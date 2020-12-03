# frozen_string_literal: true

# @api private
# @since 0.1.0
# @version 0.3.0
module SmartCore::Schema::Checker::Reconciler::Matcher
  require_relative 'matcher/options'
  require_relative 'matcher/result'
  require_relative 'matcher/result_finalizer'

  class << self
    # @param reconciler [SmartCore::Schema::Checker::Reconciler]
    # @param verifiable_hash [SmartCore::Schema::Checker::VerifiableHash]
    # @return [SmartCore::Schema::Checker::Reconciler::Matcher::Result]
    #
    # @api private
    # @since 0.1.0
    # @version 0.3.0
    def match(reconciler, verifiable_hash)
      matcher_options = Options.build_from(reconciler)

      Result.new(verifiable_hash).tap do |result|
        match_for_contract_keys(reconciler, matcher_options, verifiable_hash, result)
        match_for_extra_keys(reconciler, matcher_options, verifiable_hash, result)
      end
    end

    private

    # @param reconciler [SmartCore::Schema::Checker::Reconciler]
    # @param matcher_options [SmartCore::Schema::Checker::Reconciler::Matcher::Options]
    # @param verifiable_hash [SmartCore::Schema::Checker::VerifiableHash]
    # @param result [SmartCore::Schema::Checker::Reconciler::Matcher::Result]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    # @version 0.3.0
    def match_for_contract_keys(reconciler, matcher_options, verifiable_hash, result)
      reconciler.__contract_rules.each_rule do |rule|
        verification_result = rule.__verify!(verifiable_hash, matcher_options)
        result.contract_key_result(verification_result)
      end
    end

    # @param reconciler [SmartCore::Schema::Checker::Reconciler]
    # @param matcher_options [SmartCore::Schema::Checker::Reconciler::Matcher::Options]
    # @param verifiable_hash [SmartCore::Schema::Checker::VerifiableHash]
    # @param result [SmartCore::Schema::Checker::Reconciler::Matcher::Result]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    # @version 0.3.0
    def match_for_extra_keys(reconciler, matcher_options, verifiable_hash, result)
      verification_result = reconciler.__extra_keys_contract.__verify!(
        verifiable_hash, reconciler.__contract_rules, matcher_options
      )
      result.extra_keys_result(verification_result)
    end
  end
end
