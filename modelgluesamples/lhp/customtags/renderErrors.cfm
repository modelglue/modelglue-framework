<cfparam name="attributes.errors">

<cfif isArray(attributes.errors) and arrayLen(attributes.errors)>

	<cfoutput>
	<div id="msg" class="error">
	Please correct the following error<cfif arrayLen(attributes.errors) gt 1>s</cfif>:
	<ul class="errorList">
		<cfloop index="x" from="1" to="#arrayLen(attributes.errors)#">		
		<li>#attributes.errors[x]#</li>
		</cfloop>
	</ul>
	</div>
	</cfoutput>
	
</cfif>