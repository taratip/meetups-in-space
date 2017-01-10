require 'spec_helper'

feature 'user cancels the meetup' do
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

  scenario "when signed in, user sees button to cancel on the meetup's show page" do
    visit "/"
    sign_in_as user

    visit "/meetups/#{meetup.id}"

    expect(page).to have_selector(:link_or_button, 'Cancel')
  end

  scenario "successfully deletes the meetup" do
    visit "/"
    sign_in_as user

    visit "/meetups/#{meetup.id}"
    click_on "Cancel"

    expect(page).to have_content("Meetup")
    expect(page).not_to have_content("The first meeting")
  end
end
