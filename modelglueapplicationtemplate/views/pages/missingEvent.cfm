<cfset missing = event.getValue("missingEvent")>
<cfset missing = REReplace(missing, "[^a-z0-9]", "", "all")>

<h1>Oops!</h1>

<cfoutput>
No event named "#missing#" is defined.
</cfoutput>