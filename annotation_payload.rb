require 'plissken'
require 'json'
class AnnotationPayload
  attr_accessor :language, :text
  def initialize(json_hash)
    json_hash = json_hash.to_snake_keys
    json_hash.each do |key,value|
      if self.respond_to?("#{key}=".to_sym)
        self.send("#{key}=".to_sym, value)
      end
    end
  end
end
