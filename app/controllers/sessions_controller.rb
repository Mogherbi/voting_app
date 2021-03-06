class SessionsController < ApplicationController
  def new
  end

  def create
    redirect_to "#{ENV["ADMISSION_URL"]}/oauth/authorize?response_type=code&client_id=#{ENV["CLIENT_ID"]}&redirect_uri=#{ENV["CALLBACK_URL"]}"
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "You're now logged out"
  end

  def create_from_oauth
    response = RestClient.post("#{ENV["ADMISSION_URL"]}/oauth/token",
                               {
                                 "client_id": ENV['CLIENT_ID'],
                                 "client_secret": ENV['CLIENT_SECRET'],
                                 "grant_type": "authorization_code" ,
                                 "code": params[:code],
                                 "redirect_uri": ENV["CALLBACK_URL"]
    })
    auth_hash = JSON.parse(response.body)

    user = User.find_by(email: auth_hash["email"]) || User.create(name: auth_hash["name"], email: auth_hash["email"], user_uuid: auth_hash["user_uuid"])

    # filtered_hash = { email: auth_hash["email"], user_uuid: auth_hash["user_uuid"] }
    # user = User.find_or_initialize_by(filtered_hash)
    # user.update(auth_hash)

    if user.id
      session[:user_id] = user.id
      redirect_to '/admin'
    else
      redirect_to '/sign_in', notice: "Something went wrong, please contact the admin."
    end
  end
end
