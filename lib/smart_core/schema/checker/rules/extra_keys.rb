# frozen_string_literal: true

# @api private
# @since 0.1.0
# @version 0.3.0
module SmartCore::Schema::Checker::Rules::ExtraKeys
  require_relative 'extra_keys/result'
  require_relative 'extra_keys/success'
  require_relative 'extra_keys/failure'

  class << self
    # @param verifiable_hash [SmartCore::Schema::Checker::VerifiableHash]
    # @param rules [SmartCore::Schema::Checker::Rules]
    # @param matcher_options [SmartCore::Schema::Checker::Reconciler::Matcher::Options]
    # @return [SmartCore::Schema::Checker::Rules::ExtraKeys::Success]
    # @return [SmartCore::Schema::Checker::Rules::ExtraKeys::Failure]
    #
    # @api private
    # @since 0.1.0
    # @version 0.3.0
    def __verify!(verifiable_hash, rules, matcher_options)
      extra_keys = verifiable_hash.keys - rules.keys

      case
      when extra_keys.empty?
        Success.new(extra_keys, matcher_options)
      when extra_keys.any? && !matcher_options.strict_schema?
        Success.new(extra_keys, matcher_options)
      else
        Failure.new(extra_keys, matcher_options)
      end
    end
  end
end
