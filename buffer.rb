require 'rubygems'
require 'httparty'
require 'nokogiri'
require 'open-uri'
require "google_drive"

facebook_id = ''
twitter_id = ''
google_id = ''
token = ''
indexID = ''
indexPW = ''
sheetKey = ''

File.open('indexToken.txt', 'r') do |file|
  file.each_line do |line|
    line_data = line.split(',')
    indexID = line_data[0]
    indexPW = line_data[1]
    sheetKey = line_data[2]
    facebook_id = line_data[3]
    twitter_id = line_data[4]
    google_id = line_data[5]
    token = line_data[6]
  end
end



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

    def create4Img(title, image, url)
        desc = title + " " + url
        BufferApp.post('/updates/create.json',
            :body => {
                "text" => desc,
                "profile_ids[]" => @id,
                "access_token" => @token,
                "media[photo]" => image,
                # "media[description]" => desc,
                # "media[title]" => desc
                })
    end

    def getProfile
      BufferApp.get('/profiles.json', :query => {"access_token" => @token})
    end
end

def getTitle(url)
    title = ''
    begin
    doc = Nokogiri::HTML(open(url), nil, "UTF-8")
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
def getCoverImage(url)
    doc = Nokogiri::HTML(open(url), nil, "UTF-8")
    imageUrl = doc.xpath("//meta[@property='og:image']")[0]['content']
end




@urlHead = "http://www.soulmates.ws/mates/address_detail/"



session = GoogleDrive.login(indexID, indexPW)
begin
    ws = session.spreadsheet_by_key(sheetKey).worksheets[0]
    index =  ws[1,1].to_i
rescue
    index = rand(1000)
end


count = 0
mode = ARGV[0].to_i;
while count < 10

    urlFull = @urlHead + index.to_s + "/"

    title = getTitle(urlFull)

    while title == 404
        index = index.to_i + 1
        urlFull = @urlHead + index.to_s + "/"
        title = getTitle(urlFull)
    end

        image = getCoverImage(urlFull)

        if mode == 1
            BufferApp.new(token, facebook_id).create4Img(title, image, urlFull)
            BufferApp.new(token, google_id).create4Img(title, image, urlFull)
            BufferApp.new(token, twitter_id).create4Img(title, image, urlFull)
        else
            BufferApp.new(token, facebook_id).create(title, urlFull)
            BufferApp.new(token, google_id).create(title, urlFull)
            BufferApp.new(token, twitter_id).create4Twitter(title, urlFull)
        end


    index = index.to_i + 1
    count += 1
end

ws[1,1] = index
ws.save()
ws.reload()
