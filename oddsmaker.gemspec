# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "oddsmaker/version"

Gem::Specification.new do |spec|
  spec.name          = "oddsmaker"
  spec.version       = Oddsmaker::VERSION
  spec.authors       = ["Paul Hoffer"]
  spec.email         = ["git@paulhoffer.com"]

  spec.summary       = %q{Calculate and convert sportsbook betting odds, probabilities, wagers, and collections of odds.}
  spec.description   = %q{Convert and manipulate sportsbook betting odds (American, decimal, fractional) and probabilities. Calculate wagering profit and return, and calculate total probability and vig for a collection of odds.}
  spec.homepage      = "https://www.github.com/phoffer/oddsmaker"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "pry"
end
