class MapPolicy < ApplicationPolicy
  attr_reader :user, :map

  def initialize(user, map)
    @user = user
    @map = map
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
