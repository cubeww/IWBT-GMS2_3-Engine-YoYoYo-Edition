/// @description Check collision

// Check if the player is touching and shooting
if (place_meeting(x,y,objPlayer)) {
	if (scrButtonCheckPressed(global.shootButton)) {
	    event_user(0);
	}
}

// Check if a bullet is touching
if (place_meeting(x,y,objBullet)) {
	event_user(0);
}