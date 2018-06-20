require 'trundle'
require 'radiator'
require 'digest'

module TextbundleTo
  module Steemit
    class Publish
      attr_accessor :config

      def initialize(config:)
        @config = config
      end

      def publish(textbundle:, tags:)
        Trundle.configure do |config|
          config.namespaces do
            textbundle_to 'com.textbundleto'
          end
        end
        bundle = Trundle.open(textbundle)
        bundle = upload_image(bundle: bundle)
        post_steemit(bundle: bundle, tags: tags)
      end

      private

      def upload_image(bundle:)
        uploader = ImageUpload.new(config: @config)
        assets = []
        bundle.assets.send(:assets).each do |asset|
          url = uploader.upload(image_path: asset.last.to_s)
          bundle.text.gsub!("(assets/#{asset.first})", "(#{url})")
          assets << url
        end
        bundle.textbundle_to.images = assets unless assets.empty?
        bundle
      end

      def post_steemit(bundle:, tags:)
        options = {
          wif: @config.steemit_wif_private_key
        }
        tx = ::Radiator::Transaction.new(options)
        metadata = {
          tags: tags,
          app: "textbundle_to/#{TextbundleTo::VERSION}",
          format: 'markdown'
        }
        metadata[:image] = bundle.textbundle_to.images unless bundle.textbundle_to.images.nil?
        lines = bundle.text.split("\n")
        title = lines.first[2..-1]
        body = lines[1..-1].join("\n")
        # https://developers.steem.io/apidefinitions/#apidefinitions-condenser-api
        tx.operations << {
          type: :comment,
          parent_author: '',
          parent_permlink: tags.first, # required
          author: @config.steemit_user_name,
          permlink: Digest::SHA256.hexdigest(Time.now.to_i.to_s)[0..6], # required
          title: title,
          body: body,
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
