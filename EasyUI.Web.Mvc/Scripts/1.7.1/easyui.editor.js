﻿(function(a) {
    var b = a.easyui;
    b.scripts.push("easyui.editor.js");

    function ax(bd) {
        var be = {};
        for (var bc = 0; bc < bd.length; bc++) {
            be[bd[bc]] = true
        }
        return be
    }
    var z = ax("area,base,basefont,br,col,frame,hr,img,input,isindex,link,meta,param,embed".split(",")),
		g = "div,p,h1,h2,h3,h4,h5,h6,address,applet,blockquote,button,center,dd,dir,dl,dt,fieldset,form,frameset,hr,iframe,isindex,li,map,menu,noframes,noscript,object,ol,pre,script,table,tbody,td,tfoot,th,thead,tr,ul".split(","),
		f = ax(g),
		ad = "span,em,a,abbr,acronym,applet,b,basefont,bdo,big,br,button,cite,code,del,dfn,font,i,iframe,img,input,ins,kbd,label,map,object,q,s,samp,script,select,small,strike,strong,sub,sup,textarea,tt,u,var".split(","),
		ac = ax(ad),
		E = ax("checked,compact,declare,defer,disabled,ismap,multiple,nohref,noresize,noshade,nowrap,readonly,selected".split(","));
    var aB = function(bc) {
        if (bc.nodeType == 1) {
            bc.normalize()
        }
    };
    if (a.browser.msie && parseInt(a.browser.version) >= 8) {
        aB = function(bd) {
            if (bd.nodeType == 1 && bd.firstChild) {
                var be = bd.firstChild,
					bc = be;
                while (bc = bc.nextSibling) {
                    if (bc.nodeType == 3 && be.nodeType == 3) {
                        bc.nodeValue = be.nodeValue + bc.nodeValue;
                        x.remove(be)
                    }
                    be = bc
                }
            }
        }
    }
    function G(bd) {
        var bc = 0;
        while (bd = bd.previousSibling) {
            bc++
        }
        return bc
    }
    function am(bc) {
        return bc && bc.nodeValue !== null && bc.data !== null
    }
    function ak(be, bd) {
        try {
            return !am(be) && (a.contains(be, am(bd) ? bd.parentNode : bd) || bd.parentNode == be)
        } catch (bc) {
            return false
        }
    }
    function al(bd, bc) {
        return ak(bd, bc) || bd == bc
    }
    function F(bd, bc) {
        if (ak(bd, bc)) {
            while (bc && bc.parentNode != bd) {
                bc = bc.parentNode
            }
        }
        return bc
    }
    function T(bc) {
        return am(bc) ? bc.length : bc.childNodes.length
    }
    function aU(bf, bg) {
        var be = bf.cloneNode(false),
			bc = "",
			bd = bf;
        while (bd.nextSibling && bd.nextSibling.nodeType == 3 && bd.nextSibling.nodeValue) {
            bc += bd.nextSibling.nodeValue;
            bd = bd.nextSibling
        }
        bf.deleteData(bg, bf.length);
        be.deleteData(0, bg);
        be.nodeValue += bc;
        x.insertAfter(be, bf)
    }
    function e(be, bc) {
        for (var bd in bc) {
            var bf = be[bd];
            if (bd == "float") {
                bf = be[a.support.cssFloat ? "cssFloat" : "styleFloat"]
            }
            if (typeof bf == "object") {
                if (!e(bf, bc[bd])) {
                    return false
                }
            } else {
                if (bf != bc[bd]) {
                    return false
                }
            }
        }
        return true
    }
    var ba = /^\s+$/;
    var aM = /rgb\s*\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*\)/i;
    var t = ("color,padding-left,padding-right,padding-top,padding-bottom,background-color,background-attachment,background-image,background-position,background-repeat,border-top-style,border-top-width,border-top-color,border-bottom-style,border-bottom-width,border-bottom-color,border-left-style,border-left-width,border-left-color,border-right-style,border-right-width,border-right-color,font-family,font-size,font-style,font-variant,font-weight,line-height").split(",");
    var x = {
        isAncestorOrSelf: al,
        blockParentOrBody: function(bc) {
            return x.parentOfType(bc, g) || bc.ownerDocument.body
        },
        normalize: aB,
        toHex: function(bc) {
            var bd = aM.exec(bc);
            if (!bd) {
                return bc
            }
            return "#" + a.map(bd.slice(1), function(be) {
                return be = parseInt(be).toString(16), be.length > 1 ? be : "0" + be
            }).join("")
        },
        encode: function(bc) {
            return bc.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/ /g, "&nbsp;")
        },
        name: function(bc) {
            return bc.nodeName.toLowerCase()
        },
        significantChildNodes: function(bc) {
            return a.grep(bc.childNodes, function(bd) {
                return bd.nodeType != 3 || !x.isWhitespace(bd)
            })
        },
        lastTextNode: function(bd) {
            if (bd.nodeType == 3) {
                return bd
            }
            var be = null;
            for (var bc = bd.lastChild; bc; bc = bc.previousSibling) {
                if (be = x.lastTextNode(bc)) {
                    return be
                }
            }
            return be
        },
        is: function(bc, bd) {
            return x.name(bc) == bd
        },
        isMarker: function(bc) {
            return bc.className == "t-marker"
        },
        isWhitespace: function(bc) {
            return ba.test(bc.nodeValue)
        },
        isBlock: function(bc) {
            return f[x.name(bc)]
        },
        isEmpty: function(bc) {
            return z[x.name(bc)]
        },
        isInline: function(bc) {
            return ac[x.name(bc)]
        },
        scrollTo: function(bc) {
            bc.ownerDocument.body.scrollTop = a(am(bc) ? bc.parentNode : bc).offset().top
        },
        insertAt: function(bd, bc, be) {
            bd.insertBefore(bc, bd.childNodes[be] || null)
        },
        insertBefore: function(bc, bd) {
            if (bd.parentNode) {
                return bd.parentNode.insertBefore(bc, bd)
            } else {
                return bd
            }
        },
        insertAfter: function(bc, bd) {
            return bd.parentNode.insertBefore(bc, bd.nextSibling)
        },
        remove: function(bc) {
            bc.parentNode.removeChild(bc)
        },
        trim: function(be) {
            for (var bc = be.childNodes.length - 1; bc >= 0; bc--) {
                var bd = be.childNodes[bc];
                if (am(bd)) {
                    if (bd.nodeValue.replace(/﻿/g, "").length == 0) {
                        x.remove(bd)
                    }
                    if (x.isWhitespace(bd)) {
                        x.insertBefore(bd, be)
                    }
                } else {
                    if (bd.className != "t-marker") {
                        x.trim(bd);
                        if (bd.childNodes.length == 0 && !x.isEmpty(bd)) {
                            x.remove(bd)
                        }
                    }
                }
            }
            return be
        },
        parentOfType: function(bc, bd) {
            do {
                bc = bc.parentNode
            } while (bc && !(x.ofType(bc, bd)));
            return bc
        },
        ofType: function(bc, bd) {
            return a.inArray(x.name(bc), bd) >= 0
        },
        changeTag: function(bh, bi) {
            var bg = x.create(bh.ownerDocument, bi);
            var bd = bh.attributes;
            for (var be = 0; be < bd.length; be++) {
                var bc = bd[be];
                if (bc.specified) {
                    var bf = bc.nodeName;
                    var bj = bc.nodeValue;
                    if (bf == "class") {
                        bg.className = bj
                    } else {
                        if (bf == "style") {
                            bg.style.cssText = bh.style.cssText
                        } else {
                            bg.setAttribute(bf, bj)
                        }
                    }
                }
            }
            while (bh.firstChild) {
                bg.appendChild(bh.firstChild)
            }
            x.insertBefore(bg, bh);
            x.remove(bh);
            return bg
        },
        wrap: function(bc, bd) {
            x.insertBefore(bd, bc);
            bd.appendChild(bc);
            return bd
        },
        unwrap: function(bc) {
            var bd = bc.parentNode;
            while (bc.firstChild) {
                bd.insertBefore(bc.firstChild, bc)
            }
            bd.removeChild(bc)
        },
        create: function(bd, be, bc) {
            return x.attr(bd.createElement(be), bc)
        },
        attr: function(bd, bc) {
            bc = a.extend({}, bc);
            if (bc && "style" in bc) {
                x.style(bd, bc.style);
                delete bc.style
            }
            return a.extend(bd, bc)
        },
        style: function(bc, bd) {
            a(bc).css(bd || {})
        },
        unstyle: function(bd, be) {
            for (var bc in be) {
                if (bc == "float") {
                    bc = a.support.cssFloat ? "cssFloat" : "styleFloat"
                }
                bd.style[bc] = ""
            }
            if (bd.style.cssText == "") {
                bd.removeAttribute("style")
            }
        },
        inlineStyle: function(be, bf, bd) {
            var bg = x.create(be, bf, bd);
            be.body.appendChild(bg);
            var bc = a(bg);
            var bh = a.map(t, function(bi) {
                if (a.browser.msie && bi == "line-height" && bc.css(bi) == "1px") {
                    return "line-height:1.5"
                } else {
                    return bi + ":" + bc.css(bi)
                }
            }).join(";");
            bc.remove();
            return bh
        },
        removeClass: function(bg, be) {
            var bd = " " + bg.className + " ",
				bc = be.split(" ");
            for (var bf = 0; bf < bc.length; bf++) {
                bd = bd.replace(" " + bc[bf] + " ", " ")
            }
            bd = a.trim(bd);
            if (bd.length) {
                bg.className = bd
            } else {
                bg.removeAttribute("class")
            }
        },
        commonAncestor: function() {
            var bd = arguments.length;
            if (!bd) {
                return null
            }
            if (bd == 1) {
                return arguments[0]
            }
            var bk = [];
            var bh = Infinity;
            for (var bf = 0; bf < bd; bf++) {
                var bc = [];
                var bi = arguments[bf];
                while (bi) {
                    bc.push(bi);
                    bi = bi.parentNode
                }
                bk.push(bc.reverse());
                bh = Math.min(bh, bc.length)
            }
            if (bd == 1) {
                return bk[0][0]
            }
            var bj = null;
            for (bf = 0; bf < bh; bf++) {
                var be = bk[0][bf];
                for (var bg = 1; bg < bd; bg++) {
                    if (be != bk[bg][bf]) {
                        return bj
                    }
                }
                bj = be
            }
            return bj
        }
    };
    var K = "xx-small,x-small,small,medium,large,x-large,xx-large".split(","),
		aH = /"/g,
		m = /<br[^>]*>/i,
		B = /<p><\/p>/i;

    function y(bg) {
        var bf = [];
        var bh = {
            "easyui:script": {
                start: function(bi) {
                    bf.push("<script");
                    bc(bi);
                    bf.push(">")
                },
                end: function() {
                    bf.push("</script>")
                }
            },
            b: {
                start: function() {
                    bf.push("<strong>")
                },
                end: function() {
                    bf.push("</strong>")
                }
            },
            i: {
                start: function() {
                    bf.push("<em>")
                },
                end: function() {
                    bf.push("</em>")
                }
            },
            u: {
                start: function() {
                    bf.push('<span style="text-decoration:underline;">')
                },
                end: function() {
                    bf.push("</span>")
                }
            },
            iframe: {
                start: function(bi) {
                    bf.push("<iframe");
                    bc(bi);
                    bf.push(">")
                },
                end: function() {
                    bf.push("</iframe>")
                }
            },
            font: {
                start: function(bk) {
                    bf.push('<span style="');
                    var bi = bk.getAttribute("color");
                    var bl = K[bk.getAttribute("size")];
                    var bj = bk.getAttribute("face");
                    if (bi) {
                        bf.push("color:");
                        bf.push(x.toHex(bi));
                        bf.push(";")
                    }
                    if (bj) {
                        bf.push("font-face:");
                        bf.push(bj);
                        bf.push(";")
                    }
                    if (bl) {
                        bf.push("font-size:");
                        bf.push(bl);
                        bf.push(";")
                    }
                    bf.push('">')
                },
                end: function(bi) {
                    bf.push("</span>")
                }
            }
        };

        function bc(bu) {
            var bz = [],
				bl = bu.attributes,
				bA = a.trim;
            if (x.is(bu, "iframe")) {
                var bi = a(bu);
                if (bi.attr("originalsrc") != "") {
                    bi.attr("src", bi.attr("originalsrc"));
                    bi.removeAttr("originalsrc")
                }
            }
            if (x.is(bu, "img")) {
                var bC = bu.style.width,
					bp = bu.style.height,
					bi = a(bu);
                if (bC) {
                    bi.attr("width", parseInt(bC));
                    x.unstyle(bu, {
                        width: undefined
                    })
                }
                if (bp) {
                    bi.attr("height", parseInt(bp));
                    x.unstyle(bu, {
                        height: undefined
                    })
                }
            }
            for (var bq = 0, br = bl.length; bq < br; bq++) {
                var bj = bl[bq];
                var bt = bj.nodeName;
                if (bj.specified || (bt == "value" && bu.value != "") || (bt == "type" && bj.nodeValue == "text") || (bt == "style" && bj.nodeValue != "")) {
                    if (bt.indexOf("_moz") < 0 && bt != "complete" && bt != "altHtml") {
                        bz.push(bj)
                    }
                }
            }
            if (!bz.length) {
                return
            }
            bz.sort(function(bD, bE) {
                return bD.nodeName > bE.nodeName ? 1 : bD.nodeName < bE.nodeName ? -1 : 0
            });
            for (var bq = 0, br = bz.length; bq < br; bq++) {
                var bj = bz[bq];
                var bk = bj.nodeName;
                var bm = bj.nodeValue;
                var by = [];
                if (bk == "style") {
                    var bn = bA(bm || bu.style.cssText).split(";");
                    for (var bo = 0, bs = bn.length; bo < bs; bo++) {
                        var bv = bn[bo];
                        if (bv.length) {
                            var bx = bv.split(":");
                            var bw = bA(bx[0].toLowerCase()),
								bB = bA(bx[1]);
                            if (bw == "font-size-adjust" || bw == "font-stretch") {
                                continue
                            }
                            if (bw.indexOf("color") >= 0) {
                                bB = x.toHex(bB)
                            }
                            if (bw.indexOf("font") >= 0) {
                                bB = bB.replace(aH, "'").replace("/normal", "")
                            }
                            by.push(bw);
                            by.push(":");
                            by.push(bB);
                            by.push(";")
                        }
                    }
                } else {
                    if (bk == "src" || bk == "href") {
                        by.push(bu.getAttribute(bk, 2))
                    } else {
                        by.push(E[bk] ? bk : bm)
                    }
                }
                if (bk == "style" && by.length == 0) {
                    continue
                }
                bf.push(" ");
                bf.push(bk);
                bf.push('="');
                bf.push(by.join(""));
                bf.push('"')
            }
        }
        function be(bj, bk) {
            for (var bi = bj.firstChild; bi; bi = bi.nextSibling) {
                bd(bi, bk)
            }
        }
        function bd(bj, bn) {
            var bk = bj.nodeType;
            if (bk == 1) {
                var bo = x.name(bj);
                if (bo == "" || (bj.attributes._moz_dirty && x.is(bj, "br"))) {
                    return
                }
                var bi = bh[bo];
                if (bi) {
                    bi.start(bj);
                    be(bj);
                    bi.end(bj);
                    return
                }
                bf.push("<");
                bf.push(bo);
                bc(bj);
                if (z[bo]) {
                    bf.push(" />")
                } else {
                    bf.push(">");
                    be(bj, bn || x.is(bj, "pre"));
                    bf.push("</");
                    bf.push(bo);
                    bf.push(">")
                }
            } else {
                if (bk == 3) {
                    var bp = bj.nodeValue;
                    if (!bn && a.support.leadingWhitespace) {
                        var bl = bj.parentNode;
                        var bm = bj.previousSibling;
                        if (!bm) {
                            bm = (x.isInline(bl) ? bl : bj).previousSibling
                        }
                        if (!bm || bm.innerHTML == "" || x.isBlock(bm)) {
                            bp = bp.replace(/^[\r\n\v\f\t ]+/, "")
                        }
                        bp = bp.replace(/ +/, " ")
                    }
                    bf.push(x.encode(bp))
                } else {
                    if (bk == 4) {
                        bf.push("<![CDATA[");
                        bf.push(bj.data);
                        bf.push("]]>")
                    } else {
                        if (bk == 8) {
                            if (bj.data.indexOf("[CDATA[") < 0) {
                                bf.push("<!--");
                                bf.push(bj.data);
                                bf.push("-->")
                            } else {
                                bf.push("<!");
                                bf.push(bj.data);
                                bf.push(">")
                            }
                        }
                    }
                }
            }
        }
        be(bg);
        bf = bf.join("");
        if (bf.replace(m, "").replace(B, "") == "") {
            return ""
        }
        return bf
    }
    var aW = 0,
		aV = 1,
		C = 2,
		D = 3;

    function w(bc) {
        var bd = bc.startContainer;
        return bd.nodeType == 9 ? bd : bd.ownerDocument
    }
    function aQ(bc) {
        if (a.browser.msie && a.browser.version < 9) {
            return new a9(bc.document)
        }
        return bc.getSelection()
    }
    function aP(bd) {
        var bc = w(bd);
        return aO(bc)
    }
    function aO(bc) {
        return aQ(bb(bc))
    }
    function bb(bc) {
        return bc.defaultView || bc.parentWindow
    }
    function aT(be, bc, bf) {
        function bd(bi) {
            var bh = be.cloneRange();
            bh.collapse(bi);
            bh[bi ? "setStartBefore" : "setEndAfter"](bc);
            var bg = bh.extractContents();
            if (bf) {
                bg = x.trim(bg)
            }
            x[bi ? "insertBefore" : "insertAfter"](bg, bc)
        }
        bd(true);
        bd(false)
    }
    function aR(bd) {
        var bc = aK.image(bd);
        if (bc) {
            bd.setStartAfter(bc);
            bd.setEndAfter(bc)
        }
        var be = aP(bd);
        be.removeAllRanges();
        be.addRange(bd)
    }
    function a8(bc) {
        a.extend(this, {
            ownerDocument: bc,
            startContainer: bc,
            endContainer: bc,
            commonAncestorContainer: bc,
            startOffset: 0,
            endOffset: 0,
            collapsed: true
        })
    }
    a8.prototype = {
        setStart: function(bc, bd) {
            this.startContainer = bc;
            this.startOffset = bd;
            a6(this);
            I(this, true)
        },
        setEnd: function(bc, bd) {
            this.endContainer = bc;
            this.endOffset = bd;
            a6(this);
            I(this, false)
        },
        setStartBefore: function(bc) {
            this.setStart(bc.parentNode, G(bc))
        },
        setStartAfter: function(bc) {
            this.setStart(bc.parentNode, G(bc) + 1)
        },
        setEndBefore: function(bc) {
            this.setEnd(bc.parentNode, G(bc))
        },
        setEndAfter: function(bc) {
            this.setEnd(bc.parentNode, G(bc) + 1)
        },
        selectNode: function(bc) {
            this.setStartBefore(bc);
            this.setEndAfter(bc)
        },
        selectNodeContents: function(bc) {
            this.setStart(bc, 0);
            this.setEnd(bc, bc[bc.nodeType === 1 ? "childNodes" : "nodeValue"].length)
        },
        collapse: function(bc) {
            if (bc) {
                this.setEnd(this.startContainer, this.startOffset)
            } else {
                this.setStart(this.endContainer, this.endOffset)
            }
        },
        deleteContents: function() {
            var bd = this.cloneRange();
            if (this.startContainer != this.commonAncestorContainer) {
                this.setStartAfter(F(this.commonAncestorContainer, this.startContainer))
            }
            this.collapse(true);
            (function bc(be) {
                while (be.next()) {
                    be.hasPartialSubtree() ? bc(be.getSubtreeIterator()) : be.remove()
                }
            })(new aJ(bd))
        },
        cloneContents: function() {
            var bd = w(this);
            return (function bc(bf) {
                for (var bg, be = bd.createDocumentFragment(); bg = bf.next();) {
                    bg = bg.cloneNode(!bf.hasPartialSubtree());
                    if (bf.hasPartialSubtree()) {
                        bg.appendChild(bc(bf.getSubtreeIterator()))
                    }
                    be.appendChild(bg)
                }
                return be
            })(new aJ(this))
        },
        extractContents: function() {
            var be = this.cloneRange();
            if (this.startContainer != this.commonAncestorContainer) {
                this.setStartAfter(F(this.commonAncestorContainer, this.startContainer))
            }
            this.collapse(true);
            var bf = this;
            var bc = w(this);
            return (function bd(bh) {
                for (var bi, bg = bc.createDocumentFragment(); bi = bh.next();) {
                    bh.hasPartialSubtree() ? bi = bi.cloneNode(false) : bh.remove(bf.originalRange);
                    if (bh.hasPartialSubtree()) {
                        bi.appendChild(bd(bh.getSubtreeIterator()))
                    }
                    bg.appendChild(bi)
                }
                return bg
            })(new aJ(be))
        },
        insertNode: function(bc) {
            if (am(this.startContainer)) {
                if (this.startOffset != this.startContainer.nodeValue.length) {
                    aU(this.startContainer, this.startOffset)
                }
                x.insertAfter(bc, this.startContainer)
            } else {
                x.insertAt(this.startContainer, bc, this.startOffset)
            }
            this.setStart(this.startContainer, this.startOffset)
        },
        cloneRange: function() {
            return a.extend(new a8(this.ownerDocument), {
                startContainer: this.startContainer,
                endContainer: this.endContainer,
                commonAncestorContainer: this.commonAncestorContainer,
                startOffset: this.startOffset,
                endOffset: this.endOffset,
                collapsed: this.collapsed,
                originalRange: this
            })
        },
        toString: function() {
            var bd = this.startContainer.nodeName,
				bc = this.endContainer.nodeName;
            return [bd == "#text" ? this.startContainer.nodeValue : bd, "(", this.startOffset, ") : ", bc == "#text" ? this.endContainer.nodeValue : bc, "(", this.endOffset, ")"].join("")
        }
    };

    function q(bh, bd, bj, bf) {
        if (bh == bd) {
            return bf - bj
        }
        var bc = bd;
        while (bc && bc.parentNode != bh) {
            bc = bc.parentNode
        }
        if (bc) {
            return G(bc) - bj
        }
        bc = bh;
        while (bc && bc.parentNode != bd) {
            bc = bc.parentNode
        }
        if (bc) {
            return bf - G(bc) - 1
        }
        var bg = x.commonAncestor(bh, bd);
        var bi = bh;
        while (bi && bi.parentNode != bg) {
            bi = bi.parentNode
        }
        if (!bi) {
            bi = bg
        }
        var be = bd;
        while (be && be.parentNode != bg) {
            be = be.parentNode
        }
        if (!be) {
            be = bg
        }
        if (bi == be) {
            return 0
        }
        return G(be) - G(bi)
    }
    function I(bd, be) {
        function bc(bg) {
            try {
                return q(bg.startContainer, bg.endContainer, bg.startOffset, bg.endOffset) < 0
            } catch (bf) {
                return true
            }
        }
        if (bc(bd)) {
            if (be) {
                bd.commonAncestorContainer = bd.endContainer = bd.startContainer;
                bd.endOffset = bd.startOffset
            } else {
                bd.commonAncestorContainer = bd.startContainer = bd.endContainer;
                bd.startOffset = bd.endOffset
            }
            bd.collapsed = true
        }
    }
    function a6(bd) {
        bd.collapsed = bd.startContainer == bd.endContainer && bd.startOffset == bd.endOffset;
        var bc = bd.startContainer;
        while (bc && bc != bd.endContainer && !ak(bc, bd.endContainer)) {
            bc = bc.parentNode
        }
        bd.commonAncestorContainer = bc
    }
    function s(bc) {
        if (a.browser.msie && a.browser.version < 9) {
            return new a8(bc)
        }
        return bc.createRange()
    }
    function aJ(bc) {
        a.extend(this, {
            range: bc,
            _current: null,
            _next: null,
            _end: null
        });
        if (bc.collapsed) {
            return
        }
        var bd = bc.commonAncestorContainer;
        this._next = bc.startContainer == bd && !am(bc.startContainer) ? bc.startContainer.childNodes[bc.startOffset] : F(bd, bc.startContainer);
        this._end = bc.endContainer == bd && !am(bc.endContainer) ? bc.endContainer.childNodes[bc.endOffset] : F(bd, bc.endContainer).nextSibling
    }
    aJ.prototype = {
        hasNext: function() {
            return !!this._next
        },
        next: function() {
            var bc = this._current = this._next;
            this._next = this._current && this._current.nextSibling != this._end ? this._current.nextSibling : null;
            if (am(this._current)) {
                if (this.range.endContainer == this._current) {
                    (bc = bc.cloneNode(true)).deleteData(this.range.endOffset, bc.length - this.range.endOffset)
                }
                if (this.range.startContainer == this._current) {
                    (bc = bc.cloneNode(true)).deleteData(0, this.range.startOffset)
                }
            }
            return bc
        },
        traverse: function(bc) {
            function be() {
                this._current = this._next;
                this._next = this._current && this._current.nextSibling != this._end ? this._current.nextSibling : null;
                return this._current
            }
            var bd;
            while (bd = be.call(this)) {
                if (this.hasPartialSubtree()) {
                    this.getSubtreeIterator().traverse(bc)
                } else {
                    bc(bd)
                }
            }
            return bd
        },
        remove: function(bh) {
            var bf = this.range.startContainer == this._current;
            var be = this.range.endContainer == this._current;
            if (am(this._current) && (bf || be)) {
                var bj = bf ? this.range.startOffset : 0;
                var bd = be ? this.range.endOffset : this._current.length;
                var bc = bd - bj;
                if (bh && (bf || be)) {
                    if (this._current == bh.startContainer && bj <= bh.startOffset) {
                        bh.startOffset -= bc
                    }
                    if (this._current == bh.endContainer && bd <= bh.endOffset) {
                        bh.endOffset -= bc
                    }
                }
                this._current.deleteData(bj, bc)
            } else {
                var bi = this._current.parentNode;
                if (bh && (this.range.startContainer == bi || this.range.endContainer == bi)) {
                    var bg = G(this._current);
                    if (bi == bh.startContainer && bg <= bh.startOffset) {
                        bh.startOffset -= 1
                    }
                    if (bi == bh.endContainer && bg < bh.endOffset) {
                        bh.endOffset -= 1
                    }
                }
                x.remove(this._current)
            }
        },
        hasPartialSubtree: function() {
            return !am(this._current) && (al(this._current, this.range.startContainer) || al(this._current, this.range.endContainer))
        },
        getSubtreeIterator: function() {
            var bc = this.range.cloneRange();
            bc.selectNodeContents(this._current);
            if (al(this._current, this.range.startContainer)) {
                bc.setStart(this.range.startContainer, this.range.startOffset)
            }
            if (al(this._current, this.range.endContainer)) {
                bc.setEnd(this.range.endContainer, this.range.endOffset)
            }
            return new aJ(bc)
        }
    };

    function a9(bc) {
        this.ownerDocument = bc;
        this.rangeCount = 1
    }
    a9.prototype = {
        addRange: function(bc) {
            var bd = this.ownerDocument.body.createTextRange();
            c(bd, bc, false);
            c(bd, bc, true);
            bd.select()
        },
        removeAllRanges: function() {
            this.ownerDocument.selection.empty()
        },
        getRangeAt: function() {
            var bl, bi = new a8(this.ownerDocument),
				bj = this.ownerDocument.selection,
				bd;
            try {
                bl = bj.createRange();
                bd = bl.item ? bl.item(0) : bl.parentElement();
                if (bd.ownerDocument != this.ownerDocument) {
                    return bi
                }
            } catch (bf) {
                return bi
            }
            if (bj.type == "Control") {
                bi.selectNode(bl.item(0))
            } else {
                d(bl, bi, true);
                d(bl, bi, false);
                if (bi.startContainer.nodeType == 9) {
                    bi.setStart(bi.endContainer, bi.startOffset)
                }
                if (bi.endContainer.nodeType == 9) {
                    bi.setEnd(bi.startContainer, bi.endOffset)
                }
                if (bl.compareEndPoints("StartToEnd", bl) == 0) {
                    bi.collapse(false)
                }
                var bk = bi.startContainer,
					be = bi.endContainer,
					bc = this.ownerDocument.body;
                if (!bi.collapsed && bi.startOffset == 0 && bi.endOffset == T(bi.endContainer) && !(bk == be && am(bk) && bk.parentNode == bc)) {
                    var bh = false,
						bg = false;
                    while (G(bk) == 0 && bk == bk.parentNode.firstChild && bk != bc) {
                        bk = bk.parentNode;
                        bh = true
                    }
                    while (G(be) == T(be.parentNode) - 1 && be == be.parentNode.lastChild && be != bc) {
                        be = be.parentNode;
                        bg = true
                    }
                    if (bk == bc && be == bc && bh && bg) {
                        bi.setStart(bk, 0);
                        bi.setEnd(be, T(bc))
                    }
                }
            }
            return bi
        }
    };

    function c(bl, bi, bj) {
        var be = bi[bj ? "startContainer" : "endContainer"];
        var bh = bi[bj ? "startOffset" : "endOffset"],
			bk = 0;
        var bc = am(be) ? be : be.childNodes[bh] || null;
        var bd = am(be) ? be.parentNode : be;
        if (be.nodeType == 3 || be.nodeType == 4) {
            bk = bh
        }
        var bg = bd.insertBefore(x.create(bi.ownerDocument, "a"), bc);
        var bf = bi.ownerDocument.body.createTextRange();
        bf.moveToElementText(bg);
        x.remove(bg);
        bf[bj ? "moveStart" : "moveEnd"]("character", bk);
        bf.collapse(false);
        bl.setEndPoint(bj ? "StartToStart" : "EndToStart", bf)
    }
    function d(bi, bf, bg) {
        var bd = x.create(bf.ownerDocument, "a"),
			bc = bi.duplicate();
        bc.collapse(bg);
        var be = bc.parentElement();
        do {
            be.insertBefore(bd, bd.previousSibling);
            bc.moveToElementText(bd)
        } while (bc.compareEndPoints(bg ? "StartToStart" : "StartToEnd", bi) > 0 && bd.previousSibling);
        bc.setEndPoint(bg ? "EndToStart" : "EndToEnd", bi);
        var bh = bd.nextSibling;
        if (!bh) {
            bh = bd.previousSibling;
            if (bh && am(bh)) {
                bf.setEnd(bh, bh.nodeValue.length);
                x.remove(bd)
            } else {
                bf.selectNodeContents(be);
                x.remove(bd);
                bf.endOffset -= 1
            }
            return
        }
        x.remove(bd);
        if (am(bh)) {
            bf[bg ? "setStart" : "setEnd"](bh, bc.text.length)
        } else {
            bf[bg ? "setStartBefore" : "setEndBefore"](bh)
        }
    }
    function aI(bc) {
        this.enumerate = function() {
            var bd = [];

            function be(bf) {
                if (x.is(bf, "img") || (bf.nodeType == 3 && !x.isWhitespace(bf))) {
                    bd.push(bf)
                } else {
                    bf = bf.firstChild;
                    while (bf) {
                        be(bf);
                        bf = bf.nextSibling
                    }
                }
            }
            new aJ(bc).traverse(be);
            return bd
        }
    }
    function a0(bc) {
        return new aI(bc).enumerate()
    }
    function k(bg) {
        var bd = [];
        for (var be = 0, bf = bg.length; be < bf; be++) {
            var bc = x.parentOfType(bg[be], g);
            if (bc && a.inArray(bc, bd) < 0) {
                bd.push(bc)
            }
        }
        return bd
    }
    function S(bd) {
        var bc = [];
        new aJ(bd).traverse(function(be) {
            if (be.className == "t-marker") {
                bc.push(be)
            }
        });
        return bc
    }
    function aL(bf) {
        var bg = w(bf);
        this.body = bg.body;
        this.html = this.body.innerHTML;

        function bc(bj) {
            var bl = 0,
				bi = bj.nodeType;
            while (bj = bj.previousSibling) {
                var bk = bj.nodeType;
                if (bk != 3 || bi != bk) {
                    bl++
                }
                bi = bk
            }
            return bl
        }
        function be(bi, bj) {
            if (bi.nodeType == 3) {
                while ((bi = bi.previousSibling) && bi.nodeType == 3) {
                    bj += bi.nodeValue.length
                }
            }
            return bj
        }
        function bd(bi) {
            var bj = [];
            while (bi != bg) {
                bj.push(bc(bi));
                bi = bi.parentNode
            }
            return bj
        }
        function bh(bn, bo, bm, bi) {
            var bk = bg,
				bj = bm.length,
				bl = bi;
            while (bj--) {
                bk = bk.childNodes[bm[bj]]
            }
            while (bk.nodeType == 3 && bk.nodeValue.length < bl) {
                bl -= bk.nodeValue.length;
                bk = bk.nextSibling
            }
            bn[bo ? "setStart" : "setEnd"](bk, bl)
        }
        this.startContainer = bd(bf.startContainer);
        this.endContainer = bd(bf.endContainer);
        this.startOffset = be(bf.startContainer, bf.startOffset);
        this.endOffset = be(bf.endContainer, bf.endOffset);
        this.toRange = function() {
            var bi = bf.cloneRange();
            bh(bi, true, this.startContainer, this.startOffset);
            bh(bi, false, this.endContainer, this.endOffset);
            return bi
        }
    }
    function ay() {
        var bc;
        this.addCaret = function(bd) {
            bc = x.create(w(bd), "span", {
                className: "t-marker"
            });
            bd.insertNode(bc);
            bd.selectNode(bc);
            return bc
        };
        this.removeCaret = function(bh) {
            var bg = bc.previousSibling;
            var bi = 0;
            if (bg) {
                bi = am(bg) ? bg.nodeValue.length : G(bg)
            }
            var bd = bc.parentNode;
            var be = bg ? G(bg) : 0;
            x.remove(bc);
            aB(bd);
            var bf = bd.childNodes[be];
            if (am(bf)) {
                bh.setStart(bf, bi)
            } else {
                if (bf) {
                    var bj = x.lastTextNode(bf);
                    if (bj) {
                        bh.setStart(bj, bj.nodeValue.length)
                    } else {
                        bh[bg ? "setStartAfter" : "setStartBefore"](bf)
                    }
                } else {
                    if (!a.browser.msie && bd.innerHTML == "") {
                        bd.innerHTML = '<br _moz_dirty="" />'
                    }
                    bh.selectNodeContents(bd)
                }
            }
            bh.collapse(true)
        };
        this.add = function(be, bd) {
            if (bd && be.collapsed) {
                this.addCaret(be);
                be = aK.expand(be)
            }
            var bf = be.cloneRange();
            bf.collapse(false);
            this.end = x.create(w(be), "span", {
                className: "t-marker"
            });
            bf.insertNode(this.end);
            bf = be.cloneRange();
            bf.collapse(true);
            this.start = this.end.cloneNode(true);
            bf.insertNode(this.start);
            be.setStartBefore(this.start);
            be.setEndAfter(this.end);
            aB(be.commonAncestorContainer);
            return be
        };
        this.remove = function(bk) {
            var bn = this.start,
				bf = this.end;
            aB(bk.commonAncestorContainer);
            while (!bn.nextSibling && bn.parentNode) {
                bn = bn.parentNode
            }
            while (!bf.previousSibling && bf.parentNode) {
                bf = bf.parentNode
            }
            var bm = (bn.previousSibling && bn.previousSibling.nodeType == 3) && (bn.nextSibling && bn.nextSibling.nodeType == 3);
            var bl = (bf.previousSibling && bf.previousSibling.nodeType == 3) && (bf.nextSibling && bf.nextSibling.nodeType == 3);
            bn = bn.nextSibling;
            bf = bf.previousSibling;
            var bd = false;
            var be = false;
            if (bn == this.end) {
                be = !! this.start.previousSibling;
                bn = bf = this.start.previousSibling || this.end.nextSibling;
                bd = true
            }
            x.remove(this.start);
            x.remove(this.end);
            if (bn == null || bf == null) {
                bk.selectNodeContents(bk.commonAncestorContainer);
                bk.collapse(true);
                return
            }
            var bp = bd ? am(bn) ? bn.nodeValue.length : bn.childNodes.length : 0;
            var bh = am(bf) ? bf.nodeValue.length : bf.childNodes.length;
            if (bn.nodeType == 3) {
                while (bn.previousSibling && bn.previousSibling.nodeType == 3) {
                    bn = bn.previousSibling;
                    bp += bn.nodeValue.length
                }
            }
            if (bf.nodeType == 3) {
                while (bf.previousSibling && bf.previousSibling.nodeType == 3) {
                    bf = bf.previousSibling;
                    bh += bf.nodeValue.length
                }
            }
            var bo = G(bn),
				bq = bn.parentNode;
            var bg = G(bf),
				bi = bf.parentNode;
            for (var br = bn; br.previousSibling; br = br.previousSibling) {
                if (br.nodeType == 3 && br.previousSibling.nodeType == 3) {
                    bo--
                }
            }
            for (var bj = bf; bj.previousSibling; bj = bj.previousSibling) {
                if (bj.nodeType == 3 && bj.previousSibling.nodeType == 3) {
                    bg--
                }
            }
            aB(bq);
            if (bn.nodeType == 3) {
                bn = bq.childNodes[bo]
            }
            aB(bi);
            if (bf.nodeType == 3) {
                bf = bi.childNodes[bg]
            }
            if (bd) {
                if (bn.nodeType == 3) {
                    bk.setStart(bn, bp)
                } else {
                    bk[be ? "setStartAfter" : "setStartBefore"](bn)
                }
                bk.collapse(true)
            } else {
                if (bn.nodeType == 3) {
                    bk.setStart(bn, bp)
                } else {
                    bk.setStartBefore(bn)
                }
                if (bf.nodeType == 3) {
                    bk.setEnd(bf, bh)
                } else {
                    bk.setEndAfter(bf)
                }
            }
            if (bc) {
                this.removeCaret(bk)
            }
        }
    }
    var l = /[	-
]| | |﻿|\.|,|;|:|!|\(|\)|\?/;
	var aK = {
	    nodes: function(bd) {
	        var bc = a0(bd);
	        if (!bc.length) {
	            bd.selectNodeContents(bd.commonAncestorContainer);
	            bc = a0(bd);
	            if (!bc.length) {
	                bc = x.significantChildNodes(bd.commonAncestorContainer)
	            }
	        }
	        return bc
	    },
	    image: function(bd) {
	        var bc = [];
	        new aJ(bd).traverse(function(be) {
	            if (x.is(be, "img")) {
	                bc.push(be)
	            }
	        });
	        if (bc.length == 1) {
	            return bc[0]
	        }
	    },
	    expand: function(bg) {
	        var bh = bg.cloneRange();
	        var bi = bh.startContainer.childNodes[bh.startOffset == 0 ? 0 : bh.startOffset - 1];
	        var be = bh.endContainer.childNodes[bh.endOffset];
	        if (!am(bi) || !am(be)) {
	            return bh
	        }
	        var bd = bi.nodeValue;
	        var bc = be.nodeValue;
	        if (bd == "" || bc == "") {
	            return bh
	        }
	        var bj = bd.split("").reverse().join("").search(l);
	        var bf = bc.search(l);
	        if (bj == 0 || bf == 0) {
	            return bh
	        }
	        bf = bf == -1 ? bc.length : bf;
	        bj = bj == -1 ? 0 : bd.length - bj;
	        bh.setStart(bi, bj);
	        bh.setEnd(be, bf);
	        return bh
	    },
	    isExpandable: function(bh) {
	        var bg = bh.startContainer;
	        var be = w(bh);
	        if (bg == be || bg == be.body) {
	            return false
	        }
	        var bi = bh.cloneRange();
	        var bk = bg.nodeValue;
	        if (!bk) {
	            return false
	        }
	        var bd = bk.substring(0, bi.startOffset);
	        var bc = bk.substring(bi.startOffset);
	        var bj = 0,
				bf = 0;
	        if (bd != "") {
	            bj = bd.split("").reverse().join("").search(l)
	        }
	        if (bc != "") {
	            bf = bc.search(l)
	        }
	        return bj != 0 && bf != 0
	    }
	};

    function p(bd) {
        var be = new aL(bd.range);
        var bc = new ay();
        this.formatter = bd.formatter;
        this.getRange = function() {
            return be.toRange()
        };
        this.lockRange = function(bf) {
            return bc.add(this.getRange(), bf)
        };
        this.releaseRange = function(bf) {
            bc.remove(bf);
            aR(bf)
        };
        this.undo = function() {
            be.body.innerHTML = be.html;
            aR(be.toRange())
        };
        this.redo = function() {
            this.exec()
        };
        this.exec = function() {
            var bf = this.lockRange(true);
            this.formatter.editor = this.editor;
            this.formatter.toggle(bf);
            this.releaseRange(bf)
        }
    }
    function R(be, bd) {
        var bc = be.body;
        this.redo = function() {
            bc.innerHTML = bd.html;
            aR(bd.toRange())
        };
        this.undo = function() {
            bc.innerHTML = be.html;
            aR(be.toRange())
        }
    }
    function ai(bc) {
        p.call(this, bc);
        this.managesUndoRedo = true;
        this.exec = function() {
            var bd = this.editor;
            var be = bd.getRange();
            var bf = new aL(be);
            bd.clipboard.paste(bc.value || "");
            bd.undoRedoStack.push(new R(bf, new aL(bd.getRange())));
            bd.focus()
        }
    }
    function aj() {
        a1.call(this);
        var bc, bd = "";
        this.command = function(be) {
            return new ai(be)
        };
        this.update = function(be, bg) {
            var bf = be.data("tSelectBox");
            bf.close();
            bf.value(bd)
        };
        this.init = function(be, bf) {
            bc = bf.editor;
            bd = bc.localization.insertHtml;
            be.tSelectBox({
                data: bc.insertHtml || [],
                title: bd,
                onItemCreate: function(bg) {
                    bg.html = '<span unselectable="on">' + bg.dataItem.Text + "</span>"
                },
                onChange: function(bg) {
                    a1.exec(bc, "insertHtml", bg.value)
                },
                highlightFirst: false
            }).find(".t-input").html(bc.localization.insertHtml)
        }
    }
    function a3() {
        var bd = [],
			bc = -1;
        this.push = function(be) {
            bd = bd.slice(0, bc + 1);
            bc = bd.push(be) - 1
        };
        this.undo = function() {
            if (this.canUndo()) {
                bd[bc--].undo()
            }
        };
        this.redo = function() {
            if (this.canRedo()) {
                bd[++bc].redo()
            }
        };
        this.canUndo = function() {
            return bc >= 0
        };
        this.canRedo = function() {
            return bc != bd.length - 1
        }
    }
    function a2(bc) {
        this.keydown = function(bd) {
            var bf = bc.keyboard;
            var be = bf.isTypingKey(bd);
            if (be && !bf.typingInProgress()) {
                var bg = bc.getRange();
                this.startRestorePoint = new aL(bg);
                bf.startTyping(a.proxy(function() {
                    bc.selectionRestorePoint = this.endRestorePoint = new aL(bc.getRange());
                    bc.undoRedoStack.push(new R(this.startRestorePoint, this.endRestorePoint))
                }, this));
                return true
            }
            return false
        };
        this.keyup = function(bd) {
            var be = bc.keyboard;
            if (be.typingInProgress()) {
                be.endTyping();
                return true
            }
            return false
        }
    }
    function aZ(bc) {
        var bd = false;
        this.createUndoCommand = function() {
            this.endRestorePoint = new aL(bc.getRange());
            bc.undoRedoStack.push(new R(this.startRestorePoint, this.endRestorePoint));
            this.startRestorePoint = this.endRestorePoint
        };
        this.changed = function() {
            if (this.startRestorePoint) {
                return this.startRestorePoint.html != bc.body.innerHTML
            }
            return false
        };
        this.keydown = function(be) {
            var bf = bc.keyboard;
            if (bf.isModifierKey(be)) {
                if (bf.typingInProgress()) {
                    bf.endTyping(true)
                }
                this.startRestorePoint = new aL(bc.getRange());
                return true
            }
            if (bf.isSystem(be)) {
                bd = true;
                if (this.changed()) {
                    bd = false;
                    this.createUndoCommand()
                }
                return true
            }
            return false
        };
        this.keyup = function(be) {
            if (bd && this.changed()) {
                bd = false;
                this.createUndoCommand(be);
                return true
            }
            return false
        }
    }
    function an(bc) {
        var bi = false;
        var bh;
        var bf;

        function bd(bj) {
            return (bj >= 48 && bj <= 90) || (bj >= 96 && bj <= 111) || (bj >= 186 && bj <= 192) || (bj >= 219 && bj <= 222)
        }
        this.toolFromShortcut = function(bn, bj) {
            var bk = String.fromCharCode(bj.keyCode);
            for (var bm in bn) {
                var bl = bn[bm];
                if ((bl.key == bk || bl.key == bj.keyCode) && !! bl.ctrl == bj.ctrlKey && !! bl.alt == bj.altKey && !! bl.shift == bj.shiftKey) {
                    return bm
                }
            }
        };
        this.isTypingKey = function(bj) {
            var bk = bj.keyCode;
            return (bd(bk) && !bj.ctrlKey && !bj.altKey) || bk == 32 || bk == 13 || bk == 8 || (bk == 46 && !bj.shiftKey && !bj.ctrlKey && !bj.altKey)
        };
        this.isModifierKey = function(bj) {
            var bk = bj.keyCode;
            return (bk == 17 && !bj.shiftKey && !bj.altKey) || (bk == 16 && !bj.ctrlKey && !bj.altKey) || (bk == 18 && !bj.ctrlKey && !bj.shiftKey)
        };
        this.isSystem = function(bj) {
            return bj.keyCode == 46 && bj.ctrlKey && !bj.altKey && !bj.shiftKey
        };
        this.startTyping = function(bj) {
            bf = bj;
            bi = true
        };

        function bg() {
            bi = false;
            if (bf) {
                bf()
            }
        }
        this.endTyping = function(bj) {
            this.clearTimeout();
            if (bj) {
                bg()
            } else {
                bh = window.setTimeout(bg, 1000)
            }
        };
        this.typingInProgress = function() {
            return bi
        };
        this.clearTimeout = function() {
            window.clearTimeout(bh)
        };

        function be(bj, bl) {
            for (var bk = 0; bk < bc.length; bk++) {
                if (bc[bk][bl](bj)) {
                    break
                }
            }
        }
        this.keydown = function(bj) {
            be(bj, "keydown")
        };
        this.keyup = function(bj) {
            be(bj, "keyup")
        }
    }
    function n(bd) {
        var bc = [new az(), new u(), new aS()];

        function be(bj) {
            var bh = x.create(bd.document, "div");
            bh.innerHTML = bj;
            var bi = bd.document.createDocumentFragment();
            while (bh.firstChild) {
                bi.appendChild(bh.firstChild)
            }
            return bi
        }
        function bf(bh) {
            return /<(div|p|ul|ol|table|h[1-6])/i.test(bh)
        }
        this.oncut = function(bh) {
            var bi = new aL(bd.getRange());
            setTimeout(function() {
                bd.undoRedoStack.push(new R(bi, new aL(bd.getRange())))
            })
        };
        this.onpaste = function(bj) {
            var bl = bd.getRange();
            var bm = new aL(bl);
            var bh = x.create(bd.document, "div", {
                className: "t-paste-container",
                innerHTML: "﻿"
            });
            bd.body.appendChild(bh);
            if (bd.body.createTextRange) {
                bj.preventDefault();
                var bk = bd.createRange();
                bk.selectNodeContents(bh);
                bd.selectRange(bk);
                var bn = bd.body.createTextRange();
                bn.moveToElementText(bh);
                a(bd.body).unbind("paste");
                bn.execCommand("Paste");
                a(bd.body).bind("paste", arguments.callee)
            } else {
                var bi = bd.createRange();
                bi.selectNodeContents(bh);
                aR(bi)
            }
            setTimeout(function() {
                aR(bl);
                x.remove(bh);
                if (bh.lastChild && x.is(bh.lastChild, "br")) {
                    x.remove(bh.lastChild)
                }
                var bo = {
                    html: bh.innerHTML
                };
                b.trigger(bd.element, "paste", bo);
                bd.clipboard.paste(bo.html, true);
                bd.undoRedoStack.push(new R(bm, new aL(bd.getRange())));
                aN(bd)
            })
        };

        function bg(bh, bj) {
            if (bh) {
                return x.parentOfType(bj, ["p", "ul", "ol"]) || bj.parentNode
            }
            var bk = bj.parentNode;
            var bi = bj.ownerDocument.body;
            if (x.isInline(bk)) {
                while (bk.parentNode != bi && !x.isBlock(bk.parentNode)) {
                    bk = bk.parentNode
                }
            }
            return bk
        }
        this.paste = function(bm, bj) {
            var bn, bo;
            for (bn = 0, bo = bc.length; bn < bo; bn++) {
                if (bc[bn].applicable(bm)) {
                    bm = bc[bn].clean(bm)
                }
            }
            if (bj) {
                bm = bm.replace(/(<br>(\s|&nbsp;)*)+(<\/?(div|p|li|col|t))/ig, "$3");
                bm = bm.replace(/<(a|span)[^>]*><\/\1>/ig, "")
            }
            bm = bm.replace(/^<li/i, "<ul><li").replace(/li>$/g, "li></ul>");
            var bh = bf(bm);
            var bs = bd.getRange();
            bs.deleteContents();
            if (bs.startContainer == bd.document) {
                bs.selectNodeContents(bd.body)
            }
            var bp = new ay();
            var bi = bp.addCaret(bs);
            var br = bg(bh, bi);
            var bt = false;
            if (!/body|td/.test(x.name(br)) && (bh || x.isInline(br))) {
                bs.selectNode(bi);
                aT(bs, br, true);
                bt = true
            }
            var bk = be(bm);
            if (bk.firstChild && bk.firstChild.className === "t-paste-container") {
                var bl = [];
                for (bn = 0, bo = bk.childNodes.length; bn < bo; bn++) {
                    bl.push(bk.childNodes[bn].innerHTML)
                }
                bk = be(bl.join("<br />"))
            }
            bs.insertNode(bk);
            br = bg(bh, bi);
            if (bt) {
                while (bi.parentNode != br) {
                    x.unwrap(bi.parentNode)
                }
                x.unwrap(bi.parentNode)
            }
            aB(bs.commonAncestorContainer);
            bi.style.display = "inline";
            x.scrollTo(bi);
            bp.removeCaret(bs);
            if (x.name(bd.body.lastChild) == "table") {
                var bq = bd.document.createElement("p");
                bq.innerHTML = "<br _moz_dirty />";
                bd.body.appendChild(bq);
                bs.setStart(bq, 0);
                bs.collapse(true)
            }
            aR(bs)
        }
    }
    function u() {
        this.applicable = function(bc) {
            return /<(b|i|u|)>/i.test(bc)
        };
        this.clean = function(bc) {
            return bc.replace(/<(\/?)b>/gi, "<$1strong>").replace(/<(\/?)>/gi, "<$1em>").replace(/<u>/gi, '<span style="text-decoration: underline">').replace(/<\/u>/gi, "</span>")
        }
    }
    function aS() {
        this.applicable = function(bc) {
            return /<span/i.test(bc)
        };
        this.clean = function(bd) {
            var bg = x.create(document, "div", {
                innerHTML: bd
            }),
				bh = a("span", bg),
				bc, bf;
            for (var be = bh.length - 1; be >= 0; be--) {
                bc = bh[be];
                bf = bc.parentNode;
                if (x.is(bf, "span") && bf.childNodes.length == 1) {
                    bf.style.cssText = a.trim(bf.style.cssText + bc.style.cssText);
                    while (bc.firstChild) {
                        bf.appendChild(bc.firstChild)
                    }
                    bf.removeChild(bc)
                }
            }
            return bg.innerHTML
        }
    }
    function az() {
        var be = [/<\?xml[^>]*>/gi, "", /<!--(.|\n)*?-->/g, "", /&quot;/g, "'", /(?:<br>&nbsp;[\s\r\n]+|<br>)*(<\/?(h[1-6]|hr|p|div|table|tbody|thead|tfoot|th|tr|td|li|ol|ul|caption|address|pre|form|blockquote|dl|dt|dd|dir|fieldset)[^>]*>)(?:<br>&nbsp;[\s\r\n]+|<br>)*/g, "$1", /<br><br>/g, "<br />", /<br>(&nbsp;)+\s+/g, " ", /<br>\s+/g, "<br />", /<br>/g, " ", /<table([^>]*)>(\s|&nbsp;)+<t/gi, "<table$1><t", /<tr[^>]*>(\s|&nbsp;)*<\/tr>/gi, "", /<tbody[^>]*>(\s|&nbsp;)*<\/tbody>/gi, "", /<table[^>]*>(\s|&nbsp;)*<\/table>/gi, "", /^\s*(&nbsp;)+/gi, "", /(&nbsp;|<br[^>]*>)+\s*$/gi, "", /mso-[^;"]*;?/ig, "", /<(\/?)b(\s[^>]*)?>/ig, "<$1strong$2>", /<(\/?)i(\s[^>]*)?>/ig, "<$1em$2>", /<\/?(meta|link|style|o:|v:|x:)[^>]*>((?:.|\n)*?<\/(meta|link|style|o:|v:|x:)[^>]*>)?/ig, "", /style=(["|'])\s*\1/g, ""];
        this.applicable = function(bg) {
            return /class="?Mso|style=("[^"]*|'[^']*)mso-/i.test(bg)
        };

        function bd(bg) {
            if (/^[•·§Øo] +/.test(bg)) {
                return "ul"
            }
            if (/^\s*\w+[\.\)] {2,}/.test(bg)) {
                return "ol"
            }
        }
        function bc(bi) {
            var bs = x.create(document, "div", {
                innerHTML: bi
            });
            var bg = a(g.join(","), bs);
            var bl = -1,
				bm, bn = {
				    ul: {},
				    ol: {}
				},
				bo = bs;
            for (var bj = 0; bj < bg.length; bj++) {
                var br = bg[bj];
                var bi = br.innerHTML.replace(/<\/?\w+[^>]*>/g, "").replace(/&nbsp;/g, " ");
                var bt = bd(bi);
                if (!bt || x.name(br) != "p") {
                    if (br.innerHTML == "") {
                        x.remove(br)
                    } else {
                        bn = {
                            ul: {},
                            ol: {}
                        };
                        bo = bs;
                        bl = -1
                    }
                    continue
                }
                var bq = parseFloat(br.style.marginLeft || 0);
                var bp = bn[bt][bq];
                if (bq > bl || !bp) {
                    bp = x.create(document, bt);
                    if (bo == bs) {
                        x.insertBefore(bp, br)
                    } else {
                        bo.appendChild(bp)
                    }
                    bn[bt][bq] = bp
                }
                if (bm != bt) {
                    for (var bk in bn) {
                        for (var bh in bn[bk]) {
                            if (a.contains(bp, bn[bk][bh])) {
                                delete bn[bk][bh]
                            }
                        }
                    }
                }
                x.remove(br.firstChild);
                bo = x.create(document, "li", {
                    innerHTML: br.innerHTML
                });
                bp.appendChild(bo);
                x.remove(br);
                bl = bq;
                bm = bt
            }
            return bs.innerHTML
        }
        function bf(bg) {
            return bg.replace(/<a([^>]*)>\s*<\/a>/ig, function(bh, bi) {
                if (!bi || bi.indexOf("href") < 0) {
                    return ""
                }
                return bh
            })
        }
        this.clean = function(bg) {
            for (var bh = 0, bi = be.length; bh < bi; bh += 2) {
                bg = bg.replace(be[bh], be[bh + 1])
            }
            bg = bf(bg);
            bg = bc(bg);
            bg = bg.replace(/\s+class="?[^"\s>]*"?/ig, "");
            return bg
        }
    }
    function ae(bc) {
        function bd(bi) {
            var bj = 0,
				be = 0,
				bf = 0,
				bh = bi.parentNode;
            for (var bg = bh.firstChild; bg; bg = bg.nextSibling) {
                if (bg != bi) {
                    if (bg.className == "t-marker") {
                        bf++
                    } else {
                        if (bg.nodeType == 3) {
                            bj++
                        } else {
                            be++
                        }
                    }
                }
            }
            if (bf > 1 && bh.firstChild.className == "t-marker" && bh.lastChild.className == "t-marker") {
                return 0
            } else {
                return be + bj
            }
        }
        this.findSuitable = function(bf, be) {
            if (!be && bd(bf) > 0) {
                return null
            }
            return x.parentOfType(bf, bc[0].tags)
        };
        this.findFormat = function(bh) {
            for (var bf = 0; bf < bc.length; bf++) {
                var bg = bh;
                var bi = bc[bf].tags;
                var be = bc[bf].attr;
                if (bg && x.ofType(bg, bi) && e(bg, be)) {
                    return bg
                }
                while (bg) {
                    bg = x.parentOfType(bg, bi);
                    if (bg && e(bg, be)) {
                        return bg
                    }
                }
            }
            return null
        };
        this.isFormatted = function(bf) {
            for (var be = 0; be < bf.length; be++) {
                if (this.findFormat(bf[be])) {
                    return true
                }
            }
            return false
        }
    }
    function af(bd, bf) {
        this.finder = new ae(bd);
        var bc = a.extend({}, bd[0].attr, bf);
        var be = bd[0].tags[0];

        function bg(bh) {
            return x.wrap(bh, x.create(bh.ownerDocument, be, bc))
        }
        this.activate = function(bi, bh) {
            if (this.finder.isFormatted(bh)) {
                this.split(bi);
                this.remove(bh)
            } else {
                this.apply(bh)
            }
        };
        this.toggle = function(bi) {
            var bh = a0(bi);
            if (bh.length > 0) {
                this.activate(bi, bh)
            }
        };
        this.apply = function(bm) {
            var bi = [];
            for (var bj = 0, bk = bm.length; bj < bk; bj++) {
                var bl = bm[bj];
                var bh = this.finder.findSuitable(bl);
                if (bh) {
                    x.attr(bh, bc)
                } else {
                    bh = bg(bl)
                }
                bi.push(bh)
            }
            this.consolidate(bi)
        };
        this.remove = function(bk) {
            for (var bi = 0, bj = bk.length; bi < bj; bi++) {
                var bh = this.finder.findFormat(bk[bi]);
                if (bh) {
                    if (bc && bc.style) {
                        x.unstyle(bh, bc.style);
                        if (!bh.style.cssText) {
                            x.unwrap(bh)
                        }
                    } else {
                        x.unwrap(bh)
                    }
                }
            }
        };
        this.split = function(bl) {
            var bk = a0(bl);
            if (bk.length > 0) {
                for (var bi = 0, bj = bk.length; bi < bj; bi++) {
                    var bh = this.finder.findFormat(bk[bi]);
                    if (bh) {
                        aT(bl, bh, true)
                    }
                }
            }
        };
        this.consolidate = function(bj) {
            while (bj.length > 1) {
                var bi = bj.pop();
                var bh = bj[bj.length - 1];
                if (bi.previousSibling && bi.previousSibling.className == "t-marker") {
                    bh.appendChild(bi.previousSibling)
                }
                if (bi.tagName == bh.tagName && bi.previousSibling == bh && bi.style.cssText == bh.style.cssText) {
                    while (bi.firstChild) {
                        bh.appendChild(bi.firstChild)
                    }
                    x.remove(bi)
                }
            }
        }
    }
    function V(bc, bf) {
        ae.call(this, bc);

        function be(bp) {
            var bh = bp.attributes,
				bt = a.trim;
            if (!bh) {
                return
            }
            for (var bl = 0, bm = bh.length; bl < bm; bl++) {
                var bg = bh[bl],
					bo = bg.nodeName,
					bi = bg.nodeValue;
                if (bg.specified && bo == "style") {
                    var bj = bt(bi || bp.style.cssText).split(";");
                    for (var bk = 0, bn = bj.length; bk < bn; bk++) {
                        var bq = bj[bk];
                        if (bq.length) {
                            var bs = bq.split(":");
                            var br = bt(bs[0].toLowerCase()),
								bu = bt(bs[1]);
                            if (br != bf) {
                                continue
                            }
                            return br.indexOf("color") >= 0 ? x.toHex(bu) : bu
                        }
                    }
                }
            }
            return
        }
        function bd(bj) {
            var bg = a(am(bj) ? bj.parentNode : bj);
            var bk = bg.parents().andSelf();
            for (var bh = 0, bi = bk.length; bh < bi; bh++) {
                var bl = bf == "className" ? bk[bh].className : be(bk[bh]);
                if (bl) {
                    return bl
                }
            }
            return "inherit"
        }
        this.getFormat = function(bi) {
            var bj = bd(bi[0]);
            for (var bg = 1, bh = bi.length; bg < bh; bg++) {
                if (bj != bd(bi[bg])) {
                    return ""
                }
            }
            return bj
        };
        this.isFormatted = function(bg) {
            return this.getFormat(bg) !== ""
        }
    }
    function W(bc, be, bd) {
        af.call(this, bc, be);
        this.finder = new V(bc, bd);
        this.activate = function(bh, bg) {
            this.split(bh);
            if (bd) {
                var bf = bd.replace(/-([a-z])/, function(bi, bj) {
                    return bj.toUpperCase()
                });
                this[be.style[bf] == "inherit" ? "remove" : "apply"](bg)
            } else {
                this.apply(bg)
            }
        }
    }
    function ah(bc) {
        return bc.collapsed && !aK.isExpandable(bc)
    }
    function ag(bc) {
        Q.call(this, a.extend(bc, {
            finder: new ae(bc.format),
            formatter: function() {
                return new af(bc.format)
            }
        }));
        this.willDelayExecution = ah
    }
    function L(be) {
        a1.call(this, be);
        var bf = a.browser.msie ? "tSelectBox" : "tComboBox",
			bd = [{
			    tags: ["span"]
			}],
			bc = new V(bd, be.cssAttr);
        this.command = function(bg) {
            return new O(a.extend(bg, {
                formatter: function() {
                    var bh = {};
                    bh[be.domAttr] = bg.value;
                    return new W(bd, {
                        style: bh
                    }, be.cssAttr)
                }
            }))
        };
        this.willDelayExecution = ah;
        this.update = function(bg, bj, bl) {
            var bi = bg.data(bf);
            bi.close();
            var bk = bl.getPending(this.name);
            var bh = (bk && bk.params) ? bk.params.value : bc.getFormat(bj);
            bi.value(bh)
        };
        this.init = function(bg, bi) {
            var bh = bi.editor;
            bg[bf]({
                data: bh[be.name],
                onChange: function(bj) {
                    a1.exec(bh, be.name, bj.value)
                },
                onItemCreate: function(bj) {
                    bj.html = '<span unselectable="on" style="display:block;">' + bj.dataItem.Text + "</span>"
                },
                highlightFirst: false
            });
            bg.data(bf).value("inherit")
        }
    }
    function o(bd) {
        a1.call(this, bd);
        var bc = [{
            tags: ["span"]
        }];
        this.update = function(be) {
            be.data("tColorPicker").close()
        };
        this.command = function(be) {
            return new O(a.extend(be, {
                formatter: function() {
                    var bf = {};
                    bf[bd.domAttr] = be.value;
                    return new W(bc, {
                        style: bf
                    }, bd.cssAttr)
                }
            }))
        };
        this.willDelayExecution = ah;
        this.init = function(be, bg) {
            var bf = bg.editor;
            be.tColorPicker({
                selectedColor: "#000000",
                onChange: function(bh) {
                    a1.exec(bf, bd.name, bh.value)
                }
            })
        }
    }
    function aX() {
        a1.call(this);
        var bd = [{
            tags: ["span"]
        }],
			bc = new V(bd, "className");
        this.command = function(be) {
            return new O(a.extend(be, {
                formatter: function() {
                    return new W(bd, {
                        className: be.value
                    })
                }
            }))
        };
        this.update = function(be, bg) {
            var bf = be.data("tSelectBox");
            bf.close();
            bf.value(bc.getFormat(bg))
        };
        this.init = function(be, bg) {
            var bf = bg.editor;
            be.tSelectBox({
                data: bf.style,
                title: bf.localization.style,
                onItemCreate: function(bh) {
                    var bi = x.inlineStyle(bf.document, "span", {
                        className: bh.dataItem.Value
                    });
                    bh.html = '<span unselectable="on" style="display:block;' + bi + '">' + bh.html + "</span>"
                },
                onChange: function(bh) {
                    a1.exec(bf, "style", bh.value)
                }
            })
        }
    }
    function h(bd) {
        function bc(bh, bf) {
            for (var bg = 0; bg < bf.length; bg++) {
                var be = bf[bg];
                if (be == null || !al(bh, be)) {
                    return false
                }
            }
            return true
        }
        this.findSuitable = function(bg) {
            var bh = [];
            for (var bf = 0; bf < bg.length; bf++) {
                var be = x.ofType(bg[bf], bd[0].tags) ? bg[bf] : x.parentOfType(bg[bf], bd[0].tags);
                if (!be) {
                    return []
                }
                if (a.inArray(be, bh) < 0) {
                    bh.push(be)
                }
            }
            for (var bf = 0; bf < bh.length; bf++) {
                if (bc(bh[bf], bh)) {
                    return [bh[bf]]
                }
            }
            return bh
        };
        this.findFormat = function(bh) {
            for (var bf = 0; bf < bd.length; bf++) {
                var bg = bh;
                var bi = bd[bf].tags;
                var be = bd[bf].attr;
                while (bg) {
                    if (x.ofType(bg, bi) && e(bg, be)) {
                        return bg
                    }
                    bg = bg.parentNode
                }
            }
            return null
        };
        this.getFormat = function(bh) {
            var be = a.proxy(function(bj) {
                return this.findFormat(am(bj) ? bj.parentNode : bj)
            }, this),
				bi = be(bh[0]);
            if (!bi) {
                return ""
            }
            for (var bf = 1, bg = bh.length; bf < bg; bf++) {
                if (bi != be(bh[bf])) {
                    return ""
                }
            }
            return bi.nodeName.toLowerCase()
        };
        this.isFormatted = function(bf) {
            for (var be = 0; be < bf.length; be++) {
                if (!this.findFormat(bf[be])) {
                    return false
                }
            }
            return true
        }
    }
    function i(bd, be) {
        var bc = new h(bd);

        function bf(bn, bi, bl) {
            var bj = bl.length == 1 ? x.blockParentOrBody(bl[0]) : x.commonAncestor.apply(null, bl);
            if (x.isInline(bj)) {
                bj = x.blockParentOrBody(bj)
            }
            var bh = x.significantChildNodes(bj);
            var bm = G(bh[0]);
            var bo = x.create(bj.ownerDocument, bn, bi);
            for (var bk = 0; bk < bh.length; bk++) {
                var bg = bh[bk];
                if (x.isBlock(bg)) {
                    x.attr(bg, bi);
                    if (bo.childNodes.length) {
                        x.insertBefore(bo, bg);
                        bo = bo.cloneNode(false)
                    }
                    bm = G(bg) + 1;
                    continue
                }
                bo.appendChild(bg)
            }
            if (bo.firstChild) {
                x.insertAt(bj, bo, bm)
            }
        }
        this.apply = function(bk) {
            var bh = x.is(bk[0], "img") && bk.length == 1 ? [bk[0]] : bc.findSuitable(bk);
            var bi = bh.length ? N(x.name(bh[0]), bd) : bd[0];
            if (!bi) {
                bi = bd[0]
            }
            var bl = bi.tags[0];
            var bg = a.extend({}, bi.attr, be);
            if (bh.length) {
                for (var bj = 0; bj < bh.length; bj++) {
                    x.attr(bh[bj], bg)
                }
            } else {
                bf(bl, bg, bk)
            }
        };
        this.remove = function(bk) {
            for (var bh = 0, bi = bk.length; bh < bi; bh++) {
                var bg = bc.findFormat(bk[bh]);
                if (bg) {
                    if (x.ofType(bg, ["p", "img", "li"])) {
                        var bj = N(x.name(bg), bd);
                        if (bj.attr.style) {
                            x.unstyle(bg, bj.attr.style)
                        }
                        if (bj.attr.className) {
                            x.removeClass(bg, bj.attr.className)
                        }
                    } else {
                        x.unwrap(bg)
                    }
                }
            }
        };
        this.toggle = function(bh) {
            var bg = aK.nodes(bh);
            if (bc.isFormatted(bg)) {
                this.remove(bg)
            } else {
                this.apply(bg)
            }
        }
    }
    function U(bd, be) {
        var bc = new h(bd);
        this.apply = function(bl) {
            var bf = k(bl);
            var bg = bd[0].tags[0];
            if (bf.length) {
                for (var bi = 0, bj = bf.length; bi < bj; bi++) {
                    if (x.is(bf[bi], "li")) {
                        var bk = bf[bi].parentNode;
                        var bh = new au(bk.nodeName.toLowerCase(), bg);
                        var bm = this.editor.createRange();
                        bm.selectNode(bf[bi]);
                        bh.toggle(bm)
                    } else {
                        x.changeTag(bf[bi], bg)
                    }
                }
            } else {
                new i(bd, be).apply(bl)
            }
        };
        this.toggle = function(bg) {
            var bf = a0(bg);
            if (!bf.length) {
                bg.selectNodeContents(bg.commonAncestorContainer);
                bf = a0(bg);
                if (!bf.length) {
                    bf = x.significantChildNodes(bg.commonAncestorContainer)
                }
            }
            this.apply(bf)
        }
    }
    function O(bc) {
        bc.formatter = bc.formatter();
        p.call(this, bc)
    }
    function j(bc) {
        Q.call(this, a.extend(bc, {
            finder: new h(bc.format),
            formatter: function() {
                return new i(bc.format)
            }
        }))
    }
    function M() {
        a1.call(this);
        var bc = new h([{
            tags: g
        }]);
        this.command = function(bd) {
            return new O(a.extend(bd, {
                formatter: function() {
                    return new U([{
                        tags: [bd.value]
                    }], {})
                }
            }))
        };
        this.update = function(bd, bf) {
            var be = bd.data("tSelectBox");
            be.close();
            be.value(bc.getFormat(bf))
        };
        this.init = function(bd, bf) {
            var be = bf.editor;
            bd.tSelectBox({
                data: be.formatBlock,
                title: be.localization.formatBlock,
                onItemCreate: function(bg) {
                    var bh = bg.dataItem.Value;
                    bg.html = "<" + bh + ' unselectable="on" style="margin: .3em 0;' + x.inlineStyle(be.document, bh) + '">' + bg.dataItem.Text + "</" + bh + ">"
                },
                onChange: function(bg) {
                    a1.exec(be, "formatBlock", bg.value)
                },
                highlightFirst: false
            })
        }
    }
    function aF(bc) {
        p.call(this, bc);
        this.exec = function() {
            var bp = this.getRange(),
				bf = w(bp),
				bn, bo, bl, bg = a.browser.msie ? "" : '<br _moz_dirty="" />',
				bm, bk, bj, bi, bq, bd = "p,h1,h2,h3,h4,h5,h6".split(","),
				bs = x.parentOfType(bp.startContainer, bd),
				bh = x.parentOfType(bp.endContainer, bd),
				br = (bs && !bh) || (!bs && bh);
            bp.deleteContents();
            bk = x.create(bf, "a");
            bp.insertNode(bk);
            aB(bk.parentNode);
            bj = x.parentOfType(bk, ["li"]);
            bi = x.parentOfType(bk, "h1,h2,h3,h4,h5,h6".split(","));
            if (bj) {
                bq = bp.cloneRange();
                bq.selectNode(bj);
                if (a0(bq).length == 0) {
                    bm = x.create(bf, "p");
                    if (bj.nextSibling) {
                        aT(bq, bj.parentNode)
                    }
                    x.insertAfter(bm, bj.parentNode);
                    x.remove(bj.parentNode.childNodes.length == 1 ? bj.parentNode : bj);
                    bm.innerHTML = bg;
                    bl = bm
                }
            } else {
                if (bi && !bk.nextSibling) {
                    bm = x.create(bf, "p");
                    x.insertAfter(bm, bi);
                    bm.innerHTML = bg;
                    x.remove(bk);
                    bl = bm
                }
            }
            if (!bl) {
                if (!(bj || bi)) {
                    new i([{
                        tags: ["p"]
                    }]).apply([bk])
                }
                bp.selectNode(bk);
                bn = x.parentOfType(bk, [bj ? "li" : bi ? x.name(bi) : "p"]);
                aT(bp, bn, br);
                bo = bn.previousSibling;
                if (x.is(bo, "li") && bo.firstChild && !x.is(bo.firstChild, "br")) {
                    bo = bo.firstChild
                }
                bl = bn.nextSibling;
                if (x.is(bl, "li") && bl.firstChild && !x.is(bl.firstChild, "br")) {
                    bl = bl.firstChild
                }
                x.remove(bn);

                function be(bt) {
                    if (bt.firstChild && x.is(bt.firstChild, "br")) {
                        x.remove(bt.firstChild)
                    }
                    if (am(bt) && bt.nodeValue == "") {
                        bt = bt.parentNode
                    }
                    if (bt && !x.is(bt, "img")) {
                        while (bt.firstChild && bt.firstChild.nodeType == 1) {
                            bt = bt.firstChild
                        }
                        if (bt.innerHTML == "") {
                            bt.innerHTML = bg
                        }
                    }
                }
                be(bo);
                be(bl);
                aB(bo)
            }
            aB(bl);
            if (x.is(bl, "img")) {
                bp.setStartBefore(bl)
            } else {
                bp.selectNodeContents(bl)
            }
            bp.collapse(true);
            x.scrollTo(bl);
            aR(bp)
        }
    }
    function aA(bc) {
        p.call(this, bc);
        this.exec = function() {
            var bf = this.getRange();
            bf.deleteContents();
            var bd = x.create(w(bf), "br");
            bf.insertNode(bd);
            aB(bd.parentNode);
            if (!a.browser.msie && (!bd.nextSibling || x.isWhitespace(bd.nextSibling))) {
                var be = bd.cloneNode(true);
                be.setAttribute("_moz_dirty", "");
                x.insertAfter(be, bd)
            }
            bf.setStartAfter(bd);
            bf.collapse(true);
            aR(bf)
        }
    }
    function at(bc) {
        var bd = [bc == "ul" ? "ol" : "ul", bc];
        h.call(this, [{
            tags: bd
        }]);
        this.isFormatted = function(bh) {
            var bf = [],
				be;
            for (var bg = 0; bg < bh.length; bg++) {
                if ((be = this.findFormat(bh[bg])) && x.name(be) == bc) {
                    bf.push(be)
                }
            }
            if (bf.length < 1) {
                return false
            }
            if (bf.length != bh.length) {
                return false
            }
            for (bg = 0; bg < bf.length; bg++) {
                if (bf[bg].parentNode != be.parentNode) {
                    break
                }
                if (bf[bg] != be) {
                    return false
                }
            }
            return true
        };
        this.findSuitable = function(bf) {
            var be = x.parentOfType(bf[0], bd);
            if (be && x.name(be) == bc) {
                return be
            }
            return null
        }
    }
    function au(be, bg) {
        var bd = this.finder = new at(be);
        this.tag = be;
        this.wrap = function(bj, bl) {
            var bi = x.create(bj.ownerDocument, "li");
            for (var bh = 0; bh < bl.length; bh++) {
                var bk = bl[bh];
                if (x.is(bk, "li")) {
                    bj.appendChild(bk);
                    continue
                }
                if (x.is(bk, "ul") || x.is(bk, "ol")) {
                    while (bk.firstChild) {
                        bj.appendChild(bk.firstChild)
                    }
                    continue
                }
                if (x.is(bk, "td")) {
                    while (bk.firstChild) {
                        bi.appendChild(bk.firstChild)
                    }
                    bj.appendChild(bi);
                    bk.appendChild(bj);
                    bj = bj.cloneNode(false);
                    bi = bi.cloneNode(false);
                    continue
                }
                bi.appendChild(bk);
                if (x.isBlock(bk)) {
                    bj.appendChild(bi);
                    x.unwrap(bk);
                    bi = bi.cloneNode(false)
                }
            }
            if (bi.firstChild) {
                bj.appendChild(bi)
            }
        };
        var bc = this.containsAny = function(bj, bi) {
            for (var bh = 0; bh < bi.length; bh++) {
                if (al(bj, bi[bh])) {
                    return true
                }
            }
            return false
        };
        this.suitable = function(bh, bi) {
            if (bh.className == "t-marker") {
                var bj = bh.nextSibling;
                if (bj && x.isBlock(bj)) {
                    return false
                }
                bj = bh.previousSibling;
                if (bj && x.isBlock(bj)) {
                    return false
                }
            }
            return bc(bh, bi) || x.isInline(bh) || bh.nodeType == 3
        };
        this.split = function(bn) {
            var bl = a0(bn);
            if (bl.length) {
                var bo = x.parentOfType(bl[0], ["li"]);
                var bh = x.parentOfType(bl[bl.length - 1], ["li"]);
                bn.setStartBefore(bo);
                bn.setEndAfter(bh);
                for (var bj = 0, bk = bl.length; bj < bk; bj++) {
                    var bi = bd.findFormat(bl[bj]);
                    if (bi) {
                        var bm = a(bi).parents("ul,ol");
                        if (bm[0]) {
                            aT(bn, bm.last()[0], true)
                        } else {
                            aT(bn, bi, true)
                        }
                    }
                }
            }
        };
        a.extend(this, {
            merge: function(bk, bh) {
                var bj = bh.previousSibling,
					bi;
                while (bj && (bj.className == "k-marker" || (bj.nodeType == 3 && x.isWhitespace(bj)))) {
                    bj = bj.previousSibling
                }
                if (bj && x.name(bj) == bk) {
                    while (bh.firstChild) {
                        bj.appendChild(bh.firstChild)
                    }
                    x.remove(bh);
                    bh = bj
                }
                bi = bh.nextSibling;
                while (bi && (bi.className == "k-marker" || (bi.nodeType == 3 && x.isWhitespace(bi)))) {
                    bi = bi.nextSibling
                }
                if (bi && x.name(bi) == bk) {
                    while (bh.lastChild) {
                        bi.insertBefore(bh.lastChild, bi.firstChild)
                    }
                    x.remove(bh)
                }
            },
            applyOnSection: function(bq, bo) {
                var br = this.tag,
					bk;
                if (bo.length == 1) {
                    bk = x.parentOfType(bo[0], ["ul", "ol"])
                } else {
                    bk = x.commonAncestor.apply(null, bo)
                }
                if (!bk) {
                    bk = x.parentOfType(bo[0], ["td"]) || bo[0].ownerDocument.body
                }
                if (x.isInline(bk)) {
                    bk = x.blockParentOrBody(bk)
                }
                var bh = [];
                var bl = this.finder.findSuitable(bo);
                if (!bl) {
                    bl = new at(br == "ul" ? "ol" : "ul").findSuitable(bo)
                }
                var bj = x.significantChildNodes(bk);
                if (!bj.length) {
                    bj = bo
                }
                if (/table|tbody/.test(x.name(bk))) {
                    bj = a.map(bo, function(bs) {
                        return x.parentOfType(bs, ["td"])
                    })
                }
                function bp() {
                    bh.push(this)
                }
                for (var bm = 0; bm < bj.length; bm++) {
                    var bi = bj[bm];
                    var bn = x.name(bi);
                    if (this.suitable(bi, bo) && (!bl || !x.isAncestorOrSelf(bl, bi))) {
                        if (bl && (bn == "ul" || bn == "ol")) {
                            a.each(bi.childNodes, bp);
                            x.remove(bi)
                        } else {
                            bh.push(bi)
                        }
                    }
                }
                if (bh.length == bj.length && bk != bo[0].ownerDocument.body && !/table|tbody|tr|td/.test(x.name(bk))) {
                    bh = [bk]
                }
                if (!bl) {
                    bl = x.create(bk.ownerDocument, br);
                    x.insertBefore(bl, bh[0])
                }
                this.wrap(bl, bh);
                if (!x.is(bl, br)) {
                    x.changeTag(bl, br)
                }
                this.merge(br, bl)
            },
            apply: function(bk) {
                var bh = 0,
					bm = [],
					bj, bi, bl;
                do {
                    bl = x.parentOfType(bk[bh], ["td", "body"]);
                    if (!bj || bl != bj) {
                        if (bj) {
                            bm.push({
                                section: bj,
                                nodes: bi
                            })
                        }
                        bi = [bk[bh]];
                        bj = bl
                    } else {
                        bi.push(bk[bh])
                    }
                    bh++
                } while (bh < bk.length);
                bm.push({
                    section: bj,
                    nodes: bi
                });
                for (bh = 0; bh < bm.length; bh++) {
                    this.applyOnSection(bm[bh].section, bm[bh].nodes)
                }
            }
        });

        function bf(bm) {
            var bl = a(bm).parents("ul,ol"),
				bj, bk, bh, bi;
            if (bl[0]) {
                bi = function(bn) {
                    x.insertBefore(bn, bl.last()[0])
                }
            } else {
                bi = function(bn) {
                    x.insertBefore(bn, bm)
                }
            }
            for (bj = bm.firstChild; bj; bj = bj.nextSibling) {
                bk = x.create(bm.ownerDocument, bg || "p");
                while (bj.firstChild) {
                    bh = bj.firstChild;
                    if (x.isBlock(bh)) {
                        if (bk.firstChild) {
                            bi(bk);
                            bk = x.create(bm.ownerDocument, bg || "p")
                        }
                        bi(bh)
                    } else {
                        bk.appendChild(bh)
                    }
                }
                if (bk.firstChild) {
                    bi(bk)
                }
            }
            if (bl[0]) {
                bl.last().remove()
            }
            x.remove(bm)
        }
        this.remove = function(bk) {
            var bh;
            for (var bi = 0, bj = bk.length; bi < bj; bi++) {
                if (bh = bd.findFormat(bk[bi])) {
                    bf(bh)
                }
            }
        };
        this.toggle = function(bj) {
            var bi = a0(bj),
				bh = bj.commonAncestorContainer;
            if (!bi.length) {
                bj.selectNodeContents(bh);
                bi = a0(bj);
                if (!bi.length) {
                    var bk = bh.ownerDocument.createTextNode("");
                    bj.startContainer.appendChild(bk);
                    bi = [bk];
                    bj.selectNode(bk.parentNode)
                }
            }
            if (bd.isFormatted(bi)) {
                this.split(bj);
                this.remove(bi)
            } else {
                this.apply(bi)
            }
        }
    }
    function ar(bc) {
        bc.formatter = new au(bc.tag);
        p.call(this, bc)
    }
    function av(bc) {
        Q.call(this, a.extend(bc, {
            finder: new at(bc.tag)
        }));
        this.command = function(bd) {
            return new ar(a.extend(bd, {
                tag: bc.tag
            }))
        }
    }
    function ap() {
        this.findSuitable = function(bc) {
            return x.parentOfType(bc, ["a"])
        }
    }
    function aq() {
        this.finder = new ap();
        this.apply = function(bi, bd) {
            var bh = a0(bi);
            if (bd.innerHTML != undefined) {
                var bg = S(bi);
                var be = w(bi);
                bi.deleteContents();
                var bc = x.create(be, "a", bd);
                bi.insertNode(bc);
                if (bg.length > 1) {
                    x.insertAfter(bg[bg.length - 1], bc);
                    x.insertAfter(bg[1], bc);
                    x[bh.length > 0 ? "insertBefore" : "insertAfter"](bg[0], bc)
                }
            } else {
                var bf = new af([{
                    tags: ["a"]
                }], bd);
                bf.finder = this.finder;
                bf.apply(bh)
            }
        }
    }
    function a4(bc) {
        bc.formatter = {
            toggle: function(bd) {
                new af([{
                    tags: ["a"]
                }]).remove(a0(bd))
            }
        };
        p.call(this, bc)
    }
    function ao(be) {
        p.call(this, be);
        var bc;
        this.async = true;
        var bd = new aq();
        this.exec = function() {
            var bn = this.getRange();
            var bi = bn.collapsed;
            bn = this.lockRange(true);
            var bm = a0(bn);
            var bk = null;
            var bo = this;

            function bg(bq) {
                var br = a("#t-editor-link-url", bj.element).val();
                if (br && br != "http://") {
                    bc = {
                        href: br
                    };
                    var bu = a("#t-editor-link-title", bj.element).val();
                    if (bu) {
                        bc.title = bu
                    }
                    var bt = a("#t-editor-link-text", bj.element).val();
                    if (bt !== bk) {
                        bc.innerHTML = bt || br
                    }
                    var bs = a("#t-editor-link-target", bj.element).is(":checked");
                    if (bs) {
                        bc.target = "_blank"
                    }
                    bd.apply(bn, bc)
                }
                bh(bq);
                if (bo.change) {
                    bo.change()
                }
            }
            function bh(bq) {
                bq.preventDefault();
                bj.destroy();
                bb(w(bn)).focus();
                bo.releaseRange(bn)
            }
            var bf = bm.length ? bd.finder.findSuitable(bm[0]) : null;
            var bp = bm.length <= 1 || (bm.length == 2 && bi);
            var bl = bo.editor.localization;
            var bj = b.window.create(a.extend({}, this.editor.dialogOptions, {
                title: "Insert link",
                html: new a.easyui.stringBuilder().cat('<div class="t-editor-dialog">').cat("<ol>").cat('<li class="t-form-text-row"><label for="t-editor-link-url">' + bl.webAddress + '</label><input type="text" class="t-input" id="t-editor-link-url"/></li>').catIf('<li class="t-form-text-row"><label for="t-editor-link-text">Text</label><input type="text" class="t-input" id="t-editor-link-text"/></li>', bp).cat('<li class="t-form-text-row"><label for="t-editor-link-title">' + bl.tooltip + '</label><input type="text" class="t-input" id="t-editor-link-title"/></li>').cat('<li class="t-form-checkbox-row"><input type="checkbox" id="t-editor-link-target"/><label for="t-editor-link-target">' + bl.openInNewWindow + "</label></li>").cat("</ol>").cat('<div class="t-button-wrapper">').cat('<button class="t-dialog-insert t-button">' + bl.insert + "</button>").cat("&nbsp;" + bl.or + "&nbsp;").cat('<a href="#" class="t-dialog-close t-link">' + bl.close + "</a>").cat("</div>").cat("</div>").string(),
                onClose: bh
            })).hide().find(".t-dialog-insert").click(bg).end().find(".t-dialog-close").click(bh).end().find(".t-form-text-row input").keydown(function(bq) {
                if (bq.keyCode == 13) {
                    bg(bq)
                } else {
                    if (bq.keyCode == 27) {
                        bh(bq)
                    }
                }
            }).end().find("#t-editor-link-url").val(bf ? bf.getAttribute("href", 2) : "http://").end().find("#t-editor-link-text").val(bm.length > 0 ? (bm.length == 1 ? bm[0].nodeValue : bm[0].nodeValue + bm[1].nodeValue) : "").end().find("#t-editor-link-title").val(bf ? bf.title : "").end().find("#t-editor-link-target").attr("checked", bf ? bf.target == "_blank" : false).end().show().data("tWindow").center();
            if (bp && bm.length > 0) {
                bk = a("#t-editor-link-text", bj.element).val()
            }
            a("#t-editor-link-url", bj.element).focus().select()
        }, this.redo = function() {
            var bf = this.lockRange(true);
            bd.apply(bf, bc);
            this.releaseRange(bf)
        }
    }
    function a5(be) {
        a1.call(this, a.extend(be, {
            command: a4
        }));
        var bd = new ae([{
            tags: ["a"]
        }]),
			bc = this.init;
        this.init = function(bf, bg) {
            bc.call(this, bf, bg);
            bf.addClass("t-state-disabled")
        };
        this.update = function(bf, bg) {
            bf.toggleClass("t-state-disabled", !bd.isFormatted(bg)).removeClass("t-state-hover")
        }
    }
    function X(be) {
        p.call(this, be);
        this.async = true;
        var bc;

        function bd(bf, bg) {
            if (bc.src && bc.src != "http://") {
                if (!bf) {
                    bf = x.create(w(bg), "img", bc);
                    bf.onload = bf.onerror = function() {
                        bf.removeAttribute("complete");
                        bf.removeAttribute("width");
                        bf.removeAttribute("height")
                    };
                    bg.deleteContents();
                    bg.insertNode(bf);
                    bg.setStartAfter(bf);
                    bg.setEndAfter(bf);
                    aR(bg);
                    return true
                } else {
                    x.attr(bf, bc)
                }
            }
            return false
        }
        this.redo = function() {
            var bf = this.lockRange();
            if (!bd(aK.image(bf), bf)) {
                this.releaseRange(bf)
            }
        };
        this.exec = function() {
            var bn = this.lockRange();
            var bg = false;
            var bl = aK.image(bn);
            var bo = this;

            function bh(bq) {
                bc = {
                    src: a("#t-editor-image-url", bj.element).val(),
                    alt: a("#t-editor-image-title", bj.element).val()
                };
                bg = bd(bl, bn);
                bi(bq);
                if (bo.change) {
                    bo.change()
                }
            }
            function bi(bq) {
                bq.preventDefault();
                bj.destroy();
                bb(w(bn)).focus();
                if (!bg) {
                    bo.releaseRange(bn)
                }
            }
            var bk = this.editor.fileBrowser;
            var bp = bk && bk.selectUrl !== undefined;
            var bm = bo.editor.localization;

            function bf() {
                if (bp) {
                    new b.imageBrowser(a(this).find(".t-image-browser"), a.extend(bk, {
                        apply: bh,
                        element: bo.editor.element,
                        localization: bo.editor.localization
                    }))
                }
            }
            var bj = b.window.create(a.extend({
                width: 750
            }, this.editor.dialogOptions, {
                title: bm.insertImage,
                html: new a.easyui.stringBuilder().cat('<div class="t-editor-dialog">').catIf('<div class="t-image-browser"></div>', bp).cat("<ol>").cat('<li class="t-form-text-row"><label for="t-editor-image-url">' + bm.webAddress + '</label><input type="text" class="t-input" id="t-editor-image-url"/></li>').cat('<li class="t-form-text-row"><label for="t-editor-image-title">' + bm.tooltip + '</label><input type="text" class="t-input" id="t-editor-image-title"/></li>').cat("</ol>").cat('<div class="t-button-wrapper">').cat('<button class="t-dialog-insert t-button">' + bm.insert + "</button>").cat("&nbsp;" + bm.or + "&nbsp;").cat('<a href="#" class="t-dialog-close t-link">' + bm.close + "</a>").cat("</div>").cat("</div>").string(),
                onClose: bi,
                onActivate: bf
            })).hide().find(".t-dialog-insert").click(bh).end().find(".t-dialog-close").click(bi).end().find(".t-form-text-row input").keydown(function(bq) {
                if (bq.keyCode == 13) {
                    bh(bq)
                } else {
                    if (bq.keyCode == 27) {
                        bi(bq)
                    }
                }
            }).end().toggleClass("t-imagebrowser", bp).find("#t-editor-image-url").val(bl ? bl.getAttribute("src", 2) : "http://").end().find("#t-editor-image-title").val(bl ? bl.alt : "").end().show().data("tWindow").center();
            a("#t-editor-image-url", bj.element).focus().select()
        }
    }
    b.selectbox = function(bf, bh) {
        var bj;
        var bc = a(bf).attr("tabIndex", 0);
        var bd = bc.find(".t-input");
        var be = this.dropDown = new b.dropDown({
            effects: b.fx.slide.defaults(),
            onItemCreate: bh.onItemCreate,
            onClick: function(bl) {
                bi(bh.data[a(bl.item).index()].Value);
                bh.onChange({
                    value: bj
                })
            }
        });

        function bg() {
            if (!be.$items) {
                be.dataBind(bh.data)
            }
        }
        function bk(bl) {
            bd.html(bl ? bl : "&nbsp;")
        }
        function bi(bn) {
            bg();
            var bm = -1;
            for (var bl = 0, bo = bh.data.length; bl < bo; bl++) {
                if (bh.data[bl].Value == bn) {
                    bm = bl;
                    break
                }
            }
            if (bm != -1) {
                be.$items.removeClass("t-state-selected").eq(bm).addClass("t-state-selected");
                bk(a(be.$items[bm]).text());
                bj = bh.data[bm].Value
            }
        }
        this.value = function(bl) {
            if (bl == undefined) {
                return bj
            }
            bi(bl);
            if (bj != bl) {
                bk(bh.title || bl)
            }
        };
        this.close = function() {
            be.close()
        };
        bk(bh.title || bd.text());
        bc.click(function(bl) {
            bg();
            if (be.isOpened()) {
                be.close()
            } else {
                be.open({
                    offset: bc.offset(),
                    outerHeight: bc.outerHeight(),
                    outerWidth: bc.outerWidth(),
                    zIndex: b.getElementZIndex(bc[0])
                })
            }
        }).find("*").attr("unselectable", "on").end().keydown(function(bl) {
            var bm = bl.keyCode,
				bp, bo, bn;
            if (bm === 40) {
                if (!be.isOpened()) {
                    bc.click()
                } else {
                    bp = be.$items.filter(".t-state-selected");
                    if (!bp[0]) {
                        bn = be.$items.first()
                    } else {
                        bn = bp.next()
                    }
                    if (bn[0]) {
                        bp.removeClass("t-state-selected");
                        bn.addClass("t-state-selected")
                    }
                }
                bl.preventDefault()
            } else {
                if (bm === 38) {
                    if (be.isOpened()) {
                        bp = be.$items.filter(".t-state-selected");
                        bo = bp.prev();
                        if (bo[0]) {
                            bp.removeClass("t-state-selected");
                            bo.addClass("t-state-selected")
                        }
                    }
                    bl.preventDefault()
                } else {
                    if (bm == 13) {
                        bp = be.$items.filter(".t-state-selected");
                        if (bp[0]) {
                            bp.click()
                        }
                        bl.preventDefault()
                    } else {
                        if (bl.keyCode == 9 || bl.keyCode == 39 || bl.keyCode == 37) {
                            be.close()
                        }
                    }
                }
            }
        });
        if (a.browser.msie) {
            bc.focus(function() {
                bc.css("outline", "1px dotted #000")
            }).blur(function() {
                bc.css("outline", "")
            })
        }
        be.$element.css("direction", bc.closest(".t-rtl").length > 0 ? "rtl" : "");
        a(document.documentElement).bind("mousedown", a.proxy(function(bm) {
            var bl = be.$element;
            var bn = bl && bl.parent().length > 0;
            if (bn && !a.contains(bf, bm.target) && !a.contains(bl.parent()[0], bm.target)) {
                be.close()
            }
        }, this))
    };
    a.fn.tSelectBox = function(bc) {
        return b.create(this, {
            name: "tSelectBox",
            init: function(bd, be) {
                return new b.selectbox(bd, be)
            },
            options: bc
        })
    };
    a.fn.tSelectBox.defaults = {
        effects: b.fx.slide.defaults()
    };
    b.colorpicker = function(bd, be) {
        var bf = this;
        bf.element = bd;
        var bc = a(bd);
        a.extend(bf, be);
        bc.attr("tabIndex", 0).click(a.proxy(bf.click, bf)).keydown(function(bg) {
            var bi = bf.popup(),
				bk, bh, bj;
            if (bg.keyCode == 40) {
                if (!bi.is(":visible")) {
                    bf.open()
                } else {
                    bk = bi.find(".t-state-selected");
                    if (bk[0]) {
                        bh = bk.next()
                    } else {
                        bh = bi.find("li:first")
                    }
                    if (bh[0]) {
                        bk.removeClass("t-state-selected");
                        bh.addClass("t-state-selected")
                    }
                }
                bg.preventDefault()
            } else {
                if (bg.keyCode == 38) {
                    if (bi.is(":visible")) {
                        bk = bi.find(".t-state-selected");
                        bj = bk.prev();
                        if (bj[0]) {
                            bk.removeClass("t-state-selected");
                            bj.addClass("t-state-selected")
                        }
                    }
                    bg.preventDefault()
                } else {
                    if (bg.keyCode == 9 || bg.keyCode == 39 || bg.keyCode == 37) {
                        bf.close()
                    } else {
                        if (bg.keyCode == 13) {
                            bi.find(".t-state-selected").click();
                            bg.preventDefault()
                        }
                    }
                }
            }
        }).find("*").attr("unselectable", "on");
        if (a.browser.msie) {
            bc.focus(function() {
                bc.css("outline", "1px dotted #000")
            }).blur(function() {
                bc.css("outline", "")
            })
        }
        if (bf.selectedColor) {
            bc.find(".t-selected-color").css("background-color", this.selectedColor)
        }
        a(bd.ownerDocument.documentElement).bind("mousedown", a.proxy(function(bg) {
            if (!a(bg.target).closest(".t-colorpicker-popup").length) {
                this.close()
            }
        }, bf));
        b.bind(bf, {
            change: bf.onChange,
            load: bf.onLoad
        })
    };
    b.colorpicker.prototype = {
        select: function(bc) {
            if (bc) {
                bc = x.toHex(bc);
                if (!b.trigger(this.element, "change", {
                    value: bc
                })) {
                    this.value(bc);
                    this.close()
                }
            } else {
                b.trigger(this.element, "change", {
                    value: this.selectedColor
                })
            }
        },
        open: function() {
            var bd = this.popup();
            var bc = a(this.element);
            var be = bc.offset();
            be.top += bc.outerHeight();
            if (bc.closest(".t-rtl").length) {
                be.left -= bd.outerWidth() - bc.outerWidth()
            }
            var bf = "auto";
            bc.parents().andSelf().each(function() {
                bf = a(this).css("zIndex");
                if (Number(bf)) {
                    bf = Number(bf) + 1;
                    return false
                }
            });
            b.fx._wrap(bd).css(a.extend({
                position: "absolute",
                zIndex: bf
            }, be));
            bd.find(".t-item").bind("click", a.proxy(function(bh) {
                var bg = a(bh.currentTarget, bh.target.ownerDocument).find("div").css("background-color");
                this.select(bg)
            }, this));
            b.fx.play(this.effects, bd, {
                direction: "bottom"
            })
        },
        close: function() {
            if (!this.$popup) {
                return
            }
            b.fx.rewind(this.effects, this.$popup, {
                direction: "bottom"
            }, a.proxy(function() {
                if (this.$popup) {
                    x.remove(this.$popup[0].parentNode);
                    this.$popup = null
                }
            }, this))
        },
        toggle: function() {
            if (!this.$popup || !this.$popup.is(":visible")) {
                this.open()
            } else {
                this.close()
            }
        },
        click: function(bc) {
            if (a(bc.target).closest(".t-tool-icon").length > 0) {
                this.select()
            } else {
                this.toggle()
            }
        },
        value: function(bc) {
            if (!bc) {
                return this.selectedColor
            }
            bc = x.toHex(bc);
            this.selectedColor = bc;
            a(".t-selected-color", this.element).css("background-color", bc)
        },
        popup: function() {
            if (!this.$popup) {
                this.$popup = a(b.colorpicker.buildPopup(this)).hide().appendTo(document.body).find("*").attr("unselectable", "on").end()
            }
            return this.$popup
        }
    };
    a.extend(b.colorpicker, {
        buildPopup: function(bc) {
            var bf = new b.stringBuilder();
            bf.cat('<div class="t-popup t-group t-colorpicker-popup">').cat('<ul class="t-reset">');
            var be = bc.data;
            var bd = (bc.value() || "").substring(1);
            for (var bg = 0, bh = be.length; bg < bh; bg++) {
                bf.cat('<li class="t-item').catIf(" t-state-selected", be[bg] == bd).cat('"><div style="background-color:#').cat(be[bg]).cat('"></div></li>')
            }
            bf.cat("</ul></div>");
            return bf.string()
        }
    });
    a.fn.tColorPicker = function(bc) {
        return b.create(this, {
            name: "tColorPicker",
            init: function(bd, be) {
                return new b.colorpicker(bd, be)
            },
            options: bc
        })
    };
    a.fn.tColorPicker.defaults = {
        data: "000000,7f7f7f,880015,ed1c24,ff7f27,fff200,22b14c,00a2e8,3f48cc,a349a4,ffffff,c3c3c3,b97a57,ffaec9,ffc90e,efe4b0,b5e61d,99d9ea,7092be,c8bfe7".split(","),
        selectedColor: null,
        effects: b.fx.slide.defaults()
    };

    function Y(bc, be) {
        var bd = x.name(bc) != "td" ? "marginLeft" : "paddingLeft";
        if (be === undefined) {
            return bc.style[bd] || 0
        } else {
            if (be > 0) {
                bc.style[bd] = be + "px"
            } else {
                bc.style[bd] = "";
                if (bc.style.cssText == "") {
                    bc.removeAttribute("style")
                }
            }
        }
    }
    function aa() {
        var bc = new h([{
            tags: g
        }]);
        this.apply = function(bl) {
            var bg = bc.findSuitable(bl);
            if (bg.length) {
                var bo = [];
                for (var bi = 0; bi < bg.length; bi++) {
                    if (x.is(bg[bi], "li")) {
                        if (a(bg[bi]).index() == 0) {
                            bo.push(bg[bi].parentNode)
                        } else {
                            if (a.inArray(bg[bi].parentNode, bo) < 0) {
                                bo.push(bg[bi])
                            }
                        }
                    } else {
                        bo.push(bg[bi])
                    }
                }
                while (bo.length) {
                    var bf = bo.shift();
                    if (x.is(bf, "li")) {
                        var bm = bf.parentNode;
                        var bd = a(bf).prev("li");
                        var be = bd.find("ul,ol").last();
                        var bk = a(bf).children("ul,ol")[0];
                        if (bk && bd[0]) {
                            if (be[0]) {
                                be.append(bf);
                                be.append(a(bk).children());
                                x.remove(bk)
                            } else {
                                bd.append(bk);
                                bk.insertBefore(bf, bk.firstChild)
                            }
                        } else {
                            bk = bd.children("ul,ol")[0];
                            if (!bk) {
                                bk = x.create(bf.ownerDocument, x.name(bm));
                                bd.append(bk)
                            }
                            while (bf && bf.parentNode == bm) {
                                bk.appendChild(bf);
                                bf = bo.shift()
                            }
                        }
                    } else {
                        var bj = parseInt(Y(bf)) + 30;
                        Y(bf, bj);
                        for (var bn = 0; bn < bo.length; bn++) {
                            if (a.contains(bf, bo[bn])) {
                                bo.splice(bn, 1)
                            }
                        }
                    }
                }
            } else {
                var bh = new i([{
                    tags: "p"
                }], {
                    style: {
                        marginLeft: 30
                    }
                });
                bh.apply(bl)
            }
        };
        this.remove = function(bk) {
            var bh = bc.findSuitable(bk),
				bl;
            for (var bi = 0; bi < bh.length; bi++) {
                var bd = a(bh[bi]);
                if (bd.is("li")) {
                    var be = bd.parent();
                    var bf = be.parent();
                    if (bf.is("li,ul,ol") && !Y(be[0])) {
                        if (bl && a.contains(bl, bf[0])) {
                            continue
                        }
                        var bg = bd.nextAll("li");
                        if (bg.length) {
                            a(be[0].cloneNode(false)).appendTo(bd).append(bg)
                        }
                        if (bf.is("li")) {
                            bd.insertAfter(bf)
                        } else {
                            bd.appendTo(bf)
                        }
                        if (!be.children("li").length) {
                            be.remove()
                        }
                        continue
                    } else {
                        if (bl == be[0]) {
                            continue
                        }
                        bl = be[0]
                    }
                } else {
                    bl = bh[bi]
                }
                var bj = parseInt(Y(bl)) - 30;
                Y(bl, bj)
            }
        }
    }
    function Z(bc) {
        bc.formatter = {
            toggle: function(bd) {
                new aa().apply(aK.nodes(bd))
            }
        };
        p.call(this, bc)
    }
    function aD(bc) {
        bc.formatter = {
            toggle: function(bd) {
                new aa().remove(aK.nodes(bd))
            }
        };
        p.call(this, bc)
    }
    function aE() {
        a1.call(this, {
            command: aD
        });
        var bd = new h([{
            tags: g
        }]),
			bc = this.init;
        this.init = function(be, bf) {
            bc.call(this, be, bf);
            be.addClass("t-state-disabled")
        };
        this.update = function(be, bi) {
            var bj = bd.findSuitable(bi),
				bg, bh;
            for (var bf = 0; bf < bj.length; bf++) {
                bg = Y(bj[bf]);
                if (!bg) {
                    bh = a(bj[bf]).parents("ul,ol").length;
                    bg = (x.is(bj[bf], "li") && (bh > 1 || Y(bj[bf].parentNode))) || (x.ofType(bj[bf], ["ul", "ol"]) && bh > 0)
                }
                if (bg) {
                    be.removeClass("t-state-disabled");
                    return
                }
            }
            be.addClass("t-state-disabled").removeClass("t-state-hover")
        }
    }
    function aG(bc) {
        this.editor = bc;
        this.formats = []
    }
    aG.prototype = {
        apply: function(bi) {
            if (!this.hasPending()) {
                return
            }
            var bg = new ay();
            bg.addCaret(bi);
            var bc = bi.startContainer.childNodes[bi.startOffset];
            var bj = bc.previousSibling;
            if (!bj.nodeValue) {
                bj = bj.previousSibling
            }
            bi.setStart(bj, bj.nodeValue.length - 1);
            bg.add(bi);
            if (a0(bi).length == 0) {
                bg.remove(bi);
                bi.collapse(true);
                this.editor.selectRange(bi);
                return
            }
            var bk = bg.end.previousSibling.previousSibling;
            var bh, be = this.formats;
            for (var bf = 0; bf < be.length; bf++) {
                bh = be[bf];
                var bd = bh.command(a.extend({
                    range: bi
                }, bh.params));
                bd.editor = this.editor;
                bd.exec();
                bi.selectNode(bk)
            }
            bg.remove(bi);
            if (bk.parentNode) {
                bi.setStart(bk, 1);
                bi.collapse(true)
            }
            this.clear();
            this.editor.selectRange(bi)
        },
        hasPending: function() {
            return this.formats.length > 0
        },
        isPending: function(bc) {
            return !!this.getPending(bc)
        },
        getPending: function(bc) {
            var bd = this.formats;
            for (var be = 0; be < bd.length; be++) {
                if (bd[be].name == bc) {
                    return bd[be]
                }
            }
            return
        },
        toggle: function(bc) {
            var bd = this.formats;
            for (var be = 0; be < bd.length; be++) {
                if (bd[be].name == bc.name) {
                    if (bd[be].params && bd[be].params.value != bc.params.value) {
                        bd[be].params.value = bc.params.value
                    } else {
                        bd.splice(be, 1)
                    }
                    return
                }
            }
            bd.push(bc)
        },
        clear: function() {
            this.formats = []
        }
    };

    function a7(bc) {
        var bd = this;
        bd.options = bc;
        p.call(bd, bc);
        bd.attributes = null;
        bd.async = true;
        bd.exec = function() {
            var bi = bd.editor,
				bj = bi.getRange(),
				bh = a(a7.template).appendTo(document.body),
				bg = a7.indent(bi.value()),
				bk = ".t-editor-textarea";

            function be(bl) {
                bi.value(bh.find(bk).val());
                bf(bl);
                if (bd.change) {
                    bd.change()
                }
            }
            function bf(bl) {
                if (bl) {
                    bl.preventDefault()
                }
                bh.data("tWindow").destroy();
                bb(w(bj)).focus()
            }
            bh.tWindow(a.extend({}, bi.dialogOptions, {
                title: "View HTML",
                close: bf
            })).hide().find(bk).val(bg).end().find(".t-dialog-update").click(be).end().find(".t-dialog-close").click(bf).end().show().data("tWindow").center();
            bh.find(bk).focus()
        }
    }
    a.extend(a7, {
        template: "<div><div class='t-editor-dialog'><textarea class='t-editor-textarea t-input'></textarea><div class='t-button-wrapper'><button class='t-dialog-update t-button'>Update</button>&nbsp;or&nbsp;<a href='#' class='t-dialog-close t-link'>Close</a></div></div></div>",
        indent: function(bc) {
            return bc.replace(/<\/(p|li|ul|ol|h[1-6]|table|tr|td|th)>/ig, "</$1>\n").replace(/<(ul|ol)([^>]*)><li/ig, "<$1$2>\n<li").replace(/<br \/>/ig, "<br />\n").replace(/\n$/, "")
        }
    });

    function r(bc, bg) {
        bc.hide();
        var bf = a("<iframe />", {
            frameBorder: "0"
        }).css("display", "").addClass("t-content").insertBefore(bc)[0];
        var bh = bf.contentWindow || bf;
        var bd = bh.document || bf.contentDocument;
        var be = bc.val().replace(/(<\/?img[^>]*>)[\r\n\v\f\t ]+/ig, "$1").replace(/[\r\n\v\f\t ]+/ig, " ");
        if (!be.length && a.browser.mozilla) {
            be = '<br _moz_dirty="true" />'
        }
        bd.designMode = "On";
        bd.open();
        bd.write(new b.stringBuilder().cat("<!DOCTYPE html><html><head>").cat('<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />').cat('<style type="text/css">').cat("html,body{padding:0;margin:0;height:100%;min-height:100%;font-family:Verdana,Geneva,sans-serif;background:#fff;}").cat("html{font-size:100%}body{font-size:.75em;line-height:1.5;padding-top:1px;margin-top:-1px;").catIf("direction:rtl;", bc.closest(".t-rtl").length).cat("}").cat("h1{font-size:2em;margin:.67em 0}h2{font-size:1.5em}h3{font-size:1.16em}h4{font-size:1em}h5{font-size:.83em}h6{font-size:.7em}").cat("p{margin:0 0 1em;padding:0 .2em}.t-marker{display:none;}.t-paste-container{position:absolute;left:-10000px;width:1px;height:1px;overflow:hidden}").cat("ul,ol{padding-left:30px;margin-left:30px;}").cat("a{color:#00a}").cat("code{font-size:1.23em}").cat("</style>").cat(a.map(bg, function(bi) {
            return ['<link type="text/css" href="', bi, '" rel="stylesheet"/>'].join("")
        }).join("")).cat("</head><body>").cat(be).cat("</body></html>").string());
        bd.close();
        return bh
    }
    function aN(bc) {
        b.trigger(bc.element, "selectionChange")
    }
    var J = ".t-colorpicker,a.t-tool-icon:not(.t-state-disabled),.t-selectbox, .t-combobox .t-input";

    function ab(bc) {
        var bd = true;
        bc.window = r(a(bc.textarea), bc.stylesheets);
        bc.document = bc.window.contentDocument || bc.window.document;
        bc.body = bc.document.body;
        a(bc.document).bind({
            keydown: function(be) {
                if (be.keyCode == 9 && be.shiftKey && !be.altKey && !be.ctrlKey) {
                    var bf = a(bc.element).find(J);
                    if (bf.length) {
                        be.preventDefault();
                        bf.focus()
                    }
                } else {
                    if (be.keyCode === 121) {
                        setTimeout(function() {
                            var bi = a(bc.element).attr("tabIndex");
                            a(bc.element).attr("tabIndex", bi || 0).focus().find(J).first().focus();
                            if (!bi && bi !== 0) {
                                a(bc.element).removeAttr("tabIndex")
                            }
                        }, 100);
                        be.preventDefault()
                    } else {
                        var bh = bc.keyboard.toolFromShortcut(bc.tools, be);
                        if (bh) {
                            be.preventDefault();
                            if (!/undo|redo/.test(bh)) {
                                bc.keyboard.endTyping(true)
                            }
                            bc.exec(bh);
                            return false
                        }
                        if (bc.keyboard.isTypingKey(be) && bc.pendingFormats.hasPending()) {
                            if (bd) {
                                bd = false
                            } else {
                                var bg = bc.getRange();
                                bc.pendingFormats.apply(bg);
                                bc.selectRange(bg)
                            }
                        }
                        bc.keyboard.clearTimeout();
                        bc.keyboard.keydown(be)
                    }
                }
            },
            keyup: function(be) {
                var bg = [8, 9, 33, 34, 35, 36, 37, 38, 39, 40, 40, 45, 46];
                if (a.browser.mozilla && be.keyCode == 8) {
                    H(bc, be)
                }
                if (a.inArray(be.keyCode, bg) > -1 || (be.keyCode == 65 && be.ctrlKey && !be.altKey && !be.shiftKey)) {
                    bc.pendingFormats.clear();
                    aN(bc)
                }
                if (bc.keyboard.isTypingKey(be)) {
                    if (bc.pendingFormats.hasPending()) {
                        var bf = bc.getRange();
                        bc.pendingFormats.apply(bf);
                        bc.selectRange(bf)
                    }
                } else {
                    bd = true
                }
                bc.keyboard.keyup(be)
            },
            mousedown: function(be) {
                bc.pendingFormats.clear();
                var bf = a(be.target);
                if (!a.browser.gecko && be.which == 2 && bf.is("a[href]")) {
                    window.open(bf.attr("href"), "_new")
                }
            },
            mouseup: function() {
                aN(bc)
            }
        });
        a(bc.window).bind("blur", function() {
            var be = bc.textarea.value,
				bf = bc.encodedValue();
            bc.update(bf);
            if (bf != be) {
                b.trigger(bc.element, "change")
            }
        });
        a(bc.body).bind("cut paste", function(be) {
            bc.clipboard["on" + be.type](be)
        })
    }
    var aC = (function v(bi) {
        var bf = false,
			be = [],
			bd = {
			    fire: /(Silk)\/(\d+)\.(\d+(\.\d+)?)/,
			    android: /(Android)\s+(\d+)\.(\d+(\.\d+)?)/,
			    iphone: /(iPhone|iPod).*OS\s+(\d+)[\._]([\d\._]+)/,
			    ipad: /(iPad).*OS\s+(\d+)[\._]([\d_]+)/,
			    meego: /(MeeGo).+NokiaBrowser\/(\d+)\.([\d\._]+)/,
			    webos: /(webOS)\/(\d+)\.(\d+(\.\d+)?)/,
			    blackberry: /(BlackBerry|PlayBook).*?Version\/(\d+)\.(\d+(\.\d+)?)/
			},
			bg = {
			    ios: /^i(phone|pad|pod)$/i,
			    android: /^android|fire$/i
			},
			bh = function(bj) {
			    for (var bk in bg) {
			        if (bg.hasOwnProperty(bk) && bg[bk].test(bj)) {
			            return bk
			        }
			    }
			    return bj
			};
        for (var bc in bd) {
            if (bd.hasOwnProperty(bc)) {
                be = bi.match(bd[bc]);
                if (be) {
                    bf = {};
                    bf.device = bc;
                    bf.name = bh(bc);
                    bf[bf.name] = true;
                    bf.majorVersion = be[2];
                    bf.minorVersion = be[3].replace("_", ".");
                    break
                }
            }
        }
        return bf
    })(navigator.userAgent);
    var aY = !aC || (aC.ios && aC.majorVersion >= 5);
    b.editor = function(bg, bj) {
        if (!aY) {
            return
        }
        var bk = this;
        this.element = bg;
        var bc = a(bg);
        bc.closest("form").bind("submit", function() {
            bk.update()
        });
        a.extend(this, bj);
        b.bind(this, {
            load: this.onLoad,
            selectionChange: this.onSelectionChange,
            change: this.onChange,
            execute: this.onExecute,
            error: this.onError,
            paste: this.onPaste
        });
        for (var bi in this.tools) {
            this.tools[bi].name = bi.toLowerCase()
        }
        this.textarea = bc.find("textarea").attr("autocomplete", "off")[0];
        ab(this);
        this.keyboard = new an([new a2(this), new aZ(this)]);
        this.clipboard = new n(this);
        this.pendingFormats = new aG(this);
        this.undoRedoStack = new a3();

        function bm(bn) {
            var bo = a.grep(bn.className.split(" "), function(bp) {
                return !/^t-(widget|tool-icon|state-hover|header|combobox|dropdown|selectbox|colorpicker)$/i.test(bp)
            });
            return bo[0] ? bo[0].substring(2) : "custom"
        }
        function bd(bn, bo) {
            if (!bo.key) {
                return bn
            }
            return new b.stringBuilder().cat(bn).cat(" (").catIf("Ctrl + ", bo.ctrl).catIf("Shift + ", bo.shift).catIf("Alt + ", bo.alt).cat(bo.key).cat(")").string()
        }
        var bl = ".t-editor-toolbar > li > *",
			be = ".t-editor-button .t-tool-icon",
			bh = be + ":not(.t-state-disabled)",
			bf = be + ".t-state-disabled";
        bc.find(".t-combobox .t-input").keydown(function(bo) {
            var bn = a(this).closest(".t-combobox").data("tComboBox"),
				bp = bo.keyCode;
            if (bp == 39 || bp == 37) {
                bn.close()
            } else {
                if (bp == 40) {
                    if (!bn.dropDown.isOpened()) {
                        bo.stopImmediatePropagation();
                        bn.open()
                    }
                }
            }
        });
        bc.delegate(bh, "mouseenter", b.hover).delegate(bh, "mouseleave", b.leave).delegate(be, "mousedown", b.preventDefault).delegate(J, "keydown", function(bo) {
            var bn = a(this).closest("li"),
				bp = "li:has(" + J + ")",
				bq, br = bo.keyCode;
            if (br == 39) {
                bq = bn.nextAll(bp).first().find(J)
            } else {
                if (br == 37) {
                    bq = bn.prevAll(bp).last().find(J)
                } else {
                    if (br == 27) {
                        bq = bk
                    } else {
                        if (br == 9 && !(bo.ctrlKey || bo.altKey)) {
                            if (bo.shiftKey) {
                                bq = bn.prevAll(bp).last().find(J);
                                if (bq.length) {
                                    bo.preventDefault()
                                } else {
                                    return
                                }
                            } else {
                                bo.preventDefault();
                                bq = bn.nextAll(bp).first().find(J);
                                if (bq.length == 0) {
                                    bq = bk
                                }
                            }
                        }
                    }
                }
            }
            if (bq) {
                bq.focus()
            }
        }).delegate(bh, "click", b.stopAll(function(bn) {
            bk.exec(bm(this))
        })).delegate(bf, "click", function(bn) {
            bn.preventDefault()
        }).find(bl).each(function() {
            var br = bm(this),
				bq = bk.tools[br],
				bo = bk.localization[br],
				bn = a(this);
            if (!bq) {
                return
            }
            if (br == "fontSize" || br == "fontName") {
                var bp = bk.localization[br + "Inherit"] || aw[br + "Inherit"];
                bk[br][0].Text = bp;
                bn.find("input").val(bp).end().find("span.t-input").text(bp).end()
            }
            bq.init(bn, {
                title: bd(bo, bq),
                editor: bk
            })
        }).end().bind("selectionChange", function() {
            var bo = bk.getRange();
            var bn = a0(bo);
            if (!bn.length) {
                bn = [bo.startContainer]
            }
            bc.find(bl).each(function() {
                var bp = bk.tools[bm(this)];
                if (bp) {
                    bp.update(a(this), bn, bk.pendingFormats)
                }
            })
        });
        a(document).bind("DOMNodeInserted", function(bn) {
            if (a.contains(bn.target, bk.element) || bk.element == bn.target) {
                bk.textarea.value = bk.value();
                a(bk.element).find("iframe").remove();
                ab(bk)
            }
        }).bind("mousedown", function(bn) {
            try {
                if (bk.keyboard.typingInProgress()) {
                    bk.keyboard.endTyping(true)
                }
                if (!bk.selectionRestorePoint) {
                    bk.selectionRestorePoint = new aL(bk.getRange())
                }
            } catch (bn) {}
        });
        this.update()
    };

    function H(bd, bc) {
        var bf = bd.getRange(),
			bg = bf.startContainer;
        if (bg == bd.body.firstChild || !x.isBlock(bg) || (bg.childNodes.length > 0 && !(bg.childNodes.length == 1 && x.is(bg.firstChild, "br")))) {
            return
        }
        var be = bg.previousSibling;
        while (be && !x.isBlock(be)) {
            be = be.previousSibling
        }
        if (!be) {
            return
        }
        var bi = bd.document.createTreeWalker(be, NodeFilter.SHOW_TEXT, null, false);
        var bh;
        while (bh = bi.nextNode()) {
            be = bh
        }
        bf.setStart(be, am(be) ? be.nodeValue.length : 0);
        bf.collapse(true);
        aR(bf);
        x.remove(bg);
        bc.preventDefault()
    }
    a.extend(b.editor, {
        BlockFormatFinder: h,
        BlockFormatter: i,
        Dom: x,
        FormatCommand: O,
        GenericCommand: R,
        GreedyBlockFormatter: U,
        GreedyInlineFormatFinder: V,
        GreedyInlineFormatter: W,
        ImageCommand: X,
        IndentCommand: Z,
        IndentFormatter: aa,
        InlineFormatFinder: ae,
        InlineFormatter: af,
        InsertHtmlCommand: ai,
        Keyboard: an,
        LinkCommand: ao,
        LinkFormatFinder: ap,
        LinkFormatter: aq,
        ListCommand: ar,
        ListFormatFinder: at,
        ListFormatter: au,
        MSWordFormatCleaner: az,
        Marker: ay,
        NewLineCommand: aA,
        OutdentCommand: aD,
        ParagraphCommand: aF,
        PendingFormats: aG,
        RangeEnumerator: aI,
        RangeUtils: aK,
        RestorePoint: aL,
        SystemHandler: aZ,
        TypingHandler: a2,
        ViewHtmlCommand: a7,
        UndoRedoStack: a3,
        UnlinkCommand: a4
    });
    b.editor.prototype = {
        value: function(bd) {
            var bc = this.body;
            if (typeof bd == "undefined") {
                return y(bc)
            }
            this.pendingFormats.clear();
            bd = bd.replace(/<!\[CDATA\[(.*)?\]\]>/g, "<!--[CDATA[$1]]-->");
            bd = bd.replace(/<script([^>]*)>(.*)?<\/script>/ig, "<easyui:script $1>$2</easyui:script>");
            if (a.browser.mozilla) {
                bd = bd.replace(/<p([^>]*)>(\s*)?<\/p>/ig, '<p $1><br _moz_dirty="" /></p>')
            }
            if (a.browser.msie && parseInt(a.browser.version) < 9) {
                bd = "<br/>" + bd;
                var bf = "originalsrc",
					be = "originalhref";
                bd = bd.replace(/href\s*=\s*(?:'|")?([^'">\s]*)(?:'|")?/, be + '="$1"');
                bd = bd.replace(/src\s*=\s*(?:'|")?([^'">\s]*)(?:'|")?/, bf + '="$1"');
                bc.innerHTML = bd;
                x.remove(bc.firstChild);
                a(bc).find("easyui\\:script,script,link,img,a").each(function() {
                    var bg = this;
                    if (bg[be]) {
                        bg.setAttribute("href", bg[be]);
                        bg.removeAttribute(be)
                    }
                    if (bg[bf]) {
                        bg.setAttribute("src", bg[bf]);
                        bg.removeAttribute(bf)
                    }
                })
            } else {
                bc.innerHTML = bd;
                if (a.browser.msie) {
                    aB(bc)
                }
            }
            this.selectionRestorePoint = null;
            this.update()
        },
        focus: function() {
            this.window.focus()
        },
        update: function(bc) {
            this.textarea.value = bc || this.encoded ? this.encodedValue() : this.value()
        },
        encodedValue: function() {
            return x.encode(this.value())
        },
        createRange: function(bc) {
            return s(bc || this.document)
        },
        getSelection: function() {
            return aO(this.document)
        },
        selectRange: function(bc) {
            this.focus();
            var bd = this.getSelection();
            bd.removeAllRanges();
            bd.addRange(bc)
        },
        getRange: function() {
            var bd = this.getSelection();
            var bc = bd.rangeCount > 0 ? bd.getRangeAt(0) : this.createRange();
            if (bc.startContainer == this.document && bc.endContainer == this.document && bc.startOffset == 0 && bc.endOffset == 0) {
                bc.setStart(this.body, 0);
                bc.collapse(true)
            }
            return bc
        },
        selectedHtml: function() {
            return y(this.getRange().cloneContents())
        },
        paste: function(bc) {
            this.clipboard.paste(bc)
        },
        exec: function(bf, bg) {
            var bh, bc, be, bi = "";
            bf = bf.toLowerCase();
            if (!this.keyboard.typingInProgress()) {
                this.focus();
                bh = this.getRange();
                bc = this.document.body
            }
            for (be in this.tools) {
                if (be.toLowerCase() == bf) {
                    bi = this.tools[be];
                    break
                }
            }
            if (bi) {
                bh = this.getRange();
                if (!/undo|redo/i.test(bf) && bi.willDelayExecution(bh)) {
                    this.pendingFormats.toggle({
                        name: bf,
                        params: bg,
                        command: bi.command
                    });
                    aN(this);
                    return
                }
                var bd = bi.command ? bi.command(a.extend({
                    range: bh
                }, bg)) : null;
                b.trigger(this.element, "execute", {
                    name: bf,
                    command: bd
                });
                if (/undo|redo/i.test(bf)) {
                    this.undoRedoStack[bf]()
                } else {
                    if (bd) {
                        if (!bd.managesUndoRedo) {
                            this.undoRedoStack.push(bd)
                        }
                        bd.editor = this;
                        bd.exec();
                        if (bd.async) {
                            bd.change = a.proxy(function() {
                                aN(this)
                            }, this);
                            return
                        }
                    }
                }
                aN(this)
            }
        }
    };
    a.fn.tEditor = function(bc) {
        return b.create(this, {
            name: "tEditor",
            init: function(bd, be) {
                return new b.editor(bd, be)
            },
            options: bc
        })
    };
    var P = {
        bold: [{
            tags: ["strong"]
        }, {
            tags: ["span"],
            attr: {
                style: {
                    fontWeight: "bold"
                }
            }
        }],
        italic: [{
            tags: ["em"]
        }, {
            tags: ["span"],
            attr: {
                style: {
                    fontStyle: "italic"
                }
            }
        }],
        underline: [{
            tags: ["span"],
            attr: {
                style: {
                    textDecoration: "underline"
                }
            }
        }],
        strikethrough: [{
            tags: ["del"]
        }, {
            tags: ["span"],
            attr: {
                style: {
                    textDecoration: "line-through"
                }
            }
        }],
        superscript: [{
            tags: ["sup"]
        }],
        subscript: [{
            tags: ["sub"]
        }],
        justifyLeft: [{
            tags: g,
            attr: {
                style: {
                    textAlign: "left"
                }
            }
        }, {
            tags: ["img"],
            attr: {
                style: {
                    "float": "left"
                }
            }
        }],
        justifyCenter: [{
            tags: g,
            attr: {
                style: {
                    textAlign: "center"
                }
            }
        }, {
            tags: ["img"],
            attr: {
                style: {
                    display: "block",
                    marginLeft: "auto",
                    marginRight: "auto"
                }
            }
        }],
        justifyRight: [{
            tags: g,
            attr: {
                style: {
                    textAlign: "right"
                }
            }
        }, {
            tags: ["img"],
            attr: {
                style: {
                    "float": "right"
                }
            }
        }],
        justifyFull: [{
            tags: g,
            attr: {
                style: {
                    textAlign: "justify"
                }
            }
        }]
    };

    function N(be, bc) {
        for (var bd = 0; bd < bc.length; bd++) {
            if (a.inArray(be, bc[bd].tags) >= 0) {
                return bc[bd]
            }
        }
    }
    function a1(bc) {
        a.extend(this, bc);
        this.init = function(bd, be) {
            bd.attr({
                unselectable: "on",
                title: be.title
            })
        };
        this.command = function(bd) {
            return new bc.command(bd)
        };
        this.update = function() {};
        this.willDelayExecution = function() {
            return false
        }
    }
    a1.exec = function(bc, bd, be) {
        bc.exec(bd, {
            value: be
        })
    };

    function Q(bc) {
        a1.call(this, bc);
        this.command = function(bd) {
            return new O(a.extend(bd, {
                formatter: bc.formatter
            }))
        };
        this.update = function(bd, bh, bi) {
            var bg = bi.isPending(this.name),
				bf = bc.finder.isFormatted(bh),
				be = bg ? !bf : bf;
            bd.toggleClass("t-state-active", be)
        }
    }
    var A = function() {
        return {
            isFormatted: function() {
                return false
            }
        }
    };
    var aw = {
        bold: "Bold",
        italic: "Italic",
        underline: "Underline",
        strikethrough: "Strikethrough",
        superscript: "Superscript",
        subscript: "Subscript",
        justifyCenter: "Center text",
        justifyLeft: "Align text left",
        justifyRight: "Align text right",
        justifyFull: "Justify",
        insertUnorderedList: "Insert unordered list",
        insertOrderedList: "Insert ordered list",
        indent: "Indent",
        outdent: "Outdent",
        createLink: "Insert hyperlink",
        unlink: "Remove hyperlink",
        insertImage: "Insert image",
        insertHtml: "Insert HTML",
        fontName: "Select font family",
        fontNameInherit: "(inherited font)",
        fontSize: "Select font size",
        fontSizeInherit: "(inherited size)",
        formatBlock: "Format",
        viewHtml: "View HTML",
        style: "Styles",
        emptyFolder: "Empty Folder",
        uploadFile: "Upload",
        orderBy: "Arrange by:",
        orderBySize: "Size",
        orderByName: "Name",
        invalidFileType: 'The selected file "{0}" is not valid. Supported file types are {1}.',
        deleteFile: 'Are you sure you want to delete "{0}"?',
        overwriteFile: 'A file with name "{0}" already exists in the current directory. Do you want to overwrite it?',
        directoryNotFound: "A directory with this name was not found.",
        webAddress: "Web address",
        tooltip: "Tooltip",
        openInNewWindow: "Open link in new window",
        insert: "Insert",
        or: "or",
        close: "Close"
    };
    a.fn.tEditor.defaults = {
        localization: aw,
        formats: P,
        encoded: true,
        stylesheets: [],
        dialogOptions: {
            modal: true,
            resizable: false,
            draggable: true,
            effects: {
                list: [{
                    name: "toggle"
                }]
            }
        },
        fontName: [{
            Text: aw.fontNameInherit,
            Value: "inherit"
        }, {
            Text: "Arial",
            Value: "Arial,Helvetica,sans-serif"
        }, {
            Text: "Courier New",
            Value: "'Courier New',Courier,monospace"
        }, {
            Text: "Georgia",
            Value: "Georgia,serif"
        }, {
            Text: "Impact",
            Value: "Impact,Charcoal,sans-serif"
        }, {
            Text: "Lucida Console",
            Value: "'Lucida Console',Monaco,monospace"
        }, {
            Text: "Tahoma",
            Value: "Tahoma,Geneva,sans-serif"
        }, {
            Text: "Times New Roman",
            Value: "'Times New Roman',Times,serif"
        }, {
            Text: "Trebuchet MS",
            Value: "'Trebuchet MS',Helvetica,sans-serif"
        }, {
            Text: "Verdana",
            Value: "Verdana,Geneva,sans-serif"
        }],
        fontSize: [{
            Text: aw.fontSizeInherit,
            Value: "inherit"
        }, {
            Text: "1 (8pt)",
            Value: "xx-small"
        }, {
            Text: "2 (10pt)",
            Value: "x-small"
        }, {
            Text: "3 (12pt)",
            Value: "small"
        }, {
            Text: "4 (14pt)",
            Value: "medium"
        }, {
            Text: "5 (18pt)",
            Value: "large"
        }, {
            Text: "6 (24pt)",
            Value: "x-large"
        }, {
            Text: "7 (36pt)",
            Value: "xx-large"
        }],
        formatBlock: [{
            Text: "Paragraph",
            Value: "p"
        }, {
            Text: "Quotation",
            Value: "blockquote"
        }, {
            Text: "Heading 1",
            Value: "h1"
        }, {
            Text: "Heading 2",
            Value: "h2"
        }, {
            Text: "Heading 3",
            Value: "h3"
        }, {
            Text: "Heading 4",
            Value: "h4"
        }, {
            Text: "Heading 5",
            Value: "h5"
        }, {
            Text: "Heading 6",
            Value: "h6"
        }],
        tools: {
            bold: new ag({
                key: "B",
                ctrl: true,
                format: P.bold
            }),
            italic: new ag({
                key: "I",
                ctrl: true,
                format: P.italic
            }),
            underline: new ag({
                key: "U",
                ctrl: true,
                format: P.underline
            }),
            strikethrough: new ag({
                format: P.strikethrough
            }),
            superscript: new ag({
                format: P.superscript
            }),
            subscript: new ag({
                format: P.subscript
            }),
            undo: {
                key: "Z",
                ctrl: true
            },
            redo: {
                key: "Y",
                ctrl: true
            },
            insertLineBreak: new a1({
                key: 13,
                shift: true,
                command: aA
            }),
            insertParagraph: new a1({
                key: 13,
                command: aF
            }),
            justifyCenter: new j({
                format: P.justifyCenter
            }),
            justifyLeft: new j({
                format: P.justifyLeft
            }),
            justifyRight: new j({
                format: P.justifyRight
            }),
            justifyFull: new j({
                format: P.justifyFull
            }),
            insertUnorderedList: new av({
                tag: "ul"
            }),
            insertOrderedList: new av({
                tag: "ol"
            }),
            createLink: new a1({
                key: "K",
                ctrl: true,
                command: ao
            }),
            unlink: new a5({
                key: "K",
                ctrl: true,
                shift: true
            }),
            insertImage: new a1({
                command: X
            }),
            indent: new a1({
                command: Z
            }),
            outdent: new aE(),
            insertHtml: new aj(),
            style: new aX(),
            fontName: new L({
                cssAttr: "font-family",
                domAttr: "fontFamily",
                name: "fontName"
            }),
            fontSize: new L({
                cssAttr: "font-size",
                domAttr: "fontSize",
                name: "fontSize"
            }),
            formatBlock: new M(),
            foreColor: new o({
                cssAttr: "color",
                domAttr: "color",
                name: "foreColor"
            }),
            backColor: new o({
                cssAttr: "background-color",
                domAttr: "backgroundColor",
                name: "backColor"
            }),
            viewHtml: new a1({
                command: a7
            })
        }
    }
})(jQuery);