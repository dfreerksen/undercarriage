# Undercarriage

**\*Undercarriage is currently under development. It is not ready for production use.\***

[![CircleCI](https://circleci.com/gh/dfreerksen/undercarriage.svg?style=shield)](https://circleci.com/gh/dfreerksen/undercarriage)
[![Maintainability](https://api.codeclimate.com/v1/badges/d15980a534f8db936469/maintainability)](https://codeclimate.com/github/dfreerksen/undercarriage/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/d15980a534f8db936469/test_coverage)](https://codeclimate.com/github/dfreerksen/undercarriage/test_coverage)

Undercarriage is a set of concerns to add to your application to trim some of the fat from controllers and models.

## Requirements

* Ruby >= 2.6
* Rails >= 6.0

## Installation

Add to your application's Gemfile

```
gem 'undercarriage', '~> 0.5'
```

Run the bundle command

```
$ bundle install
```

## Usage

TODO

## TODO

* [ ] Allow a way to set locale instead of relying on browser preferred language in `Undercarriage::Controllers::LocaleConcern`

## Testing

Run tests with one of the following

```
$ bundle exec rspec
$ bundle exec rspec spec
```

### Appraisal

Undercarriage uses [Appraisal](https://github.com/thoughtbot/appraisal) to ensure various dependency versions work as expected

When dependencies change, run

```
$ bundle exec appraisal install
```

To run tests with Appraisal, run

```
$ bundle exec appraisal rspec
```

To run tests with a specific version of Appraisal, run

```
$ bundle exec appraisal rails-60 rspec
$ bundle exec appraisal rails-61 rspec
```

## Code Analysis

Various tools are used to ensure code is linted and formatted correctly.

### RuboCop

[RuboCop](https://github.com/bbatsov/rubocop) is a Ruby static code analyzer.

```
$ rubocop
```

## Documentation

[Yard](https://github.com/lsegal/yard) is used to generate documentation. [Online documentation is available](http://www.rubydoc.info/github/dfreerksen/undercarriage/master)

Build the documentation with one of the following

```
$ yard
$ yard doc
```

Build the documentation and list all undocumented objects

```
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
