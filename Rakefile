require "bundler/gem_tasks"

namespace :steemit do
  task :publish, [:textbundle, :wif, :user_name] do |_, args|
    require 'textbundle_to'

    config = TextbundleTo::Configuration.new do |config|
      config.steemit_wif_private_key = args.wif
      config.steemit_user_name = args.user_name
    end
    steemit = TextbundleTo::Steemit::Publish.new(config: config)
    result = steemit.publish(textbundle: args.textbundle, tags: args.extras)
    puts result[:message]
  end
end
