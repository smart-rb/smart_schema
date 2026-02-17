# frozen_string_literal: true

# @api private
# @since 0.12.0
class SmartCore::Schema::TypeSystem::Registry
  include Enumerable

  # @return [void]
  #
  # @api private
  # @since 0.12.0
  def initialize
    @systems = {}
    @lock = SmartCore::Engine::ReadWriteLock.new
  end

  # @param system_identifier [String, Symbol]
  # @param interop_klass [Class<SmartCore::Schema::TypeSystem::Interop>]
  # @return [void]
  #
  # @api private
  # @since 0.12.0
  def register(system_identifier, interop_klass)
    @lock.write_sync { apply(system_identifier, interop_klass) }
  end

  # @param system_identifier [String, Symbol]
  # @return [Class<SmartCore::Schema::TypeSystem::Interop>]
  #
  # @api private
  # @since 0.12.0
  def resolve(system_identifier)
    @lock.read_sync { fetch(system_identifier) }
  end

  # @return [Array<String>]
  #
  # @api private
  # @since 0.12.0
  def names
    @lock.read_sync { system_names }
  end

  # @return [Array<Class<SmartCore::Schema::TypeSystem::Interop>>]
  #
  # @api private
  # @since 0.12.0
  def interops
    @lock.read_sync { system_interops }
  end

  # @param block [Block]
  # @yield [system_name, system_interop]
  #   @yieldparam system_name [String]
  #   @yieldparam system_interop [Class<SmartCore::Schema::TypeSystem::Interop>]
  # @return [Enumerable]
  #
  # @api private
  # @since 0.12.0
  def each(&block)
    @lock.read_sync { iterate(&block) }
  end

  # @return [Hash<String,Class<SmartCore::Schema::TypeSystem::Interop>]
  #
  # @api private
  # @since 0.12.0
  def to_h
    @lock.write_sync { systems.dup }
  end
  alias_method :to_hash, :to_h

  private

  # @return [Hash<String,Class<SmartCore::Schema::TypeSystem::Interop>]
  #
  # @api private
  # @since 0.12.0
  attr_reader :systems

  # @return [Array<String>]
  #
  # @pai private
  def system_names
    systems.keys
  end

  # @return [Array<Class<SmartCore::Schema::TypeSystem::Interop>>]
  #
  # @api private
  # @since 0.12.0
  def system_interops
    systems.values
  end

  # @param block [Block]
  # @yield [system_name, system_interop]
  #   @yieldparam system_name [String]
  #   @yieldparam system_interop [Class<SmartCore::Schema::TypeSystem::Interop>]
  # @return [Enumerable]
  #
  # @api private
  # @since 0.12.0
  def iterate(&block)
    block_given? ? systems.each_pair(&block) : systems.each_pair
  end

  # @param system_identifier [String, Symbol]
  # @param interop_klass [Class<SmartCore::Schema::TypeSystem::Interop>]
  # @return [void]
  #
  # @api private
  # @since 0.12.0
  def apply(system_identifier, interop_klass)
    prevent_incorrect_system_interop!(interop_klass)
    identifier = indifferently_accessible_identifier(system_identifier)
    systems[identifier] = interop_klass
  end

  # @param system_identifier [String, Symbol]
  # @return [Class<SmartCore::Schema::TypeSystem::Interop>]
  #
  # @raise [SmartCore::Schema::UnsupportedTypeSystemError]
  #
  # @api private
  # @since 0.12.0
  def fetch(system_identifier)
    identifier = indifferently_accessible_identifier(system_identifier)

    raise(
      SmartCore::Schema::UnsupportedTypeSystemError,
      "`#{identifier}` type system is not supported."
    ) unless systems.key?(identifier)

    systems.fetch(identifier)
  end

  # @param interop_klass [Class<SMartCore::Schema::TypeSystem::Interop>]
  # @return [void]
  #
  # @raise [SmartCore::Schema::IncorrectTypeSystemInteropError]
  #
  # @api private
  # @since 0.12.0
  def prevent_incorrect_system_interop!(interop_klass)
    unless interop_klass.is_a?(Class) && interop_klass < SmartCore::Schema::TypeSystem::Interop
      raise(
        SmartCore::Schema::IncorrectTypeSystemInteropError,
        'Incorrect type system interop class.'
      )
    end
  end

  # @param system_identifier [String, Symbol]
  # @return [String]
  #
  # @api private
  # @since 0.12.0
  def indifferently_accessible_identifier(system_identifier)
    system_identifier.to_s.clone.tap(&:freeze)
  end
end
