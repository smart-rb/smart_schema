# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Schema::Checker::Rules::Required < SmartCore::Schema::Checker::Rules::Base
  # @return [SmartCore::Schema::Checker::Rules::Requirement::Required]
  #
  # @api private
  # @since 0.1.0
  attr_reader :requirement

  # @param schema_key [String, Symbol]
  # @param nested_definitions [Block]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(schema_key, &nested_definitions)
    super(schema_key, &nested_definitions)
    @requirement = SmartCore::Schema::Checker::Rules::Requirement::Required.new(self)
  end
end
