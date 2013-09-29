# SiteClassifier

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'site_classifier'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install site_classifier

## Configuration

    SiteClassifier.configure do |classifier|
      classifier.translate = true
      classifier.google_translate_api_key = "XXX"
    end

    - translate (true / false) - indicates if tags should be translated to english. if `false` tags will appear in url's native language.
    - google_translate_api_key (string) - if translate is `true`, supply a Google Translate API key to allow translation.

## Usage

    SiteClassifier::Extractor.parse_site("http://cnn.com") 
    #=> {:most_significant=>["cnn", "news", "breaking news", "busines", "sport", "entertainment", "special report"], 
        :language=>"auto", 
        :url=>"http://cnn.com", 
        :tags=>["cnn", "cnn news", "cnn international", "cnn international news", "cnn edition", "edition news", "news", "news online", "breaking news", "u.s. news", "world news", "global news", "weather", "business", "cnn money", "sports", "politics", "law", "technology", "entertainment", "education", "travel", "health", "special reports", "autos", "developing story", "news video", "cnn intl", "podcasts", "world blogs"], 
        :description=>"CNN.com International delivers breaking news from across the globe and information on the latest top stories, business, sports and entertainment headlines. Follow the news as it happens through: special reports, videos, audio, photo galleries plus interactive maps and timelines."}

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
