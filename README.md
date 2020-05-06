# README

Example Text Api
	
	- uses Rails API mode to create a simple API with 'users' and 'posts'
	- Supports multiple Users signing up (POST /users) and logging in with JWT auth (POST /users/login)
	- Users can create/edit/delete their text posts
	- Anyone can view text posts

Hosted at: https://jts-example-app.herokuapp.com/

Endpoints:

	- GET, POST /users
	
	- POST /users/login
	
	- GET, PUT, DELETE /user/{user_id}
	
	- GET /user/{user_id}/posts
	
	- GET, POST /posts
	
	- GET, PUT, DELETE /posts/{id}


Json Objects Examples:

	{
		"user" {
			"email": "luke@rebel.base",
			"password": "ch0s3n0n3"
		}
	}

	{
		"post" {
			"text": "Blue Milk",
			"user_id": "1"
		}
	}


Full API Definition:
	- see Swagger_API_definitions.yaml file


Next Steps:

	- More Robust Serialization 
	- Response Pagination 
	- Caching / optimization
	- filtering / sorting (especially w/ a more complex schema) 
	- Throttling and RackAttack protections


Ruby version: 2.6.6

System dependencies:

	- rspec
	- JWT
	- bcrypt
	- other default rails dependencies

Initilization: 
	- bundle install
	- rails db:setup

Database: sqllite3 development and test, postgres production

How to run the test suite: bundle exec rspec
	- verifys models
	- tests requests

