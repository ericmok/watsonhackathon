require_relative 'annotation'

class Message
  def initialize
    @message = {
      type: 'appMessage',
      version: 1.0,
      annotations: []
    }
  end

  def text=(text)
    annotation = Annotation.new
    annotation.text = text
    @message[:annotations] = [annotation]
  end

  def to_json(options = nil)
    @message.to_json
  end
end
