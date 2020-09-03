using Toybox.WatchUi;
using Toybox.Math;
using Toybox.Lang;
using Toybox.Math;

(:glance) class SkydivePoolView extends WatchUi.View {
    var drawText;

    function initialize(d) {
        WatchUi.View.initialize();
        drawText = d;
    }

    /*
    function onLayout(dc)
    {
    }

    function onShow()
    {
    }
    */

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        dc.drawText(
            dc.getWidth() / 2,
            dc.getHeight() / 2,
            Graphics.FONT_LARGE,
            drawText,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER

        );
    }
}
