# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Schema::Checker::Rules::Verifier::Result
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize
    @results = []
  end

  # @param result [SmartCore::Schema::Checker::Rules::Result::Base]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def add(result)
    results << result
  end
  alias_method :<<, :add

  # @return [Boolean]
  #
  # @api public
  # @since 0.1.0
  def success?
    results.all?(&:sucess?)
  end

  # @return [Boolean]
  #
  # @api public
  # @since 0.1.0
  def failure?
    results.all?(&:failure?)
  end

  private

  # @return [Array<SmartCore::Schema::Checker::Rules::result::Base>]
  #
  # @api private
  # @since 0.1.0
  attr_reader :results
end
