(function ($) {
    var $t = $.easyui;
    $t.scripts.push("easyui.menu.js");
    $t.menu = function (e, element) {
        this.element = e;
        this.nextItemZIndex = 100;
        $.extend(this, element);
        $(".t-item:not(.t-state-disabled)", e).live("mouseenter", $t.delegate(this, this.mouseenter)).live("mouseleave", $t.delegate(this, this.mouseleave)).live("click", $t.delegate(this, this.click));
        $(".t-item:not(.t-state-disabled) > .t-link", e).live("mouseenter", $t.hover).live("mouseleave", $t.leave);
        $(".t-item.t-state-disabled", e).live("click", function () {
            return false
        });
        $(document).click($t.delegate(this, this.documentClick));
        $t.bind(this, {
            select: this.onSelect,
            open: this.onOpen,
            close: this.onClose,
            load: this.onLoad
        })
    };

    function getEffectOptions(e) {
        var element = e.parent();
        return {
            direction: element.hasClass("t-menu") ? element.hasClass("t-menu-vertical") ? "right" : "bottom" : "right"
        }
    }
    function contains(h, element) {
        try {
            return $.contains(h, element)
        } catch (options) {
            return false
        }
    }
    $t.menu.prototype = {
        toggle: function (element, e) {
            $(element).each(function () {
                $(this).toggleClass("t-state-default", e).toggleClass("t-state-disabled", !e)
            })
        },
        enable: function (e) {
            this.toggle(e, true)
        },
        disable: function (e) {
            this.toggle(e, false)
        },
        open: function (e) {
            var element = this;
            $(e).each(function () {
                var options = $(this);
                clearTimeout(options.data("timer"));
                options.data("timer", setTimeout(function () {
                    var h = options.find(".t-group:first");
                    if (h.length) {
                        $t.fx.play(element.effects, h, getEffectOptions(options));
                        options.css("z-index", element.nextItemZIndex++)
                    }
                }, 100))
            })
        },
        close: function (e) {
            var element = this;
            $(e).each(function (h, i) {
                var options = $(i);
                clearTimeout(options.data("timer"));
                options.data("timer", setTimeout(function () {
                    var j = options.find(".t-group:first");
                    if (j.length) {
                        $t.fx.rewind(element.effects, j, getEffectOptions(options), function () {
                            options.css("zIndex", "");
                            if ($(element.element).find(".t-group:visible").length == 0) {
                                element.nextItemZIndex = 100
                            }
                        });
                        j.find(".t-group").stop(false, true)
                    }
                }, 100))
            })
        },
        mouseenter: function (options, h) {
            var element = $(h);
            if (!this.openOnClick || this.clicked) {
                if (!contains(h, options.relatedTarget)) {
                    this.triggerEvent("open", element);
                    this.open(element);
                    var i = element.parent().closest(".t-item")[0];
                    if (i && !contains(i, options.relatedTarget)) {
                        this.mouseenter(options, i)
                    }
                }
            }
            if (this.openOnClick && this.clicked) {
                this.triggerEvent("close", element);
                element.siblings().each($.proxy(function (e, j) {
                    this.close($(j))
                }, this))
            }
        },
        mouseleave: function (options, h) {
            if (!this.openOnClick && !contains(h, options.relatedTarget)) {
                var element = $(h);
                this.triggerEvent("close", element);
                this.close(element);
                var i = element.parent().closest(".t-item")[0];
                if (i && !contains(i, options.relatedTarget)) {
                    this.mouseleave(options, i)
                }
            }
        },
        click: function (options, h) {
            if (!options.ctrlKey) {
                options.stopPropagation()
            }
            var element = $(h);
            var i = element.find(".t-link").attr("href");
            var j = (!!i && i.charAt(i.length - 1) != "#");
            if (element.hasClass("t-state-disabled")) {
                options.preventDefault();
                return
            }
            if ($t.trigger(this.element, "select", {
                item: element[0]
            })) {
                options.preventDefault();
                return
            }
            if (!element.parent().hasClass("t-menu") || !this.openOnClick) {
                return
            }
            if (!j) {
                options.preventDefault()
            }
            this.clicked = true;
            this.triggerEvent("open", element);
            this.open(element)
        },
        documentClick: function (element, options) {
            if ($.contains(this.element, element.target)) {
                return
            }
            if (this.clicked) {
                this.clicked = false;
                $(this.element).children(".t-item").each($.proxy(function (e, h) {
                    this.close($(h))
                }, this))
            }
        },
        hasChildren: function (e) {
            return e.find(".t-group:first").length
        },
        triggerEvent: function (element, e) {
            if (this.hasChildren(e)) {
                $t.trigger(this.element, element, {
                    item: e[0]
                })
            }
        }
    };
    $.fn.tMenu = function (e) {
        return $t.create(this, {
            name: "tMenu",
            init: function (element, options) {
                return new $t.menu(element, options)
            },
            options: e
        })
    };
    $.fn.tMenu.defaults = {
        orientation: "horizontal",
        effects: $t.fx.slide.defaults(),
        openOnClick: false
    }
})(jQuery);