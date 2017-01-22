require 'plissken'
require 'json'
class DocSentiment
  attr_accessor :type
  def initialize(json_hash)
    json_hash = json_hash.to_snake_keys
    json_hash.each do |key,value|
      if self.respond_to?("#{key}=".to_sym) && !key.eql?("doc_sentiment")
        self.send("#{key}=".to_sym, value.to_sym)
      end
    end
  end
end
