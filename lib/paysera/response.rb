require 'openssl'
require 'open-uri'
require 'cgi'
require 'digest/md5'
require 'base64'

module Paysera
  class Response
    PAYSERA_PUBLIC_KEY = 'http://www.paysera.com/download/public.key'

    def initialize(query, projectid: nil, sign_password: nil)
      raise send_error("'data' parameter was not found") if query[:data].nil?
      raise send_error("'ss1' parameter was not found") if query[:ss1].nil?
      raise send_error("'ss2' parameter was not found") if query[:ss2].nil?

      projectid ||= Paysera.projectid
      raise send_error("'projectid' parameter was not found") if projectid.nil?

      sign_password ||= Paysera.sign_password
      raise send_error("'sign_password' parameter was not found") if sign_password.nil?

      raise send_error("Unable to verify 'ss1'") unless valid_ss1? query[:data], query[:ss1], sign_password
      raise send_error("Unable to verify 'ss2'") unless valid_ss2? query[:data], query[:ss2]

      @data = convert_to_hash safely_decode_string(query[:data])

      raise send_error("'projectid' mismatch") if @data[:projectid].to_i != projectid.to_i
    end

    def sms?
      # Basically if response data have sms param then it is sms payment
      @data.key? :sms
    end

    def bank?
      # Same here, if response have paytext param, then it is bank payment
      @data.key? :paytext
    end

    def get_data
      @data
    end

    private

    def convert_to_hash(query)
      Hash[query.split('&').collect do |s|
             a = s.split('=')
             [unescape_string(a[0]).to_sym, unescape_string(a[1])]
           end]
    end

    def valid_ss1?(data, ss1, sign_password)
      Digest::MD5.hexdigest(CGI.unescape(data) + sign_password) == ss1
    end

    def valid_ss2?(data, ss2)
      public_key = get_public_key
      ss2        = safely_decode_string(unescape_string(ss2))
      data       = unescape_string data

      public_key.verify(OpenSSL::Digest::SHA1.new, ss2, data)
    end

    def get_public_key
      OpenSSL::X509::Certificate.new(open(PAYSERA_PUBLIC_KEY).read).public_key
    end

    def safely_decode_string(string)
      Base64.decode64 string.gsub('-', '+').gsub('_', '/').gsub("\n", '')
    end

    def unescape_string(string)
      CGI.unescape string.to_s
    end

    def send_error(msg)
      Paysera::Error::Response.new msg
    end
  end
end
