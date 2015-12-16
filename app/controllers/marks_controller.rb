class MarksController < ApplicationController

	def mark_params
    params.require(:mark).permit(:mark, :user_liked_id, :linked_conversation_id, :user_liking_id)
  end

	def create
		@new_mark = Mark.new(mark_params)
		@target_message_id = Conversation.find(@new_mark.linked_conversation_id).firstMessage.id
		if @new_mark.save
      flash[:notice] = "Votre note à bien été enregistrée !"
      redirect_to message_path id: @target_message_id
    else
      flash[:alert] = "Votre note n'a pas pu être enregistrer pour des raisons qui nous échappent"
      redirect_to message_path id: @target_message_id
    end



	end

	def show

	end

end