get '/' do
  # render home page
  @users = User.all

  erb :index
end


#----------- SESSIONS -----------

get '/sessions/new' do
  # render sign-in page
  @email = nil
  erb :sign_in
end

post '/sessions' do
  # sign-in
  @email = params[:email]
  user = User.authenticate(@email, params[:password])
  if user
    # successfully authenticated; set up session and redirect
    session[:user_id] = user.id
    redirect to("/user/#{session[:user_id]}")
  else
    # an error occurred, re-render the sign-in form, displaying an error
    @error = "Invalid email or password."
    erb :sign_in
  end
end


delete '/sessions/:id' do
  # sign-out -- invoked via AJAX
  return 401 unless params[:id].to_i == session[:user_id].to_i
  session.clear
  200
end


#----------- USERS -----------

get '/users/new' do
  # render sign-up page
  @user = User.new
  erb :sign_up
end

post '/users' do
  # sign-up
  @user = User.new params[:user]
  if @user.save
    # successfully created new account; set up the session and redirect
    session[:user_id] = @user.id
    redirect to ("/user/#{session[:user_id]}")
  else
    # an error occurred, re-render the sign-up form, displaying errors
    erb :sign_up
  end
end


get "/user/:id" do
  @user = User.find(session[:user_id])
  erb :profile
end

get "/users/skills/:id" do 
  @proficiency = Proficiency.find(params[:id])
  erb :update
end

get "/user/skills/new" do
  @user = User.find(session[:user_id])
  erb :new_skill
end

post "users/skills/new" do
  proficiency = Proficiency.new
  proficiency.user = User.find(session[:user_id])
  proficiency.skill = Skill.find(params[:id])
  proficiency.formal = params[:formal].to_i
  proficiency.years = params[:years].to_i
  proficiency.save
  redirect to("/user/#{session[:user_id]}")
end

post "/users/skills/:id" do 
  proficiency = Proficiency.find(params[:id])
  proficiency.years = params[:years].to_i
  proficiency.formal = params[:formal].to_i
  proficiency.save
  redirect to("/user/#{proficiency.user.id}")
end

post "/users/skills/delete/:id" do 
  proficiency = Proficiency.find(params[:id])
  proficiency.destroy
  redirect to("/user/#{session[:user_id]}")
end
