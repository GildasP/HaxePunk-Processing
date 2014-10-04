package ghxp;

/*
Processing vector drawing tools for HaxePunk.
Not all the API, but just the usefull basics... 

Inspired by
http://www.processing.org/reference/

and adapted to HaxePunk context.
*/


import com.haxepunk.HXP;
import com.haxepunk.RenderMode;
import com.haxepunk.graphics.atlas.Atlas;

import com.haxepunk.Graphic;
import flash.display.BitmapData;
import flash.geom.Matrix;

//import com.haxepunk.graphics.Image;
import ghxp.GImage; // a shortcut to create HaxePunk images easily... 
// this Lib could be modified to work with native Image class easily (TODO)

typedef Vertex = { x:Float, y:Float };

class GP5 extends Graphic {

	public function new(){ super(); } // is it really usefull ?


	/*
	HaxePunk exclusive stuff, not from Processing API
	*/

	// allows to draw multiple shapes and finally build a single image with all in it
	private static var complexMode_:Bool = false; 
	public static function complexMode(){ 
		HXP.sprite.graphics.clear();
		complexMode_ = true;
	}
	public static function getComplex(w_:Int=0, h_:Int=0, rot:Float=0):GImage {
		complexMode_ = false;
		if(w_==0) w_ = Std.int(HXP.sprite.width);
		if(h_==0) h_ = Std.int(HXP.sprite.height);
		var img = createGImage(w_, h_, rot);
		HXP.sprite.graphics.clear(); // on remet à zéro
		return img;
	}

	// sometimes you need to change the style settings, and come back to it later... 
	private static var storedStyle:Dynamic;
	public static function storeStyle(){
		storedStyle = {
			"strokeColor": strokeColor,
			"strokeAlpha": strokeAlpha,
			"strokeThickness": strokeThickness,
			"fillColor": fillColor,
			"fillAlpha": fillAlpha,
			"ellipseMode": ellipseMode_,
			"rectMode": rectMode_
		};
	}
	public static function restoreStyle(){
		strokeColor = storedStyle.strokeColor;
		strokeAlpha = storedStyle.strokeAlpha;
		strokeThickness = storedStyle.strokeThickness;
		fillColor = storedStyle.fillColor;
		fillAlpha = storedStyle.fillAlpha;
		ellipseMode_ = storedStyle.ellipseMode;
		rectMode_ = storedStyle.rectMode;
	}

	public static var sommets:Array<Float>; // to store Polygon points, and re-use it later (to cuild a Collision Mask for exemple)
	public static function randomPolygon(L_:Int, H_:Int=0, nbSommets_:Int=0):GImage {
		// random convex polygon !
		// http://stackoverflow.com/questions/21690008/how-to-generate-random-vertices-to-form-a-convex-polygon-in-c
		
		if(nbSommets_ == 0) nbSommets_ = 3 + HXP.rand(6); // nb de sommets aléatoire
		if(H_ == 0) H_ = L_;

		var slices:Array<Float> = new Array(); // tranches genre camembert sur un cercle
		for (i in 0...nbSommets_) {
			slices.push(Math.random()*2*Math.PI);
		}
		slices.sort(function(x:Float, y:Float){ // ordre croissant
			if(x==y){ return 0;
			} else if(x<y){ return -1;
			} else { return 1; }
		});

		// juste pour pouvoir réutiliser la liste des sommets ensuite...
		sommets = new Array();

		for (i in 0...nbSommets_) {
			var x_:Float = L_*Math.cos(slices[i]);
			var y_:Float = H_*Math.sin(slices[i]);
			sommets.push(Std.int(x_));
			sommets.push(Std.int(y_));
		}

		// dessin
		GP5.beginShape();
		for (i in 0...nbSommets_) { GP5.vertex(sommets[2*i], sommets[2*i+1]); }		
		return GP5.endShape();
	}


	/*
	Procesing style settings
	*/

	private static var strokeColor:Int = 0x000000;
	private static var strokeThickness:Float = 1;
	private static var strokeAlpha:Float = 1;
	private static var fillColor:Int = 0xFFFFFF;
	private static var fillAlpha:Float = 1;
	private static var ellipseMode_:String = "center";
	private static var rectMode_:String = "center";

