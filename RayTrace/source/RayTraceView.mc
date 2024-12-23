using Toybox.WatchUi;
using Toybox.Math;

class Complex
{
   var real;
   var imag;

   function initialize(r, i)
   {
        real = r;
        imag = i;
   }

   function square()
   {
       // (a + i b) * (a + i b)
       // == a*a - b * b + i * 2 * a * b
        var newReal = real * real - imag * imag;
        var newImag = 2 * real * imag;

        real = newReal;
        imag = newImag;
   }

   function add(o)
   {
       real = real + o.real;
       imag = imag + o.imag;
   }

   function abs2()
   {
       return real * real + imag * imag;
   }
}

class RayTraceView extends WatchUi.View {
    //var pixel;
    //var maxPixel;

    function initialize() {
        WatchUi.View.initialize();
    }

    function onLayout(dc)
    {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        //pixel = 0;
    }

    function onUpdate(dc) {
        var h = dc.getHeight();
        var w = dc.getWidth();

        /*
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(40, dc.getHeight() / 2, Graphics.FONT_MEDIUM, "Guibou", Graphics.TEXT_JUSTIFY_LEFT);

        dc.drawRectangle(w / 2, h / 2, w/2, h/2);
        */

        for(var dPx = 0; dPx < 50; dPx++)
        {
            // var x = (pixel % w).toFloat();
            // var y = (pixel / w).toFloat();

            var x = Math.rand() % w;
            var y = Math.rand() % h;

            var c = new Complex(1.8 * x / w - 1.2, 2.0 * y / h - 1.0);
            var z = new Complex(0, 0);

            var iter = 0;
            while(z.abs2() < 1 && iter < 20){
                z.square();
                z.add(c);
                iter++;
            }

            if(z.abs2() < 1)
            {
                dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
            }
            else
            {
                var greyLevel = 255 * iter / 20;
                var color = (greyLevel) + (greyLevel << 8) + (greyLevel << 16);
                dc.setColor(color, color);
            }

            dc.drawPoint(x, y);

            /*
            var color = (x * 256 / h) + ((y * 256 / h) << 8) + (255 << 16);
            dc.setColor(color, color);
            dc.drawPoint(x, y);
            */
            //pixel++;
        }

        /*
        if(x < w)
        {
            x++;
        }
        else
        {
            if(y == h)
            {
                return;
            }
            x = 0;
            y++;
        }
        */

        //if(pixel < w * h)
        //{
          requestUpdate();
        //}
    }
}
