package game.states;

import flixel.FlxObject;
import flixel.tile.FlxBaseTilemap.FlxTilemapAutoTiling;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.tiled.TiledTileSet;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.addons.editors.tiled.TiledMap;

class BaseTileState extends BaseGameState {
	// Conditions
	public var completeLevel:Bool;
	public var gameOver:Bool;
	// Map Information
	public var map:TiledMap;

	// Groups
	public var backgroundGrp:FlxTypedGroup<FlxTilemap>;
	public var lvlGrp:FlxTypedGroup<FlxTilemap>;
	public var decorationGrp:FlxTypedGroup<FlxTilemap>;
	public var enemyGrp:FlxTypedGroup<Enemy>;
	public var entityGrp:FlxTypedGroup<Actor>;
	public var doorGrp:FlxTypedGroup<FlxSprite>;
	public var hazardGrp:FlxTypedGroup<FlxSprite>;

	public static inline var TILESET_NAME:String = 'Tileset_v1';

	override public function create() {
		super.create();
		completeLevel = false;
		gameOver = false;
	}

	public function createLevel(?levelName:String) {
		if (levelName != null) {
			final map = new TiledMap(getLevel(levelName));
			this.map = map;
		}

		createGroups();
		createLevelInformation();
		createUI();
		addGroups();
	}

	/**
		* Creates the groups that are being used on the level
				* ```haxe
		 enemyGrp = new FlxTypedGroup<Enemy>();
		 levelGrp = new FlxTypedGroup<FlxTilemap>();
		 decorationGrp = new FlxTypedGroup<FlxTilemap>();
				* ```
	 */
	public function createGroups() {
		enemyGrp = new FlxTypedGroup<Enemy>();
		lvlGrp = new FlxTypedGroup<FlxTilemap>();
		decorationGrp = new FlxTypedGroup<FlxTilemap>();
		hazardGrp = new FlxTypedGroup<FlxSprite>();
		backgroundGrp = new FlxTypedGroup<FlxTilemap>();
		doorGrp = new FlxTypedGroup<FlxSprite>();
		entityGrp = new FlxTypedGroup<Actor>();
	}

	/**
	 * Creates the level information for the level, including
	 		* the actual tiled level map.
	 */
	public function createLevelInformation() {
		// createLevelMap -- use this to create your level
		// Additional Elements Below UI
	}

	/**
	 * Function for creating the UI for the game.
	 */
	public function createUI() {}

	/**
		* Add additional groups to your tiled map
		* 
		* ```haxe
			add(lvlGrp);
			add(decorationGrp);
			add(enemyGrp);
			* ```
	 */
	public function addGroups() {
		add(backgroundGrp);
		add(lvlGrp);
		add(decorationGrp);
		add(hazardGrp);
		add(doorGrp);
		add(enemyGrp);
		add(entityGrp);
	}

	public function createLevelMap(tileLayer:TiledTileLayer) {
		// Gets Tiled Image Data
		var tileset:TiledTileSet = map.getTileSet(TILESET_NAME);
		createBackgroundLayer();
		if (tileLayer == null) {
			// get with prefix
			tileLayer = null;
		} else {
			addLevelToGrp(tileLayer, tilesetPath(), tileset);
		}
		createDecorationLayers();
	}

	function createBackgroundLayer() {
		var tileset:TiledTileSet = map.getTileSet(TILESET_NAME);
		// This works because it has an ID given by Flixel
		// var tilesetPath = AssetPaths.floor_tileset__png;

		final tileLayer:TiledTileLayer = cast(map.getLayer('Background'));

		if (tileLayer != null) {
			final levelDecoration = new FlxTilemap();
			levelDecoration.loadMapFromArray(tileLayer.tileArray, map.width,
				map.height, tilesetPath(), map.tileWidth, map.tileHeight,
				FlxTilemapAutoTiling.OFF, tileset.firstGID, 1, FlxObject.NONE);
			backgroundGrp.add(levelDecoration);
			// Tint Background
			levelDecoration.color = 0xF0C0C0C0;
		}
	}

	public function createDecorationLayers() {
		var tileset:TiledTileSet = map.getTileSet(TILESET_NAME);
		// This works because it has an ID given by Flixel
		// var tilesetPath = AssetPaths.floor_tileset__png;

		final tileLayer:TiledTileLayer = cast(map.getLayer('Decoration'));

		if (tileLayer != null) {
			final levelDecoration = new FlxTilemap();
			levelDecoration.loadMapFromArray(tileLayer.tileArray, map.width,
				map.height, tilesetPath(), map.tileWidth, map.tileHeight,
				FlxTilemapAutoTiling.OFF, tileset.firstGID, 1, FlxObject.NONE);
			decorationGrp.add(levelDecoration);
		}
		// };
	}

	public function addLevelToGrp(tileLayer:TiledTileLayer,
			tilesetPath:String, tileset:TiledTileSet) {
		var level = new FlxTilemap();
		level.loadMapFromArray(tileLayer.tileArray, map.width, map.height,
			tilesetPath, map.tileWidth, map.tileHeight,
			FlxTilemapAutoTiling.OFF, tileset.firstGID, 1);
		lvlGrp.add(level);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		// Add processing  for any tile information
		processCollision();
		processLevel(elapsed);
	}

	public function processCollision() {}

	public function processLevel(elapsed:Float) {}

	/**
	 * Returns the current tileset path for the current
	 * map.
	 * @return String
	 */
	public function tilesetPath():String {
		return AssetPaths.tileset_v1__png;
	}

	public inline function getLevel(levelName:String) {
		return 'assets/maps/sprocket/tiled/${levelName}.tmx';
	}
}