/obj/structure/ms13/ore_deposit
	name = "base ore deposit"
	desc = "Full of valuable errors to sell to coders!"
	icon = 'mojave/icons/structure/deposits.dmi'
	icon_state = ""
	density = FALSE
	anchored = TRUE
	resistance_flags = UNACIDABLE | FIRE_PROOF | LAVA_PROOF
	armor = list(MELEE = 20, BULLET = 90, LASER = 90, ENERGY = 90, BOMB = 0, BIO = 100, FIRE = 100, ACID = 100)
	hitted_sound = 'sound/effects/break_stone.ogg'
	var/deposit_type = null
	var/last_act = 0
	var/mining_bonus_damage = 0

//Ore deposit mining process

/obj/structure/ms13/ore_deposit/attackby(obj/item/W, mob/user)
	src.mining_bonus_damage = W.force * W.mining_mult
	W.force += mining_bonus_damage
	. = ..()
	W.force -= mining_bonus_damage
	if(W.mining_mult <= 0)
		to_chat(user, span_notice("You could probably use something better than a [W.name] for this."))
	if(W.mining_mult > 0)
		to_chat(user, span_notice("The [src.name] crumbles under your [W.name]!"))

/obj/structure/ms13/ore_deposit/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		if(!disassembled)
			new deposit_type(src.loc, rand(2,5))
	qdel(src)

//deposits

//randomises integrity for deposits

/obj/structure/ms13/ore_deposit/Initialize()
	. = ..()
	max_integrity = rand(380, 525)
	atom_integrity = max_integrity

/obj/structure/ms13/ore_deposit/copper
	name = "copper ore deposit"
	desc = "Full of copper ore, useful!"
	icon_state = "copper-deposit"
	deposit_type = /obj/item/stack/sheet/ms13/nugget/nugget_copper

/obj/structure/ms13/ore_deposit/lead
	name = "lead ore deposit"
	desc = "Full of lead ore, tasty!"
	icon_state = "lead-deposit"
	deposit_type = /obj/item/stack/sheet/ms13/nugget/nugget_lead

/obj/structure/ms13/ore_deposit/alu
	name = "aluminium ore deposit"
	desc = "Full of lead ore, lightweight!"
	icon_state = "aluminium-deposit"
	deposit_type = /obj/item/stack/sheet/ms13/nugget/nugget_alu

/obj/structure/ms13/ore_deposit/silver
	name = "silver ore desposit"
	desc = "Full of silver, shiny!"
	icon_state = "silver-deposit"
	deposit_type = /obj/item/stack/sheet/ms13/nugget/nugget_silver

/obj/structure/ms13/ore_deposit/gold
	name = "gold ore deposit"
	desc = "Full of gold, valuable!"
	icon_state = "gold-deposit"
	deposit_type = /obj/item/stack/sheet/ms13/nugget/nugget_gold

/obj/structure/ms13/ore_deposit/coal
	name = "coal deposit"
	desc = "Full of coal, flammable!"
	icon_state = "coal-deposit"
	deposit_type = /obj/item/stack/sheet/ms13/nugget/nugget_coal

/obj/structure/ms13/ore_deposit/coal/attackby(obj/item/W, mob/user)
	. = ..()
	var/turf/my_turf = get_turf(src)
	my_turf.VapourTurf(/datum/vapours/carbon_air_vapour, 50)

/obj/structure/ms13/ore_deposit/uranium
	name = "uranium deposit"
	desc = "Full of uranium, warm!"
	icon_state = "uranium-deposit"
	deposit_type = /obj/item/stack/sheet/ms13/nugget/nugget_uranium

/obj/structure/ms13/ore_deposit/iron
	name = "iron deposit"
	desc = "Full of iron, tough!"
	icon_state = "iron-deposit"
	deposit_type = /obj/item/stack/sheet/ms13/nugget/nugget_iron

/obj/structure/ms13/ore_deposit/zinc
	name = "zinc deposit"
	desc = "Full of zinc, not silver!"
	icon_state = "brass-deposit"
	deposit_type = /obj/item/stack/sheet/ms13/nugget/nugget_zinc

/obj/structure/ms13/ore_deposit/sulfur
	name = "sulfur deposit"
	desc = "A sulfur vent in recovery! Break this apart if you wish to sully your income!"
	icon_state = "sulfur-deposit"
	deposit_type = /obj/item/stack/sheet/ms13/nugget/sulfur
	var/sulfur_rate // Restock rate for sulfur. Transfers to new spawns, so the vent will always be just as reliable or shart as it always was
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF // Think of this thing as being part of the floor below it. It's a vent- breaking it outright would be dumb.

/obj/structure/ms13/ore_deposit/sulfur/Initialize()
	. = ..()
	sulfur_rate = rand(1,5) // Anywhere from a 1 to 5 multiplier on regrow time / fumes
	addtimer(CALLBACK(src, .proc/growup), 20 MINUTES / sulfur_rate) // Shart tier takes 20 minutes to regen. top dawgs come back in 4.
	AddElement(/datum/element/vapour_emitter, /datum/vapours/sulfur_concentrate, 50 * sulfur_rate) // Less it built up make this thing really shart yellow. Be wary of these fellas.

