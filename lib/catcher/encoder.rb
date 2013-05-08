class Encoder
  def self.encode(string)
    if string.respond_to?(:encode!)
      string.encode!('UTF-8', :invalid => :replace, :undef => :replace, :replace => '')
    else
      require 'iconv'
      ::Iconv.conv('UTF-8//IGNORE', 'UTF-8', string + ' ')[0..-2]
    end
  end
end
