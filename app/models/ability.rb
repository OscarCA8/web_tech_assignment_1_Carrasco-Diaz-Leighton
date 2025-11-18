# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.is_admin?
      can :manage, :all
    else
      can :read, :all

      # Users can manage their own profile
      can :manage, User, id: user.id

      # Participations and progress entries: users can manage their own
      can :manage, Participation, user_id: user.id
      can :create, Participation

      can :manage, ProgressEntry, user_id: user.id
      can :create, ProgressEntry

      # Challenges: creators can manage their own challenges; anyone can create
      can :manage, Challenge, creator_id: user.id
      can :create, Challenge

      # Badges are admin-managed; regular users can only read
      can :read, Badge
    end
  end
end
