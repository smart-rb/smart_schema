# frozen_string_literal: true

# @api private
# @since 0.1.0
module SmartCore::Schema::DSL
  class << self
    # @param base_klass [Class]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def included(base_klass)
      base_klass.instance_variable_set(:@__schema_checker__, SmartCore::Schema::Checker.new)
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
        :@__schema_checker__,
        SmartCore::Schema::Checker.new.combine_with(__schema_checker__)
      )
      child_klass.singleton_class.prepend(ClassInheritance)
      super
    end
  end

  # @api private
  # @since 0.1.0
  module ClassMethods
    # @return [SmartCore::Schema::Checker]
    #
    # @api private
    # @since 0.1.0
    def __schema_checker__
      @__schema_checker__
    end

    # @param definitions [Block]
    # @return [void]
    #
    # @api public
    # @since 0.1.0
    def schema(&definitions)
      __schema_checker__.append_schema_definitions(&definitions)
    end

    # @param schema_key [String, Symbol]
    # @param validator [SmartCore::Schema::Checker::EmptyValue, Class<?>]
    # @param validation [Block]
    # @return [void]
    #
    # @api public
    # @since 0.1.0
    def validate(
      schema_key,
      validator_klass = SmartCore::Schema::Checker::EmptyValue,
      &validation
    )
      __schema_checker__.define_validator(schema_key, validator_klass, &validation)
    end

    # @param schema_key [String, Symbol]
    # @param value [SmartCore::Schema::Checker::EmptyValue, Any]
    # @param expression [Block]
    # @return [void]
    #
    # @api public
    # @since 0.1.0
    def default(
      schema_key,
      value = SmartCore::Schema::Checker::EmptyValue,
      &expression
    )
      __schema_checker__.set_default_value(schema_key, value, &expression)
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
      __schema_checker__.set_value_finalizer(schema_key, &expression)
    end
  end
end
