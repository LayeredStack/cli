require 'thor'

# Require all .rb files in the layered_stack folder recursively
Dir[File.join(__dir__, 'layered_stack/**/*.rb')].each { |file| require_relative file }

module LayeredStack
  module Cli
    class Runner < Thor
      desc "hello", "say hello"
      def hello(name)
        puts "> layered_stack/hello"
        puts "Hello #{name} from Layered Stack CLI version #{LayeredStack::VERSION}!"
      end

      desc "create", "Create"
      def create
        LayeredStack::Cli::Commands::CreateCommand.execute
      end

      desc "start", "Start"
      def start
        LayeredStack::Cli::Commands::StartCommand.execute
      end

      desc "create_and_start", "Create and start"
      def create_and_start
        create
        start
      end
    end
  end
end
