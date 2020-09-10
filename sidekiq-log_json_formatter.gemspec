Gem::Specification.new do |spec|
  spec.name          = 'sidekiq-log_json_formatter'
  spec.version       = '2.0.0'
  spec.authors       = ['hekki']
  spec.email         = ['contact@hekki.info']

  spec.summary       = 'Format Sidekiq logs to JSON'
  spec.description   = 'sidekiq-log_json_formatter format Sidekiq logs to JSON'
  spec.homepage      = 'https://github.com/mitene/sidekiq-log_json_formatter'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.6.3')

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rspec'

  spec.add_dependency 'sidekiq', '~> 6'
end
