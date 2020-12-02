# SmartCore::Schema [![Gem Version](https://badge.fury.io/rb/smart_schema.svg)](https://badge.fury.io/rb/smart_schema) [![Build Status](https://travis-ci.org/smart-rb/smart_schema.svg?branch=master)](https://travis-ci.org/smart-rb/smart_schema)

`SmartCore::Schema` is a schema validator for `Hash`-like data structures in declarative DSL-powered style.

Provides convenient and concise DSL to define complex schemas in easiest way and public validation interface to achieve a comfortable work with detailed validation result.

Supports nested structures, type validation (via `smart_types`), required- and optional- schema keys, schema value presence validation, schema inheritance (soon), schema extending (soon) and schema composition (soon).

Works in predicate style and in OOP/Monadic result object style. Enjoy :)

## Installation

```ruby
gem 'smart_schema'
```

```shell
bundle install
# --- or ---
gem install smart_schema
```

```ruby
require 'smart_core/schema'
```

---

## Synopsis

- key requirement: `required` and `optional`;
- type validation: `type`;
- `nil` control: `filled`;
- nested definitions: `do ... end`;
- supported types: see `smart_types` gem;
- strict modes and strict behavior:
  - `strict!` DSL directive marks your schema as a strict schema (your hash can not have extra keys);
  - `non_strict!` DSL directive marks your schema as non-strict schema (your hash can have extra keys);
  - use `strict!` in any schema's context place to mark your current schema context as a strict;
  - use `non_strict` in any schema's context place to mark your current schema context as a strict;
  - use `schema(:strict)` to globally define strict schema (default behavior);
  - use `schema(:non_strict)` to globally define non-strict schema;
  - nested schemas inherits strict behavior from outer schemas;
  - root schema is `:strict` by default;
  - schema reopening without mode attribute does not change original schema mode
    (you should manually pass a mode attribute to redefine already defined schema mode);

```ruby
class MySchema < SmartCore::Schema
  # you can mark root schema here:
  # non_strict!
  # strict!

  schema do # or here with `schema(:strict)` (default in first invocation) or `schema(:non_strict)`
    required(:key) do
      # inherits `:strict`
      optional(:data).type(:string).filled
      optional(:value).type(:numeric)
      required(:name).type(:string)

      required(:nested) do
        # inherits `:strict`
        optional(:version).filled
      end

      optional(:another_nested) do
        non_strict! # marks current nested schema as :non_strict
      end
    end

    required(:another_key).filled
  end

  # you can open already defined schema and continue schema definitioning:
  #
  # schema do
  #   required(:third_key).filled.type(:string)
  # end

  # you can redefine strict behavior of already defined schema:
  #
  # schema(:non_strict) do
  #   ...
  # end
  #
  # -- or --
  #
  # schema do
  #   non_strict!
  # end
  #
  # -- and (redefine nested schema behavior) --
  #
  # schema do
  #   optional(:another_nested) do
  #     strict! # change from :non_strict to :strict
  #   end
  # end
end
```

```ruby
MySchema.new.valid?({
  key: {
    data: '5',
    value: 1,
    name: 'D@iVeR'
    nested: {}
  }
  another_key: true
}) # => true

MySchema.new.valid?({
  key: {
    data: nil,
    value: 1,
    name: 'D@iVeR'
    nested: {}
  }
}) # => false (missing :another_key, key->data is not filled)
```

```ruby
result = MySchema.new.validate(
  key: { data: nil, value: '1', name: 'D@iVeR' },
  another_key: nil,
  third_key: 'test'
)

# => outputs:
#  #<SmartCore::Schema::Result:0x00007ffcd8926990
#  @errors={"key.data"=>[:non_filled], "key.value"=>[:invalid_type], "key.nested"=>[:required_key_not_found], "another_key"=>[:non_filled], "third_key"=>[:extra_key]},
#  @extra_keys=#<Set: {"third_key"}>,
#  @source={:key=>{:data=>nil, :value=>"1", :name=>"D@iVeR"}, :another_key=>nil, :third_key=>"test"}>

result.success? # => false
result.extra_keys # => <Set: {"third_key"}>
result.errors # =>
{
  "key.data"=>[:non_filled],
  "key.value"=>[:invalid_type],
  "key.nested"=>[:required_key_not_found],
  "another_key"=>[:non_filled],
  "third_key"=>[:extra_key]
}
```

Possible errors:
  - `:non_filled` (existing key has nil value);
  - `:invalid_type` (existing key has invalid type);
  - `:required_key_not_found` (required key does not exist);
  - `:extra_key` (concrete key does not exist in schema);

---

## Roadmap

- **(0.x.0)** - value-validation layer;
- **(0.3.0)** - error messages (that are consistent with error codes), with a support for error-code-auto-mappings for error messages via explicit hashes or via file (yaml, json and other formats);
- **(0.4.0)** - schema inheritance;
- **(0.4.0)** - schema composition (`required(:key).schema(SchemaClass)`) (`compose_with(AnotherSchema)`);
- **(0.4.0)** - dependable schema checking (sample: if one key exist (or not) we should check another (or not), and vice verca) (mb `if(:_key_)` rule);
- **(0.6.0)** - `smart_type-system` integration;
- **(0.7.0)** - support for another data structures (such as YAML strings, JSON strings, `Struct`, `OpenStruct`s, custom `Object`s  and etc);
- **(0.8.0)** - think about pattern matching;

---

## Contributing

- Fork it ( https://github.com/smart-rb/smart_schema )
- Create your feature branch (`git checkout -b feature/my-new-feature`)
- Commit your changes (`git commit -am '[feature_context] Add some feature'`)
- Push to the branch (`git push origin feature/my-new-feature`)
- Create new Pull Request

## License

Released under MIT License.

## Authors

[Rustam Ibragimov](https://github.com/0exp)
