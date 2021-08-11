/// @description Handle player collision

// Check platform collision
var platform = instance_place(x,y,objPlatform);
if (platform != noone) {
	if (global.grav == 1) { // Check if on top of the platform (when right-side up)
	    if (y-vspeed/2 <= platform.y) {
	        if (platform.vspeed >= 0) {
	            y = platform.y-9; // Snap to the platform
	            vspeed = platform.vspeed;
	        }
        
	        onPlatform = true;
	        djump = 1;
	    }
	} else { // Check if on top of the platform (when flipped)
	    if (y-vspeed/2 >= platform.y+platform.sprite_height-1) {
	        if (platform.yspeed <= 0) {
	            y = platform.y+platform.sprite_height+8; // Snap to the platform
	            vspeed = platform.yspeed;
	        }
        
	        onPlatform = true;
	        djump = 1;
	    }
	}
}

// Check block collision
var block = instance_place(x,y,objBlock);
if (block) {
	if (block.solid) {
		x = xprevious;
		y = yprevious;
	}
	
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
	
	if (block.solid) {
		x += hspeed;
		y += vspeed;
		if (place_meeting(x,y,objBlock)) {
			x = xprevious;
			y = yprevious;
		}
	}
}

// Check killer collision
if (place_meeting(x,y,objPlayerKiller)) {
	scrKillPlayer();
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
			} else {
				sprite_index = sprPlayerIdle;
			}
		} else { // In the air
			if ((vspeed * global.grav) < 0) {
				sprite_index = sprPlayerJump;
			} else {
				sprite_index = sprPlayerFall;
			}
		}
	} else { // Touching a vine
		sprite_index = sprPlayerSlide;
	}
}