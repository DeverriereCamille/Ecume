require 'rails_helper'

RSpec.describe MessagesController, :type => :controller do
  render_views

  describe "GET home" do
    it "returns http success and the loggin page if not log-in" do
      get :index
      # expect(response).to have_http_status(:success)
      # response.should redirect_to :login
      response.should redirect_to '/users/sign_in'
      # expect(response.body).to include("Posez votre question")
    end
  end
end
