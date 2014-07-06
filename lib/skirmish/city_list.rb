module Skirmish::CityList

  def self.random_cities(min_population, angle_lat_long)

    @cities = select_us_cities(min_population)
    random_city = @cities[SecureRandom.random_number(@cities.length)]
    citylist = @cities.select do |city|
      (city.latitude - random_city.latitude).abs < angle_lat_long &&
      (city.longitude - random_city.longitude).abs < angle_lat_long
    end
  end

  private

  def knockout_cities(citylist)


  end

  def self.select_us_cities(population_minimum)
    cities = get_country_cities.select do |city|
      city.population.to_i >= population_minimum
    end
  end

  def self.get_country_cities
    @country_cities ||= Cities.cities_in_country('US').values
  end

  def self.select_global_cities(population_minimum)
    # global search not used due to speed issue
    all_countries = Country.all
    all_countries.each do |country|
      country_cities = Cities.cities_in_country(country[1]).values
      cities = country_cities.select { |city| city.population.to_i >= population_minimum }
    end
  end

end
