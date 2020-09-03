using Toybox.Application as App;
using Toybox.System;

(:glance) class SkydivePoolApp extends App.AppBase {
    var pool;
    var poolSize;

    var draw;

    const nbFigures = 22 + 16;

    function initialize() {
        App.AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
        initPool();
        doDraw();
    }

    function initPool() {
        poolSize = nbFigures;
        pool = new [nbFigures];

        var offset = 0;
        for(var i = 1; i <= 22; i++)
        {
            pool[offset] = i;
            offset += 1;
        }

        for(var c = 'A'; c <= 'Q'; c++)
        {
            if(c != 'I')
            {
                pool[offset] = c;
                offset += 1;
            }
        }
    }

    function doDraw() {
        draw = "";
        var drawPoints = 0;

        while(drawPoints < 5)
        {
            if(poolSize == 0)
            {
                poolSize = nbFigures;
            }

            var r = Math.rand() % poolSize;
            var picked = pool[r];
            poolSize -= 1;

            // Remove from pool, move to the end
            pool[r] = pool[poolSize];
            pool[poolSize] = picked;

            if(drawPoints > 0)
            {
                draw += " ";
            }

            draw += picked.toString();

            if(picked instanceof Toybox.Lang.Number)
            {
                drawPoints += 2;
            }
            else
            {
                drawPoints += 1;
            }
        }
    }


    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    function getGlanceView() {
      return [ new SkydivePoolView(draw) ];
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ new SkydivePoolView(draw) ];
    }
}
