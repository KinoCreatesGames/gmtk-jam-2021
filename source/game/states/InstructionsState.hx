package game.states;

class InstructionsState extends FlxState {
	public function new() {
		super();
	}

	override public function create() {
		super.create();
	}

	function createInstructions() {
		var content = 'This is a mouse driven game.
    You use your mouse in order to join words to entities in the world.
    Drag and drag the words onto entities to give them abilities!
    Use your words wisely in order to get Sprocket to the goal!';
		var text = new FlxText(0, 0, 300, content, Globals.FONT_N);
		add(text);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		processStateTransition();
	}

	public function processStateTransition() {
		if (FlxG.mouse.justPressed) {
			FlxG.camera.fade(KColor.BLACK, 1, false, () -> {
				FlxG.camera.fade(KColor.BLACK, 1, true);
				FlxG.switchState(new LevelOneState());
			});
		}
	}
}