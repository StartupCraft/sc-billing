# frozen_string_literal: true

module SC::Billing::Stripe::Webhooks
  class BaseOperation < ::SC::Billing::BaseOperation
    def self.set_event_type(type_name) # rubocop:disable Naming/AccessorMethodName
      define_singleton_method(:event_type) do
        type_name
      end
    end

    private

    # TODO: refactor
    def find_or_raise_user(customer_id)
      find_user(customer_id).tap do |user|
        raise_if_user_not_found(user, customer_id)
      end
    end

    def find_user(customer_id)
      user_model.find(stripe_customer_id: customer_id)
    end

    def raise_if_user_not_found(user, customer_id)
      raise "There is no user with stripe_customer_id: #{customer_id} in system" unless user
    end

    def run_hook(hook_type, **params)
      hook_handler = ::SC::Billing.event_hooks.dig(self.class.event_type, hook_type)
      return if hook_handler.nil?

      if hook_handler.is_a? Array
        hook_handler.each do |hook|
          hook.new.call(params)
        end
      else
        hook_handler.new.call(params)
      end
    end

    def run_before_hook(**params)
      run_hook('before', params)
    end

    def run_after_hook(**params)
      run_hook('after', params)
    end
  end
end
