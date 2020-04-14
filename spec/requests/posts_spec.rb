require 'rails_helper'

RSpec.describe "/posts", type: :request do
  # This should return the minimal set of attributes required to create a valid
  # Post. As you add validations to Post, be sure to
  # adjust the attributes here as well.
  let!(:users) { create_list(:user, 5) }
  let(:user_id) { users.first.id }
  let!(:posts) { create_list(:post, 12, user_id: user_id) }
  let(:post_id) { posts.first.id }

   let(:valid_attributes) {
    { "post" => {
      "text" => "jalad at tenagara",
      "user_id" => "#{user_id}"
    } }
  }

  let(:valid_headers) {
    {
      "Authorization" => JsonWebToken.encode(user_id: user_id),
      "Content-Type" => "application/json"
    }
  }

  describe 'GET /posts' do
    before { get '/posts' }

    it 'returns posts' do
      expect(json).not_to be_empty
      expect(json.size).to eq(12)
    end

    it 'returns code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /posts/:id' do
    before { get "/posts/#{post_id}" }

    context 'when the record exists' do
      it 'returns the post' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(post_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when record does not exist' do
      let(:invalid_post_id) { 100 }
        it 'returns status code 404' do
          get "/posts/#{invalid_post_id}"
          expect(response).to have_http_status(404)
        end
    end
  end


  describe 'POST /posts' do

    context 'when the request is valid' do
      before { post '/posts', params: valid_attributes.to_json, headers: valid_headers }

      it 'creates a new post' do
        expect(json['text']).to match("jalad at tenagara")
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      let(:invalid_params) {{ post: { text: "", user_id: "1" } }}
      before { post '/posts', params: invalid_params.to_json, headers: valid_headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body).to match("{\"text\":[\"can't be blank\"]}")
      end
    end

    context 'when the user_id is invalid' do
      let(:invalid_params) {{ post: { text: 'ach hans run', user_id: "" } }}
      before { post '/posts', params: invalid_params.to_json, headers: valid_headers }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end

      it 'returns a validation failure message' do
        expect(response.body).to match("Invalid Authorization")
      end
    end
  end

  describe 'PUT /posts/:id' do

    context 'when the record exists' do
      before{ put "/posts/#{post_id}", params: valid_attributes.to_json, headers: valid_headers }

      it 'updates the record' do
        get "/posts/#{post_id}"
        expect(json['text']).to match("jalad at tenagara")
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe 'DELETE /posts/:id' do
    before { delete "/posts/#{post_id}", headers: valid_headers }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'removes the post' do
      get "/posts/#{post_id}"
      expect(response).to have_http_status(404)
    end

  end

  def json
    JSON.parse(response.body)
  end
end
