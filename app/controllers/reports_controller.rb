class ReportsController < ApplicationController

  before_filter :authenticate_user!

  def index
    @title = "Reports"
  end

  def rating_breakdown
    @date_from = Date.strptime(params[:date_from].to_s, '%d/%m/%Y') rescue nil
    @date_to   = Date.strptime(params[:date_to].to_s, '%d/%m/%Y') rescue nil

    @title = "Star Rating Breakdown"
    @subtitle = "For Rated Calls"
    @subtitle += " from #{@date_from}" if @date_from
    @subtitle += " to #{@date_to}" if @date_to

    @graph = Rating.rating_breakdown_graph(@date_from, @date_to)
  end

  def campaign_breakdown
    @date_from = Date.strptime(params[:date_from].to_s, '%d/%m/%Y') rescue nil
    @date_to   = Date.strptime(params[:date_to].to_s, '%d/%m/%Y') rescue nil

    @title = "Campaign Breakdown"
    @subtitle = "Inbound calls by campaign number"
    @subtitle += " from #{@date_from}" if @date_from
    @subtitle += " to #{@date_to}" if @date_to

    @graph = Campaign.campaign_breakdown_graph(@date_from, @date_to)
  end
end
