<cfset settings = event.getValue("settings")>

<h2 class="red">Getting Started</h2>

<p>
Welcome to Lighthouse Pro, a web based bug and issue tracker. To begin using Lighthouse Pro, simply
select from one of the projects in the left hand menu. You may update your preferences or logout from
the top hand menu. This is version <cfoutput>#settings.version#</cfoutput> of Lighthouse Pro. The latest version can be 
found at <a href="http://lighthousepro.riaforge.org/">http://lighthousepro.riaforge.org</a>. It was 
created by <a href="http://www.coldfusionjedi.com">Raymond Camden</a>.
</p>

<p>
Every project will contain issues (bug, enhancement requests, etc). Each issue is made of a few different properties:
<ul>
<li>Name: The name of the issue obviously. Try to use something descriptive.</li>
<li>Description: A <i>detailed</i> description of the issue.</li>
<li>Type: Not all issues are bugs. Some are enhancement requests. Your installation of Lighthouse Pro may have several customized issue types. Be sure to pick the
one that most accurately describes what your issues is.</li>
<li>Area: This is the area that the issue concerns. A bug in the admin of a project would go in the Admin area. These settings are unique per project.</li>
<li>Severity: How serious is your issue?</li>
<li>Status: New issues are typically marked open. You should mark an issue fixed when the problem has been addressed, and the reporter of the issue can mark the issue closed
when they agree everything is taken care of. Status values can be customized.</li>
<li>Due Date: If an issue must be fixed by a certain date, specify a due date.</li>
<li>Related URL: If you can demonstrate the issue by showing a URL be sure to specify it when editing the issue.</li> 
<li>Attachment: If you can't use a URL to demonstrate the issue, consider attaching a screen shot.</li>
<li>Owner: Sometimes its nice to pass the buck. If you think an issue belongs to someone else, simply specify another owner in the project.</li>
<li>History: This is a read only log of the changes to the issue.</li>
</ul>
</p>	