FactoryBot.define do
  factory :post do
    text { Faker::TvShows::DrWho.quote }
    user
  end
end