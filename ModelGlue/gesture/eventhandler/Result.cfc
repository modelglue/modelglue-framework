<cfcomponent output="false" hint="I represent a result mapping.">

<cfproperty name="name" type="string" hint="The name of the result, such as ""formInvalid"" or ""loginSuccessful"".">
<cfproperty name="event" type="string" hint="The name of the event that should be run as a result of this result's being added via addResult().">
<cfproperty name="redirect" default="false" type="boolean" hint="Should a redirect take place?  If true, a redirect will occur the exact moment the result is added with addResult().">
<cfproperty name="append" type="string" hint="If a redirect occurs, I'm a comma-delimited list of event values to append to the resultant url.">
<cfproperty name="anchor" type="string" hint="If a redirect occurs, I'm the name of an event value containing a string to append as an anchor (index.cfm?event=foo##Anchor)">
<cfproperty name="preserveState" default="true" type="boolean" hint="If a redirect takes place, should state be preserved?">
<cfproperty name="format" type="string" hint="The request format of the result." />

<cfset this.name = "" />
<cfset this.event = "" />
<cfset this.redirect = false />
<cfset this.append = "" />
<cfset this.anchor = "" />
<cfset this.preserveState = true />
<cfset this.format = "" />

</cfcomponent>