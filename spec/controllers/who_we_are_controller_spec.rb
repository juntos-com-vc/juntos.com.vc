require 'rails_helper'

RSpec.describe WhoWeAreController, type: :controller do
  subject { response }

  describe 'GET show' do
    let!(:team_member) { create :user, staffs: [0] }
    let!(:financial_member) { create :user, staffs: [1] }
    let!(:technical_member) { create :user, staffs: [2] }
    let!(:advice_member) { create :user, staffs: [3] }

    let!(:who_we_are) { create :page, name: :who_we_are, locale: :pt }
    let!(:mission) { create :page, name: :mission, locale: :pt }
    let!(:values) { create :page, name: :values, locale: :pt }
    let!(:vision) { create :page, name: :vision, locale: :pt }
    let!(:goals) { create :page, name: :goals, locale: :pt }

    let!(:report) { create :transparency_report }

    before { get :show, id: :who_we_are, locale: :pt }

    it { is_expected.to be_successful }
    it { is_expected.to render_with_layout :juntos_bootstrap }
    it { is_expected.to render_template :show }
    
    describe 'page assignments' do
      it 'correctly assigns page information' do
        expect(assigns :page).to eq who_we_are
      end

      it 'correctly assigns mission content' do
        expect(assigns :mission).to eq mission
      end

      it 'correctly assigns values content' do
        expect(assigns :values).to eq values
      end

      it 'correctly assigns vision content' do
        expect(assigns :vision).to eq vision
      end

      it 'correctly assigns goals content' do
        expect(assigns :goals).to eq goals
      end

      it 'assigns the last transparency report' do
        expect(assigns :transparency_report).to eq report
      end
    end

    describe 'staff assignments' do
      it 'assigns team members' do
        expect(assigns :team).to eq [team_member]
      end

      it 'assigns financial board members' do
        expect(assigns :financial_board).to eq [financial_member]
      end

      it 'assigns technical board members' do
        expect(assigns :technical_board).to eq [technical_member]
      end

      it 'assigns advice board members' do
        expect(assigns :advice_board).to eq [advice_member]
      end
    end
  end
end
