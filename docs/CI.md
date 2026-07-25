# GitHub Actions

[GitHub Actions](https://github.com/features/actions) is used for continuous integration. The workflow is defined in
[`.github/workflows/ci.yml`](../.github/workflows/ci.yml) and runs on every push to `master` and on pull requests.

It has four jobs:

- `rspec` — `bundle exec rspec spec`
- `rubocop` — `bundle exec rubocop`
- `yard-lint` — `bundle exec yard-lint`
- `appraisal` — `bundle exec appraisal install` then `bundle exec appraisal rspec`, running the suite against every
  Rails version defined in `Appraisals`

To run a job locally, use the same commands as above (see the README for `bundle install` setup) or install
[`act`](https://github.com/nektos/act) to run the workflow itself:

```bash
$ act -j rspec
```
