<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<EasyUI.Web.Mvc.JavaScriptTests.Customer>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    
    <%= Html.EasyUI().Editor().Name("Editor") %>

    <script type="text/javascript" src="<%= Url.Content("~/Scripts/editorTestHelper.js") %>"></script>

</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

    <script type="text/javascript">

        var editor;

        module("Editor / Serialization", {
            setup: function() {
                editor = getEditor();
            }
        });

        test('value reciprocity', function() {
            editor.value("<p>and now, for something completely different</p>");

            equal(editor.value(), "<p>and now, for something completely different</p>");
        });
        
        test('closes empty tags', function() {
            editor.value('<hr>');
            equal(editor.value(), '<hr />');
        });

        test('converts to lower case', function() {
            editor.value('<hr>');
            equal(editor.value(), '<hr />');
        });

        test('converts mixed case to lower case', function() {
            editor.value('<hr>');
            equal(editor.value(), '<hr />');
        });

        test('returns child tags', function() {
            editor.value('<div><span></div>');
            equal(editor.value(), '<div><span></span></div>');
        });
        
        test('returns root text nodes', function() {
            editor.value('test');
            equal(editor.value(), 'test');
        });
        
        test('returns child text nodes', function() {
            editor.value('<span>test</span>');
            equal(editor.value(), '<span>test</span>');
        });

        test('fills attributes', function() {
            editor.value('<input type=hidden>');
            equal(editor.value(), '<input type="hidden" />');
        });

        test('expands attributes', function() {
            editor.value('<hr disabled>');
            equal(editor.value(), '<hr disabled="disabled" />');
        });

        test('fills custom attributes', function() {
            editor.value('<hr test="test">');
            equal(editor.value(), '<hr test="test" />');
        });

        test('caps attributes', function() {
            editor.value('<hr CLASS="test">');
            equal(editor.value(), '<hr class="test" />');
        });

        test('attributes containing dashes', function() {
            editor.value('<hr class=t-input />');
            equal(editor.value(), '<hr class="t-input" />');
        });

        test('adds closing tag', function() {
            editor.value('<strong>');
            equal(editor.value(), '<strong></strong>');
        });

        test('fixes improperly nested inline tags', function() {
            editor.value('<strong><span></strong></span>');
            equal(editor.value(), '<strong><span></span></strong>');
        });
        
        test('fixes improperly nested inline and block tags', function() {
//How to fix this without string parsing ???
//            editor.value('<strong><div></strong></div>');
//            equal(editor.value(), '<strong></strong><div></div>');
        });

        test('handles style attribute values', function() {
            editor.value('<div style="text-align:left"></div>');
            
            equal(editor.value(), '<div style="text-align:left;"></div>');
        });

        test('handles style color values', function() {
            editor.value('<div style="color:#000000"></div>');
            equal(editor.value(), '<div style="color:#000000;"></div>');
        });

        test('comments', function() {
            editor.value('<!-- comment -->');
            equal(editor.value(), '<!-- comment -->');
        });
        
        test('cdata encoding', function() {
            editor.value('<![CDATA[test]]>');
            ok(editor.body.innerHTML.indexOf('<!--[CDATA[test]]-->') > -1);
        });

        test('cdata', function() {
            editor.value('<![CDATA[test]]>');
            equal(editor.value(), '<![CDATA[test]]>');
        });

        test('b converted to strong', function() {
            editor.value('<b></b>');
            equal(editor.value(), '<strong></strong>');
        });

        test('i converted to em', function() {
            editor.value('<i></i>');
            equal(editor.value(), '<em></em>');
        });
        
        test('u converted to span with underline style', function() {
            editor.value('<u></u>');
            equal(editor.value(), '<span style="text-decoration:underline;"></span>');
        });

        test('font converted to span', function() {
            editor.value('<font color="#ff0000" face="verdana" size="5">foo</font>');
            equal(editor.value(), '<span style="color:#ff0000;font-face:verdana;font-size:x-large;">foo</span>');
        });

        test('script tag preserved', function() {
            editor.value('<script>var answer=42;<\/script>');
            equal(editor.value(), '<script>var answer=42;<\/script>');
        });
        
        test('script tag not executed', function() {
            editor.value('<script>var answer=42;<\/script>');
            ok(undefined === window.answer);
        });

        test('br moz dirty removed', function() {
            editor.value('<br _moz_dirty="">');
            equal(editor.value(), '');
        });
        
        test('moz dirty removed', function() {
            editor.value('<hr _moz_dirty="">');
            equal(editor.value(), '<hr />');
        });

        test('multiple attributes sorted alphabetically', function() {
            editor.value('<input type="button" class="t-button" style="display:none;" />');
            equal(editor.value(), '<input class="t-button" style="display:none;" type="button" />');
        });

        test('javascript attributes', function() {
            editor.value('<input type="button" onclick="alert(1)" />');
            equal(editor.value(), '<input onclick="alert(1)" type="button" />');
        });

        test('value attribute', function() {
            editor.value('<input type="button" value="test" />');
            equal(editor.value(), '<input type="button" value="test" />');
        });

        test('type text attribute', function() {
            editor.value('<input type="text" value="test" />');
            equal(editor.value(), '<input type="text" value="test" />');
        });
        
        test('style ending with whitespace', function() {
            editor.value('<hr style="display:none; " />');
            equal(editor.value(), '<hr style="display:none;" />');
        });

        test('a href is not made absolute', function() {
            editor.value('<a href="foo">a</a>');
            equal(editor.value(), '<a href="foo">a</a>');
        });
        
        test('link href is not made absolute', function() {
            editor.value('<link href="foo" />');
            equal(editor.value(), '<link href="foo" />');
        });
        
        test('img src is not made absolute', function() {
            editor.value('<img src="foo" />');
            equal(editor.value(), '<img src="foo" />');
        });
        test('script src is not made absolute', function() {
            editor.value('<script src="foo"><\/script>');
            equal(editor.value(), '<script src="foo"><\/script>');
        });

        test('href without quotes', function() {
            editor.value('<a href=foo>a</a>');
            equal(editor.value(), '<a href="foo">a</a>');
        });
        
        test('href without quotes and with whitespace', function() {
            editor.value('<a href= foo >a</a>');
            equal(editor.value(), '<a href="foo">a</a>');
        });
        
        test('href without quotes and whith other attrubutes', function() {
            editor.value('<a href= foo class=test>a</a>');
            equal(editor.value(), '<a class="test" href="foo">a</a>');
        });

        test('href with single quotes', function() {
            editor.value('<a href=\'foo\'>a</a>');
            equal(editor.value(), '<a href="foo">a</a>');
        });
        
        test('href with hash', function() {
            editor.value('<a href="#hash">a</a>');
            equal(editor.value(), '<a href="#hash">a</a>');
        });
        
        test('href with absolute', function() {
            editor.value('<a href="http://www.example.com">a</a>');
            equal(editor.value(), '<a href="http://www.example.com">a</a>');
        });

        test('href with absolute and url content', function() {
            editor.value('<a href="http://www.example.com">www.example.com</a>');
            equal(editor.value(), '<a href="http://www.example.com">www.example.com</a>');
        });

        test('attributes starting with underscore moz are removed', function() {
            editor.value('<hr _moz_resizing="true" />');
            equal(editor.value(), '<hr />');
        });

        test('empty whitespace whitespace trimmed', function() {
            editor.value('<hr />      ');
            equal(editor.value(), '<hr />');
        });

        test('whitespace empty whitespace trimmed', function() {
            editor.value('           <hr />');
            equal(editor.value(), '<hr />');
        });
        
        test('whitespace empty inline whitespace trimmed', function() {
            editor.value('           <a></a>');
            equal(editor.value(), '<a></a>');
        });

        test('whitespace inline whitespace trimmed', function() {
            editor.value('           <a>foo</a>');
            equal(editor.value(), '<a>foo</a>');
        });

        test('empty inline whitespace whitespace trimmed', function() {
            editor.value('<a></a>     ');
            equal(editor.value(), '<a></a>');
        });

        test('inline whitespace whitespace collapsed', function() {
            editor.value('<a>foo</a>     ');
            equal(editor.value(), '<a>foo</a> ');
        });
        
        test('whitespace empty block whitespace trimmed', function() {
            editor.value('           <div></div>');
            equal(editor.value(), '<div></div>');
        });
        
        test('whitespace block whitespace trimmed', function() {
            editor.value('           <div>foo</div>');
            equal(editor.value(), '<div>foo</div>');
        });

        test('empty block whitespace whitespace trimmed', function() {
            editor.value('<div></div>     ');
            equal(editor.value(), '<div></div>');
        });

        test('block whitespace whitespace trimmed', function() {
            editor.value('<div>foo</div>     ');
            equal(editor.value(), '<div>foo</div>');
        });

        test('trimming whitespace within content', function() {
            editor.value('<span>foo   bar</span>');
            equal(editor.value(), '<span>foo bar</span>');
        });

        test('keeping white space in pre', function() {
            editor.value('<pre>foo   bar</pre>');
            equal(editor.value(), '<pre>foo   bar</pre>');
        });
        
        test('keeping white space in pre children', function() {
            editor.value('<pre><span>   foo  </span></pre>');
            equal(editor.value(), '<pre><span>   foo  </span></pre>');
        });

        test('text whitespace inline whitespace collapsed', function() {
            editor.value('foo  <strong>bar</strong>');
            equal(editor.value(), 'foo <strong>bar</strong>');
        });

        test('text whitespace block whitespace preserved', function() {
            editor.value('foo <div>bar</div>');
            equal(editor.value(), 'foo <div>bar</div>');
        });

        test('text whitespace empty element whitespace preserved', function() {
            editor.value('foo <hr />');
            equal(editor.value(), 'foo <hr />');
        });

        test('empty element whitespace text whitespace trimmed', function() {
            editor.value('<hr /> foo');
            equal(editor.value(), '<hr />foo');
        });

        test('whitespace at end of inline element preserved', function() {
            editor.value('<strong>foo </strong>');
            equal(editor.value(), '<strong>foo </strong>');
        });

        test('whitespace at beginning of inline element after text', function() {
            editor.value('foo bar<strong> baz</strong>');
            equal(editor.value(), 'foo bar<strong> baz</strong>');
        });          
        
        test('whitespace at end of inline element after text', function() {
            editor.value('foo bar<strong>baz </strong>');
            equal(editor.value(), 'foo bar<strong>baz </strong>');
        });        
        
        test('whitespace at end of inline element', function() {
            editor.value('<strong>baz </strong>');
            equal(editor.value(), '<strong>baz </strong>');
        });         
        
        test('whitespace at beginning of inline element', function() {
            editor.value('<strong> baz</strong>');
            equal(editor.value(), '<strong>baz</strong>');
        });        
        
        test('whitespace at beginning of inline element before text', function() {
            editor.value('<span>boo <span style="color:red;">foo</span> bar</span>');
            equal(editor.value(), '<span>boo <span style="color:red;">foo</span> bar</span>');
        });

        test('whitespace after inline element is preserved', function() {
            editor.value('<p><strong>foo</strong> bar</p>');
            equal(editor.value(), '<p><strong>foo</strong> bar</p>');

        });

        test('complete attribute ignored', function() {
            editor.value('<img complete="complete" />');
            equal(editor.value(), '<img />');
        });

        test('image discards redundant height', function() {
            editor.value('<img height="2" style="height:2px;" />');
            equal(editor.value(), '<img height="2" />');
        });

        test('image migrates height from style', function() {
            editor.value('<img style="height:4px;" />');
            equal(editor.value(), '<img height="4" />');
        });

        test('image discards redundant width', function() {
            editor.value('<img width="2" style="width:2px;" />');
            equal(editor.value(), '<img width="2" />');
        });

        test('image migrates width from style', function() {
            editor.value('<img style="width:4px;" />');
            equal(editor.value(), '<img width="4" />');
        });
        
        test('nbsp', function() {
            editor.value('&nbsp;&nbsp;&nbsp;');
            equal(editor.value(), '&nbsp;&nbsp;&nbsp;');
        });

        test('nbsp and whitespace', function() {
            editor.value('            &nbsp;&nbsp;&nbsp;');
            equal(editor.value(), '&nbsp;&nbsp;&nbsp;');
        });
        test('amp', function() {
            editor.value('&amp;');
            equal(editor.value(), '&amp;');
        });
        
        test('lt', function() {
            editor.value('&lt;');
            equal(editor.value(), '&lt;');
        });
        
        test('gt', function() {
            editor.value('&gt;');
            equal(editor.value(), '&gt;');
        });

        test('amp escaped', function() {
            editor.value('&amp;');
            equal(editor.encodedValue(), '&amp;amp;');
        });

        test('gt escaped', function() {
            editor.value('&gt;');
            equal(editor.encodedValue(), '&amp;gt;');
        });

        test('nbsp escaped', function() {
            editor.value('&nbsp;');
            equal(editor.encodedValue(), '&amp;nbsp;');
        });

        test('setting empty paragraphs adds line breaks in mozilla', function() {
            editor.value('<p> </p>');

            if ($.browser.mozilla) {
                equals(editor.body.firstChild.childNodes.length, 1);
                equals(editor.body.firstChild.firstChild.nodeName.toLowerCase(), 'br');
            }
        });

        test('setting value removes pending formats', function() {
            editor.value('foo');

            editor.pendingFormats.toggle({ format: editor.formats.bold, values: undefined });

            ok(editor.pendingFormats.hasPending());

            editor.value('bar');

            ok(!editor.pendingFormats.hasPending());
        });

        test("single quotes in style attribute", function() {
            editor.value('<span style="font-family:\'Verdana\';">foo</span>');
            equal(editor.value(), '<span style="font-family:\'Verdana\';">foo</span>');
        });

        test('single brs are considered no value (to enable required field validation)', function() {
            editor.value('<br>');
            equal(editor.value(), '');
        });

        test('single empty paragraph is considered no value (to enable required field validation)', function() {
            editor.value('<p></p>');
            equal(editor.value(), '');
        });

        test('strips font-size-adjust and font-stretch properties', function() {
            editor.value('<span style="font:12px/normal Verdana;">foo</span>');
            equal(editor.value(), '<span style="font:12px/normal Verdana;">foo</span>');
        });

        test('reversing quotes in style attribute', function() {
            editor.body.innerHTML = '<span style=\'font:12px/normal "Times New Roman";\'>foo</span>';
            equal(editor.value(), '<span style="font:12px/normal \'Times New Roman\';">foo</span>');
        });

    </script>

</asp:Content>