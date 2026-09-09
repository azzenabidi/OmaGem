# Omarchy

A small Ruby DSL for configuring and managing [Omarchy](https://omarchy.org/)
Linux systems: themes, backgrounds, packages, services, the shell bar,
plugins, toggles, snapshots, and system operations. It wraps the single
`omarchy` CLI, so it stays in sync with the real command surface.

Designed to be used both in scripts and inside a Rails application.

## Installation

```ruby
gem "omarchy"
```

## Usage

```ruby
require "omarchy"

Omarchy.run do
  theme "catppuccin"
  background "/home/me/Pictures/forest.png"

  add_packages "docker", "git"
  add_packages "yay-bin", aur: true

  install_service "tailscale"
  install_dev_env "ruby"
  install_browser "firefox"

  nightlight :on
  touchpad :on

  bar_set "omarchy.clock", "format", "HH:mm"
  clone_plugin "omarchy.workspaces"

  update(yes: false)
end
```

Every method is documented on `Omarchy::Config`. The block is evaluated
against a fresh `Config`, so you can call any DSL method directly:

```ruby
config = Omarchy.run do
  theme "catppuccin"
  add_packages "git"
end

config.executed            # => [["theme", "set", "catppuccin"], ["pkg", "add", "git"]]
config.client.run("theme", "current").stdout  # raw command passthrough
```

### Query methods

```ruby
Omarchy.run do
  current_theme                       # "catppuccin"
  themes                              # ["catppuccin", "tokyo-night", ...]
  package_present?("docker")          # true/false
  package_installed?("docker", "git") # true/false
end
```

### From a Rails app

Because `Omarchy.run` returns the `Config` (and records every executed
command), you can invoke it from a controller, job, or service and inspect
the results:

```ruby
result = Omarchy.run { theme params[:theme] }
flash[:notice] = result.current_theme
```

### Reusable, non-destructive configuration

Pass a fake (recording) client to build a config without touching the system:

```ruby
config = Omarchy::Config.new(client: Omarchy::Client::Fake.new)
config.theme "catppuccin"
config.executed # => [["theme", "set", "catppuccin"]]
```

## Errors

- `Omarchy::CommandFailed` — a command exited non-zero (set `ignore_errors: true` in `Omarchy.run` to raise nothing and keep going).
- `Omarchy::CommandNotFound` — the `omarchy` binary isn't on `PATH` (`ensure_command!`).
- `Omarchy::ArgumentError` — an invalid enum value (e.g. an unknown terminal).

## Development

```bash
bundle install
bundle exec rake test
```

## License

MIT
