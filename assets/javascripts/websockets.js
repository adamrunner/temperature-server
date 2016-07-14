window.onload = function(){
  (function(){
    var show = function(el){

      return function(msg){
        var data = JSON.parse(msg)
        var html = data.map(function(string){
          return JST['show_row']({show: string})
        });
        $("#current_shows").html(html)
      }
    }();

    var ws       = new WebSocket('ws://' + window.location.host + window.location.pathname);

    ws.onclose   = function()  { console.log('websocket closed'); }
    ws.onmessage = function(m) { show(m.data); };

  })();
}
