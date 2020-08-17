﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <%= Html.EasyUI().Editor().Name("Editor") %>
</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

    <script type="text/javascript">

        var cleaner;
    
        function clean(html) {
           var value = cleaner.clean(html);
           return value.replace(/(<\/?[^>]*>)/g, function (_, tag) {
            return tag.toLowerCase();
           }).replace(/[\r\n]+/g, '');
        }

        

        module("Editor / MSWordFormatCleaner", {
            setup: function() {
                cleaner = new $.easyui.editor.MSWordFormatCleaner();
            }
        });
    
        test('cleaning meta tags', function() {
            equal(clean('<meta content="text/html"><meta content="Word.Document">'), '');
        });

        test('cleaning link tags', function() {
            equal(clean('<link href="file://clip_filelist.xml"><link rel="colorSchemeMapping"></link>'), '');
        });

        test('cleaning style tags', function() {
            equal(clean('<style>foo<\/style>'), '');
        });
    
        test('cleaning invalid tag contents style tags', function() {
            equal(clean('<style>foo<\/style>'), '');
        });
    
        test('ordered list', function() {
            equal(clean('<p class="MsoListParagraphCxSpFirst" style="text-indent: -0.25in;"><!--[if !supportLists]--><span style=""><span style="">1.<span style="font: 7pt &quot;Times New Roman&quot;;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></span></span><!--[endif]-->foo</p>'), '<ol><li>foo</li></ol>');
        });

        test('strip comments', function() {
            equal(clean('<!--[if gte mso 9]>\n<xml>foo</xml><![endif]--><!--[if gte mso 9]><xml>foo</xml><![endif]-->'), '');
        });
    
        test('strip comments regardles of version', function() {
            equal(clean('<!--[if gte mso 10]>\n<xml>foo</xml><![endif]--><!--[if gte mso 49]><xml>foo</xml><![endif]-->'), '');
        });

        test('unordered list', function() {
            equal(clean('<p class="MsoListParagraphCxSpFirst" style="text-indent: -0.25in;"><span style="font-family: Symbol;"><span style="">o<span style="font: 7pt &quot;Times New Roman&quot;;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></span></span>foo</p>'), '<ul><li>foo</li></ul>');
        });
    
        test('class removed', function() {
            equal(clean('<p class="foo">foo</p>'), '<p>foo</p>');
        });

        test('class without quote removed', function() {
            equal(clean('<p class=MsoTest>foo</p>'), '<p>foo</p>');
        });
    
        test('class without quote and with other attributes removed', function() {
            equal(clean('<p class=MsoTest id="foo-bar">foo</p>').indexOf('MsoTest'), -1);
        });

        test('remove o namespace', function() {
            equal(clean('<o:p>foo</o:p>'), '');
        });

        test('remove v namespace', function() {
            equal(clean('<v:p>foo</v:p>'), '');
        });

        test('remove mso style attributes', function() {
            equal(clean('<p style="mso-fareast-font:Symbol;color:red;">foo</p>').indexOf('mso'), -1);
        });
    
        test('opening list when there is no comment', function() {
            equal(clean('<p style="text-indent: -0.25in;" class="MsoListParagraphCxSpFirst"><span style="font-family: Symbol;"><span style="">o<span style="font: 7pt &quot;Times New Roman&quot;;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></span></span>foo</p>'), '<ul><li>foo</li></ul>');
        });

        test('comments removed', function() {
            equal(clean('<!--[if gte vml 1]>foo<![endif]-->'), '');
        });

        test('nested lists with fractional margin', function() {
            equal(clean('<p class="MsoListParagraphCxSpFirst" style="text-indent: -0.25in;"><span style=""><span style="">1.<span style="font: 7pt &quot;Times New Roman&quot;;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></span></span>One</p><p class="MsoListParagraphCxSpFirst" style="margin-left: 0.75in; text-indent: -0.25in;"><span style=""><span style="">1.<span style="font: 7pt &quot;Times New Roman&quot;;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></span></span>Two</p>'), '<ol><li>One<ol><li>Two</li></ol></li></ol>');
        });

        test('nested list with more than one root node', function() {
            equal(clean('<p class="MsoListParagraphCxSpFirst" style="text-indent: -0.25in;"><span style=""><span style="">1.<span style="font: 7pt &quot;Times New Roman&quot;;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></span></span>One</p><p class="MsoListParagraphCxSpFirst" style="margin-left: 0.75in; text-indent: -0.25in;"><span style=""><span style="">1.<span style="font: 7pt &quot;Times New Roman&quot;;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></span></span>Two</p><p class="MsoListParagraphCxSpFirst" style="text-indent: -0.25in;"><span style=""><span style="">2.<span style="font: 7pt &quot;Times New Roman&quot;;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></span></span>Three</p>'), '<ol><li>One<ol><li>Two</li></ol></li><li>Three</li></ol>');
        });

        test('paragraph cleaned', function() {
            equal(clean('<p class="MsoTitle"><span>foo</span></p>'), '<p><span>foo</span></p>');
        });

        test('list paragraph', function() {
            equal(clean('<p class="MsoListParagraphCxSpFirst"><span><span><span>o</span>&nbsp;</span></span>foo</p><p>bar</p>'), '<ul><li>foo</li></ul><p>bar</p>');
        });
    
        test('list paragraph list', function() {
            equal(clean('<p class="MsoListParagraphCxSpFirst"><span><span><span>o</span>&nbsp;</span></span>foo</p><p>bar</p><p class="MsoListParagraphCxSpFirst"><span><span><span>o</span>&nbsp;</span></span>baz</p>'), '<ul><li>foo</li></ul><p>bar</p><ul><li>baz</li></ul>');
        });

        test('nested list paragraph list', function() {
            equal(clean('<p class="MsoListParagraphCxSpFirst"><span><span><span>o</span>&nbsp;</span></span>foo</p><p class="MsoListParagraphCxSpFirst" style="margin-left:1in;"><span><span><span>o</span>&nbsp;</span></span>moo</p><p>bar</p><p class="MsoListParagraphCxSpFirst"><span><span><span>o</span>&nbsp;</span></span>baz</p>'), '<ul><li>foo<ul><li>moo</li></ul></li></ul><p>bar</p><ul><li>baz</li></ul>');
        });
    
        test('list block element list', function() {
            equal(clean('<p class="MsoListParagraphCxSpFirst"><span><span><span>o</span>&nbsp;</span></span>foo</p><h1>bar</h1><p class="MsoListParagraphCxSpFirst"><span><span><span>o</span>&nbsp;</span></span>baz</p>'), '<ul><li>foo</li></ul><h1>bar</h1><ul><li>baz</li></ul>');
        });

        test('list when there is no class just margin', function() {
            equal(clean('<p style="margin-left:1in;text-indent: -0.25in;"><span style="font-family: Symbol;"><span style="">o<span style="font: 7pt &quot;Times New Roman&quot;;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></span></span>foo</p>'), '<ul><li>foo</li></ul>');        
        });

        test('empty block elements skipped', function() {
            equal(clean('<p class="MsoListParagraphCxSpFirst"><span><span><span>o</span>&nbsp;</span></span>foo</p><h1></h1><p class="MsoListParagraphCxSpFirst"><span><span><span>o</span>&nbsp;</span></span>baz</p>'), '<ul><li>foo</li><li>baz</li></ul>');
        });

        test('paragraph which contains o but not first is not suitable', function() {
            equal(clean('<p class="MsoListParagraphCxSpFirst"><span><span>foo</span>&nbsp;</span>foo</p>'), '<p><span><span>foo</span>&nbsp;</span>foo</p>');
        });
    
        test('paragraph which contains number but not first is not suitable', function() {
            equal(clean('<p class="MsoListParagraphCxSpFirst"><span><span>foo1.</span>&nbsp;</span>foo</p>'), '<p><span><span>foo1.</span>&nbsp;</span>foo</p>');
        });

        test('nested lists', function() {
            equal(clean('<p class="MsoListParagraphCxSpFirst" style="text-indent: -0.25in;"><span style="font-family: Symbol;"><span style="">·<span style="font: 7pt &quot;Times New Roman&quot;;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></span></span>foo</p><p class="MsoListParagraphCxSpMiddle" style="margin-left: 1in; text-indent: -0.25in;"><span style="font-family: &quot;Courier New&quot;;"><span style="">o<span style="font: 7pt &quot;Times New Roman&quot;;">&nbsp;&nbsp;</span></span></span>bar</p><p class="MsoListParagraphCxSpMiddle" style="margin-left: 1.5in; text-indent: -0.25in;"><span style="font-family: Wingdings;"><span style="">§<span style="font: 7pt &quot;Times New Roman&quot;;">&nbsp;</span></span></span>baz</p><p class="MsoListParagraphCxSpLast" style="text-indent: -0.25in;"><span style="font-family: Symbol;"><span style="">·<span style="font: 7pt &quot;Times New Roman&quot;;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></span></span>moo</p>'), '<ul><li>foo<ul><li>bar<ul><li>baz</li></ul></li></ul></li><li>moo</li></ul>');
        });

        test('unordered list with two nested spans', function() {
            equal(clean('<p class="MsoListParagraphCxSpFirst" style="text-indent: -0.25in;"><span style="">o<span style="font: 7pt &quot;Times New Roman&quot;;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></span>foo</p>'), '<ul><li>foo</li></ul>');
        });
    
        test('nested lists of different type and same margin', function() {
            equal(clean('<p><span><span>1.</span>&nbsp;&nbsp;</span>foo</p><p><span><span>o</span>&nbsp;</span>bar</p>'), '<ol><li>foo<ul><li>bar</li></ul></li></ol>');
        });

        test('mixed multi level lists setup 1', function() {
            equal(clean('<p class="MsoListParagraphCxSpFirst" style="text-indent: -0.25in;"><span style="font-family: Symbol;"><span style="">·<span style="font: 7pt &quot;Times New Roman&quot;;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></span></span>foo</p><p class="MsoListParagraphCxSpMiddle" style="margin-left: 1in; text-indent: -0.25in;"><span style=""><span style="">1.<span style="font: 7pt &quot;Times New Roman&quot;;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></span></span>bar</p><p class="MsoListParagraphCxSpMiddle" style="margin-left: 1.5in; text-indent: -0.25in;"><span style=""><span style="">1.<span style="font: 7pt &quot;Times New Roman&quot;;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></span></span>moo</p><p class="MsoListParagraphCxSpLast" style="margin-left: 1in; text-indent: -0.25in;"><span style=""><span style="">2.<span style="font: 7pt &quot;Times New Roman&quot;;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></span></span>baz</p>'), '<ul><li>foo<ol><li>bar<ol><li>moo</li></ol></li><li>baz</li></ol></li></ul>');
        });

        test('mixed multi level lists setup 2', function() {
            equal(clean('<p class="MsoListParagraphCxSpFirst" style="text-indent: -0.25in;"><span style="font-family: Symbol;"><span style="">·<span style="font: 7pt &quot;Times New Roman&quot;;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></span></span>foo</p><p class="MsoListParagraphCxSpMiddle" style="margin-left: 1in; text-indent: -0.25in;"><span style=""><span style="">1.<span style="font: 7pt &quot;Times New Roman&quot;;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></span></span>bar</p><p class="MsoListParagraphCxSpLast" style="text-indent: -0.25in;"><span style="font-family: Symbol;"><span style="">·<span style="font: 7pt &quot;Times New Roman&quot;;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></span></span>moo</p>'), '<ul><li>foo<ol><li>bar</li></ol></li><li>moo</li></ul>');
        });

        test('three level lists', function() {
            equal(clean('<p class="MsoListParagraphCxSpFirst" style="text-indent: -0.25in;"><span style="font-family: Symbol;"><span style="">·<span style="font: 7pt &quot;Times New Roman&quot;;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></span></span>foo</p><p class="MsoListParagraphCxSpMiddle" style="margin-left: 1in; text-indent: -0.25in;"><span style="font-family: &quot;Courier New&quot;;"><span style="">o<span style="font: 7pt &quot;Times New Roman&quot;;">&nbsp;&nbsp;</span></span></span>foo1</p><p class="MsoListParagraphCxSpMiddle" style="text-indent: -0.25in;"><span style="font-family: Symbol;"><span style="">·<span style="font: 7pt &quot;Times New Roman&quot;;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></span></span>bar</p><p class="MsoListParagraphCxSpMiddle" style="margin-left: 1in; text-indent: -0.25in;"><span style="font-family: &quot;Courier New&quot;;"><span style="">o<span style="font: 7pt &quot;Times New Roman&quot;;">&nbsp;&nbsp;</span></span></span>bar1</p><p class="MsoListParagraphCxSpMiddle" style="margin-left: 1.5in; text-indent: -0.25in;"><span style="font-family: Wingdings;"><span style="">§<span style="font: 7pt &quot;Times New Roman&quot;;">&nbsp;</span></span></span>bar11</p><p class="MsoListParagraphCxSpLast" style="margin-left: 1in; text-indent: -0.25in;"><span style="font-family: &quot;Courier New&quot;;"><span style="">o<span style="font: 7pt &quot;Times New Roman&quot;;">&nbsp;&nbsp;</span></span></span>bar2</p>'), '<ul><li>foo<ul><li>foo1</li></ul></li><li>bar<ul><li>bar1<ul><li>bar11</li></ul></li><li>bar2</li></ul></li></ul>');
        });
    
        test('three level mixed lists', function() {
            equal(clean('<p class="MsoListParagraphCxSpFirst" style="text-indent: -0.25in;"><span style="font-family: Symbol;"><span style="">·<span style="font: 7pt &quot;Times New Roman&quot;;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></span></span>foo</p><p class="MsoListParagraphCxSpMiddle" style="margin-left: 1in; text-indent: -0.25in;"><span style=""><span style="">1.<span style="font: 7pt &quot;Times New Roman&quot;;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></span></span>foo1</p><p class="MsoListParagraphCxSpMiddle" style="text-indent: -0.25in;"><span style="font-family: Symbol;"><span style="">·<span style="font: 7pt &quot;Times New Roman&quot;;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></span></span>bar</p><p class="MsoListParagraphCxSpMiddle" style="margin-left: 1in; text-indent: -0.25in;"><span style=""><span style="">1.<span style="font: 7pt &quot;Times New Roman&quot;;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></span></span>bar1</p><p class="MsoListParagraphCxSpMiddle" style="margin-left: 1.5in; text-indent: -0.25in;"><span style=""><span style="">1.<span style="font: 7pt &quot;Times New Roman&quot;;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></span></span>bar11</p><p class="MsoListParagraphCxSpLast" style="margin-left: 1in; text-indent: -0.25in;"><span style=""><span style="">2.<span style="font: 7pt &quot;Times New Roman&quot;;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></span></span>bar2</p>'), '<ul><li>foo<ol><li>foo1</li></ol></li><li>bar<ol><li>bar1<ol><li>bar11</li></ol></li><li>bar2</li></ol></li></ul>');
        });

        test('mixed lists same margin', function() {
            equal(clean('<p class="MsoNormal" style="margin: 3pt 0in 3pt 0.25in; text-align: justify; text-indent: -0.25in;"><span style="font-size: 10pt; font-family: &quot;Verdana&quot;,&quot;sans-serif&quot;;"><span style="">1.<span style="font: 7pt &quot;Times New Roman&quot;;">&nbsp;&nbsp;&nbsp;</span></span></span>foo</p><p class="MsoNormal" style="margin-left: 0.25in; text-align: justify; text-indent: -0.25in;"><span style="font-size: 10pt; font-family: Symbol;"><span style="">·<span style="font: 7pt &quot;Times New Roman&quot;;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></span></span>bar</p><p class="MsoNormal" style="margin: 3pt 0in 3pt 0.25in; text-align: justify; text-indent: -0.25in;"><span style="font-size: 10pt; font-family: &quot;Verdana&quot;,&quot;sans-serif&quot;;"><span style="">2.<span style="font: 7pt &quot;Times New Roman&quot;;">&nbsp;&nbsp;&nbsp;</span></span></span>baz</p>'), '<ol><li>foo<ul><li>bar</li></ul></li><li>baz</li></ol>');
        });
    
        test('mixed nested lists same margin', function() {
            equal(clean('<p class="MsoNormal" style="margin: 3pt 0in 3pt 0.25in; text-align: justify; text-indent: -0.25in;"><span style="font-size: 10pt; font-family: &quot;Verdana&quot;,&quot;sans-serif&quot;;"><span style="">1.<span style="font: 7pt &quot;Times New Roman&quot;;">&nbsp;&nbsp;&nbsp;</span></span></span>foo</p><p class="MsoNormal" style="margin-left: 0.25in; text-align: justify; text-indent: -0.25in;"><span style="font-size: 10pt; font-family: Symbol;"><span style="">·<span style="font: 7pt &quot;Times New Roman&quot;;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></span></span>bar</p><p class="MsoNormal" style="margin: 3pt 0in 3pt 0.25in; text-align: justify; text-indent: -0.25in;"><span style="font-size: 10pt; font-family: &quot;Verdana&quot;,&quot;sans-serif&quot;;"><span style="">2.<span style="font: 7pt &quot;Times New Roman&quot;;">&nbsp;&nbsp;&nbsp;</span></span></span>baz</p><p class="MsoNormal" style="margin-left: 0.25in; text-align: justify; text-indent: -0.25in;"><span style="font-size: 10pt; font-family: Symbol;"><span style="">·<span style="font: 7pt &quot;Times New Roman&quot;;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></span></span>bar</p>'), '<ol><li>foo<ul><li>bar</li></ul></li><li>baz<ul><li>bar</li></ul></li></ol>');
        });

        test('ordered list from parenthesis', function() {
            equal(clean('<p class="MsoListParagraphCxSpFirst" style="text-indent: -0.25in;"><span style="font-family: Symbol;"><span style="">1)<span style="font: 7pt &quot;Times New Roman&quot;;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></span></span>foo</p>'), '<ol><li>foo</li></ol>')
        });

        test('handling unclosed tags', function() {
            equal(clean('<h2>foo<br></h2><div>bar</div>'), '<h2>foo</h2><div>bar</div>')
        });

        test('cleaning attribute values with encoded quotes', function() {
            equal(clean('<span style="mso-bidi-font-family:&quot;Times New Roman&quot;;">foo</span>'), '<span>foo</span>')
        });

        test('converting bold tags to strong', function() {
            equal(clean('<b>foo</b>'), '<strong>foo</strong>');
            equal(clean('<blockquote>foo</blockquote>'), '<blockquote>foo</blockquote>');
        });

        test('converting italics tags to emphasis', function() {
            equal(clean('<i>foo</i>'), '<em>foo</em>');
            equal(clean('<img />foo'), '<img>foo');
        });

    </script>

</asp:Content>
