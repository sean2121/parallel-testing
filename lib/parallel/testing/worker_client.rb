require_relative 'spec_runner'
require 'drb'

module Parallel
  module Testing
    class WorkerClient
      attr_accessor :path, :spec_runner, :iterator, :args , :number

      def initialize(args, number)
        @args = args
        @number = number
        after_fork_do
        start_client
      end

      def after_fork_do
        Parallel::Testing.configuration.after_fork_transaction.call(self)
      end

      def start_client
        DRb.start_service
        ​​q = DRbObject.new_with_uri('druby://localhost:50565')
        loop do
          if recv = ​​q.pop
            @iterator = Iterator.new(recv)
            run
          else
            ​​q.push(nil)
            exit!
          end
        end
      end

      def run
        spec_runner = SpecRunner.new(args)
        spec_runner.run_specs(iterator)
      end
    end
  end
end
