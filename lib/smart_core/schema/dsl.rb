# frozen_string_literal: true

# @api private
# @since 0.1.0
module SmartCore::Schema::DSL
  require_relative 'dsl/commands'

  # @return [NilClass]
  #
  # @api private
  # @since 0.1.0
  NO_VALIDATOR_CLASS = nil

  class << self
    # @param base_klass [Class]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def included(base_klass)
      base_klass.instance_variable_set(:@__schema_constructor__, SmartCore::Schema::Constructor.new)
      base_klass.extend(ClassMethods)
      base_klass.singleton_class.prepend(ClassInheritance)
    end
  end

  # @api private
  # @since 0.1.0
  module ClassInheritance
    # @param child_klass [Class]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def inherited(child_klass)
      child_klass.instance_variable_set(
        :@__schema_constructor__,
        SmartCore::Schema::Constructor.new.combine_with(__schema_constructor__)
      )
      child_klass.singleton_class.prepend(ClassInheritance)
      super
    end
  end

  # @api private
  # @since 0.1.0
  module ClassMethods
    # @return [SmartCore::Schema::Constructor]
    #
    # @api private
    # @since 0.1.0
    def __schema_constructor__
      @__schema_constructor__
    end

    # @param definitions [Block]
    # @return [void]
    #
    # @api public
    # @since 0.1.0
    def schema(&definitions)
      __schema_constructor__.append_schema_definitions(&definitions)
    end

    # @param schema_key [String, Symbol]
    # @param validator [SmartCore::Schema::Constructor::EmptyValue, Class<???>]
    # @param validation [Block]
    # @return [void]
    #
    # @api public
    # @since 0.1.0
    def validate(
      schema_key,
      validator_klass = SmartCore::Schema::Constructor::EmptyValue,
      &validation
    )
      __schema_constructor__.define_validator(schema_key, validator_klass, &validation)
    end

    # @param schema_key [String, Symbol]
    # @param value [SmartCore::Schema::Constructor::EmptyValue, Any]
    # @param expression [Block]
    # @return [void]
    #
    # @api public
    # @since 0.1.0
    def default(
      schema_key,
      value = SmartCore::Schema::Constructor::EmptyValue,
      &expression
    )
      __schema_constructor__.set_default_value(schema_key, value, &expression)
    end

    # @param schema_key [String, Symbol]
    # @param expression [Block]
    # @yield [schema_value]
    # @yieldparam schema_value [Any]
    # @return [void]
    #
    # @api public
    # @since 0.1.0
    def finalize(schema_key, &expression)
      __schema_constructor__.set_value_finalizer(schema_key, &expression)
    end
  end
end
