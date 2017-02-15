class UsersController < ApplicationController

  before_filter :authenticate_manager!
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @title = "Users"

    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @title = "User"
  end

  # GET /users/new
  def new
    @title = "New User"

    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @title = "Edit User"
  end

  # POST /users
  # POST /users.json
  def create
    @title = "New User"
    # Mass assignment will fail unless :team is a Team instance, or nil
    @team = user_params[:team].blank? ? nil : Team.find(user_params[:team])
    user_params[:team] = @team
    
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @title = "Edit User"
    respond_to do |format|
      if (!params[:user][:password].blank? && !params[:user][:password_confirmation].blank?)
        # Let the model tell us if the confirmation doesn't match
        @user.password = params[:user][:password]
        @user.password_confirmation = params[:user][:password_confirmation]
      end
      @user.email = params[:user][:email]
      @user.first_name = params[:user][:first_name]
      @user.last_name = params[:user][:last_name]
      @user.manager = params[:user][:manager]
      @user.team = params[:user][:team].blank? ? nil : Team.find(params[:user][:team])
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit!
    end
end
