package game.ext;

import openfl.utils.Assets;
import flixel.system.frontEnds.SoundFrontEnd;

function dLog(...rest:Dynamic) {
	#if debug
	trace(rest);
	#end
}

function sceneToMessageText(sText:SceneText):MsgText {
	return {
		text: sText.text,
		name: sText.speaker,
		bustName: sText.bust
	}
}

function stopMusic(sFrontEnd:SoundFrontEnd) {
	var music = sFrontEnd.music;
	if (music != null) {
		music.stop();
	}
}

function pauseMusic(sFrontEnd:SoundFrontEnd) {
	var music = sFrontEnd.music;
	if (music != null) {
		music.pause();
	}
}

function resumeMusic(sFrontEnd:SoundFrontEnd) {
	var music = sFrontEnd.music;
	if (music != null) {
		music.resume();
	}
}

// Asset Path

/**
 * Replaces the "../../" at the start of a path with  "assets/".
 * @param filePath 
 */
inline function assetPath(filePath:String) {
	return filePath.replace('../../', 'assets/');
}