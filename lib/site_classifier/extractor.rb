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

    def self.debug(string)
      if SiteClassifier.configuration.debug?
        puts "#{Time.now.to_i} - #{string}"
      end
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
      # if !description.nil?
      #   if tags.any?
      #     most_sig = tags.select {|tag| self.description.downcase.include?(tag)}.collect {|tag| tag.singularize }
      #   else
      #     most_sig = word_frequency.keys.select {|tag| self.description.downcase.include?(tag)}.collect {|tag| tag.singularize }
      #   end
      # end

      description.to_s.split.each do |word|
        self.word_frequency[word] ||= 0
        self.word_frequency[word] += 1
      end

      if most_sig.empty?
        most_sig = self.word_frequency.reject {|k,v| v < 3}.keys
        most_sig.flatten!
      end

      if description && tags.any?
        tags.each do |tag|
          if description.include?(tag)
            most_sig << tag.singularize
          end
        end
      end
      
      most_sig.uniq!

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

      debug("getting #{url}")
      html = Nokogiri::HTML(self.get(url).parsed_response)

      tags = []
      description = nil
      word_hash = {}
      page_lang = "auto"

      begin
        page_lang = html.search("html").first["lang"].to_s.slice(0..1)
        debug("found lang in html tag - #{page_lang}")
      rescue
      end

      begin
        page_lang = html.search("html").first["xml:lang"].to_s.slice(0..1)
        debug("found lang in html tag (xml:lang) - #{page_lang}")
      rescue
      end

      begin
        tags = html.search('meta[name="keywords"]').first["content"].split(",").collect(&:strip).collect(&:downcase)
        debug("Tags - #{tags.inspect}")
      rescue
        debug("no tags found")
      end

      if tags.empty?
        begin
          tags = html.search('meta[property="keywords"]').first["content"].split(",").collect(&:strip).collect(&:downcase)
          debug("Tags - #{tags.inspect}")
        rescue
          debug("no tags found")
        end
      end
      begin
        description = html.search('meta[name="description"]').first["content"]
        debug("Decription meta found")
      rescue
      end

      if description.nil?
        begin
          description = html.search('meta[property="og:description"]').first["content"]
          debug("Facebook og:description found")
        rescue
        end
      end

      if description.nil?
        begin
          description = html.search('meta[name="og:description"]').first["content"]
          debug("Facebook og:description found")
        rescue
        end
      end

      if tags.empty?
        debug("no tags, parsing body")
        word_hash = Hash.new(0)
        all_text = []
        # all_text = html.search("p").collect {|p| p.text.strip }.collect {|text| text.split.collect(&:strip)}.flatten.reject {|word| word.size < 4}
        # debug("p's extracts - #{all_text.inspect}")
        if all_text.empty?
          all_text = html.search("div").collect {|p| p.text.strip }.collect {|text| text.split.collect(&:strip)}.flatten.reject {|word| word.size < 4}
          debug("divs extracts - #{all_text.inspect}")
        end
        all_text += description.to_s.split

        all_text.flatten.each do |word|
          word_hash[word] += 1
        end
        debug("final word hash - #{word_hash.inspect}")
        word_hash.reject! {|k,v| v < 3 || k.size == 1 || k.include?(".") || k.include?("'") || k.include?("(") || k.include?(":") || k.include?("]")}
        
      end
      self.new(url, tags, word_hash, description, page_lang)
    end
  end
end