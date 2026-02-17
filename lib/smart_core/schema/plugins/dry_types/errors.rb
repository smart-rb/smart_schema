# frozen_string_literal: true

# rubocop:disable Style/StaticClass
class SmartCore::Schema
  # @api public
  # @since 0.12.0
  DryTypesError = Class.new(SmartCore::Schema::Error)

  # @api public
  # @since 0.12.0
  DryTypesValidationError = Class.new(DryTypesError)
end
# rubocop:enable Style/StaticClass
