package game.states;

import game.objects.Slow;
import game.objects.Reverse;
import game.objects.Jump;
import game.objects.Small;
import game.objects.NonSolid;
import game.objects.Fast;
import game.hazard.DeathArea;
import game.hazard.MovingPlatform;
import game.objects.Walk;
import game.objects.Word;
import game.objects.Large;
import flixel.FlxState;

enum abstract EntityNames(String) from String to String {
	var PLAYER = 'Player';
	var ENEMY = 'Enemy';
	var GOAL = 'Goal';
	var MPLATFORM = 'MovingPlatform';
	var DEATH = 'DeathArea';
}

class PlayState extends BaseLDTkState {
	public var wordGrp:FlxTypedGroup<Word>;
	public var carriedWord:Word;
	public var grabSound:FlxSound;
	public var releaseSound:FlxSound;
	public var deathGrp:FlxTypedGroup<FlxSprite>;

	public var player:Player;
	public var goal:FlxSprite;

	override public function create() {
		super.create();
	}

	override public function setupAssets() {
		super.setupAssets();
		grabSound = FlxG.sound.load(AssetPaths.grab_sound__ogg);
		releaseSound = FlxG.sound.load(AssetPaths.release_sound__ogg);
	}

	override public function createGroups() {
		super.createGroups();
		wordGrp = new FlxTypedGroup<Word>();
		deathGrp = new FlxTypedGroup<FlxSprite>();

		addWords();
	}

	/**
	 * Used to add words at the top of the screen.
	 */
	public function addWords() {}

	override public function addGroups() {
		super.addGroups();
		add(wordGrp);
		add(deathGrp);
		setupMouse();
	}

	override public function createLevelInformation() {
		// map.getLayer()
		createLevelMap();
		createEntities();
		createWords();
		applyModifiers();
	}

	function applyModifiers() {}

	/**
	 * Spawns Entities into the game.
	 */
	function createEntities() {
		// var entityLayer = lvl.l_Entities.
		// Player
		lvl.l_Entities.all_Player.iter((pl) -> {
			player = new Player(pl.pixelX, pl.pixelY,
				DepotData.Actors_Sprocket);
			entityGrp.add(player);
		});
		// Enemy - None Currently.

		// Moving Platform
		lvl.l_Entities.all_MovingPlatform.iter((mPl) -> {
			var tileSize = lvl.l_Level.gridSize;
			var path = mPl.f_Path.map((point) ->
				new FlxPoint(point.cx * tileSize, point.cy * tileSize));
			var mPlatform = new MovingPlatform(mPl.pixelX, mPl.pixelX, path);
			hazardGrp.add(mPlatform);
		});

		// Hazard

		// Death
		lvl.l_Entities.all_DeathArea.iter((deathArea) -> {
			var deathSprite = new DeathArea(deathArea.pixelX, deathArea.pixelY);
			deathGrp.add(deathSprite);
		});

		// Goal
		lvl.l_Entities.all_Goal.iter((goal) -> {
			this.goal = new FlxSprite(goal.pixelX, goal.pixelY);
			this.goal.loadGraphic(AssetPaths.door_sprocket__png, false, 24,
				24, true);
			doorGrp.add(this.goal);
		});
	}

	/**
	 * Creates words based off the word layer in LDTk.
	 */
	function createWords() {
		lvl.l_Words.all_Word.iter((word) -> {
			// Go by entity type
			var wordType = word.f_WordType;
			var newWord:Word = switch (wordType) {
				case WalkW:
					new Walk(word.pixelX, word.pixelY);
				case FastW:
					new Fast(word.pixelX, word.pixelY);
				case JumpW:
					new Jump(word.pixelX, word.pixelY);
				case NonSolidW:
					new NonSolid(word.pixelY, word.pixelY);
				case ReverseW:
					new Reverse(word.pixelX, word.pixelY);
				case SlowW:
					new Slow(word.pixelX, word.pixelY);
				case SmallW:
					new Small(word.pixelX, word.pixelY);
				case LargeW:
					new Large(word.pixelX, word.pixelY);
				case _:
					null; // Do nothing
			}
			wordGrp.add(newWord);
		});
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
	}

	override public function processCollision() {
		if (player.notSolid == false) {
			FlxG.collide(player, lvlGrp);
			FlxG.collide(player, hazardGrp);
		}
		FlxG.overlap(player, deathGrp, (_, _) -> {
			gameOver = true;
		});
		FlxG.overlap(player, goal, playerTouchGoal);
	}

	function playerTouchGoal(player:Player, goal:FlxSprite) {
		/**
		 * Complete Level and Play SFX
		 */
		completeLevel = true;
	}

	override public function processLevel(elapsed:Float) {
		processMouse(elapsed);
		processStateTransition(elapsed);
	}

	function processMouse(elapsed:Float) {
		processWordFollowMouse(elapsed);
		processAttachDetachWords(elapsed);
	}

	function processWordFollowMouse(elapsed:Float) {
		var offsetX = -6;
		if (carriedWord != null) {
			carriedWord.setPosition(mouseCursor.x + offsetX, mouseCursor.y);
		}
	}

	function processAttachDetachWords(elapsed:Float) {
		FlxG.overlap(mouseCursor, entityGrp, attachWord);
		FlxG.overlap(mouseCursor, wordGrp, grabWord);
		FlxG.overlap(mouseCursor, entityGrp, detachWord);

		// if (FlxG.mouse.overlaps(entityGrp) && FlxG.mouse.justReleased
		// 	&& carriedWord != null) {
		// 	// Drops word onto the target
		// } else if (FlxG.mouse.overlaps(entityGrp)
		// 	&& FlxG.mouse.justPressedRight) {
		// 	// This is the removing section
		// }
	}

	function grabWord(mouse:FlxSprite, word:Word) {
		// Release word on release
		if (FlxG.mouse.justReleased) {
			releaseSound.play();
			carriedWord = null;
		}
		// Grab word
		if (FlxG.mouse.justPressed && word.visible) {
			grabSound.play();
			carriedWord = word;
		}
	}

	function attachWord(mouse:FlxSprite, actor:Actor) {
		if (carriedWord != null && FlxG.mouse.justReleased) {
			// Drop word onto the actor
			actor.applyWord(carriedWord);
			carriedWord = null;
		}
	}

	function detachWord(mouse:FlxSprite, actor:Actor) {
		if (FlxG.mouse.justPressed) {
			// Remove the latest word instead
			actor.removeWord();
		}
	}

	function processStateTransition(elapsed:Float) {
		var pause = FlxG.keys.anyJustPressed([ESCAPE]);
		var reset = FlxG.keys.anyJustPressed([R]);
		if (reset) {
			FlxG.resetState();
		}
		if (pause) {
			if (!pauseSound.playing) {
				// Automatically pauses the game using the function openPauseState
				pauseSound.play();
				openPauseState();
			}
		}

		if (completeLevel) {
			levelCompleteSound.play();

			// Show Win SubState
			openSubState(new WinSubState(nextLevel()));
		}

		// Show Game Over
		if (gameOver) {
			openSubState(new GameOverSubState());
		}
	}

	override function updateMouse() {
		super.updateMouse();
		if (carriedWord != null) {
			mouseCursor.animation.play('hold');
		} else {
			mouseCursor.animation.play('moving');
		}
	}

	/**
	 * Override this function to choose the next level to go to
	 * after completing a level.
	 * @return FlxState
	 */
	public function nextLevel():FlxState {
		return null;
	}
}