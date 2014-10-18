
##
# Wraper around youtube-dl application.
# Example call:
# youtube-dl -o '%(title)s.%(ext)s' -x --audio-format mp3 https://www.youtube.com/watch?v=zzG4K2m_j5U
#
module MediaConverter
  class YoutubeDl
    class YoutubeDlWrongFormat < StandardError; end

    FORMATS = %w(mp3 m4a opus best aac vorbis wav).freeze

    class << self
      def root_path
        'public/downloads/'
      end

      def file_path(name)
        @file_path = root_path << name
      end

      def output_file_option(name)
        "-o '#{file_path(name)}.%(ext)s'"
      end

      def format_option(format)
        raise YoutubeDlWrongFormat, "#{format} not supported" unless FORMATS.include?(format.to_s)
        "--extract-audio --audio-format '#{format}'"
      end

      def download(url, name, format = 'mp3')
        return if File.exists?("#{file_path(name)}.mp3")

        system("youtube-dl #{format_option(format)} #{output_file_option(name)} '#{url}'")
      end
    end
  end
end
