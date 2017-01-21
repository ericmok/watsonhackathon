
require 'sinatra'
require "sinatra/json"
require 'json'
require "net/http"
require "uri"
APP_ID = ""
APP_SECRET = ""
webhoook = ""


require 'net/http'
require 'uri'
require 'pp'

uri = URI.parse("https://api.watsonwork.ibm.com/oauth/token")
reqq = Net::HTTP::Post.new(uri)
reqq.basic_auth("","")
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

key = webhoook
digest = OpenSSL::Digest.new('sha256')


post '/webhook' do
  if JSON.parse(request.body.string)['type'] == "verification"
    headers['X-OUTBOUND-TOKEN'] = "#{OpenSSL::HMAC.hexdigest('sha256', key, json(response: JSON.parse(request.body.string)['challenge']))}"
    json(response: JSON.parse(request.body.string)['challenge'])
  else
    pp request.env
    pp request.body.string
    spaceId = ""
    host = "https://api.watsonwork.ibm.com/v1/spaces/#{spaceId}/messages"


    body = {
      type: 'appMessage',
      version: 1.0,
      annotations: [{
        type: 'generic',
        version: 1.0,

        color: '#6CB7FB',
        title: 'Echo message',
        text: "NO!",

        actor: {
          name: 'from sample echo app',
          avatar: 'https://avatars1.githubusercontent.com/u/22985179',
          url: 'https://github.com/watsonwork/watsonwork-echo'
        }
      }]
    }
    res = HTTParty.post( host, :headers => { "Authorization" => "Bearer #{access_token}", 'Content-Type' => 'application/json'}, :body => body.to_json)

  end
end
