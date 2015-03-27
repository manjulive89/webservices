class Api::V2Controller < ApiController
  before_action :authenticate_by_api_key

  ActionController::Parameters.action_on_unpermitted_parameters = :raise

  rescue_from(ActionController::UnpermittedParameters) do |e|
    render json:   { error:  { unknown_parameters: e.params } },
           status: :bad_request
  end

  rescue_from(Exceptions::InvalidDateRangeFormat) do |_e|
    render json:   { error:  'Invalid Date Range Format' },
           status: :bad_request
  end

  private

  def authenticate_by_api_key
    api_key = params[:api_key] || request.headers['Api-Key']

    unless api_key && User.to_adapter.find_first(api_key: api_key)
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end
