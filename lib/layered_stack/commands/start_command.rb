require 'thor'
require 'logger'

module LayeredStack
  module Cli
    module Commands
      class StartCommand < Thor
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
            if Dir.exist?("frontend")
              begin
                Dir.chdir("frontend")
                logger.info("Changed directory to 'frontend'")
                true
              rescue => e
                logger.error("Failed to change directory: #{e.message}")
                false
              end
            else
              logger.error("Directory 'frontend' does not exist")
              false
            end
          end

          def open_browser
            logger.info("\n# Opening the browser")
            if system("open http://localhost:3001")
              logger.info("Browser opened successfully")
            else
              logger.error("Failed to open the browser")
            end
          end

          def run_development_server
            logger.info("\n# Running the development server")
            if system("npm run dev")
              logger.info("Development server started successfully")
            else
              logger.error("Failed to start the development server")
            end
          end
        end
      end
    end
  end
end
