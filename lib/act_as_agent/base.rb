# frozen_string_literal: true

module ActAsAgent
  module Base
    def self.included(base)
      base.extend(ClassMethods)
    end

    def run(text: nil); end

    module ClassMethods
      def llm_provider(llm:)
        define_method(:tools) { list }
      end
    end
  end
end
