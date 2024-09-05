require 'fileutils'
require 'thor'

module LayeredStack
  module Cli
    module Commands
      class CreateCommand < Thor
        CREATE_NEXT_APP_SWITCHES = "--js --tailwind --eslint --app --src-dir --import-alias @/* --use-npm"
        NEXT_VERSION = ENV['NEXT_VERSION']
        FRONTEND_DIR = "frontend"
        TEMPLATE_FILES = {
          File.expand_path("../../../../templates/tailwind.config.js", __FILE__) => "frontend/tailwind.config.js",
          File.expand_path("../../../../templates/layout.js", __FILE__) => "frontend/src/app/layout.js",
          File.expand_path("../../../../templates/page.js", __FILE__) => "frontend/src/app/page.js"
        }

        def self.execute
          new.execute
        end

        no_commands do
          def execute
            puts "> layered_stack/create"

            remove_existing_frontend
            run_create_next_app
            Dir.chdir(FRONTEND_DIR) do
              install_dependencies
              update_package_json
            end
            copy_template_files
            print_next_steps
          end

          private

          def remove_existing_frontend
            if Dir.exist?(FRONTEND_DIR)
              puts "\n# Removing existing /#{FRONTEND_DIR} directory"
              FileUtils.rm_rf(FRONTEND_DIR)
            end
          end

          def run_create_next_app
            command = "npx create-next-app@#{NEXT_VERSION} #{CREATE_NEXT_APP_SWITCHES} #{FRONTEND_DIR}"
            run_command(command, "Running create-next-app")
          end

          def install_dependencies
            run_command("npm install next-themes", "Installing next-themes")
            run_command("npm install @heroicons/react@latest", "Installing @heroicons/react@latest")
            run_command("npm install @layeredstack/ui@latest", "Installing @layeredstack/ui@latest")
          end

          def update_package_json
            puts "# Updating package.json to change the port to 3001"
            update_file("package.json", '"dev": "next dev"', '"dev": "next dev -p 3001"')
            update_file("package.json", '"start": "next start"', '"start": "next start -p 3001"')
          end

          def copy_template_files
            puts "\n# Copying template files to the frontend directory"
            TEMPLATE_FILES.each do |src, dest|
              FileUtils.cp(src, dest)
            end
          end

          def print_next_steps
            puts "Start the project with the following command:"
            puts "\nbundle exec layered_stack start"
          end

          def run_command(command, description)
            puts "\n# #{description}"
            system(command) || abort("Failed to execute: #{command}")
          end

          def update_file(file, pattern, replacement)
            system("sed -i '' 's/#{pattern}/#{replacement}/' #{file}") || abort("Failed to update #{file}")
          end
        end
      end
    end
  end
end
