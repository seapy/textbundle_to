module TextbundleTo
  class Configuration
    attr_accessor :steemit_wif_private_key
    attr_accessor :steemit_user_name

    def initialize
      yield self
    end
  end
end
