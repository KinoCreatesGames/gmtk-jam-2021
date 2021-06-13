package game.objects;

class NonSolid extends Word {
	override public function create() {
		super.create();
		this.text = 'Non-Solid';
	}
}