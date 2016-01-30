# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bunto/version'

Gem::Specification.new do |spec|
  spec.name          = 'bunto-docs'
  spec.version       = Bunto::VERSION
  spec.authors       = ['Parker Moore']
  spec.email         = ['SuriyaaKudoIsc@users.noreply.github.com']
  spec.summary       = %q{Offline usage documentation for Bunto.}
  spec.homepage      = 'https://bit.ly/BuntoBETA'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").grep(%r{^site/})
  spec.require_paths = ['lib']

  spec.add_dependency 'bunto', Bunto::VERSION

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
end
