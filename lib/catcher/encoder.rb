class Encoder
  def self.encode(string)
    string.force_encoding('UTF-8')
  end
end
