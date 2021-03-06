(function (a, o) {
    var b = a.easyui,
		j = a.easyui.query;
    b.scripts.push("easyui.imagebrowser.js");
    b.imageBrowser = function (u, y) {
        this.element = u;
        this.wrapper = a(u);
        var v = y.filter || "*.png,*.gif,*.jpg,*.jpeg";
        var x = y.localization;
        this.wrapper.append('<div class="t-floatwrap"><div class="t-widget t-combobox t-header t-breadcrumbs"><div class="t-dropdown-wrap t-state-default"><input type="text" class="t-input" /><div class="t-breadcrumbs-wrap"/><span class="t-select t-header"><span class="t-icon t-arrow-down">select</span></span></div></div><div class="t-widget t-combobox t-dropdown-wrap t-search-wrap" /></div>').append(n(x, y.uploadUrl, y.createDirectoryUrl, y.deleteFileUrl || y.deleteDirectoryUrl)).append('<ul id="t-editor-image-list" class="t-reset t-floats t-tiles" />');
        var r = this.wrapper.find(".t-breadcrumbs");
        var w = this.wrapper.find(".t-tiles");
        var z = this.wrapper.find(".t-search-wrap");
        if (y.uploadUrl) {
            this.wrapper.find(".t-upload input").tUpload({
                async: {
                    saveUrl: y.uploadUrl,
                    autoUpload: true
                },
                multiple: false,
                onUpload: function (A) {
                    var C = new RegExp(("(" + v.split(",").join(")|(") + ")").replace(/\*\./g, ".*."), "i");
                    var B = A.files[0].name;
                    if (C.test(B)) {
                        A.data = {
                            path: r.val()
                        };
                        w.trigger("t:upload", [{
                            name: B
                        }, function () {
                            A.preventDefault()
                        }])
                    } else {
                        A.preventDefault();
                        alert(b.formatString(x.invalidFileType, B, v))
                    }
                },
                onError: function (A) {
                    A.preventDefault();
                    w.trigger("t:error", [A.files[0]]);
                    var B = A.XMLHttpRequest;
                    if (b.ajaxError(y.element, "error", B, B.statusText)) {
                        return
                    }
                },
                onSuccess: function (A) {
                    w.trigger("t:completeFile", [a.extend(A.response, {
                        path: r.val()
                    })])
                }
            })
        }
        new b.searchBox(z[0]);
        new b.fileListView(w[0], {
            thumbnailUrl: y.thumbUrl,
            localization: x
        });
        var t = new b.dropDown({
            effects: b.fx.slide.defaults(),
            onClick: function (A) {
                a(u).find(".t-tiles-arrange a span:first").html(a(A.item).text());
                t.close();
                r.trigger("t:change")
            }
        });
        var q = [{
            Text: x.orderByName,
            Value: "name"
        }, {
            Text: x.orderBySize,
            Value: "size"
        }];
        t.dataBind(q);
        this.wrapper.find(".t-tiles-arrange a").click(function (B) {
            B.preventDefault();
            var A = a(this);
            t.open({
                offset: A.offset(),
                outerHeight: A.outerHeight(),
                outerWidth: A.outerWidth(),
                zIndex: b.getElementZIndex(this)
            })
        }).end().delegate(".t-button:not(.t-state-disabled):has(.t-delete)", "click", function () {
            var A = w.find(".t-state-selected");
            if (A.length && confirm(b.formatString(x.deleteFile, A.find("strong").text()))) {
                a.ajax({
                    type: "POST",
                    url: A.data("kind") == "f" ? y.deleteFileUrl : y.deleteDirectoryUrl,
                    data: {
                        path: A.data("url")
                    },
                    error: function (C, B) {
                        if (b.ajaxError(y.element, "error", C, B)) {
                            return
                        }
                    },
                    success: function () {
                        w.trigger("t:delete");
                        a(u).find(".t-delete").parent().addClass("t-state-disabled")
                    }
                })
            }
        }).delegate(".t-button:not(.t-state-disabled):has(.t-addfolder)", "click", function () {
            w.trigger("t:createDirectory", [function (A) {
                a.ajax({
                    type: "POST",
                    url: y.createDirectoryUrl,
                    data: {
                        path: r.val(),
                        name: A
                    },
                    error: function (C, B) {
                        w.trigger("t:errorDirectory", {
                            name: A
                        });
                        if (b.ajaxError(y.element, "error", C, B)) {
                            return
                        }
                    },
                    success: function () {
                        w.trigger("t:completeDirectory", {
                            path: r.val(),
                            name: A
                        })
                    }
                })
            }])
        });
        a(document.documentElement).bind("mousedown", function (A) {
            var B = t.$element[0];
            if (!a.contains(B, A.target)) {
                t.close()
            }
        });
        var s = new b.dataSource({
            error: function (C, B) {
                var A = b.trigger(y.element, "error", {
                    XMLHttpRequest: C,
                    textStatus: B
                });
                if (!A) {
                    if (B == "error") {
                        if (C.status == "404") {
                            alert(y.localization.directoryNotFound)
                        } else {
                            if (C.status != "0") {
                                alert("Error! The requested URL returned " + C.status + " - " + C.statusText)
                            }
                        }
                    } else {
                        if (B == "timeout") {
                            alert("Error! Server timeout.")
                        }
                    }
                }
            },
            url: y.selectUrl,
            callback: function (B) {
                a(u).find(".t-delete").parent().addClass("t-state-disabled");
                if (!r.val()) {
                    new b.breadcrumbs(r[0], {
                        path: B.Path,
                        roots: B.ContentPaths
                    })
                }
                r.val(B.Path).trigger("t:refresh");
                var A = a(u).find(".t-tiles-arrange a span:first").text();
                var D = a.map(q, function (E) {
                    if (E.Text == A) {
                        return E.Value
                    }
                })[0];
                var C = z.val();
                w.trigger("t:refresh", [B, D, C])
            }
        });
        z.bind("t:change", function () {
            r.trigger("t:change")
        });
        s.get({
            path: ""
        });
        w.bind("t:select", function (A) {
            if (A.kind == "d") {
                s.get({
                    path: A.url
                })
            } else {
                y.apply(A)
            }
        }).bind("t:change", function (A) {
            var B = a(u).find(".t-delete").parent().addClass("t-state-disabled");
            if (A.kind == "f") {
                var C = A.url;
                if (y.imageUrl) {
                    C = y.imageUrl + "?path=" + C
                }
                a(u).parent().find("#t-editor-image-url").val(C)
            }
            if ((A.kind == "f" && y.deleteFileUrl) || (A.kind == "d" && y.deleteDirectoryUrl)) {
                B.removeClass("t-state-disabled")
            }
        });
        r.bind("t:change", function () {
            var A = a(this).val();
            if (!A.match(/\/$/)) {
                A = A + "/"
            }
            s.get({
                path: A
            })
        })
    };

    function n(u, t, r, s) {
        var w = !t ? "" : '<div class="t-widget t-upload"><div class="t-button t-button-icontext t-button-bare t-upload-button"><span class="t-icon t-add"></span>' + u.uploadFile + '<input type="file" name="file" /></div></div>',
			q = !r ? "" : '<button type="button" class="t-button t-button-icon t-button-bare"><span class="t-icon t-addfolder"></span></button>',
			v = !s ? "" : '<button type="button" class="t-button t-button-icon t-button-bare t-state-disabled"><span class="t-icon t-delete"></span></button>&nbsp;';
        return '<div class="t-widget t-toolbar t-floatwrap"><div class="t-toolbar-wrap">' + w + q + v + '</div><div class="t-tiles-arrange">' + u.orderBy + ' <a href="#" class="t-link"><span>' + u.orderByName + '</span><span class="t-icon t-arrow-down"></span></a></div></div>'
    }
    b.fileInfoReader = function (q) {
        this._thumbnailUrl = q.thumbnailUrl || ""
    };
    b.fileInfoReader.prototype = {
        read: function (r, q) {
            return q[r] || q[(r.charAt(0).toUpperCase() + r.substring(1))]
        },
        directories: function (q) {
            return this.read("directories", q)
        },
        files: function (q) {
            return this.read("files", q)
        },
        thumbUrl: function (r, q) {
            return this._thumbnailUrl + "/?path=" + r + encodeURIComponent(q)
        },
        size: function (q) {
            var s = this.read("size", q);
            if (!s) {
                return ""
            }
            var r = " bytes";
            if (s >= 1073741824) {
                r = " GB";
                s /= 1073741824
            } else {
                if (s >= 1048576) {
                    r = " MB";
                    s /= 1048576
                } else {
                    if (s >= 1024) {
                        r = " KB";
                        s /= 1024
                    }
                }
            }
            return Math.round(s * 100) / 100 + r
        },
        name: function (q) {
            return this.read("name", q)
        },
        path: function (q) {
            return this.read("path", q)
        },
        concatPaths: function (r, q) {
            if (r === o || !r.match(/\/$/)) {
                r = (r || "") + "/"
            }
            return r + encodeURIComponent(q)
        }
    };
    b.fileListView = function (q, r) {
        this.element = q;
        this.wrapper = a(q);
        this._localization = r.localization;
        this._reader = r.reader || new b.fileInfoReader({
            thumbnailUrl: r.thumbnailUrl
        });
        this._pageSize = r.pageSize || 20;
        this.wrapper.bind({
            "t:refresh": a.proxy(this._refresh, this),
            "t:upload": a.proxy(this._upload, this),
            "t:completeDirectory": a.proxy(this._completeDirectory, this),
            "t:delete": a.proxy(this._delete, this),
            "t:errorFile": a.proxy(this._errorFile, this),
            "t:errorDirectory": a.proxy(this._errorDirectory, this),
            "t:createDirectory": a.proxy(this._createDirectory, this),
            scroll: a.proxy(this._scroll, this)
        }).delegate("li[data-url]:not(.t-tile-empty)", "click", a.proxy(this._click, this)).delegate("li[data-url]:not(.t-tile-empty)", "dblclick", a.proxy(this._dblclick, this))
    };

    function g(q) {
        return '<li class="t-tile" data-filename="' + q.name + '"><div class="t-thumb"><span class="t-icon t-loading"></span></div><strong>' + q.name + "</strong></li>"
    }
    function d(q) {
        return '<li class="t-tile-empty"><strong>' + q + "</strong></li>"
    }
    function e(q) {
        return '<li class="t-tile" data-filename="' + q.name + '" data-thumburl="' + q.thumbUrl + '" data-url="' + q.url + '" data-kind="' + q.kind + '"><div class="t-thumb"><span class="t-icon t-loading"></span></div><strong>' + q.name + '</strong><span class="t-filesize">' + q.size + "</span>";
        "</li>"
    }
    function c(q) {
        return '<li class="t-tile" data-url="' + q.url + '" data-kind="' + q.kind + '"><div class="t-thumb"><span class="t-icon t-folder"></span></div><strong>' + q.name + "</strong></li>"
    }
    function h(q) {
        return '<li class="t-tile" data-kind="d"><div class="t-thumb"><span class="t-icon t-folder"></span></div><input class="t-input" value="' + q + '" /></li>'
    }
    function f(s) {
        var q = a(s);
        var r = a("<img />", {
            alt: q.data("filename")
        }).hide().bind("load", function () {
            a(this).prev().remove().end().addClass("t-image").fadeIn()
        });
        q.find(".t-loading").after(r);
        r.attr("src", q.data("thumburl"));
        s.loaded = true
    }
    if (a.browser.msie && parseFloat(a.browser.version) < 8) {
        var i = function (q) {
            return q.offsetTop
        }
    } else {
        var i = function (q) {
            return q.offsetTop - a(q).height()
        }
    }
    var k = /(\:|\^|\$|\/|\.|\+|\||\(|\)|\[|\]|\{|\}|\\)/g,
		m = /\*/g,
		l = /\?/g;

    function p(q) {
        return new RegExp(q.replace(k, "\\$1").replace(m, ".*").replace(l, ".?"), "ig")
    }
    b.fileListView.prototype = {
        bindTo: function (q, v, t) {
            this._filter = t;
            var w = this._reader;
            this.wrapper.empty();
            var r = j(this._reader.directories(q) || []);
            var s = j(this._reader.files(q) || []);
            if (t) {
                var y = function (z) {
                    return p(t).test(w.name(z))
                };
                r = r.where(y);
                s = s.where(y)
            }
            var x = function (z) {
                return w[v](z)
            };
            this._data = this._process(this._reader.path(q), r.orderBy(x), s.orderBy(x));
            var u = this._data.select(function (z) {
                return z.kind == "f" ? e(z) : c(z)
            }).toArray().join("");
            this.wrapper.append(u);
            this._tiles = this.wrapper.find("li[data-kind=f]");
            this._scroll();
            this._asEmpty()
        },
        _asEmpty: function () {
            if (!this._data.any() && !this._filter) {
                this.wrapper.append(d(this._localization.emptyFolder))
            }
        },
        _completeFile: function (q, t) {
            var s = this._reader.name(q);
            var u = this._reader.path(q);
            var r = a(e({
                kind: "f",
                thumbUrl: this._reader.thumbUrl(u, s),
                url: this._reader.concatPaths(u, s),
                name: s,
                size: this._reader.size(q)
            }));
            this.wrapper.find("li").eq(this.fileIndex(t)).replaceWith(r);
            f(r[0]);
            r.click()
        },
        _completeDirectory: function (r, q) {
            var t = this._reader.name(q);
            var u = this._reader.path(q);
            var s = a(c({
                kind: "d",
                url: this._reader.concatPaths(u, t),
                name: t
            }));
            this.wrapper.find("li").eq(this.directoryIndex(t)).replaceWith(s)
        },
        _delete: function () {
            var r = this.wrapper.find(".t-state-selected");
            if (r.length) {
                var q = this._data.toArray();
                q.splice(r.index(), 1);
                this._data = j(q);
                r.remove();
                this._scroll();
                this._asEmpty()
            }
        },
        _scroll: function (q) {
            clearTimeout(this._timeout);
            this._timeout = setTimeout(a.proxy(function () {
                var r = this.wrapper.outerHeight();
                var t = this.wrapper.scrollTop();
                var s = t + r;
                this._tiles.each(function () {
                    var v = i(this);
                    var u = v + this.offsetHeight;
                    if ((v >= t && v < s) || (u >= t && u < s)) {
                        f(this)
                    }
                    if (v > s) {
                        return false
                    }
                });
                this._tiles = this._tiles.filter(function () {
                    return !this.loaded
                })
            }, this), 250)
        },
        _upload: function (r, t, x) {
            var u = t.name;
            var s = this.fileIndex(u);
            if (s > -1 && !confirm(b.formatString(this._localization.overwriteFile, u))) {
                x()
            } else {
                this.wrapper.find(".t-tile-empty").remove();
                var w = a(g(t));
                if (s > -1) {
                    w.data("existing", true);
                    this.wrapper.find("li").eq(s).replaceWith(w)
                } else {
                    var v = this.wrapper.find("li[data-kind=f]:first");
                    if (v.length) {
                        v.before(w)
                    } else {
                        this.wrapper.append(w)
                    }
                    var q = this._data.toArray();
                    q.splice(w.index(), 0, {
                        name: u,
                        kind: "f"
                    })
                }
                this.wrapper.scrollTop(w.attr("offsetTop") - this.element.offsetHeight);
                this.wrapper.one("t:completeFile", a.proxy(function (y, z) {
                    this._completeFile(z, u)
                }, this))
            }
        },
        _nameDirectory: function () {
            var t = "New folder";
            var r = this._data.where(function (u) {
                return u.kind == "d" && u.name.indexOf(t) > -1
            }).select(function (u) {
                return u.name
            }).toArray();
            if (a.inArray(t, r) > -1) {
                var s = 2;
                do {
                    var q = t + " (" + s + ")";
                    s++
                } while (a.inArray(q, r) > -1);
                t = q
            }
            return t
        },
        _createDirectory: function (s, q) {
            var w = this._nameDirectory();
            var v = a(h(w));
            var t = this.wrapper.find("li[data-kind=f]:first");
            if (t.length) {
                t.before(v)
            } else {
                this.wrapper.append(v)
            }
            var r = this._data.toArray();
            var u = v.addClass("t-state-selected").siblings().removeClass("t-state-selected").end().find("input").keydown(function (x) {
                if (x.keyCode == 13) {
                    this.blur()
                }
            }).blur(a.proxy(function (x) {
                var y = a.trim(x.target.value);
                if (!y || this._data.any(function (z) {
					return z.kind == "d" && z.name.toLowerCase() == y.toLowerCase()
                })) {
                    y = this._nameDirectory()
                }
                r.splice(v.index(), 0, {
                    name: y,
                    kind: "d"
                });
                a(x.target).replaceWith("<strong>" + y + "</strong>");
                q(y)
            }, this));
            setTimeout(function () {
                u.select()
            });
            this.wrapper.find(".t-tile-empty").remove();
            this.wrapper.scrollTop(v.attr("offsetTop") - this.element.offsetHeight)
        },
        _errorFile: function (q, r) {
            var s = this.fileIndex(r.name);
            if (s > -1) {
                var t = this.wrapper.find("li").eq(s);
                if (t.data("existing")) {
                    var u = a(e(this._data.toArray()[s]));
                    t.replaceWith(u);
                    f(u[0])
                } else {
                    t.remove();
                    this._data.toArray().splice(s, 1)
                }
                this._asEmpty()
            }
        },
        _errorDirectory: function (r, q) {
            var s = this.directoryIndex(q.name);
            if (s > -1) {
                this.wrapper.find("li").eq(s).remove();
                this._data.toArray().splice(s, 1);
                this._asEmpty()
            }
        },
        fileIndex: function (q) {
            return this._index("f", q)
        },
        directoryIndex: function (q) {
            return this._index("d", q)
        },
        _index: function (r, s) {
            var t = -1,
				q = this._data ? this._data.toArray() : [];
            s = s.toLowerCase();
            a.each(q, function (u, v) {
                if (v.kind == r && v.name.toLowerCase() == s) {
                    t = u;
                    return false
                }
            });
            return t
        },
        _raise: function (r, s) {
            var q = a(r.currentTarget);
            b.trigger(this.wrapper, s, {
                kind: q.data("kind"),
                url: q.data("url")
            })
        },
        _click: function (q) {
            a(q.currentTarget).addClass("t-state-selected").siblings().removeClass("t-state-selected");
            this._raise(q, "t:change")
        },
        _dblclick: function (q) {
            if (document.selection && document.selection.empty) {
                document.selection.empty()
            }
            this._raise(q, "t:select")
        },
        _refresh: function (r, q, t, s) {
            this.bindTo(q, t, s)
        },
        _process: function (s, q, r) {
            var t = this._reader;
            var q = q.select(function (u) {
                return {
                    url: t.concatPaths(s, t.name(u)),
                    name: t.name(u),
                    kind: "d"
                }
            });
            var r = r.select(function (u) {
                var v = t.name(u);
                return {
                    url: t.concatPaths(s, v),
                    name: v,
                    kind: "f",
                    thumbUrl: t.thumbUrl(s, v),
                    size: t.size(u)
                }
            });
            return q.concat(r)
        }
    };
    b.dataSource = function (q) {
        this._url = q.url;
        this._callback = q.callback;
        this._error = q.error
    };
    b.dataSource.prototype = {
        _complete: function (q) {
            if (this._callback) {
                this._callback(q)
            }
        },
        get: function (q) {
            a.ajax({
                type: "POST",
                url: this._url,
                data: q,
                success: a.proxy(this._complete, this),
                error: this._error
            })
        }
    };
    b.breadcrumbs = function (r, s) {
        this.element = r;
        this.wrapper = a(r);
        this._gap = s.gap || 50;
        this._initPaths(s.path);
        var q = new b.dropDown({
            effects: b.fx.slide.defaults(),
            onClick: a.proxy(function (t) {
                var u = a(t.item).text();
                q.close();
                this._initPaths(u);
                a(r).val(u).trigger("t:change")
            }, this)
        });
        q.dataBind(s.roots);
        this.wrapper.delegate("input", "focus", a.proxy(this._focus, this)).delegate("input", "blur", a.proxy(this._blur, this)).delegate("input", "keydown", a.proxy(function (t) {
            if (t.keyCode == 13) {
                this._blur()
            }
        }, this)).delegate("a:not(.t-first)", "click", b.stopAll(this._click, this)).delegate(".t-select", "click", function () {
            var t = a(r);
            q.open({
                offset: t.offset(),
                outerHeight: t.outerHeight(),
                outerWidth: t.outerWidth(),
                zIndex: b.getElementZIndex(this)
            })
        }).bind("t:refresh", a.proxy(this.refresh, this));
        a(document.documentElement).bind("mousedown", function (t) {
            var u = q.$element[0];
            if (!a.contains(u, t.target)) {
                q.close()
            }
        });
        this.value(s.path)
    };
    b.breadcrumbs.prototype = {
        _initPaths: function (q) {
            this._basePath = (q || "").replace(/\/{2,}/g, "/").replace(/\/$/, "");
            q = this._basePath.split("/");
            q.pop();
            this._root = q.join("/")
        },
        _html: function () {
            var q = this._basePath.split("/").length - 1;
            var r = this.value();
            if (r === o || !r.match(/^\//)) {
                r = "/" + (r || "")
            }
            return '<div class="t-dropdown-wrap t-state-default"><input type="text" class="t-input" /><div class="t-breadcrumbs-wrap">' + a.map(r.split("/"), function (t, s) {
                if (t && s >= q) {
                    return '<a class="t-link" href="#">' + t + "</a>"
                }
            }).join('<span class="t-icon t-arrow-next">&gt;</span>') + '</div><span class="t-select t-header"><span class="t-icon t-arrow-down">select</span></span></div>'
        },
        _path: function (q) {
            return this._root + "/" + a.map(q, function (r) {
                return a(r).text()
            }).join("/")
        },
        _update: function (r) {
            r = r.charAt(0) === "/" ? r : "/" + r;
            var q = this.value() != r;
            this.value(r);
            if (q) {
                this.wrapper.trigger("t:change")
            }
        },
        value: function (q) {
            if (q !== o) {
                this.wrapper.val(q.replace(/\/{2,}/g, "/"));
                this.refresh()
            } else {
                return this.wrapper.val()
            }
        },
        _click: function (q) {
            this._update(this._path(a(q.target).prevAll("a").andSelf()))
        },
        refresh: function () {
            this.wrapper.empty().append(this._html());
            var r = this.wrapper.width() - this._gap;
            var q = this.wrapper.find("a");
            q.each(function (t) {
                var s = a(this);
                if (s.parent().width() > r) {
                    if (t == q.length - 1) {
                        s.width(r)
                    } else {
                        s.prev().andSelf().hide()
                    }
                }
            })
        },
        _focus: function () {
            var q = this.wrapper.find(".t-breadcrumbs-wrap").hide().end().find("input").val(this.value());
            setTimeout(function () {
                q.select()
            })
        },
        _blur: function () {
            var q = this.wrapper.find("input").val().replace(/\/{2,}/g, "/");
            if (!q || q.toLowerCase().indexOf(this._basePath.toLowerCase()) < 0) {
                q = this._basePath
            }
            this._update(q)
        }
    };
    b.searchBox = function (q) {
        this.element = q;
        this.wrapper = a(q);
        this.wrapper.delegate("input", "focus", a.proxy(this._focus, this)).delegate("input", "blur", a.proxy(this._blur, this)).delegate("input", "keydown", a.proxy(function (r) {
            if (r.keyCode == 13) {
                this._blur()
            }
        }, this)).delegate("a", "click", b.stopAll(this._click, this));
        this._render()
    };
    b.searchBox.prototype = {
        _render: function () {
            var q = '<label for="t-imagebrowser-search">Search</label><input type="text" id="t-imagebrowser-search" class="t-input" /><a href="#" class="t-icon t-search">search</a>';
            this.wrapper.empty().append(a(q))
        },
        _focus: function () {
            this.wrapper.find("label").hide()
        },
        _blur: function () {
            this._update(this.wrapper.find("input").val());
            if (this.value() == "") {
                this.wrapper.find("label").show()
            }
        },
        _update: function (r) {
            var q = this.value() != r;
            this.value(r);
            if (q) {
                this.wrapper.trigger("t:change")
            }
        },
        value: function (q) {
            if (q !== o) {
                this.wrapper.val(q)
            } else {
                return this.wrapper.val()
            }
        },
        _click: function () {
            this._blur()
        }
    }
})(jQuery);