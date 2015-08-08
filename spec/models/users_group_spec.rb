require 'rails_helper'

RSpec.describe UsersGroup, type: :model do
  it { expect(subject).to belong_to(:user) }
  it { expect(subject).to belong_to(:group) }
end
