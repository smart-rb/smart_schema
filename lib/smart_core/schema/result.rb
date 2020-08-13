# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Schema::Result
  # @param schema [Hash<String|Symbol,Any>]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(schema)
    @schema = schema
    @results = []
  end

  # @param rule_result [SmartCore::Schema::Checker::Rules::Verifier::Result]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def <<(rule_result)
    results << rule_result
  end

  private

  # @return [Array<SmartCore::Schema::Checker::Rule::Verifier::Result>]
  #
  # @api private
  # @since 0.1.0
  attr_reader :results
end
