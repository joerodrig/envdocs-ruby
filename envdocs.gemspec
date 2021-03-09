$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "envdocs/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "envdocs"
  spec.version     = Envdocs::VERSION
  spec.authors     = ["Joseph James Rodriguez"]
  spec.email       = ["joerodrig3@gmail.com"]
  spec.homepage    = "https://github.com/joerodrig/envdocs-ruby/"
  spec.summary     = "Find missing ENV keys"
  spec.description = "Envdocs allows you to find missing env keys, as well as create living documentation of the keys themselves."
  spec.license     = "LGPLv3"

  spec.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", ">= 4.2", "< 6.2"

  spec.add_development_dependency "sqlite3"
end
