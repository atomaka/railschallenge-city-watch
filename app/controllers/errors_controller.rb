class ErrorsController < ApplicationController
  def catch_404
    not_found
  end
end
