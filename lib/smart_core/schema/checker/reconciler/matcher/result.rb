# frozen_string_literal: true

# @api private
# @since 0.1.0
# @version 0.8.0
class SmartCore::Schema::Checker::Reconciler::Matcher::Result
  # @return [Hash<String|Symbol,Any>]
  #
  # @api private
  # @since 0.1.0
  attr_reader :verifiable_hash

  # @return [SmartCore::Schema::Checker::Rules::Verifier::Result]
  #
  # @api private
  # @since 0.1.0
  attr_reader :contract_keys_results

  # @return [
  #   SmartCore::Schema::Checker::Rules::ExtraKeys::Success,
  #   SmartCore::Schema::Checker::Rules::ExtraKeys::Failure
  # ]
  # @api private
  # @since 0.1.0
  attr_reader :extra_keys_results

  # @param verifiable_hash [SmartCore::Schema::Checker::VerifiableHash]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  # @version 0.8.0
  def initialize(verifiable_hash)
    @verifiable_hash = verifiable_hash
    @contract_keys_results = []
    @extra_keys_results = []
  end

  # @param block
  # @yield [result]
  # @yieldparam result [
  #   SmartCore::Schema::Checker::Rules::Verifier::Result,
  #   SmartCore::Schema::Checker::Rules::ExtraKeys::Success,
  #   SmartCore::Schema::Checker::Rules::ExtraKeys::Failure
  # ]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  # @version 0.8.0
  def each_result(&block)
    contract_keys_results.each(&block)
    extra_keys_results.each(&block)
  end

  # @param result [SmartCore::Schema::Checker::Rules::Verifier::Result]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  # @version 0.8.0
  def contract_key_result(result)
    contract_keys_results << result
  end

  # @param result [
  #   SmartCore::Schema::Checker::Rules::ExtraKeys::Success,
  #   SmartCore::Schema::Checker::Rules::ExtraKeys::Failure
  # ]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  # @version 0.8.0
  def extra_keys_result(result)
    extra_keys_results << result
  end

  # @return [SmartCore::Schema::Result]
  #
  # @api private
  # @since 0.1.0
  # @version 0.8.0
  def complete!
    SmartCore::Schema::Checker::Reconciler::Matcher::ResultFinalizer.finalize(self)
  end
end
