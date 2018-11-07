# frozen_string_literal: true

module SC::Billing::Webhooks
  class StripeAction
    include Dry::Transaction

    NAMESPACE = ::SC::Billing::Stripe::Webhooks

    OPERATIONS_BY_EVENT_TYPE = [
      NAMESPACE::Customers::CreateOperation,
      NAMESPACE::Customers::UpdateOperation,
      NAMESPACE::Invoices::CreateOperation,
      NAMESPACE::Products::CreateOperation,
      NAMESPACE::Plans::CreateOperation,
      NAMESPACE::Plans::UpdateOperation,
      NAMESPACE::Customers::Sources::CreateOperation,
      NAMESPACE::Customers::Sources::UpdateOperation,
      NAMESPACE::Customers::Sources::DeleteOperation,
      NAMESPACE::Customers::Subscriptions::CreateOperation,
      NAMESPACE::Customers::Subscriptions::UpdateOperation,
      NAMESPACE::Customers::Subscriptions::DeleteOperation
    ].map do |operation_class|
      [operation_class.event_type, operation_class]
    end.to_h.freeze

    try :construct_event, catch: [JSON::ParserError, ::Stripe::SignatureVerificationError]
    step :handle

    private

    def construct_event(request)
      ::Stripe::Webhook.construct_event(
        request.body.read,
        request.env['HTTP_STRIPE_SIGNATURE'],
        ::SC::Billing.stripe_webhook_secret
      )
    end

    def handle(event)
      operation = choose_operation(event)
      return Failure(false) unless operation.present?

      operation.new.call(event)

      Success(true)
    end

    def choose_operation(event)
      return nil unless available_event?(event)

      if ::SC::Billing.custom_event_handlers.key?(event.type)
        ::SC::Billing.custom_event_handlers[event.type]
      else
        OPERATIONS_BY_EVENT_TYPE[event.type]
      end
    end

    def available_event?(event)
      ::SC::Billing.available_events.include?(event.type)
    end
  end
end
