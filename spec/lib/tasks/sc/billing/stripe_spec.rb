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