FactoryGirl.define do
  factory :product do
    name "Octocat"
    price 500
    permalink "octocat"
    file File.new(Rails.root + 'spec/factories/images/octocat.png')
  end
end