	public static function stroke(color_:Int, alpha_:Float=1){
		strokeColor = color_;
		strokeAlpha = alpha_;
	}
	public static function strokeWeight(thickness_:Float){
		strokeThickness = thickness_;
	}
	public static function noStroke(){
		strokeThickness = 0;
	}
	public static function fill(color_:Int, alpha_:Float=1){
		fillColor = color_;
		fillAlpha = alpha_;
	}
	public static function noFill(){
		fillAlpha = 0;
	}
	public static function ellipseMode(mode:String){
		if(mode == "center" || mode == "CENTER"){ ellipseMode_ = "center";
		} else { ellipseMode_ = "corner"; }
	}
	public static function rectMode(mode:String){
		if(mode == "center" || mode == "CENTER"){ rectMode_ = "center";
		} else { rectMode_ = "corner"; }
	}
	public static function background(color_:Int, alpha_:Float=1):GImage{
		var pstrokeThickness = strokeThickness; // backup previous settings
		var pfillAlpha = fillAlpha;
		var pfillColor = fillColor;

		noStroke();
		fill(color_, alpha_);		
		var image:GImage = rect(0, 0, HXP.width, HXP.height);

		// back to original settings
		if(pfillAlpha>0) fill(pfillColor, pfillAlpha);
		if(pstrokeThickness>0){ 
			stroke(strokeColor, strokeAlpha);
			strokeWeight(pstrokeThickness);
		}

		return image;
	}

	// 2D primitives
	// unless you triggered the "complex mode", each shape will generate an Image
	public static function ellipse(x_:Float=0, y_:Float=0, width:Float=0, height:Float=0):GImage {
		if (width == 0) throw "Illegal ellipse, sizes cannot be 0.";
		if (height == 0) height = width;

		applyStyle();
		HXP.sprite.graphics.drawEllipse(strokeThickness, strokeThickness, width, height);
		endStyle();

		var image:GImage = createGImage(width, height);
		image.x = x_; image.y = y_;
		if(ellipseMode_=="center") image.centerOrigin();

		return image;
	}
	public static function rect(x_:Float=0, y_:Float=0, width:Float=0, height:Float=0, radius_:Float=0):GImage {
		if (width == 0 || height == 0) throw "Illegal rect, sizes cannot be 0.";

		applyStyle();
		if(radius_==0){
			HXP.sprite.graphics.drawRect(strokeThickness, strokeThickness, width, height);
		} else {
			HXP.sprite.graphics.drawRoundRect(strokeThickness, strokeThickness, width, height, 2*radius_, 2*radius_);
		}		
		endStyle();

		var image:GImage = createGImage(width, height);
		image.x = x_; image.y = y_;
		if(rectMode_=="center") image.centerOrigin();

		return image;
	}
	public static function line(x1:Float, y1:Float, x2:Float, y2:Float):GImage {

		var x_:Float = Math.min(x1, x2);
		var y_:Float = Math.min(y1, y2);
		var w_:Float = Math.abs(x2-x1);
		var h_:Float = Math.abs(y2-y1);

		if(complexMode_){ x_ = 0; y_ = 0; }

		applyStyle();
		HXP.sprite.graphics.moveTo(x1-x_+strokeThickness, y1-y_+strokeThickness);
		HXP.sprite.graphics.lineTo(x2-x_+strokeThickness, y2-y_+strokeThickness);
		endStyle();

		var image:GImage = createGImage(Std.int(w_+2*strokeThickness), Std.int(h_+2*strokeThickness));
		image.x = x_-strokeThickness; 
		image.y = y_-strokeThickness;
		return image;
	}
	public static function quad(x1:Float, y1:Float, x2:Float, y2:Float, x3:Float, y3:Float, x4:Float, y4:Float):GImage {
		beginShape();
		vertex(x1, y1);
		vertex(x2, y2);
		vertex(x3, y3);
		vertex(x4, y4);
		return endShape();
	}
	public static function triangle(x1:Float, y1:Float, x2:Float, y2:Float, x3:Float, y3:Float):GImage {
		beginShape();
		vertex(x1, y1);
		vertex(x2, y2);
		vertex(x3, y3);
		return endShape();
	}
	public static function point(x_:Float=0, y_:Float=0):GImage {
		if(strokeThickness>1){
			var rond:GImage = ellipse(x_, y_, Std.int(strokeThickness/4));
			rond.centerOrigin();
			return rond;
		} else {
			return rect(x_, y_, 1, 1);
		}
	}

