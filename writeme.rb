require "erb"
require "httparty"
require "nokogiri"

hdoc_response = HTTParty.get("https://100daysofcode.narze.vercel.app")
page = Nokogiri::HTML(hdoc_response.body)
title = page.xpath('//h2[contains(text(), "Latest : Day")]').text
day = title.delete("^0-9")

til_response = HTTParty.get("https://raw.githubusercontent.com/narze/til/master/README.md")
til_entries = til_response.body.split("\n")[2].delete("^0-9")

digital_garden_posts = HTTParty.get("https://monosor.com/api/info.json")
digital_garden_posts_count = JSON.parse(digital_garden_posts.body)["count"]

@active_projects = [
  {
    name: "Digital Garden",
    link: "https://monosor.com",
    duration: "#{digital_garden_posts_count} Posts",
  },
  {
    name: "Today I Learned",
    link: "https://github.com/narze/til",
    duration: "#{til_entries} Entries",
  },
  {
    name: "#100DaysOfCode",
    link: "https://github.com/narze/100daysofcode",
    duration: "#{day} Days! 🎉",
  },
]

template = File.read("writeme.md.erb")

content = ERB.new(template, nil, "<>").result

File.write("README.md", content)
