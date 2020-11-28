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
  # @version 0.2.0
  module ClassMethods
    # @return [SmartCore::Schema::Checker]
    #
    # @api private
    # @since 0.1.0
    def __schema_checker__
      @__schema_checker__
    end

    # @note nil strict mode means `do not change current mode`
    # @param strict_mode [NilClass, String, Symbol]
    # @param definitions [Block]
    # @return [void]
    #
    # @api public
    # @since 0.1.0
    # @version 0.2.0
    def schema(strict_mode = nil, &definitions)
      __schema_checker__.invoke_in_pipe do
        set_strict_mode(strict_mode)
        append_schema_definitions(&definitions)
      end
    end

    # @return [void]
    #
    # @api public
    # @since 0.2.0
    def strict!
      __schema_checker__.set_strict_mode(:strict)
    end

    # @return [void]
    #
    # @api public
    # @since 0.2.0
    def non_strict!
      __schema_checker__.set_strict_mode(:non_strict)
    end
  end
end
