class UnprocessedImagesController < ApplicationController
  def create
    render partial: UnprocessedImage.create(unprocessed_image_params)
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
