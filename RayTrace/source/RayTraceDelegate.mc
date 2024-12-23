using Toybox.WatchUi;

class InputDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        WatchUi.BehaviorDelegate.initialize();
    }

    function onMenu() {
        timer1.stop();
        return true;
    }
}
