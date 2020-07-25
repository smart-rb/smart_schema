# frozen_string_literal: true

# @api private
# @since 0.1.0
module SmartCore::Schema::Checker::Commands
  class Finalize < Base
    # @return [String]
    #
    # @api private
    # @since 0.1.0
    attr_reader :schema_key

    # @return [Proc]
    #
    # @api private
    # @since 0.1.0
    attr_reader :expression

    # @param schema_key [String]
    # @param expression [Proc]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def initialize(schema_key, expression)
      @schema_key = schema_key
      @expression = expression
    end
  end
end
