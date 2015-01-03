# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'paysera/version'

Gem::Specification.new do |spec|
  spec.name          = 'paysera'
  spec.version       = Paysera::VERSION
  spec.authors       = ['Tomas Achmedovas']
  spec.email         = ['achmedovas.tomas@gmail.com']
  spec.summary       = %q{Paysera.com payment API}
  spec.description   = %q{Paysera.com payment API}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
end
