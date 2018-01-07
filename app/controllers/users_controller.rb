class UsersController < ApplicationController
	before_action :signed_in_user, only: [:show]		
	before_action :correct_user,   only: [:show]


	def show
		@user = User.find(params[:id])
	end

	
		
	
	

	private

    	def user_params
    		params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation, :domain_id)
    	end

    	def signed_in_user
      		unless signed_in?
        		store_location
        		redirect_to signin_url, alert: "Please sign in."
      		end
    	end

    	def correct_user
      		@user = User.find(params[:id])
      		redirect_to(root_url) unless current_user?(@user)
    	end
end
