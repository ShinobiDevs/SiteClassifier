module SiteClassifier
  class Configuration
    attr_accessor :translate, :google_translate_api_key
      
    # Instantiate a new class
    def initialize(options = {})
      @translate = options[:translate] || false
      @google_translate_api_key = options[:google_translate_api_key]
    end

    # Configure by block
    def self.configure(&block)
      new_configuration = SiteClassifier::Configuration.new
      yield new_configuration
      new_configuration
    end
  end
end