class SeasonPolicy < ApplicationPolicy
  attr_reader :user, :season

  def initialize(user, season)
    @user = user
    @season = season
  end

  def edit?
    user.admin?
  end

  def new?
    user.admin?
  end

  def create?
    user.admin?
  end

  def update?
    user.admin?
  end

end
