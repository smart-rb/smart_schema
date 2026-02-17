# frozen_string_literal: true

module SmartCore::Schema::TypeSystem
  # @api private
  # @since 0.12.0
  class SmartTypes::AbstractFactory < Interop::AbstractFactory
    class << self
      # @param type [SmartCore::Types::Primitive]
      # @return [void]
      #
      # @raise [SmartCore::Schema::IncorrectTypeObjectError]
      #
      # @api private
      # @since 0.12.0
      def prevent_incompatible_type!(type)
        unless type.is_a?(SmartCore::Types::Primitive)
          raise(
            SmartCore::Schema::IncorrectTypeObjectError,
            'Incorrect SmartCore::Types primitive ' \
            '(type object should be a type of SmartCore::Types::Primitive)'
          )
        end
      end

      # @param type [Any]
      # @return [String]
      #
      # @api private
      # @since 0.12.0
      def build_identifier(type)
        type.name
      end

      # @param type [SmartCore::Types::Primitive]
      # @return [SmartCore::Schema::TypeSystem::SmartTypes::Operation::Valid]
      #
      # @api private
      # @since 0.12.0
      def build_valid_operation(type)
        SmartTypes::Operation::Valid.new(type)
      end

      # @return [SmartCore::Types::Value::Any]
      #
      # @api private
      # @since 0.12.0
      def generic_type_object
        SmartCore::Types::Value::Any
      end

      # @return [SmartCore::Types::Primitive]
      #
      # @api private
      # @since 0.12.0
      def primitive_type_class
        SmartCore::Types::Primitive
      end

      # @param type [SmartCore::Types::Primitive]
      # @return [SmartCore::Schema::TypeSystem::SmartTypes::Operation::Validate]
      #
      # @api private
      # @since 0.12.0
      def build_validate_operation(type)
        SmartTypes::Operation::Validate.new(type)
      end

      # @param type [SmartCore::Types::Primitive]
      # @return [SmartCore::Schema::TypeSystem::SmartTypes::Operation::Cast]
      #
      # @api private
      # @since 0.12.0
      def build_cast_operation(type)
        SmartTypes::Operation::Cast.new(type)
      end

      # @param identifier [String]
      # @param valid_op [SmartCore::Schema::TypeSystem::SmartTypes::Operation::Valid]
      # @param valid_op [SmartCore::Schema::TypeSystem::SmartTypes::Operation::Validate]
      # @param valid_op [SmartCore::Schema::TypeSystem::SmartTypes::Operation::Cast]
      # @return [SmartCore::Schema::TypeSystem::SmartTypes]
      #
      # @api private
      # @since 0.12.0
      # @version 0.5.1
      def build_interop(identifier, valid_op, validate_op, cast_op)
        SmartTypes.new(identifier, valid_op, validate_op, cast_op)
      end
    end
  end
end
