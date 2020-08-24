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
  end
end
