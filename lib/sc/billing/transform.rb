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
end
