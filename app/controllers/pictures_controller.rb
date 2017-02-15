class PicturesController < ApplicationController
  before_action :set_picture, only: [:show, :edit, :update, :destroy]

  def index
    if params[:search].present?
      keywords = params[:search].split("　").join(" ").split
      @pictures = Picture.tagged_with keywords, any: true
      @pictures = @pictures.page(params[:page]).per(9)
    else
      @pictures = Picture.all.order("id desc").page(params[:page]).per(9)
    end
  end

  def show
  end

  def new
    @picture = Picture.new
  end

  def edit
  end

  def create
    @picture = Picture.new(picture_params)

    if @picture.save
      flash[:success] = "画像がアップロードされました。"
      redirect_to @picture
    else
      render :new
      flash[:error] = "画像のアップロードに失敗しました。"
    end
  end

  def update
    if @picture.update(picture_params)
      flash[:success] = "情報が更新されました。"
      redirect_to @picture
    else
      render :edit
      flash[:error] = "情報の更新に失敗しました。"
    end
  end

  def destroy
    @picture.destroy
    flash[:success] = "画像が削除されました。"
    redirect_to pictures_url
  end

  private
    def set_picture
      @picture = Picture.find(params[:id])
    end
    
    def picture_params
      params.require(:picture).permit(:name, :photo, :tag_list)
    end
end
