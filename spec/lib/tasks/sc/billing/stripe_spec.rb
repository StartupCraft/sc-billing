# frozen_string_literal: true

RSpec.shared_examples_for 'calls proper service inside task' do |klass|
  it 'calls proper service' do
    service = instance_double(klass)
    allow(klass).to receive(:new).and_return(service)
    allow(service).to receive(:call)

    task.execute
    expect(service).to have_received(:call)
  end
end

RSpec.describe 'sc:billing:stripe:sync_products', type: :task do
  it_behaves_like 'calls proper service inside task', ::SC::Billing::Stripe::SyncProductsService
end

RSpec.describe 'sc:billing:stripe:sync_plans', type: :task do
  it_behaves_like 'calls proper service inside task', ::SC::Billing::Stripe::SyncPlansService
end

RSpec.describe 'sc:billing:stripe:sync_subscriptions', type: :task do
  it_behaves_like 'calls proper service inside task', ::SC::Billing::Stripe::SyncSubscriptionsService
end

RSpec.describe 'sc:billing:stripe:sync_invoices', type: :task do
  it_behaves_like 'calls proper service inside task', ::SC::Billing::Stripe::SyncInvoicesService
end
