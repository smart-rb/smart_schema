# frozen_string_literal: true

# rubocop:disable Style/StaticClass
class SmartCore::Schema
  # @api public
  # @since 0.1.0
  Error = Class.new(SmartCore::Error)

  # @api public
  # @since 0.1.0
  ArgumentError = Class.new(SmartCore::ArgumentError)

  # @api public
  # @since 0.12.0
  NoTypeAliasError = Class.new(Error)

  # @api public
  # @since 0.12.0
  PluginError = Class.new(Error)

  # @api public
  # @since 0.12.0
  UnresolvedPluginDependencyError = Class.new(PluginError)

  # @api public
  # @since 0.12.0
  AlreadyRegisteredPluginError = Class.new(PluginError)

  # @api public
  # @since 0.12.0
  UnregisteredPluginError = Class.new(PluginError)

  # @api public
  # @since 0.12.0
  TypeSystemError = Class.new(Error)

  # @api public
  # @since 0.5.1
  IncorrectTypeError = Class.new(TypeSystemError)

  # @api public
  # @since 0.12.0
  TypeAliasNotFoundError = Class.new(TypeSystemError)

  # @api public
  # @since 0.12.0
  IncorrectTypeSystemInteropError = Class.new(TypeSystemError)

  # @api public
  # @since 0.12.0
  IncorrectTypeObjectError = Class.new(TypeSystemError)

  # @api public
  # @since 0.12.0
  UnsupportedTypeSystemError = Class.new(TypeSystemError)

  # @api public
  # @since 0.12.0
  UnsupportedTypeOperationError = Class.new(TypeSystemError)

  # @api public
  # @since 0.12.0
  TypeCastingUnsupportedError = Class.new(UnsupportedTypeOperationError)
end
# rubocop:enable Style/StaticClass
