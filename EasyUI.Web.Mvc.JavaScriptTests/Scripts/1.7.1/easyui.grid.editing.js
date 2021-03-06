(function (a) {
    var b = a.easyui,
		e = /^\/Date\((.*?)\)\/$/,
		d = /[0#?]/,
		i = /[npc?]/;
    b.scripts.push("easyui.grid.editing.js");
    var m = function (p) {
        this.formId = p;
        this._isBuild = false;
        var o = "tUnobtrusiveValidation";
        var n = "tUnobtrusiveContainer";
        var q = this.unobtrusive = {
            adapters: [],
            parseElement: function (s, w) {
                var r = a(s),
                    t = r.parents("form")[0],
                    x, v, u;
                if (!t) {
                    return
                }
                x = q.validationInfo(t);
                x.options.rules[s.name] = v = {};
                x.options.messages[s.name] = u = {};
                a.each(this.adapters, function () {
                    var A = "data-val-" + this.name,
                        y = r.attr(A),
                        z = {};
                    if (y !== undefined) {
                        A += "-";
                        a.each(this.params, function () {
                            z[this] = r.attr(A + this)
                        });
                        this.adapt({
                            element: s,
                            form: t,
                            message: y,
                            params: z,
                            rules: v,
                            messages: u
                        })
                    }
                });
                if (!w) {
                    x.attachValidation()
                }
            },
            parse: function (r) {
                a(r).find(":input[data-val=true]").each(function () {
                    q.parseElement(this, true)
                });
                a(r).each(function () {
                    var s = q.validationInfo(this);
                    if (s) {
                        s.attachValidation()
                    }
                })
            },
            onError: function (s, t) {
                var r = a(this).find("[data-valmsg-for='" + t[0].name + "']"),
                    u = a.parseJSON(r.attr("data-valmsg-replace")) !== false;
                r.removeClass("field-validation-valid").addClass("field-validation-error");
                s.data(n, r);
                if (u) {
                    r.empty();
                    s.removeClass("input-validation-error").appendTo(r)
                } else {
                    s.hide()
                }
            },
            onErrors: function (s, u) {
                var r = a(this).find("[data-valmsg-summary=true]"),
                    t = r.find("ul");
                if (t && t.length && u.errorList.length) {
                    t.empty();
                    r.addClass("validation-summary-errors").removeClass("validation-summary-valid");
                    a.each(u.errorList, function () {
                        a("<li />").html(this.message).appendTo(t)
                    })
                }
            },
            onSuccess: function (s) {
                var r = s.data(n),
                    t = a.parseJSON(r.attr("data-valmsg-replace"));
                if (r) {
                    r.addClass("field-validation-valid").removeClass("field-validation-error");
                    s.removeData(n);
                    if (t) {
                        r.empty()
                    }
                }
            },
            validationInfo: function (s) {
                var r = a(s),
                    t = r.data(o);
                if (!t) {
                    t = {
                        options: {
                            errorClass: "input-validation-error",
                            errorElement: "span",
                            errorPlacement: a.proxy(q.onError, s),
                            invalidHandler: a.proxy(q.onErrors, s),
                            messages: {},
                            rules: {},
                            success: a.proxy(q.onSuccess, s)
                        },
                        attachValidation: function () {
                            r.validate(this.options)
                        },
                        validate: function () {
                            r.validate();
                            return r.valid()
                        }
                    };
                    r.data(o, t)
                }
                return t
            }
        }
    };
    m.prototype = {
        build: function () {
            if (this._isBuild) {
                return
            }
            this._isBuild = true;
            var n = [];

            function q(s, t, u) {
                s.rules[t] = u;
                if (s.message) {
                    s.messages[t] = s.message
                }
            }
            function r(s) {
                return s.replace(/^\s+|\s+$/g, "").split(/\s*,\s*/g)
            }
            function p(s) {
                return s.substr(0, s.lastIndexOf(".") + 1)
            }
            function o(t, s) {
                if (t.indexOf("*.") === 0) {
                    t = t.replace("*.", s)
                }
                return t
            }
            n = this.unobtrusive.adapters;
            n.add = function (s, u, t) {
                if (!t) {
                    t = u;
                    u = []
                }
                this.push({
                    name: s,
                    params: u,
                    adapt: t
                });
                return this
            };
            n.addBool = function (s, t) {
                return this.add(s, function (u) {
                    q(u, t || s, true)
                })
            };
            n.addMinMax = function (s, x, u, w, v, t) {
                return this.add(s, [v || "min", t || "max"], function (A) {
                    var z = A.params.min,
						y = A.params.max;
                    if (z && y) {
                        q(A, w, [z, y])
                    } else {
                        if (z) {
                            q(A, x, z)
                        } else {
                            if (y) {
                                q(A, u, y)
                            }
                        }
                    }
                })
            };
            n.addSingleVal = function (s, t, u) {
                return this.add(s, [t || "val"], function (v) {
                    q(v, u || s, v.params[t])
                })
            };
            n.addSingleVal("accept", "exts").addSingleVal("regex", "pattern");
            n.addBool("creditcard").addBool("date").addBool("digits").addBool("email").addBool("number").addBool("url");
            n.addMinMax("length", "minlength", "maxlength", "rangelength").addMinMax("range", "min", "max", "range");
            n.add("equalto", ["other"], function (t) {
                var s = a(t.form).find(":input[name=" + t.params.other + "]")[0];
                q(t, "equalTo", s)
            });
            n.add("required", function (s) {
                if (s.element.tagName.toUpperCase() !== "INPUT" || s.element.type.toUpperCase() !== "CHECKBOX") {
                    q(s, "required", true)
                }
            });
            n.add("remote", ["url", "type", "additionalfields"], function (s) {
                var u = {
                    url: s.params.url,
                    type: s.params.type || "GET",
                    data: {}
                },
					t = p(s.element.name);
                a.each(r(s.params.additionalfields || s.element.name), function (w, v) {
                    var x = o(v, t);
                    u.data[x] = function () {
                        return a(s.form).find(":input[name='" + x + "']").val()
                    }
                });
                q(s, "remote", u)
            });
            if (a.validator.unobtrusive && a.validator.unobtrusive.adapters) {
                a.extend(n, a.validator.unobtrusive.adapters)
            }
            a.validator.addMethod("regex", function (v, s, u) {
                if (this.optional(s)) {
                    return true
                }
                var t = new RegExp(u).exec(v);
                return t && t.index == 0 && t[0].length == v.length
            });
            a.validator.addMethod("number", function (v, t) {
                var u = b.cultureInfo.numericgroupsize;
                if (u) {
                    var s = new b.stringBuilder();
                    s.cat("^-?(?:\\d+|\\d{1,").cat(u).cat("}(?:").cat(b.cultureInfo.numericgroupseparator).cat("\\d{").cat(u).cat("})+)(?:\\").cat(b.cultureInfo.numericdecimalseparator).cat("\\d+)?$");
                    return this.optional(t) || (s && new RegExp(s.string()).test(v))
                }
                return this.optional(t) || /^-?(?:\d+|\d{1,3}(?:,\d{3})+)(?:\.\d+)?$/.test(v)
            })
        },
        parse: function () {
            this.build();
            this.unobtrusive.parse(this.formId)
        }
    };
    var h = function (n) {
        this.validationMetaData = n
    };
    h.prototype = {
        build: function (C) {
            a.validator.addMethod("regex", function (G, D, F) {
                if (this.optional(D)) {
                    return true
                }
                var E = new RegExp(F).exec(G);
                return E && E.index == 0 && E[0].length == G.length
            });
            a.validator.addMethod("number", function (G, E) {
                var F = b.cultureInfo.numericgroupsize;
                var D = new b.stringBuilder();
                D.cat("^-?(?:\\d+|\\d{1,").cat(F).cat("}(?:").cat(b.cultureInfo.numericgroupseparator).cat("\\d{").cat(F).cat("})+)(?:\\").cat(b.cultureInfo.numericdecimalseparator).cat("\\d+)?$");
                return this.optional(E) || new RegExp(D.string()).test(G)
            });

            function n(F, E, D) {
                F.range = [E, D]
            }
            function o(D, E) {
                D.regex = E
            }
            function p(D) {
                D.required = true
            }
            function q(E, D) {
                E.maxlength = D
            }
            function r(D, F, E) {
                D[F] = E
            }
            function t(G) {
                var E = {};
                for (var D = 0; D < G.length; D++) {
                    var F = G[D];
                    E[F.FieldName] = "#" + F.ValidationMessageId
                }
                return E
            }
            function s(K) {
                var G = {};
                for (var D = 0; D < K.length; D++) {
                    var H = K[D];
                    var I = {};
                    G[H.FieldName] = I;
                    var L = H.ValidationRules;
                    for (var E = 0; E < L.length; E++) {
                        var J = L[E];
                        if (J.ErrorMessage) {
                            var F = J.ValidationType;
                            switch (J.ValidationType) {
                                case "regularExpression":
                                    F = "regex";
                                    break;
                                case "stringLength":
                                    F = "maxlength";
                                    break
                            }
                            I[F] = J.ErrorMessage
                        }
                    }
                }
                return G
            }
            function u(I) {
                var J = I.ValidationRules;
                var G = {};
                for (var D = 0; D < J.length; D++) {
                    var H = J[D];
                    switch (H.ValidationType) {
                        case "range":
                            var F = (typeof (H.ValidationParameters.minimum) == "undefined") ? H.ValidationParameters.min : H.ValidationParameters.minimum;
                            var E = (typeof (H.ValidationParameters.maximum) == "undefined") ? H.ValidationParameters.max : H.ValidationParameters.maximum;
                            n(G, F, E);
                            break;
                        case "regularExpression":
                        case "regex":
                            o(G, H.ValidationParameters.pattern);
                            break;
                        case "required":
                            p(G);
                            break;
                        case "stringLength":
                            q(G, H.ValidationParameters.maximumLength);
                            break;
                        case "length":
                            q(G, H.ValidationParameters.max);
                            break;
                        default:
                            r(G, H.ValidationType, H.ValidationParameters);
                            break
                    }
                }
                return G
            }
            function v(H) {
                var F = {};
                for (var E = 0; E < H.length; E++) {
                    var G = H[E];
                    var D = G.FieldName;
                    F[D] = u(G)
                }
                return F
            }
            var B = a("#" + C.FormId);
            var x = C.Fields;
            var A = v(x);
            var y = t(x);
            var w = s(x);
            var z = {
                errorClass: "input-validation-error",
                errorElement: "span",
                errorPlacement: function (E, D) {
                    var F = y[D.attr("name")];
                    if (F) {
                        a(F).empty().removeClass("field-validation-valid").addClass("field-validation-error");
                        E.removeClass("input-validation-error").attr("_for_validation_message", F).appendTo(F)
                    }
                },
                messages: w,
                rules: A,
                success: function (D) {
                    a(D.attr("_for_validation_message")).empty().addClass("field-validation-valid").removeClass("field-validation-error")
                }
            };
            B.validate(z)
        },
        parse: function () {
            this.build(this.validationMetaData)
        }
    };
    b.editing = {};

    function c(n) {
        a(n || document.body).find("div.t-grid").each(function () {
            var o = a(this).data("tGrid");
            if (o && o.cancel) {
                o.cancel()
            }
        })
    }
    function f(p, q, o) {
        for (var n in q) {
            if (a.isPlainObject(q[n])) {
                f(p, q[n], o ? o + "." + n : n)
            } else {
                p[o ? o + "." + n : n] = q[n]
            }
        }
    }
    function l(r) {
        for (var q in r) {
            var p = q.indexOf(".");
            if (p > -1) {
                var o = q.substring(0, p);
                var n = r[o] || {};
                n[q.substring(p + 1)] = r[q];
                r[o] = l(n);
                delete r[q]
            }
        }
        return r
    }
    function j(n) {
        var p, q, o;
        for (p in n) {
            q = n[p];
            if (typeof q === "string") {
                o = e.exec(q);
                if (o) {
                    n[p] = new Date(parseInt(o[1]))
                }
            } else {
                if (a.isPlainObject(q)) {
                    j(q)
                }
            }
        }
    }
    function k(n, t, s) {
        var u = {};
        for (var v = 0, p = 0; v < n.length; v++) {
            var o = n[v];
            j(o);
            if (s(o)) {
                for (var r in o) {
                    var w = o[r],
						q = t + "[" + p + "]." + r;
                    if (a.isPlainObject(w)) {
                        f(u, w, q)
                    } else {
                        u[q] = w
                    }
                }
                p++
            }
        }
        return u
    }
    b.editing.initialize = function (t) {
        a.extend(t, this.implementation);
        var n = a(t.element);
        t.modelBinder = new b.grid.ModelBinder();
        t.formViewBinder = new b.grid.FormViewBinder({
            date: function (x, y) {
                var v = t.columnFromMember(x);
                var w = v ? v.format : "";
                return b.formatString(w || "{0:G}", y)
            }
        });
        if (t.isAjax()) {
            t.serializeData = function (v, x, w) {
                if (!w) {
                    w = function () {
                        return true
                    }
                }
                v = k(v, x, w);
                return t._convert(v)
            };
            if (t.editing.mode == "InCell") {
                j(t.editing.defaultDataItem || {});
                t.changeLog = new b.grid.ChangeLog(t.pageSize || (t.data && t.data.length) || 0, t.editing.insertRowPosition);
                a(t.element).bind("dataBound", function () {
                    t.changeLog.clear();
                    t.valid = true;
                    t.td = null
                });
                t.cellEditor = new b.grid.CellEditor({
                    columns: t.columns,
                    cellIndex: function (v) {
                        return t.cellIndex(v)
                    },
                    id: t.formId(),
                    bind: a.proxy(t.formViewBinder.bind, t.formViewBinder),
                    validate: a.proxy(t.validation, t)
                });
                n.delegate(".t-grid-save-changes:not(.t-state-disabled)", "click", b.stopAll(function (v) {
                    t.submitChanges()
                }));
                n.delegate(".t-grid-cancel-changes", "click", b.stopAll(function (v) {
                    t.cancelChanges()
                }));
                t.hasChanges = function () {
                    return t.changeLog.dirty()
                };
                t.updatedDataItems = function () {
                    return a.grep(t.changeLog.updated, function (v) {
                        return v != undefined
                    })
                };
                t.insertedDataItems = function () {
                    return t.changeLog.inserted
                };
                t.deletedDataItems = function () {
                    return a.grep(t.changeLog.deleted, function (v) {
                        return v != undefined
                    })
                };
                t.submitChanges = function () {
                    t._onCommand({
                        name: "submitChanges"
                    });
                    if (t.changeLog.dirty()) {
                        t._validateForm(function () {
                            var x = t.changeLog.inserted;
                            var y = a.grep(t.changeLog.updated, function (A) {
                                return A != undefined
                            });
                            var w = a.grep(t.changeLog.deleted, function (A) {
                                return A != undefined
                            });
                            var v = {};
                            if (b.trigger(t.element, "submitChanges", {
                                inserted: x,
                                updated: y,
                                deleted: w,
                                values: v
                            })) {
                                return
                            }
                            var z = t.ws ? {
                                inserted: a.map(x, function (A) {
                                    return t._convert(A)
                                }),
                                updated: a.map(y, function (A) {
                                    return t._convert(A)
                                }),
                                deleted: a.map(w, function (A) {
                                    return t._convert(A)
                                })
                            } : t.changeLog.serialize(x, y, w);
                            t.sendValues(a.extend(z, v), "updateUrl", "submitChanges")
                        })
                    }
                };
                t.cancelChanges = function () {
                    t._onCommand({
                        name: "cancelChanges"
                    });
                    t.changeLog.clear();
                    t.valid = true;
                    t.td = null;
                    t.ajaxRequest()
                };
                t.cellIndex = function (v) {
                    return a(v).parent().find("td:not(.t-group-cell,.t-hierarchy-cell)").index(v)
                };
                t.rowIndex = function (v) {
                    v = a(v);
                    if (v.hasClass("t-grid-new-row")) {
                        return v.parent().find(".t-grid-new-row").index(v)
                    }
                    return v.parent().find("tr:not(.t-detail-row,.t-grouping-row)").index(v)
                };
                var q;
                t.valid = true;
                t.editCell = function (E) {
                    var w = t.columns[t.cellIndex(E)];
                    if (t.valid && (w && !w.readonly)) {
                        t.td = E;
                        if (t.form().length) {
                            a.data(t.form()[0], "validator", null)
                        }
                        E = a(E);
                        var F = E.parent();
                        var A = t.rowIndex(F);
                        var y = {};
                        if (t.editing.insertRowPosition == "bottom" && E.closest("tr").hasClass("t-grid-new-row")) {
                            y = t.dataItem(F) || t.changeLog.get(A)
                        } else {
                            y = t.changeLog.get(A, E.closest("tr").hasClass("t-grid-new-row")) || t.dataItem(F)
                        }
                        q = E.find(".t-dirty");
                        t.cellEditor.edit(E, y);
                        b.trigger(t.element, "edit", {
                            mode: F.hasClass("t-grid-new-row") ? "insert" : "edit",
                            form: t.form()[0],
                            dataItem: y,
                            cell: E[0]
                        })
                    } else {
                        if (t.keyboardNavigation) {
                            var E = a(E),
								x = E.closest(".t-grid-content", t.element);
                            if (x.length > 0) {
                                var v = E.outerWidth(),
									C = E.position().left,
									D = x.scrollLeft(),
									z = x.outerWidth();
                                if (C > D && C + v > z) {
                                    var B = D + b.scrollbarWidth() + C + v - z;
                                    x.scrollLeft(B)
                                }
                            }
                        }
                    }
                };
                t.saveCell = function (v) {
                    t.valid = false;
                    t._validateForm(function () {
                        t.valid = true;
                        v = a(v);
                        var z = v.parent();
                        var y = t.rowIndex(z);
                        var w = {};
                        if (t.editing.insertRowPosition == "bottom" && v.closest("tr").hasClass("t-grid-new-row")) {
                            w = t.dataItem(z) || t.changeLog.get(y)
                        } else {
                            w = t.changeLog.get(y, v.closest("tr").hasClass("t-grid-new-row")) || t.dataItem(z)
                        }
                        var A = l(t.modelBinder.bind(v));
                        var x = false;
                        if (b.trigger(t.element, "save", {
                            mode: z.hasClass("t-grid-new-row") ? "insert" : "edit",
                            dataItem: w,
                            values: A,
                            form: t.form()[0],
                            cell: v[0]
                        })) {
                            return
                        }
                        if (z.hasClass("t-grid-new-row")) {
                            t.changeLog.insert(t.rowIndex(z), A)
                        } else {
                            x = t.changeLog.update(t.rowIndex(z), w, A)
                        }
                        t.cellEditor.display(v, a.extend(true, {}, w, A));
                        if (x || z.hasClass("t-grid-new-row")) {
                            q = a('<span class="t-dirty" />')
                        }
                        if (q && q.length) {
                            q.prependTo(t.td)
                        }
                        t.td = null
                    })
                };
                t.cancelCell = function (x) {
                    x = a(x);
                    var y = x.parent(),
						w = t.rowIndex(y),
						v = {};
                    if (t.editing.insertRowPosition == "bottom" && x.closest("tr").hasClass("t-grid-new-row")) {
                        v = t.dataItem(y) || t.changeLog.get(w)
                    } else {
                        v = t.changeLog.get(w, x.closest("tr").hasClass("t-grid-new-row")) || t.dataItem(y)
                    }
                    t.valid = true;
                    t.cellEditor.display(x, v);
                    if (q && q.length) {
                        q.prependTo(t.td)
                    }
                    t.td = null
                };
                t.td = null;
                t.$tbody.delegate("tr:not(.t-grouping-row,.t-no-data,.t-footer-template,.t-group-footer) > td:not(.t-detail-cell,.t-grid-edit-cell,.t-group-cell,.t-hierarchy-cell)", t.editing.beginEdit || "click", function (v) {
                    if (a(this).closest("tbody")[0] == t.$tbody[0]) {
                        t.editCell(this)
                    }
                });
                a(document).mousedown(function (v) {
                    if (t.td && !a.contains(t.td, v.target) && t.td != v.target && !a(v.target).closest(".t-animation-container").length) {
                        t.saveCell(t.td)
                    }
                })
            } else {
                if (t.editing.beginEdit) {
                    t.$tbody.delegate("tr:not(.t-detail-row,.t-grouping-row,.t-grid-edit-row,.t-group-footer)", t.editing.beginEdit, function (v) {
                        if (!a(v.target).is(":button,a,:input,a>.t-icon")) {
                            t.editRow(a(this))
                        }
                    })
                }
            }
            n.delegate(".t-grid-edit", "click", b.stopAll(function (v) {
                t.editRow(a(this).closest("tr"))
            })).delegate(".t-grid-delete", "click", b.stopAll(function (v) {
                t.deleteRow(a(this).closest("tr"))
            })).delegate(".t-grid-add", "click", b.stopAll(function (v) {
                t.addRow()
            }))
        } else {
            n.delegate(".t-grid-delete", "click", b.stop(function (v) {
                if (t.editing.confirmDelete !== false && !confirm(t.localization.deleteConfirmation)) {
                    v.preventDefault()
                }
            }));
            t.validation()
        }
        t.errorView = new b.grid.ErrorView();
        var o = new b.grid.DataCellBuilder({
            columns: t.columns,
            rowTemplate: t.rowTemplate
        });
        var p = a.grep(t.columns, function (v) {
            return v.commands && a.grep(v.commands, function (w) {
                return w.name == "edit"
            })[0]
        })[0];
        if (!p) {
            p = {
                commands: [{
                    name: "edit",
                    buttonType: "Text"
                }]
            };
            p.insert = t.insertFor(p);
            p.edit = t.editFor(p)
        }
        var s = new b.grid.FormContainerBuilder({
            html: function () {
                return unescape(t.editing.editor)
            },
            insert: function () {
                return p.insert()
            },
            edit: function () {
                return p.edit()
            }
        });
        var r = t.editing.mode;
        var u = function () {
            return (t.groups || []).length
        };
        if (r == "InLine") {
            t.rowEditor = new b.grid.Editor({
                id: t.formId(),
                insertRow: t.editing.insertRowPosition,
                cancel: o.display,
                edit: o.edit,
                insert: o.insert,
                groups: u,
                details: t.detail
            })
        } else {
            if (r == "InForm") {
                t.rowEditor = new b.grid.Editor({
                    id: t.formId(),
                    cancel: o.display,
                    insertRow: t.editing.insertRowPosition,
                    groups: u,
                    details: t.detail,
                    edit: function () {
                        return '<td colspan="' + a.grep(t.columns, function (v) {
                            return !v.hidden
                        }).length + '">' + s.edit() + "</td>"
                    },
                    insert: function () {
                        return '<td colspan="' + a.grep(t.columns, function (v) {
                            return !v.hidden
                        }).length + '">' + s.insert() + "</td>"
                    }
                })
            } else {
                if (r == "PopUp") {
                    t.rowEditor = new b.grid.PopUpEditor({
                        id: t.formId(),
                        edit: s.edit,
                        container: t.element,
                        settings: t.editing.popup,
                        insert: s.insert,
                        editTitle: t.localization.edit,
                        insertTitle: t.localization.insert
                    })
                } else {
                    o = new b.grid.CellBuilder({
                        columns: t.columns
                    });
                    t.rowEditor = new b.grid.Editor({
                        id: t.formId(),
                        cancel: o.display,
                        insertRow: t.editing.insertRowPosition,
                        edit: o.edit,
                        insert: o.insert,
                        groups: u,
                        details: t.detail
                    })
                }
            }
        }
        if (!t.keyboardNavigation) {
            n.delegate(":input:not(.t-button):not(textarea)", "keydown", b.stop(function (v) {
                if (v.keyCode == 13 || v.keyCode == 27) {
                    v.preventDefault();
                    var w = {
                        13: ".t-grid-update, .t-grid-insert",
                        27: ".t-grid-cancel"
                    };
                    a(this).closest("tr").find(w[v.keyCode]).click()
                }
            }))
        }
    };
    b.editing.implementation = {
        editFor: function (o) {
            var r = this.localization;
            if (o.commands) {
                var p = a.grep(o.commands, function (t) {
                    return t.name == "edit"
                })[0];
                if (p) {
                    var s = b.grid.ButtonBuilder.create(a.extend(true, {}, p, {
                        text: p.updateText || r.update,
                        name: "update"
                    }));
                    var n = b.grid.ButtonBuilder.create(a.extend(true, {}, p, {
                        text: p.cancelText || r.cancel,
                        name: "cancel"
                    }));
                    var q = s.build() + n.build();
                    return function () {
                        return q
                    }
                } else {
                    return function () {
                        return ""
                    }
                }
            } else {
                if (!o.readonly && o.editor) {
                    return function () {
                        return unescape(o.editor)
                    }
                }
            }
            return this.displayFor(o)
        },
        insertFor: function (o) {
            var s = this.localization;
            if (o.commands) {
                var p = a.grep(o.commands, function (t) {
                    return t.name == "edit"
                })[0];
                if (p) {
                    var r = b.grid.ButtonBuilder.create(a.extend(true, {}, p, {
                        text: p.insertText || s.insert,
                        name: "insert"
                    }));
                    var n = b.grid.ButtonBuilder.create(a.extend(true, {}, p, {
                        text: p.cancelText || s.cancel,
                        name: "cancel"
                    }));
                    var q = r.build() + n.build();
                    return function () {
                        return q
                    }
                } else {
                    return function () {
                        return ""
                    }
                }
            } else {
                return this.editFor(o)
            }
        },
        insertRow: function (n) {
            var v = this;
            if (a.isPlainObject(n)) {
                var p = a.extend(true, {}, v.editing.defaultDataItem, n);
                if (this.editing.mode != "InCell") {
                    j(p);
                    v.sendValues(p, "insertUrl", "insert")
                } else {
                    v.changeLog.insert(p);
                    var r = (v.groups || []).length + 1,
						q = v.detail,
						w = a('<tr class="t-grid-new-row">' + new Array(r).join('<td class="t-group-cell" />') + ((q) ? '<td class="t-hierarchy-cell"/>' : "") + "</tr>"),
						o = v.columns,
						u, s, t;
                    v.$tbody.prepend(w);
                    w.closest("table").wrap(function () {
                        if (!a(this).parent().is("form")) {
                            return g(v.formId())
                        }
                    });
                    for (s = 0, t = o.length; s < t; s++) {
                        u = a("<td>").appendTo(w);
                        v.cellEditor.display(u, p);
                        if (!o[s].readonly) {
                            u.prepend('<span class="t-dirty" />')
                        }
                        if (o[s].hidden) {
                            u.hide()
                        }
                    }
                }
                return
            }
            var w = (n.data("tr") || n)[0];
            this._onCommand({
                name: "insert",
                row: w
            });
            v._validateForm(function () {
                var x = v.extractValues(n);
                if (b.trigger(v.element, "save", {
                    mode: "insert",
                    values: x,
                    form: v.form()[0]
                })) {
                    return
                }
                v.sendValues(x, "insertUrl", "insert")
            })
        },
        _validateForm: function (n) {
            var o = this.form();
            if (o.length) {
                var p = o.validate();
                if (p) {
                    this.validate();
                    p.settings.submitHandler = function () {
                        n();
                        p.settings.submitHandler = a.noop
                    };
                    o.submit()
                }
            }
        },
        _rowForData: function (v) {
            var u = this,
				n = (u.changeLog ? u.changeLog.inserted : []).concat(u.data || []),
				p = [];
            v = v ? v : {};
            for (var s in u.dataKeys) {
                p.push(u.valueFor({
                    member: s
                }))
            }
            for (var q = 0, t = n.length; q < t; q++) {
                var r = p.length - 1,
					o = p[r];
                while (o && o(v) === o(n[q])) {
                    o = p[--r]
                }
                if (r < 0) {
                    return u.$tbody.find(">tr:not(.t-grouping-row,.t-group-footer,.t-detail-row,.t-no-data,.t-footer-template)").eq(q)
                }
            }
        },
        updateRow: function (n) {
            var w = this;
            if (a.isPlainObject(n)) {
                var y = n;
                if (this.editing.mode != "InCell") {
                    j(y);
                    w.sendValues(y, "updateUrl", "update")
                } else {
                    n = w._rowForData(y);
                    if (!n) {
                        return
                    }
                    var u = w.rowIndex(n),
						p = w.changeLog,
						s = p.get(u) || w.dataItem(n),
						o = n.find("td:not(.t-hierarchy-cell,.t-group-cell)"),
						r = {},
						v, q;
                    for (var t in y) {
                        r[t] = y[t];
                        q = w.columnFromMember(t);
                        if (q && !q.readonly && p.update(u, s, r)) {
                            v = o.eq(a.inArray(q, w.columns));
                            w.cellEditor.display(v, r);
                            v.prepend('<span class="t-dirty" />')
                        }
                    }
                    n.closest("table").wrap(function () {
                        if (!a(this).parent().is("form")) {
                            return g(w.formId())
                        }
                    })
                }
                return
            }
            var x = (n.data("tr") || n)[0];
            this._onCommand({
                name: "update",
                row: x
            });
            w._validateForm(function () {
                var z = w.dataItem(x);
                var A = w.extractValues(n, (w.editing.mode != "InCell" || !w.ws));
                if (b.trigger(w.element, "save", {
                    mode: "edit",
                    dataItem: z,
                    values: A,
                    form: w.form()[0]
                })) {
                    return
                }
                if (w.editing.mode == "InCell") {
                    A = a.extend(z, A)
                }
                j(A);
                w.sendValues(A, "updateUrl", "update")
            })
        },
        deleteRow: function (n) {
            var p = a.isPlainObject(n),
				o, r, q = this;
            if (p) {
                o = n;
                n = q._rowForData(n);
                o = a.extend({}, this.dataItem(n), o);
                if (q.editing.mode != "InCell") {
                    if (!q._isServerOperation() && q.dataSource) {
                        q.deletedIds.push(q.dataSource.id(o))
                    }
                    j(o);
                    q.sendValues(o, "deleteUrl", "delete")
                } else {
                    q.changeLog.erase(q.rowIndex(n), o, n.hasClass("t-grid-new-row"));
                    if (!q._isServerOperation() && q.dataSource && o) {
                        q.deletedIds.push(q.dataSource.id(o))
                    }
                    n.next("tr.t-detail-row").remove();
                    q.cancelRow(n);
                    n.hide()
                }
                return
            }
            o = this.dataItem(n);
            this._onCommand({
                name: "delete",
                row: n[0]
            });
            if (this.editing.mode != "InCell") {
                r = this.extractValues(n, true);
                if (b.trigger(this.element, "delete", {
                    row: n[0],
                    dataItem: o,
                    values: r
                })) {
                    return
                }
                if (!this._isServerOperation() && this.dataSource) {
                    this.deletedIds.push(this.dataSource.id(o))
                }
                if (this.editing.confirmDelete === false || confirm(this.localization.deleteConfirmation)) {
                    this.sendValues(r, "deleteUrl", "delete")
                }
            } else {
                if (!n.hasClass("t-grid-new-row")) {
                    r = this.extractValues(n, true)
                }
                if (b.trigger(this.element, "delete", {
                    row: n[0],
                    dataItem: o,
                    values: r
                })) {
                    return
                }
                if (this.editing.confirmDelete === false || confirm(this.localization.deleteConfirmation)) {
                    this.changeLog.erase(this.rowIndex(n), o, n.hasClass("t-grid-new-row"));
                    if (this.td && a.contains(n[0], this.td)) {
                        this.td = null;
                        this.valid = true
                    }
                    if (!this._isServerOperation() && this.dataSource && o) {
                        this.deletedIds.push(this.dataSource.id(o))
                    }
                    n.next("tr.t-detail-row").remove();
                    this.cancelRow(n);
                    n.hide()
                }
            }
        },
        editRow: function (n) {
            var q = this.dataItem(n);
            this._onCommand({
                name: "edit",
                row: n[0]
            });
            if (this.editing.mode != "InCell") {
                c(a(this.element).closest(".t-edit-form")[0]);
                var p = this.rowEditor.edit(n, q);
                var r = this.form();
                r.undelegate(".t-grid-update", "click").delegate(".t-grid-update", "click", b.stopAll(a.proxy(function () {
                    this.updateRow(p)
                }, this))).undelegate(".t-grid-cancel", "click").delegate(".t-grid-cancel", "click", b.stopAll(a.proxy(function () {
                    this.cancelRow(n)
                }, this)));
                this.formViewBinder.bind(p, q);
                b.trigger(this.element, "edit", {
                    mode: "edit",
                    form: r[0],
                    dataItem: q
                });
                this.validation()
            } else {
                if (this.valid) {
                    var u = this.rowEditor.edit(n, q);
                    var o = u.find("td:not(.t-hierarchy-cell,.t-group-cell)");
                    var t = n.find(":input:visible:enabled:first");
                    this.td = t.closest("td")[0];
                    if (!this.td) {
                        var s = 0;
                        a.each(this.columns, function (w, v) {
                            if (!v.hidden && !v.readonly) {
                                s = w;
                                return false
                            }
                        });
                        this.td = o[s]
                    }
                    t.focus();
                    this.validation()
                }
            }
        },
        form: function () {
            return a("#" + this.formId())
        },
        addRow: function () {
            var q = a.extend(true, {}, this.editing.defaultDataItem);
            this._onCommand({
                name: "add"
            });
            if (this.editing.mode != "InCell") {
                c(a(this.element).closest(".t-edit-form")[0]);
                var p = this.rowEditor.insert(this.$tbody, q);
                var r = this.form();
                r.undelegate(".t-grid-insert", "click").delegate(".t-grid-insert", "click", b.stopAll(a.proxy(function () {
                    this.insertRow(p)
                }, this))).undelegate(".t-grid-cancel", "click").delegate(".t-grid-cancel", "click", b.stopAll(a.proxy(function () {
                    this.cancelRow(p)
                }, this)));
                b.trigger(this.element, "edit", {
                    mode: "insert",
                    form: r[0],
                    dataItem: q
                });
                this.validation()
            } else {
                if (this.valid) {
                    var v = this.rowEditor.insert(this.$tbody, q);
                    var o = v.find("td:not(.t-hierarchy-cell,.t-group-cell)");
                    var u = v.find(":input:enabled:visible:first");
                    this.changeLog.insert(q);
                    this.td = u.closest("td")[0];
                    if (!this.td) {
                        var t = 0;
                        a.each(this.columns, function (x, w) {
                            if (!w.hidden && !w.readonly) {
                                t = x;
                                return false
                            }
                        });
                        this.td = o[t]
                    }
                    for (var s = this.columns.length - 1; s >= 0; s--) {
                        if (!this.columns[s].readonly) {
                            var n = o.eq(s);
                            if (n[0] != this.td) {
                                n.prepend('<span class="t-dirty" />')
                            }
                        }
                    }
                    b.trigger(this.element, "edit", {
                        mode: "insert",
                        form: this.form()[0],
                        dataItem: q,
                        cell: this.td
                    });
                    this.validation();
                    u.focus()
                }
            }
            if (this.editing.mode != "PopUp") {
                this.$tbody.find(" > tr.t-no-data").hide()
            }
        },
        extractValues: function (n, q) {
            var s = this.modelBinder.bind(n);
            if (q) {
                var o = this.dataItem(n.data("tr") || n);
                for (var p in this.dataKeys) {
                    var r = this.valueFor({
                        member: p
                    })(o);
                    if (r instanceof Date) {
                        r = b.formatString("{0:G}", r)
                    }
                    s[this.ws ? p : this.dataKeys[p]] = r
                }
            }
            return s
        },
        cancelRow: function (n) {
            if (!n.length) {
                return
            }
            var p = (n.data("tr") || n)[0];
            var o = this.dataItem(n);
            this._onCommand({
                name: "cancel",
                row: p
            });
            this.rowEditor.cancel(n, o);
            if (n.is(".t-grid-new-row")) {
                if (!this.changeLog || !this.changeLog.inserted.length) {
                    this.$tbody.find(" > tr.t-no-data").show()
                }
                return
            }
            b.trigger(this.element, "rowDataBound", {
                row: n[0],
                dataItem: o
            })
        },
        validate: function () {
            var n = this.form();
            if (n.length) {
                var p = n.validate();
                var o = p.form();
                if (p.pendingRequest) {
                    p.formSubmitted = true;
                    return false
                }
                return o
            }
            return true
        },
        cancel: function () {
            this.cancelRow(this.$tbody.find(">.t-grid-edit-row"))
        },
        _dataSource: function () {
            var r = this,
				p = this._dataSourceOptions(),
				n = p.data,
				q = [],
				o = [];
            a.each(r.dataKeys, function (s, t) {
                q.push(t);
                o.push(b.getter(s))
            });
            if (r.isAjax()) {
                a.extend(true, p, {
                    model: b.Model.define({
                        id: function (s, u) {
                            var t;
                            if (u === undefined) {
                                return a.map(o, function (v) {
                                    return v(s)
                                }).join("-")
                            } else {
                                t = u.split("-");
                                a.each(q, function (v, w) {
                                    s[w] = t[v]
                                })
                            }
                        }
                    })
                })
            }
            r.dataSource = new b.DataSource(p);
            if (n && n.data) {
                r._convertInitialData(n.data)
            }
            r.dataSource.bind("change", a.proxy(r._dataChange, r))
        },
        _convert: function (u) {
            for (var p in u) {
                var t = u[p],
					n, o;
                if (t instanceof Date) {
                    n = this.columnFromMember(p);
                    o = "{0:G}";
                    if (n && n.format) {
                        o = n.format
                    }
                    u[p] = this.ws ? "\\/Date(" + t.getTime() + ")\\/" : b.formatString(o, t)
                }
                if (typeof t === "number") {
                    var q = "numeric",
						s = {
						    n: q,
						    p: "percent",
						    c: "currency",
						    "#": q,
						    "0": q
						};
                    n = this.columnFromMember(p), o = (n && n.format ? n.format : "N").toLowerCase(), t = t.toString();
                    var r = o.match(i) || o.match(d);
                    u[p] = r ? t.replace(".", b.cultureInfo[s[r] + "decimalseparator"]) : t
                }
                if (t == undefined) {
                    delete u[p]
                }
                if (a.isPlainObject(t)) {
                    this._convert(t)
                }
            }
            return u
        },
        sendValues: function (r, p, n) {
            if (this.editing.mode != "InCell" || !this.ws) {
                this._convert(r);
                for (var o in this.dataKeys) {
                    var q = this.valueFor({
                        member: o
                    })(r);
                    if (q != undefined) {
                        r[this.ws ? o : this.dataKeys[o]] = q
                    }
                }
            }
            this.showBusy();
            a.ajax(this.ajaxOptions({
                data: this.ws ? (this.editing.mode == "InCell" ? r : {
                    value: r
                }) : r,
                url: this.url(p),
                hasErrors: a.proxy(this.hasErrors, this),
                commandName: n,
                displayErrors: a.proxy(this.displayErrors, this)
            }))
        },
        displayErrors: function (n) {
            this.errorView.bind(a("#" + this.formId()), n.modelState)
        },
        hasErrors: function (n) {
            var o = n.modelState;
            var p = false;
            if (o) {
                a.each(o, function (q, r) {
                    if ("errors" in r) {
                        p = true;
                        return false
                    }
                })
            }
            return p
        },
        formId: function () {
            return a(this.element).attr("id") + "form"
        },
        validation: function () {
            this.validator().parse()
        },
        validator: function () {
            if (this.validationMetadata) {
                return new h(this.validationMetadata)
            } else {
                return new m("#" + this.formId())
            }
        }
    };
    b.grid.ModelBinder = function () {
        this.binders = {
            ":input.t-autocomplete": function () {
                return a(this).val()
            },
            ".t-numerictextbox :input": function () {
                return a(this).data("tTextBox").value()
            },
            ":input[name]:not(.t-input, :radio, :button),:radio:checked": function () {
                return a(this).val()
            },
            ":checkbox": function () {
                return a(this).is(":checked")
            },
            ".t-datepicker :input": function () {
                return a(this).data("tDatePicker").value()
            },
            ".t-timepicker :input": function () {
                return a(this).data("tTimePicker").value()
            },
            ".t-datetimepicker :input": function () {
                return a(this).data("tDateTimePicker").value()
            },
            ".t-editor textarea:hidden": function () {
                var n = a(this).closest(".t-editor").data("tEditor");
                if (n.encoded) {
                    return n.encodedValue()
                }
                return n.value()
            }
        };
        this.bind = function (n) {
            var o = {};
            a.each(this.binders, function (q, p) {
                n.find(q).each(function () {
                    if (!this.disabled) {
                        o[this.name] = p.call(this)
                    }
                })
            });
            return o
        }
    };
    b.grid.FormViewBinder = function (n) {
        this.converters = n || {};
        this.binders = {
            ':input:not(:radio):not([type="file"])': function (q) {
                if (typeof q == "boolean") {
                    q = q + ""
                }
                a(this).val(q)
            },
            ":checkbox": function (q) {
                a(this).attr("checked", q == true)
            },
            ":radio": function (r) {
                var q = a(this).val();
                if (typeof r == "boolean") {
                    q = q.toLowerCase()
                }
                if (q == r.toString()) {
                    a(this).attr("checked", true)
                }
            }
        };

        function p(q) {
            return function (r) {
                a(this).data(q).value(r)
            }
        }
        function o() {
            return function (q) {
                a(this).closest(".t-editor").data("tEditor").value(q)
            }
        }
        this.binders[".t-numerictextbox :input"] = p("tTextBox");
        this.binders[".t-dropdown :input:hidden"] = p("tDropDownList");
        this.binders[".t-datepicker :input"] = p("tDatePicker");
        this.binders[".t-datetimepicker :input"] = p("tDateTimePicker");
        this.binders[".t-timepicker :input"] = p("tTimePicker");
        this.binders[".t-slider :input"] = p("tSlider");
        this.binders[".t-combobox :input:hidden"] = p("tComboBox");
        this.binders[".t-editor textarea:hidden"] = o();
        this.evaluate = function (v, r) {
            if (r != null) {
                var x = v,
					s = false,
					u = r.split(".");
                while (u.length) {
                    var t = u.shift();
                    if (t.indexOf("[") > -1) {
                        x = new Function("d", "try { return d." + t + "}catch(e){}")(x);
                        if (x != null) {
                            s = true
                        } else {
                            x = v
                        }
                    } else {
                        if (x != null && typeof (x[t]) != "undefined") {
                            x = x[t];
                            s = true
                        } else {
                            if (s) {
                                s = false;
                                break
                            }
                        }
                    }
                }
                if (s && !a.isPlainObject(x)) {
                    var q = e.exec(x);
                    if (q) {
                        x = new Date(parseInt(q[1]))
                    }
                    var w = b.getType(x);
                    if (w in this.converters) {
                        x = this.converters[w](r, x)
                    }
                    return x
                }
            }
        };
        this.bind = function (q, r) {
            var s;
            a.each(this.binders, a.proxy(function (u, t) {
                q.find(u).each(a.proxy(function (w, v) {
                    var x = this.evaluate(r, v.name);
                    if (x != s) {
                        t.call(v, x)
                    }
                }, this))
            }, this))
        }
    };
    b.grid.CellBuilder = function (o) {
        function n(p, r) {
            var q = 0;
            a.each(o.columns, function (t, s) {
                if (!s.readonly && !s.hidden) {
                    q = t;
                    return false
                }
            });
            return a.map(o.columns, function (u, v) {
                var t = [];
                var s = b.splitClassesFromAttr(u.attr);
                if (v == q && r == "insert") {
                    t.push("t-grid-edit-cell")
                } else {
                    if (v == o.columns.length - 1) {
                        t.push("t-last")
                    }
                }
                if (s.classes) {
                    t.push(s.classes)
                }
                return "<td " + (s.attributes ? s.attributes : "") + (t.length ? ' class="' + t.join(" ") + '"' : "") + ">" + u[v == q ? r : "display"](p) + "</td>"
            }).join("")
        }
        this.edit = function (p) {
            return n(p, "edit")
        };
        this.insert = function (p) {
            return n(p, "insert")
        };
        this.display = function (p) {
            return n(p, "display")
        }
    };
    b.grid.DataCellBuilder = function (o) {
        function n(p, q) {
            return a.map(o.columns, function (r, s) {
                return "<td " + (r.attr ? r.attr : "") + (s == o.columns.length - 1 ? ' class="t-last">' : ">") + r[q](p) + "</td>"
            }).join("")
        }
        this.edit = function (p) {
            return n(p, "edit")
        };
        this.insert = function (p) {
            return n(p, "insert")
        };
        this.display = function (p) {
            if (o.rowTemplate) {
                return '<td colspan="' + o.columns.length + '">' + o.rowTemplate(p) + "</td>"
            }
            return n(p, "display")
        }
    };
    b.grid.FormContainerBuilder = function (o) {
        function n(p) {
            return '<div class="t-edit-form-container">' + o.html() + o[p]() + "</div>"
        }
        this.edit = function () {
            return n("edit")
        };
        this.insert = function () {
            return n("insert")
        }
    };

    function g(n) {
        return a("<form />", {
            id: n
        }).addClass("t-edit-form").submit(b.preventDefault)
    }
    b.grid.PopUpEditor = function (p) {
        var q;

        function n() {
            var r = q.data("tWindow");
            r && r.close();
            q.remove()
        }
        function o(r, s) {
            var t = p.settings;
            q = a("<div />", {
                id: p.container.id + "PopUp"
            }).appendTo(p.container).css({
                top: 0,
                left: "50%",
                marginLeft: -90
            }).tWindow(t).find(".t-window-content").append(p[s](r)).wrapInner(g(p.id)).end();
            a(p.container).one("dataBound", n);
            q.find(".t-close").click(b.stopAll(n)).end().data("tWindow").open().title((t && t.title) ? t.title : p[s + "Title"]);
            return q
        }
        this.edit = function (s, r) {
            s.addClass("t-grid-edit-row");
            return o(r, "edit").data("tr", s)
        };
        this.insert = function (s, r) {
            return o(r, "insert")
        };
        this.cancel = function (r) {
            r.removeClass("t-grid-edit-row");
            n()
        }
    };
    b.grid.Editor = function (p) {
        var n = p.groups ||
		function () {
		    return 0
		};

        function o(t, q, r) {
            var s = t.find(".t-group-cell,.t-hierarchy-cell");
            t.addClass("t-grid-edit-row").empty().append(s).append(p[r](q)).closest("table").wrap(function () {
                if (!a(this).parent().is("form")) {
                    return g(p.id)
                }
            })
        }
        this.cancel = function (r, q) {
            if (r.is(".t-grid-new-row")) {
                r.remove()
            } else {
                o(r, q, "cancel");
                r.removeClass("t-grid-edit-row")
            }
        };
        this.insert = function (q, r) {
            var s = '<tr class="t-grid-new-row">' + new Array(n() + 1).join('<td class="t-group-cell" />') + ((p.details) ? '<td class="t-hierarchy-cell"/>' : "") + "</tr>";
            var t = a(s);
            if (p.insertRow == "bottom") {
                q.append(t)
            } else {
                q.prepend(t)
            }
            o(t, r, "insert");
            if (p.insertRow == "bottom") {
                q.closest(".t-grid-content").scrollTop(t[0].offsetTop + t[0].offsetHeight)
            }
            return t
        };
        this.edit = function (r, q) {
            o(r, q, "edit");
            return r
        }
    };
    b.grid.CellEditor = function (n) {
        this.edit = function (r, q) {
            var o = n.columns[n.cellIndex(r)];
            if (!o.readonly) {
                r.parent().addClass("t-grid-edit-row").end().empty().html(o.edit(q)).closest("table").wrap(function () {
                    if (!a(this).parent().is("form")) {
                        return g(n.id)
                    }
                });
                n.bind(r, q);
                n.validate();
                r.find(":input:visible:first").trigger("focusin").focus();
                r.addClass("t-grid-edit-cell");
                if (a.browser.msie && a.browser.version < 9) {
                    var p = r.closest(".t-grid-content");
                    p.scrollLeft(p.scrollLeft())
                }
            }
            return !o.readonly
        };
        this.display = function (q, p) {
            var o = n.columns[n.cellIndex(q)];
            q.removeClass("t-grid-edit-cell").empty().html(o.display(p)).parent().removeClass("t-grid-edit-row")
        }
    };
    b.grid.ChangeLog = function (o, n) {
        this.insert = function (p, r) {
            if (r == undefined) {
                r = p;
                if (n == "bottom") {
                    this.inserted.push(r)
                } else {
                    this.inserted.splice(0, 0, r)
                }
            } else {
                var q = this.inserted[p];
                if (q === undefined) {
                    this.inserted.splice(0, 0, r)
                } else {
                    a.extend(q, r)
                }
            }
        };
        this.get = function (p, s) {
            s = typeof s === "undefined" ? true : s;
            var q = this.inserted[p],
				r = n == "bottom" ? 0 : this.inserted.length;
            if (s && this.inserted[p]) {
                return q
            }
            return this.updated[p - r]
        };
        this.update = function (r, u, w) {
            if (n !== "bottom") {
                r = r - this.inserted.length
            }
            var s = this.updated[r] || u || {};
            var q = false;
            for (var t in w) {
                var v = s[t],
					p = w[t];
                if (v instanceof Date) {
                    if (p instanceof Date && p.getTime() !== v.getTime()) {
                        q = true
                    }
                } else {
                    if (p !== v) {
                        q = true
                    }
                }
            }
            if (q) {
                this.updated[r] = a.extend({}, s, w)
            }
            return q
        };
        this.erase = function (p, t, r) {
            var q = this.inserted[p];
            if (n !== "bottom") {
                r = true
            }
            if (r && q) {
                this.inserted.splice(p, 1)
            } else {
                if (n !== "bottom") {
                    p = p - this.inserted.length
                }
                var s = this.updated[p];
                if (s) {
                    delete this.updated[p]
                }
                this.deleted[p] = t
            }
        };
        this.clear = function () {
            this.updated = new Array(o);
            this.deleted = new Array(o);
            this.inserted = []
        };
        this.serialize = function (q, r, p) {
            return a.extend({}, k(q, "inserted", function () {
                return true
            }), k(r, "updated", function (s) {
                return s !== undefined
            }), k(p, "deleted", function (s) {
                return s !== undefined
            }))
        };
        this.dirty = function () {
            if (this.inserted.length) {
                return true
            }
            for (var p = 0; p < this.updated.length; p++) {
                if (this.updated[p]) {
                    return true
                }
            }
            for (p = 0; p < this.deleted.length; p++) {
                if (this.deleted[p]) {
                    return true
                }
            }
            return false
        };
        this.clear()
    };
    b.grid.ErrorView = function () {
        this.bind = function (n, o) {
            n.find("span[id$=_validationMessage]").removeClass("field-validation-error").addClass("field-validation-valid").html("").end().find(".input-validation-error").removeClass("input-validation-error").addClass("valid");
            a.each(o, function (p, r) {
                if ("errors" in r && r.errors[0]) {
                    var q = p;
                    p = p.replace(".", "_");
                    n.find("#" + p + '_validationMessage, [data-valmsg-for="' + q + '"]').html(r.errors[0]).removeClass("field-validation-valid").addClass("field-validation-error").end().find("#" + p).removeClass("valid").addClass("input-validation-error")
                }
            })
        }
    }
})(jQuery);