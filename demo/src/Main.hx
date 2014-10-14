import com.haxepunk.HXP;
import com.haxepunk.Engine;
import com.haxepunk.Scene;
import scenes.Playground;

class Main extends Engine {
	override public function init(){ super.init();	
		HXP.scene = new Playground();	
	}
	public static function main() {
		new Main();
	}
}