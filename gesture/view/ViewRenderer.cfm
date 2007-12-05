<cfif thistag.executionmode eq "start"><cfsilent>
<cfset viewstate = attributes.viewstate />
<cfset event = attributes.viewstate />
<cfset viewcollection = attributes.viewcollection />
</cfsilent><cfinclude template="#attributes.includePath#" /></cfif>