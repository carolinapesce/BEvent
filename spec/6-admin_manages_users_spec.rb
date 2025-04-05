require 'rails_helper'

RSpec.describe "Admin Functionality", type: :request do
  let(:admin) { create(:user, role: 2) }
  let!(:users) { create_list(:user, 5) }
  let!(:user_to_delete) { create(:user) }
  let!(:user_to_update) { create(:user) }
  let!(:user_to_block) { create(:user) }

  before do
    login_as(admin)
  end

  it 'mostra la lista di tutti gli utenti' do
    get admin_users_path
    expect(response).to have_http_status(:success)
    user = users.first
    expect(response.body).to include("#{user.first_name}")
  end

  it 'elimina uno user' do
    expect {
      delete admin_user_path(user_to_delete)
    }.to change(User, :count).by(-1)
    expect(response).to redirect_to(admin_users_path)
  end

  it 'modifica uno user' do
    patch admin_user_path(user_to_update), params: { user: { first_name: 'Updated' } }
    expect(user_to_update.reload.first_name).to eq('Updated')
    expect(response).to redirect_to(admin_users_path)
  end

  describe 'PATCH /admin/users/:id/block' do
    it 'blocca uno user' do
      patch block_admin_user_path(user_to_block)
      expect(user_to_block.reload.blocked).to be_truthy
    end

    it 'sblocca uno user' do
      user_to_block.update(blocked: true)
      patch unblock_admin_user_path(user_to_block)
      expect(user_to_block.reload.blocked).to be_falsey
    end
  end

end