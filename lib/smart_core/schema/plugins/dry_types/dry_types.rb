# frozen_string_literal: true

module SmartCore::Schema::TypeSystem
  # @api public
  # @since 0.12.0
  class DryTypes < Interop
    require_relative 'dry_types/abstract_factory'
    require_relative 'dry_types/operation'
  end
end
