# frozen_string_literal: true

module SmartCore::Schema::TypeSystem::DryTypes::Operation
  # @api private
  # @since 0.12.0
  class Validate < Base
    # @param value [Any]
    # @return [void]
    #
    # @api private
    # @since 0.12.0
    def call(value)
      raise(
        SmartCore::Schema::DryTypesValidationError,
        "Dry::Types validation error: (get #{value.inspect} for type #{type.inspect}"
      ) unless type.valid?(value)
    end
  end
end
