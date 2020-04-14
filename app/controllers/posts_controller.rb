class PostsController < ApplicationController
  before_action :set_post, only: [:show, :update, :destroy]
  before_action :authenticate_request!, only: [:create, :update, :destroy]

  # GET /posts
  def index
    @posts = Post.all

    render json: @posts
  end

  # GET /posts/1
  def show
    render json: @post
  end

  # POST /posts
  def create
    if canWrite

      @post = Post.new(post_params)

      if @post.save
        render json: @post, status: :created, location: @post
      else
        render json: @post.errors, status: :unprocessable_entity
      end

    else
      invalid_authentication
    end
  end

  # PATCH/PUT /posts/1
  def update
    if canWrite && isMyPost

      if @post.update(post_params)
        render json: @post, status: :no_content
      else
        render json: @post.errors, status: :unprocessable_entity
      end

    else
      invalid_authentication
    end
  end

  # DELETE /posts/1
  def destroy
    if isMyPost
      @post.destroy
    else
      invalid_authentication
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      post = Post.find_by(id: params[:id])

      if post
       @post = post
      else
        render json: { error: 'Post not found' }, status: :not_found
      end
    end

    # Only allow a trusted parameter "white list" through.
    def post_params
      params.require(:post).permit(:text, :user_id)
    end

    def isMyPost
      @post.user_id .eql? @current_user.id
    end

    def canWrite
      post_params[:user_id] .eql? @current_user.id.to_s
    end
end
