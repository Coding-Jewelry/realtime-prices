class SessionsController < ApplicationController
	def new
 	end

	def create
		user = User.find_by(email: params[:session][:email].downcase)
    	if user && user.authenticate(params[:session][:password]) && (user.domain.company_id == params[:session][:domain_id])
      		sign_in user
          flash[:notice] = 'Successful login'
      		redirect_back_or user
    	else
      		flash[:alert] = 'Invalid email/password combination'
      		redirect_to signin_path
    	end
	end

	def destroy
    sign_out
    redirect_to root_url
  end
end
