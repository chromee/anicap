class PicturesController < ApplicationController
  before_action :set_picture, only: [:show, :edit, :update, :destroy]
  protect_from_forgery except: [:create]
  before_action :set_page, only: [:index, :show, :new]
  
  PER_PAGE = 24

  def index
    if params[:search].present?
      keywords = params[:search].split(",")
      @pictures = Picture.tagged_with keywords, any: true
      @pictures = @pictures.page(params[:page]).per(PER_PAGE)
    else
      @pictures = Picture.all.order("id desc").page(params[:page]).per(PER_PAGE)
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

    respond_to do |format|
      if @picture.save
        format.html do
          flash[:success] = "画像がアップロードされました。"
         redirect_to @picture
        end
        format.json { render :show, status: :created, location: @picture }

      else
        format.html do
          render :new
          flash[:error] = "画像のアップロードに失敗しました。"
        end
        format.json { render json: @picture.errors, status: :unprocessable_entity }
      end
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
      if request.path_parameters[:format] == "json"
        json_request = ActionController::Parameters.new(JSON.parse(request.body.read))
        json_request.require(:picture).permit(:name, :photo, :tag_list)
      else
        params.require(:picture).permit(:name, :photo, :tag_list)
      end
    end
    
    def set_page
      @page = params[:page]
    end
end
