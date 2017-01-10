require 'sinatra'
require 'json'
require_relative 'config/application'

set :bind, '0.0.0.0'  # bind to all interfaces

helpers do
  def current_user
    if @current_user.nil? && session[:user_id]
      @current_user = User.find_by(id: session[:user_id])
      session[:user_id] = nil unless @current_user
    end
    @current_user
  end
end

get '/' do
  redirect '/meetups'
end

get '/auth/github/callback' do
  user = User.find_or_create_from_omniauth(env['omniauth.auth'])
  session[:user_id] = user.id
  flash[:notice] = "You're now signed in as #{user.username}!"

  redirect '/'
end

get '/sign_out' do
  session[:user_id] = nil
  flash[:notice] = "You have been signed out."

  redirect '/'
end

get '/meetups' do
  @meetups = Meetup.order(:name).all

  erb :'meetups/index'
end

get '/meetups/new' do
  @meetup = Meetup.new
  erb :'meetups/new'
end

get '/meetups/:id' do
  meetup_creator = Meetup.includes(:creator)
  @meetup = meetup_creator.find(params[:id])

  @members = Meeting.includes(:user).where(meetup_id: params[:id])

  @current_member = false

  if current_user
    @members.each do |member|
      if (member[:user_id] == current_user.id)
        @current_member = true
        break
      end
    end
  end

  erb :'meetups/show'
end

get '/meetups/edit/:id' do
  @meetup = Meetup.find(params[:id])
  @errors = []

  erb :'meetups/edit'
end

post '/meetups/create' do
  params[:meetup][:creator_id]  = current_user.id
  @meetup = Meetup.new(params[:meetup])

  if @meetup.save
    flash[:notice] = "You have created a meetup successfully."
    redirect "/meetups/#{@meetup.id}"
  else
    erb :'meetups/new'
  end
end

post '/meetups/:id' do
  meetup_id = params[:id]

  if (current_user.nil?)
    flash[:notice] = "You must sign in first!"
    redirect "/"
  else
    user_id = current_user.id
  end

  meeting = Meeting.new(meetup_id: meetup_id, user_id: user_id)

  if meeting.save
    flash[:notice] = "You have joined the meetup"
    redirect "/meetups/#{meetup_id}"
  else
    erb :"meetups/#{meetup_id}"
  end
end

post '/meetups/edit/:id' do
  @currentmeetup = Meetup.find(params[:id])

  begin
    @currentmeetup.update_attributes!(params[:meetup])

    flash[:notice] = "The meetup has been successfully updated"
    redirect "/meetups/#{params[:id]}"
  rescue ActiveRecord::RecordInvalid => invalid
    @errors = invalid.record.errors
    @meetup = Meetup.find(params[:id])

    erb :"/meetups/edit"
  end
end

delete '/meetups/:id' do
  Meetup.find(params[:id]).destroy

  redirect "/"
end

# delete '/meetups/leave/:id' do
#   Meeting.delete_all(meetup_id: params[:id], user_id: current_user.id)
#
#   redirect "/meetups/#{params[:id]}"
# end

post '/meetups/leave/:id' do
    Meeting.delete_all(meetup_id: params[:id], user_id: current_user.id)

    redirect "/meetups/#{params[:id]}"
end

#Ajax RESTful
post '/api/v1/meetups.json' do
  unless params[:meetup_id].nil? || params[:meetup_id].empty?
    user_id = current_user.id
    meetup_id = params[:meetup_id]

    meeting = Meeting.new(meetup_id: meetup_id, user_id: user_id)

    if meeting.save
      halt 201, { id: current_user.id, name: current_user.username, avatar_url: current_user.avatar_url }.to_json
    else
      status 400
    end
  else
    status 400
  end
end

post '/api/v1/meetups/leave.json' do
  unless params[:meetup_id].nil? || params[:meetup_id].empty?
    user_id = current_user.id
    meetup_id = params[:meetup_id]

    Meeting.delete_all(meetup_id: meetup_id, user_id: user_id)

    halt 201, { id: current_user.id }.to_json
  else
    status 400
  end
end
