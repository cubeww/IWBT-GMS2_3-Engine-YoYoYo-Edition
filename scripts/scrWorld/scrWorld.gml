/// @function scrInitEngineOptions()
/// @description Sets configurable engine options
function scrInitEngineOptions() {

	// Set global engine options that can be changed mid-game

	global.debugMode = false; // Enables debug keys (check objWorld step event to see all of them), make sure to set this to "false" before releasing your game
	global.debugVisuals = true; // Enables changing the color/alpha of the player when inf jump/god mode are toggled, make sure to disable this if you want to change the player's image_alpha or image_blend
	global.debugOverlay = false; // Enables showing the debug text overlay (shows player location, align, etc.)
	global.debugNoDeath = false; // Enables debug god mode (toggle with Home key)
	global.debugInfJump = false; // Enables debug infinite jump (toggle with End key)
	global.debugShowHitbox = false; // Enables showing the player's hitbox (toggle with Del key)

	global.windowCaptionDef = "I Wanna Be The GMS2_3 Engine YoYoYo Edition v0.9"; // Sets the default window caption
	window_set_caption(global.windowCaptionDef);

	global.startRoom = rSample01; // Sets which room for the game to begin with

	global.deathMusicMode = 0; // Sets whether or not to play death music when the player dies (0 = no death music, 1 = death music and instantly pause current music, 2 = death music and fade out current music)
	global.adAlign = false; // Sets whether or not to enable A/D align
	global.edgeDeath = true; // Sets whether to kill the player when he leaves the boundaries of the room

	// Set global engine options that stay constant

	#macro MD5_STR_ADD "Put something here!" // Sets what to add to the end of md5 input string to make saves harder to hack, should be set to something unique and hard to predict (similar to setting a password)

	#macro DIFFICULTY_MENU_MODE 1 // Sets whether to use a warp room or a menu for selecting the game's difficulty (0 = warp room, 1 = menu)
	#macro MENU_SOUND sndJump // Sets what sound to use for navigating the main menu
	#macro TIME_WHEN_DEAD true // Sets whether or not to count the in-game timer when the player is dead
	#macro PAUSE_DELAY_LENGTH 25 // Sets the delay in frames in which the player can pause/unpause the game to prevent pause buffer strats (can be set to 0 to disable pause delay)
	#macro DIRECTIONAL_TAP_FIX false // Sets whether to change the behavior of tapping left/right for less than 1 frame (by default the player does not move when this happens, enabling this always moves the player for 1 frame when left/right is tapped)
	#macro PLAYER_ANIMATION_FIX false // Sets whether to fix the weird player animation inconsistencies when moving around

	#macro SECRET_ITEM_TOTAL 8 // Sets how many secret items for the game to save/load
	#macro BOSS_ITEM_TOTAL 8 // Sets how many boss items for the game to save/load
	#macro AUTOSAVE_SECRET_ITEMS false // Sets whether to save secret items immediately when you grab them or if you have to hit a save afterward

	#macro CONTROLLER_ENABLED true // Sets whether controllers are supported
	#macro CONTROLLER_DELAY_LENGTH 5 // Sets the delay in frames in which the player can switch between keyboard/controller (can be set to 0 to disable delay)

	#macro NO_FILE_SELECT_MODE false // Enables mode that skips any menus and immediately starts a new game

}

