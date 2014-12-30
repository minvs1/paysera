require 'base64'
require 'cgi'
require 'digest/md5'

class Paysera::Request
  def self.build_request(paysera_params, sign_password=nil)
    # Ensure that all key will be symbols
    request_params = Hash[paysera_params.map { |k, v| [k.to_sym, v] }]

    # Set default values 
    request_params[:version]   = Paysera::API_VERSION
    request_params[:projectid] ||= Paysera.project_id
    sign_password  ||= Paysera.sign_password

    valid_request  = validate_request(request_params)
    encoded_query  = encode_string make_query(valid_request)
    signed_request = sign_request(encoded_query, sign_password)

    query = make_query({
                           :data => encoded_query,
                           :sign => signed_request
                       })


    "https://www.mokejimai.lt/pay/?#{query}"
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
      raise exception("'#{k}' is required but missing") if v[:required] and req[k].nil?

      req_value = req[k].to_s
      regex     = v[:regex].to_s
      maxlen    = v[:maxlen]

      unless req[k].nil?
        raise exception("'#{k}' value '#{req[k]}' is too long, #{v[:maxlen]} characters allowed.") if maxlen and req_value.length > maxlen
        raise exception("'#{k}' value '#{req[k]}' invalid.") if '' != regex and !req_value.match(regex)

        # Add only existing params
        request[k] = req[k]
      end
    end

    request
  end

  def self.exception(msg)
    Exception.new msg
  end
end