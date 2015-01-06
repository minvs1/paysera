require 'paysera/version'
require 'paysera/attributes'
require 'paysera/error'
require 'paysera/request'
require 'paysera/response'

module Paysera
  API_VERSION = '1.6'

  class << self
    attr_accessor :projectid, :sign_password

    def config
      yield self
    end
  end
end
