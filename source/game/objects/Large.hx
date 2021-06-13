package game.objects;

/**
 * When an entity in game has this word
 * attached, they will grow in size.
 */
class Large extends Word {
	override public function create() {
		super.create();
		this.text = 'Large';
	}
}