$DOMAIN_3 = M

# $ ruby domain3.rb <category> <lower-limit (Starting point: lower-limit/80)> <total images needed>

require 'nokogiri'
require 'open-uri'

category = ARGV[0].to_s
lower_limit = ARGV[1].to_i
total = ARGV[2].to_i
pages = (total / 80) + 1
page_init = lower_limit / 80

counter = 1
pages.times { |i|

URL = "http://#{$DOMAIN_3}.com/term/images/#{category}?range=0&size=0&sort=relevance&page=#{i + page_init + 1}"

file = Nokogiri::HTML(open(URL)).css(".content-inner a")

file.each do |anchor|
  if anchor.to_s =~ /$DOMAIN_3.com/
    fff = anchor.to_s.split("\"")[1]
    fil = Nokogiri::HTML(open(fff)).css("#media-media a")
    fil.each do |v|
      if (v.to_s =~ /$DOMAIN_3/ and counter <= total)
        fda = v.to_s.split("\"")[3]
	dff = Time.now
	dird = "#{category}/#{dff.day}-#{dff.month}-#{dff.year}"
	FileUtils.mkdir_p dird
	File.open((dird + "/#{counter}.#{fda[-3..-1]}"),'wb'){ |f| f.write(open(fda).read) }
	counter = counter + 1
      else
	abort()
      end
    end
  end
end

}
