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

    def testemoip
        api = Moip.new
        api.call
        r = api.order({
            ownId: 'joao123',
            items: [
                {
                product: "Apoio para o projeto de teste",
                quantity: 1,
                detail: "",
                price: 3000
                }
            ],
            customer: {
                fullname: 'João Pinho',
                ownId: 'joaoteste123',
                email: 'joao@joao.com',
                taxDocument: {
                    type: "CPF",
                    number: '10132097702'
                }
            }
        })

        order = JSON.parse r.body
        id = order['id']
        payment = api.payment(id,
            {
                statementDescriptor: 'Juntos.com.vc', 
                fundingInstrument: {  
                    method: 'BOLETO', 
                    boleto: {  
                        expirationDate: (Time.new + 5.days).strftime('%Y-%m-%d'), 
                        instructionLines: {  
                            first: "Boleto referente DOAÇÃO para campanha na juntos.com.vc",
                            second: "Caso perca o prazo de pagamento, você poderá gerar outro boleto",
                            third: "na página da campanha que realizou a doação"
                        },
                        logo_uri: "http://juntos.com.vc/assets/juntos/logo-small.png"
                    }
                }
            })
        p = JSON.parse payment.body
        abort p['id'].inspect
    end
end
