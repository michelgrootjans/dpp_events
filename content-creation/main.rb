require 'sinatra'
require 'mongo'
require 'bunny'
require 'time'

configure do
  client = Mongo::Client.new([ 'mongo:27017' ], :database => 'content')
  set :article_collection,   client[:articles]

  conn = Bunny.new(hostname: 'queue')
  conn.start
  channel = conn.create_channel
  topic = channel.fanout('articles_written')
  set :topic, topic
end


set :bind, '0.0.0.0'

require 'slim'

get '/' do
  redirect '/articles'
end

get '/articles' do
  @drafts = settings.article_collection.find(status: :draft)
  @availables = settings.article_collection.find(status: :available)
  slim :index
end

get '/articles/:reference' do
  @article = settings.article_collection.find(reference: params[:reference]).first
  slim :show
end

get '/articles/:reference/make-available' do
  reference = params[:reference]
  article = settings.article_collection.find(reference: reference).first

  article[:status] = :available
  settings.topic.publish(ArticleWasMadeAvailable.to_json(article))
  settings.article_collection.update_one({reference: reference}, article )

  redirect '/articles'
end

post '/' do
  article = {
      reference: SecureRandom.uuid,
      title: params[:title],
      content: params[:content],
      status: :draft
  }
  settings.article_collection.insert_one(article)

  redirect '/'
end

class ArticleWasMadeAvailable < Hash
  def self.to_json(article)
    self.to_hash(article).to_json
  end

  def self.to_hash(article)
    {
        id: SecureRandom.uuid,
        timestamp: DateTime.now,
        type: 'ArticleWasMadeAvailable',
        payload:
        {
            reference: article[:reference],
            title: article[:title],
            content: article[:content]
        }
    }
  end
end