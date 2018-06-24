require 'trundle'
require 'digest'
require 'active_support'
require 'active_support/core_ext/string/inflections'

module TextbundleTo
  class TextbundleExtend
    attr_accessor :title
    attr_accessor :tags
    attr_accessor :body
    attr_accessor :assets
    
    BEAR_CREATOR_IDENTIFIER = 'net.shinyfrog.bear'

    def initialize(textbundle_path:)
      @textbundle = Trundle.open(textbundle_path)
      @assets = @textbundle.assets.send(:assets).map { |a| OpenStruct.new(path: "assets/#{a[0]}", pathname: a[1], url: nil) }
      set_datas
    end
    
    def replace_assets_url
      @assets.each do |asset|
        @body.gsub!("(#{asset.path})", "(#{asset.url})")
      end
    end
    
    def permlink
      slug = @title.parameterize
      slug.empty? ? Digest::SHA256.hexdigest(Time.now.to_i.to_s)[0..6] : slug
    end

    private

    def set_datas
      lines = @textbundle.text.lines
      @title = lines.first[2..-1].rstrip
      if @textbundle.creator_identifier == BEAR_CREATOR_IDENTIFIER && tag_line?(lines[1])
        @tags = lines[1].scan(/(?:\s|^)(?:#)([^\s]+)(?=\s|$)/i).map { |e| e[0] }
        @body = lines[2..-1].join
      else
        @body = lines[1..-1].join
      end
    end
    
    def tag_line?(line)
      line.start_with? '#'
    end
  end
end
