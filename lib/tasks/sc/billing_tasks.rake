# frozen_string_literal: true

# desc "Explaining what the task does"
namespace :sc do
  namespace :billing do
    namespace :stripe do
      task sync_products: :environment do
        ::SC::Billing::Stripe::SyncProductsService.new.call
      end

      task sync_plans: :environment do
        ::SC::Billing::Stripe::SyncPlansService.new.call
      end
    end
  end
end
