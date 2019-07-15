# frozen_string_literal: true

require 'addressable'
require 'eac_ruby_utils/envs/base_env'
require 'net/ssh'
require 'shellwords'

module EacRubyUtils
  module Envs
    class SshEnv < ::EacRubyUtils::Envs::BaseEnv
      class << self
        def parse_uri(uri)
          r = parse_user_hostname(uri) || ::Addressable::URI.parse(uri)
          return r if r.scheme == 'ssh'

          raise "URI has no SSH scheme: #{uri}"
        end

        private

        def parse_user_hostname(user_hostname)
          m = /\A([^@]+)@([^@]+)\z/.match(user_hostname)
          m ? ::Addressable::URI.new(scheme: 'ssh', host: m[2], user: m[1]) : nil
        rescue Addressable::URI::InvalidURIError
          nil
        end
      end

      def initialize(uri)
        @uri = self.class.parse_uri(uri)
      end

      def to_s
        uri.to_s
      end

      def command_line(line)
        "#{ssh_command_line} #{Shellwords.escape(line)}"
      end

      private

      attr_reader :uri

      def ssh_command_line
        r = %w[ssh]
        r += ['-p', uri.port] if uri.port.present?
        r += ssh_command_line_options
        r << "#{uri.user}@#{uri.host}"
        r.map { |a| Shellwords.escape(a) }.join(' ')
      end

      def ssh_command_line_options
        r = []
        uri.query_values&.each { |k, v| r += ['-o', "#{k}=#{v}"] }
        r
      end
    end
  end
end
