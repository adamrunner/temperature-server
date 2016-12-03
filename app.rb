Bundler.require
require 'yaml'
require 'sinatra'
require 'sinatra/asset_pipeline'

class App < Sinatra::Base
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
  set :assets_prefix, '/assets'
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

  post '/add' do
  end

  post '/delete' do
  end
end
