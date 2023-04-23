Events.Subscribe("UpdateCharPos", function(updatedPos){
    document.getElementById('position').innerHTML = "Pos: " + updatedPos;
})