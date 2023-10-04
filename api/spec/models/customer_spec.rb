require 'rails_helper'

RSpec.describe Customer, type: :model do
  it 'is valid with a name' do
    customer = FactoryBot.build(:customer, name: 'John Doe')
    expect(customer).to be_valid
  end

  it 'is invalid without a name' do
    customer = FactoryBot.build(:customer, name: nil)
    expect(customer).not_to be_valid
  end
end
