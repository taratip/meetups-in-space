require "spec_helper"

feature "user leaves the meetup" do
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

  scenario "current member sees leave button on the meetup" do
    visit "/"
    sign_in_as user2

    visit "/meetups/#{meetup.id}"

    expect(page).to have_selector(:link_or_button, 'Leave')
  end

  scenario "current member leaves the meetup and no longer on the member list" do
    visit "/"
    sign_in_as user2

    visit "/meetups/#{meetup.id}"
    click_on "Leave"

    expect(page).to have_selector(:link_or_button, 'Join')
  end
end
