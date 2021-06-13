package game.states;

import game.hazard.DeathArea;
import flixel.addons.editors.tiled.TiledTileLayer;
import game.hazard.MovingPlatform;
import game.objects.Walk;
import flixel.addons.editors.tiled.TiledObjectLayer;
import game.objects.Word;
import game.objects.Large;
import flixel.text.FlxText;
import flixel.FlxState;

enum abstract EntityNames(String) from String to String {
	var PLAYER = 'Player';
	var ENEMY = 'Enemy';
	var GOAL = 'Goal';
	var MPLATFORM = 'MovingPlatform';
	var DEATH = 'DeathArea';
}

class PlayState extends BaseTileState {
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
		var word = new Walk(30, 30);

		wordGrp.add(word);
	}

	override public function addGroups() {
		super.addGroups();
		add(wordGrp);
		add(deathGrp);
		setupMouse();
	}

	override public function createLevelInformation() {
		// map.getLayer()
		createLevelMap(cast this.map.getLayer('Level'));
		createEntities();
	}

	/**
	 * Spawns Entities into the game.
	 */
	function createEntities() {
		var entityLayer:TiledObjectLayer = cast map.getLayer('Entities');
		entityLayer.objects.iter((entity) -> {
			switch (entity.name) {
				case ENEMY:
					var enemy = null;
					entityGrp.add(enemy);
				case PLAYER:
					player = new Player(entity.x, entity.y,
						DepotData.Actors_Sprocket);
					entityGrp.add(player);
				case MPLATFORM:
					var path = [];
					for (name => val in entity.properties.keys) {
						if (name.contains('Path')) {
							var tileWidth = cast map.getTileSet(BaseTileState.TILESET_NAME)
								.tileWidth;

							var xy = val.split(',')
								.map((el) -> Std.parseInt(el) * tileWidth);
							path.push(new FlxPoint(xy[0], xy[1]));
						}
					}
					var mPlatform = new MovingPlatform(entity.x, entity.y,
						path);
					hazardGrp.add(mPlatform);
				case DEATH:
					var deathSprite = new DeathArea(entity.x, entity.y);
					deathGrp.add(deathSprite);
				case GOAL:
					goal = new FlxSprite(entity.x, entity.y);
					goal.loadGraphic(AssetPaths.door_sprocket__png, false, 24,
						24, true);
					doorGrp.add(goal);
			}
		});
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
	}

	override public function processCollision() {
		FlxG.collide(player, lvlGrp);
		FlxG.collide(player, hazardGrp);
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
		FlxG.overlap(mouseCursor, entityGrp, detachWord);
		FlxG.overlap(mouseCursor, wordGrp, grabWord);
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
		if (FlxG.mouse.justPressed) {
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