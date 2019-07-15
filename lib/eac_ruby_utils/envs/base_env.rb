# frozen_string_literal: true

require 'eac_ruby_utils/envs/command'

module EacRubyUtils
  module Envs
    class BaseEnv
      def command(*args)
        ::EacRubyUtils::Envs::Command.new(self, args)
      end

      def file_exist?(file)
        command(['stat', file]).execute[:exit_code].zero?
      end
    end
  end
end
