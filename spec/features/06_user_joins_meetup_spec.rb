require 'spec_helper'

feature 'user joins meetup' do
  let!(:user) do
    User.create(
      provider: "github",
      uid: "1",
      username: "jarlax1",
      email: "jarlax1@launchacademy.com",
      avatar_url: "https://avatars2.githubusercontent.com/u/174825?v=3&s=400"
    )
  end

  let!(:user2) do
    User.create(
      provider: "github",
      uid: "2",
      username: "jarlax2",
      email: "jarlax2@launchacademy.com",
      avatar_url: "https://avatars2.githubusercontent.com/u/174825?v=3&s=400"
    )
  end

  let!(:user3) do
    User.create(
      provider: "github",
      uid: "3",
      username: "jarlax3",
      email: "jarlax3@launchacademy.com",
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

  let!(:meeting) do
    Meeting.create(
      user_id: user2.id,
      meetup_id: meetup.id
    )
  end

  scenario 'sees button to join if not signed in' do
    visit "/meetups/#{meetup.id}"

    expect(page).to have_selector(:link_or_button, 'Join')
  end

  scenario 'sees button to join if signed in but not a member of the meetup' do
    visit "/"
    sign_in_as user3

    visit "/meetups/#{meetup.id}"

    expect(page).to have_selector(:link_or_button, 'Join')
  end

  scenario 'successfully join to the meetup' do
    visit "/"
    sign_in_as user3

    visit "/meetups/#{meetup.id}"
    click_on "Join"

    expect(page).to have_content("You have joined the meetup")
    expect(page).to have_content("jarlax3")
  end

  scenario 'successfully join to the meetup' do
    visit "/"
    sign_in_as user3

    visit "/meetups/#{meetup.id}"
    click_on "Join"

    expect(page).to have_content("You have joined the meetup")
    expect(page).to have_content("jarlax3")
  end

  scenario 'join when not signed in' do
    visit "/meetups/#{meetup.id}"

    click_on "Join"

    expect(page).to have_content("You must sign in first!")
  end
end
