require 'sinatra'
require 'json'
require 'jsonapi-serializers'

class Character
  def initialize(id:, first_name:, last_name:)
    @id, @first_name, @last_name = id, first_name, last_name
  end

  attr_reader :id, :first_name, :last_name
end

class CharacterSerializer
  include JSONAPI::Serializer

  attribute :first_name
  attribute :last_name
end

class ExampleServer < Sinatra::Base
  options "*" do
    response.headers["Allow"] = "HEAD,GET,PUT,DELETE,OPTIONS"
    response.headers["Access-Control-Allow-Headers"] = "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept"
    response.headers["Access-Control-Allow-Origin"] = "null"
    200
  end

  before do
    content_type 'application/vnd.api+json'
    headers['Access-Control-Allow-Origin'] = 'null'
  end

  get '/luke' do
    character = Character.new(id: 'luke', first_name: 'Luke', last_name: 'Skywalker')
    JSONAPI::Serializer.serialize(character).to_json
  end
end
