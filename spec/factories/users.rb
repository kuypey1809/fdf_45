FactoryBot.define do
  factory :user1, class: User do
    name {Faker::Name.name}
    email {Faker::Internet.email}
    phone {"0914112828"}
    address {Faker::Address.street_address}
    password {"123123"}
  end
  factory :user, class: User do
    name {Faker::Name.name}
    email {"KuyPEY1809@Gmail.Com"}
    phone {"0914112828"}
    address {Faker::Address.street_address}
    password {"123123"}
  end
  factory :user2, class: User do
    name {"van khoi"}
    email {"asdasd"}
    phone {"0914112828"}
    address {"94 pvn"}
    password {"123123"}
  end
end
