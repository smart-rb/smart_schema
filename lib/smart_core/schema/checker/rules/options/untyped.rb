# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Schema::Checker::Rules::Options::Untyped
  # @param schema_key [String]
  # @param schema_value [Any]
  # @return [?]
  #
  # @api private
  # @since 0.1.0
  def validate(schema_key, schema_value)
    SmartCore::Schema::Checker::Result::PreSuccess.new(schema_key, schema_value)
  end
end
