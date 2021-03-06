(function (a) {
    var b = a.easyui;
    var c = /'/ig;
    var d = b.fx.slide.defaults();
    b.scripts.push("easyui.grid.filtering.js");

    function e(g) {
        if (!g.format) {
            return b.cultureInfo.shortDate
        }
        return /\{0(:([^\}]+))?\}/.exec(g.format)[2]
    }
    function f(g, h) {
        if (g.type == "Date") {
            if (!(h instanceof Date)) {
                h = new Date(parseInt(h.replace(/\/Date\((.*?)\)\//, "$1")))
            }
            return b.formatString(g.format || "{0:G}", h)
        }
        return h
    }
    b.filtering = {};
    b.filtering.initialize = function (g) {
        a.extend(g, b.filtering.implementation);
        g.filterBy = g.filterExpr();
        a("> .t-grid-content", g.element).bind("scroll", function () {
            g.hideFilter()
        });
        a(document).click(function (h) {
            if (h.which != 3) {
                g.hideFilter()
            }
        });
        g.$header.find(".t-grid-filter").click(a.proxy(g.showFilter, g)).hover(function () {
            a(this).toggleClass("t-state-hover")
        })
    };
    b.filtering.implementation = {
        createFilterCommands: function (i, g) {
            var h = [];
            a.each(this.localization, function (k, m) {
                var l = "filter" + (g.data ? "ForeignKey" : g.type);
                var j = k.indexOf(l);
                if (j > -1) {
                    h.push({
                        key: k.substring(j + l.length).toLowerCase(),
                        value: m
                    })
                }
            });
            if (g.type == "String") {
                if (h[0].key !== "eq") {
                    h.push(h.shift())
                }
            }
            i.cat('<select class="t-filter-operator">');
            a.each(h, function (k, j) {
                i.cat('<option value="').cat(j.key).cat('">').cat(j.value).cat("</option>")
            });
            i.cat("</select>")
        },
        createTypeSpecificInput: function (i, g, h, j) {
            if (g.data) {
                i.cat("<div><select><option>").cat(this.localization.filterSelectValue).cat("</option>");
                a.each(g.data, function () {
                    i.cat('<option value="').cat(this.Value).cat('">').cat(this.Text).cat("</option>")
                });
                i.cat("</select></div>")
            } else {
                if (g.type == "Date") {
                    i.cat('<div class="t-widget t-datepicker"><div class="t-picker-wrap">').cat('<input class="t-input" id="').cat(h).cat('" type="text" value="" />').cat('<span class="t-select"><label class="t-icon t-icon-calendar" for="').cat(h).cat('" title="').cat(this.localization.filterOpenPopupHint).cat('" /></span></div></div>')
                } else {
                    if (g.type == "Boolean") {
                        i.cat('<div><input type="radio" style="width:auto;display:inline" id="').cat(h + j).cat('" name="').cat(h).cat('" value="').cat(j).cat('" />').cat('<label style="display:inline" for="').cat(h + j).cat('">').cat(this.localization[j ? "filterBoolIsTrue" : "filterBoolIsFalse"]).cat("</label></div>")
                    } else {
                        if (g.type == "Enum") {
                            i.cat("<div><select><option>").cat(this.localization.filterSelectValue).cat("</option>");
                            a.each(g.values, function (k, l) {
                                i.cat('<option value="').cat(l).cat('">').cat(k).cat("</option>")
                            });
                            i.cat("</select></div>")
                        } else {
                            if (g.type == "Number") {
                                i.cat('<div class="t-widget t-numerictextbox">').cat('<input class="t-input" name="').cat(h).cat('" id="').cat(h).cat('" type="text" value=""/>').cat("</div>")
                            } else {
                                i.cat('<input type="text" />')
                            }
                        }
                    }
                }
            }
        },
        createFilterMenu: function (h) {
            var j = new b.stringBuilder();
            j.cat('<div class="t-animation-container"><div class="t-filter-options t-group t-popup" style="display:none">').cat('<button class="t-button t-button-icontext t-button-expand t-clear-button"><span class="t-icon t-clear-filter"></span>').cat(this.localization.filterClear).cat('</button><div class="t-filter-help-text">').cat(this.localization.filterShowRows).cat("</div>");
            var i = a(this.element).attr("id") + h.member;
            if (h.type == "Boolean") {
                this.createTypeSpecificInput(j, h, i, true);
                this.createTypeSpecificInput(j, h, i, false)
            } else {
                this.createFilterCommands(j, h);
                this.createTypeSpecificInput(j, h, i + "first");
                if (this.showOrOption) {
                    j.cat('<select class="t-filter-logic">').cat('<option value="and">' + this.localization.filterAnd + "</option>").cat('<option value="or">' + this.localization.filterOr + "</option>").cat("</select>")
                } else {
                    j.cat('<div class="t-filter-help-text">').cat(this.localization.filterAnd).cat("</div>")
                }
                this.createFilterCommands(j, h);
                this.createTypeSpecificInput(j, h, i + "second")
            }
            j.cat('<button class="t-button t-button-icontext t-button-expand t-filter-button"><span class="t-icon t-filter"></span>').cat(this.localization.filter).cat("</button></div></div>");
            var g = a(j.string());
            var k = h.filters || [];
            k = k.length && k[0].logic ? k[0].filters : k;
            a.each(k, function (l) {
                g.find(".t-filter-operator:eq(" + l + ")").val(this.operator).end().find(":text:eq(" + l + "),select:not(.t-filter-operator):eq(" + l + ")").val(f(h, this.value));
                if (h.type == "Boolean") {
                    g.find(":radio[id$=" + this.value + "]").attr("checked", true)
                }
            });
            return g.appendTo(this.element).find(".t-datepicker .t-input").each(function () {
                a(this).tDatePicker({
                    format: e(h)
                })
            }).end().find(".t-numerictextbox .t-input").each(function () {
                a(this).tTextBox({
                    type: "numeric",
                    minValue: null,
                    maxValue: null,
                    numFormat: "",
                    groupSeparator: ""
                })
            }).end()
        },
        showFilter: function (k) {
            k.stopPropagation();
            var g = a(k.target).closest(".t-grid-filter");
            this.hideFilter(function () {
                return this.parentNode != g[0]
            });
            var h = g.data("filter");
            if (!h) {
                var i = this.columns[this.$columns().index(g.parent())];
                h = this.createFilterMenu(i).data("column", i).click(function (s) {
                    s.stopPropagation();
                    if (a(s.target).parents(".t-datepicker").length == 0) {
                        a(".t-datepicker .t-input", this).each(function () {
                            a(this).data("tDatePicker").hidePopup()
                        })
                    }
                }).find(".t-filter-button").click(a.proxy(this.filterClick, this)).end().find(".t-clear-button").click(a.proxy(this.clearClick, this)).end().find("input[type=text]").keydown(a.proxy(function (s) {
                    if (s.keyCode == 13) {
                        this.filterClick(s)
                    }
                }, this)).end();
                g.data("filter", h)
            }
            var q = 0;
            a(this.element).find("> .t-grouping-header, > .t-grid-toolbar").add(this.$header).each(function () {
                q += this.offsetHeight
            });
            var p = {
                top: q
            };
            var m = a(this.element).closest(".t-rtl").length;
            var l = this.$headerWrap.scrollLeft();
            var r = !m ? -l - 1 : l - 1;
            g.parent().add(g.parent().prevAll("th")).each(function () {
                if (a(this).css("display") != "none") {
                    r += this.offsetWidth
                }
            });
            var n = r - g.outerWidth();
            var o = h.outerWidth() || h.find(".t-group").outerWidth();
            if (n + o > this.$header.closest(".t-grid-header").innerWidth()) {
                n = r - o + 1
            }
            if (m) {
                var j = ((a.browser.mozilla && parseInt(a.browser.version, 10) < 2) || a.browser.webkit) ? 18 : 0;
                p.right = n + j
            } else {
                p.left = n
            }
            h.css(p);
            b.fx[h.find(".t-filter-options").is(":visible") ? "rewind" : "play"](d, h.find(".t-filter-options"), {
                direction: "bottom"
            })
        },
        hideFilter: function (g) {
            g = g ||
			function () {
			    return true
			};
            a(".t-grid .t-animation-container").find(".t-datepicker .t-input").each(function () {
                a(this).data("tDatePicker").hidePopup()
            }).end().find(".t-filter-options").filter(g).each(function () {
                b.fx.rewind(d, a(this), {
                    direction: "bottom"
                })
            })
        },
        clearClick: function (i) {
            i.preventDefault();
            var g = a(i.target);
            var h = g.closest(".t-animation-container").data("column");
            h.filters = null;
            g.closest(".t-filter-options").find(".t-numerictextbox .t-input").each(function () {
                a(this).data("tTextBox").value("")
            }).end().find("input").removeAttr("checked").removeClass("t-state-error").not(":radio").val("").end().end().find("select").removeClass("t-state-error").find("option:first").attr("selected", "selected");
            this.filter(this.filterExpr());
            this.hideFilter()
        },
        filterClick: function (i) {
            i.preventDefault();
            var g = a(i.target);
            var h = g.closest(".t-animation-container").data("column");
            h.filters = [];
            var k = false;
            var j = h.filters;
            if (this.showOrOption) {
                h.filters = [{
                    logic: g.closest(".t-filter-options").find("select.t-filter-logic").val() || "and",
                    filters: j
                }]
            }
            g.closest(".t-filter-options").find("input[type=text]:visible,select:not(.t-filter-operator,.t-filter-logic)").each(a.proxy(function (m, n) {
                var l = a(n);
                var r = a.trim(l.val());
                if (!r) {
                    l.removeClass("t-state-error");
                    return true
                }
                var q = this.isValidFilterValue(h, r);
                l.toggleClass("t-state-error", !q);
                if (!q) {
                    k = true;
                    return true
                }
                var o = l.data("tTextBox");
                if (o) {
                    r = o.value()
                }
                if (h.type === "Enum" && r != this.localization.filterSelectValue) {
                    r = parseInt(r, 10)
                }
                var p = l.prev("select.t-filter-operator").val() || l.parent().prev("select.t-filter-operator").val() || l.parent().parent().prev("select.t-filter-operator").val();
                if (r != this.localization.filterSelectValue) {
                    j.push({
                        operator: p,
                        value: r
                    })
                }
            }, this));
            g.parent().find("input:checked").each(a.proxy(function (m, n) {
                var l = a(n);
                var o = a(n).attr("value");
                if (h.type === "Boolean" && o && typeof o === "string") {
                    o = o.toLowerCase().indexOf("true") > -1 ? true : false
                }
                j.push({
                    operator: "eq",
                    value: o
                })
            }, this));
            if (!k) {
                if (j.length > 0) {
                    this.filter(this.filterExpr())
                } else {
                    h.filters = null
                }
                this.hideFilter()
            }
        },
        isValidFilterValue: function (g, i) {
            if (g.type == "Date") {
                var h;
                if (i.indexOf("Date(") > -1) {
                    h = new Date(parseInt(i.replace(/^\/Date\((.*?)\)\/$/, "$1")))
                } else {
                    h = b.datetime.parse({
                        value: i,
                        format: e(g)
                    })
                }
                return h != undefined
            }
            return true
        },
        encodeFilterValue: function (g, i) {
            switch (g.type) {
                case "String":
                    return "'" + i.replace(c, "''") + "'";
                case "Date":
                    var h;
                    if (typeof i == "string") {
                        if (i.indexOf("Date(") > -1) {
                            h = new Date(parseInt(i.replace(/^\/Date\((.*?)\)\/$/, "$1")))
                        } else {
                            h = b.datetime.parse({
                                value: i,
                                format: e(g)
                            }).toDate()
                        }
                    } else {
                        h = i
                    }
                    return "datetime'" + b.formatString("{0:yyyy-MM-ddTHH-mm-ss}", h) + "'"
            }
            return i
        },
        filterExpr: function () {
            var i = [];
            for (var h = 0; h < this.columns.length; h++) {
                var g = this.columns[h];
                if (g.filters) {
                    i.push(this._buildExpression(g.filters, g, "~and~"))
                }
            }
            return i.join("~and~")
        },
        _buildExpression: function (j, g, k) {
            var l = [];
            for (var i = 0; i < j.length; i++) {
                var h = j[i];
                if (h.logic) {
                    l.push(new b.stringBuilder().catIf("(", h.filters.length > 1).cat(this._buildExpression(h.filters, g, "~" + h.logic + "~")).catIf(")", h.filters.length > 1).string())
                } else {
                    l.push(new b.stringBuilder().cat(g.member).cat("~").cat(h.operator).cat("~").cat(this.encodeFilterValue(g, h.value)).string())
                }
            }
            return l.join(k)
        },
        filter: function (g) {
            this.currentPage = 1;
            this.filterBy = g;
            if (this.isAjax()) {
                this.$columns().each(a.proxy(function (i, h) {
                    a(".t-grid-filter", h).toggleClass("t-active-filter", !!this.columns[i].filters)
                }, this));
                this.ajaxRequest()
            } else {
                this.serverRequest()
            }
        }
    }
})(jQuery);