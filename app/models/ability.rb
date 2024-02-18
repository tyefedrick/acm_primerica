class Ability
    include CanCan::Ability
  
    def initialize(user)
      user ||= User.new
  
    if user.admin?
      can :manage, :all
    elsif user.editor?
      can :manage, [Article, Comment]
    else
      can :read, :all
    end
  end
end