package game.states;

class InstructionsState extends FlxState {
	public function new() {
		super();
	}

	override public function create() {
		super.create();
		createInstructions();
	}

	function createInstructions() {
		var content = 'This is a mouse driven game.
    You use your mouse in order to join words to entities in the world.
    Drag and drag the words onto entities to give them abilities!
    Use your words wisely in order to get Sprocket to the goal!
		You can press R to reset the stage.'.split("\n")
			.map((line) -> {
				return line.trim();
			})
			.join("\n");
		var text = new FlxText(0, 0, 300, content, Globals.FONT_N);
		text.screenCenter();
		add(text);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		processStateTransition();
	}

	function startMusic() {
		FlxG.sound.playMusic(AssetPaths.JDSherbert_Sprocket_Tea__ogg);
	}

	public function processStateTransition() {
		if (FlxG.mouse.justPressed) {
			FlxG.camera.fade(KColor.BLACK, 1, false, () -> {
				FlxG.camera.fade(KColor.BLACK, 1, true);
				startMusic();
				FlxG.switchState(new LevelOneState());
			});
		}
	}
}