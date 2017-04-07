class SubscriptionDecorator < Draper::Decorator
  include Draper::LazyHelpers
  delegate_all

  def project_profile_link
    link_to source.project.name, project_path(source.project), class: 'link default'
  end

  def bank_billet_link
    return unless source.bank_billet?

    if source.charge_scheduled_for_today?
      link_to bank_billet_link_text, bank_billet_url, target: '_blank', class: 'link default'
    else
      waiting_for_the_charge_message
    end
  end

  private

  def waiting_for_the_charge_message
    content_tag(:span, I18n.t('projects.subscriptions.show.pending_bank_billet'), class: 'font-secondary')
  end

  def bank_billet_url
    source.current_transaction.bank_billet_url
  end

  def bank_billet_link_text
    I18n.t('projects.subscriptions.show.bank_billet')
  end
end
