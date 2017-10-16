require 'sinatra'
require 'mongo'
require 'json/ext' # required for .to_json

configure do
  client = Mongo::Client.new([ 'mongo:27017' ], :database => 'dispatcher')
  set :article_collection,   client[:articles]
  set :message_collection,   client[:messages]
end


set :bind, '0.0.0.0'

require 'slim'

get '/messages/?' do
  content_type :json
  settings.message_collection.find.map(&:to_s)
end

get '/new_doc' do
  # collection = settings.client[:messages]
  doc = { name: 'Steve', hobbies: [ 'hiking', 'tennis', 'fly fishing' ] }
  settings.article_collection.insert_one(doc)
  redirect "/messages"
end

# helpers do
#   # a helper method to turn a string ID
#   # representation into a BSON::ObjectId
#   def object_id val
#     begin
#       BSON::ObjectId.from_string(val)
#     rescue BSON::ObjectId::Invalid
#       nil
#     end
#   end
#
#   def document_by_id id
#     id = object_id(id) if String === id
#     if id.nil?
#       {}.to_json
#     else
#       document = settings.mongo_db.find(:_id => id).to_a.first
#       (document || {}).to_json
#     end
#   end
# end
