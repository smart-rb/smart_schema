    def aggregate_errors(result, errors, extra_keys)
      result.contract_keys_results.each do |contract_result|
        aggregate_contract_errors(result, errors, extra_keys)
      end

      result.extra_keys_results.each do |extra_keys_result|
        aggregate_extra_keys_errors(extra_keys_result, extra_keys)
      end
    end

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
