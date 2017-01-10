require 'spec_helper'

feature 'user edits the meetup details' do
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

  scenario "when signed in, user sees link to edit on the meetup's show page" do
    visit "/"
    sign_in_as user

    visit "/meetups/#{meetup.id}"

    expect(page).to have_selector(:link_or_button, 'Edit')
  end

  scenario "sees pre-populated with meetup's details" do
    visit "/"
    sign_in_as user

    visit "/meetups/#{meetup.id}"
    click_on "Edit"

    expect(page).to have_field("name", with: "The first meeting")
    expect(page).to have_field("description", with: "This is the first ever meetup")
    expect(page).to have_field("location", with: "Somewhere in space")
  end

  scenario "successfully edits the meetup's details" do
    visit "/"
    sign_in_as user

    visit "/meetups/#{meetup.id}"
    click_on "Edit"

    fill_in "description", with: "Add a little bit more details on the meetup"
    click_on "Save"

    expect(page).to have_content("The meetup has been successfully updated")
    expect(page).to have_content("The first meeting")
    expect(page).to have_content("Add a little bit more details on the meetup")
  end

  scenario "fails to update with invalid information" do
    visit "/"
    sign_in_as user

    visit "/meetups/#{meetup.id}"
    click_on "Edit"

    fill_in "description", with: ""
    click_on "Save"

    expect(page).to have_content("Description can't be blank")
    expect(page).to have_field("description", with: "This is the first ever meetup")
  end
end
