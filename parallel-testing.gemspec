
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "parallel/testing/version"

Gem::Specification.new do |spec|
  spec.name          = "parallel-testing"
  spec.version       = Parallel::Testing::VERSION
  spec.authors       = ["shoji_tokunaga"]
  spec.email         = ["shouto04@gmail.com"]
  spec.summary       = "run rpsec in parallel"
  spec.description   = "run rspec in parallel"
  spec.license       = "MIT"
  spec.bindir = "bin"
  spec.executables = ["parallel-testing"]
  spec.require_paths = ["lib"]


  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
