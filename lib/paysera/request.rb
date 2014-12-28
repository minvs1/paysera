require 'base64'
require 'digest/md5'

class Paysera::Request
  def self.build_request(paysera_params)
    # Ensure that all key will be symbols
    request_params              = Hash[paysera_params.map { |k, v| [k.to_sym, v] }]

    # Set default values 
    request_params[:version]    = Paysera::API_VERSION
    request_params[:project_id] = 123123123 # TODO get project_id from rails configuration file

    encoded_query  = encode_query(validate_and_make_query(request_params))
    signed_request = sign_request(encoded_query, '34nig3uov30') # TODO get sign password from rails configuration file

    query = "data=#{encoded_query}&sign=#{signed_request}"

    query
  end

  private

  def self.sign_request(query, password)
    # Encode string + password with md5
    Digest::MD5.hexdigest(query + password)
  end

  def self.encode_query(query)
    # 1) Encode with base64
    # 2) Replace / with _ and + with -
    Base64.encode64(query).gsub('/', '_').gsub('+', '-')
  end

  def self.validate_and_make_query(req)
    request = ''

    Paysera::Attributes::REQUEST.each do |k, v|
      raise exception("'#{k}' is required but missing") if v[:required] and req[k].nil?

      req_value = req[k].to_s
      regex = v[:regex].to_s
      maxlen = v[:maxlen]

      unless req[k].nil?
        raise exception("'#{k}' value '#{req[k]}' is too long, #{v[:maxlen]} characters allowed.") if maxlen and req_value.length > maxlen
        raise exception("'#{k}' value '#{req[k]}' invalid.") if '' != regex and !req_value.match(regex)

        # Make query
        request += "&#{k}=#{req[k]}"
      end
    end

    # Delete first char - &
    request[0] = ''

    request
  end

  def self.exception(msg)
    Exception.new msg
  end
end