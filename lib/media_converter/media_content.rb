module MediaConverter
  class MediaContent
    def initialize(opts = {})
      @file_name = opts.delete(:youtube_id)
    end

    def file_path
      "public/downloads/#{@file_name}.mp3"
    end

    def download_path
      "downloads/#{@file_name}.mp3"
    end

    def youtube_url
      "https://www.youtube.com/watch?v=#{@file_name}"
    end

    def launch_downloader
      YoutubeDownloader.perform_async(self.to_json)
    end

    def to_json
      { youtube_url: youtube_url, file_name: @file_name }.to_json
    end
  end
end