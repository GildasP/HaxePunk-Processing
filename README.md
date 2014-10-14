HaxePunk-Processing
===================

The Processing drawing API for OpenFL/HaxePunk - Vector shapes editing was never so easy !

Version 1.0 - You may even use it :)
------------------------------------

[Processing][1] (aka P5) has great simple tools to draw simple or complex vector shapes.

Doing the same with HaxePunk or OpenFL is really painfull, so here is the best of both !

Unreal vector drawing !
-----------------------

HaxePunk is more bitmap than vector oriented, so here the trick is to draw vectors, then the lib puts them together in an Image object (it uses BitmapData to do it).

You can choose to build an Image for every shape, or to group shapes in a single Image, and get a complex graphic.

After that, you just use this image as usual !

No more spritesheets and invasive assets, you can draw your sprites in real-time !

And it's just 1 .hx file to put in your project.

Easy to use
-----------

It's all static methods, so you can do fast things like this :

    addGraphic( P5.ellipse(70, 70, 70, 60) ); // x, y, W, H
    addGraphic( P5.rect(150, 70, 70, 60) ); // x, y, W, H
    addGraphic( P5.triangle(200, 75, 258, 30, 286, 95) ); // x1, y1, x2, y2, ...
    addGraphic( P5.quad(338, 31, 386, 20, 369, 63, 330, 76) ); // x1, y1, x2, y2, ...
    addGraphic( P5.line(430, 20, 485, 75) ); // x1, y1, x2, y2

or build a complex polygon like this :

    P5.beginShape();
    P5.vertex(20, 20);
    P5.vertex(40, 20);
    P5.vertex(40, 40);
    P5.vertex(60, 40);
    P5.vertex(60, 60);
    P5.vertex(20, 60);
    graphic = P5.endShape();

or combine multiple shapes in one Image like this :

    P5.complexMode(); // to trigger the complex mode
    P5.ellipse(L/2, H/2, L, H);
    P5.line(0, 0, L, H);
    P5.line(L, 0, 0, H);
    graphic = P5.getComplex(); // you get a cross on a circle !

The only thing to consider is this : while in complexe mode, the coordinates are no more relative to the stage, but to the Image you're (virtually) drawing in.
And the origin of these coordinates is the top-left corner of the image; sorry for that, it's because of the Flash drawing methods used to go from vector to bitmap.

Todo list
---------

 - Curves drawing (made easy in Processing)
 - Make it a real lib and not just 3 text files... (or not ?)

  [1]: http://www.processing.org/reference/        