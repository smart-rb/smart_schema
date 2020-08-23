# SmartCore::Schema [![Gem Version](https://badge.fury.io/rb/smart_schema.svg)](https://badge.fury.io/rb/smart_schema) [![Build Status](https://travis-ci.org/smart-rb/smart_schema.svg?branch=master)](https://travis-ci.org/smart-rb/smart_schema)

## Synopsis

```ruby
class MySchema < SmartCore::Schema
  schema do
    required(:key) do
      optional(:data).type(:string).filled
      optional(:value).type(:numeric)
      required(:name).type(:string)
    end
  end
end

MySchema.new.valid?({
  key: {
    data: '5',
    value: 1,
    name: 'Vasia'
  }
}) # => true


result = MySchema.new.validate(

)
```

## Roadmap

- **(0.2.0)** schema inheritance;
- **(0.3.0)** schema composition (`required(:key).schema(SchemaClass)`) (`compose_with(AnotherSchema)`);
- **(0.4.0)** error messages (that are consistent with error codes);
