require 'test_helper'

module TextbundleTo
  class TestTextbundleExtendBearTags < MiniTest::Test
    def setup
      @extend = TextbundleExtend.new(textbundle_path: 'test/fixtures/text_with_image_bear_tags.textbundle')
    end

    def test_attrs
      assert_equal 'This is test post with tags 이것은 테스트 글입니다', @extend.title
      assert_equal ['test','invalid','test1'], @extend.tags
      exp_body = <<~BODY
      This is textbundle test. 

      Below is image 

      ![](assets/0B67DFC5-F0B2-404E-BD74-2ADF8BBBAC63.png)

      Thanks

      감사합니다.(korean)
      BODY
      assert_equal exp_body, @extend.body
    end
  end
end
