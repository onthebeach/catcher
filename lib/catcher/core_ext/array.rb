class Array
  def with_indifferent_access
    map(&:with_indifferent_access)
  end
end
