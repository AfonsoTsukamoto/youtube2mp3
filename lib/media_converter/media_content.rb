module MediaConverter
  class MediaContent < ActiveRecord::Base
    after_create :launch_downloader

    def file_name
      "#{id}_#{youtube_id}"
    end

    def file_path
      return 'rick_roll' unless processed
      YoutubeDl.file_path(file_name)
    end

    def download_path
      "downloads/#{file_name}.mp3"
    end

    def youtube_url
      "https://www.youtube.com/watch?v=#{youtube_id}"
    end

    def processed!
      update_attributes(processed: true)
    end

    private

    def launch_downloader
      YoutubeDownloader.perform_async(self.id)
    end
  end
end