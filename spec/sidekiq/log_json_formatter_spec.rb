require 'spec_helper'

RSpec.describe 'Sidekiq::LogJsonFormatter' do
  describe '#call' do
    subject { Sidekiq::LogJsonFormatter.new.call(severity, time, program_name, message) }

    let(:time) { Time.now }
    let(:program_name) { 'RSpec' }

    shared_examples 'json log is output' do
      it do
        log = JSON.parse(subject)

        expect(log['@type']).to eq 'sidekiq'
        expect(log['@severity']).to eq severity
        expect(log['@timestamp']).to eq time.utc.iso8601
        expect(log['@fields']['program_name']).to eq program_name
        expect(log['@fields']['worker']).to eq worker
        expect(log['@status']).to eq status
        expect(log['@message']).to eq message
        expect(log['@run_time']).to eq run_time
      end
    end

    context 'debug severity' do
      let(:severity) { 'DEBUG' }
      let(:message) { 'debug message' }
      let(:worker) { nil }
      let(:status) { nil }
      let(:run_time) { nil }

      it_behaves_like 'json log is output'
    end

    context 'INFO severity' do
      before do
        allow_any_instance_of(Sidekiq::LogJsonFormatter).to receive(:ctx).and_return(ctx)
      end

      let(:severity) { 'INFO' }
      let(:worker) { 'TestWorker' }
      let(:jid) { 'JID-xxxxxxxxxxxxxxxxxxxxxx' }

      context 'status: start' do
        let(:ctx) { { 'class': 'TestWorker', 'jid': 'xxxxxxxxxxxxxxxxxxxxxx' } }
        let(:message) { 'start' }
        let(:status) { 'start' }
        let(:run_time) { nil }

        it_behaves_like 'json log is output'
      end

      context 'status: done' do
        let(:ctx) { { 'class': 'TestWorker', 'jid': 'xxxxxxxxxxxxxxxxxxxxxx', 'elapsed': '0.015' } }
        let(:message) { 'done' }
        let(:status) { 'done' }
        let(:run_time) { 0.015 }

        it_behaves_like 'json log is output'
      end

      context 'status: fail' do
        let(:ctx) { { 'class': 'TestWorker', 'jid': 'xxxxxxxxxxxxxxxxxxxxxx', 'elapsed': '0.123' } }
        let(:message) { 'fail' }
        let(:status) { 'fail' }
        let(:run_time) { 0.123 }

        it_behaves_like 'json log is output'
      end
    end

    context 'WARN severity' do
      let(:severity) { 'WARN' }

      shared_examples 'json log is output' do
        it do
          log = JSON.parse(subject)

          expect(log['@type']).to eq 'sidekiq'
          expect(log['@severity']).to eq severity
          expect(log['@timestamp']).to eq time.utc.iso8601
          expect(log['@fields']['program_name']).to eq program_name
          expect(log['@fields']['worker']).to eq nil
          expect(log['@status']).to eq status
          expect(log['@message']).to eq error_message
          expect(log['@run_time']).to eq nil
        end
      end

      context 'status: exception' do
        let(:message) { StandardError.new(error_message) }
        let(:error_message) { 'error message' }
        let(:status) { 'exception' }

        it_behaves_like 'json log is output'
      end

      context 'status: retry' do
        let(:message) { { 'retry' => true, 'class' => 'TestClass', 'args' => 'args' } }
        let(:error_message) { 'TestClass failed, retrying with args args.' }
        let(:status) { 'retry' }

        it_behaves_like 'json log is output'
      end

      context 'status: dead' do
        let(:message) { { 'class' => 'TestClass', 'args' => 'args' } }
        let(:error_message) { 'TestClass failed with args args, not retrying.' }
        let(:status) { 'dead' }

        it_behaves_like 'json log is output'
      end
    end
  end
end
