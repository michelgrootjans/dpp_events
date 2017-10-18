require 'sinatra'
require 'mongo'
require 'json/ext' # required for .to_json

configure do
  client = Mongo::Client.new([ 'mongo:27017' ], :database => 'quicknews')
  set :article_collection,   client[:articles]
end


set :bind, '0.0.0.0'

require 'slim'

get '/' do
  redirect '/articles'
end

get '/articles' do
  @articles = settings.article_collection.find
  slim :index
end

get '/articles/:reference' do
  @article = settings.article_collection.find(reference: params[:reference]).first
  slim :show
end
