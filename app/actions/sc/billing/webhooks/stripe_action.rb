# frozen_string_literal: true

module SC::Billing::Webhooks
  class StripeAction
    include Dry::Transaction

    # TODO: make congfigurable
    OPERATIONS_BY_EVENT_TYPE = {
      'customer.created' => ::SC::Billing::Stripe::Customers::CreateOperation
    }.freeze

    try :construct_event, catch: [JSON::ParserError, ::Stripe::SignatureVerificationError]
    step :handle

    def construct_event(request)
      ::Stripe::Webhook.construct_event(
        request.body.read,
        request.env['HTTP_STRIPE_SIGNATURE'],
        ::SC::Billing.stripe_webhook_secret
      )
    end

    def handle(event)
      operation = OPERATIONS_BY_EVENT_TYPE[event.type]
      return Failure(false) unless operation.present?

      operation.new.call(event)

      Success(true)
    end
  end
end
