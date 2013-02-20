require 'iconv'
class Encoder
  def self.encode(string)
    ::Iconv.conv('UTF-8//IGNORE', 'UTF-8', string + ' ')[0..-2]
  end
end
