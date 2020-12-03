# frozen_string_literal: true

class SmartCore::Schema::Checker::Rules::Options
  # @api private
  # @since 0.1.0
  class Filled < Empty
    # @note Constant is used only for other developers.
    # @return [Symbol]
    #
    # @api private
    # @since 0.1.0
    ERROR_CODE = :non_filled

    # @param verifiable_hash [SmartCore::Schema::Checker::VerifiableHash]
    # @return [SmartCore::Schema::Checker::Rules::Result::Success]
    # @return [SmartCore::Schema::Checker::Rules::Result::Failure]
    #
    # @api private
    # @since 0.1.0
    def validate(verifiable_hash)
      schema_value = verifiable_hash[schema_key]

      if non_filled?(schema_value)
        SmartCore::Schema::Checker::Rules::Result::Failure.new(
          key: schema_key,
          value: schema_value,
          error: ERROR_CODE,
          message: 'Requires to be filled'
        )
      else
        SmartCore::Schema::Checker::Rules::Result::Success.new(
          key: schema_key,
          value: schema_value
        )
      end
    end

    private

    # @param value [Any]
    # @return [Boolean]
    #
    # @api private
    # @since 0.1.0
    def non_filled?(value)
      value == nil
    end
  end
end
