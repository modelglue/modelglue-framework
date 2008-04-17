<cfcomponent output="false" hint="I represent an event handler.">

<cfproperty name="name" type="string" hint="The name of the event handler." />
<cfproperty name="access" type="string" default="public" hint="Access setting (generally PUBLIC or PRIVATE)." />
<cfproperty name="messages" type="array" hint="Messages broadcast when this event handler is run.  Add messages with addMessage()!" />
<cfproperty name="views" type="array" hint="Messages broadcast when this event handler is run.  Add views with addView()!" />
<cfproperty name="resMappings" type="array" hint="Result definitions.  Add resMappings with addResult()!" />
<cfproperty name="cache" type="boolean" hint="Cache this event-handler?" />
<cfproperty name="cacheKey" type="string" hint="Key by which this event-handler should be known in the cache.  Typically set by convention." />
<cfproperty name="cacheKeyValues" type="string" hint="List of event values to append to the cache key." />
<cfproperty name="cacheTimeout" type="numeric" hint="Number of seconds this event-handler should be cached." />

<cfset this.name = "" />
<cfset this.access = "public" />
<cfset this.messages = structNew() />
<cfset this.messages.cfNullKeyWorkaround = arrayNew(1) />
<cfset this.views = structNew() />
<cfset this.views.cfNullKeyWorkaround = arrayNew(1) />
<cfset this.results = structNew() />
<cfset this.results.cfNullKeyWorkaround = structNew() />
<cfset this.cache = 0 />
<cfset this.cacheKey = "" />
<cfset this.cacheKeyValues = "" />
<cfset this.cacheTimeout = 0 />

<cffunction name="addMessage" returntype="ModelGlue.gesture.eventhandler.EventHandler" output="false" hint="Adds a Message and returns this.">
	<cfargument name="message" type="ModelGlue.gesture.eventhandler.Message" />
	<cfargument name="format" type="string" default="cfNullKeyWorkaround" />
	
	<cfif not structKeyExists(this.messages, arguments.format)>
		<cfset this.messages[arguments.format] = arrayNew(1) />
	</cfif>
	
	<cfset arrayAppend(this.messages[arguments.format], message) />

	<cfreturn this />
</cffunction>

<cffunction name="hasMessage" access="public" returnType="boolean" output="false" hint="I state if a message already exists in this EventHandler.  Incurs a loop:  not a map lookup">
  <cfargument name="messagename" required="true" type="string">
  <cfargument name="format" default="cfNullKeyWorkaround" type="string">
	
	<cfset var i = "" />
	
	<cfif not structKeyExists(this.messages, arguments.format)>
		<cfset this.messages[arguments.format] = arrayNew(1) />
	</cfif>
	
	<cfloop from="1" to="#arrayLen(this.messages[arguments.format])#" index="i">
		<cfif this.messages[arguments.format][i].name eq messageName>
			<cfreturn true />
		</cfif>
	</cfloop>
	
	<cfreturn false />
</cffunction>

<cffunction name="addView" returntype="ModelGlue.gesture.eventhandler.EventHandler" output="false" hint="Adds a View and returns this.">
	<cfargument name="view" type="ModelGlue.gesture.eventhandler.View" />
  <cfargument name="format" default="cfNullKeyWorkaround" type="string">
	
	<cfif not structKeyExists(this.views, arguments.format)>
		<cfset this.views[arguments.format] = arrayNew(1) />
	</cfif>

	<cfset arrayAppend(this.views[arguments.format], view) />
	
	<cfreturn this />
</cffunction>

<cffunction name="addResult" returntype="ModelGlue.gesture.eventhandler.EventHandler" output="false" hint="Adds a Result and returns this.">
	<cfargument name="result" type="ModelGlue.gesture.eventhandler.Result" />
	<cfargument name="format" type="string" default="cfNullKeyWorkaround" />
	
	<cfif result.name eq "">
		<cfset result.name = "cfNullKeyWorkaround" />
	</cfif>
	
	<cfif not structKeyExists(this.results, arguments.format)>
		<cfset this.results[arguments.format] = structNew() />
	</cfif>
	
	<cfif not structKeyExists(this.results[arguments.format], arguments.result.name)>
		<cfset this.results[arguments.format][arguments.result.name] = arrayNew(1) />
	</cfif>
	
	<cfset arrayAppend(this.results[arguments.format][arguments.result.name], result) />
	
	<cfreturn this />
</cffunction>

<cffunction name="hasResult" access="public" returntype="boolean" output="false" hint="I state if any resMappings exist for the given result name.  Map lookup (fast operation).">
	<cfargument name="name" required="true" type="string">
	<cfargument name="format" required="false" default="cfNullKeyWorkaround" />
	
	<cfreturn structKeyExists(this.results, arguments.format) and structKeyExists(this.results[arguments.format], arguments.name) />
</cffunction>

<cffunction name="resultMappingExists" access="public" returntype="boolean" output="false" hint="Deprecated for consistency:  use hasResult().">
	<cfargument name="name" required="true" type="string">
	<cfargument name="format" required="false" default="cfNullKeyWorkaround" />

	<cfreturn hasResult(argumentCollection=arguments) />
</cffunction>

<cffunction name="beforeConfiguration" access="public" returntype="void" output="false" hint="Called before configuring the event handler.  Subclasses can use this to add messages, results, or views before they're added by something like a ModelGlue XML file.">
</cffunction>

<cffunction name="afterConfiguration" access="public" returntype="void" output="false" hint="Called after configuring the event handler.  Subclasses can use this to add messages, results, or views after they're added by something like a ModelGlue XML file.">
</cffunction>

</cfcomponent>