require 'sinatra/base'
require_relative 'models/link.rb'

class Bookmark < Sinatra::Base
  get '/' do
    'Hello Bookmark!'
    redirect '/links'
  end

  get '/links' do
    @links = Link.all
    linkone = @links[0].title

    erb :links
  end

  get '/links/new' do
    erb :form
  end

  post '/links' do
    title = params[:title]
    url = params[:url]
    Link.create(title: title, url: url)
    redirect '/links'
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
