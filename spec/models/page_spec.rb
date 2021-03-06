require "spec_helper"

describe Page do

  it "is invalid without a title" do
    page = build(:page, title: nil)
    expect(page).to_not be_valid
    expect(page.errors[:title].size).to eq(1)
  end

  it "is invalid without a permalink" do
    page = build(:page, permalink: nil)
    expect(page).to_not be_valid
    expect(page.errors[:permalink].size).to eq(1)
  end

  it "is invalid without content" do
    page = build(:page, content: nil)
    expect(page).to_not be_valid
    expect(page.errors[:content].size).to eq(1)
  end

  it "has a unique title" do
    create(:page, title: "About")
    expect(build(:page, title: "About")).to_not be_valid
  end

  it "has a unique permalink" do
    create(:page, permalink: "about/pants")
    expect(build(:page, permalink: "about/pants")).to_not be_valid
  end
end
