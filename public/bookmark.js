$(function() {
  var styles = ""+
    ".bkbk { "+
      "font-family: Helvetica Neue, sans-serif; "+
      "font-size: 13px;"+
      "position:fixed; "+
      "width: 260px; "+
      "height: 100%; "+
      "padding: 20px; "+
      "overflow-x: hidden; "+
      "overflow-y: auto; "+
      "z-index: 9999;" +
      "top: 0; "+
      "left: -305px; "+
      "-webkit-box-shadow: 3px 0 3px rgba(0,0,0,0.1); "+
      "background-color: #eeeeee; }"+
    ".bkbk a {"+
      "color: #336699;"+
      "text-decoration: none; }"+
    ".bkbk a:hover {"+
      "color: #000000;"+
      "text-decoration: underline; }"+
    ".bkbk ul {"+
      "margin: 0;"+
      "padding: 0;"+
      "list-style: none; }"+
    ".bkbk-close {"+
      "display: block;"+
      "font-size: 20px;"+
      "float: right;"+
      "line-height: 1;"+
      "margin: -15px -10px 0 0; }"+
    "a.bkbk-close:hover {"+
      "text-decoration: none; }";

  // Create style wrapper
  var style = $('<style>').attr('type','text/css').text(styles);
  
  // Create bookmark container and list
  var list = $('<div>').attr('class','bkbk').html('<ul><li><a href="//google.com">Google</a></li></ul>');
  list.prepend('<a href="#" class="bkbk-close">&times;</a>');

  // Add bookmark styles and contents to page
  $('body').prepend(style).prepend(list);
  
  // Add the close button and setup click handling
  $('.bkbk-close').on('click', function(e) {
    list.animate({'left':'-305px'}, 500, 'ease');
    e.preventDefault();
  });
  
  // Finally, show the list
  list.animate({'left':'0'}, 500, 'ease');

});
