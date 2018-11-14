# frozen_string_literal: true

module SC::Billing::FindOrRaise
  # rubocop:disable Metrics/MethodLength
  def self.[](entity_names)
    Module.new do
      entity_names.to_a.each do |entity_name, stripe_key|
        define_method("find_or_raise_#{entity_name}") do |stripe_id|
          public_send("find_#{entity_name}", stripe_id).tap do |entity|
            public_send("raise_if_#{entity_name}_not_found", entity, stripe_id)
          end
        end

        define_method("find_#{entity_name}") do |stripe_id|
          public_send("#{entity_name}_model").find(stripe_key => stripe_id)
        end

        define_method("raise_if_#{entity_name}_not_found") do |entity, stripe_id|
          raise "There is no #{entity_name} with stripe_id: #{stripe_id} in system" unless entity
        end
      end
    end
  end
  # rubocop:enable Metrics/MethodLength
end
