# frozen_string_literal: true

require_relative 'lib/grc/version'

Gem::Specification.new do |spec|
  spec.name = 'grc'
  spec.version = Grc::VERSION
  spec.authors = ['Bernardo C.D.A. Vasconcelos']
  spec.email = ['35749099+bcdavasconcelos@users.noreply.github.com']

  spec.summary = 'Methods in Ruby for working with Ancient Greek'
  spec.description = 'This gem provides some methods for working with Ancient Greek in Ruby. '
  spec.homepage = 'https://github.com/bcdavasconcelos/grc'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.6.0'

  # spec.metadata['allowed_push_host'] = 'rubygems.org'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/bcdavasconcelos/grc.git'
  spec.metadata['changelog_uri'] = 'https://github.com/bcdavasconcelos/grc/blob/Main/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  spec.add_dependency 'minitest', '~> 5.0'
  spec.add_dependency 'minitest-reporters', '~> 1.0'
  spec.add_dependency 'rake', '~> 13.0'
  spec.add_dependency 'unicode-name', '~> 1.10.0'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
