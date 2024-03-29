# Changelog
All notable changes to this project will be documented in this file.

# [0.11.0] - 2022-11-25
## Changed
- Reduced object allocation count inside the type validation logic (updated `smart_types` to `~> 0.8`);
- Support for *Ruby@2.5* and *Ruby@2.6* has ended;
- Updated development dependencies;

# [0.10.0] - 2022-10-16
## Changed
- Updated `smart_engine` dependency with a `SmartCore::Engine::ReadWriteLock` fixes;

# [0.9.0] - 2022-09-30
## Changed
- Reduced context switching count during lock operations (migrate from `SmartCore::Engine::Lock` to `SmartCore::Engine::ReadWriteLock`);

# [0.8.0] - 2022-09-30
## Changed
- Reduced object allocations and mutex usage:
  - only one mutex of `SmartCore::Schema::Checker` instance is enough cuz this mutex covers the entire validation process;
  - more retained objects in `SmartCore::Schema::Checker::Rules` (cache layer for rule names);
- Updated development dependencies;
- Updated `smart_engine` dependency (`~> 0.11` -> `~> 0.13`);

# [0.7.0] - 2022-09-28
## Changed
- Started the total code refactoring in order to decrease object and memory allocations:
  - Decreased object allocations in `SmartCore::Schema::Checker::VerifiableHash#fetch(key)`

# [0.6.0] - 2022-09-27
## Added
- Now `Forwardable` module has explicit requiring in order to support *Ruby@3.1* (`lib/smart_core/smart_schema.rb#6`);

# [0.5.0] - 2021-01-18
## Changed
- Updated `smart_types` dependency (`~> 0.4.0`) to guarantee **Ruby@3** compatability;

# [0.4.0] - 2021-01-18
## Added
- Support for **Ruby@3**;

## Changed
- No more `TravisCI` (TODO: migrate to `GitHub Actions`);
- Updated development dependencies;

# [0.3.0] - 2020-12-03
### Added
- Support for *strict* and *non-strict* schemas;
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

# [0.2.0] - 2020-11-09
### Added
- `#errors` now includes `#extra_keys` too (`:extra_key` error code for each extra key);
- Unfreezed `SmartCore::Schema::Checker::Rules::TYPE_ALIASES` for extendability (until `smart_type-syste` has been integrated);

# [0.1.0] - 2020-08-25

- Release :)
