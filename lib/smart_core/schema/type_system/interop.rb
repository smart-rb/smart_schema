# frozen_string_literal: true

# @abstract
# @api private
# @since 0.12.0
class SmartCore::Schema::TypeSystem::Interop
  require_relative 'interop/operation'
  require_relative 'interop/abstract_factory'
  require_relative 'interop/aliasing'

  # @since 0.12.0
  include SmartCore::Schema::TypeSystem::Interop::Aliasing

  class << self
    # @param type_object [Any]
    # @return [SmartCore::Schema::TypeSystem::Interop]
    #
    # @api private
    # @since 0.12.0
    def create(type_object)
      self::AbstractFactory.create(type_object)
    end

    # @return [SmartCore::Schema::TypeSystem::Interop]
    #
    # @api private
    # @since 0.12.0
    def generic_type_object
      self::AbstractFactory.generic_type_object
    end

    # @param type_object [Any]
    # @return [void]
    #
    # @raise [SmartCore::Schema::IncorrectTypeObjectError]
    #
    # @api private
    # @since 0.12.0
    def prevent_incompatible_type!(type_object)
      self::AbstractFactory.prevent_incompatible_type!(type_object)
    end

    # @return [Any]
    #
    # @api private
    # @since 0.12.0
    def primitive_type_class
      self::AbstractFactory.primitive_type_class
    end
  end

  # @return [String]
  #
  # @api private
  # @since 0.5.1
  attr_reader :identifier

  # @param identifier [String]
  # @param valid_op [SmartCore::Schema::TypeSystem::Interop::Operation]
  # @param validate_op [SmartCore::Schema::TypeSystem::Interop::Operation]
  # @param cast_op [SmartCore::Schema::TypeSystem::Interop::Operation]
  # @return [void]
  #
  # @api private
  # @since 0.12.0
  # @version 0.5.1
  def initialize(identifier, valid_op, validate_op, cast_op)
    @identifier = identifier
    @valid_op = valid_op
    @validate_op = validate_op
    @cast_op = cast_op
  end

  # @param value [Any]
  # @return [Boolean]
  #
  # @api private
  # @since 0.12.0
  def valid?(value)
    valid_op.call(value)
  end

  # @param value [Any]
  # @return [void]
  #
  # @api private
  # @since 0.12.0
  def validate!(value)
    validate_op.call(value)
  end

  # @param value [Any]
  # @return [Any]
  #
  # @api private
  # @since 0.12.0
  def cast(value)
    cast_op.call(value)
  end

  private

  # @return [SmartCore::Schema::TypeSystem::Interop::Operation]
  #
  # @api private
  # @since 0.12.0
  attr_reader :valid_op

  # @return [SmartCore::Schema::TypeSystem::Interop::Operation]
  #
  # @api private
  # @since 0.12.0
  attr_reader :validate_op

  # @return [SmartCore::Schema::TypeSystem::Interop::Operation]
  #
  # @api private
  # @since 0.12.0
  attr_reader :cast_op
end
