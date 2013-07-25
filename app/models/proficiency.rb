class Proficiency < ActiveRecord::Base
  belongs_to :user
  belongs_to :skill
  validates  :years, :formal, :presence => true# Remember to create a migration!
end
