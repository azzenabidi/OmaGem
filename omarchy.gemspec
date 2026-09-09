# frozen_string_literal: true

require_relative 'lib/omarchy/version'

Gem::Specification.new do |spec|
  spec.name        = 'omagem'
  spec.version     = Omarchy::VERSION
  spec.authors     = ['azzen']
  spec.summary     = 'Ruby DSL to configure and manage Omarchy Linux systems'
  spec.description = 'A tiny Ruby DSL that wraps the `omarchy` CLI so you can manage ' \
                     'themes, packages, services, the shell bar, and more from Ruby ' \
                     'or a Rails application.'
  spec.license     = 'MIT'
  spec.homepage    = 'https://github.com/azzenabidi/OmaGem'
  spec.required_ruby_version = '>= 3.0'

  spec.files = Dir['lib/**/*.rb'] + %w[README.md LICENSE]
  spec.require_paths = ['lib']

  spec.metadata['rubygems_mfa_required'] = 'true'
end
