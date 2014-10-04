HaxePunk-Processing
===================

The Processing drawing API for OpenFL-HaxePunk - Vector shapes editing was never so easy !

This is a beta version - but it works, I already use it :)
----------------------------------------

[Processing][1] has great simple tools to draw simple or complex vector shapes.

Doing the same with HaxePunk or OpenFL is really painfull, so here is the best of both !

Unreal vector drawing !
-----------------------

HaxePunk is more bitmap than vector oriented, so here the trick is to draw vectors, then the lib puts them together in an Image object (it uses BitmapData to do it).

You can choose to build an Image for every shape, or to group shapes in a single Image, and get a complex graphic.

After that, you just use this image as usual !

No more spritesheets and invasive assets, you can draw your sprites in real-time !

Easy to use
-----------

It's all static methods, so you can do fast things like this :

    graphic = P5.ellipse(0, 0, 100, 75);

or build a complex polygon like this :

    P5.beginShape();
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
    graphic = GP5.getComplex(L, H); // you get a cross on a circle !

Todo list
---------

 - Code cleanup !
 - Remove the GImage dependency ? it's a tool I find usefull, but it's not needed to use this lib...
 - Curves with bezier stuff; it would be really usefull
 - Make it a real lib and not just 3 text files...

  [1]: http://www.processing.org/reference/        