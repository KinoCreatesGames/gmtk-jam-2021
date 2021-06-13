package game.objects;

/**
 * When this word is attached,
 * the entity will  shrink in size.  
 */
class Small extends Word {
	override public function create() {
		super.create();
		this.text = "Small";
	}
}