require 'spec_helper'

feature "user creates a new meetup" do
  let!(:user) do
    User.create(
      provider: "github",
      uid: "1",
      username: "jarlax1",
      email: "jarlax1@launchacademy.com",
      avatar_url: "https://avatars2.githubusercontent.com/u/174825?v=3&s=400"
    )
  end

  scenario "navigates to the meetups new page" do
    visit "/meetups"

    expect(page).to have_link('Add New', href: '/meetups/new')
  end

  scenario "need to signs in to create a new meetup" do
    visit "/meetups/new"

    expect(page).to have_content('You are not currently signed in. Please sign in first!')
  end

  scenario "successfully creates a new meetup, providing all fields" do
    visit "/meetups/new"
    sign_in_as user

    visit "/meetups/new"

    fill_in "name", with: "New meetup"
    fill_in "description", with: "This is the first ever meetup"
    fill_in "location", with: "On earth"
    click_on "Add a meetup"

    expect(page).to have_content('You have created a meetup successfully.')
  end

  scenario "fails to creat a new meetup, without providing all fields" do
    visit "/meetups/new"
    sign_in_as user

    visit "/meetups/new"

    fill_in "name", with: "New meetup"
    click_on "Add a meetup"

    expect(page).to have_content("Location can't be blank")
    expect(page).to have_content("Description can't be blank")
    expect(page).to have_field("name", with: "New meetup")
  end
end
