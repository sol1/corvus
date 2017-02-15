require 'number_range' # To get STI'ed models

class CampaignsController < ApplicationController

  before_filter :authenticate_manager!
  before_action :set_campaign, only: [:show, :edit, :update, :destroy]

  # GET /campaigns
  # GET /campaigns.json
  def index
    @campaigns = Campaign.all
  end

  # GET /campaigns/1
  # GET /campaigns/1.json
  def show
  end

  # GET /campaigns/new
  def new
    @campaign = Campaign.new
  end

  # GET /campaigns/1/edit
  def edit
  end

  # POST /campaigns
  # POST /campaigns.json
  def create
    @campaign = Campaign.new(campaign_params)
    if params[:number_ranges]
      manage_number_ranges params[:number_ranges]
    end
    respond_to do |format|
      if @campaign.save
        format.html { redirect_to @campaign, notice: 'Campaign was successfully created.' }
        format.json { render :show, status: :created, location: @campaign }
      else
        format.html { render :new }
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /campaigns/1
  # PATCH/PUT /campaigns/1.json
  def update
    if params[:number_ranges]
      manage_number_ranges params[:number_ranges]
    end
    respond_to do |format|
      if @campaign.update(campaign_params)
        format.html { redirect_to @campaign, notice: 'Campaign was successfully updated.' }
        format.json { render :show, status: :ok, location: @campaign }
      else
        format.html { render :edit }
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /campaigns/1
  # DELETE /campaigns/1.json
  def destroy
    @campaign.destroy
    respond_to do |format|
      format.html { redirect_to campaigns_url, notice: 'Campaign was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def manage_number_ranges number_ranges
      for number_range in number_ranges
        if number_range[:id]
          nr = CampaignNumberRange.find(number_range[:id])
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
            nr = CampaignNumberRange.new(:parent_id => @campaign.id)
            nr.start = number_range[:start].blank? ? number_range[:end] : number_range[:start]
            nr.end = number_range[:end].blank? ? number_range[:start] : number_range[:end]
            nr.save
          end
        end
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_campaign
      @campaign = Campaign.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def campaign_params
      params.require(:campaign).permit(:name)
    end
end
