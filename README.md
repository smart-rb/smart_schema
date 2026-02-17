# SmartCore::Schema &middot; <a target="_blank" href="https://github.com/Cado-Labs"><img src="https://github.com/Cado-Labs/cado-labs-logos/raw/main/cado_labs_badge.svg" alt="Supported by Cado Labs" style="max-width: 100%; height: 20px"></a> &middot; [![Gem Version](https://badge.fury.io/rb/smart_schema.svg)](https://badge.fury.io/rb/smart_schema)

`SmartCore::Schema` is a schema validator for `Hash`-like data structures (`Array`-like - coming soon) in declarative DSL-powered style.

Provides convenient and concise DSL to define complex schemas in easiest way and public validation interface to achieve a comfortable work with detailed validation result.

Supports nested structures, type validation (via `smart_types`), required- and optional- schema keys, *strict* and *non-strict* schemas, schema value presence validation, schema inheritance (soon), schema extending (soon) and schema composition (soon).

Works in predicate style and in OOP/Monadic result object style. Enjoy :)

---

<p>
  <a href="https://github.com/Cado-Labs">
    <img src="https://github.com/Cado-Labs/cado-labs-logos/blob/main/cado_labs_supporting.svg" alt="Supported by Cado Labs" />
  </a>
</p>

---

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
- strict modes and strict behavior: `strict!`, `non_strict!`, `schema(:strict)`, `schema(:non_strict)`;
- `:strict` is used by default (in first `schema` invokation);
- you can make non-strict inner schemas inside strict schemas (and vise-versa);
- inner schemas inherits their's mode from their's nearest outer schema (and can have own mode too);

```ruby
class MySchema < SmartCore::Schema
  # you can mark strict mode in root schema here:
  #
  # non_strict!
  #
  # -- or --
  #
  # strict!

  schema do # or here with `schema(:strict)` (default in first time) or `schema(:non_strict)`
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
        non_strict! # marks current nested schema as `:non_strict`
      end
    end

    required(:another_key).filled
  end
end
```

```ruby
# you can open already defined schema and continue schema definitioning:

schema do
  required(:third_key).filled.type(:string)
end
```

```ruby
# you can redefine strict behavior of already defined schema:

schema(:non_strict) do
  # ...
end

# -- or --
schema do
  non_strict!
end

# -- or --
non_strict!
```

```ruby
# you can redefine nested schema behavior:

schema do
  optional(:another_nested) do
    strict! # change from :non_strict to :strict
  end
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
#  @spread_keys=#<Set: {}>, (coming soon (spread keys of non-strict schemas))
#  @source={:key=>{:data=>nil, :value=>"1", :name=>"D@iVeR"}, :another_key=>nil, :third_key=>"test"}>

result.success? # => false
result.spread_keys # => <Set: {}> (coming soon (spread keys of non-strict schemas))
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

## Type System Customization

- supports `smart-types` (pre-configured by default);
- supports `dry-types` (requires `dry-types` gem required in your project);
- configuration has a global effect (single type-config for all Schema instances/classes)
  - **NOTE**: this behavior will be reworked in future (mutliple type system support at once);

### Type System Configuration and Usage

```ruby
# IMPORTANT: inn order to use dry-types:
# 1. you should install dry-types and require dry-types in your projecgts
# 2. require dry_types plugin

require 'dry-types'
SmartCore::Schema.plugin(:dry_types) # fails if you try to enable this plugin without a pre-isntalled dry-types;
```

```ruby
SmartCore::Schema::Configuration.configure do |config|
  config.type_system = :dry_types # :smart_types (:smart_types is used by default)
end
```

```ruby
# configure type aliases

# - for smart-types
SmartCore::Schema.type_system.type_alias(:integer, SmartCore::Types::Value::Integer)
# smart-types has a list of pre-configured aliases. see lib/smart_core/schema/type_system/smart_types.rb

# - for dry-types
SmartCore::Schema.type_system.type_alias(:integer, Dry::Types['integer'])
# dry-types has no pre-configured aliases.
```

```ruby
# classic smart-types usage
class MySchemaWithSmartTypes < SmartCore::Schema
  schema do
    required(:date).type(SmartCore::Types::Value::String) # object-style
    required(:count).type(:integer) # alias-style
  end
end

# dry-types usage
class MySchemaWithDryTypes < SmartCore::Schema
  schema do
    required(:date).type(Dry::Types['string']) # object-style
    required(:count).type(:integer) # alias-style 
  end
end
```

---

## Roadmap

- **(x.x.x)** - **(As Soon As Possible)** support for schema inhertiance with schema redefinition ;
- **(x.x.x)** - support for `.cast` in type definitions;
- **(x.x.x)** - mutable schemas (value convertion during schema checking with returning the new coerced data structure);
- **(x.x.x)** - public interface for type aliasing (custom type alias registration API);
- **(x.x.x)** - support for `Array`-like data structures;
- **(0.x.0)** - an abiltiy to represent the required schema as a string (conviniet way to check what schema is defained internally when we work wtih a dynamic schema definition or in a console);
- **(0.x.0)** - migrate to `GitHub Actions` (CI);
- **(0.x.0)** - value-validation layer;
- **(0.x.0)** - error messages (that are consistent with error codes), with a support for error-code-auto-mappings for error messages via explicit hashes or via file (yaml, json and other formats);
- **(0.6.0)** - support for `Array`-type in schema definition;
- **(0.6.0)** - spread keys of non-strict schemas in validation result;
- **(0.7.0)** - schema inheritance;
- **(0.7.0)** - schema composition (`required(:key).schema(SchemaClass)`) (`compose_with(AnotherSchema)`);
- **(0.7.0)** - dependable schema checking (sample: if one key exist (or not) we should check another (or not), and vice verca) (mb `if(:_key_)` rule);
- **(0.8.0)** - `smart_type-system` integration;
- **(0.9.0)** - support for another data structures (such as YAML strings, JSON strings, `Struct`, `OpenStruct`s, custom `Object`s  and etc);
- **(0.10.0)** - mixin-based implementation;
- **(0.x.0)** - think about pattern matching;
- **(0.x.0)** - dependable schema checks: we can conditionally check some parts of schema stracture that depends on schema key values;
- **(0.x.0)** - support for dynamic keys, when the key name can have any name and can be a value or a schema;
  ```ruby
  # PROPOSAL:
  
  required(:some_key) do
    dynamic do # dynamic schema
      required(:kek).type(:string).filled
    end

    dynamic.type(:integer).filled # dynamic key
  end
  ```

---

## Build

- run tests:

```shell
bundle exec rake rspec
```

- run code style checks:

```shell
bundle exec rake rubocop
```

- run code style checks with auto-correction:

```shell
bundle exec rake rubocop -A
```

---

## Contributing

- Fork it ( https://github.com/smart-rb/smart_schema )
- Create your feature branch (`git checkout -b feature/my-new-feature`)
- Commit your changes (`git commit -am '[feature_context] Add some feature'`)
- Push to the branch (`git push origin feature/my-new-feature`)
- Create new Pull Request

## License

Released under MIT License.

## Supporting

<a href="https://github.com/Cado-Labs">
  <img src="https://github.com/Cado-Labs/cado-labs-logos/blob/main/cado_labs_logo.png" alt="Supported by Cado Labs" />
</a>

## Authors

[Rustam Ibragimov](https://github.com/0exp)
