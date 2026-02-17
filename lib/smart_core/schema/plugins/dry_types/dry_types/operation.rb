# frozen_string_literal: true

module SmartCore::Schema::TypeSystem
  # @api private
  # @since 0.12.0
  module DryTypes::Operation
    require_relative 'operation/base'
    require_relative 'operation/valid'
    require_relative 'operation/validate'
    require_relative 'operation/cast'
  end
end
