require 'rails_helper'

RSpec.describe Admin::TraderController, type: :controller do
    include Devise::Test::ControllerHelpers
    let(:valid_attributes) { FactoryBot.attributes_for(:user) }
    let(:invalid_attributes) { FactoryBot.attributes_for(:user, email: nil) }


  describe "GET #new" do
  let(:admin_user) { create(:admin_user) }

  before do
    sign_in admin_user
  end

    it "returns a success response" do
      get :new
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
  let(:admin_user) { create(:admin_user) }
  
  before do
    sign_in admin_user
  end
    context "with valid params" do
      it "creates a new trader" do
        expect {
          post :create, params: { user: valid_attributes }
        }.to change(User, :count).by(1)
      end

      it "redirects to the traders index" do
        post :create, params: { user: valid_attributes }
        expect(response).to redirect_to(admin_trader_index_path)
      end
    end

    context "with invalid params" do
      it "does not create a new trader" do
        expect {
          post :create, params: { user: invalid_attributes }
        }.to_not change(User, :count)
      end

      it "re-renders the 'new' template" do
        post :create, params: { user: invalid_attributes }
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #index" do
  let(:admin_user) { create(:admin_user) }
  
  before do
    sign_in admin_user
  end
    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
  let(:admin_user) { create(:admin_user) }
  
  before do
    sign_in admin_user
  end
    let(:trader) { FactoryBot.create(:user) }

    it "returns a success response" do
      get :show, params: { id: trader.to_param }
      expect(response).to be_successful
    end
  end

  describe "GET #edit" do
  let(:admin_user) { create(:admin_user) }
  
  before do
    sign_in admin_user
  end
    let(:trader) { FactoryBot.create(:user) }

    it "returns a success response" do
      get :edit, params: { id: trader.to_param }
      expect(response).to be_successful
    end
  end

  describe "PUT #update" do
  let(:admin_user) { create(:admin_user) }
  
  before do
    sign_in admin_user
  end
    let(:trader) { FactoryBot.create(:user) }

    context "with valid params" do
      let(:new_attributes) { { firstname: "New Firstname" } }

      it "updates the requested trader" do
        put :update, params: { id: trader.to_param, user: new_attributes }
        trader.reload
        expect(trader.firstname).to eq("New Firstname")
      end

      it "redirects to the traders index" do
        put :update, params: { id: trader.to_param, user: valid_attributes }
        expect(response).to redirect_to(admin_trader_index_path)
      end
    end

    context "with invalid params" do
      it "re-renders the 'edit' template" do
        put :update, params: { id: trader.to_param, user: invalid_attributes }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE #destroy" do
  let(:admin_user) { create(:admin_user) }
  
  before do
    sign_in admin_user
  end
    let!(:trader) { FactoryBot.create(:user) }

    it "destroys the requested trader" do
      expect {
        delete :destroy, params: { id: trader.to_param }
      }.to change(User, :count).by(-1)
    end

    it "redirects to the traders index" do
      delete :destroy, params: { id: trader.to_param }
      expect(response).to redirect_to(admin_trader_index_path)
    end
  end
end
