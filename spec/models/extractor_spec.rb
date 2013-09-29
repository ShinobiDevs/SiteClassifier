require 'spec_helper'

describe SiteClassifier::Extractor do
  describe "#initialize" do
    it "should create a valid instance" do
      extractor = SiteClassifier::Extractor.new("http://cnn.com", ["news"], ["news", "economy"], "This is cnn", "auto")

      extractor.url.should eq("http://cnn.com")
    end
  end

  describe "#validate_lang" do
    before(:all) do
      @extractor = SiteClassifier::Extractor.new("http://cnn.com", ["news"], ["news", "economy"], "This is cnn", "auto")
    end

    it "should keep language if it is a known language to google translate" do
      @extractor.validate_lang
      @extractor.lang.should eq("auto")
    end

    it "should reset to 'auto' if language is not a known language to google translate" do
      @extractor.lang = "bullshit-language"
      @extractor.validate_lang
      @extractor.lang.should eq("auto")
    end
  end

  describe "#most_significant" do
    before(:each) {
      SiteClassifier.configuration.translate = false
      @extractor = SiteClassifier::Extractor.new("http://cnn.com", ["news"], {"news" => 10, "economy" => 5, "text" => 3, "elad" => 1, "miki" => 1}, "This is cnn news", "auto")
    }

    it "should return a list of the most common tags that exist in description" do
      @extractor.most_significant.should eq(["news"])
    end

    it "should return a list of most frequest used words and exist in description if tags are empty and description exists" do
      @extractor.tags = []
      @extractor.most_significant.should eq(["news"])
    end

    it "should return a list of most frequest used words if tags are empty and description missing" do
      @extractor.tags = []
      @extractor.description = nil
      @extractor.most_significant.should eq(["news", "economy", "text", "elad", "miki"])
    end
  end
end