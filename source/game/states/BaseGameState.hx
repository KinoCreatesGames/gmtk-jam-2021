package game.states;

class BaseGameState extends FlxState {
	var pauseSound:FlxSound;

	var mouseCursor:FlxSprite;

	override public function create() {
		super.create();
		startMusic();
		setupMouse();
		setupAssets();
	}

	function startMusic() {
		FlxG.sound.playMusic(AssetPaths.JDSherbert_Sprocket_Tea__ogg);
	}

	function setupMouse() {
		mouseCursor = new FlxSprite(12, 12);
		mouseCursor.loadGraphic(AssetPaths.mouse_cursor__png, true, 12, 12,
			true);
		mouseCursor.animation.add('moving', [0], null, true);
		mouseCursor.animation.add('hold', [1], null, true);
		FlxG.mouse.visible = false;
		add(mouseCursor);
	}

	public function setupAssets() {
		pauseSound = FlxG.sound.load(AssetPaths.pause_in__wav);
	}

	function openPauseState() {
		openSubState(new PauseSubState());
		FlxG.sound.pauseMusic();
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		updateMouse();
	}

	function updateMouse() {
		mouseCursor.scrollFactor.set(0, 0);
		var mousePosition = FlxG.mouse.getPosition();
		mouseCursor.setPosition(mousePosition.x, mousePosition.y);
	}
}