	// Vertex
	private static var vectArray:Array<Vertex> = new Array();
	public static function beginShape(){
		vectArray = new Array();
	}
	public static function vertex(x_:Float, y_:Float){
		var v:Vertex = { x:x_, y:y_ };
		vectArray.push(v);
	}
	public static function endShape(close:Bool=true):GImage {
		if(vectArray.length<=1) throw "Illegal shape, needs at least 2 vertex.";

		// setting of the image that will contain all the vertexes
		var minX:Float = vectArray[0].x;
		var maxX:Float = vectArray[0].x;
		var minY:Float = vectArray[0].y;
		var maxY:Float = vectArray[0].y;
		for (i in 1...vectArray.length){
			minX = Math.min(minX, vectArray[i].x);
			maxX = Math.max(maxX, vectArray[i].x);
			minY = Math.min(minY, vectArray[i].y);
			maxY = Math.max(maxY, vectArray[i].y);
		}
		var x_:Float;
		var y_:Float;
		if(rectMode_=="center"){
			x_ = (minX+maxX)/2;
			y_ = (minY+maxY)/2;
		} else {
			x_ = minX;
			y_ = minY;
		}			
		
		var w_:Float = maxX - minX;
		var h_:Float = maxY - minY;

		applyStyle();

		sommets = new Array(); // sometimes it's usefull to re-use this, to create the associated colision Mask for exemple
		if(rectMode_=="center"){
			sommets.push(vectArray[0].x-minX+strokeThickness); sommets.push(vectArray[0].y-minY+strokeThickness);
			HXP.sprite.graphics.moveTo(vectArray[0].x-minX+strokeThickness, vectArray[0].y-minY+strokeThickness); // move to 1st
			for (i in 1...vectArray.length){
				sommets.push(vectArray[i].x-minX+strokeThickness); sommets.push(vectArray[i].y-minY+strokeThickness);
				HXP.sprite.graphics.lineTo(vectArray[i].x-minX+strokeThickness, vectArray[i].y-minY+strokeThickness);
			}
			if(close) HXP.sprite.graphics.lineTo(vectArray[0].x-minX+strokeThickness, vectArray[0].y-minY+strokeThickness); // line to 1st
		} else {
			sommets.push(vectArray[0].x-x_+strokeThickness); sommets.push(vectArray[0].y-y_+strokeThickness);
			HXP.sprite.graphics.moveTo(vectArray[0].x-x_+strokeThickness, vectArray[0].y-y_+strokeThickness); // move to 1st
			for (i in 1...vectArray.length){
				sommets.push(vectArray[i].x-x_+strokeThickness); sommets.push(vectArray[i].y-y_+strokeThickness);
				HXP.sprite.graphics.lineTo(vectArray[i].x-x_+strokeThickness, vectArray[i].y-y_+strokeThickness);
			}
			if(close) HXP.sprite.graphics.lineTo(vectArray[0].x-x_+strokeThickness, vectArray[0].y-y_+strokeThickness); // line to 1st
		}
		
		endStyle();		
		
		var image:GImage = createGImage(Std.int(w_+2*strokeThickness), Std.int(h_+2*strokeThickness));
		image.x = 0;
		image.y = 0;

		if(rectMode_=="center") image.centerOrigin();

		vectArray = new Array(); // init
		return image;
	}
	

	// Curves ??? TODO !
	/* note : curveTo de 
	http://haxepunk.com/documentation/api/content/flash/display/Graphics.html
	semble correspondre directement avec les bézier.
	pour les curves il ya une "matrice" de transposition,
	pour passer de la liste des points aux courbes de bézier :)
	https://github.com/processing-js/processing-js/blob/master/src/Processing.js
	ligne 6904, // curveVertex
	dans Drawing2D.prototype.endShape
	et ça a l'air trop bien les curves de P5 !!!
	
	bezier()
	bezierDetail()
	bezierPoint()
	bezierTangent()
	curve()
	curveDetail()
	curvePoint()
	curveTangent()
	curveTightness()*/

	// Matrix stuff ???
	// not usefull in HaxePunk context : rotating an Image is very simple !
	/*applyMatrix()
	popMatrix()
	printMatrix()
	pushMatrix()
	resetMatrix()
	rotate()
	rotateX()
	rotateY()
	rotateZ()
	scale()
	translate()*/



	// private stuff
	private static function applyStyle(){ // applies stroke/fill styles before drawing
		if(!complexMode_) HXP.sprite.graphics.clear();
		if(strokeThickness>0) HXP.sprite.graphics.lineStyle(strokeThickness, strokeColor, strokeAlpha);
		if(fillAlpha>0) HXP.sprite.graphics.beginFill(fillColor, fillAlpha);
		// on dessine un flash.display.Graphics natif
	}
	private static function endStyle(){
		if(fillAlpha>0) HXP.sprite.graphics.endFill();
	}
	private static function createGImage(w_:Float, h_:Float, rot:Float=0):GImage {
		// vector shape conversion to flash.display.BitmapData with the right size
		var data:BitmapData = HXP.createBitmap(
			Math.ceil(w_+2*strokeThickness), 
			Math.ceil(h_+2*strokeThickness), true, 0);

		var matrice:Matrix = new Matrix();
		//matrice.scale(iTest.scaleX, iTest.scaleY);
		/*matrice.translate(-(w_+2*strokeThickness)/2, -(h_+2*strokeThickness)/2);
		matrice.rotate( rot );
		matrice.translate(0,0);*/
		//matrice.translate(0, 0);

		data.draw(HXP.sprite, matrice);
		// -> haxepunk.graphics.GImage
		var image:GImage;
		if (HXP.renderMode == RenderMode.HARDWARE){
			image = new GImage(Atlas.loadImageAsRegion(data));
		} else {
			image = new GImage(data);
		}
		return image;
	}
	
}