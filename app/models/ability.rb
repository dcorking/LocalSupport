class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    can :manage, :all
    cannot :create, Organization unless user.admin?
  end
end
