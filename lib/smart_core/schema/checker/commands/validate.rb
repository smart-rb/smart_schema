# frozen_string_literal: true

# @api private
# @since 0.1.0
module SmartCore::Schema::Checker::Commands
  class Validate < Base
    # @return [String]
    #
    # @api private
    # @since 0.1.0
    attr_reader :schema_key

    # @return [SmartCore::Schema::Checker::EmptyValue, Class<?>]
    #
    # @api private
    # @since 0.1.0
    attr_reader :validator_klass

    # @return [Proc]
    #
    # @api private
    # @since 0.1.0
    attr_reader :validation

    # @param schema_key [String]
    # @param validator_klass [SmartCore::Schema::Checker::EmptyValue, Class<?>]
    # @param validation [Proc]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def initialize(schema_key, validator_klass, validation)
      @schema_key = schema_key
      @validator_klass = validator_klass
      @validation = validation
    end
  end
end
