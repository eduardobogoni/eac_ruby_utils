# frozen_string_literal: true

module EacRubyUtils
  module Console
    class DocoptRunner
      DOCOPT_ERROR_EXIT_CODE = 0x22220000

      class << self
        def run(options = {})
          new(options).send(:run)
        rescue Docopt::Exit => e
          STDERR.write(e.message + "\n")
          ::Kernel.exit(DOCOPT_ERROR_EXIT_CODE)
        end
      end
    end
  end
end
