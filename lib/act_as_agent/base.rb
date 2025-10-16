# frozen_string_literal: true

module ActAsAgent
  module Base
    def self.included(base)
      base.extend(ClassMethods)
    end

    def run(); end

    module ClassMethods
      def tools(list)
        define_method(:tools) { list }
      end
    end
  end
end
