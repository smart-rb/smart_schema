# frozen_string_literal: true

# @api private
# @since 0.1.0
class SmartCore::Schema::Checker::Rules
  # TODO: use smart_type-system
  TYPE_ALIASES = {
    'value.any'         => SmartCore::Types::Value::Any.nilable,
    'value.nil'         => SmartCore::Types::Value::Nil.nilable,
    'value.string'      => SmartCore::Types::Value::String.nilable,
    'value.symbol'      => SmartCore::Types::Value::Symbol.nilable,
    'value.text'        => SmartCore::Types::Value::Text.nilable,
    'value.integer'     => SmartCore::Types::Value::Integer.nilable,
    'value.float'       => SmartCore::Types::Value::Float.nilable,
    'value.numeric'     => SmartCore::Types::Value::Numeric.nilable,
    'value.big_decimal' => SmartCore::Types::Value::BigDecimal.nilable,
    'value.boolean'     => SmartCore::Types::Value::Boolean.nilable,
    'value.array'       => SmartCore::Types::Value::Array.nilable,
    'value.hash'        => SmartCore::Types::Value::Hash.nilable,
    'value.proc'        => SmartCore::Types::Value::Proc.nilable,
    'value.class'       => SmartCore::Types::Value::Class.nilable,
    'value.module'      => SmartCore::Types::Value::Module.nilable,
    'value.tme'         => SmartCore::Types::Value::Time.nilable,
    'value.date_time'   => SmartCore::Types::Value::DateTime.nilable,
    'value.date'        => SmartCore::Types::Value::Date.nilable,
    'value.time_based'  => SmartCore::Types::Value::TimeBased.nilable,
    'any'               => SmartCore::Types::Value::Any.nilable,
    'nil'               => SmartCore::Types::Value::Nil.nilable,
    'string'            => SmartCore::Types::Value::String.nilable,
    'symbol'            => SmartCore::Types::Value::Symbol.nilable,
    'text'              => SmartCore::Types::Value::Text.nilable,
    'integer'           => SmartCore::Types::Value::Integer.nilable,
    'float'             => SmartCore::Types::Value::Float.nilable,
    'numeric'           => SmartCore::Types::Value::Numeric.nilable,
    'big_decimal'       => SmartCore::Types::Value::BigDecimal.nilable,
    'boolean'           => SmartCore::Types::Value::Boolean.nilable,
    'array'             => SmartCore::Types::Value::Array.nilable,
    'hash'              => SmartCore::Types::Value::Hash.nilable,
    'proc'              => SmartCore::Types::Value::Proc.nilable,
    'class'             => SmartCore::Types::Value::Class.nilable,
    'module'            => SmartCore::Types::Value::Module.nilable,
    'tme'               => SmartCore::Types::Value::Time.nilable,
    'date_time'         => SmartCore::Types::Value::DateTime.nilable,
    'date'              => SmartCore::Types::Value::Date.nilable,
    'time_based'        => SmartCore::Types::Value::TimeBased.nilable
  }.freeze
end
