/// @function scrButtonCheck(buttonArray)
/// @description Checks whether a button is currently being pressed
/// @param buttonArray array containing the keyboard button in index 0 and the controller button in index 1
function scrButtonCheck(buttonIn) {

	if (!global.controllerMode) {
	    return (keyboard_check(buttonIn[0]));
	} else {
	    return (gamepad_button_check(global.controllerIndex,buttonIn[1]));
	}
}

/// @function scrButtonCheckPressed(buttonArray)
/// @description Checks whether a button is being pressed this frame
/// @param buttonArray array containing the keyboard button in index 0 and the controller button in index 1
function scrButtonCheckPressed(buttonIn) {

	if (!global.controllerMode) {
	    return (keyboard_check_pressed(buttonIn[0]));
	} else {
	    return (gamepad_button_check_pressed(global.controllerIndex,buttonIn[1]));
	}
}

/// @function scrButtonCheckReleased(buttonArray)
/// @description Checks whether a button is being released this frame
/// @param buttonArray array containing the keyboard button in index 0 and the controller button in index 1
function scrButtonCheckReleased(buttonIn) {

	if (!global.controllerMode) {
	    return (keyboard_check_released(buttonIn[0]));
	} else {
	    return (gamepad_button_check_released(global.controllerIndex,buttonIn[1]));
	}
}

/// @function scrAnyControllerButtonPressed()
/// @description Returns a gamepad button if one is being pressed and -1 if none are pressed (if multiple are pressed at the same time, return whichever has the lowest value)
function scrAnyControllerButtonPressed() {

	// Make an array of all the gamepad buttons to check
	var buttonArr = [gp_face1,gp_face2,gp_face3,gp_face4,gp_padu,gp_padd,gp_padl,gp_padr,gp_stickr,gp_stickl,gp_select,gp_start,gp_shoulderr,gp_shoulderrb,gp_shoulderl,gp_shoulderlb];
	var buttonArrLength = array_length(buttonArr);

	// Check every button in the array
	for (var i = 0; i < buttonArrLength; i++) {
	    if (gamepad_button_check_pressed(global.controllerIndex, buttonArr[i])) {
	        return buttonArr[i]; // Button pressed, return value
		}
	}

	return -1; // No buttons pressed
}

