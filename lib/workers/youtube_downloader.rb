class YoutubeDownloader
  include MediaConverter
  include Sidekiq::Worker

  sidekiq_options queue: :downloads, retry: false

  def perform(media)
    media = JSON.parse(media)

    YoutubeDl.download(media['youtube_url'], media['file_name'])
  end
end
