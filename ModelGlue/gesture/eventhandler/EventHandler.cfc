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
<cfproperty name="extensible" type="boolean" hint="Allow extension by other event-handlers with the same name?" />

<cfset this.name = "" />
<cfset this.access = "public" />
<cfset this.messages = arrayNew(1) />
<cfset this.views = arrayNew(1) />
<cfset this.results = structNew() />
<cfset this.cache = 0 />
<cfset this.cacheKey = "" />
<cfset this.cacheKeyValues = "" />
<cfset this.cacheTimeout = 0 />
<cfset this.extensible = false />

<cffunction name="addMessage" returntype="ModelGlue.gesture.eventhandler.EventHandler" output="false" hint="Adds a Message and returns this.">
	<cfargument name="message" type="ModelGlue.gesture.eventhandler.Message" />
	
	<cfset arrayAppend(this.messages, message) />

	<cfreturn this />
</cffunction>

<cffunction name="hasMessage" access="public" returnType="boolean" output="false" hint="I state if a message already exists in this EventHandler.  Incurs a loop:  not a map lookup">
  <cfargument name="messagename" required="true" type="string">
	
	<cfset var i = "" />
	
	<cfloop from="1" to="#arrayLen(this.messages)#" index="i">
		<cfif this.messages[i].name eq messageName>
			<cfreturn true />
		</cfif>
	</cfloop>
	
	<cfreturn false />
</cffunction>

<cffunction name="addView" returntype="ModelGlue.gesture.eventhandler.EventHandler" output="false" hint="Adds a View and returns this.">
	<cfargument name="view" type="ModelGlue.gesture.eventhandler.View" />
	
	<cfset arrayAppend(this.views, view) />
	
	<cfreturn this />
</cffunction>

<cffunction name="addResult" returntype="ModelGlue.gesture.eventhandler.EventHandler" output="false" hint="Adds a Result and returns this.">
	<cfargument name="result" type="ModelGlue.gesture.eventhandler.Result" />
	
	<cfif arguments.result.name eq "">
		<cfset arguments.result.name = "cfNullKeyWorkaround" />
	</cfif>
	
	<cfif not structKeyExists(this.results, arguments.result.name)>
		<cfset this.results[arguments.result.name] = arrayNew(1) />
	</cfif>
	
	<cfset arrayAppend(this.results[arguments.result.name], result) />
	
	<cfreturn this />
</cffunction>

<cffunction name="hasResult" access="public" returntype="boolean" output="false" hint="I state if any resMappings exist for the given result name.  Map lookup (fast operation).">
	<cfargument name="name" required="true" type="string">
	
	<cfreturn structKeyExists(this.results, arguments.name) />
</cffunction>

<cffunction name="resultMappingExists" access="public" returntype="boolean" output="false" hint="Deprecated for consistency:  use hasResult().">
	<cfargument name="name" required="true" type="string">

	<cfreturn hasResult(argumentCollection=arguments) />
</cffunction>

<cffunction name="beforeConfiguration" access="public" returntype="void" output="false" hint="Called before configuring the event handler.  Subclasses can use this to add messages, results, or views before they're added by something like a ModelGlue XML file.">
</cffunction>

<cffunction name="afterConfiguration" access="public" returntype="void" output="false" hint="Called after configuring the event handler.  Subclasses can use this to add messages, results, or views after they're added by something like a ModelGlue XML file.">
</cffunction>

</cfcomponent>