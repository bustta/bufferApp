require 'rubygems'
require 'httparty'

class BufferApp
    include HTTParty
    base_uri 'https://api.bufferapp.com/1'

    def initialize(token, id)
        @token = token
        @id = id
    end


    def create(text)
        BufferApp.post('/updates/create.json', :body => {"text" => text, "profile_ids[]" => @id, "access_token" => @token})
    end

    def getProfile
      BufferApp.get('/profiles.json', :query => {"access_token" => @token})


    end
end

profile_id = "52b3069411243a4d5a0000ba"
token = "1/ca8f892f4f20142ffd0ac7400ab79366"
# puts BufferApp.new(token).getProfile
puts BufferApp.new(token, profile_id ).create("666")
