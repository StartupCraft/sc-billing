# frozen_string_literal: true

module SC::Billing::Transform
  extend Transproc::Registry

  import Transproc::HashTransformations

  # Transform object attrs to hash
  #
  # @example
  #   Transform[:attrs_to_hash, %i[a b]].call(some_object)
  #
  #   # => {:a=>1, :b=>nil}
  #
  def self.attrs_to_hash(source_obj, keys)
    keys.each_with_object({}) do |key, hash|
      hash[key] = source_obj.respond_to?(key) ? source_obj.send(key) : nil
    end
  end

  # Transform hash values from timestamp to time by keys
  #
  # @example
  #   Transform[:timestamp_to_time, %i[as_of due_to]].call(as_of: 1_528_549_095, due_to: 1_528_559_09)
  #
  #   # => {:as_of=>2018-06-09 12:58:15 +0000, :due_to=>2018-06-09 15:44:55 +0000}
  #
  def self.timestamp_to_time(source_hash, keys)
    from_timestamp_to_time_meth = ::SC::Billing::Helpers::FromTimestampToTime.new

    Hash[source_hash].tap do |hash|
      keys.each do |key|
        next unless hash.key?(key)

        hash[key] = from_timestamp_to_time_meth.call(hash[key])
      end
    end
  end
end
