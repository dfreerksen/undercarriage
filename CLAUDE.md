# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Undercarriage is a Ruby gem: a set of `ActiveSupport::Concern` modules that get mixed into Rails controllers and models to remove boilerplate from RESTful controller actions. There is no app to run — the gem's behavior is exercised entirely through a dummy Rails app under `test/dummy` and RSpec request/model specs (in `spec/`) that hit it via `ActionDispatch::Integration` (no Capybara/browser driving, no FactoryBot, no DatabaseCleaner — plain RSpec + Rails, transactional fixtures via `config.use_transactional_fixtures`).

## Common commands

```
$ bundle install                  # install dependencies
$ bundle exec rspec               # run the full test suite
$ bundle exec rspec spec/requests/posts_spec.rb   # run a single spec file
$ bundle exec rspec spec/requests/posts_spec.rb:10   # run a single example by line
$ bundle exec rubocop             # lint (uses .rubocop.yml)
$ bundle exec yard                # build documentation into doc/
$ bundle exec yard stats --list-undoc   # list undocumented public API
$ bundle exec yard-lint            # lint YARD doc comments (uses .yard-lint.yml, strict mode)
```

Tests require a working Rails environment for `test/dummy` — `bundle install` sets this up. `RAILS_ENV` is forced to `test` in `spec/rails_helper.rb`; SQLite is used for the test DB (`test/dummy/db/test.sqlite3`).

