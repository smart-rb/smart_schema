# frozen_string_literal: true

# @api private
# @since 0.12.0
module SmartCore::Schema::Plugins::AccessMixin
  # @param plugin_name [Symbol, String]
  # @return [void]
  #
  # @see SmartCore::Schema::Plugins
  #
  # @api public
  # @since 0.12.0
  def plugin(plugin_name)
    SmartCore::Schema::Plugins.load(plugin_name)
  end

  # @return [Array<String>]
  #
  # @see SmartCore::Schema::Plugins
  #
  # @api public
  # @since 0.12.0
  def plugins
    SmartCore::Schema::Plugins.names
  end

  # @return [Hash<String,Class<SmartCore::Schema::Plugins::Abstract>>]
  #
  # @api private
  # @since 0.12.0
  def loaded_plugins
    SmartCore::Schema::Plugins.loaded_plugins
  end
  alias_method :enabled_plugins, :loaded_plugins

  # @param plugin_name [String, Symbol]
  # @param plugin_klass [Class<SmartCore::Schema::Plugins::Abstract>]
  # @return [void]
  #
  # @see SmartCore::Schema::Plugins
  #
  # @api public
  # @since 0.12.0
  def register_plugin(plugin_name, plugin_klass)
    SmartCore::Schema::Plugins.register_plugin(plugin_name, plugin_klass)
  end
end
