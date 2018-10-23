class Player < ApplicationRecord
  belongs_to :team
  has_many :cumulative_games

  def self.years_in_league_between(min, max)
    where("years_in_league >= ?", min).where("years_in_league <= ?", max)
  end

  def self.is_at_least_one(*attributes)
    send_chain(attributes.map{ |pos| ['attribute_true', pos]})
  end

  def self.attribute_true(attribute)
    where(attribute, true)
  end

  def self.age_between(min, max)
  	min_dob = calculate_date_of_birth(min)
  	max_dob = calculate_date_of_birth(max)
  	where('birth_date <= ?', min_dob).where('birth_date >= ?', max_dob)
  end

  private
  def self.calculate_date_of_birth(age)
    Date.today.years_ago(age)
  end

  def self.send_chain(methods)
    methods.each_with_index.inject(self) do |o, (args, index)|
      if index == 0
      	o.send(*args)
      else 	
      	o.or(send(*args))
      end
    end
  end
end
