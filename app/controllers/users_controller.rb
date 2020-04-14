class UsersController < ApplicationController
  before_action :set_user, except: [:login, :index, :create]
  before_action :authenticate_request!, only: [:update, :destroy]

  # POST /users/1/login
  def login
    user = User.find_by(email: user_params[:email].to_s.downcase)

    if user&.authenticate(user_params[:password])
      render json: payloader(user), status: :ok
    else
      render json: { error: 'Invalid username/password' }, status: :unauthorized
    end
  end

  # GET /users/1/posts
  def posts_index
    render json: @user.posts
  end

  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save && @user.authenticate(user_params[:password])
      render json: payloader(@user), status: :created
    elsif @user.errors[:email][0] .eql? "has already been taken"
      render json: @user.errors, status: :conflict
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if isUser

      if @user.update(user_params)
        render json: @user, status: :no_content
      else
        render json: @user.errors, status: :unprocessable_entity
      end

    else
      invalid_authentication
    end
  end

  # DELETE /users/1
  def destroy
    if isUser
      @user.destroy
    else
      invalid_authentication
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      user = User.find_by(id: params[:id])
      
      if user
       @user = user
      else
        render json: { error: 'User not found' }, status: :not_found
      end
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:email, :password)
    end

    # JWT Payload helper
    def payloader(user)
      if user.id.nil? || user.email.nil?
        return { error: 'invalid user format' }
      else
        {
          auth_token: JsonWebToken.encode({user_id: user.id}),
          user: {id: user.id, email: user.email}
        }
      end
    end

    def isUser
      @user == @current_user
    end
end
