# frozen_string_literal: true

# rubocop:disable Style/StaticClass
class SmartCore::Schema
  # @api public
  # @since 0.1.0
  Error = Class.new(SmartCore::Error)

  # @api public
  # @since 0.1.0
  ArgumentError = Class.new(SmartCore::ArgumentError)
end
# rubocop:enable Style/StaticClass
