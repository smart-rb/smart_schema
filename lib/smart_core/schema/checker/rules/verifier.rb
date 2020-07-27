# frozen_string_literal: true

# @api private
# @since 0.1.0
module SmartCore::Schema::Checker::Rules::Verifier
  class << self
    # @param rule [SmartCore::Schema::Checker::Rules::Base]
    # @param verifiable_value [Any]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def verify!(rule, verifiable_value)
      verifiable_key = SmartCore::Schema::KeyControl.normalize(verifiable_key)

      result = SmartCore::Schema::Checker::Result::Composite.new
      result << check_type(rule, verifiable_value)
      result
    end

    private

    def check_type(rule, verifiable_value)
      rule.options.type.validate(rule.schema_key, verifiable_value)
    end
  end
end
