/// @function scrGetMusic()
/// @description Gets and plays which song is supposed to be playing for the current room
function scrGetMusic() {

	var roomSong;

	switch (room) {
	    case rTitle: // Add rooms to this list here (if you have several rooms that play the same song they can be put together)
	    case rMenu:
	    case rOptions:
	    case rDifficultySelect:
	    case rSample01:
		case rSample02:
	        roomSong = musGuyRock;
	        break; // Always put a break after setting the song
		case rEnd:
	        roomSong = -1; // Play nothing
	        break;
	    default: // By default don't play anything in case the room does not have a song set
	        roomSong = -1;
	        break;
	}

	if (roomSong != -2) { // Don't change music if roomSong is set to -2 (this is useful for bosses that you want full control of what song is playing)
	    scrPlayMusic(roomSong,true); // Play the song for the current room
	}
}

/// @function scrPlayMusic(soundID,loops)
/// @description Plays a song (if it's not already playing)
/// @param soundID song to play (-1 plays nothing and stops anything currently playing)
/// @param loops whether or not to loop the song
function scrPlayMusic(songID, loopSong) {

	if (!global.muteMusic) {  // Check if music is currently muted
	    if (global.currentMusicID != songID) { // Check if the song to play is already playing
	        global.currentMusicID = songID;
        
	        audio_stop_sound(global.currentMusic);
        
	        if (songID != -1) {
	            global.currentMusic = audio_play_sound(global.currentMusicID,1,loopSong);
			}
	    }
	}
}

/// @function scrStopMusic()
/// @description Stops any music currently playing
function scrStopMusic() {

	global.currentMusicID = -1;

	audio_stop_sound(global.currentMusic);
}

/// @function scrToggleMusic()
/// @description Toggles the music on and off
function scrToggleMusic() {

	global.muteMusic = !global.muteMusic;

	if (!global.muteMusic) {  // Unmuting music, start playing music
	    if (instance_exists(objPlayer) || !global.gameStarted) {
	        scrGetMusic(); // Find and play the proper music for the current room
	    }
	} else { // Muting music
	    scrStopMusic();
	    audio_stop_sound(global.gameOverMusic);
	}
}

