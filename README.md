# sidekiq-log_json_formatter
A gem that formats [Sidekiq](https://github.com/mperham/sidekiq) logs into JSON format.

### Format 
```json
{
  "@timestamp": "2020-09-01T18:41:42Z",
  "@fields": {
    "pid": 1234,
    "tid": "TID-1o3t9o",
    "context": "ExampleWorker JID-deda0f0c174afad251121282",
    "program_name": null,
    "worker": "ExampleWorker",
  },
  "@type": "sidekiq",
  "@status": "done",
  "@severity": "INFO",
  "@run_time": 51.579,
  "@message": "done: 37.298 sec"
}
```

### Installation
Add this line to your application's Gemfile:

```ruby
gem 'sidekiq-log_json_formatter'
```

And then execute:

```sh
$ bundle
```

Or install it yourself as:

```sh
$ gem install sidekiq-log_json_formatter
```

### Usage
Add this to your Sidekiq configuration:

```ruby
require 'sidekiq/log_json_formatter'

Sidekiq.logger.formatter = Sidekiq::LogJsonFormatter.new
```

### License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
