class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    can_admin = user.admin?

    can :manage, :all
    cannot :create, Organization unless can_admin
    cannot :edit, Organization unless can_admin
    # cannot :edit, @organization unless user.organization == @organization
  end
end
