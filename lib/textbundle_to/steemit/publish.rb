require 'radiator'

module TextbundleTo
  module Steemit
    class Publish
      attr_accessor :config

      def initialize(config:)
        @config = config
      end

      def publish(textbundle_path:, tags: nil)
        bundle = TextbundleExtend.new(textbundle_path: textbundle_path)
        tags&.reject!(&:empty?)
        bundle.tags = tags if (tags&.count || 0) > 0
        post_steemit(bundle: bundle)
      end

      private

      def upload_image(bundle:)
        uploader = ImageUpload.new(config: @config)
        bundle.assets.each do |asset|
          asset.url = uploader.upload(image_path: asset.pathname.to_s)
        end
        bundle.replace_assets_url
      end

      def post_steemit(bundle:)
        upload_image(bundle: bundle)
        
        options = {
          wif: @config.steemit_wif_private_key
        }
        tx = ::Radiator::Transaction.new(options)
        metadata = {
          tags: bundle.tags,
          app: "textbundle_to/#{TextbundleTo::VERSION}",
          format: 'markdown'
        }
        metadata[:image] = bundle.assets.map { |e| e.url } if (bundle.assets&.count || 0) > 0
        # https://developers.steem.io/apidefinitions/#apidefinitions-condenser-api
        tx.operations << {
          type: :comment,
          parent_author: '',
          parent_permlink: bundle.tags.first, # required
          author: @config.steemit_user_name,
          permlink: bundle.permlink, # required
          title: bundle.title,
          body: bundle.body,
          json_metadata: metadata.to_json
        }
        response = tx.process(true)
        # response => "{\n  \"jsonrpc\": \"2.0\",\n  \"result\": {\n    \"id\": \"xxxxxxxxx\",\n    \"block_num\": 200000,\n    \"trx_num\": 8,\n    \"expired\": false\n  },\n  \"id\": 1\n}"
        success = response.error.nil?
        {
          success: success,
          message: success ? '🚀 Success publishing on steemit' : "⚠️  #{response.error.message}"
        }
      end
    end
  end
end
