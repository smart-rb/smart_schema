# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Schema::Checker::Rules::Options::Empty
  # @param schema_key [String]
  # @param schema_value [Any]
  # @return [SmartCore::Schema::Checker::Rules::Result::Success]
  #
  # @api private
  # @since 0.1.0
  def validate(schema_key, schema_value)
    SmartCore::Schema::Checker::Rules::Result::Success.new(
      key: schema_key,
      value: schema_value
    )
  end
end
