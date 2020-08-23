# frozen_string_literal: true

# @api private
# @since 0.1.0
module SmartCore::Schema::Checker::Rules::Verifier
  require_relative 'verifier/result'

  class << self
    # @param rule [SmartCore::Schema::Checker::Rules::Base]
    # @param verifiable_hash [SmartCore::Schema::Checker::VerifiableHash]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def verify!(rule, verifiable_hash)
      SmartCore::Schema::Checker::Rules::Verifier::Result.new(rule).tap do |result|
        requirement = result << check_requirement(rule, verifiable_hash)
        next result if requirement.required? && requirement.failure?
        next result if requirement.optional? && requirement.success? && !requirement.key_exists?
        result << check_type(rule, verifiable_hash)
        result << check_filled(rule, verifiable_hash)
        result << check_nested(rule, verifiable_hash)
      end
    end

    private

    # @param rule [SmartCore::Schema::Checker::Rules::Base]
    # @param verifiable_hash [SmartCore::Schema::Checker::VerifiableHash]
    # @return [SmartCore::Schema::Checker::Rules::Requirement::Result]
    #
    # @api private
    # @since 0.1.0
    def check_requirement(rule, verifiable_hash)
      rule.requirement.validate(verifiable_hash)
    end

    # @param rule [SmartCore::Schema::Checker::Rules::Base]
    # @param verifiable_hash [SmartCore::Schema::Checker::VerifiableHash]
    # @return [SmartCore::Schema::Checker::Rules::Result::Success]
    # @return [SmartCore::Schema::Checker::Rules::Result::Failure]
    #
    # @api private
    # @since 0.1.0
    def check_type(rule, verifiable_hash)
      rule.options.type.validate(verifiable_hash)
    end

    # @param rule [SmartCore::Schema::Checker::Rules::Base]
    # @param verifiable_hash [SmartCore::Schema::Checker::VerifiableHash]
    # @return [SmartCore::Schema::Checker::Rules::Result::Success]
    # @return [SmartCore::Schema::Checker::Rules::Result::Failure]
    #
    # @api private
    # @since 0.1.0
    def check_filled(rule, verifiable_hash)
      rule.options.filled.validate(verifiable_hash)
    end

    # @param rule [SmartCore::Schema::Checker::Rules::Base]
    # @param verifiable_hash [SmartCore::Schema::Checker::VerifiableHash]
    # @return [SmartCore::Schema::Checker::Reconciler::Matcher::Result]
    #
    # @api private
    # @since 0.1.0
    def check_nested(rule, verifiable_hash)
      return unless rule.nested_reconciler
      rule.nested_reconciler.__match!(verifiable_hash.extract(rule.schema_key))
    end
  end
end
