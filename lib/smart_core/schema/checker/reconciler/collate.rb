# frozen_string_literal: true

# @api private
# @since 0.1.0
module SmartCore::Schema::Checker::Reconciler::Collate
  class << self
    # @param verifiable_hash [Hash<String|Symbol,Any>]
    # @param rules [SmartCore::Schema::Checker::Rules]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def call(verifiable_hash, rules)
      verifiable_hash.each_pair do |key, value|
        key = SmartCore::Schema::KeyControl.normalize(key)
        rules[key].__verify!(value)
      end
    end
  end
end
