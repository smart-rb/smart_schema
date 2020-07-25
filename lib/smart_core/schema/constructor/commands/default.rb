# frozen_string_literal: true

# @api private
# @since 0.1.0
module SmartCore::Schema::Constructor::Commands
  class Default < Base
    # @return [String]
    #
    # @api private
    # @since 0.1.0
    attr_reader :schema_key

    # @return [SmartCore::Schema::Constructor::EmptyValue, Any]
    #
    # @api private
    # @since 0.1.0
    attr_reader :default_value

    # @return [Proc]
    #
    # @api private
    # @since 0.1.0
    attr_reader :expression

    # @param schema_key [String]
    # @param default_value [SmartCore::Schema::Constructor::EmptyValue, Any]
    # @param expression [Proc]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def initialize(schema_key, default_value, expression)
      @schema_key = schema_key
      @default_value = default_value
      @expression = expression
    end
  end
end
