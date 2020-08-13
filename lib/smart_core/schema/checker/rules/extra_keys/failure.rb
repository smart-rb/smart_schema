# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Schema::Checker::Rules::ExtraKeys::Failure
  # @return extra_keys [Array<String>]
  #
  # @api private
  # @since 0.1.0
  attr_reader :extra_keys

  # @param extra_keys [Array<String>]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(extra_keys)
    @extra_keys = extra_keys
  end

  # @return [Boolean]
  #
  # @api private
  # @since 0.1.0
  def success?
    false
  end

  # @return [Boolean]
  #
  # @api private
  # @since 0.1.0
  def failure?
    true
  end
end
