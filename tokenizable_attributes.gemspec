$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'listable_collections/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'listable_collections'
  s.version     = ListableCollections::VERSION
  s.authors     = ['mmontossi']
  s.email       = ['mmontossi@buyin.io']
  s.homepage    = 'https://github.com/mmontossi/listable_collections'
  s.summary     = 'Listable collections for rails.'
  s.description = 'Minimalistic listable collections for rails.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.required_ruby_version = '>= 2.0.0'

  s.add_dependency 'rails', (ENV['RAILS_VERSION'] ? "~> #{ENV['RAILS_VERSION']}" : ['>= 4.0.0', '< 4.3.0'])
  s.add_development_dependency 'mocha'
  s.add_development_dependency 'sqlite3'
end
