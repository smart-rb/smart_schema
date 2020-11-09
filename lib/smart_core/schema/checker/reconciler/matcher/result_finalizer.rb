# frozen_string_literal: true

# @api private
# @since 0.1.0
module SmartCore::Schema::Checker::Reconciler::Matcher::ResultFinalizer
  # @return [Proc]
  #
  # @api private
  # @since 0.1.0
  ERRORS_CONTAINER_BUILDER = -> { Hash.new { |hash, key| hash[key] = Set.new } }

  # @return [Proc]
  #
  # @api private
  # @since 0.1.0
  EXTRA_KEYS_CONTAINER_BUILDER = -> { Set.new }

  # @return [Symbol]
  #
  # @api private
  # @since 0.2.0
  EXTRA_KEY_ERROR_CODE = :extra_key

  class << self
    # @param result [SmartCore::Schema::Checker::Reconciler::Matcher::Result]
    # @return [SmartCore::Schema::Result]
    #
    # @ai privates
    # @since 0.1.0
    def finalize(result)
      schema_errors, extra_keys = aggregate_errors(result)
      schema_errors, extra_keys = compile_errors(schema_errors, extra_keys)
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
    # @return [Array<Hash<String,Any>,Set<String>>]
    #
    # @api private
    # @since 0.1.0
    def aggregate_errors(result)
      schema_errors = ERRORS_CONTAINER_BUILDER.call
      extra_keys = EXTRA_KEYS_CONTAINER_BUILDER.call

      result.each_result do |concrete_result|
        case concrete_result
        when SmartCore::Schema::Checker::Rules::Verifier::Result
          aggregate_verifier_errors(concrete_result, schema_errors)
        when SmartCore::Schema::Checker::Rules::ExtraKeys::Failure
          aggregate_extra_keys_errors(concrete_result, extra_keys)
        end
      end

      [schema_errors, extra_keys]
    end

    # @param result [SmartCore::Schema::Checker::Rules::Verifier::Result]
    # @param errors [Hash<String,Array<String>|Hash<String,Hash>>]
    # @param extra_keys [Set<String>]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def aggregate_verifier_errors(result, errors)
      result.each_result do |concrete_result|
        case concrete_result
        when SmartCore::Schema::Checker::Reconciler::Matcher::Result
          sub_schema_errors, sub_extra_keys = aggregate_errors(concrete_result)
          errors[result.key] << [sub_schema_errors, sub_extra_keys]
        when SmartCore::Schema::Checker::Rules::Requirement::Result
          errors[concrete_result.key] << concrete_result.error if concrete_result.failure?
        when SmartCore::Schema::Checker::Rules::Result::Failure
          errors[concrete_result.key] << concrete_result.error
        end
      end
    end

    # @param result [SmartCore::Schema::Checker::Rules::ExtraKeys::Failure]
    # @param extra_keys [Set<String>]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def aggregate_extra_keys_errors(result, extra_keys)
      extra_keys.merge(result.extra_keys)
    end

    # @param errors [Hash]
    # @param extra_keys [Set]
    # @return [Array<Hash<String,Array<Symbol>>,Set<String>]
    #
    # @api private
    # @since 0.1.0
    def compile_errors(errors, extra_keys, initial_error_key = nil)
      compiled_errors = ERRORS_CONTAINER_BUILDER.call
      compiled_extra_keys = EXTRA_KEYS_CONTAINER_BUILDER.call

      compiled_extra_keys.merge(extra_keys).map! do |key|
        # dot-notated nested keys
        initial_error_key ? "#{initial_error_key}.#{key}" : key
      end

      errors.each_pair do |key, error_set|
        # dot-notated nested key
        compiled_key = initial_error_key ? "#{initial_error_key}.#{key}" : key

        error_set.each do |error|
          case error
          when Symbol # error code
            compiled_errors[compiled_key] << error
          when Array # nested errors
            sub_errors, sub_extra_keys = error
            compiled_sub_errors, compiled_sub_extra_keys = compile_errors(
              sub_errors, sub_extra_keys, compiled_key
            )
            compiled_errors.merge!(compiled_sub_errors)
            compiled_extra_keys.merge(compiled_sub_extra_keys)
          end
        end
      end

      compiled_extra_keys.each do |compiled_extra_key|
        compiled_errors[compiled_extra_key] << EXTRA_KEY_ERROR_CODE
      end

      [compiled_errors, compiled_extra_keys]
    end
  end
end
