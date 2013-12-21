# == Schema Information
#
# Table name: pages
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  permalink   :string(255)
#  content     :text
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe Page do
  it 'has a valid factory' do
    build(:page).should be_valid
  end
  it 'is invalid without a title' do
    page = build(:page, title: nil)
    page.should_not be_valid
    page.should have(1).error_on(:title)
  end
  it 'is invalid without a permalink' do
    page = build(:page, permalink: nil)
    page.should_not be_valid
    page.should have(1).error_on(:permalink)
  end
  it 'is invalid without content' do
    page = build(:page, content: nil)
    page.should_not be_valid
    page.should have(1).error_on(:content)
  end
  it 'has a unique title' do
    create(:page, title: 'About')
    build(:page, title: 'About').should_not be_valid
  end
  it 'has a unique permalink' do
    create(:page, permalink: 'about/pants')
    build(:page, permalink: 'about/pants').should_not be_valid
  end
end
