require 'thor'

# Require all .rb files in the layered_stack folder recursively
Dir[File.join(__dir__, 'layered_stack/**/*.rb')].each { |file| require_relative file }

module LayeredStack
  class Cli < Thor
    # This is a Thor configuration that will exit the program if a command fails
    def self.exit_on_failure?
      true
    end

    # Create a new layered stack
    desc "create", "Create a new layered stack"
    def create(arg)
      LayeredStack::Root::Create.execute(arg)
    end

    # Frontend commands
    class Frontend < Thor
      namespace :frontend

      desc "create", "Create"
      def create
        LayeredStack::Frontend::Create.execute
      end

      desc "start", "Start"
      def start
        LayeredStack::Frontend::Start.execute
      end

      desc "create_and_start", "Create and start"
      def create_and_start
        create
        start
      end
    end
    register(Frontend, 'frontend', 'frontend [COMMAND]', 'Commands for the frontend')

    # Backend commands
    class Backend < Thor
      namespace :backend

      desc "create", "Create"
      def create
        LayeredStack::Backend::Create.execute
      end

      desc "start", "Start"
      def start
        LayeredStack::Backend::Start.execute
      end

      desc "create_and_start", "Create and start"
      def create_and_start
        create
        start
      end
    end
    register(Backend, 'backend', 'backend [COMMAND]', 'Commands for the backend')
  end
end
