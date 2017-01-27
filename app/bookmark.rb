ENV["RACK_ENV"] ||= "development"

require 'sinatra/base'
require 'sinatra/flash'
require_relative 'data_mapper_setup'


class Bookmark < Sinatra::Base

  enable :sessions
  set :session_secret, 'super secret'

  get '/sign_up' do
    @user = User.new
    erb :sign_up
  end

  post '/sign_up' do
    user_email = params[:user_email]
    password = params[:password]
    password_confirmation = params[:password_confirmation]
    @user = User.create(user_email: user_email,
                      password: password,
                      password_confirmation: password_confirmation )
    if @user.save
    session[:user_id] = @user.id
    redirect to('/links')
    else
    flash.now[:notice] = "Password and confirmation password do not match"
    erb :sign_up
    end
  end

  helpers do
    def current_user
      @current_user ||= User.get(session[:user_id])
    end
  end

  get '/links' do
    @links = Link.all
    @users = User.all
    erb :links
  end

  get '/links/new' do
    erb :form
  end

  post '/links' do
    title = params[:title]
    url = params[:url]
    tag_split = params[:tag].split(" ")
    link = Link.new(title: title, url: url)
    tag_split.each do |item| link.tags << (Tag.first_or_create(name: item))
    end
    link.save
    redirect '/links'
  end

  get '/tags/:tag' do
    tag = Tag.first_or_create(name: params[:tag])
    @links = Link.all
    @link_tags = LinkTag.all
    @links = tag ? tag.links : []
    erb :links
  end
  register Sinatra::Flash
  run! if app_file == $0
end
