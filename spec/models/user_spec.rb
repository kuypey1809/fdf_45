require "rails_helper"

RSpec.describe User, type: :model do
  context "should have columns" do
    it {is_expected.to have_db_column(:name).of_type(:string)}
    it {is_expected.to have_db_column(:email).of_type(:string)}
    it {is_expected.to have_db_column(:address).of_type(:string)}
    it {is_expected.to have_db_column(:phone).of_type(:string)}
    it {is_expected.to have_db_column(:role).of_type(:integer).
      with_options(default: :customer, null: false)}
    it {is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(null: false)}
    it {is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(null: false)}
    it {is_expected.to have_db_column(:password_digest).of_type(:string)}
  end

  context "associations" do
    it {is_expected.to have_many(:suggestions).dependent(:destroy)}
    it {is_expected.to have_many(:orders).dependent(:destroy)}
    it {is_expected.to have_many(:ratings).dependent(:destroy)}
    it {is_expected.to have_secure_password}
  end

  context "validate presence and length" do
    it {is_expected.to validate_presence_of :name}
    it {is_expected.to validate_length_of(:name).is_at_most(50)}
    it {is_expected.to validate_presence_of :email}
    it {is_expected.to validate_length_of(:email).is_at_most(255)}
    it {is_expected.to validate_presence_of :address}
    it {is_expected.to validate_length_of(:address).is_at_most(60)}
    it {is_expected.to validate_presence_of :phone}
    it {is_expected.to validate_length_of(:password).is_at_least(6)}
    it {is_expected.to define_enum_for(:role)}
  end

  context "has valid factory" do
  subject {FactoryBot.create(:user1)}
    it {is_expected.to be_valid}
    it {is_expected.to validate_uniqueness_of(:email).ignoring_case_sensitivity}
    it {expect(subject.email).to match(/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i) }
    it {expect(subject.phone).to match(/(09|03|05|07|08)+([0-9]{8})\b/)}
  end

  context ".callback before save" do
    let(:me1) {FactoryBot.build(:user)}
    it "downcase email" do
      expect(me1.email).to eq("KuyPEY1809@Gmail.Com")
      me1.run_callbacks :save
      expect(me1.email).to eq("kuypey1809@gmail.com")
    end
  end

  context "duplicated email" do
    let(:me2) {FactoryBot.build(:user)}
    it {is_expected.not_to be_valid}
  end
end
