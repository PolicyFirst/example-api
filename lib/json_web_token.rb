require 'jwt'

class JsonWebToken
	
	#encode and sign email, password, and expiration date with Secret Key
	def self.encode(payload)
		payload.reverse_merge!(meta)
		JWT.encode(payload, Rails.application.credentials.fetch(:secret_key_base))
	end

	# Decode JWT to recieve user email
	def self.decode(token)
		JWT.decode(token, Rails.application.credentials.fetch(:secret_key_base))
	end

	# validates JWT date, issuer, and audience 
	def self.valid_payload(payload)
		if isExpired(payload) || payload['iss'] != meta[:iss] || payload['aud'] != meta[:aud]
			return false
		else
			return true
		end
	end

	# options encoded in JWT
	def self.meta
		{
		exp: 7.days.from_now.to_i,
		iss: 'issuer_name',
		aud: 'client',
		}
	end

	# validates JWT expiration
	def self.isExpired(payload)
		Time.at(payload['exp']) < Time.now
	end

end
