class UserPolicy < ApplicationPolicy
  attr_reader :user, :user_check

  def initialize(user, user_check)
    @user = user
    @user_check = user_check
  end

  def edit?
    user.admin? or user.id == user_check.id
  end

  def new?
    user.admin?
  end

  def create?
    user.admin?
  end

  def update?
    user.admin? or user.id == user_check.id
  end

  def access_dashboard_page?
    user.admin?
  end
end
