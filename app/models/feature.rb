# Provides feature flags.
# ======================
# To create a new feature flag
#
#   Feature.create(:name => :my_feature_name)
#
# By default, features are inactive.
# Test if your feature is active with:
#
#   Feature.active?(:my_feature_name)
#
# Deactivate it and reactivate it with (just like the rollout gem):
#
#   Feature.deactivate(:my_feature_name)
#   Feature.activate(:my_feature_name)
#
# ### Tips
#
# It is probably better only to flag the entry points that a 
# user normally takes into a feature, and leave the actual
# feature pages active. This approach is described in
# http://martinfowler.com/bliki/FeatureToggle.html
#
# If you do want to block a route with a flag, edit config/routes.rb,
# to add this as a constraint to that route:
# 
#   constraints: lambda { |request| Feature.active?(:my_feature_name) }

class Feature < ActiveRecord::Base
  attr_accessible :name, :active
  validates :name, presence: true, uniqueness:true, allow_blank: false
  # Why does the following validation break the code?
  # Feature::activate sets ::active? from false to true
     # Failure/Error: Feature.activate(:foo)
     # NoMethodError:
     #   undefined method `update_attribute' for nil:NilClass
  #  validates :active, presence: true, allow_blank: false

  def self.deactivate(feature)
    find_by_name(feature).update_attribute(:active, false)
  end

  def self.activate(feature)
    find_by_name(feature).update_attribute(:active, true)
  end

  def self.active?(feature)
    flag = find_by_name(feature)
    flag.nil? ? false : flag.active?
  end

  # Create the feature flags named in
  # config/feature_flag_names
  # Records are separated by newlines
  # Each record is a name. Please use snake_case.
  # Can SQL be injected via that file?
  def self.configure_all filename
    flag_file = File.new(filename, "r")
    puts "A lot more to do here"
  end

  # Enable all flags that are found in the database
  def self.activate_all
    Feature.where(active: false).each {|f| f.active = true; f.save}
  end
end
