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

asq_res = HTTParty.get("https://raw.githubusercontent.com/narze/awesome-salim-quotes/main/README.md")
asq_entries = asq_res.body.strip.split("\n").select { |l| l.start_with?("- ") }.size

@active_projects = [
  { name: "ติด vs ตรวจ", link: "https://tid-vs-truad.vercel.app" },
  { name: "Coffee to Code", link: "https://github.com/narze/coffee-to-code" },
  { name: "Resumette - Printer-friendly standard résumé", link: "https://github.com/narze/resume" }, 
  { name: "Manoonchai Thai Keyboard Layout", link: "https://github.com/manoonchai/manoonchai" },
  { name: "Thailand Grand Opening", link: "https://thailand-grand-opening.web.app" },
  { name: "Awesome Salim Quotes", link: "https://narze.github.io/awesome-salim-quotes", duration: "#{asq_entries} Quotes" },
  {
    name: "Digital Garden",
    link: "https://monosor.com",
    duration: "#{digital_garden_posts_count} Posts",
  },
]

@past_projects = [
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

torpleng_res = HTTParty.get("https://raw.githubusercontent.com/narze/torpleng/main/README.md")
torpleng_entries = torpleng_res.body.split("# Entries").last.strip.split("\n").select { |l| l.start_with?("- ") }.size

@special_projects = {
  torpleng: "(#{torpleng_entries} เพลง)",
  awesome_salim_quotes: "(#{asq_entries} Quotes)",
}

template = File.read("writeme.md.erb")

content = ERB.new(template, nil, "<>").result

File.write("README.md", content)

puts "README updated."
