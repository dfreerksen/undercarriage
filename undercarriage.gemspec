# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

require 'undercarriage/version'

Gem::Specification.new do |spec|
  spec.name        = 'undercarriage'
  spec.version     = Undercarriage::VERSION
  spec.authors     = ['David Freerksen']
  spec.email       = ['dfreerksen@gmail.com']
  spec.homepage    = 'https://github.com/dfreerksen/undercarriage'
  spec.summary     = 'Controller and model concerns for Ruby on Rails.'
  spec.description = 'Undercarriage is a set of concerns to add to your application to trim some of the fat from ' \
                     'controllers and models.'
  spec.license     = 'MIT'

  spec.required_ruby_version = '>= 2.5'

  spec.metadata = {
    'bug_tracker_uri' => 'https://github.com/dfreerksen/undercarriage/issues',
    'documentation_uri' => 'https://www.rubydoc.info/github/dfreerksen/undercarriage/master',
    'homepage_uri' => 'https://github.com/dfreerksen/undercarriage',
    'source_code_uri' => 'https://github.com/dfreerksen/undercarriage',
    'wiki_uri' => 'https://github.com/dfreerksen/undercarriage/wiki'
  }

  spec.files = Dir['lib/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  spec.add_dependency 'rails', '>= 6.0.3'
end
