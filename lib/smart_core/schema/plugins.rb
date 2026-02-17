# frozen_string_literal: true

# @api private
# @since 0.12.0
module SmartCore::Schema::Plugins
  require_relative 'plugins/abstract'
  require_relative 'plugins/registry'
  require_relative 'plugins/registry_interface'
  require_relative 'plugins/access_mixin'
  require_relative 'plugins/dry_types'

  # @since 0.12.0
  extend SmartCore::Schema::Plugins::RegistryInterface

  # @since 0.12.0
  register_plugin('dry_types', SmartCore::Schema::Plugins::DryTypes)
end
