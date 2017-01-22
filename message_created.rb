require 'plissken'
class MessageCreated
  attr_accessor :space_name, :space_id, :message_id, :time, :type, :user_name,
                 :user_id, :content_type, :content
  def initialize(json_hash)
    json_hash = json_hash.to_snake_keys
    json_hash.each do |key,value|
      self.send("#{key}=".to_sym, value) if self.respond_to?("#{key}=".to_sym)
    end
  end
end
