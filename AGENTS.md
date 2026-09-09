# AGENTS.md

Guidance for AI coding agents working in this repository.

## Project overview

OmaGem is a small Ruby gem that provides a DSL for configuring and managing
[Omarchy](https://omarchy.org/) Linux systems. It does **not** reimplement
anything — every operation shells out to the `omarchy` CLI binary, so the gem
stays in sync with the real command surface and never touches
`/usr/share/omarchy/` directly.

Intended to be used from scripts and Rails applications.

## Naming — read this first (easy to get wrong)

There are three distinct "omarchy" meanings. Do not conflate them:

| String | Meaning | Rule |
|--------|---------|------|
| `OmaGem` | The Ruby module / project name | Rename freely if the project is renamed |
| `omagem` | The published gem name (lowercase) | Keep in gemspec `name`, `gem push`, image badges |
| `omarchy` | The Linux system / CLI binary / command invocations | **Never rename** — keep as literal strings |
| `omarchy.clock` etc. | Shell plugin/widget IDs | **Never rename** — they're real plugin IDs |

Examples of correct usage:
- Module: `module OmaGem`, `OmaGem.run`, `OmaGem::Config`.
- CLI: `run('theme', 'set', name)` and `Client.new(command: 'omarchy')`.
- System: "A DSL for managing Omarchy Linux systems" in prose/docs.
- Plugins: `bar_set 'omarchy.clock', 'format', 'HH:mm'`.

Do **not** blanket-search-and-replace `omarchy` → `omagem`. Target only the Ruby
API layers when renaming.

## Stack & tooling

- Ruby 3.0+ (CI matrix 3.0–3.4).
- Bundler for dependencies; Minitest for tests; Rake as the task runner;
  RuboCop for linting.
- No runtime dependencies — stdlib only (`open3`).

## Commands

```bash
bundle install
bundle exec rake test          # run the test suite
bundle exec rubocop            # lint (must be clean before committing)
bundle exec rubocop -A         # autofix safe + unsafe offenses
gem build OmaGem.gemspec       # build the gem locally
```

Always run tests and RuboCop before finishing a change.

## Repository layout

```
lib/omagem.rb                  # entry point; OmaGem.run { ... } DSL entry
lib/omagem/
  version.rb                   # OmaGem::VERSION — bump for releases
  errors.rb                    # Error, CommandFailed, CommandNotFound, ArgumentError
  client.rb                    # shells out to the `omarchy` binary (Open3)
  config.rb                    # Config — the DSL base; runs commands, mixes in modules
  dsl/                         # one module per feature area:
    theme.rb                   #   Theme
    package.rb                 #   Package
    service.rb                 #   Service (apps, browsers, editors, dev envs, gaming)
    system.rb                  #   System (update, defaults, font, channel, power)
    bar.rb                     #   Bar (layout, position, widget placement)
    plugin.rb                  #   Plugin (clone/enable/disable/list)
    toggle.rb                  #   Toggle (nightlight, touchpad, idle, ...)
    snapshot.rb                #   Snapshot (create/restore)
    misc.rb                    #   Misc (screenshot, screenrecord, reminder, focus)
test/
  test_helper.rb               # FakeClient + OmaGemTestHelpers#dsl
  omagem_test.rb               # Minitest coverage for the DSL
.github/workflows/
  ci.yml                       # tests (matrix) + lint + gem build on push/PR
  release.yml                  # tag v* → test, gem push, GitHub release
OmaGem.gemspec                 # gem metadata; name must stay "omagem"
```

## How the DSL works

`OmaGem.run { ... }` evaluates the block against `OmaGem::Config`.
Every feature module (`lib/omagem/dsl/*.rb`) is `include`d into `Config` in
`lib/omagem/config.rb`. Each DSL method ultimately calls `run(*args)` (or
`client.run` for queries), which executes `omarchy <args...>` and returns a
`Client::Result`.

### Adding a DSL method

1. Pick the right feature module in `lib/omagem/dsl/`, or create a new one.
2. Implement the method, delegating shell execution to `run(*args)`:

   ```ruby
   def nightlight(state = :toggle)
     run('toggle', 'nightlight', state.to_s)
   end
   ```

3. For enum-style arguments, validate with `validate_in!` (defined on Config):

   ```ruby
   validate_in!(name, %w[alacritty foot ghostty kitty], 'terminal')
   ```

4. If you created a new module, `require_relative` it and `include` it into
   `Config` at the bottom of `lib/omagem/config.rb`.
5. Add Minitest coverage in `test/omagem_test.rb` asserting the exact command
   args recorded in `config.executed`.

### Query methods vs actions

- Actions that mutate state should call `run(...)` and return the result.
- Read-only queries (e.g. `themes`, `current_theme`, `package_present?`) call
  `client.run(...)` directly so a failed status does not raise.

## Testing conventions

- Use the recording fake client — never shell out in tests:

  ```ruby
  c = dsl { add_packages 'docker', 'git' }
  assert_equal %w[pkg add docker git], c.executed.first
  ```

- Test both the happy path (exact args) and validation failures
  (`assert_raises(OmaGem::ArgumentError)`) for enum args.
- The fake client is in `test/test_helper.rb`; it records every `run` call.

## Code style

- RuboCop-clean is mandatory. `bundle exec rubocop -A` then verify.
- Single-quoted strings when no interpolation is needed (RuboCop enforces this).
- `# frozen_string_literal: true` at the top of every Ruby file.
- Comments explain *why*, not *what*, and only where non-obvious.
- Keep commits small, focused, and conventional:
  `Add ...`, `Fix ...`, `Refactor ...`, `Bump version to X.Y.Z`.

## Releases

1. Bump `OmaGem::VERSION` in `lib/omagem/version.rb` (SemVer).
2. Push to `main`, then tag:

   ```bash
   git tag v<version>
   git push origin v<version>
   ```

3. The `release.yml` workflow runs tests, `gem build OmaGem.gemspec`,
   `gem push omagem-*.gem`, and creates a GitHub release.
4. Keep workflow filenames in sync: the build step references `OmaGem.gemspec`,
   the push step globs `omagem-*.gem` (the built artifact keeps the lowercased
   gem name from the gemspec).

## Security

- Never write secrets to the repo, docs, or chat. The RubyGems API key lives
  only in the GitHub Actions secret `RUBYGEMS_API_KEY`.
- Do not log or expose the API key in output or commit messages.
- The gem never reads or writes `/usr/share/omarchy/`; it only invokes the CLI.