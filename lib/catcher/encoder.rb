class Encoder
  def self.encode(string)
    if string.encoding == Encoding::ASCII_8BIT
      string.force_encoding('UTF-8')
    else
      string.encode('UTF-8')
    end
  end
end
