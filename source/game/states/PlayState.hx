package game.states;

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
}

class PlayState extends BaseTileState {
	public var wordGrp:FlxTypedGroup<Word>;
	public var carriedWord:Word;
	public var doorGrp:FlxTypedGroup<FlxSprite>;
	public var player:Player;
	public var goal:FlxSprite;

	override public function create() {
		super.create();
	}

	override public function createGroups() {
		super.createGroups();
		wordGrp = new FlxTypedGroup<Word>();
		var word = new Walk(30, 30);
		doorGrp = new FlxTypedGroup<FlxSprite>();
		wordGrp.add(word);
	}

	override public function addGroups() {
		super.addGroups();
		add(wordGrp);
		add(doorGrp);
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
		FlxG.overlap(mouseCursor, wordGrp, grabWord);
		FlxG.overlap(mouseCursor, entityGrp, attachWord);
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
			carriedWord = null;
		}
		// Grab word
		if (FlxG.mouse.justPressed) {
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
		if (true) {}
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
			if (levelCompleteSound.playing == false) {
				// Show Win SubState
				openSubState(new WinSubState(nextLevel()));
			}
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