/// @description Flip player rightside-up

if (place_meeting(x,y,objPlayer)) {
	if (global.grav == -1) {
	    scrFlipGrav();
	}
}