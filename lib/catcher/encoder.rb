class Encoder
  def initialize(string)
    @string = string
  end

  def self.encode(string)
    new(string).encode
  end

  def encode
    native? ? native : iconv
  end

  private
  attr_reader :string

  def native?
    encodable? && !ascii?
  end

  def ascii?
    string.encoding.to_s.include?('ASCII')
  end

  def encodable?
    string.respond_to?(:encode!)
  end

  def native
    string.encode!('UTF-8', :invalid => :replace, :undef => :replace, :replace => '')
  end

  def iconv
    require 'iconv'
    ::Iconv.conv('UTF-8//IGNORE', 'UTF-8', string + ' ')[0..-2]
  end
end
