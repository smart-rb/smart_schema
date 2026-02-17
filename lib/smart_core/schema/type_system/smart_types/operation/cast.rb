# frozen_string_literal: true

module SmartCore::Schema::TypeSystem::SmartTypes::Operation
  # @api private
  # @since 0.12.0
  class Cast < Base
    # @param value [Any]
    # @return [Any]
    #
    # @api private
    # @since 0.12.0
    def call(value)
      type.cast(value)
    end
  end
end
