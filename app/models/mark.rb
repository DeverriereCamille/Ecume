class Mark < ActiveRecord::Base
	has_many :users
	has_many :conversations

end
