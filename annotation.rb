class Annotation
  def initialize
    @annotation = {
      type: 'generic',
      version: 1.0
    }
  end

  def text=(text)
    @annotation[:text] = text
    @annotation
  end

  def to_json(options = nil)
    @annotation.to_json
  end
end
