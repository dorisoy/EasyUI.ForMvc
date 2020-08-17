﻿<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>

<div class="accessibility-validation">
    <h3 class="legend">Accessibility validation</h3>

    <%: Html.WaveValidatorLink() %>

    <p>
        WAVE is a free web accessibility evaluation tool, which checks for compliance issues with many of the
        <a href="http://www.section508.gov/index.cfm?fuseaction=stdsdoc" class="t-link">Section 508</a>
         and 
         <a href="http://www.w3.org/TR/WCAG20/" class="t-link">WCAG guidelines</a>.
         Have in mind that only humans can determine whether a web page is accessible - the above validation link is provided for the sake of completeness.
    </p>
</div>