class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,:recoverable,
  			 :rememberable, :trackable, :validatable


  def find_message

    # Lister toutes les conversations sans recepteur_id où transmitter_id est different du current_user_id 
    @conversation_with_no_recepter = Conversation.where("recepteur_id" => nil).where.not(transmitter_id: id).sample

    # In the case there is no question without answer
    if @conversation_with_no_recepter

      #Initialisation of pourcentage of finding a message
      @pourcetage_chance_of_finding_a_message = 100



      # The goal is now to give more chance to find a message for those who have a good average
     
      # COMMENT THIS PART FOR HAVING 100% TO FIND A MESSAGE - - - - - - - - - - - - - - 

      #we have averageMark between 0 & 5
      @averageMark = averageMark

      @averageMark *= 10 #now between 0 & 50

      @averageMark += 10 #now between 10 & 60

      #If you have 5/5 of average you have 60% to find a message = 2/3
      #If you have 2.5/5 of average, you have 35% to find a message = 1/3
      #If you have 0/5 of average, you have 10% to find a message = 1/10

      #Of course 60% it's a lot, even 35% is still a lot, but it's for the beta version !

      @pourcetage_chance_of_finding_a_message = @averageMark

      # END COMMENT THIS PART FOR HAVING 100% TO FIND A MESSAGE - - - - - - - - - - - - - - 

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
