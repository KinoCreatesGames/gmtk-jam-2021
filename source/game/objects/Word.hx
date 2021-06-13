package game.objects;

import flixel.FlxObject;

/**
 * Word is the base class of all words in the game.
 * Each word has a different effect on 
 * a character in the game.
 */
class Word extends FlxText {
	public function new(x:Float, y:Float) {
		super(x, y, -1, '', Globals.FONT_N);
		allowCollisions = FlxObject.ANY;
		create();
	}

	public function create() {}
}