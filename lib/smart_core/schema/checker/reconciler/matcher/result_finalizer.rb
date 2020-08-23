# frozen_string_literal: true

# @api private
# @since 0.1.0
module SmartCore::Schema::Checker::Reconciler::Matcher::ResultFinalizer
  # @return [Proc]
  #
  # @api private
  # @since 0.1.0
  ERRORS_CONTAINER_BUILDER = -> { Hash.new { |hash, key| hash[key] = [] } }

  # @return [Proc]
  #
  # @api private
  # @since 0.1.0
  EXTRA_KEYS_CONTAINER_BUILDER = -> { Set.new }

  class << self
    # @param result [SmartCore::Schema::Checker::Reconciler::Matcher::Result]
    # @return [SmartCore::Schema::Result]
    #
    # @ai privates
    # @since 0.1.0
    def finalize(result)
      schema_errors = ERRORS_CONTAINER_BUILDER.call
      extra_keys = EXTRA_KEYS_CONTAINER_BUILDER.call
      aggregate_errors(result, schema_errors, extra_keys)
      build_final_result(result, schema_errors, extra_keys)
    end

    private

    # @param result [SmartCore::Schema::Checker::Reconciler::Matcher::Result]
    # @param schema_errors [Hash<String,Array<Symbol>>]
    # @param extra_keys [Set<String>]
    # @return [SmartCore::Schema::Result]
    #
    # @api private
    # @since 0.1.0
    def build_final_result(result, schema_errors, extra_keys)
      SmartCore::Schema::Result.new(
        result.verifiable_hash.source,
        schema_errors.freeze,
        extra_keys.freeze
      )
    end

    # @param result [SmartCore::Schema::Checker::Reconciler::Matcher::Result]
    # @param errors [Hash<String,Array<String>|Hash<String,Hash>>]
    # @param extra_keys [Set<String>]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def aggregate_errors(result, errors, extra_keys)
      result.each_result do |concrete_result|
        case concrete_result
        when SmartCore::Schema::Checker::Rules::Verifier::Result
          aggregate_verifier_errors(concrete_result, errors, extra_keys)
        when SmartCore::Schema::Checker::Rules::ExtraKeys::Failure
          aggregate_extra_keys_errors(concrete_result, errors, extra_keys)
        end
      end
    end

    # @param result []
    # @param errors []
    # @param extra_keys []
    # @return []
    #
    # @api private
    # @since 0.1.0
    def aggregate_verifier_errors(result, errors, extra_keys)
      result.each_result do |concrete_result|
        case concrete_result
        when SmartCore::Schema::Checker::Reconciler::Matcher::Result
          sub_schema_errors = ERRORS_CONTAINER_BUILDER.call
          sub_extra_keys = EXTRA_KEYS_CONTAINER_BUILDER.call
          aggregate_errors(concrete_result, sub_schema_errors, sub_extra_keys)
          errors[result.key] << [sub_schema_errors, sub_extra_keys]
        when SmartCore::Schema::Checker::Rules::Requirement::Result
          errors[concrete_result.key] << concrete_result.error if concrete_result.failure?
        when SmartCore::Schema::Checker::Rules::Result::Failure
          errors[concrete_result.key] << concrete_result.error
        end
      end
    end

    # @param result []
    # @param errors []
    # @param extra_keys []
    # @return []
    #
    # @api private
    # @since 0.1.0
    def aggregate_extra_keys_errors(result, errors, extra_keys)
      extra_keys << result.extra_keys
    end
  end
end

__END__

    # @param contract_result [
    #   SmartCore::Schema::Checker::Rules::Requirement::Result,
    #   SmartCore::Schema::checker::Rules::Result::Failure,
    #   SmartCore::Schema::checker::Rules::Result::Success,
    #   SmartCore::Schema::Checker::Rules::ExtraKeys::Success,
    #   SmartCore::Schema::Checker::Rules::ExtraKeys::Failure,
    #   SmartCore::Schema::Checker::Rules::Verifier::Result,
    #   SmartCore::Schema::Checker::Reconciler::Matcher::Result
    #   SmartCore::Schema::Result, ???
    # ]
    # @param errors
    # @param extra_keys
    # @return []
    #
    # @api private
    # @since 0.1.0
    def aggregate_contract_errors(contract_result, errors, extra_keys)
      puts 'AGGREGATE_CONTRACT_ERRORS'
      puts contract_result.class
      case contract_result
      when SmartCore::Schema::Checker::Rules::Requirement::Result
        aggregate_requirement_errors(contract_result, errors)
      when SmartCore::Schema::Checker::Rules::Result::Failure
        aggregate_rules_errors(contract_result, errors)
      when SmartCore::Schema::Checker::Rules::ExtraKeys::Failure
        binding.pry
        aggregate_extra_keys_errors(contract_result, extra_keys)
      when SmartCore::Schema::Checker::Rules::Verifier::Result
        aggregate_verifier_errors(contract_result, errors, extra_keys)
      when SmartCore::Schema::Checker::Reconciler::Matcher::Result
        aggregate_matcher_errors(contract_result, errors, extra_keys)
      when SmartCore::Schema::Result
        aggregate_final_errors(contract_result, errors, extra_keys)
      end
    end

    def aggregate_extra_keys_errors(extra_keys_result, extra_keys)
      puts extra_keys_result.class
      case extra_keys_result
      when SmartCore::Schema::Checker::Rules::ExtraKeys::Failure
        aggregate_extra_key_error(extra_keys_result, extra_keys)
      end
    end

    # @param result [SmartCore::Schema::Checker::Rules::Requirement::Result]
    # @param errors [Hash]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def aggregate_requirement_errors(result, errors)
      # raise 'aggregate_requirement_errors'
      errors[result.key] << result.error if result.failure?
    end

    # @param result [SmartCore::Schema::Checker::Rules::Result::Failure]
    # @param errors [Hash]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def aggregate_rules_errors(result, errors)
      # raise 'aggregate_rules_errors'
      errors[result.key] << result.error
    end

    # @param result [SmartCore::Schema::Checker::Rules::ExtraKeys::Failure]
    # @param errors [Hash]
    # @param extra_keys [Set<String>]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def aggregate_extra_key_error(result, extra_keys)
      # raise 'aggregate_extra_keys_errors'
      extra_keys.merge(result.extra_keys)
    end

    # @param result [SmartCore::Schema::Checker::Rules::Verifier::Result]
    # @param errors [Hash]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def aggregate_verifier_errors(result, errors, extra_keys)
      # raise 'aggregate_verifier_errors'
      result.each do |verifier_result|
        errors[result.key] << aggregate_contract_errors(
          verifier_result, errors, extra_keys
        )
      end
    end

    # @param result [SmartCore::Schema::Checker::Reconciler::Matcher::Result]
    # @param errors [Hash]
    # @param extra_keys [Set<String>]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def aggregate_matcher_errors(result, errors, extra_keys)
      # raise 'aggregate_matcher_errors'
    end

    # @param result [SmartCore::Schema::Result]
    # @param errors [Hash]
    # @param extra_keys [Set<String>]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def aggregate_final_errors(result, errors, extra_keys)
      # raise 'aggregate_final_errors'
    end
  end
end
