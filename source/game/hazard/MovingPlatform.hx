package game.hazard;

import flixel.util.FlxPath;

class MovingPlatform extends FlxSprite {
	public function new(x:Float, y:Float, loopPath:Array<FlxPoint>) {
		super(x, y);
		this.origin.set(0, 0);
		this.path = new FlxPath(loopPath);
		this.path.autoCenter = false;
		this.path.start(null, 40, FlxPath.LOOP_FORWARD);
		loadGraphic(AssetPaths.tileset_v3__png, true, 24, 24, true);
		animation.add('frameOne', [0], 1, true);
		animation.play('frameOne');
	}
}