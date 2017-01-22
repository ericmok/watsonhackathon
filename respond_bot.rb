module RespondBot
  def self.flirt
    [
      'hey babe... wyd?',
      'hey bighead',
      'heyyyy',
      'hi stranger',
      'ok bye',
      'been a while',
      'everything ok?'
    ].sample
  end

  def self.respond(name)
    [
      "I don't know what you said#{' ' + name.split(" ").first}, but i'm glad you're talking to me",
      "Thanks for noticing me#{' ' + name.split(" ").first}!",
      "awww you!",
      "#{name.split(" ").first.upcase}!",
      "you are so cute when you text#{' ' + name.split(" ").first}!"
    ].sample
  end

  def self.concerned(name)
    [
      "awww whats wrong#{' ' + name.split(" ").first}?",
      "is everything ok#{' ' + name.split(" ").first}? :(",
      "im sorry to hear that#{' ' + name.split(" ").first}",
      "nooooo dont be like that#{' ' + name.split(" ").first}!",
      "you still have me :)"
    ].sample
  end
end
