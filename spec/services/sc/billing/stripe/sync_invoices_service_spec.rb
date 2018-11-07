# frozen_string_literal: true

RSpec.describe SC::Billing::Stripe::SyncInvoicesService, :stripe do
  let(:service) { described_class.new }
  let(:stripe_helper) { StripeMock.create_test_helper }

  describe '#call' do
    subject(:call) do
      service.call
    end

    def double_invoice(invoice_id, plan, customer_id = nil)
      invoice_items = construct_invoice_items(plan)

      construct_invoice(invoice_id, customer_id, invoice_items)
    end

    def construct_invoice_items(plan)
      invoice_item = Stripe::InvoiceItem.construct_from(plan: plan)
      Stripe::ListObject.construct_from(data: [invoice_item])
    end

    # rubocop:disable Metrics/MethodLength
    def construct_invoice(invoice_id, customer_id, invoice_items)
      Stripe::Invoice.construct_from(
        id: invoice_id,
        items: invoice_items,
        customer: customer_id,
        status: 'active',
        current_period_start: 1_528_385_032,
        current_period_end: 1_530_977_032,
        trial_start: nil,
        trial_end: nil,
        cancel_at_period_end: false,
        canceled_at: nil
      )
    end
    # rubocop:enable Metrics/MethodLength

    before do
      plan = stripe_helper.create_plan(product: 'prod_1', id: 'plan_1')

      invoice = double_invoice('sub_1', plan)
      invoice2 = double_invoice('sub_2', plan, 'cus_1')
      invoices_list = Stripe::ListObject.construct_from(data: [invoice, invoice2], has_more: false)

      allow(Stripe::Invoice).to receive(:all).and_return(invoices_list)
    end

    let!(:invoice) { create(:stripe_invoice, :active, stripe_id: 'sub_1') }

    context 'when plan does not exist in system' do
      it 'raises error' do
        expect { call }.to raise_error('There is no enough plans in system')
      end
    end

    context 'when product does not exist in system' do
      before do
        create(:stripe_plan, stripe_id: 'plan_1')
      end

      it 'raises error' do
        expect { call }.to raise_error('There is no enough products in system')
      end
    end

    context 'when product exists in system' do
      let!(:product) { create(:stripe_product, stripe_id: 'prod_1') }

      before do
        create(:stripe_plan, product: product, stripe_id: 'plan_1')
        create(:user, stripe_customer_id: 'cus_1')
      end

      it 'actualizes invoices and creates new one' do
        expect { call }.to(
          change { invoice.reload.products }.from([]).to([product])
            .and(change { invoice.reload.current_period_start_at })
            .and(change { invoice.reload.current_period_end_at })
            .and(not_change { invoice.reload.trial_start_at })
            .and(not_change { invoice.reload.trial_end_at })
            .and(change { invoice.reload.stripe_data })
            .and(change { ::SC::Billing::Stripe::Invoice.count }.by(1))
        )
      end
    end
  end
end
