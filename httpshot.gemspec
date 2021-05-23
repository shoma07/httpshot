# frozen_string_literal: true

require_relative 'lib/httpshot/version'

Gem::Specification.new do |spec|
  spec.name          = 'httpshot'
  spec.version       = Httpshot::VERSION
  spec.authors       = %w[shoma07]
  spec.email         = %w[23730734+shoma07@users.noreply.github.com]

  spec.summary       = 'Screenshot command line tool'
  spec.description   = 'Screenshot command line tool'
  spec.homepage      = 'https://github.com/shoma07/httpshot'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 3.0.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = %w[lib]

  spec.add_dependency 'selenium-webdriver'
  spec.add_dependency 'webdrivers'
end
