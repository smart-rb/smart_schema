# frozen_string_literal: true

require 'qonfig'

# @api public
# @since 0.12.0
module SmartCore::Schema::Configuration
  # @since 0.12.0
  include Qonfig::Configurable

  # @api public
  # @since 0.12.0
  extend SmartCore::Schema::Plugins::AccessMixin

  class << self
    # @param setting_key [String, Symbol]
    # @return [Qonfig::Settings, Any]
    #
    # @api private
    # @since 0.12.0
    def [](setting_key)
      config[setting_key]
    end
  end

  # @since 0.12.0
  configuration do
    setting :type_system, :smart_types
    validate :default_type_system do |value|
      SmartCore::Schema::TypeSystem.resolve(value) rescue false
    end
  end
end
