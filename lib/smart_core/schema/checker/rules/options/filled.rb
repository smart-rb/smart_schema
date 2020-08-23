# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Schema::Checker::Rules::Options
  class Filled < Empty
    # @note Constant is used only for clarity (for other developers).
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
          message: 'TODO: меседж что поле должно быть filled (not null)'
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
      schema_value == nil
    end
  end
end