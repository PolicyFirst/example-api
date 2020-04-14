require 'rails_helper'

RSpec.describe "/users", type: :request do

  # initialize test data 
  let!(:users) { create_list(:user, 12) }
  let(:user) { users.first }
  let(:user_password) { user.password }
  let(:user_email) { user.email }
  let(:user_id) { user.id }

  # This should return the minimal set of attributes required to create a valid
  # User. As you add validations to User, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    { "user" => {
      "email" => "jon@nights.watch",
      "password" => "ghost"
    } }
  }

  let(:login_attributes) {
    { "user" => {
      "email" => user_email,
      "password" => user_password
    } }
  }

  let(:invalid_attributes) {
    { "user" => {
      "email" => "char@zeon.co",
      "password" => "password"
    } }
  }

  let(:valid_headers) {
    {
      "Authorization" => JsonWebToken.encode(user_id: user_id),
      "Content-Type" => "application/json"
    }
  }

  describe 'POST /users/login' do
    before { post '/users/login', params: login_attributes }
    
    context 'when the password/email is correct' do
      it 'returns token' do
        expect(json).not_to be_empty
         expect(json["auth_token"])
      end

      it 'returns code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the password/email is invalid' do
      before { post '/users/login', params: invalid_attributes }

      it 'returns error message' do
        expect(response.body).to match("Invalid username/password")
      end

      it 'returns code 401' do
        expect(response).to have_http_status(401)
      end
    end

  end

  describe 'GET /users' do
    before { get '/users' }

    it 'returns users' do
      expect(json).not_to be_empty
      expect(json.size).to eq(12)
    end

    it 'returns code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /users/:id' do
    before { get "/users/#{user_id}" }

    context 'when the user exists' do
      it 'returns the user' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(user_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when record does not exist' do
      let(:user_id) { 100 }
        it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'POST /users' do

    context 'when the request is valid' do
      before { post '/users', params: valid_attributes }

      it 'creates a new user' do
        expect(json).not_to be_empty
        expect(json["auth_token"])
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/users', params: { user: { email: "", password: 'swordfish' } } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body).to match("{\"email\":[\"can't be blank\"]}")
      end
    end

    context 'when the request is invalid' do
      before { post '/users', params: { user: { email: 'Cersei@casterly.rock', password: "" } } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body).to match("{\"password\":[\"can't be blank\"],\"email\":[]}")
      end
    end
  end

  describe 'PUT /users/:id' do

    context 'when the record exists' do
      before{ put "/users/#{user_id}", params: valid_attributes.to_json, headers: valid_headers }

      it 'updates the record' do
        get "/users/#{user_id}"
        expect(json['email']).to match("jon@nights.watch")
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe 'DELETE /users/:id' do
    before { delete "/users/#{user_id}", headers: valid_headers }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'removes the user' do
      get "/users/#{user_id}"
      expect(response).to have_http_status(404)
    end

  end

  def json
    JSON.parse(response.body)
  end
end
