class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,:recoverable,
  			 :rememberable, :trackable, :validatable


  def find_message
    # Dans une version plus avancée, il faudra prendre en compte la note de chaque utilisateur
    # Afin d'attribuer plus de message aux mieux notés

    # Lister toutes les conversations sans recepteur_id où transmitter_id est different du current_user_id 
    @conversation_with_no_recepter = Conversation.where("recepteur_id" => nil).where.not(transmitter_id: id).sample

    # In the case there is no question without answer
    if @conversation_with_no_recepter

      @pourcetage_chance_of_finding_a_message = 100

      if rand(100) < @pourcetage_chance_of_finding_a_message
      	@message_to_answer = Message.where(conversation_id: @conversation_with_no_recepter.id).first
      end
      
    end

    return @message_to_answer

  end

  def hasPublished?(conversation)
		# Let's check if the current user is the transmitter
  	if conversation.transmitter_id == id 
  		# If the conversaiton is published by transmitter	return true
  		conversation.published_by_transmitter
		# Let's check if the current user is the recepter
  	elsif conversation.recepteur_id == id
  		# If the conversation is published by recepter	return true
  		conversation.published_by_recepteur
  	end

  end

  #return the list of all unread message
  def unreadMessage?
    personalConversation = Conversation.where(transmitter_id: id) + Conversation.where(recepteur_id: id)

    Message.where(conversation_id: personalConversation.to_a).where(read: false).where.not(author_id: id)
  end 

  #return a list of unread message for a particular conversation
  def unreadMessageFrom(conversation_id)
    Message.where(conversation_id: conversation_id).where(read: false).where.not(author_id: id)
  end

  def averageMark
    #fait la moyenne de toutes les notes qu'a eu un user
    @average = Mark.where(user_liked_id: id).average(:mark)
    if @average.nil?
      return 2.5
    else
      return @average
    end
  end



end
