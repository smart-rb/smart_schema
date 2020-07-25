# SmartCore::Schema [![Gem Version](https://badge.fury.io/rb/smart_schema.svg)](https://badge.fury.io/rb/smart_schema) [![Build Status](https://travis-ci.org/smart-rb/smart_schema.svg?branch=master)](https://travis-ci.org/smart-rb/smart_schema)

### Demo Goal

```ruby
class MySchema < SmartCore::Schema
  schema do
    required(:key) do
      optional(:data).type(:string).finalize { |val| "-#{val}-" }
      optional(:value).type(:numeric)
      required(:name).type(:string).default('lol').finalize { |val| "=#{val}=" }
    end

    # .default(:instance_method_name)
    # .finalize(:instance_method_name)
  end

  validate('key.name') do
  end

  default('key.data') do
  end

  finalize('key.data') do |value|
  end
end

MySchema.new.valid?({
  key: {
    data: '5',
    value: 1,
    name: 'Vasia'
  }
}) # => true

MySchema.new.format({
  key: {
    data: '5',
    value: 1,
    name: 'Vasia'
  }
}, symbolize_keys: false)

# =>
{
  'key' => {
    'data' => '-5-',
    'value' => 1,
    'name' => '=Vasia='
  }
}

# thinking about error format: =>
# {
#   'key.data' => error_object
#   'key.data' => :missing
#   'key.data' => :invalid_type
# }
```
