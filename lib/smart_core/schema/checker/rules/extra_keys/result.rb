# frozen_string_literal: true

# @apbstract
#
# @api private
# @since 0.3.0
class SmartCore::Schema::Checker::Rules::ExtraKeys::Result
  # @return [Array<String>]
  #
  # @api private
  # @since 0.3.0
  attr_reader :extra_keys

  # @return [SmartCore::Schema::Checker::Reconciler::Matcher::Options]
  #
  # @api private
  # @since 0.3.0
  attr_reader :matcher_options

  # @param extra_keys [Array<String>]
  # @param matcher_options [SmartCore::Schema::Checker::Reconciler::Matcher::Options]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  # @version 0.3.0
  def initialize(extra_keys, matcher_options)
    @extra_keys = extra_keys
    @matcher_options = matcher_options
  end

  # @!method success?
  #   @return [Boolean]

  # @!method failure?
  #   @return [Boolean]
end
