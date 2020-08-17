(function(a){var b=a.telerik;b.scripts.push("telerik.autocomplete.js");b.autocomplete=function(d,f){a.extend(this,f);var c=this.$element=a(d).addClass("t-widget t-autocomplete t-input").attr("autocomplete","off").bind("paste",a.proxy(function(i){g(this)},this));this.$text=c;this.element=d;this.trigger=new b.list.trigger(this);this.trigger.change=function(){var j=this.component.text();var i=this.component.previousValue;if(i==undefined||j!=i){b.trigger(this.component.element,"valueChange",{value:j})}this.component.previousValue=j};this.loader=new b.list.loader(this);this.loader.showBusy=function(){this.busyTimeout=setTimeout(a.proxy(function(){this.component.$element.addClass("t-loading")},this),100)};this.loader.hideBusy=function(){clearTimeout(this.busyTimeout);this.component.$element.removeClass("t-loading")};this.filtering=new b.list.filtering(this);this.filtering.autoFill=function(i,m){if(i.autoFill&&(i.lastKeyCode!=8&&i.lastKeyCode!=46)){var l=i.$text[0],u=l.value,q=i.separator,j=b.caretPos(l),p=i.multiple;var n=p&&q?b.lastIndexOf(u.substring(0,j),q):-1;var s=n!=-1?n+q.length:0;var k=u.substring(s,j);var o=m.toLowerCase().indexOf(k.toLowerCase());if(o!=-1){var t=m.substring(o+k.length);if(p){var r=u.split(q),v=h(l,q);r[v]=k+t;l.value=r.join(q)+(i.multiple&&v!=0&&v==r.length-1?q:"")}else{l.value=k+t}b.list.selection(l,j,j+t.length)}}};this.enable=function(){c.removeClass("t-state-disabled").removeAttr("disabled")};this.disable=function(){c.addClass("t-state-disabled").attr("disabled","disabled")};this.filtering.multiple=a.proxy(function(i){if(this.multiple){i=i.split(this.separator);i=i[h(this.$text[0],this.separator)]}return i},this);this.dropDown=new b.dropDown({attr:this.dropDownAttr,effects:this.effects,onClick:a.proxy(function(i){this.select(i.item);this.trigger.change();this.trigger.close()},this)});this.dropDown.$element.css("direction",c.closest(".t-rtl").length?"rtl":"");this.fill=function(i){function k(r){var q=r.highlightFirst?j.$items.first():null;if(q){q.addClass("t-state-selected")}}var l=this.loader;var j=this.dropDown;var m=this.minChars;var o=this.text();var p=o.length;if(!j.$items&&!l.ajaxError){if((l.isAjax()||this.onDataBinding)&&p>=m){var n={};n[this.queryString.text]=o;l.ajaxRequest(function(q){this.dataBind(q,true);k(this);b.trigger(this.element,"dataBound");this.trigger.change();if(i){i()}},{data:n})}else{this.dataBind(this.data,true);k(this);if(i){i()}}}};this.text=function(){if(arguments.length>0){this.previousValue=arguments[0]}return this.$text.val.apply(this.$text,arguments)};this.value=function(){return this.text.apply(this,arguments)};this.select=function(m){var l=this.highlight(m);if(l==-1){return l}var k=this.filteredDataIndexes;var n=(k&&k.length)>0?k[l]:l;var m=this.data[n];var j=m.Text?m.Text:m;var p=j;if(this.multiple){var i=this.$element;var o=this.separator;var q=h(i[0],o);p=i.val().split(o);p[q]=j;p=p.join(o)+(q==p.length-1?o:"")}this.$text.val(p)};b.list.common.call(this);b.list.filters.call(this);b.list.initialize.call(this);this.dataBind=function(i,j){this.data=i=(i||[]);this.dropDown.dataBind(i,this.encoded);if(!j){this.$text.val("")}};c.bind({focus:a.proxy(function(i){i.stopPropagation()},this),keydown:a.proxy(e,this),keypress:a.proxy(function(i){var j=i.keyCode||i.charCode;if(j==0||a.inArray(j,b.list.keycodes)!=-1||i.ctrlKey){return true}},this)});a(document.documentElement).bind("mousedown",a.proxy(function(j){var i=this.dropDown.$element.parent();var k=i.length;if((!k&&d!==j.target)||(k&&!a.contains(d,j.target)&&!a.contains(i[0],j.target))){this.trigger.change();this.trigger.close()}},this));function h(i,j){return i.value.substring(0,b.caretPos(i)).split(j).length-1}function g(i){clearTimeout(i.timeout);i.timeout=setTimeout(function(){i.filtering.filter(i)},i.delay)}function e(o){var t=this.trigger;var n=this.dropDown;var q=o.keyCode||o.which;this.lastKeyCode=q;if(!o.shiftKey&&q>36&&q<41&&q!=37&&q!=39){o.preventDefault();if(n.isOpened()){if(!n.$items){this.fill()}var k=n.$items;var l=k.filter(".t-state-selected:first");var j=[];if(q==38){var s=l.prev();j=s.length?s:k.last()}else{if(q==40){var r=l.next();j=r.length?r:k.first()}}if(j.length){var p=j[0];this.highlight(p);n.scrollTo(p);this.filtering.autoFill(this,j.text())}}return}if(q==8||q==46){var i=this.$element;if(i.val()!=""){g(this)}setTimeout(a.proxy(function(){if(i.val()==""){t.close()}},this),0);return}if(q==13){if(n.isOpened()){o.preventDefault()}if(n.$items){var m=n.$items.filter(".t-state-selected:first");if(m.length>0){this.select(m[0])}}t.change();t.close();b.list.moveToEnd(this.element);return}if(q==27||q==9){clearTimeout(this.timeout);t.change();t.close();return}g(this)}};a.fn.tAutoComplete=function(c){return b.create(this,{name:"tAutoComplete",init:function(d,e){return new b.autocomplete(d,e)},options:c})};a.fn.tAutoComplete.defaults={encoded:true,effects:b.fx.slide.defaults(),filter:1,delay:200,minChars:1,cache:true,autoFill:false,highlightFirst:false,queryString:{text:"text"},multiple:false,separator:", "}})(jQuery);