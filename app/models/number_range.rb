class NumberRange < ActiveRecord::Base

  validates_presence_of :start
end

class TeamNumberRange < NumberRange

  belongs_to :team
end

class CampaignNumberRange < NumberRange

  belongs_to :campaign
end
