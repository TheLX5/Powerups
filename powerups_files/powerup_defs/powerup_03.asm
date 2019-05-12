;;;;;;;;;
;; fire mario

!fireball_shoot_up		= 1	;If this is set to 1, Mario will be able to shoot upwards the superballs.

!fireball_activate_on_off	= 0	;Set to 1 to enable fireballs be able to active ON/OFF blocks on contact.

!fireball_activate_turn_block	= 0	;Set to 1 to enable fireballs be able to active turn blocks on contact.
					;Set to 2 to enable fireballs be able to break turn blocks on contact.

!fireball_activate_throw_block	= 0	;Set to 1 to enable fireballs be able to break throw blocks on contact.

!fireball_activate_glass_block	= 0	;Set to 1 to enable fireballs be able to active glass blocks on contact.

!fireball_collect_coins		= 0	;Set to 1 to enable fireballs be able to collect coins.

%powerup_number(fire,03,Palette)	;Mandatory macro to get the powerup number.
	;Input: %powerup_number(<define>,<hex_num>)
	;<define>: Prefix of your defines in this file, must be unique.
	;<hex_num>: Actual powerup number, it must not repeat from another powerup
	;     	    And it must not exceed the value in !max_powerup.
	;Output: Various defines
	;!<define>_powerup_num: Complete define name, you could use it for something else
	;		        Its value would be <hex_num>
	;!powerup_<hex_num>: Complete define name, used within the patch in some tables
	;	             Its value will be !<define>_powerup_num
	;And a few other defines with prefix !powerup_<num>_ instead of !<define>_ such as:
	;!powerup_<num>_tile, !powerup_<num>_prop