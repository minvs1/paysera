require 'cgi'

class Paysera::Helper
  def self.make_query(data)
    data.collect do |key, value|
      "#{CGI.escape(key.to_s)}=#{CGI.escape(value.to_s)}"
    end.compact.sort! * '&'
  end
end