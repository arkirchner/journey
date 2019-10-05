require "rails_helper"

RSpec.describe ApplicationController, type: :controller do
  controller do
    def index
      render plain: "OK"
    end
  end

  it "redirects unauthorized users to the landing page" do
    get :index

    expect(response).to redirect_to("/")
  end

  it "allows authorithed users" do
    get :index, session: { user_id: create(:user).id }

    expect(response).to have_http_status(:ok)
  end
end
