class ApplicationController < ActionController::Base
  ActionController::Parameters.action_on_unpermitted_parameters = :raise

  rescue_from ActionController::RoutingError, with: :not_found
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::UnpermittedParameters, with: :unpermitted_params

  private

  def not_found
    render file: File.join(Rails.root, 'public', '404.json'), status: :not_found
  end

  def unpermitted_params(exception)
    unprocessable_entity(exception.message)
  end

  def unprocessable_entity(errors)
    render json: { message: errors }, status: :unprocessable_entity
  end
end
