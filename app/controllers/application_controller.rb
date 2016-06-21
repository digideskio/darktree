class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token, if: :json_request?
  rescue_from ActionController::ParameterMissing, with: :handle_400

  def handle_400(exception)
    respond_to do |format|
      p exception
      p exception.param
      # TODO: format.html
      format.json { render json: { message: exception.message } }
    end
  end

  protected

  def json_request?
    request.format.json?
  end
end
