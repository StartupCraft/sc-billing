# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

# Maintain your gem's version:
require 'sc/billing/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'sc-billing'
  s.version     = SC::Billing::VERSION
  s.authors     = ['Vadim Shalamov']
  s.email       = ['vadshalamov@gmail.com']
  s.homepage    = 'https://github.com/StartupCraft/sc-billing'
  s.summary     = 'Gem contains billing implementation for StartupCraft projects.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['spec/**/*']

  s.add_dependency 'dry-auto_inject', '>= 0.4'
  s.add_dependency 'dry-configurable', '>= 0.7'
  s.add_dependency 'dry-container', '>= 0.6'
  s.add_dependency 'dry-transaction', '>= 0.10'
  s.add_dependency 'pg', '>= 0.20'
  s.add_dependency 'rails', '>= 5.1', '< 6.0'
  s.add_dependency 'sequel', '>= 5.0'
  s.add_dependency 'stripe', '>= 3.11'

  s.add_development_dependency 'database_cleaner', '1.6'
  s.add_development_dependency 'factory_bot_rails', '~> 4.8'
  s.add_development_dependency 'ffaker', '~> 2.10'
  s.add_development_dependency 'pry-byebug'
  s.add_development_dependency 'rspec-rails', '~> 3.7'
  s.add_development_dependency 'rubocop', '~> 0.58'
  s.add_development_dependency 'rubocop-rspec', '~> 1.27'
  s.add_development_dependency 'sequel-rails', '~> 1.0'
  s.add_development_dependency 'stripe-ruby-mock', '2.5.3'
  s.add_development_dependency 'webmock', '~> 3.0'
end
