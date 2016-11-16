require 'rails_helper'

RSpec.describe ProjectPostWorker do
  let(:perform_post)      { ProjectPostWorker.perform_async(post.id) }
  let(:project)           { create(:project) }
  let(:contribution)      { create(:contribution, :confirmed, project: project) }
  let(:user)              { project.user }
  let(:post) {
    ProjectPost.create!(
      user:    user,
      project: project,
      title:   "title",
      comment: "this is a comment\nhttp://vimeo.com/6944344\nhttp://catarse.me/assets/catarse/logo164x54.png"
    )
  }

  before do
    Sidekiq::Testing.inline!
    ActionMailer::Base.deliveries = []

    expect(ProjectPostNotification).to receive(:notify_once).with(
        :posts,
        contribution.user,
        post,
        {
          from_email: user.email,
          from_name:  user.decorate.display_name
        }
      ).once.and_call_original
  end

  it("should satisfy expectations") { perform_post }
end
