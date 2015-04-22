class RespondersController < ApplicationController
  before_action :set_responder, only: [:show, :update]

  def index
    @responders = Responder.all

    render json: @responders
  end

  def show
    if @responder
      render json: @responder, status: :ok
    else
      fail ActiveRecord::RecordNotFound
    end
  end

  def create
    @responder = Responder.new(create_params)

    if @responder.save
      render json: @responder, status: :created
    else
      render json: { message: @responder.errors.messages }, status: :unprocessable_entity
    end
  end

  def update
    if @responder.update(update_params)
      render json: @responder, status: :ok
    else
      render json: { message: @responder.errors.messages }, status: :unprocessable_entity
    end
  end

  private

  def create_params
    params.require(:responder).permit(:type, :name, :capacity)
  end

  def update_params
    params.require(:responder).permit(:on_duty)
  end

  def set_responder
    @responder = Responder.find_by_name(params[:id])
  end
end
