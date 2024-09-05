# frozen_string_literal: true

require 'thor'
require 'logger'

module LayeredStack
  module Cli
    module Commands
      class StartCommand < Thor
        FRONTEND_DIR = "frontend"
        LOCALHOST_URL = "http://localhost:3001"

        def self.execute
          new.execute
        end

        no_commands do
          def execute
            logger.info("> layered_stack/start")

            if change_directory
              open_browser
              run_development_server
            end
          end

          private

          def logger
            @logger ||= Logger.new(STDOUT)
          end

          def change_directory
            if Dir.exist?(FRONTEND_DIR)
              begin
                Dir.chdir(FRONTEND_DIR)
                logger.info("Changed directory to '#{FRONTEND_DIR}'")
                true
              rescue => e
                logger.error("Failed to change directory: #{e.message}")
                false
              end
            else
              logger.error("Directory '#{FRONTEND_DIR}' does not exist")
              false
            end
          end

          def open_browser
            logger.info("\n# Opening the browser")
            run_command("open #{LOCALHOST_URL}", "Browser opened successfully", "Failed to open the browser")
          end

          def run_development_server
            logger.info("\n# Running the development server")
            run_command("npm run dev", "Development server started successfully", "Failed to start the development server")
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
end
