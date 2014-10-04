package ghxp;


/*
A shortcut class to simplify haxepunk Image handling
+ some usefull tools

Not inspired by Processing, just a thing I find usefull... 
*/

import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import com.haxepunk.Graphic;

class GImage extends Image {

	public var w(get,null):Float;
	public var h(get,null):Float;
	private function get_w(){ return w; }
	private function get_h(){ return h; }
	public var clearBuffer:Bool;

	public function new(source_:ImageType, x_:Float=0, y_:Float=0, l_:Float=0, h_:Float=0){
		super(source_);
		x = x_; y = y_;
		clearBuffer = true;

		resize(l_, h_);
	}

	public function moveTo(x_:Float, y_:Float){ x = x_; y = y_; }
	public function moveBy(x_:Float, y_:Float){ x += x_; y += y_; }
	
	public function resize(w_:Float=0, h_:Float=0){		
		if(w_<=0){ // if 0, then the size is set from the natural size of the asset
			w = width; scaleX = 1;
		} else {
			w = w_; scaleX = w/width;
		}
		if(h_<=0){
			h = height; scaleY = 1;
		} else {
			h = h_; scaleY = h/height;
		}
	}
	public function rescale(scaleX_:Float=1, scaleY_:Float=1){
		scaleX = scaleX_; scaleY = scaleY_;
		w = width*scaleX; h = height*scaleY;
	}
	public function rescaleBy(scaleX_:Float=1, scaleY_:Float=1){
		scaleX *= scaleX_; scaleY *= scaleY_;
		w = width*scaleX; h = height*scaleY;
	}

	public override function destroy(){
		if(clearBuffer) clear(); // "clears the image buffer"
		super.destroy();
	}

}