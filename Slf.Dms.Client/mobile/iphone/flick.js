var touching, dPrevious, dCurrent, dNext, oX;

// Whether or not the finger is touching the screen
touching = false;

// Original X-coordinate
oX = 0;

// Initial page numbers
dPrevious = 0;
dCurrent = 1;
dNext = 2;

// Apple iPhone Touch API events
document.addEventListener('touchstart', touchHandler, false);
document.addEventListener('touchmove', touchHandler, false);
document.addEventListener('touchend', touchHandler, false);
document.addEventListener('touchcancel', touchHandler, false);

// The handler for all Apple iPhone Touch API events
function touchHandler(e) {
    // If the user has started a touch event
    if (e.type == "touchstart") {
        touching = true;
        // If there's only one finger touching
        if (e.touches.length == 1) {
            var touch = e.touches[0];
            // If they user tries clicking on a link
            if (touch.target.onclick) {
                touch.target.onclick();
            }
            // The originating X-coord (point where finger first touched the screen)
            oX = touch.pageX;
            // Reset default values for current X-coord and scroll distance
            nX = 0;
            scrollX = 0;
            /* Debugging */document.getElementById('dir').innerHTML = 'Direction: Null';
            /* Debugging */document.getElementById('oX').innerHTML = 'Start X-Coord: ' + oX + 'px';
        }
    }
    // If the user has touched the screen and moved the finger
    else if (e.type == "touchmove") {
        // Prevent the default scrolling behaviour (notice: This disables vertical scrolling as well)
        e.preventDefault();

        // If there's only one finger touching
        if (e.touches.length == 1) {
            var touch = e.touches[0];
            // The current X-coord of the users finger
            var nX = touch.pageX;
            /* Debugging */document.getElementById('nX').innerHTML = 'Current X-Coord: ' + nX + 'px';

            // If the user moved the finger from the right to the left
            if (oX > nX) {
                // Find the scrolling distance
                var scrollX = oX - nX;
                /* Debugging */document.getElementById('scrollX').innerHTML = 'Scroll Distance: ' + scrollX + 'px';
                // If the user scrolled more than 100 pixels
                if (scrollX > 100) {
                    /* Debugging */document.getElementById('dir').innerHTML = 'Direction: Flicked Left';
                    // If the next DIV exists then continue
                    if (document.getElementById('Div' + dNext)) {
                        // If this is still from the original touch
                        if (touching == true) {
                            // End the current touch
                            touching = false;
                            // Move in the next DIV
                            switchNext(dCurrent, dNext);
                            // Recalculate the pages
                            dPrevious = dCurrent;
                            dCurrent = dNext;
                            dNext = dNext + 1;
                            /* Debugging */alertIt();
                        }
                    }
                }
                // If the user moved the finger from the left to the right
            } else {
                // Find the scrolling distance
                var scrollX = nX - oX;
                /* Debugging */document.getElementById('scrollX').innerHTML = 'Scroll Distance: ' + scrollX + 'px';
                // If the user scrolled more than 100 pixels
                if (scrollX > 100) {
                    /* Debugging */document.getElementById('dir').innerHTML = 'Direction: Flicked Right';
                    // If the previous page isn't 0, in other words there's a previous page to the left
                    if (dPrevious != 0) {
                        // If this is still from the original touch
                        if (touching == true) {
                            // End the current touch
                            touching = false;
                            // Move in the previous DIV
                            switchPrevious(dCurrent, dPrevious);
                            // Recalculate the pages
                            dNext = dCurrent;
                            dCurrent = dPrevious;
                            dPrevious = dPrevious - 1;
                            /* Debugging */alertIt();
                        }
                    }
                }
            }
        }
    }
    // If the user has removed the finger from the screen
    else if (e.type == "touchend" || e.type == "touchcancel") {
        // Defines the finger as not touching
        touching = false;
    }
}
// If the user requests the page to the right of the screen ('next' DIV)
function switchNext(divOut, divIn) {
    // Show the DIV to the right
    document.getElementById('Div' + divIn).style.display = 'block';
    // Move the currently displaying DIV from Center to Left
    document.getElementById('Div' + divOut).className = 'divCtL';
    // Move the requested DIV from the Right to Center
    document.getElementById('Div' + divIn).className = 'divRtC';
    // For some reason the animation doesn't stick after exiting this function, so force the off-screen location
    document.getElementById('Div' + divOut).style.left = '-490px';
    // For some reason the animation doesn't stick after exiting this function, so force the on-screen location
    document.getElementById('Div' + divIn).style.left = '10px';
}
// If the user requests the page to the left of the screen ('previous' DIV)
function switchPrevious(divOut, divIn) {
    // Show the DIV to the left
    document.getElementById('Div' + divIn).style.display = 'block';
    // Move the currently displaying DIV from Center to Right
    document.getElementById('Div' + divOut).className = 'divCtR';
    // Move the requested DIV from the Left to Center
    document.getElementById('Div' + divIn).className = 'divLtC';
    // For some reason the animation doesn't stick after exiting this function, so force the off-screen location
    document.getElementById('Div' + divOut).style.left = '490px';
    // For some reason the animation doesn't stick after exiting this function, so force the on-screen location
    document.getElementById('Div' + divIn).style.left = '10px';
}
/* Debug Results Display DIV */
function alertIt() {
    document.getElementById('divPrev').innerHTML = 'Previous Page: ' + dPrevious;
    document.getElementById('divCurrent').innerHTML = 'Current Page: ' + dCurrent;
    document.getElementById('divNext').innerHTML = 'Next Page: ' + dNext;
}