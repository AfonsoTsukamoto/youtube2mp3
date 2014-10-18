require 'json'
require 'rack'
require 'sinatra/json'
require 'sinatra/base'
require 'sinatra/reloader'

require 'active_support'
require 'active_support/core_ext/array'
#require 'pry'
require 'redis'
require 'sidekiq'

module MediaConverter
  class Router < Sinatra::Base
    register Sinatra::Reloader
    register Sinatra::JSON

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
      media = MediaContent.new(youtube_id: params[:youtube_id])
      media.launch_downloader

      json id: params[:youtube_id]
    end

    get '/video/:youtube_id/audio' do
      media = MediaContent.new(youtube_id: params[:youtube_id])

      if File.exists?(media.file_path)
        json url: "#{base_url}/#{media.download_path}"
      else
        json error: 'nononono'
      end
    end
  end
end
