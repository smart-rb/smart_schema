# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Schema::Checker::Rules::Requirement::Optional
  # @param rule [SmartCore::Schema::Checker::Rules::Optional]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(rule)
    @rule = rule
  end

  # @param verifiable_hash [SmartCore::Schema::Checker::VerifiableHash]
  # @return [SmartCore::Schema::Checker::Rules::Requirement::Result]
  #
  # @api private
  # @since 0.1.0
  def validate(verifiable_hash)
    SmartCore::Schema::Checker::Rules::Requirement::Result.new(
      rule.schema_key,
      verifiable_hash,
      required: false,
      key_exists: verifiable_hash.key?(rule.schema_key)
    )
  end

  private

  # @return [SmartCore::Schema::Checker::Rules::Required]
  #
  # @api private
  # @since 0.1.0
  attr_reader :rule
end
