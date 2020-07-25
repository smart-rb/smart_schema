# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Schema::Checker::Rules::Base
  # @return [String]
  #
  # @api private
  # @since 0.1.0
  attr_reader :schema_key

  # @param schema_key [String, Symbol]
  # @param nested_definitions [Block]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(schema_key, &nested_definitions)
    SmartCore::Schema::KeyControl.prevent_incompatible!(schema_key)

    @schema_key = SmartCore::Schema::KeyControl.normalize(schema_key)
    @nested_reconciler = nil

    define_nested_reconciler(&nested_definitions)
  end

  private

  # @return [NilClass, SmartCore::Schema::Checker::Reconciler]
  #
  # @api private
  # @since 0.1.0
  attr_reader :nested_reconciler

  # @param nested_definitions [Block]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def define_nested_reconciler(&nested_definitions)
    return unless block_given?
    @nested_reconciler = SmartCore::Schema::Checker::Reconciler.create(nested_definitions)
  end
end
