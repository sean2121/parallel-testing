require 'etc'

module Parallel
  module Testing
    class Config
      # Get a number of logical processors
      def self.multi_core_info
        Etc.nprocessors || 1
      end
    end
  end
end

