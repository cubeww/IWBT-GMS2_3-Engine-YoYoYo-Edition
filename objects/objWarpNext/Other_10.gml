/// @description Warp to the next room

if (place_meeting(x,y,objPlayer)) {
	with (objPlayer) {
	    instance_destroy();
	}

	room_goto_next();
}