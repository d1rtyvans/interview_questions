# 2. Allow key to hold many values with each value having a timestamp. if get receives just the key, return latest value. If get receives both key and time, return the appropriate value.
# 3. modify get to return closest value with timestamp lesser than argument timestamp.
# implement a key-value datastore that supports querying for historic values. For every key there can be multiple values at different timestamps, and it should support querying by a key only, or a key and timestamp. 

require 'pry'
class TimeHash
  # Store key (with timestamped values)
  # Lookup by key
  # Lookup by timestamp
  # Rank by timestamp (latest value)
  def initialize
    @hash = {}
  end

  def set(key, value, timestamp: Time.now)
    @hash[key] ||= {}
    @hash[key][timestamp] = value

    unless @hash[key]['latest'] && @hash[key]['latest'] > timestamp
      @hash[key]['latest'] = timestamp
    end
  end

  def get(key, timestamp = nil)
    if @hash[key]
      timestamp = @hash[key]['latest'] unless timestamp
      @hash[key][timestamp]
    end
  end
end


h = TimeHash.new

puts "Test 1: #{h.get(:hey).nil?}"

h.set(:hey, 'hi')
h.set(:hey, 'hello')

puts "Test 2: #{h.get(:hey) == 'hello'}"
puts "Test 3: #{h.get(:hey, Time.now).nil?}"

timestamp = Time.new('2019')
h.set(:bye, 'goodbye')
h.set(:bye, 'farewell', timestamp: timestamp)

puts "Test 4: #{h.get(:bye) == 'goodbye'}"
puts "Test 5: #{h.get(:bye, timestamp) == 'farewell'}"
puts "Test 6: #{h.get(:bye, Time.now).nil?}"
