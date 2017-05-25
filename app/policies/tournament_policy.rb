class TournamentPolicy < ApplicationPolicy
  attr_reader :user, :tournament

  def initialize(user, tournament)
    @user = user
    @tournament = tournament
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
