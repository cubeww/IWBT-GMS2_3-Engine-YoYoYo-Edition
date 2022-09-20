/// @description Handle player collision

// Check block collision
with (objBlock) {
	if (object_is_ancestor(object_index,objPlatform) || object_index == objPlatform)
		continue;

	with (other) {
		if (place_meeting(x,y,other)) {
			x = xprevious;
			y = yprevious;
	
			// Check for horizontal collisions
			if (!place_free(x+hspeed,y)) {
				if (hspeed <= 0) {
					move_contact_solid(180,abs(hspeed));
			    } else {
					move_contact_solid(0,abs(hspeed));
				}
		
			    hspeed = 0;
			}

			// Check for vertical collisions
			if (!place_free(x,y+vspeed)) {
				if(vspeed <= 0) {
					move_contact_solid(90,abs(vspeed));
		
					if (global.grav == -1) {
						djump = 1;
					}
			    } else {
					move_contact_solid(270,abs(vspeed));
		
					if (global.grav == 1) {
						djump = 1;
					}
				}
	
			    vspeed = 0;
			}

			// Check for diagonal collisions
			if (!place_free(x+hspeed,y+vspeed)) {
				hspeed = 0;
			}
	
			x += hspeed;
			y += vspeed;
		}
	}
}

// Check platform collision
with (objPlatform) {
	with (other) {
		if (place_meeting(x,y,other)) {
			if (global.grav == 1) { // Check if on top of the platform (when right-side up)
			    if (y-vspeed/2 <= other.y) {
			        if (other.vspeed >= 0) {
			            y = other.y-9; // Snap to the platform
			            vspeed = other.vspeed;
			        }
        
			        onPlatform = true;
			        djump = 1;
			    }
			} else { // Check if on top of the platform (when flipped)
			    if (y-vspeed/2 >= other.y+other.sprite_height-1) {
			        if (other.yspeed <= 0) {
			            y = other.y+other.sprite_height+8; // Snap to the platform
			            vspeed = other.yspeed;
			        }
        
			        onPlatform = true;
			        djump = 1;
			    }
			}
		}
	}
}

// Check killer collision
if (place_meeting(x,y,objPlayerKiller)) {
	scrKillPlayer();
}

// Check water collision
with (objWaterParent) {
	event_user(0);
}

// Check save collision
with (objSave) {
	event_user(1);
}

// Check room changer collision
with (objRoomChanger) {
	event_user(0);
}

// Check warp next collision
with (objWarpNext) {
	event_user(0);
}

// Check if player left the room and update player sprite (if set to)
if ((x < 0 || x > room_width || y < 0 || y > room_height) && global.edgeDeath) {
    scrKillPlayer();
}

// Update player sprite
if (PLAYER_ANIMATION_FIX) {
	// Block/vine checks
	var notOnBlock = (place_free(x,y+(global.grav)));
	var onVineR = (place_meeting(x+1,y,objWalljumpR) && notOnBlock);
	var onVineL = (place_meeting(x-1,y,objWalljumpL) && notOnBlock);
	
	if (!onVineR && !onVineL) { // Not touching any vines
		if (onPlatform || !notOnBlock) { // Standing on something
			// Check if moving left/right
			var L = (scrButtonCheck(global.leftButton) || (DIRECTIONAL_TAP_FIX && scrButtonCheckPressed(global.leftButton)));
			var R = (scrButtonCheck(global.rightButton) || (DIRECTIONAL_TAP_FIX && scrButtonCheckPressed(global.rightButton)));
			
			if ((L || R) && !frozen) {
				sprite_index = sprPlayerRun;
				image_speed = 0.5;
			} else {
				sprite_index = sprPlayerIdle;
				image_speed = 0.2;
			}
		} else { // In the air
			if ((vspeed * global.grav) < 0) {
				sprite_index = sprPlayerJump;
				image_speed = 0.5;
			} else {
				sprite_index = sprPlayerFall;
				image_speed = 0.5;
			}
		}
	} else { // Touching a vine
		sprite_index = sprPlayerSlide;
		image_speed = 0.5;
	}
}