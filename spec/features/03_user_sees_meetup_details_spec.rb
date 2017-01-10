require 'spec_helper'
require 'pry'

feature 'user sees meetup details' do
  let!(:user) do
    User.create(
      provider: "github",
      uid: "1",
      username: "jarlax1",
      email: "jarlax1@launchacademy.com",
      avatar_url: "https://avatars2.githubusercontent.com/u/174825?v=3&s=400"
    )
  end

  let!(:meetup) do
    Meetup.create(
      creator_id: user.id,
      name: "The first meeting",
      description: "This is the first ever meetup",
      location: "Somewhere in space"
    )
  end

  scenario "can get to meetup's details page through meetup index page" do
    visit "/meetups/#{meetup.id}"
    expect(page).to have_content("The first meeting")
  end

  scenario "can see meetup details" do
    visit "/meetups/#{meetup.id}"
    expect(page).to have_content("The first meeting")
  end

  scenario "can see meetup's description, location and creator" do
    visit "/meetups/#{meetup.id}"
    expect(page).to have_content("This is the first ever meetup")
    expect(page).to have_content("Somewhere in space")
    expect(page).to have_content("jarlax1")
  end
end