/obj/structure/ms13/ore_deposit/sulfur/examine(mob/user)
	. = ..()
	switch(sulfur_rate)
		if(5)
			. += span_nicegreen("She's flowin' great! Won't take long to build up at all.")
		if(4)
			. += span_green("Flow's pretty alright...")
		if(3)
			. += span_notice("This vent is completely average.")
		if(2)
			. += span_alert("Sputtering and inconsistent.")
		if(1)
			. += span_red("Barely makin' a toot. Ain't worth a god damn dollar.")


/obj/structure/ms13/ore_deposit/sulfur/proc/growup()
	var/obj/structure/ms13/ore_deposit/sulfur/growth/GU = new /obj/structure/ms13/ore_deposit/sulfur/growth(loc, 1)
	GU.sulfur_rate = src.sulfur_rate
	qdel(src)

/obj/structure/ms13/ore_deposit/sulfur/take_damage(damage_amount, damage_type, damage_flag, sound_effect, attack_dir, armour_penetration, def_zone)
	. = ..()
	var/turf/my_turf = get_turf(src)
	my_turf.VapourTurf(/datum/vapours/sulfur_concentrate, 25) // Kick a bit more in the air per hit for good measure

/obj/structure/ms13/ore_deposit/sulfur/growth
	name = "sulfur growth"
	desc = "A sulfur vent that actively bellows fumes. Try not to collapse the tunnel. Don't breathe too deep!"
	icon_state = "sulfur-growth"
	deposit_type = /obj/item/stack/sheet/ms13/nugget/sulfur
	resistance_flags = null

/obj/structure/ms13/ore_deposit/sulfur/growth/Initialize()
	. = ..()
	AddElement(/datum/element/vapour_emitter, /datum/vapours/sulfur_concentrate, 35 * sulfur_rate)

/obj/structure/ms13/ore_deposit/sulfur/growth/deconstruct(disassembled = TRUE)
	var/obj/structure/ms13/ore_deposit/sulfur/G = new /obj/structure/ms13/ore_deposit/sulfur(loc, 1)
	G.sulfur_rate = src.sulfur_rate
	return ..()

/obj/structure/ms13/ore_deposit/sulfur/growth/examine(mob/user)
	. = ..()
	. += span_yellowteamradio("Payday! Time to mine!")

//Nuggets

/obj/item/stack/sheet/ms13/nugget
	name = "base type nugget"
	desc = "Full of BUGS! You shouldn't be seeing this."
	icon = 'mojave/icons/objects/crafting/materials_inventory.dmi'
	w_class = WEIGHT_CLASS_TINY
	grid_height = 32
	grid_width = 32
	amount = 1
	max_amount = 8

/obj/item/stack/sheet/ms13/nugget/Initialize()
	. = ..()
	AddElement(/datum/element/item_scaling, 0.45, 1)

/obj/item/stack/sheet/ms13/nugget/nugget_zinc
	name = "zinc nuggets"
	desc = "A hard lump of zinc, Useless now."
	singular_name = "zinc nugget"
	icon_state = "brass"
	merge_type = /obj/item/stack/sheet/ms13/nugget/nugget_zinc

/obj/item/stack/sheet/ms13/nugget/nugget_zinc/two
	amount = 2

/obj/item/stack/sheet/ms13/nugget/nugget_iron
	name = "iron ore nuggets"
	desc = "A hard lump of iron, Useless now."
	singular_name = "iron ore nugget"
	icon_state = "iron"
	merge_type = /obj/item/stack/sheet/ms13/nugget/nugget_iron

/obj/item/stack/sheet/ms13/nugget/nugget_iron/two
	amount = 2

/obj/item/stack/sheet/ms13/nugget/nugget_uranium
	name = "pitchblende nuggets"
	desc = "A hard lump of uranium, Useless now."
	singular_name = "pitchblende nugget"
	icon_state = "uranium"
	merge_type = /obj/item/stack/sheet/ms13/nugget/nugget_uranium

/obj/item/stack/sheet/ms13/nugget/nugget_uranium/two
	amount = 2

/obj/item/stack/sheet/ms13/nugget/nugget_coal
	name = "coal chunks"
	desc = "A hard lump of coal, careful with any flames."
	singular_name = "coal chunk"
	icon_state = "coal"
	merge_type = /obj/item/stack/sheet/ms13/nugget/nugget_coal

/obj/item/stack/sheet/ms13/nugget/nugget_coal/two
	amount = 2

/obj/item/stack/sheet/ms13/nugget/nugget_copper
	name = "copper ore nuggets"
	desc = "Full of potential copper. Useless now."
	singular_name = "copper ore nugget"
	icon_state = "copper"
	merge_type = /obj/item/stack/sheet/ms13/nugget/nugget_copper

