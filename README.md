# Undercarriage

Undercarriage is a set of concerns to add to your application to trim some of the fat from controllers and models.

## Requirements

* Ruby >= 3.0
* Rails >= 6.0

## Installation

Add to your application's Gemfile

```bash
gem 'undercarriage', '~> 1.1'
```

Run the bundle command

```bash
$ bundle install
```

## Usage

Include `Undercarriage::Controllers::RestfulConcern` in a controller to get full RESTful `index`/`show`/`new`/`create`/`edit`/`update`/`destroy` actions, driven off the controller's own name/path:

```ruby
class PostsController < ApplicationController
  include Undercarriage::Controllers::RestfulConcern

  private

  def permitted_attributes
    [:title, :body]
  end
end
```

This infers `Post` as the model, sets `@posts`/`@post` as appropriate, and wires up flash messages, strong params, and redirects with no further code. Override the `*_content` hooks (e.g. `show_content`, `create_content`) or `after_create_action`/`after_update_action` to customize a single action without redefining it — see the YARD docs on each `Undercarriage::Controllers::Restful::*` concern for the full hook list.

The standalone concerns can be included individually where you don't want the full RESTful stack:

```ruby
class ExamplesController < ApplicationController
  include Undercarriage::Controllers::ActionConcern  # action?/index_action?/etc. view helpers
  include Undercarriage::Controllers::KaminariConcern # page_num/per_page params for Kaminari
  include Undercarriage::Controllers::LocaleConcern   # I18n.locale from HTTP_ACCEPT_LANGUAGE
end

class Example < ApplicationRecord
  include Undercarriage::Models::PublishedConcern # published/unpublished scopes
end
```

See the YARD documentation linked below for every concern's options and examples.

## Testing

Run tests with one of the following

```bash
$ bundle exec rspec
$ bundle exec rspec spec
```

### Appraisal

Undercarriage uses [Appraisal2](https://github.com/appraisal-rb/appraisal2) (a maintained fork of [Appraisal](https://github.com/thoughtbot/appraisal), still exposing the `appraisal` executable) to ensure various dependency versions work as expected

When dependencies change, run

```bash
$ bundle exec appraisal install
$ bundle exec appraisal generate-install
```

To run tests with Appraisal, run

```bash
$ bundle exec appraisal rspec
```

```bash
$ bundle exec appraisal rails-6-0 rspec spec
$ bundle exec appraisal rails-6-1 rspec spec
$ bundle exec appraisal rails-7-0 rspec spec
$ bundle exec appraisal rails-7-1 rspec spec
$ bundle exec appraisal rails-7-2 rspec spec
$ bundle exec appraisal rails-8-0 rspec spec
$ bundle exec appraisal rails-8-1 rspec spec
```

## Code Analysis

Various tools are used to ensure code is linted and formatted correctly.

### RuboCop

[RuboCop](https://github.com/bbatsov/rubocop) is a Ruby static code analyzer.

```bash
$ rubocop
```

### YARD-Lint

[YARD-Lint](https://github.com/mensfeld/yard-lint) is a linter for YARD documentation.

```bash
$ bundle exec yard-lint
```

## Documentation

[Yard](https://github.com/lsegal/yard) is used to generate documentation. [Online documentation is available](http://www.rubydoc.info/github/dfreerksen/undercarriage/master)

Build the documentation with one of the following

```bash
$ yard
$ yard doc
```

Build the documentation and list all undocumented objects

```bash
$ yard stats --list-undoc
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Contributing

1. Fork it ([https://github.com/dfreerksen/undercarriage/fork](https://github.com/dfreerksen/undercarriage/fork))
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
