FactoryBot.define do
	factory :team do
		name "Vancouver Canucks"
		division "Pacific"
	end

	factory :player do
		name "Henrik Sedin"
    	lw false
    	rw false
     	c true
    	d false
    	g false
    	age 34
		association :team
	end

	factory :cumulative_game do
		date Date.new(2001,2,3)
      	home true
      	goals 0
      	assists 0
      	hits 0
      	blocks 0
      	shots 0
      	pim 0
      	ppg 0
      	ppa 0
      	shg 0
      	sha 0
      	gwg 0
      	otg 0
      	plus_minus 0
      	toi 0
      	mss 0
      	gva 0
      	tka 0
      	fow 0
      	fot 0

      	association :player
      	association :team
      	association :opponent_team, factory: :team
	end
end