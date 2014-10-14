package scenes;

import com.haxepunk.Scene;
import ghxp.P5;
import com.haxepunk.graphics.Image; // for the buddy var

class Playground extends Scene {

    var stuff:Image;
    var buddy:Image;

    public function new(){ super();

        // setting color styles
        P5.fill(0x000000, 0.5); // semi-transparent black
        P5.stroke(0xFFFFFF);

        // drawing simple shapes
        addGraphic( P5.ellipse(70, 70, 70, 60) );
        addGraphic( P5.rect(150, 70, 70, 60) );
        addGraphic( P5.triangle(200, 75, 258, 30, 286, 95) );
        addGraphic( P5.quad(338, 31, 386, 20, 369, 63, 330, 76) );
        addGraphic( P5.line(430, 20, 485, 75) );

        // changing drawing style
        P5.fill(0xFFF000);
        P5.stroke(0x000000);

        // drawing a polygon
        P5.beginShape();
        P5.vertex(120, 220);
        P5.vertex(140, 220);
        P5.vertex(140, 240);
        P5.vertex(160, 240);
        P5.vertex(160, 260);
        P5.vertex(120, 260);
        addGraphic( P5.endShape() );

        // drawing a random polygon (bonus)
        var poly = P5.randomPolygon(100, 100, 7); // 100x100 px and 7 summits
        poly.x = 500; poly.y = 250;
        addGraphic(poly);

        // new drawing style
        P5.fill(0xFF3300);

        // what if you want to build a complex single graphic, with few shapes in it ?
        P5.complexMode(); // toggle to complex shape mode... and relative coordinates (relative to top-left corner of image, due to Flash graphic engine)
        var L = 40;
        var H = 40;
        P5.ellipse(L/2, H/2, L, H);
        P5.line(0, 0, L, H);
        P5.line(L, 0, 0, H);
        stuff = P5.getComplex(L, H); // you get a cross on a circle !
        stuff.x = 200; stuff.y = 200;
        addGraphic(stuff);

        // and another one
        P5.complexMode(); // toggle to complex shape mode... and relative coordinates (relative to top-left corner of image, due to Flash graphic engine)
        
        P5.rect(31, 61, 20, 100);
        P5.ellipse(31, 31, 60, 60);
        P5.fill(0xFFFFFF); // white eyes :)
        P5.ellipse(12, 31, 16, 32); 
        P5.ellipse(50, 31, 16, 32); 
        P5.fill(0xFF3300); // back to orange
        P5.line(21, 111, 11, 121);
        P5.line(41, 111, 51, 121);
        P5.line(21, 67, 6, 67);
        P5.line(41, 67, 56, 67);

        P5.beginShape(); // even polygons can be used in complex mode
        P5.vertex(24, 64);
        P5.vertex(38, 64);
        P5.vertex(31, 78);
        P5.endShape();

        buddy = P5.getComplex(); // you get a buddy image, with its origin centered
        buddy.x = 300; buddy.y = 200;
        addGraphic(buddy);
    }

    // to animate a bit, and show how complex shapes is REALLY rendered in single Image objects
    /*public override function update(){ super.update();
        stuff.x --; stuff.y --;
        stuff.angle ++;
        limitPos(stuff);

        buddy.x ++; buddy.y ++;
        buddy.angle --;
        limitPos(buddy);
    }
    private function limitPos(img:Image){
        if(img.x > 700) img.x = -100;
        if(img.y > 500) img.y = -100;
        if(img.x < -100) img.x = 700;
        if(img.y < -100) img.y = 500;
    }*/
}