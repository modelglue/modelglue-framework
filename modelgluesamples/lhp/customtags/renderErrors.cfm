<cfparam name="attributes.errors">

<cfif isArray(attributes.errors) and arrayLen(attributes.errors)>

	<cfoutput>
	<div id="msg" class="error">
	Please correct the following error<cfif arrayLen(attributes.errors) gt 1>s</cfif>:
	<ul class="errorList">
		<cfloop index="e" array="#attributes.errors#">
		<li>#e#</li>
		</cfloop>
	</ul>
	</div>
	</cfoutput>
	
</cfif>