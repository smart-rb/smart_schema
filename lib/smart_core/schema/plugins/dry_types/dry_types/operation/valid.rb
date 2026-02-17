# frozen_string_literal: true

module SmartCore::Schema::TypeSystem::DryTypes::Operation
  # @api private
  # @since 0.12.0
  class Valid < Base
    # @param value [Any]
    # @return [Boolean]
    #
    # @api private
    # @since 0.12.0
    def call(value)
      type.valid?(value)
    end
  end
end
