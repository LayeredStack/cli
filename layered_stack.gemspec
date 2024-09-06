require_relative 'lib/layered_stack/version'

Gem::Specification.new do |s|
  # General
  s.name                        = 'layered_stack'
  s.version                     = LayeredStack::VERSION
  s.authors                     = ['Layered Stack']
  s.email                       = ['support@layeredstack.com']

  # About
  s.summary                     = 'Layered Stack CLI'
  s.description                 = 'CLI for Layered Stack'
  s.homepage                    = 'https://www.layeredstack.com/'
  s.license                     = 'MIT'

  # Metadata
  s.metadata['homepage_uri']    = s.homepage
  s.metadata['source_code_uri'] = 'https://github.com/LayeredStack/cli'

  # Ruby
  s.required_ruby_version       = '>=3.3.0'

  # Files and executables
  s.files                       = Dir.glob('lib/**/*.rb') + Dir.glob('assets/**/*')
  s.executables                 = ['layered_stack']

  # Dependencies
  s.add_dependency "thor", "~> 1.3.2"
  s.add_dependency "rails", ">= 7.0.0"
end
