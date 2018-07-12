class TelefonicaController < ApplicationController
    before_filter :http_basic_authenticate

    def http_basic_authenticate
        authenticate_or_request_with_http_basic do |username, password|
            username == "telefonica" && password == "UJ7XqbWtHPcCy9df"
        end
    end
    def channel
        channel = Channel::find(24)
        render json: channel
    end
    def projects
        channel = Channel::find(24)
        render :json => channel.projects.to_json( :only => [:permalink, :name] )
    end
    def project
        project = Project.by_permalink_and_available(params[:permalink]).first!
        # render :json => project.to_json
        render :json => {
            name: project.name,
            permalink: project.permalink,
            goal: project.goal,
            pleged: project.pledged,
            total_contributions: project.total_contributions,
            state: project.state,
            about: project.about,
            category: project.category.name_pt,
            expires_at: project.display_expires_at,
            contributions: project.contributions.select('value, project_value, platform_value, payment_service_fee, state, created_at, confirmed_at, canceled_at, reward_id, anonymous, payment_method, payment_choice, installments, payer_name, payer_email, payer_document, address_street, address_number, address_complement, address_neighbourhood,address_zip_code,address_city,address_state,country_code,address_phone_number'),
            rewards: project.rewards.select('minimum_value,maximum_contributions,description,days_to_delivery')
        }
    end
end
