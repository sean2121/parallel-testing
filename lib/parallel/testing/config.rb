require 'etc'
require 'pry'

module Parallel
  module Testing
    class << self
      def configure
        yield(configuration)
      end

      def configuration
        @configuration ||= Configuration.new
      end
    end

    class Configuration
      attr_accessor :number_of_cores

      def initialize
        @number_of_cores = Etc.nprocessors || 1
        @after_fork = Proc.new { |worker| }
      end

      def after_fork(&block)
        @after_fork = block if block_given?
      end

      def after_fork_transaction
        @after_fork
      end
    end
  end
end


