$DOMAIN_1 = F

# $ ruby domain1.rb <category> <album-number>
require 'fileutils'
require 'nokogiri'
require 'open-uri'
#require "resolv-replace.rb"

category = ARGV[0].to_s
album_num = ARGV[1].to_i
page = (album_num / 53) + 1
counter = 1
album_count = 0
fixed_album_num = album_num.divmod(52)[1] - 1

BASE_URL = "http://#{$DOMAIN_1}.com"
URL = "#{BASE_URL}/page/#{page}/#{category}/"

file = Nokogiri::HTML(open(URL))
fff = file.css(".pic_pad a").to_a
sd = file.css(".gallery_data").to_a
ting = []
sd.each_with_index do |d, i|
  if (i % 2 == 0)
    str = d.to_s.split("pics")[0]
    ting << str[-3..-2].delete(">").to_i
  end
end

count = ting[fixed_album_num]
anchor = fff[fixed_album_num]
fffe = anchor.to_s.split("\"")[1]
fasd = fffe.split("/")
ttot = "http://i5.#{$DOMAIN_1}.com/large/#{fasd[2]}/#{fasd[3]}"[0..-6]
totalu = BASE_URL + fffe
count.times do |i|
  if ttot =~ /index/
    finalurl = ttot[0..-6] + "image-#{i+1}.jpg"
  else
    finalurl = ttot + "-#{i+1}.jpg"
  end
  FileUtils.mkdir_p "#{category}/#{album_num}"
  File.open("#{category}/#{album_num}/#{counter}.jpg",'wb'){ |f| f.write(open(finalurl).read) }
  counter = counter + 1
end
