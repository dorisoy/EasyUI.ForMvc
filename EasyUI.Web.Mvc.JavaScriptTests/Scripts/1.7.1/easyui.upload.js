(function (a) {
    var u, b = a.easyui,
		p = /\.([^\.]+)$/;
    b.scripts.push("easyui.upload.js");
    b.upload = function (w, x) {
        a.extend(this, x);
        this.element = w;
        this.name = w.name;
        var v = a(w);
        this.wrapper = v.closest(".t-upload");
        if (this.wrapper.length == 0) {
            this.wrapper = this._wrapInput(v)
        }
        this._setActiveInput(v);
        this.toggle(this.enabled);
        v.closest("form").bind({
            submit: a.proxy(this._onParentFormSubmit, this),
            reset: a.proxy(this._onParentFormReset, this)
        });
        if (this.async.saveUrl != u) {
            this._module = this._getSupportsFormData() ? new d(this) : new l(this)
        } else {
            this._module = new s(this)
        }
        if (this._getSupportsDrop()) {
            this._setupDropZone()
        }
        this.wrapper.delegate(".t-upload-action", "click", a.proxy(this._onFileAction, this)).delegate(".t-upload-selected", "click", a.proxy(this._onUploadSelected, this)).delegate(".t-file", "t:progress", a.proxy(this._onFileProgress, this)).delegate(".t-file", "t:upload-success", a.proxy(this._onUploadSuccess, this)).delegate(".t-file", "t:upload-error", a.proxy(this._onUploadError, this));
        b.bind(this.wrapper, {
            load: this.onLoad,
            select: this.onSelect,
            upload: this.onUpload,
            success: this.onSuccess,
            error: this.onError,
            complete: this.onComplete,
            cancel: this.onCancel,
            remove: this.onRemove
        });
        var y = a(this.wrapper).data("tUpload", this);
        a(w).bind("load", function () {
            b.trigger(y, "load")
        })
    };
    b.upload.prototype = {
        enable: function () {
            this.toggle(true)
        },
        disable: function () {
            this.toggle(false)
        },
        toggle: function (v) {
            v = typeof v === "undefined" ? v : !v;
            this.wrapper.toggleClass("t-state-disabled", v)
        },
        _addInput: function (v) {
            v.insertAfter(this.element).data("tUpload", this);
            a(this.element).hide().removeAttr("id");
            this._setActiveInput(v)
        },
        _setActiveInput: function (v) {
            var w = this.wrapper;
            this.element = v;
            v.attr("multiple", this._getSupportsMultiple() ? this.multiple : false).attr("autocomplete", "off").click(function (x) {
                if (w.hasClass("t-state-disabled")) {
                    x.preventDefault()
                }
            }).change(a.proxy(this._onInputChange, this))
        },
        _onInputChange: function (v) {
            var y = this,
				w = a(v.target),
				x = b.trigger(y.wrapper, "select", {
				    files: k(w)
				});
            if (x) {
                y._addInput(w.clone().val(""));
                w.remove()
            } else {
                w.trigger("t:select")
            }
        },
        _onDrop: function (x) {
            var w = x.originalEvent.dataTransfer,
				v = w.files;
            q(x);
            if (v.length > 0) {
                var y = b.trigger(this.wrapper, "select", {
                    files: e(v)
                });
                if (!y) {
                    a(".t-dropzone", this.wrapper).trigger("t:select", [v])
                }
            }
        },
        _enqueueFile: function (z, v) {
            var y = a(".t-upload-files", this.wrapper);
            if (y.length == 0) {
                y = a("<ul class='t-upload-files t-reset'></ul>").appendTo(this.wrapper);
                if (!this.showFileList) {
                    y.hide()
                }
            }
            var w = a(".t-file", y);
            var x = a("<li class='t-file'><span class='t-icon'></span><span class='t-filename' title='" + z + "'>" + z + "</span></li>").appendTo(y).data(v);
            if (!this.multiple) {
                w.trigger("t:remove")
            }
            return x
        },
        _removeFileEntry: function (w) {
            var x = w.closest(".t-upload-files"),
				v;
            w.remove();
            v = a(".t-file", x);
            if (v.find("> .t-fail").length === v.length) {
                this._hideUploadButton()
            }
            if (v.length == 0) {
                x.remove()
            }
        },
        _setFileAction: function (x, v) {
            var w = {
                remove: "t-delete",
                cancel: "t-cancel",
                retry: "t-retry"
            };
            if (!w.hasOwnProperty(v)) {
                return
            }
            this._clearFileAction(x);
            x.append(this._renderAction(w[v], this.localization[v]).addClass("t-upload-action"))
        },
        _setFileState: function (w, y) {
            var z = {
                uploading: {
                    cssClass: "t-loading",
                    text: this.localization.statusUploading
                },
                uploaded: {
                    cssClass: "t-success",
                    text: this.localization.statusUploaded
                },
                failed: {
                    cssClass: "t-fail",
                    text: this.localization.statusFailed
                }
            };
            var v = z[y];
            if (v) {
                var x = w.children(".t-icon").text(v.text);
                x[0].className = "t-icon " + v.cssClass
            }
        },
        _renderAction: function (v, w) {
            if (v != "") {
                return a("<button type='button' class='t-button t-button-icontext'><span class='t-icon " + v + "'></span>" + w + "</button>")
            } else {
                return a("<button type='button' class='t-button'>" + w + "</button>")
            }
        },
        _clearFileAction: function (v) {
            v.find(".t-upload-action").remove()
        },
        _onFileAction: function (w) {
            if (!this.wrapper.hasClass("t-state-disabled")) {
                var v = a(w.target).closest(".t-upload-action"),
					z = v.find(".t-icon"),
					y = v.closest(".t-file"),
					x = {
					    files: y.data("fileNames")
					};
                if (z.hasClass("t-delete")) {
                    if (!b.trigger(this.wrapper, "remove", x)) {
                        y.trigger("t:remove", x.data)
                    }
                } else {
                    if (z.hasClass("t-cancel")) {
                        b.trigger(this.wrapper, "cancel", x);
                        y.trigger("t:cancel");
                        this._checkAllComplete()
                    } else {
                        if (z.hasClass("t-retry")) {
                            y.trigger("t:retry")
                        }
                    }
                }
            }
            return false
        },
        _onUploadSelected: function () {
            this.wrapper.trigger("t:saveSelected");
            return false
        },
        _onFileProgress: function (v, w) {
            var x = a(".t-progress-status", v.target);
            if (x.length == 0) {
                x = a("<span class='t-progress'><span class='t-progress-status' style='width: 0;'></span></span>").appendTo(a(".t-filename", v.target)).find(".t-progress-status")
            }
            x.width(w + "%")
        },
        _onUploadSuccess: function (v, x, y) {
            var w = g(v);
            this._setFileState(w, "uploaded");
            b.trigger(this.wrapper, "success", {
                files: w.data("fileNames"),
                response: x,
                operation: "upload",
                XMLHttpRequest: y
            });
            if (this._supportsRemove()) {
                this._setFileAction(w, "remove")
            } else {
                this._clearFileAction(w)
            }
            this._checkAllComplete()
        },
        _onUploadError: function (v, y) {
            var w = g(v);
            this._setFileState(w, "failed");
            this._setFileAction(w, "retry");
            var x = b.trigger(this.wrapper, "error", {
                operation: "upload",
                files: w.data("fileNames"),
                XMLHttpRequest: y
            });
            n("Server response: " + y.responseText);
            if (!x) {
                this._alert("Error! Upload failed. Unexpected server response - see console.")
            }
            this._checkAllComplete()
        },
        _showUploadButton: function () {
            var v = a(".t-upload-selected", this.wrapper);
            if (v.length == 0) {
                v = this._renderAction("", this.localization.uploadSelectedFiles).addClass("t-upload-selected")
            }
            this.wrapper.append(v)
        },
        _hideUploadButton: function () {
            a(".t-upload-selected", this.wrapper).remove()
        },
        _onParentFormSubmit: function () {
            var x = this,
				v = x.element;
            v.trigger("t:abort");
            if (!v.value) {
                var w = a(v);
                w.attr("disabled", "disabled");
                window.setTimeout(function () {
                    w.removeAttr("disabled")
                }, 0)
            }
        },
        _onParentFormReset: function () {
            a(".t-upload-files", this.wrapper).remove()
        },
        _getSupportsFormData: function () {
            return typeof (FormData) != "undefined"
        },
        _getSupportsMultiple: function () {
            return !a.browser.opera
        },
        _getSupportsDrop: function () {
            var y = this._getUserAgent().toLowerCase(),
				v = /chrome/.test(y),
				w = !v && /safari/.test(y),
				x = w && /windows/.test(y);
            return !x && this._getSupportsFormData() && (this.async.saveUrl != u)
        },
        _getUserAgent: function () {
            return navigator.userAgent
        },
        _setupDropZone: function () {
            a(".t-upload-button", this.wrapper).wrap("<div class='t-dropzone'></div>");
            var v = a(".t-dropzone", this.wrapper).append(a("<em>" + this.localization.dropFilesHere + "</em>")).bind({
                dragenter: q,
                dragover: function (w) {
                    w.preventDefault()
                },
                drop: a.proxy(this._onDrop, this)
            });
            c(v, function () {
                v.addClass("t-dropzone-hovered")
            }, function () {
                v.removeClass("t-dropzone-hovered")
            });
            c(a(document), function () {
                v.addClass("t-dropzone-active")
            }, function () {
                v.removeClass("t-dropzone-active")
            })
        },
        _supportsRemove: function () {
            return this.async.removeUrl != u
        },
        _submitRemove: function (w, v, y, x) {
            var z = a.extend(v, f());
            z.fileNames = w;
            a.ajax({
                type: "POST",
                dataType: "json",
                url: this.async.removeUrl,
                traditional: true,
                data: z,
                success: y,
                error: x
            })
        },
        _alert: function (v) {
            alert(v)
        },
        _wrapInput: function (v) {
            v.wrap("<div class='t-widget t-upload'><div class='t-button t-upload-button'></div></div>");
            v.closest(".t-button").append("<span>" + this.localization.select + "</span>");
            return v.closest(".t-upload")
        },
        _checkAllComplete: function () {
            if (a(".t-file .t-icon.t-loading", this.wrapper).length == 0) {
                b.trigger(this.wrapper, "complete")
            }
        }
    };
    a.fn.tUpload = function (v) {
        return b.create(this, {
            name: "tUpload",
            init: function (w, x) {
                return new b.upload(w, x)
            },
            options: v
        })
    };
    a.fn.tUpload.defaults = {
        enabled: true,
        multiple: true,
        showFileList: true,
        async: {},
        localization: {
            select: "Select...",
            cancel: "Cancel",
            retry: "Retry",
            remove: "Remove",
            uploadSelectedFiles: "Upload files",
            dropFilesHere: "drop files here to upload",
            statusUploading: "uploading",
            statusUploaded: "uploaded",
            statusFailed: "failed"
        }
    };
    var s = function (v) {
        this.name = "syncUploadModule";
        this.element = v.wrapper;
        this.upload = v;
        this.element.bind("t:select", a.proxy(this.onSelect, this)).bind("t:remove", a.proxy(this.onRemove, this)).closest("form").attr("enctype", "multipart/form-data").attr("encoding", "multipart/form-data")
    };
    s.prototype = {
        onSelect: function (v) {
            var y = this.upload;
            var x = a(v.target);
            y._addInput(x.clone().val(""));
            var w = y._enqueueFile(j(x), {
                relatedInput: x,
                fileNames: k(x)
            });
            y._setFileAction(w, "remove")
        },
        onRemove: function (v) {
            var w = g(v);
            w.data("relatedInput").remove();
            this.upload._removeFileEntry(w)
        }
    };
    var l = function (v) {
        this.name = "iframeUploadModule";
        this.element = v.wrapper;
        this.upload = v;
        this.iframes = [];
        this.element.bind("t:select", a.proxy(this.onSelect, this)).bind("t:cancel", a.proxy(this.onCancel, this)).bind("t:retry", a.proxy(this.onRetry, this)).bind("t:remove", a.proxy(this.onRemove, this)).bind("t:saveSelected", a.proxy(this.onSaveSelected, this)).bind("t:abort", a.proxy(this.onAbort, this))
    };
    b.upload._frameId = 0;
    l.prototype = {
        onSelect: function (v) {
            var y = this.upload,
				x = a(v.target);
            var w = this.prepareUpload(x);
            if (y.async.autoUpload) {
                this.performUpload(w)
            } else {
                if (y._supportsRemove()) {
                    this.upload._setFileAction(w, "remove")
                }
                y._showUploadButton()
            }
        },
        prepareUpload: function (A) {
            var B = this.upload;
            var v = a(B.element);
            var z = B.async.saveField || A.attr("name");
            B._addInput(A.clone().val(""));
            A.attr("name", z);
            var y = this.createFrame(B.name + "_" + b.upload._frameId++);
            this.registerFrame(y);
            var x = this.createForm(B.async.saveUrl, y.attr("name")).append(v);
            var w = B._enqueueFile(j(A), {
                frame: y,
                relatedInput: v,
                fileNames: k(A)
            });
            y.data({
                form: x,
                file: w
            });
            return w
        },
        performUpload: function (x) {
            var w = {
                files: x.data("fileNames")
            },
				z = x.data("frame"),
				B = this.upload;
            if (!b.trigger(B.wrapper, "upload", w)) {
                B._hideUploadButton();
                z.appendTo(document.body);
                var y = z.data("form").appendTo(document.body);
                w.data = a.extend({}, w.data, f());
                for (var A in w.data) {
                    var v = y.find("input[name='" + A + "']");
                    if (v.length == 0) {
                        v = a("<input>", {
                            type: "hidden",
                            name: A
                        }).prependTo(y)
                    }
                    v.val(w.data[A])
                }
                B._setFileAction(x, "cancel");
                B._setFileState(x, "uploading");
                z.one("load", a.proxy(this.onIframeLoad, this));
                y[0].submit()
            } else {
                B._removeFileEntry(z.data("file"));
                this.cleanupFrame(z);
                this.unregisterFrame(z)
            }
        },
        onSaveSelected: function (v) {
            var w = this;
            a(".t-file", this.element).each(function () {
                var x = a(this),
					y = m(x);
                if (!y) {
                    w.performUpload(x)
                }
            })
        },
        onIframeLoad: function (v) {
            var w = a(v.target);
            try {
                var x = w.contents().text()
            } catch (v) {
                x = "Error trying to get server response: " + v
            }
            this.processResponse(w, x)
        },
        processResponse: function (x, z) {
            var w = x.data("file"),
				y = this,
				v = {
				    responseText: z
				};
            t(z, function (A) {
                a.extend(v, {
                    statusText: "OK",
                    status: "200"
                });
                w.trigger("t:upload-success", [A, v]);
                y.cleanupFrame(x);
                y.unregisterFrame(x)
            }, function () {
                a.extend(v, {
                    statusText: "error",
                    status: "500"
                });
                w.trigger("t:upload-error", [v])
            })
        },
        onCancel: function (v) {
            var w = a(v.target).data("frame");
            this.stopFrameSubmit(w);
            this.cleanupFrame(w);
            this.unregisterFrame(w);
            this.upload._removeFileEntry(w.data("file"))
        },
        onRetry: function (v) {
            var w = g(v);
            this.performUpload(w)
        },
        onRemove: function (w, v) {
            var x = g(w);
            var y = x.data("frame");
            if (y) {
                this.unregisterFrame(y);
                this.upload._removeFileEntry(x);
                this.cleanupFrame(y)
            } else {
                o(x, this.upload, v)
            }
        },
        onAbort: function () {
            var v = this.element,
				w = this;
            a.each(this.iframes, function () {
                a("input", this.data("form")).appendTo(v);
                w.stopFrameSubmit(this[0]);
                this.data("form").remove();
                this.remove()
            });
            this.iframes = []
        },
        createFrame: function (v) {
            return a("<iframe name='" + v + "' id='" + v + "' style='display:none;' />")
        },
        createForm: function (v, w) {
            return a("<form enctype='multipart/form-data' method='POST' action='" + v + "' target='" + w + "'/>")
        },
        stopFrameSubmit: function (v) {
            if (typeof (v.stop) != "undefined") {
                v.stop()
            } else {
                if (v.document) {
                    v.document.execCommand("Stop");
                    v.contentWindow.location.href = v.contentWindow.location.href
                }
            }
        },
        registerFrame: function (v) {
            this.iframes.push(v)
        },
        unregisterFrame: function (v) {
            this.iframes = a.grep(this.iframes, function (w) {
                return w.attr("name") != v.attr("name")
            })
        },
        cleanupFrame: function (w) {
            var v = w.data("form");
            w.data("file").data("frame", null);
            setTimeout(function () {
                v.remove();
                w.remove()
            }, 1)
        }
    };
    var d = function (v) {
        this.name = "formDataUploadModule";
        this.element = v.wrapper;
        this.upload = v;
        this.element.bind("t:select", a.proxy(this.onSelect, this)).bind("t:cancel", a.proxy(this.onCancel, this)).bind("t:remove", a.proxy(this.onRemove, this)).bind("t:retry", a.proxy(this.onRetry, this)).bind("t:saveSelected", a.proxy(this.onSaveSelected, this)).bind("t:abort", a.proxy(this.onAbort, this))
    };
    d.prototype = {
        onSelect: function (v, z) {
            var B = this.upload,
				y = this,
				A = a(v.target),
				x = z ? e(z) : this.getInputFiles(A),
				w = this.prepareUpload(A, x);
            a.each(w, function () {
                if (B.async.autoUpload) {
                    y.performUpload(this)
                } else {
                    if (B._supportsRemove()) {
                        B._setFileAction(this, "remove")
                    }
                    B._showUploadButton()
                }
            })
        },
        prepareUpload: function (x, w) {
            var v = this.enqueueFiles(w);
            if (x.is("input")) {
                a.each(v, function () {
                    a(this).data("relatedInput", x)
                });
                x.data("relatedFileEntries", v);
                this.upload._addInput(x.clone().val(""))
            }
            return v
        },
        enqueueFiles: function (x) {
            var A = this.upload;
            fileEntries = [];
            for (var y = 0; y < x.length; y++) {
                var v = x[y],
					z = v.name;
                var w = A._enqueueFile(z, {
                    fileNames: [v]
                });
                w.data("file", v);
                fileEntries.push(w)
            }
            return fileEntries
        },
        getInputFiles: function (v) {
            return k(v)
        },
        performUpload: function (w) {
            var z = this.upload,
				x = this.createFormData(w.data("file")),
				v = {
				    files: w.data("fileNames")
				};
            if (!b.trigger(this.element, "upload", v)) {
                z._setFileAction(w, "cancel");
                z._hideUploadButton();
                v.data = a.extend({}, v.data, f());
                for (var y in v.data) {
                    x.append(y, v.data[y])
                }
                z._setFileState(w, "uploading");
                this.postFormData(this.upload.async.saveUrl, x, w)
            } else {
                this.removeFileEntry(w)
            }
        },
        onSaveSelected: function (v) {
            var w = this;
            a(".t-file", this.element).each(function () {
                var x = a(this),
					y = m(x);
                if (!y) {
                    w.performUpload(x)
                }
            })
        },
        onCancel: function (v) {
            var w = g(v);
            this.stopUploadRequest(w);
            this.removeFileEntry(w)
        },
        onRetry: function (v) {
            var w = g(v);
            this.performUpload(w)
        },
        onRemove: function (w, v) {
            var x = g(w);
            if (x.children(".t-icon").is(".t-success")) {
                o(x, this.upload, v)
            } else {
                this.removeFileEntry(x)
            }
        },
        postFormData: function (y, v, w) {
            var z = new XMLHttpRequest(),
				x = this;
            w.data("request", z);
            z.addEventListener("load", function (A) {
                x.onRequestSuccess.call(x, A, w)
            }, false);
            z.addEventListener("error", function (A) {
                x.onRequestError.call(x, A, w)
            }, false);
            z.upload.addEventListener("progress", function (A) {
                x.onRequestProgress.call(x, A, w)
            }, false);
            z.open("POST", y);
            z.send(v)
        },
        createFormData: function (v) {
            var w = new FormData(),
				x = this.upload;
            w.append(x.async.saveField || x.name, v.rawFile);
            return w
        },
        onRequestSuccess: function (v, w) {
            var y = v.target,
				x = this;
            t(y.responseText, function (z) {
                w.trigger("t:upload-success", [z, y]);
                w.trigger("t:progress", [100]);
                x.cleanupFileEntry(w)
            }, function () {
                w.trigger("t:upload-error", [y])
            })
        },
        onRequestError: function (v, w) {
            var x = v.target;
            w.trigger("t:upload-error", [x])
        },
        cleanupFileEntry: function (v) {
            var w = v.data("relatedInput"),
				x = true;
            if (w) {
                a.each(w.data("relatedFileEntries"), function () {
                    if (this.parent().length > 0 && this[0] != v[0]) {
                        x = x && this.children(".t-icon").is(".t-success")
                    }
                });
                if (x) {
                    w.remove()
                }
            }
        },
        removeFileEntry: function (v) {
            this.cleanupFileEntry(v);
            this.upload._removeFileEntry(v)
        },
        onRequestProgress: function (v, w) {
            var x = Math.round(v.loaded * 100 / v.total);
            w.trigger("t:progress", [x])
        },
        stopUploadRequest: function (v) {
            v.data("request").abort()
        }
    };

    function j(v) {
        return a.map(k(v), function (w) {
            return w.name
        }).join(", ")
    }
    function k(v) {
        var w = v[0];
        if (w.files) {
            return e(w.files)
        } else {
            return [{
                name: r(w.value),
                extension: h(w.value),
                size: null
            }]
        }
    }
    function e(v) {
        return a.map(v, function (w) {
            return i(w)
        })
    }
    function i(w) {
        var v = w.name || w.fileName;
        return {
            name: v,
            extension: h(v),
            size: w.size || w.fileSize,
            rawFile: w
        }
    }
    function h(v) {
        var w = v.match(p);
        return w ? w[0] : ""
    }
    function r(v) {
        var w = v.lastIndexOf("\\");
        return (w != -1) ? v.substr(w + 1) : v
    }
    function o(w, B, v) {
        if (!B._supportsRemove()) {
            return
        }
        var y = w.data("fileNames");
        var x = a.map(y, function (C) {
            return C.name
        });
        B._submitRemove(x, v, function A(C, D, E) {
            B._removeFileEntry(w);
            b.trigger(B.wrapper, "success", {
                operation: "remove",
                files: y,
                response: C,
                XMLHttpRequest: E
            })
        }, function z(E, D, D) {
            var C = b.trigger(B.wrapper, "error", {
                operation: "remove",
                files: y,
                XMLHttpRequest: E
            });
            n("Server response: " + E.responseText);
            if (!C) {
                B._alert("Error! Remove operation failed. Unexpected response - see console.")
            }
        })
    }
    function t(w, z, y) {
        try {
            var x = a.parseJSON(w)
        } catch (v) {
            y();
            return
        }
        z(x)
    }
    function q(v) {
        v.stopPropagation();
        v.preventDefault()
    }
    function c(v, y, z) {
        var w, x;
        v.bind("dragenter", function (A) {
            y();
            x = new Date();
            if (!w) {
                w = setInterval(function () {
                    var B = new Date() - x;
                    if (B > 100) {
                        z();
                        clearInterval(w);
                        w = null
                    }
                }, 100)
            }
        }).bind("dragover", function (A) {
            x = new Date()
        })
    }
    function m(v) {
        return v.children(".t-icon").is(".t-loading, .t-success, .t-fail")
    }
    function n(v) {
        if (typeof (console) != "undefined" && console.log) {
            console.log(v)
        }
    }
    function g(v) {
        return a(v.target).closest(".t-file")
    }
    function f() {
        var v = {};
        a("input[name^='__RequestVerificationToken']").each(function () {
            v[this.name] = this.value
        });
        return v
    }
})(jQuery);