/// @description Warp the player if they're outside the room

if (place_meeting(x,y,objPlayer)) {
	if (objPlayer.x < 0 || objPlayer.x > room_width || objPlayer.y < 0 || objPlayer.y > room_height) { //Check if player has left the room
		if (!smoothTransition) { // Not using smooth transition, use default warp
			event_inherited();
		} else { // Using smooth transition, wrap the player around the screen then warp
			if (objPlayer.x < 0) {
			    objPlayer.x += room_width;
			} else if (objPlayer.x > room_width) {
			    objPlayer.x -= room_width;
			}
			if (objPlayer.y < 0) {
			    objPlayer.y += room_height;
			} else if (objPlayer.y > room_height) {
			    objPlayer.y -= room_height;
			}
        
			room_goto(roomTo);
		}
	}
}