require_relative 'lib/rescue_from/version'

Gem::Specification.new do |spec|
  spec.name = 'rescue_from'
  spec.version = RescueFrom::VERSION
  spec.authors = ['Moku S.r.l.', 'Riccardo Agatea']
  spec.email = ['info@moku.io']
  spec.license = 'MIT'

  spec.summary = 'An imitation of ActiveSupport::Rescuable that relies on Ruby\'s callbacks to reduce boilerplate code.'
  spec.description = 'An imitation of ActiveSupport::Rescuable that relies on Ruby\'s callbacks to reduce ' \
                     'boilerplate code.'
  spec.homepage = 'https://github.com/moku-io/rescue_from'
  spec.required_ruby_version = '>= 2.6.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/moku-io/rescue_from'
  spec.metadata['changelog_uri'] = 'https://github.com/moku-io/rescue_from/blob/master/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir __dir__ do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport'
  spec.add_dependency 'therefore', '~> 1.0'
end
