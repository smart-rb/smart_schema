# frozen_string_literal: true

module SmartCore::Schema::TypeSystem
  # @api private
  # @since 0.12.0
  class DryTypes::AbstractFactory < Interop::AbstractFactory
    class << self
      # @param type [::Dry::Types::Type]
      # @return [void]
      #
      # @raise [SmartCore::Schema::IncorrectTypeObjectError]
      #
      # @api private
      # @since 0.12.0
      def prevent_incompatible_type!(type)
        unless type.is_a?(::Dry::Types::Type)
          raise(
            SmartCore::Schema::IncorrectTypeObjectError,
            'Incorrect Dry::Types primitive ' \
            '(type object should be an object of Dry::Types::Type)'
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

      # @param type [::Dry::Types::Type]
      # @return [SmartCore::Schema::TypeSystem::DryTypes::Operation::Valid]
      #
      # @api private
      # @since 0.12.0
      def build_valid_operation(type)
        DryTypes::Operation::Valid.new(type)
      end

      # @return [::Dry::Types::Any]
      #
      # @api private
      # @since 0.12.0
      def generic_type_object
        ::Dry::Types::Any
      end

      # @return [Class<::Dry::Types::Type>]
      #
      # @api private
      # @since 0.12.0
      def primitive_type_class
        ::Dry::Types::Type
      end

      # @return [::Dry::Types::Type]
      #
      # @api private
      # @since 0.12.1
      def hash_type_object_for_nested_schemas
        ::Dry::Types['hash']
      end

      # @param type [::Dry::Types::Type]
      # @return [SmartCore::Schema::TypeSystem::DryTypes::Operation::Validate]
      #
      # @api private
      # @since 0.12.0
      def build_validate_operation(type)
        DryTypes::Operation::Validate.new(type)
      end

      # @param type [::Dry::Types::Type]
      # @return [SmartCore::Schema::TypeSystem::DryTypes::Operation::Cast]
      #
      # @api private
      # @since 0.12.0
      def build_cast_operation(type)
        DryTypes::Operation::Cast.new(type)
      end

      # @param identifier [String]
      # @param valid_op [SmartCore::Schema::TypeSystem::DryTypes::Operation::Valid]
      # @param valid_op [SmartCore::Schema::TypeSystem::DryTypes::Operation::Validate]
      # @param valid_op [SmartCore::Schema::TypeSystem::DryTypes::Operation::Cast]
      # @return [SmartCore::Schema::TypeSystem::DryTypes]
      #
      # @api private
      # @since 0.12.0
      # @version 0.5.1
      def build_interop(identifier, valid_op, validate_op, cast_op)
        DryTypes.new(identifier, valid_op, validate_op, cast_op)
      end
    end
  end
end
