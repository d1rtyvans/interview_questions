class KV
  def initialize
    @kv = {}
  end

  def get(key, timestamp = nil)
    if @kv[key]
      if timestamp
        @kv[key][timestamp] || fuzzy_find(key, timestamp)
      else
        @kv[key + '-latest']
      end
    end
  end

  def set(key, value)
    timestamp = Time.now.to_f
    @kv[key] ||= {}
    @kv[key][timestamp] = value
    @kv[key + '-latest'] = value
    timestamp
  end

  private

  def fuzzy_find(key, timestamp)
    keys   = @kv[key].keys
    left   = 0
    right  = keys.length - 1
    fuzzy_time_match = 0.0

    # Binary search, keep track of closest lower match
    while left < right
      middle = (left + right) / 2

      case
      when timestamp > keys[middle]
        if fuzzy_time_match < keys[middle]
          fuzzy_time_match = keys[middle]
        end

        left = middle + 1
      else
        right = middle - 1
      end
    end

    @kv[key][fuzzy_time_match]
  end
end
