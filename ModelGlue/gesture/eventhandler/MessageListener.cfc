<cfcomponent output="false" hint="I represent a listener for a message, containing its target and the name of the listener function.">

<cfproperty name="target" hint="The listener (Observer) object." />
<cfproperty name="listenerFunction" hint="The name of the listener function." />

<cfset this.target = "" />
<cfset this.listenerFunction = "" />

<cffunction name="invokeListener" hint="I invoke the listener function.">
	<cfargument name="eventContext" hint="The event context for the invokation." />
	
	<cfinvoke component="#this.target#" method="#this.listenerFunction#">
		<cfinvokeargument name="event" value="#arguments.eventContext#" />
	</cfinvoke>
</cffunction>

</cfcomponent>