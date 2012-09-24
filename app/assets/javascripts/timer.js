var settimmer = 0;
$(function(){
    window.setInterval(function() {
        var timeCounter = $("b[id=show-time]").html();
        var updateTime = eval(timeCounter)- eval(1);
        $("b[id=show-time]").html(updateTime);

        if(updateTime == 0){
            window.location = ("invite");

        }

    }, 1000);

});
