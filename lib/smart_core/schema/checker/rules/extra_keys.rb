# frozen_string_literal: true

# @api private
# @since 0.1.0
module SmartCore::Schema::Checker::Rules::ExtraKeys
  require_relative 'extra_keys/success'
  require_relative 'extra_keys/failure'

  class << self
    # @param verifiable_hash [SmartCore::Schema::Checker::VerifiableHash]
    # @param rules [SmartCore::Schema::Checker::Rules]
    # @return [SmartCore::Schema::Checker::Rules::ExtraKeys::Success]
    # @return [SmartCore::Schema::Checker::Rules::ExtraKeys::Failure]
    #
    # @api private
    # @since 0.1.0
    def __verify!(verifiable_hash, rules)
      extra_keys = verifiable_hash.keys - rules.keys
      extra_keys.empty? ? Success.new : Failure.new(extra_keys)
    end
  end
end
