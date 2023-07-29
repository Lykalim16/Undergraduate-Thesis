/* No moderation */


model Scenario01

global {
	int nb_people <- 4000 update: 4000 - nb_people_dead;
	float agent_speed <- 5.0 #km / #h;
	float step <- 5 #minutes;
	float expose_distance <- 2.0 #m;
	float proba_infection <- 0.50;
	float proba_recover <- 0.80; /* 80% chance of recovering */
	int nb_infected_init <- 5;
	int nb_exposed_init <- 0;
	int nb_recovered_init <- 0;
	int nb_immune_init <- 0; /* immune only if already recovered */
	int nb_dead_init <- 0;
	file roads_shapefile <- file("../includes/road.shp");
	file buildings_shapefile <- file("../includes/building.shp");
	geometry shape <- envelope(buildings_shapefile);
	graph road_network;
	/* Makulit at hours: 9-11am, 3-6pm. At these times, agent has a more chance to leave the building*/
	float staying_coeff update: 10.0 ^ (1 + min([abs(current_date.hour - 9), abs(current_date.hour - 10), abs(current_date.hour - 11), abs(current_date.hour - 15), abs(current_date.hour - 16), abs(current_date.hour - 17), abs(current_date.hour - 18)]));
	list<people_in_building> list_people_in_buildings update: (building accumulate each.people_in_building);
	int nb_people_susceptible <- nb_people - nb_infected_init update: (nb_people - nb_people_infected - nb_people_recovered);
	int nb_people_infected <- nb_infected_init update: (people + list_people_in_buildings) count (each.is_infected);
	int nb_people_not_infected <- nb_people - nb_infected_init update: (nb_people - nb_people_infected);
	int nb_people_exposed <- nb_exposed_init update: (people + list_people_in_buildings) count (each.is_exposed);
	int nb_people_not_exposed <- nb_people - nb_exposed_init update: (nb_people - nb_people_exposed);
	int nb_people_recovered <- nb_recovered_init update: (people + list_people_in_buildings) count (each.is_recovered);
	int nb_people_not_recovered <- nb_people - nb_recovered_init update: (nb_people - nb_people_recovered);
	int nb_people_immune <- nb_immune_init update: (people + list_people_in_buildings) count (each.is_immune);
	int nb_people_not_immune <- nb_people - nb_immune_init update: (nb_people - nb_people_immune);
	int nb_people_dead <- nb_dead_init update: (people + list_people_in_buildings) count (each.is_dead);
	int nb_people_not_dead <- nb_people - nb_dead_init update: (nb_people - nb_people_dead);
	int current_day <- 1 update: current_date.hour = 0 and current_date.minute = 0 ? current_day + 1 : current_day;
	/* night is before 7am and after 8pm */
	bool is_night <- true update: current_date.hour < 7 or current_date.hour > 20;
	float infected_rate update: nb_people_infected / nb_people;
	/* list<int> nb_susceptible <- [3995]; */


	init {
		create road from: roads_shapefile;
		road_network <- as_edge_graph(road);
		create building from: buildings_shapefile;
		create people number: nb_people {
			speed <- agent_speed;
			building bd <- one_of(building);
			location <- any_location_in(bd);
		}

		ask nb_infected_init among people {
			is_infected <- true;
			time_infected <- 0;
			infected_will_recover_or_die <- rnd(2016,2880); /* will recover or die after 7-10 days */
			/* write "Infected at: " + time_infected + ", will recover at " + infected_will_recover_or_die; */
		}
	}

	reflex end_simulation when: infected_rate = 1.0 or (nb_people_infected = 0 and nb_people_exposed = 0) {
		do pause;
	}
	
	reflex print {
		if (current_date.hour = 0 and current_date.minute = 0){
			write "\\hline";
			write " \\ textbf{" + (current_day-1)+ "} & " + nb_people + " & " + nb_people_susceptible + " & " + nb_people_exposed + " & " + nb_people_infected + " & " + nb_people_recovered + " & " + nb_people_dead + " \\\\";
			/* write "Day: " + (current_day-1) + ", P: " + nb_people + ", S: " + nb_people_susceptible + ", I: " + nb_people_infected + ", R: " + nb_people_recovered + ", D: " + nb_people_dead; */
		}
		/* if (current_date.hour = 0 and current_date.minute = 0){
			add nb_people_susceptible to: nb_susceptible;
			write nb_susceptible;
		} */
	}
}

