class SubscriptionDecorator < Draper::Decorator
  include Draper::LazyHelpers
  delegate_all

  def project_profile_link
    link_to source.project.name, project_path(source.project), class: 'link default'
  end

  def bank_billet_link
    return unless source.bank_billet?

    link_to bank_billet_link_text, bank_billet_url, target: '_blank', class: 'link default'
  end

  private

  def bank_billet_url
    source.current_transaction.bank_billet_url
  end

  def bank_billet_link_text
    I18n.t('projects.subscriptions.show.bank_billet')
  end
end