/// @function scrInitGlobals()
/// @description Initializes all global variables needed for the game
function scrInitGlobals() {

	scrInitEngineOptions(); // Initialize engine options

	// Initialize basic game variables

	global.saveNum = 1;
	global.difficulty = 0; // 0 = medium, 1 = hard, 2 = very hard, 3 = impossible
	global.deaths = 0;
	global.time = 0;
	global.timeMicro = 0;
	global.saveRoom = "";
	global.savePlayerX = 0;
	global.savePlayerY = 0;
	global.grav = 1;
	global.saveGrav = 1;

	global.secretItem = array_create(SECRET_ITEM_TOTAL,false);
	global.saveSecretItem = array_create(SECRET_ITEM_TOTAL,false);

	global.bossItem = array_create(BOSS_ITEM_TOTAL,false);
	global.saveBossItem = array_create(BOSS_ITEM_TOTAL,false);

	global.gameClear = false;
	global.saveGameClear = false;

	global.trigger = array_create(50,false);

	global.gameStarted = false; // Determines whether the game is currently in progress (enables saving, restarting, etc.)
	global.noPause = false; // Sets whether or not to allow pausing (useful for bosses to prevent desync)
	global.autosave = false; // Keeps track of whether or not to autosave the game the next time the player is created
	global.noDeath = false; // Keeps track of whether to give the player god mode
	global.infJump = false; // Keeps track of whether to give the player infinite jump

	global.gamePaused = false; // Keeps track of whether the game is paused or not
	global.pauseSpr = -1; // Copies the application surface when the game is paused
	global.pauseDelay = 0; // Sets a pause delay so that the player can't quickly pause/unpause to prevent pause buffer strats

	global.currentMusicID = -1; // Keeps track of what song the current main music is
	global.currentMusic = -1; // Keeps track of the current main music instance
	global.deathSound = -1; // Keeps track of the death sound when the player dies
	global.gameOverMusic = -1; // Keeps track of the game over music instance
	global.musicFading = false; // Keeps track of whether the main music is currently fading out
	global.currentGain = 0; // Keeps track of the current main music gain before a song is faded out

	global.menuSelectPrev[0] = 0; // Keeps track of the previously selected option when navigating away from the difficulty menu
	global.menuSelectPrev[1] = 0; // Keeps track of the previously selected option when navigating away from the options menu

	display_set_gui_size(surface_get_width(application_surface),surface_get_height(application_surface)); // Set the correct GUI size for the Draw GUI event

	global.controllerMode = false; // Keeps track of whether to use keyboard or controller for inputs
	global.controllerDelay = -1; // Handles delay for switching between keyboard/controller so that the player can't use both at the same time

	randomize(); // Make sure the game starts with a random seed for RNG


}

/// @function scrSetWindowCaption()
/// @description Sets the current window caption
function scrSetWindowCaption() {

	var windowCaption = global.windowCaptionDef;

	if (global.gameStarted) {
	    var t = global.time;
	    var timeStr = string(t div 3600) + ":";
	    t = t mod 3600;
	    timeStr += string(t div 600);
	    t = t mod 600;
	    timeStr += string(t div 60) + ":";
	    t = t mod 60;
	    timeStr += string(t div 10);
	    t = t mod 10;
	    timeStr += string(floor(t));
	
		windowCaption += " - Deaths: " + string(global.deaths) + " Time: " + timeStr;
	}

	if (windowCaption != window_get_caption()) { // Only update the caption when it changes
	    window_set_caption(windowCaption);
	}
}

/// @function scrGetControllerStr(buttonIndex)
/// @description Gets a string of what the input button is
/// @param buttonIndex input button constant (i.e. gp_face1, gp_start)
function scrGetControllerStr(buttonIn) {

	switch (buttonIn) {
	    case gp_face1: return "A/Cross";
	    case gp_face2: return "B/Circle";
	    case gp_face3: return "X/Square";
	    case gp_face4: return "Y/Triangle";
	    case gp_shoulderl: return "Left Bumper";
	    case gp_shoulderlb: return "Left Trigger";
	    case gp_shoulderr: return "Right Bumper";
	    case gp_shoulderrb: return "Right Trigger";
	    case gp_select: return "Select/Touch-Pad";
	    case gp_start: return "Start/Options";
	    case gp_stickl: return "Left Stick (pressed)";
	    case gp_stickr: return "Right Stick (pressed)";
	    case gp_padu: return "D-Pad Up";
	    case gp_padd: return "D-Pad Down";
	    case gp_padl: return "D-Pad Left";
	    case gp_padr: return "D-Pad Right";
	    default: return "Unknown";
	}
}

