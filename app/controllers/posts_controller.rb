class PostsController < ApplicationController
  before_action :ensure_correct_action, {only: [:edit, :update, :destroy]}

  def index
    @posts = Post.all.order("created_at DESC")
    @posts = @posts.page(params[:page])
  end

  def show
    @post = Post.find_by(id: params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(
      title: params[:title],
      link: params[:link],
      description: params[:description],
      user_id: @current_user.id
    )
    if params[:post_image]
      @post.post_image = "#{@post.id}.jpg"
      image = params[:post_image]
      File.binwrite("public/post_images/#{@post.post_image}", image.read)
    end

    if @post.save
      flash[:notice] = "投稿を作成しました"
      redirect_to("/posts/index")
    else
      render("posts/new")
    end
  end

  def edit
    @post = Post.find_by(id: params[:id])
  end

  def update
    @post = Post.find_by(id: params[:id])
    @post.title = params[:title]
    @post.link = params[:link]
    @post.description = params[:description]
    if params[:post_image]
      @post.post_image = "#{@post.id}.jpg"
      image = params[:post_image]
      File.binwrite("public/post_images/#{@post.post_image}", image.read)
    end
    if @post.save
      flash[:notice] = "投稿を編集しました"
      redirect_to("/posts/#{@post.id}")
    else
      render("posts/edit")
    end
  end

  def destroy
    @post = Post.find_by(
      id = params[:id]
    )
    @post.destroy
    flash[:notice] = "投稿を削除しました"
    redirect_to("/posts/index")
  end

  def ensure_correct_action
    @post = Post.find_by(id: params[:id])
    if @current_user.id != @post.user.id 
      flash[:notice] = "権限がありません"
      redirect_to("/posts/index")
    end
  end

end
