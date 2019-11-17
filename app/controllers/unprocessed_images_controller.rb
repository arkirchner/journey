class UnprocessedImagesController < ApplicationController
  def show
    render partial: UnprocessedImage.with_user(current_user).find(params[:id])
  end

  def create
    image = UnprocessedImage.create(unprocessed_image_params)
    image.process_later
    render partial: image
  end

  def edit
    render "update", layout: false
  end

  private

  def unprocessed_image_params
    params.require(:unprocessed_image).permit(:image).merge(
      user: current_user, uploader_ip: request.remote_ip,
    )
  end
end
