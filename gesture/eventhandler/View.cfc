<cfcomponent output="false" hint="I represent a message and its arguments.">

<cfproperty name="name" type="string" hint="The name of the message." />
<cfproperty name="template" type="string" hint="The .cfm template (present in one of the view mappings) to render." />
<cfproperty name="values" type="struct" hint="The collection of values associated with this view." />
<cfproperty name="append" type="boolean" hint="Does this view append to existing views of the same name?" />

<cfset this.name = "" />
<cfset this.values = structNew() />
<cfset this.template = "" />
<cfset this.append = false />

<cffunction name="addValue" returntype="ModelGlue.gesture.eventhandler.View" output="false" hint="Adds a Value and returns this.">
	<cfargument name="value" type="ModelGlue.gesture.eventhandler.Value" />
	
	<cfset this.values[value.name] = value />
	
	<cfreturn this />
</cffunction>

</cfcomponent>