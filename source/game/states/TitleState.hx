package game.states;

import game.ui.Underline;
import game.states.CreditsSubstate.CreditsSubState;
import game.ui.TextButton;
import flixel.util.FlxAxes;

/**
 * Add Press Start Before entering main scene for title
 * as part of the update functionality
 */
class TitleState extends FlxState {
	public var pressStartText:FlxText;
	public var playButton:TextButton;
	public var continueButton:TextButton;
	public var optionsButton:TextButton;
	public var creditsButton:TextButton;
	public var completeFadeStart:Bool;
	public var background:FlxSprite;
	public var mouseCursor:FlxSprite;
	#if desktop
	public var exitButton:TextButton;
	#end

	override public function create() {
		FlxG.mouse.visible = true;
		bgColor = KColor.RICH_BLACK_FORGRA;
		var textColor = 0xf2d3ab;
		// Create Title Text
		// Play Title Music
		FlxG.sound.playMusic(AssetPaths.boss_title__ogg);

		var text = new FlxText(0, 0, -1, Globals.GAME_TITLE, 32);
		text.color = textColor;
		add(text);
		text.alignment = CENTER;
		text.screenCenter();
		text.y -= 60;
		completeFadeStart = false;
		initializeSave();
		createCharacter(text.x, text.y);
		setupMouse();
		createBackground();
		createPressStart();
		createButtons();
		// createControls();
		createCredits();
		createVersion();
		super.create();
	}

	function initializeSave() {
		DataPlugin.initializeSave();
		DataPlugin.Save.loadSettings();
	}

