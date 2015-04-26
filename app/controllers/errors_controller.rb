class ErrorsController < ApplicationController
  def catch_404
    # rubocop violation on following exception
    # fail ActionController::RoutingError.new(params[:path])
    render_not_found
  end
end