/// @function scrGetKeyStr(key)
/// @description Gets a string of what the input keybind is
/// @param key input key
function scrGetKeyStr(keyIn) {

	switch(keyIn) {
	    // Special keys
	    case vk_space: return "Space";
	    case vk_shift: return "Shift";
	    case vk_control: return "Control";
	    case vk_alt: return "Alt";
	    case vk_enter: return "Enter";
	    case vk_up: return "Up";
	    case vk_down: return "Down";
	    case vk_left: return "Left";
	    case vk_right: return "Right";
	    case vk_backspace: return "Backspace";
	    case vk_tab: return "Tab";
	    case vk_insert: return "Insert";
	    case vk_delete: return "Delete";
	    case vk_pageup: return "Page Up";
	    case vk_pagedown: return "Page Down";
	    case vk_home: return "Home";
	    case vk_end: return "End";
	    case vk_escape: return "Escape";
	    case vk_printscreen: return "Print Screen";
	    case vk_f1: return "F1";
	    case vk_f2: return "F2";
	    case vk_f3: return "F3";
	    case vk_f4: return "F4";
	    case vk_f5: return "F5";
	    case vk_f6: return "F6";
	    case vk_f7: return "F7";
	    case vk_f8: return "F8";
	    case vk_f9: return "F9";
	    case vk_f10: return "F10";
	    case vk_f11: return "F11";
	    case vk_f12: return "F12";
	    case vk_lshift: return "Left Shift";
	    case vk_rshift: return "Right Shift";
	    case vk_lcontrol: return "Left Control";
	    case vk_rcontrol: return "Right Control";
	    case vk_lalt: return "Left Alt";
	    case vk_ralt: return "Right Alt";
	    // Numpad keys
	    case 96: return "0";
	    case 97: return "1";
	    case 98: return "2";
	    case 99: return "3";
	    case 100: return "4";
	    case 101: return "5";
	    case 102: return "6";
	    case 103: return "7";
	    case 104: return "8";
	    case 105: return "9";
	    case 106: return "*";
	    case 107: return "+";
	    case 109: return "-";
	    case 110: return ".";
	    case 111: return "/";
	    // Misc keys
	    case 186: return ";";
	    case 187: return "=";
	    case 188: return ",";
	    case 189: return "-";
	    case 190: return ".";
	    case 191: return "/";
	    case 192: return "`";
	    case 219: return "[";
	    case 220: return "\\";
	    case 221: return "]";
	    case 222: return "\'";
	    // Other characters
	    default: return chr(keyIn);
	}
}

/// @function scrDrawButtonInfo(optionsText)
/// @description Draws the button control info for menus
/// @param optionsText sets whether to draw the text for entering the options menu
function scrDrawButtonInfo(optionsText) {

	var backButton;
	var acceptButton;
	var optionsButton;

	// Check whether to display keyboard or controller buttons
	if (!global.controllerMode) {
	    backButton = scrGetKeyStr(global.menuBackButton[0]);
	    acceptButton = scrGetKeyStr(global.menuAcceptButton[0]);
	    optionsButton = scrGetKeyStr(global.menuOptionsButton[0]);
	} else {
	    backButton = scrGetControllerStr(global.menuBackButton[1]);
	    acceptButton = scrGetControllerStr(global.menuAcceptButton[1]);
	    optionsButton = scrGetControllerStr(global.menuOptionsButton[1]);
	}

	// Draw button info
	draw_set_font(fDefault12);
	draw_set_halign(fa_left);
	draw_set_valign(fa_bottom);
	draw_text(34,576,"["+backButton+"] Back");
	draw_set_halign(fa_right);
	draw_text(766,576,"["+acceptButton+"] Accept");

	// Check if we should draw button info for entering to the options menu
	if (optionsText) {
	    draw_set_halign(fa_middle);
	    draw_text(400,576,"["+optionsButton+"] Options");
	}
}
