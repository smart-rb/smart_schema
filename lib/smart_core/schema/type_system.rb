# frozen_string_literal: true

# @api pulic
# @since 0.12.0
module SmartCore::Schema::TypeSystem
  require_relative 'type_system/interop'
  require_relative 'type_system/registry'
  require_relative 'type_system/smart_types'
  require_relative 'type_system/registry_interface'

  # @since 0.12.0
  extend SmartCore::Schema::TypeSystem::RegistryInterface

  # @since 0.12.0
  register(:smart_types, SmartCore::Schema::TypeSystem::SmartTypes)
end
