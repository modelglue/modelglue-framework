<cfcomponent output="false" hint="The core of the Model-Glue framework.  Unlike earlier versions, I'm basically just an event dispatcher and a way to get to other core components."> 

<cffunction name="init" output="false" hint="Constructor.">
	<!---
		The registry of message listeners in Model-Glue. 
		
		In Unity, this was a separate class.  We're going back to the old style
		of a simple structure to lower the number of function calls and streamline
		things.
	--->
	<cfset variables._messageListeners = structNew() />

	<!---
		The registry of event handlers in Model-Glue. 
		
		In keeping with the "simple" theme of MG3, it's just a struct keyed
		by name.  Yeeha!
	--->
	<cfset variables._eventHandlers = structNew() />
	
	<cfreturn this />
</cffunction>

<!--- EVENT LISTENER MANAGEMENT --->
<cffunction name="addEventListener" output="false" returntype="ModelGlue.gesture.ModelGlue" hint="Adds a component and a function in that component (by name, so it need not be defined at time of add) to be fired in response to a message name.">
	<cfargument name="messageName" type="string" required="true" hint="The message name to listen for." />
	<cfargument name="listenerInstance" type="any" required="true" hint="The component that wishes to act as a listener." />
	<cfargument name="listenerFunctionName" type="string" required="true" hint="The name of the listener function to fire.  A warning (but not an exception) will be added to the EventRequest if it's not defined at time of invocation." />
	
	<cfset var listener = createObject("component", "ModelGlue.gesture.eventhandler.MessageListener") />
	
	<cfif not hasEventListener(arguments.messageName)>
		<cfset variables._messageListeners[arguments.messageName] = arrayNew(1) />
	</cfif>
	
	<cfset listener.target = arguments.listenerInstance />
	<cfset listener.listenerFunction = arguments.listenerFunctionName />
	
	<cfset arrayAppend(variables._messageListeners[arguments.messageName], listener) />
	
	<cfreturn this />
</cffunction>

<cffunction name="hasEventListener" output="false" returntype="boolean" hint="Does at least one listener exist for the given message name?">
	<cfargument name="messageName" type="string" required="true" hint="The message name to check for listeners for." />
	
	<cfreturn structKeyExists(variables._messageListeners, arguments.messageName) />
</cffunction>

<cffunction name="getEventListeners" output="false" returntype="array" hint="Returns listeners for a given message.  If none exist, you'll get a key not defined error - we're going for speed, not friendliness, as this is one of the most heavily hit methods in Model-Glue.">
	<cfargument name="messageName" type="string" required="true" hint="The message name to return listeners for." />
	
	<cfreturn variables._messageListeners[arguments.messageName] />
</cffunction>

<!--- EVENT HANDLER MANAGEMENT --->
<cffunction name="addEventHandler" output="false" returntype="ModelGlue.gesture.ModelGlue" hint="I add an event handler.">
	<cfargument name="eventHandler" type="ModelGlue.gesture.eventhandler.EventHandler" required="true" hint="The event handler to add." />
	
	<cfset var i = "" />
	
	<cfset variables._eventHandlers[arguments.eventHandler.name] = arguments.eventHandler />
	
	<cfreturn this />
</cffunction>

<cffunction name="getEventHandler" output="false" hint="I get an event handler by name.  If one doesn't exist, a struct key not found error is thrown - this is a heavy hit method, so it's about speed, not being nice.">
	<cfargument name="eventHandlerName" type="string" required="true" hint="The event handler to return." />
	
	<cfreturn variables._eventHandlers[arguments.eventHandlerName] />
</cffunction>

</cfcomponent>