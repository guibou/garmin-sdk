using Toybox.Application as App;
using Toybox.System;

(:glance) class SkydivePoolApp extends App.AppBase {
    var pool;
    var reservePool;
    var draw;

    function initialize() {
        App.AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
        initPool();
        doDraw();
    }

    function initPool() {
        reservePool = new [0];
        pool = new [0];

        for(var i = 1; i <= 22; i++)
        {
            pool.add(i);
        }

        for(var c = 'A'; c <= 'Q'; c++)
        {
            if(c != 'I')
            {
                pool.add(c);
            }
        }
    }

    function doDraw() {
        draw = "";
        var drawPoints = 0;

        while(drawPoints < 5)
        {
            if(pool.size() == 0)
            {
                pool = reservePool;
                reservePool = new [0];
            }

            var r = Math.rand() % pool.size();
            var picked = pool[r];
            pool.remove(picked); // O(n) I guess. That's awful!
            reservePool.add(picked);

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
