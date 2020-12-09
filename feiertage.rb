require 'net/http'
require 'json'


(2021..2030).each do |year|
  url = "https://feiertage-api.de/api/?jahr=#{year}&nur_land=BE"
  response = Net::HTTP.get(URI(url))
  json = JSON.parse(response)
  puts year
  json.each do |k, v|
    puts "\t#{k}\t#{v['datum']}"
  end
end