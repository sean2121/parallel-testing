require_relative 'worker_client'
require_relative 'config'
require 'rspec/core'
require 'drb'

module Parallel
  module Testing
    class Master
      attr_reader :args, :files_to_run, :queue

      def initialize(args)
        @args = args
        configure_rspec(args)
        @files_to_run = ::RSpec.configuration.files_to_run.uniq
        @queue = Queue.new
        start_service
      end

      def start_service
        begin
          uri = "druby://localhost:50565"
          DRb.start_service(uri, queue)
          files_to_run.each { |r| queue.push(r) }
          queue.push(nil)
          pids = []
          Parallel::Testing.config.number_of_cores.times do
            pids << fork { WorkerClient.new(args) }
          end
          Process.waitall
        end
      ensure
        pids.each do |pid|
          if File.exist?("/tmp/paralell-testing-process-#{pid}")
            File.open("/tmp/paralell-testing-process-#{pid}") do |f|
              puts f.read
            end
          end
        end
      end


      def configure_rspec(args)
        options = ::RSpec::Core::ConfigurationOptions.new(args)
        options.configure(::RSpec.configuration)
      end
    end
  end
end
