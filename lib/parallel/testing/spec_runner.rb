require 'rspec/core'
require 'drb'

module Parallel
  module Testing
    class SpecRunner < RSpec::Core::Runner
      attr_reader :path

      def initialize(args)
        options = RSpec::Core::ConfigurationOptions.new(args)
        super(options)
        File.open("/tmp/paralell-testing-process-#{$$}", "w") do |file|
          STDOUT.reopen(file)
          STDERR.reopen(STDOUT)
          STDOUT.sync = STDERR.sync = true
        end
      end

      def run_specs(example_groups)
        @configuration.filter_manager = RSpec::Core::FilterManager.new
        success = @configuration.reporter.report(0) do |reporter|
          @configuration.with_suite_hooks do
            example_groups.map do |g|
              g.run(reporter)
            end.all?
          end
        end && !@world.non_example_failure
        success ? 0 : @configuration.failure_exit_code
      end
    end

    class Iterator
      include Enumerable
      attr_reader :path

      def initialize(path)
        @path = path
      end

      def each
        RSpec.world.example_groups.clear
        Kernel.load path
        RSpec.world.example_groups.each do |example_group|
          yield example_group
        end
      end
    end
  end
end
