require 'sinatra'
require 'mongo'
require 'json/ext' # required for .to_json

configure do
  client = Mongo::Client.new([ 'mongo:27017' ], :database => 'test')
  set :client,   client
  set :database, client.database
end


set :bind, '0.0.0.0'

require 'slim'

get '/collections/?' do
  content_type :json
  settings.database.collection_names.to_json
end

get '/new_doc' do
  collection = settings.client[:people]
  doc = { name: 'Steve', hobbies: [ 'hiking', 'tennis', 'fly fishing' ] }

  collection.insert_one(doc)
  redirect "/collections"
end

# get '/documents/?' do
#   content_type :json
#   settings.mongo_db.find.to_a.to_json
# end
#
# # find a document by its ID
# get '/document/:id/?' do
#   content_type :json
#   document_by_id(params[:id])
# end

helpers do
  # a helper method to turn a string ID
  # representation into a BSON::ObjectId
  def object_id val
    begin
      BSON::ObjectId.from_string(val)
    rescue BSON::ObjectId::Invalid
      nil
    end
  end

  def document_by_id id
    id = object_id(id) if String === id
    if id.nil?
      {}.to_json
    else
      document = settings.mongo_db.find(:_id => id).to_a.first
      (document || {}).to_json
    end
  end
end
# get '/' do
#   @articles = Article.all
#   slim :index
# end
#
# post '/' do
#   @article = Article.new(title: params[:title])
#   slim :index
# end


