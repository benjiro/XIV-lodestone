require 'spec_helper'
require 'xiv_lodestone/lodestone_server'

describe XIVLodestone::ServerStatus do
  let (:server) { XIVLodestone::ServerStatus.new }

  it 'Pull server status' do
    expect(server.nil?).not_to be
    expect(server.tonberry.nil?).not_to be
    server.fetch_server_status(Nokogiri::HTML(open(SERVER_FILE)))
    expect(server.tonberry).to eq("Offline")
  end
end