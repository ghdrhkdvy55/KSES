// Plugin: jQuery.dragmove
// Source: github.com/nathco/jQuery.dragmove
// Author: Nathan Rutzky
// Update: 1.0

(function ($) {
    $.fn.dragmove = function () {
        return this.each(function () {
            var $document = $(document),
                $this = $(this),
                active,
                startX,
                startY;
            $this.on('mousedown touchstart', function (e) {
                active = true;
                startX = e.originalEvent.pageX - $this.offset().left;
                startY = e.originalEvent.pageY - $this.offset().top;
                if ('mousedown' == e.type)
                    click = $this;
                if ('touchstart' == e.type)
                    touch = $this;
                if (window.mozInnerScreenX == null)
                    return false;
            });

            $document.on('mousemove touchmove', function (e) {
                if ('mousemove' == e.type && active){
                	click.offset({
                		left: e.originalEvent.pageX - startX,
                		top: e.originalEvent.pageY - startY
                	});
                	var obj = e.target;
                	var get_id = obj.id;
                	var top_id = 'top_' + $('#'+get_id)[0].attributes.name.value;
                	var left_id ='left_' + $('#'+get_id)[0].attributes.name.value;
                	
//                	console.log('name : ', $('#'+get_id)[0].attributes.name.value);
//                	console.log('top : ', obj.style.top + ', left : ', obj.style.left);
                	$('#'+top_id).val(obj.style.top.replace('px', ''));
                	$('#'+left_id).val(obj.style.left.replace('px', ''));
                	
                	
                	
                }
                if ('touchmove' == e.type && active)
                    touch.offset({
                        left: e.originalEvent.pageX - startX,
                        top: e.originalEvent.pageY - startY
                    });

            }).on('mouseup touchend', function () {
                active = false;
            });
        });
    };
})(jQuery);