require 'rubygems'
require 'sinatra'
require 'pp'
require 'json'
require 'mongo'
require 'active_support/all'
require 'sinatra/base'
require 'json-schema'
require 'rack/accept'
require './lang.rb'
require 'net/http'

class Server < Sinatra::Base

  use Rack::Accept

  helpers do
    def protected!
      unless authorized?
        response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
        throw(:halt, [401, "Not authorized\n"])
      end
    end
    
    def authorized?
      credentials = File.read('top_secret').split('=')
      @auth ||=  Rack::Auth::Basic::Request.new(request.env)
      @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == credentials
    end
  end

  # Get index.htm
  get %r{/(auto)?$} do |auto|
    @fingerprint = {}
    cookie_value = request.cookies['fingerprint']
    cookie_value ||= random_uid
    @fingerprint['uid'] = cookie_value
    @fingerprint['ip'] = request.ip

    @fingerprint['useragent'] = {}
    begin
      agentString = URI.escape(request.user_agent)
      uri = '/?uas=' + agentString + '&getJSON=all'
      res = Net::HTTP.get_response('www.useragentstring.com',uri)
      res.value
      @fingerprint['useragent'] = JSON.parse(res.body)
    rescue
    ensure
      @fingerprint['useragent']['description'] = request.user_agent
    end
    accept = env['rack-accept.request']

    @fingerprint['accept'] = {}

    @fingerprint['accept']['language'] = []
    for language in accept.language.values
      @fingerprint['accept']['language'].push({'name' => language,'qvalue' => accept.language.qvalue(language)})
    end 

    @fingerprint['accept']['charset'] = []
    for charset in accept.charset.values
      @fingerprint['accept']['charset'].push({'name' => charset,'qvalue' => accept.charset.qvalue(charset)})
    end 

    @fingerprint['accept']['encoding'] = []
    for enc in accept.encoding.values
      @fingerprint['accept']['encoding'].push({'name' => enc,'qvalue' => accept.encoding.qvalue(enc)})
    end 

    @fingerprint['accept']['media_type'] = []
    for typ in accept.media_type.values
      @fingerprint['accept']['media_type'].push({'name' => typ,'qvalue' => accept.media_type.qvalue(typ)})
    end 

    if auto
      erb :auto
    else
      erb :index
    end
  end

  get '/fp' do
    response.finish
  end
  
  # Post fingerprint
  post '/post' do 
    
    # TODO: 
    # - post more info to client, e.g. how many fingerprints etc. ?
    # - need to have cookie?
    
    # Read and parse post data
    fingerprint = JSON.parse request.body.read

#    if JSON::Validator.validate!('schema.json',fingerprint.to_json)
    
    # Set new cookie w/ uid
    response.set_cookie('fingerprint',{ :value => fingerprint['uid'],:expires => 3.months.from_now})
    
    # Insert fingerprint to DB
    db = Mongo::Connection.new.db('fingerprints')
    collection = db.collection('fingerprints')
    collection.insert(fingerprint)
    
    response.finish
#    end
    
  end

  # Get dataset
  get %r{/dataset(\.json)?} do |json|

    protected!

    db = Mongo::Connection.new.db('fingerprints')
    collection = db.collection('fingerprints')
    
    if json      
      fields = { '_id' => 0 }

      params.each_pair { |k,v| fields[k] = v.to_i if k != 'captures' }

      if fields.count > 1
        response.body = collection.find({}, { :fields => fields, :sort => 'timestamp'}).to_json
      else
        response.body = ([{}] * collection.count()).to_json
      end
          
      response.finish
    else
      @sample = collection.find_one({},{ :fields => {'_id' => 0 }, :sort => ['timestamp',:descending], :limit => 1} )
      erb :dataset
    end

  end

  get '/info' do
    accept = env['rack-accept.request']
    lang_pref = accept.best_language(accept.language.values)
    if lang_pref.include? 'sv'
      response.body = File.read(File.join('public', 'info_sv'))
    else
      response.body = File.read(File.join('public', 'info_en'))
    end
    response.finish
  end

  get '/time' do
    cache_control :no_cache
    response.body = [(Time.now.to_f*1000).round.to_s]
    response.finish
  end

  get '/count' do
    cache_control :no_cache
    db = Mongo::Connection.new.db('fingerprints')
    collection = db.collection('fingerprints')
    response.body = [collection.count().to_s]
    response.finish
  end

  # Generate random UID /[a-z0-9]{12}/
  def random_uid()
    return (1..12).reduce('') { |uid,_| uid + (rand 36).to_s(36) }
  end
  
end
