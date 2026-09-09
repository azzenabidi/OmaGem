# frozen_string_literal: true

require_relative 'test_helper'

class ThemeDslTest < Minitest::Test
  include OmaGemTestHelpers

  def test_theme_applies
    c = dsl { theme 'catppuccin' }
    assert_includes c.executed.flatten, 'catppuccin'
    assert_equal %w[theme set catppuccin], c.executed.first
  end

  def test_background
    c = dsl { background '/tmp/wall.png' }
    assert_equal %w[theme bg set /tmp/wall.png], c.executed.first
  end

  def test_install_theme
    c = dsl { install_theme 'https://example.com/repo.git' }
    assert_equal %w[theme install https://example.com/repo.git], c.executed.first
  end
end

class PackageDslTest < Minitest::Test
  include OmaGemTestHelpers

  def test_add_packages
    c = dsl { add_packages 'docker', 'git' }
    assert_equal %w[pkg add docker git], c.executed.first
  end

  def test_add_aur
    c = dsl { add_packages 'yay-bin', aur: true }
    assert_equal %w[pkg aur add yay-bin], c.executed.first
  end

  def test_drop_packages
    c = dsl { drop_packages 'vim' }
    assert_equal %w[pkg drop vim], c.executed.first
  end
end

class ServiceDslTest < Minitest::Test
  include OmaGemTestHelpers

  def test_install_service
    c = dsl { install_service 'tailscale' }
    assert_equal %w[install service tailscale], c.executed.first
  end

  def test_install_service_invalid
    assert_raises(OmaGem::ArgumentError) { dsl { install_service 'nope' } }
  end

  def test_install_browser
    c = dsl { install_browser 'firefox' }
    assert_equal %w[install browser firefox], c.executed.first
  end

  def test_install_dev_env
    c = dsl { install_dev_env 'ruby' }
    assert_equal %w[install dev-env ruby], c.executed.first
  end

  def test_install_terminal_invalid
    assert_raises(OmaGem::ArgumentError) { dsl { install_terminal 'notmap' } }
  end
end

class SystemDslTest < Minitest::Test
  include OmaGemTestHelpers

  def test_update_yes
    c = dsl { update(yes: true) }
    assert_equal %w[update -y], c.executed.first
  end

  def test_reboot_and_lock
    c = dsl { reboot }
    assert_equal %w[system reboot], c.executed.first
    c = dsl { lock }
    assert_equal %w[system lock], c.executed.first
  end

  def test_set_channel
    c = dsl { channel 'stable' }
    assert_equal %w[channel set stable], c.executed.first
  end

  def test_default_terminal
    c = dsl { default_terminal 'kitty' }
    assert_equal %w[default terminal kitty], c.executed.first
  end
end

class ToggleBarPluginDslTest < Minitest::Test
  include OmaGemTestHelpers

  def test_toggle
    c = dsl { nightlight :on }
    assert_equal %w[toggle nightlight on], c.executed.first
  end

  def test_bar_set
    c = dsl { bar_set 'omarchy.clock', 'format', 'HH:mm' }
    assert_equal %w[bar set omarchy.clock format HH:mm], c.executed.first
  end

  def test_bar_position_invalid
    assert_raises(OmaGem::ArgumentError) { dsl { bar_position 'middle' } }
  end

  def test_add_plugin
    c = dsl { add_plugin 'https://example.com/p.git', enable: true }
    assert_equal %w[plugin add https://example.com/p.git --enable --yes], c.executed.first
  end

  def test_snapshot
    c = dsl { create_snapshot }
    assert_equal %w[snapshot create], c.executed.first
  end
end
