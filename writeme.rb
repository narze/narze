require "httparty"
require "nokogiri"

hdoc_response = HTTParty.get("https://100daysofcode.narze.vercel.app")

page = Nokogiri::HTML(hdoc_response.body)

title = page.xpath('//h2[contains(text(), "Latest : Day")]').text

day = title.delete("^0-9")

til_response = HTTParty.get("https://raw.githubusercontent.com/narze/til/master/README.md")

til_entries = til_response.body.split("\n")[2].delete("^0-9")

content = <<~EOF
  Active projects :

  - [#100DaysOfCode](https://github.com/narze/100daysofcode) : #{day} Days
  - [Today I Learned](https://github.com/narze/til) : #{til_entries} Entries
EOF

File.write("README.md", content)
