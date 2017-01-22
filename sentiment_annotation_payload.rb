require 'plissken'
require 'json'
require './doc_sentiment'
require './annotation_payload'

class SentimentAnnotationPayload < AnnotationPayload
  attr_accessor :doc_sentiment
  def initialize(json_hash)
    json_hash = json_hash.to_snake_keys
    json_hash.each do |key,value|
      if self.respond_to?("#{key}=".to_sym) && !key.eql?(:doc_sentiment)
        self.send("#{key}=".to_sym, value)
      end
    end
    @doc_sentiment = DocSentiment.new(json_hash[:doc_sentiment])
  end
end
