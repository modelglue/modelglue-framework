<cfif thistag.executionmode eq "start"><cfsilent>
<cfset viewstate = attributes.viewstate />
<cfset event = attributes.viewstate />
<cfset viewcollection = attributes.viewcollection />
<cfset helpers = attributes.helpers />
</cfsilent><cfinclude template="#attributes.includePath#" /></cfif>