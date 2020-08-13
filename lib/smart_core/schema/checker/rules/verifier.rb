# frozen_string_literal: true

# @api private
# @since 0.1.0
module SmartCore::Schema::Checker::Rules::Verifier
  require_relative 'verifier/result'

  class << self
    # @param rule [SmartCore::Schema::Checker::Rules::Base]
    # @param verifiable_value [Any]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def verify!(rule, verifiable_value)
      SmartCore::Schema::Checker::Rules::Verifier::Result.new.tap do |result|
        result << check_type(rule, verifiable_value)
      end
    end

    private

    # @param rule [SmartCore::Schema::Checker::Rules::Base]
    # @param verifiable_value [Any]
    # @return [SmartCore::Schema::Checker::Rules::Result::Success]
    # @return [SmartCore::Schema::Checker::Rules::Result::Failure]
    #
    # @api private
    # @since 0.1.0
    def check_type(rule, verifiable_value)
      rule.options.type.validate(rule.schema_key, verifiable_value)
    end
  end
end
