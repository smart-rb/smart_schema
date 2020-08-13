# frozen_string_literal: true

# @api private
# @since 0.1.0
module SmartCore::Schema::Checker::Reconciler::Matcher
  class << self
    # @param verifiable_hash [Hash<String|Symbol,Any>]
    # @param rules [SmartCore::Schema::Checker::Rules]
    # @return [SmartCore::Schema::Result]
    #
    # @api private
    # @since 0.1.0
    def match(verifiable_hash, rules)
      SmartCore::Schema::Result.new(verifiable_hash).tap do |result|
        match_for_schema_keys(verifiable_hash, rules, result)
        match_for_extra_keys(verifiable_hash, rules, result)
      end
    end

    private

    # @param verifiable_hash [Hash<String|Symbol,Any>]
    # @param rules [SmartCore::Schema::Checker::Rules]
    # @param result [SmartCore::Schema::Result]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def match_for_schema_keys(verifiable_hash, rules, result)
      rules.each_rule { |rule| result << rule.__verify!(verifiable_hash) }
    end

    # @param verifiable_hash [Hash<String|Symbol,Any>]
    # @param rules [SmartCore::Schema::Checker::Rules]
    # @param result [SmartCore::Schema::Result]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def match_for_extra_keys(verifiable_hash, rules, result)
      result << SmartCore::Schema::Checker::Rules::ExtraKeys.__verify!(verifiable_hash, rules)
    end
  end
end
