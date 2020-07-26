# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Schema::Checker::Rules::Options::Type
  # @param required_type [String, Symbol, SmartCore::Types::Primitive]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(required_type)
    @type = resolve_required_type(required_type)
  end

  private

  # @return [SmartCore::Types::Primitive]
  #
  # @api private
  # @since 0.1.0
  attr_reader :type

  # @param required_type [String, Symbol, SmartCore::Types::Primitive]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def resolve_required_type(required_type)
    unless required_type.is_a?(String) ||
           required_type.is_a?(Symbol) ||
           required_type.is_a?(SmartCore::Types::Primitive)
      raise(SmartCore::Schema::ArgumentError, <<~ERROR_MESSAGE)
        TODO: написать нормальный эррор меседж, что тип указан некорректный
      ERROR_MESSAGE
    end

    if required_type.is_a?(SmartCore::Types::Primitive)
      required_type
    else
      begin
        SmartCore::Schema::Checker::Rules::TYPE_ALIASES.fetch(required_type.to_s)
      rescue KeyError
        raise(SmartCore::Schema::ArgumentError, <<~ERROR_MESSAGE)
          TODO: написать нормальный эррор меседж, что такого типа нету
        ERROR_MESSAGE
      end
    end
  end
end
