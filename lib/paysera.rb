require 'paysera/version'
require 'paysera/attributes'
require 'paysera/request'
require 'paysera/helper'

module Paysera
  API_VERSION = '1.6'

  class << self
    attr_accessor :project_id, :sign_password

    def config
      yield self
    end
  end
end
