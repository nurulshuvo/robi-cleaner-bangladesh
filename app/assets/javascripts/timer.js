var settimmer = 0;
$(function () {
    window.setInterval(function () {
        var timeCounter = parseInt($("b#show-time").html())

        if (parseInt(timeCounter) >= -1) {

            var updateTime = eval(timeCounter) - eval(1);
            $("b#show-time").html(updateTime)

            if (updateTime < 1) {
                $("b#show-time").html('0')
            }

            if (updateTime == 0) {
                alert("Times Up!")
                window.location = ("/facebook/invite")
            }
        }
    }, 1000);

});
