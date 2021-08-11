/// @function scrPlayerJump()
/// @description Makes the player jump
function scrPlayerJump() {

	if (place_meeting(x,y+(global.grav),objBlock) || onPlatform || place_meeting(x,y+(global.grav),objWater)) {
	    // Single jump
		vspeed = -jump;
	    djump = 1;
	    audio_play_sound(sndJump,0,false);
	} else if (djump == 1 || place_meeting(x,y+(global.grav),objWater2) || (global.infJump || global.debugInfJump)) {
	    // Double jump
		vspeed = -jump2;
	    sprite_index = sprPlayerJump;
	    audio_play_sound(sndDJump,0,false);
    
		// Check if touching water3
	    if (!place_meeting(x,y+(global.grav),objWater3)) {
	        djump = 0; // Take away the player's double jump
	    } else {
	        djump = 1; // Replenish double jump if touching water3
		}
	}
}

/// @function scrPlayerVJump()
/// @description Makes the player lose upward vertical momentum
function scrPlayerVJump() {

	if (vspeed * global.grav < 0) {
	    vspeed *= 0.45;
	}
}

/// @function scrPlayerShoot()
/// @description Makes the player shoot a bullet
function scrPlayerShoot() {

	if (instance_number(objBullet) < 4) {
	    instance_create_layer(x,y-(global.grav*2),layer,objBullet);
	    audio_play_sound(sndShoot,0,false);
	}
}

/// @function scrFlipGrav()
/// @description Flips the current gravity
function scrFlipGrav() {

	// Set gravity to go the opposite direction
	global.grav = -global.grav;

	// Flip the player and set his variables accordingly
	with (objPlayer) {
		vspeed = 0;
		djump = 1;
	
		jump = abs(jump) * global.grav;
		jump2 = abs(jump2) * global.grav;
		gravity = abs(gravity) * global.grav;
	
		if (global.grav == 1) {
			mask_index = sprPlayerMask;
		} else {
			mask_index = sprPlayerMaskFlip;
		}
	
		y += 4 * global.grav;
	}
}

/// @function scrKillPlayer()
/// @description Kills the player
function scrKillPlayer() {

	if (instance_exists(objPlayer) && (!global.noDeath && !global.debugNoDeath)) {
	    if (global.gameStarted) {
	        // Normal death
		
			global.deathSound = audio_play_sound(sndDeath,0,false);
        
			// Play death music
	        if (!global.muteMusic) {
	            if (global.deathMusicMode == 1) { // Instantly pause the current music
	                audio_pause_sound(global.currentMusic);
                
	                global.gameOverMusic = audio_play_sound(musOnDeath,1,false);
	            } else if (global.deathMusicMode == 2) { // Fade out the current music
	                with (objWorld) {
	                    event_user(0); // Fade out and stop the current music
					}
                
	                global.gameOverMusic = audio_play_sound(musOnDeath,1,false);
	            }
	        }
        
	        with (objPlayer) {
	            instance_create_layer(x,y,layer,objBloodEmitter);
	            instance_destroy();
	        }
        
	        instance_create_layer(0,0,"World",objGameOver);
        
	        global.deaths++; // Increment death counter
            
	        scrSaveGame(false); // Save deaths/time
	    } else {
	        // Death in the difficulty select room, restart the room
		
			with (objPlayer) {
	            instance_destroy();
			}
            
	        room_restart();
	    }
	}
}
