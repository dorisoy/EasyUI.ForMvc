<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<% if (Request.Url.Host.Equals("demos.easyui.com", StringComparison.OrdinalIgnoreCase)) {  %>
<script type="text/javascript">var _gaq=_gaq||[];_gaq.push(['_setAccount','UA-111455-1'],['_setDomainName','.easyui.com'],['_setAllowHash',false],['_trackPageview']);(function(){var s=document.createElement('script');s.type='text/javascript';s.async=true;s.src=('https:'==document.location.protocol?'https://ssl':'http://www')+'.google-analytics.com/ga.js';document.body.appendChild(s);})();function trackPage(p){_gaq.push(['_trackPageview',p]);}</script>
<% } %>
