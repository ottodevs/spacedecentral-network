require 'rails_helper'

RSpec.describe User, type: :model do
  describe "after creation" do
    it "does not send a confirmation email", truncation: true do
      user = build(:user)

      expect { user.save }.to change(
        Devise.mailer.deliveries, :count
      ).by(0)
    end
  end
end
