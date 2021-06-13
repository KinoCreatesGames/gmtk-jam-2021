package game.objects;

/**
 * When the word is attached, the
 * entity speed will increase by 50%.
 */
class Fast extends Word {
	override public function create() {
		super.create();
		this.text = "Fast";
	}
}