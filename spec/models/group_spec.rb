require 'rails_helper'

RSpec.describe Group, type: :model do
  it { expect(subject).to have_many(:users_groups) }
  it { expect(subject).to have_many(:users).through(:users_groups) }
end
