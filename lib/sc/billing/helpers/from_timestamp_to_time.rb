# frozen_string_literal: true

module SC::Billing::Helpers
  class FromTimestampToTime
    def call(timestamp)
      return if timestamp.nil?

      Time.at(timestamp)
    end
  end
end
