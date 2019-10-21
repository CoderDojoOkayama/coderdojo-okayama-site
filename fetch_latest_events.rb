require 'yaml'
require 'rest-client'
require 'json'

def fetch_events()
  data = []

  dojos.each do |dojo|
    if dojo['event_api'] then
      api = dojo['event_api']['api']
      id = dojo['event_api']['id']

      json = get_events(api, id)
      format(api, json, dojo).each {|d| data.push d }
    end
  end

  unless data.empty?
    output(data)
  end 
end

def get_events(api, id)
  case api
    when 'doorkeeper' then
      begin
        response = rest_client(api, id).get params: { :locale => 'ja', :sort => 'starts_at' }

        json = JSON.parse response.body
      rescue RestClient::ExceptionWithResponse => e
        nil
      end
    when 'connpass' then
      begin
        response = rest_client(api, id).get params: {:series_id => 3786, :order => 2}

        json = JSON.parse response.body
      rescue RestClient::ExceptionWithResponse => e
        nil
      end
  end
end

def rest_client(api, id)
  case api
    when 'doorkeeper' then
      RestClient::Resource.new "https://api.doorkeeper.jp/groups/#{id}/events"
    when 'connpass' then
      RestClient::Resource.new 'https://connpass.com/api/v1/event/'
  end
end

def format(api, data, dojo)
  fdata = []
  case api
    when 'doorkeeper' then
      data.each do |e|
        edata = {
          "dojo" => {
            "id" => dojo['id'],
            "name" => dojo['name'],
            "url" => dojo['url'],
          },
          "title" => e['event']['title'],
          "starts_at" => e['event']['starts_at'],
          "ends_at" => e['event']['ends_at'],
          "venue_name" => e['event']['venue_name'],
          "address" => e['event']['address'],
          "url" => e['event']['public_url'],
          "limit" => e['event']['ticket_limit'],
          "entry" => e['event']['participants'] + e['event']['waitlisted']
        }

        fdata.push edata
      end
    when 'connpass' then
      data['events'].each do |e|
        if Date.parse(e['started_at']) > Date.today then
          edata = {
            "dojo" => {
              "id" => dojo['id'],
              "name" => dojo['name'],
              "url" => dojo['url'],            
            },
            "title" => e['title'],
            "starts_at" => e['started_at'],
            "ends_at" => e['ended_at'],
            "venue_name" => e['place'],
            "address" => e['address'],
            "url" => e['event_url'],
            "limit" => e['limit'],
            "entry" => e['accepted'] + e['waiting']
          }

          fdata.push edata
        end
      end
  end

  fdata
end

def output(data)
  YAML.dump(data, File.open(File.expand_path('./_data/events.yml'), 'w'))
end

def dojos
  file = File.expand_path('./_data/dojos.yml')
  dojos = open(file, 'r') { |f| YAML.load(f) }
  dojos
end

fetch_events()