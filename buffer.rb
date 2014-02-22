require 'rubygems'
require 'httparty'
require 'nokogiri'
require 'open-uri'

facebook_id = "52b3069411243a4d5a0000ba"
twitter_id = "52af2f34c43ab5213c000002"
google_id = "52af2f59c43ab5193c000001"

token = "1/ca8f892f4f20142ffd0ac7400ab79366"


class BufferApp
    include HTTParty
    base_uri 'https://api.bufferapp.com/1'

    def initialize(token, id)
        @token = token
        @id = id
    end

    def create(text, url)
        BufferApp.post('/updates/create.json',
            :body => {
                "text" => text,
                "profile_ids[]" => @id,
                "access_token" => @token,
                "media[link]" => url,
                # "media[description]" => text,
                "media[title]" => text
                })
    end

    def create4Twitter(text, url)
        content = text + " " + url
        BufferApp.post('/updates/create.json',
            :body => {
                "text" => content,
                "profile_ids[]" => @id,
                "access_token" => @token
                })
    end

    def getProfile
      BufferApp.get('/profiles.json', :query => {"access_token" => @token})
    end
end

def getTitle(url)
    title = ''
    begin
    doc = Nokogiri::HTML(open(url))
    title = doc.css('title').text
    rescue
        title = 404
    end

end


def getIndex
    fileName = "index"
    file = open(fileName, "r")
    index = 1
    while line = file.gets
        index = line
    end
    file.close
    return index
end
def setIndex(index)
    fileName = "index"
    open(fileName, "w") do |file|
        file.print index
    end
end


@urlHead = "http://www.soulmates.ws/mates/address_detail/"

# 10.times do
    # index = getIndex()
    # urlFull = @urlHead + index + "/"

    # title = getTitle(urlFull)
    # setIndex(index.to_i + 1)

    # while title == 404
    #     index = getIndex()
    #     urlFull = @urlHead + index + "/"
    #     title = getTitle(urlFull)
    #     setIndex(index.to_i + 1)
    # end

title = "測試"
urlFull = @urlHead + "999" + "/"
    puts title
    puts BufferApp.new(token, facebook_id).create(title, urlFull)
    # BufferApp.new(token, twitter_id).create4Twitter(title, urlFull)
    # BufferApp.new(token, google_id).create(title, urlFull)

# end
