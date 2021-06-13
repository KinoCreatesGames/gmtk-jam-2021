package game.states;

class CreditsSubState extends FlxSubState {
	var titleText:FlxText;

	public function new() {
		super(KColor.RICH_BLACK_FORGRA_LOW);
	}

	override public function create() {
		super.create();
		var verticalPadding = 24;
		var horizontalPadding = 24;
		createTitle(horizontalPadding, verticalPadding);
		createCredits(horizontalPadding, verticalPadding * 3);
	}

	function createTitle(x:Float, y:Float) {
		titleText = new FlxText(x, y);
		titleText.cameraCenterHorz();
		add(titleText);
	}

	function createCredits(x:Float, y:Float) {
		var kinoText = new FlxText(x, y, -1, 'Designer Kino Rose',
			Globals.FONT_L);
		var jdText = new FlxText(x, y, -1, 'Music by JDSherbert',
			Globals.FONT_L);

		kinoText.cameraCenterHorz();
		jdText.screenCenterHorz();
		add(kinoText);
		add(jdText);
	}
}