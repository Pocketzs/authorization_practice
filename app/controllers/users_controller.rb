class UsersController <ApplicationController 
  before_action :require_user, only: [:show]
    def new 
        @user = User.new()
    end 

    def show 
        @user = User.find(params[:id])
    end 

    def create 
        user = User.create(user_params)
        if user.save
            session[:user_id] = user.id
            redirect_to user_path(user)
        else  
            flash[:error] = user.errors.full_messages.to_sentence
            redirect_to register_path
        end 
    end 

    def login_form

    end 

    def login_user
        user = User.find_by(email: params[:email])
        if user && user.authenticate(params[:password])
            session[:user_id] = user.id
            redirect_to "/users/#{user.id}"
        else 
            flash[:error] = "Bad Credentials, try again."
            redirect_to "/login" 
        end 
    end 

    def logout_user
      session.delete(:user_id)
      redirect_to root_path
    end

    private 

    def user_params 
        params.require(:user).permit(:name, :email, :password)
    end 
end 