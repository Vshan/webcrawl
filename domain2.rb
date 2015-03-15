$DOMAIN_2 = I

# $ ruby domain2.rb <category> <album-number> <per-page (optional)>
require 'fileutils'
require 'open-uri'
require 'rubygems'
require 'mechanize'
require "resolv-replace.rb"

unless (ARGV[2])
  PER_PAGE = 25
else
  PER_PAGE = ARGV[2].to_i
end

category = ARGV[0]
album_num = ARGV[1].to_i
page = (album_num / PER_PAGE)
fixed_album_num = album_num.divmod(PER_PAGE)[1]
if fixed_album_num == 0
  fixed_album_num = PER_PAGE
  page -= 1
end

URL = "http://www.#{$DOMAIN_2}.com/gallery.php?type=1&userid=&gen=0&search=#{category}&page=#{page}&perpage=#{PER_PAGE}"

website = Mechanize.new
website.get(URL)

count = 0
website.page.links.each do |link|
  if link.href =~ /gallery.php\?/
    count += 1
    if (count == 6 + fixed_album_num)
      link.click
      website.page.links.find {|l| l.text == "One page"}.click
      break
    end
  end
end

count = 0
images = website.page.search("td a img")
time_rn = Time.now
dir = "#{category}/#{time_rn.day}-#{time_rn.month}-#{time_rn.year}/#{album_num}"
FileUtils.mkdir_p dir
images[3..-2].each do |i|
  count += 1
  imurl = "http://" + i.attributes["src"].to_s.partition('.')[2].gsub(/thumb/, "full")
  website.get(imurl).save(dir + "/#{count}.#{imurl[-3..-1]}")
  #File.open(dir + "/#{count}.#{imurl[-3..-1]}",'wb'){ |f| f.write(open(imurl).read) }
end
