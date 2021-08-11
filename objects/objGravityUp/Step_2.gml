/// @description Flip player upside-down

if (place_meeting(x,y,objPlayer)) {
	if (global.grav == 1) {
	    scrFlipGrav();
	}
}