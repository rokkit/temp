class Api::V1::BaseController < ApplicationController
  skip_before_action :verify_authenticity_token # TODO: включить CSRF защиту

  before_action :cors_preflight_check, :token_auth
  after_action :cors_set_access_control_headers


  def token_auth
    if params[:auth_token]
      user = User.find_by_auth_token(params[:auth_token])
      if user
      sign_in user
      else
        head :unauthorized
        return
      end
    end
  end
  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Accept, Authorization, Token'
    headers['Access-Control-Max-Age'] = '1728000'
  end

  def cors_preflight_check
    if request.method == 'OPTIONS'
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
      headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version, Token'
      headers['Access-Control-Max-Age'] = '1728000'

      render text: '', content_type: 'text/plain'
    end
  end
end
