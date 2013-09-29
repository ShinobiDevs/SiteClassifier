module SiteClassifier
  class Extractor
    include HTTParty

    attr_accessor :url, :tags, :description, :word_frequency, :lang

    def initialize(url, tags, word_hash, description, lang)
      @url = url
      @tags = tags
      @description = description
      @word_frequency = word_hash
      @lang = lang.downcase
    end

    # Normalize site language
    def validate_lang
      if EasyTranslate::LANGUAGES.keys.include?(@lang)
        @lang
      else
        self.lang = "auto"
      end
    end

    # Extract most significant tags
    def most_significant
      most_sig = []
      if !description.nil?
        if tags.any?
          most_sig = tags.select {|tag| self.description.downcase.include?(tag)}.collect {|tag| tag.singularize }
        else
          most_sig = word_frequency.keys.select {|tag| self.description.downcase.include?(tag)}.collect {|tag| tag.singularize }
        end
      end

      if most_sig.empty?
        most_sig = self.word_frequency.keys
      end

      self.validate_lang

      if SiteClassifier.translate_tags?
        begin
          if self.lang == "auto"
            @lang = EasyTranslate.detect(most_sig.first, key: SiteClassifier.configuration.google_translate_api_key)
          end
          EasyTranslate.translate(most_sig, from: self.lang, to: :en, key: SiteClassifier.configuration.google_translate_api_key)
        rescue
          return most_sig
        end
      else
        return most_sig
      end
    end

    def to_hash
      {
        most_significant: most_significant,
        language: self.lang,
        url: url,
        tags: tags,
        description: description
      }
    end

    def self.parse_site(url = "")
      return if url == "" || url.nil?

      html = Nokogiri::HTML(self.get(url).parsed_response)

      tags = []
      description = nil
      word_hash = {}
      page_lang = "auto"

      begin
        page_lang = html.search("html").first["lang"].to_s.slice(0..1)
      rescue
      end

      begin
        page_lang = html.search("html").first["xml:lang"].to_s.slice(0..1)
      rescue
      end

      begin
        tags = html.search('meta[name="keywords"]').first["content"].split(",").collect(&:strip).collect(&:downcase)
        description = html.search('meta[name="description"]').first["content"]
      rescue
      end

      if tags.empty?
        word_hash = Hash.new(0)
        all_text = html.search("p").collect {|p| p.text.strip }.collect {|text| text.split.collect(&:strip)}.flatten.reject {|word| word.size < 4}
        if all_text.empty?
          all_text = html.search("div").collect {|p| p.text.strip }.collect {|text| text.split.collect(&:strip)}.flatten.reject {|word| word.size < 4}
        end
        all_text.each do |word|
          word_hash[word] += 1
        end
        word_hash.reject! {|k,v| v < 2 }
      end
      self.new(url, tags, word_hash, description, page_lang)
    end
  end
end