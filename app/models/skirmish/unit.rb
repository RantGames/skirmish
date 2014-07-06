class Skirmish::Unit < ActiveRecord::Base
  belongs_to :city, class_name: 'Skirmish::City'
end
