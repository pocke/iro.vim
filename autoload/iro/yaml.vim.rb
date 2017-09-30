require 'psych'

module Iro
  module YAML
    module ScalarWithMark
      refine Psych::Nodes::Scalar do
        attr_accessor :mark
      end
    end

    class Parser < ::Psych::Parser
      def initialize
        super(MarkHandler.new(self))
      end
    end

    class MarkHandler < ::Psych::TreeBuilder
      using ScalarWithMark

      def initialize(parser)
        @parser = parser
        super()
      end

      def scalar(value, anchor, tag, plain, quoted, style)
        mark = @parser.mark
        super.tap do |scalar|
          scalar.mark = mark
        end
      end
    end
  end
end
