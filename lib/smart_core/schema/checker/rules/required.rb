# frozen_string_literal: true

# @api private
# @since 0.1.0
# @version 0.3.0
class SmartCore::Schema::Checker::Rules::Required < SmartCore::Schema::Checker::Rules::Base
  # @return [SmartCore::Schema::Checker::Rules::Requirement::Required]
  #
  # @api private
  # @since 0.1.0
  attr_reader :requirement

  # @param root_reconciler [SmartCore::Schema::Checker::Reconciler]
  # @param schema_key [String, Symbol]
  # @param nested_definitions [Block]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  # @version 0.3.0
  def initialize(root_reconciler, schema_key, &nested_definitions)
    super(root_reconciler, schema_key, &nested_definitions)
    @requirement = SmartCore::Schema::Checker::Rules::Requirement::Required.new(self)
  end
end
