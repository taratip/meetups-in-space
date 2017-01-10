require 'spec_helper'

feature 'user sees the list of members joined the meetup' do
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

  let!(:meeting1) do
    Meeting.create(
      user_id: user3.id,
      meetup_id: meetup.id
    )
  end

  scenario 'sees list of members that have joined the meetup' do
    visit "/meetups/#{meetup.id}"

    expect(page).to have_content("jarlax2")
    expect(page).to have_content("jarlax3")
  end

  scenario "sees each member's avatar and username" do
    visit "/meetups/#{meetup.id}"

    expect(page).to have_content("jarlax2")
    expect(page).to have_css('img',user2.avatar_url)
  end
end
