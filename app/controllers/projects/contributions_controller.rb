class Projects::ContributionsController < ApplicationController
  inherit_resources
  actions :index, :show, :new, :update, :review, :create
  skip_before_filter :verify_authenticity_token, only: [:moip]
  has_scope :available_to_count, type: :boolean
  has_scope :with_state
  #has_scope :page, default: 1
  after_filter :verify_authorized, except: [:index, :boleto, :moipwebhook]
  belongs_to :project
  before_action :detect_old_browsers, only: [:new, :create]
  before_action :load_channel, only: [:edit, :new]
  before_action :set_country_payment_engine
  before_action :project_is_online?, only: [:new, :create]
  before_action :project_accepts_contributions?, only: [:new, :create]
  helper_method :avaiable_payment_engines

  def edit
    authorize resource
    @payment_engines = avaiable_payment_engines
    @countries = ISO3166::Country.all_names_with_codes(I18n.locale)

    if resource.reward.try(:sold_out?)
      flash[:alert] = t('.reward_sold_out')
      return redirect_to new_project_contribution_path(@project)
    end
  end

  def update
    authorize resource
    resource.update_attributes(permitted_params[:contribution])
    resource.update_user_billing_info

    if @project.recurring?
      RecurringPaymentService.perform(resource.recurring_contribution.id,
                                      resource, params[:payment_card_hash])

      redirect_to obrigado_path(contribution: resource.id)
      return
    end

    render json: {message: 'updated'}
  end

  def index
    render collection
  end

  def show
    authorize resource
    @title = t('projects.contributions.show.title')
  end

  def boleto
    contribution = Contribution.find(params[:contribution])
    project = contribution.project
    user = contribution.user
    api = Moip.new.call
    phone = contribution.address_phone_number[4..-1]
    ddd = contribution.address_phone_number[1,2]
    phone.sub! '-', ''
    # TODO - CREATE ORDER

    api = Moip.new
    api.call
    document_type = contribution.payer_document.length > 11 ? "CNPJ" : "CPF"
    zip = contribution.address_zip_code.sub! '-', ''
    r = api.order({
      ownId: contribution.id,
      items: [
        {
          product: "Apoio para o projeto " + project.name,
          quantity: 1,
          detail: "",
          price: Integer(contribution.value*100)
        }
      ],
      customer: {
        fullname: contribution.payer_name,
        ownId: contribution.user_id,
        email: contribution.payer_email,
        taxDocument: {
          type: document_type,
          number: contribution.payer_document
        },
        shippingAddress: {
          city: contribution.address_city,
          district: contribution.address_neighbourhood,
          street: contribution.address_street,
          streetNumber: contribution.address_number,
          zipCode: zip,
          state: contribution.address_state,
          country: "BRA"
        }
      }
    })

    order = JSON.parse r.body
    id = order['id']
    payment = api.payment(id,
      {
        fundingInstrument: {
          method: "BOLETO",
          boleto: {
            expirationDate: (Time.new + 5.days).strftime('%Y-%m-%d'),
            instructionLines: {
              first: "Boleto referente DOAÇÃO para campanha na juntos.com.vc",
              second: "Caso perca o prazo de pagamento, você poderá gerar outro boleto",
              third: "na página da campanha que realizou a doação"
              },
            logoUri: "http://juntos.com.vc/assets/juntos/logo-small.png"
          }
        }
      }
    )
    p = JSON.parse payment.body
    link = p['_links']['payBoleto']['printHref']
    contribution.payment_choice = 'BoletoBancario'
    contribution.payment_method = 'MoIP'
    contribution.payment_token = p['id']
    contribution.payment_id = p['id']
    contribution.state = 'waiting_confirmation'
    contribution.save
    # Atualizar no banco de dados com informações do moip
    render :json => {
      url: link,
    }.to_json
  end

  def moipwebhook
    # tk = params[:token]
    rs = params[:resource]
    payment = rs[:payment]
    id = payment[:id]
    status = payment[:status]
    st = 'fora'
    if status == 'AUTHORIZED'
      st = 'entrou no token'
      contribution = Contribution.where(payment_token: id).first()
      if contribution.state == 'waiting_confirmation'
        st = 'entrou no status'
        contribution.state = 'confirmed'
        contribution.save
      end
    end
    render :json => {
      status: st,
      # id: id
    }.to_json
  end

  def new
    @create_url = project_contributions_url(@project, project_contribution_url_options)

    @contribution = Contribution.new(project: parent, user: current_user)
    authorize @contribution

    @title = t('projects.contributions.new.title', name: @project.name)
    load_rewards

    # Select
    if params[:reward_id] && (@selected_reward = @project.rewards.find params[:reward_id]) && !@selected_reward.sold_out?
      @contribution.reward = @selected_reward
      @contribution.project_value = "%0.0f" % @selected_reward.minimum_value
    end
  end

  def create
    Contribution.transaction do
      @title = t('projects.contributions.create.title')
      @contribution = parent.contributions.new.localized
      @contribution.user = current_user
      @contribution.project_value = permitted_params[:contribution][:project_value]
      @contribution.platform_value = permitted_params[:contribution][:platform_value]
      @contribution.preferred_payment_engine = permitted_params[:contribution][:preferred_payment_engine]
      @contribution.reward_id = (params[:contribution][:reward_id].to_i == 0 ? nil : params[:contribution][:reward_id])
      authorize @contribution
      @contribution.update_current_billing_info
      create! do |success,failure|
        failure.html do
          flash[:alert] = resource.errors.full_messages.to_sentence
          load_rewards
          render :new
        end
        success.html do
          if @project.recurring?
            CreateRecurringContribution.new(@contribution).call
          end

          flash[:notice] = nil
          session[:thank_you_contribution_id] = @contribution.id
          session[:new_contribution] = true;
          return redirect_to edit_project_contribution_path(project_id: @project.id, id: @contribution.id)
        end
      end
      @thank_you_id = @project.id
    end
  end

  protected

  def project_is_online?
    unless parent.online?
      flash[:notice] = t('projects.contributions.warnings.project_must_be_online')
      redirect_to root_path
    end
  end

  def project_accepts_contributions?
    unless parent.accept_contributions?
      flash[:notice] = t('projects.contributions.warnings.project_does_not_accept_contributions')
      redirect_to project_path(parent)
    end
  end

  def load_channel
    @channel = parent.channels.first
  end

  def load_rewards
    empty_reward = Reward.new(minimum_value: 0, description: t('projects.contributions.new.no_reward'))
    @rewards = [empty_reward] + @project.rewards.remaining.order(:minimum_value)
  end

  def permitted_params
    params.permit(policy(resource).permitted_attributes)
  end

  def avaiable_payment_engines
    engines = []

    if resource.value < 5
      engines.push PaymentEngines.find_engine('Credits')
    else
      if parent.using_pagarme?
        engines.push PaymentEngines.find_engine('Pagarme')
      else
        engines = PaymentEngines.engines.inject([]) do |total, item|
          if item.name == 'Credits' && current_user.credits > 0
            total << item
          elsif !item.name.match(/(Credits|Pagarme)/)
            total << item
          end

          total
        end
      end
    end

    @engines ||= engines
  end

  def collection
    if params[:with_state]
      @contributions ||= apply_scopes(end_of_association_chain).available_to_display.order("confirmed_at DESC")
    else
      @contributions ||= apply_scopes(end_of_association_chain).available_to_display.available_to_count.order("confirmed_at DESC")
    end
  end

  def use_catarse_boostrap
    ["new", "create", "edit", "update"].include?(action_name) ? 'juntos_bootstrap' : 'application'
  end

  def project_contribution_url_options
    { protocol: params[:protocol], host: params[:host] }
  end
end
