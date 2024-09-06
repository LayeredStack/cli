require 'fileutils'
require 'thor'
require 'logger'

module LayeredStack
  module Backend
    class Create < Thor
      def self.execute
        new.execute
      end

      no_commands do
        def execute
          check_and_remove_backend
          create_new_backend
        end

        private

        def logger
          @logger ||= Logger.new(STDOUT)
        end

        def run_command(command, message)
          logger.info(message)
          system(command)
        end

        def check_and_remove_backend
          if Dir.exist?('backend')
            run_command('rm -rf backend', 'Removing backend directory')
          end
        end

        def create_new_backend
          template_path = File.expand_path('../../../assets/backend/template.rb', __dir__)
          run_command("rails new backend --minimal --devcontainer --template=#{template_path}", 'Creating new Rails application named backend')
        end
      end
    end
  end
end