species people skills: [moving] {
	bool is_infected <- false;
	bool is_exposed <- false;
	bool is_recovered <- false;
	bool is_immune <- false;
	bool is_dead <- false;
	int time_exposed <- 0;
	int time_infected <- 0;
	int time_recovered <- 0;
	int time_dead <- 0;
	int exposed_will_be_infected <- 0;
	int infected_will_recover_or_die <- 0;
	point target;
	int staying_counter;
	int expose_counter <- 0;
	
	reflex stay when: target = nil {
		staying_counter <- staying_counter + 1;
		if flip(staying_counter / staying_coeff) {
			target <- any_location_in (one_of(building));
		}
	}

	reflex move when: target != nil {
		do goto target: target on: road_network;
		if (location = target) {
			target <- nil;
			staying_counter <- 0;
		}

	}
	
	reflex expose when: is_infected {
		ask people at_distance expose_distance {
			if (is_dead){
				is_dead <- true;
			}else if (is_immune){
				is_recovered <- true;
				is_infected <- false;
				is_exposed <- false;
			}else if (is_infected){
				is_infected <- true;
				is_exposed <- false;
				is_recovered <- false;
			}else{
				expose_counter <- expose_counter + 1;
				if (expose_counter = 3){ /* Must be exposed for 3 cycles (15 mins) before to be considered as exposed */
					is_exposed <- true;
					is_infected <- false;
					is_recovered <- false;
					time_exposed <- cycle;
					exposed_will_be_infected <- rnd(1440,2880); /* exposed will be infected after 5-10 days */
					/*write "Agent Exposed at cycle " + time_exposed + " and will be infected after " + exposed_will_be_infected + " cycles.";
					write "--------- Infected at: " + (time_exposed + exposed_will_be_infected); */
				}
				if (cycle mod 288 = 0){ /* Reset everyday */
					expose_counter <- 0;
				}
			}
		}
	}
	
	reflex infect when: is_exposed {
		if(is_immune = false and is_recovered = false and is_dead = false){
			if ((cycle - time_exposed) >= exposed_will_be_infected) { /* will determine if infected after 3-10 days of being exposed */ 
				if flip(rnd(0.3,0.8)) {
					/* write "Infected"; */
					is_infected <- true;
					is_exposed <- false;
					is_recovered <- false;
					time_infected <- cycle;
					time_exposed <- 0;
					infected_will_recover_or_die <- rnd(2016,2880); /* will recover or die after 7-10 days */
				}else{
					/* write "Not Infected"; */
					is_infected <- false;
					is_exposed <- false;
					is_recovered <- false;
					is_immune <- false;
					is_dead <- false;
					time_exposed <- 0;
					time_infected <- 0;
					expose_counter <- 0;
				}
			}
		}
	}
	
	reflex recover when: is_infected {
		if((cycle - time_infected) >= infected_will_recover_or_die){ /* if infected for 7-14 days */
			if flip(proba_recover){ /* If agent will recover */
				is_immune <- true;
				is_recovered <- true;
				is_infected <- false;
				is_exposed <- false;
				is_dead <- false;
				time_recovered <- cycle;
			}else{ /* Else, agent will be dead */
				is_dead <- true;
				is_recovered <- false;
				is_immune <- false;
				is_infected <- false;
				is_exposed <- false;
				time_dead <- cycle;
			}
		}
	}

	aspect circle {
		draw circle(1) color: is_exposed ? #orange : (is_infected ? #red : (is_recovered ? #pink : (is_dead ? #black : #blue)));
	}

	aspect sphere3D {
		draw sphere(2) at: {location.x, location.y, location.z + 2} color: is_exposed ? #orange : (is_infected ? #red : (is_recovered ? #pink : (is_dead ? #black : #blue)));
	}

}

species road {
	geometry display_shape <- shape + 2.0;
	aspect default {
		draw display_shape color: #black depth: 3.0;
	}
}

species building {
	int nb_infected <- 0 update: self.people_in_building count each.is_infected;
	int nb_exposed <- 0 update: self.people_in_building count each.is_exposed;
	int nb_recovered <- 0 update: self.people_in_building count each.is_recovered;
	int nb_dead <- 0 update: self.people_in_building count each.is_dead;
	int nb_total <- 0 update: length(self.people_in_building);
	float height <- rnd(10 #m, 20 #m);
	
	species people_in_building parent: people schedules: [] {
	}

	reflex let_people_leave {
		ask people_in_building {
			staying_counter <- staying_counter + 1;
		}

		release people_in_building where (flip(each.staying_counter / staying_coeff)) as: people in: world {
			target <- any_location_in(one_of(building));
		}

	}

	reflex let_people_enter {
		capture (people inside self where (each.target = nil)) as: people_in_building;
	}

	aspect default {
		draw shape color: nb_total = 0 ? #gray : (float(nb_infected) / nb_total > 0.5 ? #red : #green) border: #black depth: height;
	}
}

experiment main_experiment type: gui { /* experiment with a graphical interface */
	parameter "Initial Population" var: nb_people;
	parameter "Exposure distance" var: expose_distance;
	/* parameter "Proba infection" var: proba_infection min: 0.0 max: 1.0; */
	parameter "Nb people infected at init" var: nb_infected_init;
	output {
		monitor "Day" value: current_day;
		monitor "Total Population" value: nb_people;
		monitor "Number of Susceptible" value: nb_people_susceptible;
		monitor "Number of Exposed" value: nb_people_exposed;
		monitor "Number of Infected" value: nb_people_infected; 
		monitor "Number of Recovered" value: nb_people_recovered;
		monitor "Number of Dead" value: nb_people_dead;
		monitor "Current hour" value: current_date.hour;
		monitor "Current minute" value: current_date.minute;
		monitor "Infected people rate" value: infected_rate;
		
		display view3D type: opengl antialias: false {
			light #ambient intensity: 20;
			light #default intensity:(is_night ? 127 : 255); /*  intensity of the light to 127 during the night, and 255 for the day */
			/* image "../includes/soil.jpg" refresh: false;  */
			species road;
			species people aspect: sphere3D;
			species building transparency: 0.3;
		}
		
		display chart_display refresh: every(10 #cycles) {
			chart "Disease spreading" type: series {
				data "susceptible" value: nb_people_susceptible color: #blue marker: false;
				data "exposed" value: nb_people_exposed color: #orange marker: false;
				data "infected" value: nb_people_infected color: #red marker: false;
				data "recovered" value: nb_people_recovered color: #pink marker: false;
				data "dead" value: nb_people_dead color: #black marker: false;
			}
		}
	}

}