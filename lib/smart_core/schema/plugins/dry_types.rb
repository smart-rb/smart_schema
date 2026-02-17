# frozen_string_literal: true

# @api private
# @since 0.12.0
class SmartCore::Schema::Plugins::DryTypes < SmartCore::Schema::Plugins::Abstract
  class << self
    # @return [void]
    #
    # @api private
    # @since 0.12.0
    def install!
      raise(
        SmartCore::Schema::UnresolvedPluginDependencyError,
        '::Dry::Types does not exist or "dry-types" gem is not loaded'
      ) unless const_defined?('::Dry::Types')

      # NOTE: add dry-types type system implementation
      require_relative 'dry_types/errors'
      require_relative 'dry_types/dry_types'

      # NOTE: register thy-types type system
      SmartCore::Schema::TypeSystem.register(
        :dry_types, SmartCore::Schema::TypeSystem::DryTypes
      )
    end
  end
end
