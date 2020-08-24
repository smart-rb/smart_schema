# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Schema::Checker::Rules::Verifier::Result
  # @since 0.1.0
  include Enumerable

  # @return [Array<SmartCore::Schema::Checker::Rules::Result::Base>]
  #
  # @api private
  # @since 0.1.0
  attr_reader :results

  # @return [SmartCore::Schema::Checker::Rules::Base]
  #
  # @api private
  # @since 0.1.0
  attr_reader :rule

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(rule)
    @rule = rule
    @results = []
  end

  # @return [String]
  #
  # @api private
  # @since 0.1.0
  def key
    rule.schema_key
  end

  # @param result [SmartCore::Schema::Checker::Rules::Result::Base]
  # @return [result]
  #
  # @api private
  # @since 0.1.0
  def add(result)
    result.tap { results << result }
  end
  alias_method :<<, :add

  # @param block [Block]
  # @yield [result]
  # @yieldparam result [SmartCore::Schema::Checker::Rules::Result::Base]
  # @return [Enumerable]
  #
  # @api private
  # @since 0.1.0
  def each(&block)
    block_given? ? results.each(&block) : results.each
  end
  alias_method :each_result, :each

  # @return [Boolean]
  #
  # @api public
  # @since 0.1.0
  def success?
    results.all?(&:success?)
  end

  # @return [Boolean]
  #
  # @api public
  # @since 0.1.0
  def failure?
    results.all?(&:failure?)
  end
end
