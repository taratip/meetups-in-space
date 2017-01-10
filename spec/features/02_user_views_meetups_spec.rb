require 'spec_helper'

feature "User view meetups" do
  let!(:user) do
    User.create(
      provider: "github",
      uid: "1",
      username: "jarlax1",
      email: "jarlax1@launchacademy.com",
      avatar_url: "https://avatars2.githubusercontent.com/u/174825?v=3&s=400"
    )
  end

  scenario "user views all available meetups" do
    meetup = Meetup.create(
      creator_id: user.id,
      name: "The first meeting",
      description: "This is the first ever meetup",
      location: "Somewhere in space"
    )

    visit "/meetups"
    expect(page).to have_content("The first meeting")
  end

  scenario "user views meetups in alphabetically order" do
    first_meetup = Meetup.create(
      creator_id: user.id,
      name: "The first meeting",
      description: "This is the first ever meetup",
      location: "Somewhere in space"
    )

    second_meetup = Meetup.create(
      creator_id: user.id,
      name: "Second meeting",
      description: "The second meetup after successful first one",
      location: "Same location"
    )

    visit "/meetups"

    first_meetup_position = page.body.index("The first meeting")
    second_meetup_position = page.body.index("Second meeting")
    expect(second_meetup_position).to be < first_meetup_position

  end
end
