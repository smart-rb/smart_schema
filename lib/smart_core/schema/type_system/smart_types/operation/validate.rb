# frozen_string_literal: true

module SmartCore::Schema::TypeSystem::SmartTypes::Operation
  # @api private
  # @since 0.12.0
  class Validate < Base
    # @param value [Any]
    # @return [void]
    #
    # @api private
    # @since 0.12.0
    def call(value)
      type.validate!(value)
    end
  end
end
