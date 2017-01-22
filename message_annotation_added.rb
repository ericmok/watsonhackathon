require 'plissken'
require 'json'
require './sentiment_annotation_payload'

class MessageAnnotationAdded
  attr_accessor :space_name, :space_id, :message_id, :time, :type, :user_name,
                :user_id, :annotation_payload, :annotation_type, :annotation_id
  def initialize(json_hash)
    json_hash = json_hash.to_snake_keys
    json_hash.each do |key,value|
      if self.respond_to?("#{key}=".to_sym) && !key.eql?(:annotation_payload)
        self.send("#{key}=".to_sym, value)
      end
    end
    if annotation_type.eql?("message-nlp-docSentiment")
      @annotation_payload = SentimentAnnotationPayload.new(JSON.parse(json_hash[:annotation_payload]).to_snake_keys)
    end
  end
end
