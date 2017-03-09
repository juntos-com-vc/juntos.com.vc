require 'rails_helper'

RSpec.describe Project::IndexScope do
  let(:current_user) { create(:user) }
  let(:projects)     { Project.all }
  let(:index_scope)  { Project::IndexScope.new(projects, current_user) }

  describe ".recommends" do
    before do
      allow(Project).to receive(:recommended_for_home).and_return(projects)
      index_scope.recommends
    end

    it "returns the recommended projects" do
      expect(Project).to have_received(:recommended_for_home).once
    end
  end

  describe ".projects_near" do
    context "when the user is persisted" do
      let(:current_user)  { create(:user) }
      let(:projects_near_limit) { 3 }

      before do
        allow(Project).to receive(:random_near_online_with_limit)
                           .with(current_user.address_state, projects_near_limit)
                           .and_return(projects)
        index_scope.projects_near
      end

      it "returns the near projects" do
        expect(Project).to have_received(:random_near_online_with_limit).once
      end
    end

    context "when the user is not persisted" do
      let(:current_user) { nil }

      before do
        allow(Project).to receive(:random_near_online_with_limit)
        index_scope.projects_near
      end

      it "does not return any project" do
        expect(Project).not_to have_received(:random_near_online_with_limit)
      end
    end
  end

  describe ".expiring" do
    before do
      allow(Project).to receive(:expiring_for_home).and_return(projects)
      index_scope.expiring
    end

    it "returns the expiring projects" do
      expect(Project).to have_received(:expiring_for_home).once
    end
  end

  describe ".recent" do
    before do
      allow(Project).to receive(:online_non_recommended_with_limit).and_return(projects)
      index_scope.recent
    end

    it "returns the recent projects" do
      expect(Project).to have_received(:online_non_recommended_with_limit).once
    end
  end

  describe ".featured_partners" do
    before do
      allow(SitePartner).to receive(:featured)
      index_scope.featured_partners
    end

    it "returns the featured partners" do
      expect(SitePartner).to have_received(:featured).once
    end
  end

  describe ".regular_partners" do
    before do
      allow(SitePartner).to receive(:regular)
      index_scope.regular_partners
    end

    it "returns the regular partners" do
      expect(SitePartner).to have_received(:regular).once
    end
  end

  describe ".site_partners" do
    let(:regular_partners)  { create_list(:site_partner, 1, :regular) }
    let(:featured_partners) { create_list(:site_partner, 1, :featured) }

    before do
      allow(SitePartner).to receive(:featured).and_return(featured_partners)
      allow(SitePartner).to receive(:regular).and_return(regular_partners)
      index_scope.site_partners
    end

    it "returns the both regular and featured partners" do
      expect(SitePartner).to have_received(:featured).once
      expect(SitePartner).to have_received(:regular).once
    end
  end

  describe ".channels" do
    let(:visible_channel)   { create(:channel, :visible) }
    let(:invisible_channel) { create(:channel, :invisible) }
    let(:all_channels)      { [visible_channel, invisible_channel] }

    before do
      allow(Channel).to receive(:all).and_return(all_channels)
      allow(Channel).to receive(:visible).and_return(visible_channel)
      index_scope.channels
    end

    context "when the current user is admin" do
      let(:current_user) { create(:user, admin: true) }

      it "returns the both visible and invisible channels" do
        expect(Channel).to have_received(:all).once
      end
    end

    context "when the current user is not admin" do
      let(:current_user) { create(:user, admin: false) }

      it "returns the visible channels only" do
        expect(Channel).to have_received(:visible).once
      end
    end
  end

  describe ".banners" do
    before do
      allow(HomeBanner).to receive(:asc_order_by_numeric_order)
      index_scope.banners
    end

    it "returns the ordered banners by 'numeric_order'" do
      expect(HomeBanner).to have_received(:asc_order_by_numeric_order).once
    end
  end
end
