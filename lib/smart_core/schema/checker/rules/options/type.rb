# frozen_string_literal: true

class SmartCore::Schema::Checker::Rules::Options
  # @api private
  # @since 0.1.0
  class Type < Empty
    # @note Constant is used only for clarity (for other developers)
    # @return [Symbol]
    #
    # @api private
    # @since 0.1.0
    ERROR_CODE = :invalid_type

    # @param rule [SmartCore::Schema::Checker::Rules::Base]
    # @param required_type [String, Symbol, SmartCore::Types::Primitive]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def initialize(rule, required_type)
      super(rule)
      @type = resolve_required_type(required_type)
    end

    # @param verifiable_hash [SmartCore::Schema::Checker::VerifiableHash]
    # @return [SmartCore::Schema::Checker::Rules::Result::Success]
    # @return [SmartCore::Schema::Checker::Rules::Result::Failure]
    #
    # @api private
    # @since 0.1.0
    def validate(verifiable_hash)
      schema_value = verifiable_hash[schema_key]

      if type.valid?(schema_value)
        SmartCore::Schema::Checker::Rules::Result::Success.new(
          key: schema_key,
          value: schema_value
        )
      else
        SmartCore::Schema::Checker::Rules::Result::Failure.new(
          key: schema_key,
          value: schema_value,
          error: ERROR_CODE,
          message: "Requires #{type} type (got: #{schema_value.class})"
        )
      end
    end

    private

    # @return [String, Symbol, SmartCore::Types::Primitive]
    #
    # @api private
    # @since 0.1.0
    attr_reader :type

    # @param required_type [String, Symbol, SmartCore::Types::Primitive]
    # @return [SmartCore::Types::Primitive]
    #
    # @api private
    # @since 0.1.0
    def resolve_required_type(required_type)
      unless required_type.is_a?(String) ||
             required_type.is_a?(Symbol) ||
             required_type.is_a?(SmartCore::Types::Primitive)
        raise(SmartCore::Schema::ArgumentError, <<~ERROR_MESSAGE)
          Schema key type should be a type of string, symbol or SmartCore:Types::Primitive (got: #{required_type})
        ERROR_MESSAGE
      end

      if required_type.is_a?(SmartCore::Types::Primitive)
        required_type
      else
        begin
          SmartCore::Schema::Checker::Rules::TYPE_ALIASES.fetch(required_type.to_s)
        rescue KeyError
          raise(SmartCore::Schema::ArgumentError, <<~ERROR_MESSAGE)
            Chosen schema key type is not supported or not registered (got #{required_type})
          ERROR_MESSAGE
        end
      end

      # TODO: rework with smart_type-system
    end
  end
end
