require 'thor'
require 'logger'

module LayeredStack
  module Frontend
    class Start < Thor
      def self.execute
        new.execute
      end

      no_commands do
        def execute
          logger.info("> layered_stack/frontend/start")
          run_command('code frontend', 'Starting VS Code in frontend directory', 'Failed to start VS Code')
        end

        private

        def logger
          @logger ||= Logger.new(STDOUT)
        end

        def run_command(command, success_message, error_message)
          if system(command)
            logger.info(success_message)
          else
            logger.error(error_message)
          end
        end
      end
    end
  end
end
