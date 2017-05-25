class TeamPolicy < ApplicationPolicy
  attr_reader :user, :team

  def initialize(user, team)
    @user = user
    @team = team
  end

  def edit?
    false
  end

  def new?
    false
  end

  def create?
    false
  end

  def update?
    false
  end

end
