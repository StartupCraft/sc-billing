# frozen_string_literal: true

require 'sc/billing/container'

SC::Billing::Import = Dry::AutoInject(::SC::Billing::Container)
