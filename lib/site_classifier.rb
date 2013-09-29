require "site_classifier/version"
require 'httparty'
require 'easy_translate'
require 'nokogiri'
require 'active_support/inflector'

module SiteClassifier

  autoload :Configuration, 'site_classifier/configuration'
  autoload :Extractor, 'site_classifier/extractor'

  attr_reader :setup

  def self.configure(&block)
    @setup = SiteClassifier::Configuration.configure(&block)
  end

  def self.translate_tags?
    self.configuration.translate == true
  end

  def self.configuration
    @setup ||= SiteClassifier::Configuration.new
  end
end
