require 'spec_helper'

describe SiteClassifier do

  describe '#configure' do
    it "should have a 'configure' method" do
      SiteClassifier.should respond_to(:configure)
    end

    it "should accept block configuration" do
      SiteClassifier.configure do |sc|
        sc.translate = true
        sc.google_translate_api_key = "xxx"
      end

      SiteClassifier.configuration.translate.should be_true
      SiteClassifier.configuration.google_translate_api_key.should eq("xxx")
    end
  end

  describe '#configuration' do
    it "should have a 'configuration' method" do
      SiteClassifier.should respond_to(:configuration)
    end
  end

  describe "#translate_tags?" do
    before(:all) do
      SiteClassifier.configure do |sc|
        sc.translate = true
        sc.google_translate_api_key = "xxx"
      end
    end

    it "should have a 'translate_tags?' method" do
      SiteClassifier.should respond_to(:translate_tags?)
    end

    it "should return true if translate is set to true in configuration" do
      SiteClassifier.translate_tags?.should be_true
    end
  end
end