require 'openssl'
require 'open-uri'
require 'cgi'
require 'digest/md5'
require 'base64'

class Paysera::Response
  PAYSERA_PUBLIC_KEY = 'https://www.webtopay.com/download/public.key'

  def self.check_response(query, project_id=nil, sign_password=nil)
    raise exception("'ss1' parameter was not found") if query[:ss1].nil?
    raise exception("'ss2' parameter was not found") if query[:ss2].nil?
    raise exception("'data' parameter was not found") if query[:data].nil?
    raise exception("unable to verify 'ss2'") unless valid_ss2? query
    raise exception("unable to verify 'ss1'") unless valid_ss1? query,
                                                                sign_password || Paysera.sign_password

    data       = convert_to_hash decode_string(query[:data])
    project_id ||= Paysera.project_id

    raise exception("'projectid' mismatch") if data[:projectid].to_i != project_id

    data
  end

  private

  def self.convert_to_hash(query)
    Hash[query.split('&').collect do |s|
           a = s.split('=')
           [unescape_string(a[0]).to_sym, unescape_string(a[1])]
         end]
  end

  def self.valid_ss1?(query, sign_password)
    Digest::MD5.hexdigest(query[:data] + sign_password) == query[:ss1]
  end

  def self.valid_ss2?(query)
    public_key = get_public_key
    ss2        = unescape_string decode_string(query[:ss2])
    data       = unescape_string query[:data]

    public_key.verify(OpenSSL::Digest::SHA1.new, ss2, data)
  end

  def self.get_public_key
    OpenSSL::X509::Certificate.new(open(PAYSERA_PUBLIC_KEY).read).public_key
  end

  def self.decode_string(string)
    Base64.decode64 string.gsub('-', '+').gsub('_', '/')
  end

  def self.unescape_string(string)
    CGI.unescape string.to_s
  end

  def self.exception(msg)
    Exception.new msg
  end
end
