package game.hazard;

class DeathArea extends FlxSprite {
	public function new(x:Float, y:Float) {
		super(x, y);
		makeGraphic(24, 24, KColor.TRANSPARENT);
	}
}