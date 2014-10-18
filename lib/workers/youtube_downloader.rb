class YoutubeDownloader
  include MediaConverter
  include Sidekiq::Worker
  sidekiq_options queue: :downloads

  def perform(id)
    media = MediaContent.find_by(id: id)
    puts media.attributes
    YoutubeDl.download(media.youtube_url, media.file_name)
    media.processed!
  end
end