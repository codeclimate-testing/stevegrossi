require 'faker'

FactoryGirl.define do  
  
  factory :book do
    title { Faker::Lorem.sentence(6) }
    publisher { Faker::Company.name }
    pub_year { Time.now.year - 1 }
    thoughts { Faker::Lorem.paragraphs }
    after(:build) { |book| book.authors << FactoryGirl.build(:author) }
  end
  
  factory :book_without_author, parent: Book do
    after(:build) { |book| book.authors = [] }
  end
  
  factory :book_with_two_authors, parent: Book do
    after(:build) do |book|
        book.authors << FactoryGirl.build(:author)
    end
  end
  
end