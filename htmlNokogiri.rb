require 'nokogiri'
require 'open-uri'

url = "http://www.soulmates.ws/mates/address_detail/611/"
doc = Nokogiri::HTML(open(url), nil, "UTF-8")
imageUrl = doc.xpath("//meta[@property='og:image']")[0]['content']
p imageUrl