require 'spec_helper'

# Helper method tests if all features are on
def all_features_active?
  Feature.all.inject {|memo, f| memo && Feature.active?(f.name)}
end

describe Feature do
  describe '::activate' do
    it 'sets ::active? from true to true' do
      Feature.create(name: :foo, active: true)
      Feature.activate(:foo)
      expect(Feature.active?(:foo)).to be true
    end
    it 'sets ::active? from false to true' do
      Feature.create(name: :foo, active: false)
      Feature.activate(:foo)
      expect(Feature.active?(:foo)).to be true
    end
  end

  describe '::deactivate' do
    it 'sets ::active? from true to false' do
      Feature.create(name: :foo, active: true)
      Feature.deactivate(:foo)
      expect(Feature.active?(:foo)).to be false
    end
    it 'sets ::active? from false to false' do
      Feature.create(name: :foo, active: false)
      Feature.deactivate(:foo)
      expect(Feature.active?(:foo)).to be false
    end
  end

  describe '::active?' do
    it 'is false when inactive' do
      Feature.create(name: :foo, active: false)
      expect(Feature.active?(:foo)).to be false
    end
    it 'is true when active' do
      Feature.create(name: :foo, active: true)
      expect(Feature.active?(:foo)).to be true
    end
    it 'is false when the feature flag does not exist' do
      # Feature :bar does not exist
      expect(Feature.active?(:bar)).to be false
    end
    it 'makes new flags inactive by default' do
      Feature.create(name: :splat)
      expect(Feature.active?(:splat)).to be false
    end
  end
  describe '::activate_all' do
    it 'turns on all flags in the database'
    test_flags = {:foo => false, :bar => true, :splat => false}
    test_flags.each {|flag, state| Feature.create(name: flag, active: state)}
    expect(all_features_active?).to be_false # null case
    Feature.activate_all
    expect(all_features_active?).to be_true
  end
  describe '::configure_all' do
    it 'adds feature flag names from a file'
  end
end
