# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Schema::Checker::Rules::Options::Type
  # @note Constant is used only for clarity (for other developers).
  # @return [Symbol]
  #
  # @api private
  # @since 0.1.0
  ERROR_CODE = :invalid_type

  # @param required_type [String, Symbol, SmartCore::Types::Primitive]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(required_type)
    @type = resolve_required_type(required_type)
  end

  # @param schema_key [String]
  # @param schema_value [Any]
  # @return [SmartCore::Schema::Checker::Rules::Result::Success]
  # @return [SmartCore::Schema::Checker::Rules::Result::Failure]
  #
  # @api private
  # @since 0.1.0
  def validate(schema_key, schema_value)
    if type.valid?(schema_value)
      SmartCore::Schema::Checker::Rules::Result::Success.new(
        key: schema_key,
        value: schema_value
      )
    else
      SmartCore::Schema::Checker::Rules::Result::Failure.new(
        key: schema_key,
        value: schema_value,
        error: ERROR_CODE,
        message: 'TODO: меседж что экспектед такой тоайп, а получен другой'
      )
    end
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
        TODO: написать нормальный эррор меседж, что тип в схеме для ключа указан некорректный
      ERROR_MESSAGE
    end

    if required_type.is_a?(SmartCore::Types::Primitive)
      required_type
    else
      begin
        SmartCore::Schema::Checker::Rules::TYPE_ALIASES.fetch(required_type.to_s)
      rescue KeyError
        raise(SmartCore::Schema::ArgumentError, <<~ERROR_MESSAGE)
          TODO: написать нормальный эррор меседж, что нет типа, который выбран в схеме для ключа
        ERROR_MESSAGE
      end
    end
  end
end
