require 'spec_helper'

describe SiteClassifier::Configuration do
  describe "#initialize" do
    it "should access an option hash" do
      conf = SiteClassifier::Configuration.new({translate: true, google_translate_api_key: "xxx"})
      conf.translate.should be_true
      conf.google_translate_api_key.should eq("xxx")
    end
  end

  describe "#configure" do
    it "should return a valid instance with a configuration block" do
      conf = SiteClassifier::Configuration.configure do |conf|
        conf.translate = true
        conf.google_translate_api_key = "yyy"
      end

      conf.translate.should be_true
      conf.google_translate_api_key.should eq("yyy")
    end
  end
end