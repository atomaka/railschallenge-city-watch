class EmergenciesController < ApplicationController
  before_action :set_emergency, only: [ :show, :update ]
  def index
    @emergencies = Emergency.all

    render json: @emergencies
  end

  def show
    if @emergency
      render json: @emergency
    else
      raise ActiveRecord::RecordNotFound
    end
  end

  def create
    @emergency = Emergency.new(create_params)

    if @emergency.save
      render json: @emergency, status: :created
    else
      render json: { message: @emergency.errors.messages }, status: :unprocessable_entity
    end
  end

  def update
    if @emergency.update(update_params)
      render json: @emergency, status: :ok
    else
      render json: { message: @emergency.errors.messages }, status: :unprocessable_entity
    end
  end

  private

  def create_params
    params.require(:emergency).permit(:code, :fire_severity, :police_severity, :medical_severity)
  end

  def update_params
    params.require(:emergency).permit(:fire_severity, :police_severity, :medical_severity, :resolved_at)
  end

  def set_emergency
    @emergency = Emergency.find_by_code(params[:id])
  end
end