[yard-lint](https://github.com/mensfeld/yard-lint) checks the YARD doc comments themselves (tag order, `@param`/`@return` presence, doc coverage, etc.), separate from `yard`'s own doc generation. `.yard-lint.yml` is configured in strict mode — every validator is `Severity: error` and `MinCoverage` is 100% — so new public methods need full YARD docs (matching the extensive doc-comment style already used throughout `lib/`) to pass.

### Appraisal (multi Rails-version testing)

The gem supports Rails >= 6.0. [Appraisal2](https://github.com/appraisal-rb/appraisal2) (the `appraisal2` gem, a maintained fork of the original `appraisal`, still exposing the `appraisal` executable) verifies it against multiple Rails versions defined in `Appraisals` (currently rails-8-1, rails-8-0, rails-7-2, rails-7-1, rails-7-0, rails-6-1, rails-6-0). Note `rspec-rails` needs an explicit `~> 7.1.1` override on the rails-7-1 and rails-7-0 appraisals — `rspec-rails >= 8.0` requires `railties >= 7.2`, which conflicts with Rails 7.0/7.1. activerecord's `sqlite3_adapter.rb` hardcodes `gem "sqlite3", "~> 1.4"` on every Rails version below 7.1, so rails-7-0/rails-6-1/rails-6-0 each pin `sqlite3` to match.

```
$ bundle exec appraisal generate  # regenerate gemfiles/*.gemfile from Appraisals — required after editing Appraisals
$ bundle exec appraisal install   # bundle install against the existing gemfiles/*.gemfile (does NOT regenerate them)
$ bundle exec appraisal rspec     # run tests across all appraised Rails versions
```

`install` only runs `bundle check`/`bundle install` against whatever is already in `gemfiles/*.gemfile` — editing `Appraisals` and running `install` silently reuses the stale generated gemfiles. Run `generate` (or `generate-install` to do both) after changing `Appraisals`.

**Gotcha (learned the hard way):** Ruby >= 3.4 demoted `logger`, `bigdecimal`, `mutex_m`, and `drb` from default gems to bundled gems, so they're no longer auto-loaded. Rails 6.0/6.1 assume they're already available and never require them explicitly (Rails 7+ does), so running `bundle exec appraisal rails-6-0 rspec` or `rails-6-1` on Ruby 3.4 fails at boot with `NameError`/`LoadError` unless the rails-6-0/rails-6-1 `Appraisals` blocks declare `bigdecimal`/`mutex_m`(/`drb` for 6.0) as explicit gem dependencies, and `test/dummy/config/boot.rb` explicitly `require`s `logger`/`bigdecimal` before `require "rails"` runs. Relatedly, `test/dummy/config/application.rb`'s `config.load_defaults` is computed from the running `Rails::VERSION` rather than hardcoded, since a fixed value (e.g. `7.0`) is rejected by Rails 6.0/6.1 as an unknown version. If a future Ruby drops another default gem (`benchmark` already warns as deprecated on activesupport 6.1 under Ruby 3.4), expect the same failure pattern and the same fix shape.

CI (GitHub Actions, see `.github/workflows/ci.yml`) runs four jobs on every push to `master` and on pull requests: `rspec` (`bundle exec rspec spec`), `rubocop`, `yard-lint`, and `appraisal` (`bundle exec appraisal install` then `bundle exec appraisal rspec`, across every Rails version in `Appraisals`). See `docs/CI.md`.

## Architecture

### Module structure mirrors `include` structure

`lib/undercarriage.rb` requires every file; each concern is required individually and namespaced under `Undercarriage::Controllers::*` or `Undercarriage::Models::*`. The umbrella concern is `Undercarriage::Controllers::RestfulConcern` (`lib/undercarriage/controllers/restful_concern.rb`), which — when included in a controller — includes all of the `Restful::*` sub-concerns:

- `Restful::FlashConcern` — i18n-driven flash messages
- `Restful::LocationAfterConcern` — redirect targets after create/update/destroy
- `Restful::NamespaceConcern` — infers admin/nested namespace from `controller_path`
- `Restful::PermittedAttributesConcern` — strong params plumbing
- `Restful::UtilityConcern` — name/model derivation from `controller_name`
- `Restful::Actions::{Base,Index,Show,New,Create,Edit,Update,Destroy}Concern` — one module per REST action

Standalone concerns not pulled in by `RestfulConcern` (must be included separately):
- `Undercarriage::Controllers::ActionConcern` — `action?`/`index_action?`/`member_action?`/etc. helper predicates, exposed to views via `helper_method`
- `Undercarriage::Controllers::KaminariConcern` — `page_num`/`per_page` param parsing for Kaminari (Kaminari itself is not a gem dependency — the consuming app must add it)
- `Undercarriage::Controllers::LocaleConcern` — sets `I18n.locale` from `HTTP_ACCEPT_LANGUAGE` via an `around_action`, exposes `html_lang`/`html_dir` view helpers
- `Undercarriage::Models::PublishedConcern` — `published`/`unpublished` scopes and `published?`/`unpublished?` based on a configurable `published_at`-style column

### Convention-over-configuration via `controller_name`

Everything is driven off Rails' `controller_name`/`controller_path`. `UtilityConcern` derives `model_name`, `model_class`, `instance_name` (singular, e.g. `post`), and `instances_name` (plural, e.g. `posts`) from the controller name. Action concerns then use these to set instance variables dynamically, e.g. `IndexConcern#resources_content` does `instance_variable_set("@#{instances_name}", ...)` so a `PostsController` automatically gets `@posts`.

### Override hooks, not the actions themselves

Each action concern defines a public action method (e.g. `create`) plus protected/private "content" methods meant to be overridden by the including controller, rather than expecting the whole action to be redefined:

- `resources_content` (index), `resource_content` (show/edit/update/destroy), `create_resource_content`, `new_resource_content` — override to change the underlying query/build (e.g. to add Pundit `authorize`)
- `index_content`, `new_content`, `create_content`, `show_content`, `edit_content`, `update_content`, `destroy_content` — finer-grained per-action hooks that the `*_resource_content` methods above delegate to (e.g. `show_content`/`edit_content`/`update_content`/`destroy_content` all delegate to `resource_content` by default). Override one of these instead of the shared method above to change a single action's query without affecting its siblings
- `nested_resource_pre_build` / `nested_resource_build` — hooks for building nested associations (called at different points for new/create vs edit/update — see comments in `base_concern.rb`)
- `after_create_action` / `after_update_action` — post-persistence callbacks
- `permitted_attributes` (or the action-specific `permitted_create_attributes`/`permitted_update_attributes`) — strong params

This override pattern (documented via extensive inline usage comments in each concern file) is the primary way consumers customize behavior — read the doc comments at the top of a concern before adding new hooks to it.

### Flash and locale lookups follow a fallback chain

`FlashConcern#flash_message_defaults` builds an ordered list of i18n keys from most-specific to least (namespace+controller+action+status → controller+action+status → generic `flash.actions.*` → hardcoded English string) and passes them all as `I18n.t(..., default: [...])`. `LocaleConcern` similarly intersects the parsed `HTTP_ACCEPT_LANGUAGE` header against `I18n.available_locales`, falling back to `I18n.default_locale`. When touching either, preserve the fallback-chain shape rather than short-circuiting it.

### Testing model

Two tiers, depending on how tightly a concern's logic is coupled to the request/response cycle:

- **`spec/lib/undercarriage/**`** — isolated unit specs, one file per concern, mirroring `lib/`'s own path structure. Each `include`s the concern into a bare `Class.new` and stubs only the specific methods that concern actually calls (`action_name`, `params`, `controller_name`, `helper_method`/`before_action` as no-ops that record calls, etc.) — no Rails routing, no HTTP, no `test/dummy` controller involved. Used for concerns whose logic is self-contained enough to test this way: `ActionConcern`, `LocaleConcern`, `KaminariConcern`, `RestfulConcern` (the wiring itself — see below), `FlashConcern`, `LocationAfterConcern` (via `Rails.application.routes.url_helpers` mixed in, so real route helpers resolve without a controller), `NamespaceConcern`, `PermittedAttributesConcern`, `UtilityConcern`, and `Restful::Actions::BaseConcern`.
- **`spec/requests/**`/`spec/models/**`** — `test/dummy` is a minimal real Rails app that includes the concerns, and these specs (`type: :request`/`type: :model`) hit real routes via Rails' integration test helpers (`get`/`post`/`patch`/`delete`) and assert on `response.body`/`response.status`/`flash`. Used for the 7 `Restful::Actions::*Concern`s (`Index`/`Show`/`New`/`Create`/`Edit`/`Update`/`Destroy`), which are too deeply tied to real `respond_to`/`format`/`render`/`redirect_to`/`flash` behavior to fake convincingly in isolation. There's no layout and no asset pipeline — views are minimal ERB files that print the relevant instance variables and `ActionConcern` predicates as plain text specifically so specs can assert on `response.body` without a browser.

When a concern genuinely can't be isolated (route helpers, full CRUD respond_to blocks), prefer extending `test/dummy` over writing a request spec against the concern's methods directly — see the dummy-app bullets below.

**Gotcha (learned the hard way):** if a spec calls `I18n.backend.store_translations` (or otherwise mutates *global* state — I18n, `class_attribute` defaults, etc.) to test one tier of a fallback chain, that state persists for the rest of the process and can silently leak into other examples depending on random run order. `spec/lib/undercarriage/controllers/restful/flash_concern_spec.rb` hit exactly this (a "generic tier" translation leaking into a "no translation at all" example) and fixed it with `after { I18n.backend.reload! }`. Reach for this whenever a spec stores translations or otherwise mutates shared state rather than trusting per-example `let`/`before` scoping alone.

`test/dummy`'s app is intentionally small and reused across concerns rather than one dummy controller per concern:

- `Post` (`app/models/post.rb`) — `include`s `Undercarriage::Models::PublishedConcern`, validates `title` presence (so create/update failure paths are exercisable)
- `PostsController` (`app/controllers/posts_controller.rb`) — full `RestfulConcern` CRUD + `KaminariConcern` (pagination) + `ActionConcern` (predicates printed in the views); the primary target for CRUD/flash/permitted-params/pagination coverage (`spec/requests/posts_spec.rb`)
- `Admin::PostsController` (`app/controllers/admin/posts_controller.rb`) — an empty subclass of `PostsController` (`controller_path` of `admin/posts`), which exercises `NamespaceConcern`'s namespace inference and the namespaced tier of `FlashConcern`'s i18n fallback chain (`spec/requests/admin/posts_spec.rb`). Rails' view-lookup prefix inheritance means it reuses `PostsController`'s views without duplicating them; it also relies on inheriting `permitted_attributes` from `PostsController` rather than redefining it, which doubles as a regression test for the `PermittedAttributesConcern` fix below.
- `GreetingsController` (`app/controllers/greetings_controller.rb`) — `LocaleConcern` only, renders `lang=<html_lang> dir=<html_dir>` as plain text (`spec/requests/greetings_spec.rb`)
- `HooksController` (`app/controllers/hooks_controller.rb`) — subclasses `PostsController` solely to override `nested_resource_pre_build`/`nested_resource_build`/`after_create_action`/`after_update_action` and record call order, regression-testing the hook-timing contract documented in `base_concern.rb` (`spec/requests/hooks_spec.rb`). Because its own `controller_name` is `"hooks"` (unlike the `Admin::` namespace, a genuinely different controller class name changes `controller_name`), it has to explicitly override `model_name`/`instances_name` to reuse `Post` and `PostsController`'s views instead of looking for a nonexistent `Hook` model.

`test/dummy/config/locales/en.yml` defines `flash.admin.posts.create.success` (but no non-namespaced equivalent), so the admin-vs-top-level create specs demonstrate the fallback chain actually preferring the namespaced key when present and falling through to the generic English default when it isn't. `ar.yml` exists solely to register a second available locale for `LocaleConcern`'s RTL detection.

When adding or changing controller/model *behavior* (a new action, a new response format, a new redirect), extend this dummy app (new model/controller/route in `test/dummy/`) and a matching request/model spec. When adding or changing a concern's own self-contained *logic* (a new predicate, a new parsing rule), prefer an isolated `spec/lib/` unit spec unless it genuinely needs real routing/`respond_to` to observe.

## Versioning and releases

Version lives in `lib/undercarriage/version.rb`. Release steps (semantic versioning) are documented in `docs/Release.md`: bump version, update `README.md`'s pinned version string if it's a major/minor bump, `bundle exec rake build`, commit as "Bump to X.Y.Z", `bundle exec rake release`.
