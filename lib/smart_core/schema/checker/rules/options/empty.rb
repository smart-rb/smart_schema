# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Schema::Checker::Rules::Options::Empty
  # @since 0.1.0
  extend Forwardable

  # @param rule [SmartCore::Schema::Checker::Rules::Base]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(rule)
    @rule = rule
  end

  # @param verifiable_hash [SmartCore::Schema::Checker::VerifiableHash]
  # @return [SmartCore::Schema::Checker::Rules::Result::Success]
  #
  # @api private
  # @since 0.1.0
  def validate(verifiable_hash)
    SmartCore::Schema::Checker::Rules::Result::Success.new(
      key: schema_key,
      value: verifiable_hash[schema_key]
    )
  end

  private

  # @return [SmartCore::Schema::Checker::Rules::Base]
  #
  # @api private
  # @since 0.1.0
  attr_reader :rule

  # @return [String]
  #
  # @api private
  # @since 0.1.0
  def_delegator :rule, :schema_key
end
