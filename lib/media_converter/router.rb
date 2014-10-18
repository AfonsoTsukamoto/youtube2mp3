require 'json'
require 'rack'
require 'sinatra/json'
require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/activerecord'

require 'active_support'
require 'active_support/core_ext/array'
require 'pry'
require 'redis'
require 'sidekiq'

module MediaConverter
  class Router < Sinatra::Base
    register Sinatra::Reloader
    register Sinatra::ActiveRecordExtension
    register Sinatra::JSON

    set :database_file, '../../config/database.yml'
    set :public_folder, File.join(root, '..', '..', 'public/')

    configure do
      enable :logging
    end

    helpers do
      def base_url
        uri = URI.parse(request.url)
        "#{uri.scheme}://#{uri.host}"
      end
    end

    post '/video/:youtube_id/process' do
      media = MediaContent.create!(youtube_id: params[:youtube_id])
      json id: media.id
    end

    get '/video/:id/audio' do
      media = MediaContent.find_by(id: params[:id])

      if media &&  media.processed
        json url: "#{base_url}/#{media.download_path}"
      else
        json error: 'No no no no'
      end
    end
  end
end