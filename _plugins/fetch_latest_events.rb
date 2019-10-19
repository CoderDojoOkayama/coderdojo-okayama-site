require 'yaml'
require 'rest-client'

module Original
  public
  def self.fetch_events(api, id, dojo_id)
    json = get_events(api, id)
    format(api, json, dojo_id)
  end

  private
  def self.get_events(api, id)
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

  def self.rest_client(api, id)
    case api
      when 'doorkeeper' then
        RestClient::Resource.new "https://api.doorkeeper.jp/groups/#{id}/events"
      when 'connpass' then
        RestClient::Resource.new 'https://connpass.com/api/v1/event/'
    end
  end

  def self.format(api, data, dojo_id)
    fdata = []
    case api
      when 'doorkeeper' then
        data.each do |e|
          edata = {
            "dojo_id" => dojo_id,
            "title" => e['event']['title'],
            "starts_at" => e['event']['starts_at'],
            "ends_at" => e['event']['ends_at'],
            "venue_name" => e['event']['venue_name'],
            "address" => e['event']['address'],
            "url" => e['event']['public_url']
          }
          fdata.push edata
        end
      when 'connpass' then
        data['events'].each do |e|
          edata = {
            "dojo_id" => dojo_id,
            "title" => e['title'],
            "starts_at" => e['started_at'],
            "ends_at" => e['ended_at'],
            "venue_name" => e['place'],
            "address" => e['address'],
            "url" => e['event_url']
          }
          fdata.push edata
        end

    end

    fdata
  end
end

Jekyll::Hooks.register :site, :post_read do |site, payload|
  file = File.expand_path('./_data/dojos.yml')
  dojos = open(file, 'r') { |f| YAML.load(f) }
  data = []
  dojos.each do |dojo|
    if dojo['event_api'] then
      ddata = Original.fetch_events(dojo['event_api']['api'], dojo['event_api']['id'], dojo['id'])
      ddata.each {|d| data.push d }
    end
  end
  YAML.dump(data, File.open(File.expand_path('./_data/events.yml'), 'w'))
end