class Conversation < ActiveRecord::Base

	has_many :messages
  has_many :users

  def finished! #Pour clore la conversation
  	self.update_attribute(:finished, true)
  end

	def publish(publisher_id) 
	#mettre une des valeurs de publication à 1 (si les deux valeurs de publication sont à 1, la conversation est publique)
		if publisher_id == transmitter_id 
			self.update_attribute(:published_by_transmitter, true)
		end

		if publisher_id == recepteur_id
			self.update_attribute(:published_by_recepteur, true)
		end

	end

	def published?
		published_by_transmitter && published_by_recepteur
	end

	def lastMessage
		Message.where({conversation_id: id}).last
	end

	def firstMessage
		Message.where({conversation_id: id}).first
	end

	def numberOfMessage
		Message.where({conversation_id: id}).count
	end

	def unreadMessageby(user_id)
		# Conversation.where("transmitter_id = user_id OR recepteur_id = user_id")
		Message.where(conversation_id: id).where(read: false).where.not(author_id: user_id)
	end

	# Fonction that return the Mark object of the mark that user_id given to his interlocutor during this conversation
	def alreadyNotedBy(user_id)
		Mark.where(linked_conversation_id: id, user_liking_id: user_id)
	end

end
