package game.states;

import game.ui.TextButton;

class WinSubState extends FlxSubState {
	public var background:FlxSprite;
	public var congratsText:FlxText;
	public var continueButton:TextButton;
	public var toTitleButton:TextButton;
	public var nextLevel:FlxState;
	public var mouseCursor:FlxSprite;

	private var initialPosition:Float;
	private var timeCount:Float;

	public function new(?nextLevel:FlxState) {
		super();
		if (nextLevel != null) {
			this.nextLevel = nextLevel;
		}
	}

	override public function create() {
		super.create();
		timeCount = 0;
		createBackground();
		createCongrats();
		createButtons();
		setupMouse();
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

	// note 480 x 270
	public function createBackground() {
		var width = FlxG.width / 2;
		var height = FlxG.height / 2;
		background = new FlxSprite(width, height);
		background.makeGraphic(cast width, cast height, KColor.TRANSPARENT);
		// Draw Border  +  Background
		background.drawRect(0, 0, width, height, KColor.RICH_BLACK, {
			thickness: 4,
			color: KColor.WHITE
		});
		background.screenCenter();
		add(background);
	}

	public function createCongrats() {
		congratsText = new FlxText(background.x, background.y, -1,
			Globals.TEXT_CONGRATS, Globals.FONT_L);
		congratsText.screenCenterHorz();
		congratsText.y += 30;
		initialPosition = congratsText.y;
		add(congratsText);
	}

	public function createButtons() {
		var padding = 24;
		var x = background.x + padding;
		var y = background.y + (background.height - padding);
		if (nextLevel != null) {
			continueButton = new TextButton(cast x, cast y, 'Continue',
				Globals.FONT_N, clickContinue);

			continueButton.hoverColor = KColor.PRETTY_PINK;
			continueButton.clickColor = KColor.RICH_BLACK_FORGRA;
		}

		x = background.x + (background.width - padding);
		toTitleButton = new TextButton(cast x, cast y, 'To Title',
			Globals.FONT_N, clickToTitle);
		toTitleButton.x -= toTitleButton.width;

		toTitleButton.hoverColor = KColor.PRETTY_PINK;
		toTitleButton.clickColor = KColor.RICH_BLACK_FORGRA;
		if (nextLevel != null) {
			add(continueButton);
		}
		add(toTitleButton);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		updateMouse();
		updateCongrats(elapsed);
	}

	public function updateCongrats(elapsed:Float) {
		timeCount += elapsed;
		congratsText.y = initialPosition + (18 * Math.sin(timeCount));
	}

	public function clickContinue() {
		FlxG.camera.fade(KColor.BLACK, 1, false, () -> {
			close();
			FlxG.camera.fade(KColor.BLACK, 1, true);
			FlxG.switchState(nextLevel);
		});
	}

	public function clickToTitle() {
		FlxG.camera.fade(KColor.BLACK, 1, false, () -> {
			close();
			// FlxG.camera.fade(KColor.BLACK, 1, true);
			FlxG.switchState(new TitleState());
		});
	}

	function updateMouse() {
		mouseCursor.scrollFactor.set(0, 0);
		var mousePosition = FlxG.mouse.getPosition();
		mouseCursor.setPosition(mousePosition.x, mousePosition.y);
	}
}