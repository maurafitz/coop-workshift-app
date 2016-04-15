(function () {
    (function ($) {
        return $.fn.fixedHeader = function (options) {
            var config;
            config = {
                topOffset: 40,
                bgColor: '#EEEEEE'
            };
            if (options) {
                $.extend(config, options);
            }
            return this.each(function () {
                var $head, $win, headTop, isFixed, o, processScroll, ww;
                processScroll = function () {
                    var headTop, i, isFixed, scrollTop, t;
                    if (!o.is(':visible')) {
                        return;
                    }
                    i = void 0;
                    scrollTop = $win.scrollTop();
                    t = $head.length && $head.offset().top - config.topOffset;
                    if (!isFixed && headTop !== t) {
                        headTop = t;
                    }
                    if (scrollTop >= headTop && !isFixed) {
                        isFixed = 1;
                    } else {
                        if (scrollTop <= headTop && isFixed) {
                            isFixed = 0;
                        }
                    }
                    if (isFixed) {
                        return $('thead.header-copy', o).removeClass('hide');
                    } else {
                        return $('thead.header-copy', o).addClass('hide');
                    }
                };
                o = $(this);
                $win = $(window);
                $head = $('thead.header', o);
                isFixed = 0;
                headTop = $head.length && $head.offset().top - config.topOffset;
                $win.on('scroll', processScroll);
                $head.on('click', function () {
                    if (!isFixed) {
                        return setTimeout(function () {
                            return $win.scrollTop($win.scrollTop() - 47);
                        }, 10);
                    }
                });
                $head.clone().removeClass('header').addClass('header-copy header-fixed').appendTo(o);
                ww = [];
                o.find('thead.header > tr:first > th').each(function (i, h) {
                    return ww.push($(h).width() + 12);
                });
                $.each(ww, function (i, w) {
                    return o.find('thead.header > tr > th:eq(' + i + '), thead.header-copy > tr > th:eq(' + i + ')').css({ width: w });
                });
                o.find('thead.header-copy').css({
                    margin: '0 auto',
                    width: o.width(),
                    'background-color': config.bgColor
                });
                return processScroll();
            });
        };
    }(jQuery));
}.call(this));