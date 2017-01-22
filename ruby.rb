require 'sinatra'
require "sinatra/json"
require 'json'
require "net/http"
require "uri"
require './message_created'
require './message_annotation_added'
require './respond_bot'

annotations_file = "annotations.txt"


require 'uri'
require 'pp'
require "yaml"

secrets = YAML.load_file('secret.yaml')

APP_ID = secrets['APP_ID']
APP_SECRET = secrets['APP_SECRET']
webhook = secrets['webhook']

pp secrets.inspect

uri = URI.parse("https://api.watsonwork.ibm.com/oauth/token")
reqq = Net::HTTP::Post.new(uri)
reqq.basic_auth(APP_ID, APP_SECRET)
reqq.set_form_data(
  "grant_type" => "client_credentials",
)

req_options = {
  use_ssl: uri.scheme == "https",
}

response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
  http.request(reqq)
end
pp JSON.parse(response.body)["access_token"]
access_token = JSON.parse(response.body)["access_token"]

require 'openssl'
require 'httparty'

key = webhook
digest = OpenSSL::Digest.new('sha256')

spaceId = "58838c97e4b007614d439dcf"
host = "https://api.watsonwork.ibm.com/v1/spaces/#{spaceId}/messages"
require_relative 'message'
require_relative 'annotation'

body = Message.new
body.text = RespondBot.flirt
res = HTTParty.post( host, :headers => { "Authorization" => "Bearer #{access_token}", 'Content-Type' => 'application/json'}, :body => body.to_json)

messages = []

post '/webhook' do
  if JSON.parse(request.body.string)['type'] == "verification"
    headers['X-OUTBOUND-TOKEN'] = "#{OpenSSL::HMAC.hexdigest('sha256', key, json(response: JSON.parse(request.body.string)['challenge']))}"
    json(response: JSON.parse(request.body.string)['challenge'])
  else
    body_json = JSON.parse(request.body.string)

    if body_json["type"].eql?"message-created"
        messages << MessageCreated.new(body_json)
      end
    if body_json["type"].eql?"message-annotation-added"
      annotation = MessageAnnotationAdded.new(body_json)
      if annotation.annotation_type.eql?("message-nlp-docSentiment")
        type = annotation.annotation_payload.doc_sentiment.type
        message = messages.find {|mes| annotation.message_id.eql?(mes.message_id) }
        if(message.user_name && !message.user_name.eql?("BOTNAME"))
          puts type
          puts message.user_name
          message_to_send = Message.new
          message_to_send.text = RespondBot.concerned(message.user_name) if type.eql? :negative
          message_to_send.text = RespondBot.respond(message.user_name) if !type.eql? :negative
          HTTParty.post( host, :headers => { "Authorization" => "Bearer #{access_token}", 'Content-Type' => 'application/json'}, :body => message_to_send.to_json)
        end
      end
    end

    # pp request.env
    # pp request.body.string
    f = File.open(annotations_file,'a')
    f.puts(request.body.string+"\n\n\n")
    f.close()
  end
end
