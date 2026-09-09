# frozen_string_literal: true

require_relative '../errors'

module Omarchy
  module DSL
    # Package management: add / drop Arch and AUR packages, plus queries.
    module Package
      # Install one or more Arch packages if missing.
      def add_packages(*names, aur: false)
        if aur
          run('pkg', 'aur', 'add', *names)
        else
          run('pkg', 'add', *names)
        end
        names.size == 1 ? names.first : names
      end
      alias install_packages add_packages

      # Remove one or more packages if they are installed.
      def drop_packages(*names)
        run('pkg', 'drop', *names)
        names.size == 1 ? names.first : names
      end
      alias remove_packages drop_packages
    end
  end
end
