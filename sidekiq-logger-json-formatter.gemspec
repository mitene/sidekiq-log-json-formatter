Gem::Specification.new do |spec|
  spec.name          = 'sidekiq-logger-json-formatter'
  spec.version       = '0.0.1'
  spec.authors       = ['hekki']
  spec.email         = ['contact@hekki.info']

  spec.summary       = 'Format Sidekiq logs to JSON format'
  spec.description   = 'sidekiq-logger-json-formatter format Sidekiq logs to JSON format'
  spec.homepage      = 'https://github.com/mitene/sidekiq-logger-json-formatter'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.6.3')

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'sidekiq', '~> 6'
end

