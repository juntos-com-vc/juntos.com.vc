RSpec.shared_examples 'when no hooks are triggered on new and create methods' do
  it 'should return a success response code on get new request' do
    get :new, { locale: :pt, project_id: project.id }.merge(ssl_options)
    expect(response.code).to eq '200'
  end

  it 'should redirect to edit project contribution page on post create request' do
    post :create, { locale: :pt, project_id: project.id,
                    contribution: attributes_for(:contribution) }.merge(ssl_options)
    is_expected.to redirect_to edit_project_contribution_path(project_id: project.id,
                                                              id: project.contributions.first.id)
  end
end

RSpec.shared_examples 'when a flash notice is raised because the project state is not online' do
  it { expect(flash[:notice]).to match I18n.t('projects.contributions.warnings.project_must_be_online') }
end

RSpec.shared_examples 'when a flash notice is raised because the project is unavailable for contributions' do
  it { expect(flash[:notice]).to match I18n.t('projects.contributions.warnings.project_does_not_accept_contributions') }
end
