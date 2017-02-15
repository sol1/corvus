require 'number_range' # To get STI'ed models

class TeamsController < ApplicationController

  before_filter :authenticate_manager!
  before_action :set_team, only: [:show, :edit, :update, :destroy]

  # GET /teams
  # GET /teams.json
  def index
    @teams = Team.all
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
  end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # GET /teams/1/edit
  def edit
  end

  # POST /teams
  # POST /teams.json
  def create
    @team = Team.new(team_params)
    if params[:number_ranges]
      manage_number_ranges params[:number_ranges]
    end
    respond_to do |format|
      if @team.save
        format.html { redirect_to @team, notice: 'Team was successfully created.' }
        format.json { render :show, status: :created, location: @team }
      else
        format.html { render :new }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teams/1
  # PATCH/PUT /teams/1.json
  def update
    if params[:number_ranges]
      manage_number_ranges params[:number_ranges]
    end
    respond_to do |format|
      if @team.update(team_params)
        format.html { redirect_to @team, notice: 'Team was successfully updated.' }
        format.json { render :show, status: :ok, location: @team }
      else
        format.html { render :edit }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy
    @team.destroy
    respond_to do |format|
      format.html { redirect_to teams_url, notice: 'Team was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def manage_number_ranges number_ranges
      for number_range in number_ranges
        if number_range[:id]
          nr = TeamNumberRange.find(number_range[:id])
          # If both start and end are blank assume the operator wishes to remove this entry entirely
          if number_range[:start].blank? && number_range[:end].blank?
            nr.destroy
          else
            # If only one of start or end are specified, set the other to match it (ie this is to filter a single number)
            nr.start = number_range[:start].blank? ? number_range[:end] : number_range[:start]
            nr.end = number_range[:end].blank? ? number_range[:start] : number_range[:end]
            nr.save
          end
        else
          # Create a new number range if at least one of start or end is specified
          if !number_range[:start].blank? || !number_range[:end].blank?
            nr = TeamNumberRange.new(:parent_id => @team.id)
            nr.start = number_range[:start].blank? ? number_range[:end] : number_range[:start]
            nr.end = number_range[:end].blank? ? number_range[:start] : number_range[:end]
            nr.save
          end
        end
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def team_params
      params.require(:team).permit(:name)
    end
end
