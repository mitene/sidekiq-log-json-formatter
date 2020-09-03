# sidekiq-log_json_formatter
A gem that formats [Sidekiq](https://github.com/mperham/sidekiq) logs into JSON format.

### Format 
```json
{
  "@timestamp": "2020-09-01T18:41:42Z",
  "@fields": {
    "pid": 1234,
    "tid": "TID-1o3t9o", 
    "context": {
      "class": "ExampleWorker",
      "jid": "7094855b3de6a4507c9825ec",
      "elapsed": "51.579"
    },
    "program_name": null,
    "worker": "ExampleWorker"
  }, 
  "@type": "sidekiq",
  "@status": "done",
  "@severity": "INFO", 
  "@run_time": 51.579,
  "@message": "done"
}
```

### Installation
Add this line to your application's Gemfile:

```
gem 'sidekiq-log_json_formatter'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install sidekiq-log_json_formatter
```

### Usage
Add this to your Sidekiq configuration:

```
require 'sidekiq/log_json_formatter'

Sidekiq.logger.formatter = Sidekiq::LogJsonFormatter.new
```

### License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
