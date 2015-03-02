class Api::V2Controller < ApiController
  before_action :authenticate_by_api_key

  private

  def authenticate_by_api_key
    api_key = params[:api_key] || request.headers['Api-Key']

    unless api_key && User.to_adapter.find_first(api_key: api_key)
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end