	function createCharacter(x:Float, y:Float) {
		var margin = 60;
		var sprocket = new FlxSprite(x, y + margin);
		sprocket.loadGraphic(AssetPaths.sprocket__png, true, 24, 24, true);
		sprocket.animation.add("run", [0, 1, 2], 12, true);
		add(sprocket);
		sprocket.animation.play('run');
		sprocket.cameraCenterHorz();
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

	function createBackground() {
		var height = (FlxG.height / 3);
		var width = FlxG.width / 3;
		var underline = new Underline(0, 0, FlxG.width / 2, 4, KColor.WHITE);
		underline.setupFade(2, true);
		underline.screenCenter();
		underline.y -= 40;
		background = new FlxSprite(0, (FlxG.height - height) - 20);
		background.makeGraphic(cast width, cast height, 0x43000000);
		background.drawBorder(2, KColor.WHITE);
		background.visible = false;
		background.alpha = 0;
		background.screenCenterHorz();
		add(underline);
		add(background);
	}

	public function createPressStart() {
		pressStartText = new FlxText(0, 0, -1, 'Press Any Button To Start',
			Globals.FONT_N);
		pressStartText.screenCenter();
		pressStartText.y += 30;
		// add later
		add(pressStartText);
		pressStartText.flicker(0, .4);
	}

	public function createButtons() {
		// Create Buttons
		var spacing = 20;
		var y = 40;
		playButton = new TextButton(0, 0, Globals.TEXT_START, Globals.FONT_N,
			clickStart);
		playButton.hoverColor = KColor.BURGUNDY;
		playButton.clickColor = KColor.BURGUNDY;
		playButton.screenCenter();
		playButton.y += y;
		y += spacing;
		// continueButton = new TextButton(0, 0, Globals.TEXT_CONTINUE,
		// 	Globals.FONT_N, clickContinue);
		// continueButton.hoverColor = KColor.BURGUNDY;
		// continueButton.clickColor = KColor.BURGUNDY;
		// continueButton.screenCenter();
		// continueButton.y += y;
		y += spacing;
		optionsButton = new TextButton(0, 0, Globals.TEXT_OPTIONS,
			Globals.FONT_N, clickOptions);
		optionsButton.hoverColor = KColor.BURGUNDY;
		optionsButton.clickColor = KColor.BURGUNDY;
		optionsButton.screenCenter();
		optionsButton.y += y;
		y += spacing;
		creditsButton = new TextButton(0, 0, Globals.TEXT_CREDITS,
			Globals.FONT_N, clickCredits);
		creditsButton.hoverColor = KColor.BURGUNDY;
		creditsButton.clickColor = KColor.BURGUNDY;
		creditsButton.screenCenter();
		creditsButton.y += y;
		y += spacing;
		#if desktop
		exitButton = new TextButton(0, 0, Globals.TEXT_EXIT, Globals.FONT_N,
			clickExit);
		exitButton.hoverColor = KColor.BURGUNDY;
		exitButton.clickColor = KColor.BURGUNDY;
		exitButton.screenCenter();
		exitButton.y += y;
		#end
		// Add Buttons

		playButton.canClick = false;
		playButton.alpha = 0;
		// continueButton.canClick = false;
		// continueButton.alpha = 0;
		optionsButton.canClick = false;
		optionsButton.alpha = 0;
		creditsButton.canClick = false;
		creditsButton.alpha = 0;
		add(playButton);
		// add(continueButton);
		add(optionsButton);
		add(creditsButton);
		#if desktop
		exitButton.canClick = false;
		exitButton.alpha = 0;
		add(exitButton);
		#end
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		updateMouse();
		updatePressStart(elapsed);
	}

	function updateMouse() {
		mouseCursor.scrollFactor.set(0, 0);
		var mousePosition = FlxG.mouse.getPosition();
		mouseCursor.setPosition(mousePosition.x, mousePosition.y);
	}

	public function updatePressStart(elapsed:Float) {
		var keyPressed = FlxG.keys.firstPressed();
		if (keyPressed != -1) {
			pressStartText.stopFlickering();
			pressStartText.visible = false;
		} else if (pressStartText.visible) {}

		var fadeTime = 0.25;
		if (!pressStartText.visible && !pressStartText.isFlickering()
			&& completeFadeStart == false) {
			background.visible = true;
			background.fadeIn(fadeTime);
			playButton.fadeIn(fadeTime);
			if (playButton.alpha >= .9) {
				continueButton.fadeIn(fadeTime);
			}
			if (continueButton.alpha >= .9) {
				optionsButton.fadeIn(fadeTime);
			}
			if (optionsButton.alpha >= .9) {
				creditsButton.fadeIn(fadeTime);
				#if !desktop
				completeFadeStart = true;
				#end
			}

			#if desktop
			if (creditsButton.alpha >= .9) {
				exitButton.fadeIn(fadeTime);
				completeFadeStart = true;
			}
			exitButton.visible = true;
			#end
		}

		if (completeFadeStart) {
			playButton.canClick = true;
			continueButton.canClick = true;
			optionsButton.canClick = true;
			creditsButton.canClick = true;
			#if desktop
			exitButton.canClick = true;
			#end
		}
	}

	public function clickStart() {
		FlxG.switchState(new InstructionsState());
	}

	public function clickContinue() {
		// openSubState(new LoadSubState());
	}

	public function clickOptions() {
		openSubState(new SettingsSubState());
	}

	public function clickCredits() {
		openSubState(new CreditsSubState());
	}

	#if desktop
	public function clickExit() {
		Sys.exit(0);
	}
	#end

	public function createControls() {
		var textWidth = 200;
		var textSize = 12;
		var controlsText = new FlxText(20, FlxG.height - 100, textWidth,
			'How To Move:
UP: W/UP
Left/Right: A/Left, S/Right', textSize);
		add(controlsText);
	}

	public function createCredits() {
		var textWidth = 200;
		var textSize = 12;
		var creditsText = new FlxText(FlxG.width - textWidth,
			FlxG.height - 20, textWidth, 'Created by KinoCreates', textSize);
		add(creditsText);
	}

	public function createVersion() {
		var textWidth = 400;
		var textSize = 12;
		var versionText = new FlxText(20, FlxG.height - 20, textWidth,
			Globals.TEXT_VERSION, textSize);
		// versionText.screenCenter(FlxAxes.X);
		add(versionText);
	}
}