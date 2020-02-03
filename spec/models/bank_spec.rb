require 'rails_helper'

RSpec.describe Bank, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:state) }
end
