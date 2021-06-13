package game.states;

class LevelOneState extends PlayState {
	override public function create() {
		super.create();
		createLevel('Level_0');
	}
}