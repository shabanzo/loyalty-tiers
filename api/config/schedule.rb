# frozen_string_literal: true

every '30 23 31 12 *' do
  runner '::LoyaltyStat::AnnualGenerator.new.call'
end
