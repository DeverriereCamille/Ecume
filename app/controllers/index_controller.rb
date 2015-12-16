class IndexController < ApplicationController

  def home
  	@message = Message.new

  	# Si l'utilisateur courant n'a pas de nouvelles conversation qui lui sont adressée
  		# Rechercher toutes les conversations avec une seul message où le id_recepteur = currentuser.id 
  		@unreplied_conversation = Conversation.where(recepteur_id: current_user.id).last

  		# Si il n'y a pas de conversation du tout, fixer la valeur à 0 pour ne pas qu'elle soit nil
  		if @unreplied_conversation.present? 
  			number_of_message = @unreplied_conversation.numberOfMessage
  		else
  			number_of_message = 0
  		end

  		if number_of_message == 1
  			# looking for the content of a conversation with only the question
  			@message_to_answer = @unreplied_conversation.lastMessage
  			@message_to_answer_content = @message_to_answer.content
  			@message_to_answer_id = @message_to_answer.id

  		else
  			# If no message to answer, let's find a message
  			@found_messages = current_user.find_message
  			if @found_messages.present?
  				@message_to_answer = @found_messages
  				@message_to_answer_content = @found_messages.content
  				@message_to_answer_id = @found_messages.id
  			end
  		end
  end

  def general
  	@users = User.all
  	@messages = Message.all
  	@conversations = Conversation.all
  	@conversations_with_no_recepter = Conversation.where(recepteur_id: nil)
  end

  def research
  	@q = Message.ransack()
    @message_reasult = @q.result()
  	# @messages = @q.result(distinct: true)
  end



end
