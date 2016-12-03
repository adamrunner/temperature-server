Bundler.require
require 'elasticsearch'
require 'yaml'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/asset_pipeline'


class App < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  # Include these files when precompiling assets
  set :assets_precompile, %w(app.js app.css *.png *.jpg *.svg *.eot *.ttf *.woff *.woff2)

  # The path to your assets
  set :assets_paths, %w(assets)

  # Use another host for serving assets
  # set :assets_host, '<id>.cloudfront.net'
  #
  # # Which prefix to serve the assets under
  # set :assets_prefix, 'custom-prefix'

  # Serve assets using this protocol (http, :https, :relative)
  set :assets_protocol, :http

  # CSS minification
  set :assets_css_compressor, :sass

  # JavaScript minification
  set :assets_js_compressor, :uglifier
  set :assets_prefix, ['/assets']
  set :haml, format: :html5
  set :assets_debug, true
  set :digest_assets, false
  set :assets_expand, true
  # Make sure that you resgister the plugins after you configure them
  register Sinatra::Partial
  register Sinatra::AssetPipeline
  configure do
    sprockets.append_path File.dirname(HamlCoffeeAssets.helpers_path)
  end

  set :sockets, []

  def websocket_send(data)
    EM.next_tick { settings.sockets.each{|s| s.send(data.to_json) } }
  end

  get '/' do
    if request.websocket?
      request.websocket do |ws|
        ws.onopen do
          settings.sockets << ws
        end
        ws.onclose do
          settings.sockets.delete(ws)
        end
      end
    else
      haml :index
    end
  end

  get '/temp' do
    @client = Elasticsearch::Client.new log: true, host: 'https://es.adamrunner.com'
    # http://192.168.1.90/temp?sensor_id=1&temp=75.58
    # Date should be in "2015-01-01T12:10:30-0800" format
    sensor_id = params['sensor_id']
    temp      = params['temp']
    @client.index({
      index: 'temperature_data',
      type: 'temperature',
      body: {
        sensor_id: sensor_id.to_i,
        temperature: temp.to_f,
        timestamp: Time.now.strftime("%Y-%m-%dT%H:%M:%S%z")
      }
    })

    [200, {}, '']
  end

  post '/add' do
  end

  post '/delete' do
  end
end
