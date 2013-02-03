;(function($) {
  $.fn.idfix_picture_widget = function(options){
    var $widget = $(this);

    var $options = $.extend($.fn.idfix_picture_widget.defaults, options || {});

    $widget.wrapInner('<div><div><div></div></div></div>').
      children("div").addClass('previews').
      children('div').addClass('container').
      before('<div class="previous_button"></div><div class="next_button"></div>').
      children('div').addClass('list').width(30000);

    var $previews           = $widget.children(".previews");
    var $previews_pictures  = $previews.children(".container");
    var $previews_previous  = $previews.children(".previous_button");
    var $previews_next      = $previews.children(".next_button");

    var $list_width = 0;
    var $current_scroll = 0;

    var check_preview_buttons = function(){
      if($current_scroll == 0){
        $previews_previous.addClass("disabled");
      } else {
        $previews_previous.removeClass("disabled");
      }

      if($current_scroll >= $list_width - $previews_pictures.outerWidth()){
        $previews_next.addClass("disabled");
      } else {
        $previews_next.removeClass("disabled");
      }
    };

    var scroll_preview_to = function(picture){
      var prev_width = 0;

      picture.prevAll(".picture").each(function(){
        prev_width += $(this).outerWidth();
      });

      $previews_pictures.scrollLeft(prev_width);
      $current_scroll = $previews_pictures.scrollLeft();
      check_preview_buttons();
    };

    $previews_next.click(function(){
      $previews_pictures.scrollLeft($current_scroll + $previews_pictures.outerWidth());
      $current_scroll = $previews_pictures.scrollLeft();
      check_preview_buttons();
    });

    $previews_previous.click(function(){
      $previews_pictures.scrollLeft($current_scroll - $previews_pictures.outerWidth());
      $current_scroll = $previews_pictures.scrollLeft();
      check_preview_buttons();
    });

    if($options.full_size){
      var full_size_code = '<div class="full_size"><div class="previous_button"></div><div class="next_button"></div><div class="container"></div></div>';

      if($options.full_size_first){
        $widget.prepend(full_size_code);
      }else{
        $widget.append(full_size_code);
      }

      var $full_size          = $widget.children(".full_size");
      var $full_size_picture  = $full_size.children(".container");
      var $full_size_previous = $full_size.children(".previous_button");
      var $full_size_next     = $full_size.children(".next_button");

      var check_full_size_buttons = function(){
        if($previews.find('.current').prev().length == 0){
          $full_size_previous.addClass("disabled");
        } else {
          $full_size_previous.removeClass("disabled");
        }

        if($previews.find('.current').next().length == 0){
          $full_size_next.addClass("disabled");
        } else {
          $full_size_next.removeClass("disabled");
        }
      }

      var resize_full_size_buttons = function(){
        var header_height = $full_size_picture.children("h2").outerHeight();
        var container_height = $full_size_picture.innerHeight();

        $full_size_previous.height(container_height - header_height).css("margin-top", header_height);
        $full_size_next.height(container_height - header_height).css("margin-top", header_height);
      }

      $previews.find(".picture").click(function(){
        $full_size_picture.html(
          $('<img />').
            attr('src', $(this).attr('full_size')).
            attr('alt', $(this).children('img').attr('alt')).
            load(resize_full_size_buttons)
        )
        if($(this).attr('title')){
          $full_size_picture.prepend(
            $("<h2>" + $(this).attr('title') + "</h2>")
          );
        }

        $(this).siblings().removeClass('current');
        $(this).addClass('current');
        
        check_full_size_buttons();
      });

      $full_size_next.click(function(){
        scroll_preview_to($previews.find('.current').next().eq(0).click());
      })

      $full_size_previous.click(function(){
        scroll_preview_to($previews.find('.current').prev().eq($previews.find('.current').prev().length - 1).click());
      });

      $previews.find(".picture").eq(0).click();

    }

    $widget.show();

    // Measuring picture list width
    $previews_pictures.find('.picture').each(function(){
      $list_width += $(this).outerWidth();
    });
    $previews_pictures.children('.list').css({width: $list_width});
    
    check_preview_buttons();
  };

  $.fn.idfix_picture_widget.defaults = {
    full_size: true
  }
})(jQuery);
