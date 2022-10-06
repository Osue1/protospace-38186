class PrototypesController < ApplicationController

  before_action :authenticate_user!, only: [:new, :create, :edit, :updata, :destroy]
  before_action :move_index, only: :edit

  def index
    @prototypes = Prototype.includes(:user)
  end

  def new
    @prototype = Prototype.new
  end

  def create
    @prototype = Prototype.new(prototype_params)
   if @prototype.save
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    set_prototype
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  def edit
    set_prototype
  end

  def update
    set_prototype
    if @prototype.update(prototype_params)
      redirect_to prototype_path
    else
      render :edit
    end
  end

  def destroy
    set_prototype
    @prototype.destroy
    redirect_to root_path
  end

  private

  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept ,:image).merge(user_id: current_user.id)
  end

  def move_index
    set_prototype
    unless @prototype.user == current_user
      redirect_to action: :index
    end
  end

  def set_prototype
    @prototype = Prototype.find(params[:id])
  end
end
