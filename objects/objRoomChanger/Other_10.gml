/// @description Warp the player

if (place_meeting(x,y,objPlayer)) {
	if (warpX == 0 && warpY == 0) { // No coordinates set, go to where objPlayerStart is
	    with(objPlayer) {
	        instance_destroy();
		}
	} else { // Coordinates set, move player to them
	    objPlayer.x = warpX;
	    objPlayer.y = warpY;
	}

	room_goto(roomTo);
}