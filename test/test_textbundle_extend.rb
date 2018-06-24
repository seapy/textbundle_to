require 'test_helper'

module TextbundleTo
  class TestTextbundleExtend < MiniTest::Test
    def setup
      @extend = TextbundleExtend.new(textbundle_path: 'test/fixtures/text_with_image.textbundle')
    end

    def test_check_init
      refute_empty @extend.assets
      first = @extend.assets.first
      assert_equal 'assets/0B67DFC5-F0B2-404E-BD74-2ADF8BBBAC63.png', first.path
      assert_kind_of Pathname, first.pathname
      assert_respond_to first, :url
      assert_nil first.url
    end

    def test_attrs
      assert_equal 'This is test post 이것은 테스트 글입니다', @extend.title
      assert_equal 'this-is-test-post', @extend.permlink
      assert_nil @extend.tags
      exp_body = <<~BODY
      This is textbundle test. 

      Below is image 

      ![](assets/0B67DFC5-F0B2-404E-BD74-2ADF8BBBAC63.png)

      Thanks

      감사합니다.(korean)
      BODY
      assert_equal exp_body, @extend.body
    end

    def test_asset_uploaded_url
      uploaded_url = 'https://www.example.com/aaa.jpg'
      @extend.assets.each do |asset|
        asset.url = uploaded_url
      end
      assert_equal @extend.assets.first.url, uploaded_url
      
      exp_body = <<~BODY
      This is textbundle test. 

      Below is image 

      ![](https://www.example.com/aaa.jpg)

      Thanks

      감사합니다.(korean)
      BODY
      @extend.replace_assets_url
      assert_equal exp_body, @extend.body
    end
  end
end
