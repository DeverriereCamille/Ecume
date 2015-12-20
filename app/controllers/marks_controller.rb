class MarksController < ApplicationController

	def mark_params
    params.require(:mark).permit(:mark, :user_liked_id, :linked_conversation_id, :user_liking_id)
  end

	def create
		@new_mark = Mark.new(mark_params)
		@target_message_id = Conversation.find(@new_mark.linked_conversation_id).firstMessage.id
		if @new_mark.save
      flash[:notice] = "Your mark has been saved"
      redirect_to message_path id: @target_message_id
    else
      flash[:alert] = "Your mark hasn't been saved :/"
      redirect_to message_path id: @target_message_id
    end



	end

	def show

	end

end