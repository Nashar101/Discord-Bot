class ApplicationController < ActionController::API
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  before_action :authenticate_request

  private
  def authenticate_request
    puts request.headers["Authorization"]
    puts ENV["TERRARIA_SERVER_API_KEY"]
    return render json: {error: "Invalid API Key, nice try" }, status: 401 if request.headers["Authorization"] != ENV["TERRARIA_SERVER_API_KEY"]

    puts ""
  end
end
