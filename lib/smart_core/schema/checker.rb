# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Schema::Checker
  require_relative 'checker/rules'
  require_relative 'checker/commands'
  require_relative 'checker/reconciler'
  require_relative 'checker/result'

  # @return [BasicObject]
  #
  # @api private
  # @since 0.1.0
  EmptyValue = Class.new(BasicObject) { include SmartCore::Engine::Frozener::Mixin }.new.freeze

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

  # @param verifiable_hash [Hash<String|Symbol,Any>]
  # @return [?]
  #
  # @api private
  # @since 0.1.0
  def check!(verifiable_hash)
    schema_definitions.each do |schema_definition|
      schema_definition.call(verifiable_hash)
    end
  end

  # @param definitions [Block]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def append_schema_definitions(&definitions)
    thread_safe { add_schema_command(&definitions) }
  end

  # @param schema_key [String, Symbol]
  # @param validator_klass [SmartCore::Schema::Checker::EmptyValue, Class<?>]
  # @param validation [Block]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def define_validator(schema_key, validator_klass, &validation)
    thread_safe { add_validate_command(schema_key, validator_klass, &validation) }
  end

  # @param schema_key [String, Symbol]
  # @param default_value [SmartCore::Schema::Checker::EmptyValue, Any]
  # @param expression [Block]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def set_default_value(schema_key, default_value, &expression)
    thread_safe { add_default_command(schema_key, default_value, &expression) }
  end

  # @param schema_key [String, Symbol]
  # @param expression [Block]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def set_value_finalizer(schema_key, &expression)
    thread_safe { add_finalize_command(schema_key, &expression) }
  end

  # @param another_checker [SmartCore::Schema::Checker]
  # @return [SmartCore::Schema::Checker]
  #
  # @api private
  # @since 0.1.0
  def combine_with(another_checker)
    thread_safe { self } # TODO: merge definitions and return self
  end

  private

  # @return [Array<SmartCore::Schema::Checker::Commands::Schema>]
  #
  # @api private
  # @since 0.1.0
  attr_reader :schema_definitions

  # @return [Hash<String,SmartCore::Schema::Checker::Commands::Default>]
  #
  # @api private
  # @since 0.1.0
  attr_reader :defaults

  # @return [Hash<String,SmartCore::Schema::Checker::Commands::Validate>]
  #
  # @api private
  # @since 0.1.0
  attr_reader :validators

  # @return [Hash<String,SmartCore::Schema::Checker::Commands::Finalize>]
  #
  # @api private
  # @since 0.1.0
  attr_reader :finalizers

  # @param definitions [Block]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def add_schema_command(&definitions)
    raise(SmartCore::Schema::ArgumentError, <<~ERROR_MESSAGE) unless definitions
      Schema definitions is not provided (you should provide Block argument)
    ERROR_MESSAGE

    schema_definitions << SmartCore::Schema::Checker::Commands::Schema.new(definitions)
  end

  # @param schema_key [String, Symbol]
  # @param validator_klass [SmartCore::Schema::Checker::EmptyValue, Class<?>]
  # @param validation [Block]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def add_validate_command(schema_key, validator_klass, &validation)
    SmartCore::Schema::KeyControl.prevent_incompatible!(schema_key)

    if validator_klass != EmptyValue && !validator_klass.is_a?(::Class) # TODO: Validator class
      raise(SmartCore::Schema::ArgumentError, <<~ERROR_MESSAGE)
      ERROR_MESSAGE
    end

    raise(SmartCore::Schema::ArgumentError, <<~ERROR_MESSAGE) unless validation
    ERROR_MESSAGE

    normalized_schema_key = SmartCore::Schema::KeyControl.normalize(schema_key)

    validators[normalized_schema_key] = SmartCore::Schema::Checker::Commands::Validate.new(
      normalized_schema_key, validator_klass, validation
    )
  end

  # @param schema_key [String, Symbol]
  # @param default_value [SmartCore::Schema::Checker::EmptyValue, Any]
  # @param expression [Block]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def add_default_command(schema_key, default_value, &expression)
    SmartCore::Schema::KeyControl.prevent_incompatible!(schema_key)

    raise(SmartCore::Schema::ArgumentError, <<~ERROR_MESSAGE) unless expression
    ERROR_MESSAGE

    normalized_schema_key = SmartCore::Schema::KeyControl.normalize(schema_key)

    defaults[normalized_schema_key] = SmartCore::Schema::Checker::Commands::Default.new(
      normalized_schema_key, default_value, expression
    )
  end

  # @param schema_key [String, Symbol]
  # @param expression [Block]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def add_finalize_command(schema_key, &expression)
    SmartCore::Schema::KeyControl.prevent_incompatible!(schema_key)

    raise(SmartCore::Schema::ArgumentError, <<~ERROR_MESSAGE) unless expression
    ERROR_MESSAGE

    normalized_schema_key = SmartCore::Schema::KeyControl.normalize(schema_key)

    defaults[normalized_schema_key] = SmartCore::Schema::Checker::Commands::Finalize.new(
      normalized_schema_key, expression
    )
  end

  # @param block [Block]
  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def thread_safe(&block)
    @lock.synchronize(&block)
  end
end
