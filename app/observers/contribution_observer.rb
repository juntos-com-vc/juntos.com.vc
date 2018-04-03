class ContributionObserver < ActiveRecord::Observer
  observe :contribution

  def after_create(contribution)
    contribution.define_key
    PendingContributionWorker.perform_at(2.day.from_now, contribution.id)
  end

  def after_save(contribution)
    if contribution.payment_choice_was.nil? && contribution.payment_choice == 'BoletoBancario'
      contribution.notify_to_contributor(:payment_slip)
    end
  end

  def before_save(contribution)
    # 
    notify_confirmation(contribution) if contribution.confirmed? && contribution.confirmed_at.nil?
  end

  def from_confirmed_to_refunded_and_canceled(contribution)
    # update_summary(contribution, false)
    do_direct_refund(contribution)
  end

  def from_requested_refund_to_refunded(contribution)
    contribution.notify_to_contributor((contribution.slip_payment? ? :refund_completed_slip : :refund_completed))
  end
  alias :from_confirmed_to_refunded :from_requested_refund_to_refunded

  def from_pending_to_invalid_payment(contribution)
    # update_summary(contribution, false)
    contribution.notify_to_backoffice :invalid_payment
  end
  alias :from_waiting_confirmation_to_invalid_payment :from_pending_to_invalid_payment

  def from_confirmed_to_requested_refund(contribution)
    # update_summary(contribution, false)
    contribution.notify_to_backoffice :refund_request, {from_email: contribution.user.email, from_name: contribution.user.name}
    do_direct_refund(contribution)

    unless contribution.is_pagarme?
      template = (contribution.slip_payment? ? :requested_refund_slip : :requested_refund)
      contribution.notify_to_contributor(template)
    end
  end

  def from_confirmed_to_canceled(contribution)
    # update_summary(contribution, false)
    contribution.notify_to_backoffice :contribution_canceled_after_confirmed
    contribution.notify_to_contributor((contribution.slip_payment? ? :contribution_canceled_slip : :contribution_canceled))
  end

  private
  def do_direct_refund(contribution)
    contribution.direct_refund if contribution.can_do_refund?
  end

  def update_summary(contribution, confirmed)
    summary = Summary.site.first
    contributions = summary.contributions
    total = summary.total
    if confirmed
      contributions += 1
      total += contribution.value
    else
      contributions -= 1
      total -= contribution.value
    end
    summary.contributions = contributions
    summary.total = total
    summary.save
  end

  def notify_confirmation(contribution)
    # update_summary(contribution, true)
    project = contribution.project
    if project.ticket_price.present?
      tickets = (contribution.value / project.ticket_price).floor
      if tickets > 0
        logger = Logger.new(STDOUT)
        logger.debug "Teste de log"
        for i in 1..tickets
          tk = contribution.id.to_s + "-" + i.to_s
          logger.debug "Ticket: " + tk
          logger.debug "Projeto: " + project.id.to_s
          logger.debug "Usuario " + contribution.user.id.to_s
          Ticket.create(project_id: project.id, user_id: contribution.user.id, ticket: tk)
        end
      end
    end
    contribution.confirmed_at = Time.now
    contribution.notify_to_contributor(:confirm_contribution)
    if contribution.recurring_contribution_id.nil? &&
       (Time.now > contribution.project.expires_at  + 7.days) &&
       User.where(email: ::CatarseSettings[:email_payments]).present?
      contribution.notify_to_backoffice(:contribution_confirmed_after_project_was_closed)
    end
  end
end
