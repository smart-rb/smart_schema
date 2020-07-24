# frozen_string_literal: true

RSpec.describe SmartCore::Schema do
  it 'has a version number' do
    expect(SmartCore::Schema::VERSION).not_to be nil
  end
end
