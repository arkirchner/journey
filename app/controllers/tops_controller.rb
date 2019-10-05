class TopsController < ApplicationController
  skip_before_action :redirect_when_unauthorized, only: :index

  def index; end
end
