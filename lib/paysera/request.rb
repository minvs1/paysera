require 'base64'
require 'cgi'
require 'digest/md5'

module Paysera
  class Request
    def self.build_request(paysera_params, sign_password=nil)
      # Ensure that all key will be symbols
      paysera_params             = Hash[paysera_params.map { |k, v| [k.to_sym, v] }]

      # Set default values
      paysera_params[:version]   = Paysera::API_VERSION
      paysera_params[:projectid] ||= Paysera.projectid
      sign_password              ||= Paysera.sign_password

      raise send_error("'sign_password' is required but missing") if sign_password.nil?

      valid_request = validate_request(paysera_params)
      encoded_query  = encode_string make_query(valid_request)
      signed_request = sign_request(encoded_query, sign_password)

      query = make_query({
                             :data => encoded_query,
                             :sign => signed_request
                         })


      "https://www.paysera.lt/pay/?#{query}"
    end

    private

    def self.make_query(data)
      data.collect do |key, value|
        "#{CGI.escape(key.to_s)}=#{CGI.escape(value.to_s)}"
      end.compact.sort! * '&'
    end

    def self.sign_request(query, password)
      # Encode string + password with md5
      Digest::MD5.hexdigest(query + password)
    end

    def self.encode_string(string)
      # 1) Encode with base64
      # 2) Replace / with _ and + with -
      Base64.encode64(string).gsub("\n", '').gsub('/', '_').gsub('+', '-')
    end

    def self.validate_request(req)
      request = {}

      Paysera::Attributes::REQUEST.each do |k, v|
        raise send_error("'#{k}' is required but missing") if v[:required] and req[k].nil?

        req_value = req[k].to_s
        regex     = v[:regex].to_s
        maxlen    = v[:maxlen]

        unless req[k].nil?
          raise send_error("'#{k}' value '#{req[k]}' is too long, #{v[:maxlen]} characters allowed.") if maxlen and req_value.length > maxlen
          raise send_error("'#{k}' value '#{req[k]}' invalid.") if '' != regex and !req_value.match(regex)

          # Add only existing params
          request[k] = req[k]
        end
      end

      request
    end

    def self.send_error(msg)
      Paysera::Error::Request.new msg
    end
  end
end