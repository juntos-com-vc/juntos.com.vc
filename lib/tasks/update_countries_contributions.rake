namespace :contribution do
  desc 'Add country code in contributions according to country_id'
  task add_country_code: :environment do
    countries_in_contribution = Contribution.uniq.pluck(:country_id).compact
    countries_with_code = parser_countries_with_code

    countries_in_contribution.each do |country_id|
      country_name = Country.find(country_id).name
      code = countries_with_code[country_name]
      
      puts "Country: #{country_name}, code: #{code}"
      
      contributions = Contribution.where(country_id: country_id)
      contributions.update_all(country_code: code)
    end
  end

  def parser_countries_with_code
    ISO3166::Country.all_names_with_codes(:pt)
      .inject({}) do |key, value|
        key.merge!({ value[0] => value[1] })
    end
  end
end
