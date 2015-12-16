class Mark < ActiveRecord::Base
	has_many :users
	has_many :conversations

	def average
		#fait la moyenne de toutes les notes qu'a eu un user
		Mark.average(:age) # => 35.8
	end
end
