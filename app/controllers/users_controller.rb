class UsersController < ApplicationController
  before_action :authenticate_user, {only: [:edit, :update, :show]}
  before_action :forbid_login_user, {only: [:new, :create, :login_form, :login]}
  before_action :ensure_correct_user, {only: [:edit, :update]}

  def index
    @users = []
    users_id = []

    if User.find_by(name: params[:name]) && Skill.find_by(name: params[:skill])
      puts 1
      skill = Skill.find_by(name: params[:skill])
      @skill_users = SkillUser.where(skill_id: skill.id)
      @skill_users.each do |skill_user|
        if skill_user.user.name == params[:name] && User.find_by(name: params[:name])
          users_id << skill_user.user.id
        end
      end
      @users = User.where(id: users_id).order("created_at DESC")

    elsif Skill.find_by(name: params[:skill])
      puts 2
      skill = Skill.find_by(name: params[:skill])
      @skill_users = SkillUser.where(skill_id: skill.id)
      @skill_users.each do |skill_user|
        users_id << skill_user.user.id
      end
      @users = User.where(id: users_id).order("created_at DESC")

    elsif User.find_by(name: params[:name])
      puts 3
      @users = User.where(name: params[:name]).order("created_at DESC")

    else
      puts 4
      @users = User.all.order("created_at DESC")
    end
    puts @users
    @users = @users.page(params[:page])
  end

  def show
    @user = User.find_by(id: params[:id])
    @posts = @user.posts
    @posts = @posts.page(params[:page])
    @skills_user = SkillUser.where(user_id: @user.id)
  end

  def login_form
  end

  def login
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:notice] = "ログインしました"
      redirect_to("/posts/index")
    else
      @error_message = "メールアドレスまたはパスワードが間違っています"
      @email = params[:email]
      @password = params[:password]
      render("users/login_form")
    end
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = "ログアウトしました"
    redirect_to("/login")
  end

  def new
    @user = User.new 
  end

  def create
    @user = User.new(
      name: params[:name],
      age: params[:age],
      email: params[:email],
      icon_image: "default_icon.jpg",
      banner_image: "default_banner.jpg",
      password: params[:password]
    )
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "ユーザー登録が完了しました"
      redirect_to("/users/#{@user.id}")
    else
      render("users/new")
    end
  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find_by(id: params[:id])
    @user.name = params[:name]
    @user.age = params[:age]
    @user.email = params[:email]
    @user.github = params[:github]
    @user.introduction = params[:introduction]
    @user.password = params[:password]
    

    if params[:icon_image]
      @user.icon_image = "#{@user.id}.jpg"
      image = params[:icon_image]
      File.binwrite("public/user_images/#{@user.icon_image}", image.read)
    end

    if params[:banner_image]
      @user.banner_image = "#{@user.id}.jpg"
      image = params[:banner_image]
      File.binwrite("public/banner_images/#{@user.banner_image}", image.read)
    end

    # プログラミングスキル登録
    @skills.each do |skill|
      if params["rd_#{skill.name}"] == "yes"
        if SkillUser.find_by(user_id: @user.id, skill_id: skill.id) == nil
          skill_user = SkillUser.new(user_id: @user.id, skill_id: skill.id)
          skill_user.save
        end
      
      # プログラミングスキル解除
      else params["rd_#{skill.name}"] == "no"
        skill_user = SkillUser.find_by(user_id: @user.id, skill_id: skill.id)
        if skill_user
          skill_user.destroy
        end
      end

    end

    if @user.save
      flash[:notice] = "ユーザー情報を編集しました"
      redirect_to("/users/#{@user.id}")
    else
      render("users/edit")
    end
  end

  def ensure_correct_user
    if @current_user.id != params[:id].to_i
      flash[:notice] = "権限がありません"
      redirect_to("/posts/index")
    end
  end
end
