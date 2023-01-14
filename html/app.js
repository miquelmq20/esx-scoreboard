QBScoreboard = {}

$(document).ready(function(){
    window.addEventListener('message', function(event) {
        switch(event.data.action) {
            case "open":
                QBScoreboard.Open(event.data);
                break;
            case "close":
                QBScoreboard.Close();
                break;
        }
    })
});

QBScoreboard.Open = function(data) {
    $(".scoreboard-block").fadeIn(150);
    $("#total-players").html("<p>"+data.players+"</p>");

    $(".ftp-police").html("<span>"+data.currentCops+"</span>");
    $(".ftp-ambu").html("<span>"+data.currentAmbu+"</span>");
    $(".ftp-mech").html("<span>"+data.currentMech+"</span>");

    if (data.currentAmbu == 0) {
        $(".stat-ems").html('<i class="fas fa-times"></i>');
    } else if (data.currentAmbu >= 1) {
        $(".stat-ems").html('<i class="fas fa-check"></i>');
    }

    if (data.currentMech == 0) {
        $(".stat-meca").html('<i class="fas fa-times"></i>');
    } else if (data.currentMech >= 1) {
        $(".stat-meca").html('<i class="fas fa-check"></i>');
    }

    $.each(data.requiredCops, function(i, category){
        var beam = $(".scoreboard-info").find('[data-type="'+i+'"]');
        var status = $(beam).find(".info-beam-status");

        if (category.busy) {
            $(status).html('<i class="fas fa-clock"></i>');
        } else if (data.currentCops >= category.minimum) {
            $(status).html('<i class="fas fa-check"></i>');
        } else {
            $(status).html('<i class="fas fa-times"></i>');
        }
    });
    
}

QBScoreboard.Close = function() {
    $(".scoreboard-block").fadeOut(150);
}