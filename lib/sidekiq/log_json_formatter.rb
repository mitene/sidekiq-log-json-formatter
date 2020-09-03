require 'sidekiq'

module Sidekiq
  class LogJsonFormatter < Sidekiq::Logger::Formatters::Base
    def call(severity, time, program_name, message)
      hash = {
        '@timestamp' => time.utc.iso8601,
        '@fields' => {
          pid: ::Process.pid,
          tid: "TID-#{tid}",
          context: ctx,
          program_name: program_name,
          worker: worker,
        },
        '@type' => 'sidekiq',
        '@status' => nil,
        '@severity' => severity,
        '@run_time' => nil,
      }.merge(process_message(message))

      Sidekiq.dump_json(hash) << "\n"
    end

    private

    def worker
      return nil if ctx == {}

      ctx[:class]
    end

    def process_message(message)
      case message
      when Exception
        {
          '@status' => 'exception',
          '@message' => message.message
        }
      when Hash
        if message['retry']
          {
            '@status' => 'retry',
            '@message' => "#{message['class']} failed, retrying with args #{message['args']}."
          }
        else
          {
            '@status' => 'dead',
            '@message' => "#{message['class']} failed with args #{message['args']}, not retrying."
          }
        end
      else
        {
          '@status' => status(message),
          '@run_time' => ctx[:elapsed] && ctx[:elapsed].to_f, # run time in seconds
          '@message' => message
        }
      end
    end

    def status(message)
      if %w[start done fail].any?(message)
        message
      else
        nil
      end
    end
  end
end
