require 'rails_helper'

RSpec.describe User, type: :model do
	
	# test associations

	it { should have_many(:posts) }

	# test attributes

	it { should validate_presence_of(:email) }

	it { should validate_uniqueness_of(:email) }

	it { should validate_presence_of(:password) }
end
