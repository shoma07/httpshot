lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "httpshot/version"

Gem::Specification.new do |spec|
  spec.name          = "httpshot"
  spec.version       = Httpshot::VERSION
  spec.authors       = ["shoma07"]
  spec.email         = ["23730734+shoma07@users.noreply.github.com"]

  spec.summary       = %q{Screenshot command line tool}
  spec.description   = %q{Screenshot command line tool}
  spec.homepage      = "https://github.com/shoma07/httpshot"
  spec.license       = "MIT"

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/#{Httpshot}/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "webdrivers", "~> 4.0"
  spec.add_dependency "selenium-webdriver", "~> 3.0"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
end
