# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails_readonly_injector/version'

Gem::Specification.new do |spec|
  spec.name          = 'rails_readonly_injector'
  spec.version       = RailsReadonlyInjector::VERSION
  spec.authors       = ['Andrew Walter']
  spec.email         = ['andrew.walter@burnet.edu.au']

  spec.summary       = "Globally toggle 'read-only' mode in a Rails application, on-demand, without having to restart the server."
  spec.homepage      = 'https://www.github.com/xtrasimplicity/rails_readonly_injector'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.1.3'

  spec.add_runtime_dependency 'rails', ['>= 3.0', '< 5.3']

  spec.add_development_dependency 'appraisal', '~> 2.2'
  spec.add_development_dependency 'bundler', '>= 1.16'
  spec.add_development_dependency 'rake', '>= 12.3.3'
  spec.add_development_dependency 'yard', '~> 0.9.12'
end
