class ApplicationController < ActionController::API

  private

  def renderErrorResponse(errorCode, errorMessage=Rack::Utils::HTTP_STATUS_CODES[errorCode])
    render :json => '{"status": ' + errorCode.to_s + ',"message": ' + errorMessage + ' }', :status => errorCode
  end
end
