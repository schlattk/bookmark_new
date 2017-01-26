ENV["RACK_ENV"] ||= "development"

require 'sinatra/base'
require_relative 'data_mapper_setup'

class Bookmark < Sinatra::Base
  get '/' do
    'Hello Bookmark!'
    redirect '/links'
  end

  get '/links' do
    @links = Link.all


    erb :links
  end

  get '/links/new' do
    erb :form
  end

  post '/links' do
    title = params[:title]
    url = params[:url]
    tag = params[:tag]
    link = Link.new(title: title, url: url)
    tag = Tag.first_or_create(name: tag)
    link.tags << tag
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

  # start the server if ruby file executed directly
  run! if app_file == $0
end
