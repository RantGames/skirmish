
describe SessionsController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  it 'allows sign in via json' do
    User.create!(email: 'foo@example.org', password: 'swordfish', password_confirmation: 'swordfish')
    post :create, user: {email: 'foo@example.org', password: 'swordfish', remember_me: '0'}, format: :json

    expect(response.body).to match_json_expression({ success: true })
  end
end