# frozen_string_literal: true

module SmartCore::Schema::TypeSystem::DryTypes::Operation
  # @api private
  # @since 0.12.0
  class Cast < Base
    # @param value [Any]
    # @return [void]
    #
    # @raise [SmartCore::Schema::TypeCastingUnsupportedError]
    #
    # @api private
    # @since 0.12.0
    def call(value)
      raise(
        SmartCore::Schema::TypeCastingUnsupportedError,
        'DryTypes type system has no support for type casting at the moment.'
      )
    end
  end
end
