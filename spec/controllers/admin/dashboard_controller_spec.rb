require 'rails_helper'

RSpec.describe Admin::DashboardController, type: :controller do
  include Devise::Test::ControllerHelpers

  describe 'GET #index' do
    context 'when admin user is authenticated' do
      let(:admin_user) { create(:admin_user) }
      let(:trader) { create(:user, status: :pending) }

      before { sign_in admin_user }
      it 'renders the index template' do
          get :index
          expect(response).to render_template(:index)
      end

      it 'assigns @users with pending status' do
          pending_user = create(:user, status: :pending)
          approved_user = create(:user, status: :approved)
          get :index

          expect(assigns(:users)).to eq([pending_user])
      end
    end

  context 'when admin user is not authenticated' do
    it 'redirects to the sign in page' do
      get :index
      expect(response).to redirect_to(new_admin_user_session_path)
    end
  end
end
    describe 'PATCH #approve' do
    let(:admin_user) { create(:admin_user) }
    let(:user) { create(:user, status: :pending) }

    context 'when admin user is authenticated' do
      before { sign_in admin_user }

      it 'approves the trader account' do
        patch :approve, params: { id: user.id }
        user.reload
        expect(user.status).to eq('approved')
      end

      it 'sends an approval email to the trader' do
        expect(UserMailer).to receive(:approved_email).with(user).and_call_original
        patch :approve, params: { id: user.id }
      end

      it 'redirects to admin dashboard with success notice' do
        patch :approve, params: { id: user.id }
        expect(response).to redirect_to(admin_dashboard_path)
        expect(flash[:notice]).to eq('Trader account approved successfully')
      end
    end

    context 'when admin user is not authenticated' do
      it 'redirects to the sign in page' do
        patch :approve, params: { id: user.id }
        expect(response).to redirect_to(new_admin_user_session_path)
      end
    end
    end

end