/obj/item/stack/sheet/ms13/nugget/nugget_copper/two
	amount = 2

/obj/item/stack/sheet/ms13/nugget/nugget_lead
	name = "lead ore nuggets"
	desc = "Full of potential lead. Useless now."
	singular_name = "lead ore nugget"
	icon_state = "lead"
	merge_type = /obj/item/stack/sheet/ms13/nugget/nugget_lead

/obj/item/stack/sheet/ms13/nugget/nugget_lead/two
	amount = 2

/obj/item/stack/sheet/ms13/nugget/nugget_alu
	name = "aluminium ore nuggets"
	desc = "Full of potential aluminium. Useless now."
	singular_name = "aluminium ore nugget"
	icon_state = "aluminium"
	merge_type = /obj/item/stack/sheet/ms13/nugget/nugget_alu

/obj/item/stack/sheet/ms13/nugget/nugget_alu/two
	amount = 2

/obj/item/stack/sheet/ms13/nugget/nugget_silver
	name = "silver ore nuggets"
	desc = "Full of potential silver. Useless now."
	singular_name = "silver ore nugget"
	icon_state = "silver"
	merge_type = /obj/item/stack/sheet/ms13/nugget/nugget_silver

/obj/item/stack/sheet/ms13/nugget/nugget_silver/two
	amount = 2

/obj/item/stack/sheet/ms13/nugget/nugget_gold
	name = "gold ore nuggets"
	desc = "Full of potential gold. Useless now."
	singular_name = "gold ore nugget"
	icon_state = "gold"
	merge_type = /obj/item/stack/sheet/ms13/nugget/nugget_gold

/obj/item/stack/sheet/ms13/nugget/nugget_gold/two
	amount = 2

/obj/item/stack/sheet/ms13/nugget/sulfur
	name = "sulfur ore"
	desc = "Yellow rocks full of valuable sulfur."
	singular_name = "sulfure ore chunk"
	icon_state = "sulfur"
	merge_type = /obj/item/stack/sheet/ms13/nugget/sulfur

/obj/item/stack/sheet/ms13/nugget/sulfur/two
	amount = 2

//Deposit generation

//currently not spawning in uranium deposits as there is no use for them
#define DEPOSIT_SPAWN_LIST_DROUGHT list(/obj/structure/ms13/ore_deposit/gold = 1, /obj/structure/ms13/ore_deposit/silver = 3, /obj/structure/ms13/ore_deposit/alu = 4, /obj/structure/ms13/ore_deposit/lead = 5, /obj/structure/ms13/ore_deposit/copper = 5, /obj/structure/ms13/ore_deposit/coal = 4, /obj/structure/ms13/ore_deposit/iron = 4, /obj/structure/ms13/ore_deposit/zinc = 4, /obj/structure/ms13/ore_deposit/sulfur/growth = 3) //The total sum of this right now is 33, so finding prob is X/33. If you change these numbers please update this comment.
#define DEPOSIT_SPAWN_CHANCE_DROUGHT	2.8

#define DEPOSIT_SPAWN_LIST_MAMMOTH list(/obj/structure/ms13/ore_deposit/gold = 2, /obj/structure/ms13/ore_deposit/silver = 4, /obj/structure/ms13/ore_deposit/alu = 3, /obj/structure/ms13/ore_deposit/lead = 3, /obj/structure/ms13/ore_deposit/copper = 5, /obj/structure/ms13/ore_deposit/coal = 4, /obj/structure/ms13/ore_deposit/iron = 4, /obj/structure/ms13/ore_deposit/zinc = 5, /obj/structure/ms13/ore_deposit/sulfur/growth = 3) //The total sum of this right now is 33, so finding prob is X/33. If you change these numbers please update this comment.
#define DEPOSIT_SPAWN_CHANCE_MAMMOTH	2.5

/turf/open/floor/plating/ms13/ground/mountain/Initialize()
	. = ..()
	var/randDeposit = null
	//spontaneously spawn deposits
	if( (locate(/obj/machinery) in src) || (locate(/obj/structure) in src) ) //can't put ores on a tile that has already has stuff
		return
	if(prob(DEPOSIT_SPAWN_CHANCE_MAMMOTH))
		randDeposit = pick_weight(DEPOSIT_SPAWN_LIST_MAMMOTH) //Create a new deposit object at this location, and assign var
		new randDeposit(src)
		. = TRUE //in case we ever need this to return if we spawned
		return .

/turf/open/floor/plating/ms13/ground/mountain/drought/Initialize()
	. = ..()
	var/randDeposit = null
	if( (locate(/obj/machinery) in src) || (locate(/obj/structure) in src) )
		return
	if(prob(DEPOSIT_SPAWN_CHANCE_DROUGHT))
		randDeposit = pick_weight(DEPOSIT_SPAWN_LIST_DROUGHT)
		new randDeposit(src)
		. = TRUE
		return .
