# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Schema::Checker::Rules::Result::Base
  # @return [String]
  #
  # @api public
  # @since 0.1.0
  attr_reader :key

  # @return [Any]
  #
  # @api public
  # @since 0.1.0
  attr_reader :value

  # @option key [String]
  # @option value [Any]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(key:, value:)
    @key = key
    @value = value
  end

  # @return [Boolean]
  #
  # @api public
  # @since 0.1.0
  def success?
    false
  end

  # @return [Boolean]
  #
  # @api public
  # @since 0.1.0
  def failure?
    false
  end
end
