require 'sinatra'
require 'mongo'
require 'bunny'
require 'json'

configure do
  client = Mongo::Client.new([ 'mongo:27017' ], :database => 'dispatcher')
  set :article_collection,   client[:articles]

  conn = Bunny.new(hostname: 'queue')
  conn.start
  channel = conn.create_channel
  topic = channel.topic('articles_published')
  set :topic, topic
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

get '/articles/:reference/publish/:brand' do
  reference = params[:reference]
  brand = params[:brand]

  article = settings.article_collection.find(reference: reference).first
  article[:published_to] << brand
  settings.article_collection.update_one({reference: reference}, article )

  event = {
      reference: article[:reference],
      title: article[:title],
      content: article[:content]
  }
  settings.topic.publish(event.to_json, routing_key: brand)

  redirect '/articles'
end