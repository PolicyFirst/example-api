class ApplicationController < ActionController::API
	require 'json_web_token'

	protected

	# Validates token & user, then sets @current_user scope
	def authenticate_request!
		if !payload || !JsonWebToken.valid_payload(payload.first)
			return invalid_authentication
		end

		load_current_user!
		invalid_authentication unless @current_user
	end

	# Returns 401 for malformed / invalid requests.
	def invalid_authentication
		render json: {error: 'Invalid Authorization'}, status: :unauthorized
	end


	private

    # Decodes the JWT token from with Authorization Header.
    def payload
      auth_header = request.headers['Authorization']
      token = auth_header.split(' ').last
      JsonWebToken.decode(token)
      rescue
      nil
    end

    def load_current_user!
      @current_user = User.find_by(id: payload[0]['user_id'])
    end

end
