require 'faraday'
require 'json'
require 'mimemagic'

module TextbundleTo
  module Steemit
    class ImageUpload
      IMAGE_SERVER = 'https://steemitimages.com'

      def initialize(config:)
        @config = config
        @conn = Faraday.new(url: IMAGE_SERVER) do |faraday|
          faraday.request :multipart
          faraday.adapter Faraday.default_adapter
        end
      end

      def upload(image_path:)
        sign = signature(image_path: image_path)
        mime = MimeMagic.by_magic(File.open(image_path))
        resp = @conn.post do |req|
          req.url "/#{@config.steemit_user_name}/#{sign}"
          req.body = {file: Faraday::UploadIO.new(image_path, mime)}
        end
        json = JSON.parse resp.body
        json['url']
      end

      def signature(image_path:)
        `node js/signature.js #{@config.steemit_wif_private_key} #{image_path}`
      end
    end
  end
end
