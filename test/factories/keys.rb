# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :key do
    key_id "MyString"
    public_key "MyString"
    url "MyString"
    name "MyString"
    verified false
    authorization nil
  end
end
