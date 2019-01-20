require 'etc'

module Parallel
  module Testing
    class << self
      def configure
        yield(configuration)
      end

      def config
        @configuration ||= Configuration.new
      end
    end

    class Configuration
      include Singleton
      attr_accessor :number_of_cores

      def initialize
        @number_of_cores = Etc.nprocessors || 1
      end

      def after_fork_set(&block)
        if block_given?
          @after_fork_block = block
        else
          lambda {}
        end
      end

      def after_fork
        @after_fork_block
      end
    end
  end
end


