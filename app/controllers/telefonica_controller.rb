class TelefonicaController < ApplicationController
    before_filter :http_basic_authenticate

    def http_basic_authenticate
        authenticate_or_request_with_http_basic do |username, password|
            username == "telefonica" && password == "UJ7XqbWtHPcCy9df"
        end
    end
    def projects
        channel = Channel::find(24)
        render :json => channel.projects.to_json( :only => [:permalink, :name] )
    end
    def project
        project = Project.by_permalink_and_available(params[:permalink]).first!
        channelId = project.channels.count > 0 ? project.channels.first.id : 0
        if channelId != 24
            render :json => {:error => "not-found"}.to_json, :status => 404
        else
            render :json => {
                name: project.name,
                permalink: project.permalink,
                goal: project.goal.to_f,
                pledged: project.pledged.to_f,
                total_contributions: project.total_contributions.to_i,
                state: project.state,
                about: project.about,
                category: project.category.name_pt,
                expires_at: project.display_expires_at,
                contributions: project.contributions.as_json(),
                rewards: project.rewards.as_json()
            }.to_json
        end
    end
end
