# frozen_string_literal: true

# general controller class
class ApplicationController < ActionController::API
  private

  def render_error_response(
    error_code,
    error_message = Rack::Utils::HTTP_STATUS_CODES[error_code]
  )
    json = { status: error_code.to_s, message: error_message }
    render json: json, status: error_code
  end
end
