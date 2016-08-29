# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bunto/version'

Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new('>= 0') if s.respond_to? :required_rubygems_version=
  s.rubygems_version = '2.2.2'
  s.required_ruby_version = '>= 2.0.0'

  s.name          = 'bunto'
  s.version       = Bunto::VERSION
  s.license       = 'MIT'

  s.summary       = 'A simple, static site generator & web application framework.'
  s.description   = 'Bunto is a simple, static site generator & web application framework.'
  s.post_install_message = <<-msg
--------------------------------------------------------
Thank you for installing Bunto!

Bunto is a Web Application Framework build by Suriyaa
Kudo which can be used as a simple, static site 
generator for personal, project, or organization sites.

For more information visit:
https://github.com/bunto/bunto
--------------------------------------------------------
msg

  s.authors       = ['Suriyaa Kudo']
  s.email         = 'SuriyaaKudoIsc@users.noreply.github.com'
  s.homepage      = 'https://github.com/bunto/bunto'

  all_files       = `git ls-files -z`.split("\x0")
  s.files         = all_files.grep(%r{^(exe|lib)/|^.rubocop.yml$})
  s.executables   = all_files.grep(%r{^exe/}) { |f| File.basename(f) }
  s.bindir        = "exe"
  s.require_paths = ['lib']

  s.rdoc_options = ['--charset=UTF-8']
  s.extra_rdoc_files = %w[README.markdown LICENSE]

  s.add_runtime_dependency('liquid',    '~> 3.0')
  s.add_runtime_dependency('kramdown',  '~> 1.3')
  s.add_runtime_dependency('mercenary', '~> 0.3.3')
  s.add_runtime_dependency('safe_yaml', '~> 1.0')
  s.add_runtime_dependency('colorator', '~> 1.0')
  s.add_runtime_dependency('rouge', '~> 1.7')
  s.add_runtime_dependency('bunto-sass-converter', '~> 3.0')
  s.add_runtime_dependency('bunto-watch', '>= 1.0')
  s.add_runtime_dependency("pathutil", "~> 0.9")
end
