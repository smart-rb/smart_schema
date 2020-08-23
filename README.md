# SmartCore::Schema [![Gem Version](https://badge.fury.io/rb/smart_schema.svg)](https://badge.fury.io/rb/smart_schema) [![Build Status](https://travis-ci.org/smart-rb/smart_schema.svg?branch=master)](https://travis-ci.org/smart-rb/smart_schema)

### Demo Goal

```ruby
class MySchema < SmartCore::Schema
  schema do
    required(:key) do # автоматически добавляет .type(:hash).filled
      optional(:data).type(:string).filled
      optional(:value).type(:numeric)
      required(:name).type(:string)
    end

    # пдумать, норм ли вот так?
    #   required(:key).type(:hash).filled do
    #   end
    #
    #   required(:key).type(:hash) do # автофиллед
    #   end
    #
    #   required(:key).filled do # автот хэш-тайпэд
    #   end
  end
end

MySchema.new.valid?({
  key: {
    data: '5',
    value: 1,
    name: 'Vasia'
  }
}) # => true

# thinking about error format: =>
# {
#   'key.data' => error_object
#   'key.data' => :missing
#   'key.data' => :invalid_type
# }
```
