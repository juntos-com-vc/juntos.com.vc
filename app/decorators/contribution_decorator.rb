class ContributionDecorator < Draper::Decorator
  decorates :contribution
  include Draper::LazyHelpers

  def default_payment_method
    if source.preferred_payment_engine.present?
      "##{source.preferred_payment_engine}"
    elsif source.user.credits > 0
      "#Credits"
    end
  end

  def display_value
    number_to_currency source.localized.value
  end

  def display_project_value
    number_to_currency source.localized.project_value
  end

  def display_platform_value
    number_to_currency source.localized.platform_value
  end

  def display_confirmed_at
    I18n.l(source.confirmed_at.to_date) if source.confirmed_at
  end

  def display_slip_url
    return source.slip_url if source.slip_url.present?
    "https://www.moip.com.br/Boleto.do?id=#{source.payment_id.gsub('.', '').to_i}"
  end

  def user_document
    source.user.cpf.presence || '-'
  end
end
