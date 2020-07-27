# frozen_string_literal: true

class SmartCore::Schema
  # @api public
  # @since 0.1.0
  Error = Class.new(SmartCore::Error)

  # @api public
  # @since 0.1.0
  ArgumentError = Class.new(SmartCore::ArgumentError)

  # @api public
  # @since 0.1.0
  UnaccceptableSchemaKeyError = Class.new(Error)
end
