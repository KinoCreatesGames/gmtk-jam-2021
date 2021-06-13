package source.game.objects;

/**
 * When the word is attached
 * the entity will be 50% slower.
 */
class Slow extends Word {
	override public function create() {
		super.create();
		this.text = 'Slow';
	}
}