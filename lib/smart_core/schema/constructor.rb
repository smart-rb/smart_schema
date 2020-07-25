# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Schema::Constructor
  # @return [Class<BasicObject>]
  #
  # @api private
  # @since 0.1.0
  EmptyValue = Class.new(BasicObject) { include SmartCore::Engine::Frozener::Mixin }

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize
    @schema_definitions = []
    @defaults = {}
    @validators = {}
    @finalizers = {}
    @lock = SmartCore::Engine::Lock.new
  end

  # @param definitions [Block]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def append_schema_definitions(&definitions)
  end

  # @param schema_key [String, Symbol]
  # @param validator_klass [SmartCore::Schema::Constructor::EmptyValue, Class<???>]
  # @param validation [Block]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def define_validator(schema_key, validator_klass, &validation)
  end

  # @param schema_key [String, Symbol]
  # @param default_value [SmartCore::Schema::Constructor::EmptyValue, Any]
  # @param expression [Block]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def set_default_value(schema_key, default_value, &expression)
  end

  # @param schema_key [String, Symbol]
  # @param expression [Block]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def set_value_finalizer(schema_key, &expression)
  end

  # @param another_constructor [SmartCore::Schema::Constructor]
  # @return [SmartCore::Schema::Constructor]
  #
  # @api private
  # @since 0.1.0
  def combine_with(another_constructor)
    self # TODO: merge definitions and return self
  end

  private

  # @return [Hash<String,?>]
  #
  # @api private
  # @since 0.1.0
  attr_reader :defaults

  # @return [Hash<String,?>]
  #
  # @api private
  # @since 0.1.0
  attr_reader :validators

  # @return [Hash<String,?>]
  #
  # @api private
  # @since 0.1.0
  attr_reader :finalizers

  # @return [?]
  #
  # @api private
  # @since 0.1.0
  attr_reader :schema_definitions

  # @param block [Block]
  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def thread_safe(&block)
    @lock.synchronize(&block)
  end
end
