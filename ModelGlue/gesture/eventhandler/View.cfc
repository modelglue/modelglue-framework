<cfcomponent output="false" hint="I represent a view and its values.">

<cfproperty name="name" type="string" hint="The name of the message." />
<cfproperty name="template" type="string" hint="The .cfm template (present in one of the view mappings) to render." />
<cfproperty name="values" type="struct" hint="The collection of values associated with this view." />
<cfproperty name="append" type="boolean" hint="Does this view append to existing views of the same name?" />
<cfproperty name="cache" type="boolean" hint="Cache this view?" />
<cfproperty name="cacheKey" type="string" hint="Key by which this event-handler should be known in the cache.  Typically set by convention." />
<cfproperty name="cacheKeyValues" type="string" hint="List of event values to append to the cache key." />
<cfproperty name="cacheTimeout" type="numeric" hint="Number of seconds this event-handler should be cached." />
<cfproperty name="format" type="string" hint="The request format of the view." />

<cfset this.name = "" />
<cfset this.values = structNew() />
<cfset this.template = "" />
<cfset this.append = false />
<cfset this.cache = 0 />
<cfset this.cacheKey = "" />
<cfset this.cacheKeyValues = "" />
<cfset this.cacheTimeout = 0 />
<cfset this.format = "" />

<cffunction name="addValue" returntype="ModelGlue.gesture.eventhandler.View" output="false" hint="Adds a Value and returns this.">
	<cfargument name="value" type="ModelGlue.gesture.eventhandler.Value" />
	
	<cfset this.values[value.name] = value />
	
	<cfreturn this />
</cffunction>

</cfcomponent>