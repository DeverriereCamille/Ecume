class MessagesController < ApplicationController
  include ActiveModel::Validations
  validates :content, presence: true
  validates :content, length: { minimum: 5 }

  def message_params
      params.require(:message).permit(:content, :conversation_id)
  end



  # def answer_params
  #   params.require(:answer).permit(:content, :conversation_id)
  # end

  def edit
    # current_user.id = 25
    # Si le get précise la fermeture d'une conversation
    if !params[:conversation_to_close_id].nil?
      @conversation_to_close = Conversation.find(params[:conversation_to_close_id])
      @conversation_to_close.finished!
      redirect_to message_path
    end

    # Si le get précise la publication d'une conversation
    if !params[:conversation_to_publish_id].nil?
      # On va voir lequel des interlocuteur clos la conversation_id
      @conversation_to_publish = Conversation.find(params[:conversation_to_publish_id])
      
      @conversation_to_publish.publish(current_user.id)
      redirect_to message_path
    end
    # @

  end

  def create

    if message_params[:content].length < 5
      flash[:notice] = "Think about writing some stuff before sending !"      
      redirect_to root_path
    else

      # Create a message

      # If conversation_id is known, it's an answer
      if message_params[:conversation_id].present?
        @message = Message.new(message_params.merge(author_id: current_user.id, read: false))

        flash[:notice] = "Your answer is now sent !"
      
      else # If conversation_id isn't known, we have to create the converation
    
        # Create and record this new conversation
        # Generate a random string
        @unlocking_key = (0...50).map { ('a'..'z').to_a[rand(26)] }.join
        @current_conversation = Conversation.new({transmitter_id: current_user.id, unlocking_key: @unlocking_key.to_s})
        @current_conversation.save
        @current_conversation_id = @current_conversation.id
        
        @message = Message.new(message_params.merge(author_id: current_user.id, read: false, conversation_id: @current_conversation_id))
        flash[:notice] = "Your message is now far, be patient, it may take time to come back !"
        
      end
   

      if @message.save
        redirect_to root_path
      else
        flash[:alert] = "Your message is not sent"
        redirect_to root_path
      end
    end
  end


  def show
    # Collect the id in get for display messages
  	@message= Message.find(params[:id])

    

    # Find the conversation to display, based on the collected message
    @conversation = Conversation.find(@message.conversation_id)

    # CHECK IF THE CURRENT USER IS AUTHORISED TO SEE IT - - - - - - - - - - - - - - - 

    # If the conversation isn't published and if the current_user isn't the transmitter or the recepteur
    # ( OR if the transmitter try to access by himself to his own message)
    if ((!@conversation.published?) && (current_user.id != @conversation.transmitter_id) && ((@conversation.recepteur_id.present?) && (current_user.id != @conversation.recepteur_id)) || (@conversation.transmitter_id == current_user.id && @conversation.recepteur_id.nil? ))
      # Just tell to the current user to go fuck around
      flash[:alert] = "You arn't authorised to access to this page"
      if !@conversation.published?
        flash[:alert] += " - This is a private conversation"
      end
      if current_user.id != @conversation.transmitter_id && current_user.id != @conversation.recepteur_id
        flash[:alert] += " and you are not part of interlocutors"
      end
      redirect_to root_path
      
    else # IF THE CURRENT USER IS AUTHORISED - - - - - - - - - - - - - 

      # If you aren't the first to see this message
      if @conversation.recepteur_id.present?

        #Define the @interlocuteur
        if current_user.id == @conversation.transmitter_id
          if @conversation.recepteur_id
            @interlocutor = User.find(@conversation.recepteur_id)
          end
        else
          @interlocutor = User.find(@conversation.transmitter_id)
        end

        if @conversation.finished
          # Nessessary variable for form creation 
          @new_mark = Mark.new
        end


      else #If there is no recepteur (let's be the recepteur)
        #Have a check on the "unlocking_key" value, cause there is onlu one way to arrive here

        # - - - - - - - - - - - - - -  - <
        if params[:unlocking_key] != @conversation.unlocking_key
          flash[:notice] = "Well tried, but no, it's messages that are coming to you, and not you coming to messages !"
          redirect_to root_path
        end

        # If it's an answer, lets record you as the recepteur
        #the folowing if is useless normally but it's to be sure
        if Conversation.find(@message.conversation_id).transmitter_id != current_user.id
          Conversation.find(@message.conversation_id).update!(recepteur_id: current_user.id)
          # Define again the "@conversation" because of updates
          @conversation = Conversation.find(@message.conversation_id)
        end
      end


      # If some message wasn't read
      @reading_message = Message.where(conversation_id: @conversation.id).where.not(author_id: current_user.id).update_all(:read => true)

      # Display conversation's messages from the most recent to the older 
      @all_messages = Message.where({conversation_id: @message.conversation_id}).sort_by(&:created_at)
      
      # Variable nécessaire à la création d'une réponse dans le formulaire
      @answer = Message.new

    end
  end

  # Mes conversations
  def index
    # Réunir les conversation ou 
    # =>  le user_curent est l'émetteur et ou il y a un recepteur et ou il y a plus d'un message
    # +  le user_curent est le récepteur

    @questions = Conversation.where(transmitter_id: current_user.id).where.not(recepteur_id: nil)
    @answers = Conversation.where(recepteur_id: current_user.id)
    @conversation_full = @questions + @answers

    # bug noticed : A user could become Recepter when he clic on the "repondre" link, then the transmitter is able to see the conversation even if the recepter didn"t replied..
    # -> But anyway, if a user see a conversation, he could only respond to this one, then we can consider he will do if faster

    if params[:q].present?
      @query = Message.ransack(params[:q])

      #check if the size of the query is enough long :
      if @query.content_cont.size <= 2
        flash[:alert] = "Make a query with more than 2 caracters for more pertinence !"
        #Fix some variable to nil or empty stuff for nothing to appear
        @query = nil
        @conversation_full = Array.new
        @message_result_query = Array.new
      else

        #list of Mesages contains :q inside
        @message_result_query = @query.result()

        #Array of Message contains :q inside
        @array_message_result = Array.try_convert(@message_result_query)


        @conversation_full = Array.new
        @array_message_result.each do |i|
          if Conversation.find(i.conversation_id).published?
            @conversation_full.push(Conversation.find(i.conversation_id))
          end

        end

      end  #end if minimum query size


    end #end of if presence params :q


  end # end of index method

  # def answering(conversation_id)
  #   @message = Message.new(message_params.merge(author_id: current_user.id, conversation_id: conversation_id))
  # end

  def particular_conversation
    @this_conversation = Conversation.find(params[:id])
  end

end