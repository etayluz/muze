class UsersController < ApplicationController

	def create
		@user = User.create({"uuid"=>params[:uuid]})
		render json: @user
		# puts "create"
		# @tweet = {"tweet"=>1}
		# render json: @tweet
	end
end
