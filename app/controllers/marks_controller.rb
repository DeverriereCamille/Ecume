class MarksController < ApplicationController

	protect_from_forgery with: :null_session

	def create
    flash[:notice] = "Personne n'a été noté pour l'instant !"
		redirect_to message_path
	end

	def index

	end

end