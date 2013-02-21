class DummyClass < Catcher::API
  def id
    @id ||= @options.fetch(:id)
  end

  def locale
    @locale ||= @options.fetch(:locale)
  end

  def root_key
    :example
  end

  def domain
    'example.com'
  end

  def resource
    "http://#{domain}/#{locale}/#{id}"
  end

  def expires_in
    500
  end
end

class CacheApi < DummyClass

  def cache_key
    "example-#{locale}-#{id}"
  end

end

class NoCacheApi < DummyClass;end;

