require "textbundle_to/version"
require "textbundle_to/configuration"
require "textbundle_to/steemit/publish"
require "textbundle_to/steemit/image_upload"

module TextbundleTo
  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
