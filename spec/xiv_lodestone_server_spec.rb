require 'spec_helper'
require 'xiv_lodestone/lodestone_helper'
require 'xiv_lodestone/lodestone_server'

describe XIVLodestone::ServerStatus do
  let (:server) { XIVLodestone::ServerStatus.new }

  it 'Pull server status' do
    expect(server.nil?).not_to be
    expect(server.elemental.tonberry.nil?).not_to be
  end

  it 'method missing check' do
    expect(server.method_missing(:elemental).is_a?(XIVLodestone::ServerStatus::ServerList)).to eql(true)
  end

  it 'updating server information' do
    server.fetch_server_status(Nokogiri::HTML(open(SERVER_FILE)))
    expect(server.elemental.tonberry.status).to eq("Offline")
    expect(server.elemental.tonberry.registration).to eq("Closed")
  end

  it 'build a server' do
    s = XIVLodestone::ServerStatus::ServerList::Server.new("Hello", "World", "Yay")
    expect(s.name).to eq("Hello")
    expect(s.status).to eq("World")
    expect(s.registration).to eq("Yay")
  end

  it 'Dump json' do
    expect(server.to_json.is_a?(String)).to eq(true)
  end
end