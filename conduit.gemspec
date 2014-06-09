$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'conduit/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|

  # Details
  #
  s.name     = 'conduit'
  s.version  = Conduit::VERSION
  s.authors  = ['Mike Kelley']
  s.email    = ['mike@codezombie.org']
  s.homepage = 'https://github.com/conduit/conduit'
  s.summary  = 'Conduit is an interface for debit platforms.'

  # Files
  #
  s.files = Dir['{app,config,db,lib}/**/*', 'Rakefile', 'README.rdoc']
  s.test_files = Dir['spec/**/*', 'lib/conduit/drivers/**/spec/*']

  # Dependencies
  #
  s.add_dependency 'activesupport'
  s.add_dependency 'aws-sdk'
  s.add_dependency 'excon'
  s.add_dependency 'tilt'

  # Development Dependencies
  #
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'rspec-its'
  s.add_development_dependency 'nokogiri'
  s.add_development_dependency 'rspec'

end
