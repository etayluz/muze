class UsersController < ApplicationController

	def create
		puts "create"
		@tweet = {"tweet"=>1}
		render json: @tweet
		# respond_to do |format|
		# 	format.json { render json: @tweet }
		# end
	end
end
