require_relative '../dto/http_error_response_dto'
require_relative '../dto/http_response_dto'

class ApplicationController < ActionController::Base
  def send_success_response(response, http_code)
    response_dto = HTTPResponseDTO.new
    response_dto.response = response
    render json: response_dto, status: http_code
  end

  def send_error_response(icon_url, header, msg, custom_code, http_code)
    error_response = HTTPErrorResponseDTO.new
    error_response.icon_url = icon_url
    error_response.header = header
    error_response.message = msg
    error_response.custom_code = custom_code

    response_dto = HTTPResponseDTO.new
    response_dto.response = error_response

    render json: response_dto, status: http_code
  end
end
