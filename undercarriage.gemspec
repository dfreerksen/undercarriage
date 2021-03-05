# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

require 'undercarriage/version'

Gem::Specification.new do |spec|
  spec.name        = 'undercarriage'
  spec.version     = Undercarriage::VERSION
  spec.authors     = ['David Freerksen']
  spec.email       = ['dfreerksen@gmail.com']
  spec.homepage    = 'https://github.com/dfreerksen/undercarriage'
  spec.summary     = 'Base resources to remove some of the fat.'
  spec.description = 'Base resources to remove some of the fat.'
  spec.license     = 'MIT'

  spec.required_ruby_version = '>= 2.5.0'

  spec.files = Dir['lib/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  spec.add_dependency 'rails', '>= 6.0.3'

  spec.add_development_dependency 'sqlite3'
end
