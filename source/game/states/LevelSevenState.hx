package game.states;

class LevelSevenState extends PlayState {
	override public function create() {
		super.create();
		createLevel(project.all_levels.Level_6);
	}

	override public function nextLevel() {
		return new ThankYouState();
	}
}