class ApplicationController < ActionController::Base
  ActionController::Parameters.action_on_unpermitted_parameters = :raise

  rescue_from ActionController::RoutingError, with: :render_not_found
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActionController::UnpermittedParameters, with: :render_unpermitted_params

  private

  def render_not_found
    render file: File.join(Rails.root, 'public', '404.json'), status: :not_found
  end

  def render_unpermitted_params(exception)
    render_unprocessable_entity(exception.message)
  end

  def render_unprocessable_entity(errors)
    render json: { message: errors }, status: :unprocessable_entity
  end
end
