# Omarchy

[![CI](https://github.com/azzenabidi/OmaGem/actions/workflows/ci.yml/badge.svg)](https://github.com/azzenabidi/OmaGem/actions/workflows/ci.yml)
[![Gem Version](https://img.shields.io/gem/v/omagem)](https://rubygems.org/gems/omagem)
[![License: MIT](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

A small Ruby DSL for configuring and managing [Omarchy](https://omarchy.org/)
Linux systems: themes, backgrounds, packages, services, the shell bar,
plugins, toggles, snapshots, and system operations. It wraps the single
`omarchy` CLI, so it stays in sync with the real command surface.

Designed to be used both in scripts and inside a Rails application.

## Requirements

- Ruby 3.0+
- An [Omarchy](https://omarchy.org/) system with the `omarchy` CLI on your `PATH`

## Installation

Add this line to your application's Gemfile:

```ruby
gem "omagem"
```

Or install directly from the repository:

```ruby
gem "omarchy", github: "azzenabidi/OmaGem", branch: "main"
```

And then execute:

```bash
bundle install
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

## DSL reference

### Themes & backgrounds

```ruby
theme "catppuccin"              # apply a theme ("Tokyo Night" or "tokyo-night" both work)
themes                          # list available themes
install_theme "https://...git"  # install from a git repo
remove_theme "my-theme"         # remove a user-installed theme
refresh_theme                   # re-apply current theme from templates
update_themes                   # update installed git themes

background "/path/to/image.png" # set the desktop background
background_next                 # cycle to next background
background_switcher             # open the background switcher
```

### Packages

```ruby
add_packages "docker", "git"      # install Arch packages if missing
add_packages "yay-bin", aur: true # install from the AUR
drop_packages "vim"               # remove packages if installed

package_present?("docker")          # true unless ALL listed are installed
package_installed?("docker", "git") # true when ALL listed are installed
```

### Services, apps, tools

```ruby
install_service "tailscale"     # 1password, dropbox, nordvpn, once, signal, spotify, sunshine, tailscale
remove_service "tailscale"

install_browser "firefox"       # chrome, brave, brave-origin, edge, firefox, zen
install_editor "helix"          # emacs, helix, vscode, zed
install_terminal "kitty"        # alacritty, foot, ghostty, kitty
install_dev_env "ruby"          # ruby, node, bun, deno, go, laravel, symfony, php, python, elixir, phoenix, rust, java, zig, ocaml, dotnet, clojure, scala
install_game "steam"            # steam, heroic, lutris, retroarch, battlenet, geforce-now, xbox-cloud, xbox-controllers, gpu-lib32
install_app "ChatGPT", "openai-chatgpt"
```

### System

```ruby
update(yes: true)        # full system + Omarchy update (-y skips prompts)
version                  # installed version
lock                     # lock screen
reboot / shutdown / logout

channel "stable"         # stable, rc, edge, dev
default_terminal "kitty" # alacritty, foot, ghostty, kitty
default_browser "zen"    # chromium, chrome, brave, brave-origin, edge, firefox, zen
default_editor "nvim"    # code, cursor, zed, sublime_text, helix, vim, emacs, nvim

font "JetBrainsMono Nerd Font"
current_font

create_snapshot / restore_snapshot
debug
```

### Bar, plugins, toggles

```ruby
bar "local.neon-bar"              # switch bar layout
bar_position "top"                # top, bottom, left, right
bar_transparent true              # true, false, :toggle
bar_set "omarchy.clock", "format", "HH:mm"
bar_move "omarchy.clock", ["--section", "center", "--index", "0"]

add_plugin "https://...git", enable: true
clone_plugin "omarchy.workspaces"
enable_plugin "omarchy.clock"
disable_plugin "omarchy.clock"
remove_plugin "omarchy.clock"
list_plugins(json: false)

nightlight :on               # :on, :off, :toggle
touchpad :off
touchscreen :on
idle :toggle
bar_visible :toggle
notification_silencing       # do-not-disturb
```

### Misc

```ruby
screenshot
screenrecord(fullscreen: true, desktop_audio: true, webcam: false)
stop_screenrecord
reminder 15, "Pick up Jack"
focus_app "org.mozilla.firefox"
```

## From a Rails app

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
bundle exec rubocop
```

## License

MIT