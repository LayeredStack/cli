require 'thor'
require 'logger'

module LayeredStack
  module Backend
    class Start < Thor
      def self.execute
        new.execute
      end

      no_commands do
        def execute
          logger.info("> layered_stack/frontend/start")
          run_command('code backend', 'Starting VS Code in /backend directory')
        end

        private

        def logger
          @logger ||= Logger.new(STDOUT)
        end

        def run_command(command, message)
          logger.info(message)
          system(command)
        end
      end
    end
  end
end
