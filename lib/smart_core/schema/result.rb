# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Schema::Result
  # @return [Hash<String,Any>]
  #
  # @api public
  # @since 0.1.0
  attr_reader :source

  # @return [Hash<String,Array<Symbol>>]
  #
  # @api public
  # @since 0.1.0
  attr_reader :errors

  # @return [Set<String>]
  #
  # @api public
  # @since 0.1.0
  attr_reader :extra_keys

  # @param source [Hash<String|Symbol,Any>]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(source, errors, extra_keys)
    @source = source
    @errors = errors
    @extra_keys = extra_keys
  end

  # @return [Boolean]
  #
  # @api public
  # @since 0.1.0
  def success?
    errors.empty? && extra_keys.empty?
  end

  # @return [Boolean]
  #
  # @api public
  # @since 0.1.0
  def failure?
    errors.any? || extra_keys.any?
  end
end
