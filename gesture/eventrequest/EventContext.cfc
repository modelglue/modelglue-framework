<cfcomponent output="false" hint="I represent an event request and its context.  I am what you see as arguments.event.">

<cffunction name="init" access="public" returnType="any" output="false" hint="I build a new EventContext.">
	<cfargument name="values" required="false" default="#arrayNew(1)#" hint="A single structure or array of structure to merge into this collection." />
	
	<cfset variables._state = createObject("component", "ModelGlue.gesture.collections.MapCollection").init(values) />
	<cfset variables._viewCollection = createObject("component", "ModelGlue.gesture.collections.ViewCollection").init() />
	<cfset variables._readyForExecution = false />
	<cfset variables._initialEvent = "" />
	<cfset variables._nextEventHandler = "" />
	<cfset variables._listeners = structNew() />
	<cfset variables._eventHandlers = structNew() />

	<cfset resetResults() />

	<cfreturn this />
</cffunction>

<cffunction name="setListenerMap" output="false" hint="I set the map of message listeners to be used for message broadcasting.">
	<cfargument name="listenerMap" type="struct" hint="The listener map." />
	<cfset variables._listeners = arguments.listenerMap />	
</cffunction>

<cffunction name="setEventHandlerMap" output="false" hint="I set the map of event handlers registered with Model-Glue.">
	<cfargument name="eventHandlerMap" type="struct" hint="The event handlers map." />
	<cfset variables._eventHandlers = arguments.eventHandlerMap />	
</cffunction>

<cffunction name="setViewRenderer" output="false" hint="I set the instance of the view renderer to use when a request is made to render a view.">
	<cfargument name="viewRenderer" hint="The view renderer to use." />
	<cfset variables._viewRenderer = arguments.viewRenderer />	
</cffunction>

<!--- EVENT HANDLER QUEUE MANAGEMENT --->
<cffunction name="addEventHandler" output="false" hint="Queues an event handler to be executed as part of this request.">
	<cfargument name="eventHandler" hint="An EventHandler instance to queue.  Duck-typed for speed." />
	
	<cfset var link = structNew() />

	<cfset link.eventHandler = arguments.eventHandler />
	<cfset link.next = "" />

	<cfif variables._readyForExecution and not isObject(variables._initialEvent)>
		<cfset variables._initialEvent = arguments.eventHandler />
	</cfif>
	
	<cfif not isStruct(variables._nextEventHandler)>
		<cfset variables._nextEventHandler = link />
	<cfelse>
		<cfset variables._nextEventHandler.next = link />
	</cfif>	
</cffunction>

<cffunction name="getInitialEventHandler" output="false" hint="Returns the name of the initial event in this request.">
	<cfreturn variables._initialEvent />
</cffunction>

<cffunction name="getNextEventHandler" output="false" hint="Returns the next event handler in the queue.">
	<cfset var eh = variables._nextEventHandler.eventHandler />
	<cfset variables._nextEventHandler = variables._nextEventHandler.next />
	<cfreturn eh />
</cffunction>

<cffunction name="hasNextEventHandler" output="false" hint="Returns if there's another event handler in the queue.">
	<cfreturn isStruct(variables._nextEventHandler) />
</cffunction>

<cffunction name="onReadyForExecution" output="false" hint="Invoked when all ""under the hood"" events (onRequestStart, etc.) are complete.">
	<cfset variables._readyForExecution = true />
</cffunction>

<!--- REQUEST EXECUTION --->
<cffunction name="execute" output="false" hint="Executes the event request.  Duck typed for speed:  returns the request itself.">
	<cfset var eh = "" />
	
	<!--- TODO:  Add plug-in points...but that requires configuration.  We're just doing core request for now. --->
	
	<cfloop condition="isStruct(variables._nextEventHandler)">
		<cfset eh = getNextEventHandler() />
		<cfset executeEventHandler(eh) />
	</cfloop>

	<cfreturn this />
</cffunction>

<cffunction name="executeEventHandler" output="false" hint="Executes an event handler:  invokes listener functions, handles results, and queues views for rendering.">
	<cfargument name="eventHandler" hint="The event handler to execute.  Duck-typed for speed." />
	
	<cfset var message = "" />
	<cfset var results = "" />
	
	<cfset var i = "" />
	<cfset var j = "" />
		
	<!--- Invoke message broadcasts. --->
	<cfloop from="1" to="#arrayLen(arguments.eventHandler.messages)#" index="i">
		<cfset message = arguments.eventHandler.messages[i] />
		<cfif structKeyExists(variables._listeners, message.name)>
			<cfloop from="1" to="#arrayLen(variables._listeners[message.name])#" index="j">
				<cfset variables._listeners[message.name][j].invokeListener(this) />
			</cfloop>
		</cfif>
	</cfloop>
	
	<!--- Get, queue, and reset results. --->
	<cfset results = getResults() />
	
	<!--- Queue explicit results --->
	<cfloop from="1" to="#arrayLen(results)#" index="i">
		<cfif len(results[i]) and arguments.eventHandler.hasResult(results[i])>
			<cfloop from="1" to="#arrayLen(arguments.eventHandler.results[results[i]])#" index="j">
				<cfset addEventHandler(variables._eventHandlers[arguments.eventHandler.results[results[i]][j].event]) />
			</cfloop>
		</cfif>
	</cfloop>

	<!--- TODO: Queue implicit results --->
	<cfif structKeyExists(arguments.eventHandler.results, "")>
		<cfset results = arguments.eventHandler.results[""] />
		<cfloop from="1" to="#arrayLen(results)#" index="i">
			<cfset addEventHandler(variables._eventHandlers[results[i].event]) />
		</cfloop>
	</cfif>
		
	<!--- Reset results --->
	<cfset resetResults() />
</cffunction>

<!--- RESULT MANAGEMENT --->
<cffunction name="resetResults" access="public" hint="Resets results to an empty array.">
	<cfset variables._results = arrayNew(1) />
</cffunction>

<cffunction name="getResults" access="public" hint="Gets the result names added by a listener function.">
	<cfreturn variables._results />
</cffunction>

<cffunction name="addResult" access="public" hint="Adds a result, by name, to the result queue.">
	<cfargument name="result" type="string" hint="The name of the result (e.g., ""formInvalid"" or the like) to add." />
	
	<!--- TODO:  Add redirect capabilities.  How the @#@#$ are we going to unit test that?  Mock forwarder?--->
	<cfset arrayAppend(variables._results, arguments.result) />
</cffunction>

<!--- STATE (DATA BUS) MANAGEMENT --->
<cffunction name="getAllValues" access="public" returnType="struct" output="false" hint="DEPRECATED:  Use getAll().  Still supported for reverse compatibility.  I return the entire view's current state.">
  <cfreturn getAll() />
</cffunction>

<cffunction name="getAll" access="public" returnType="struct" output="false" hint="I get all values by reference.">
  <cfreturn variables._state.getAll() />
</cffunction>

<cffunction name="setValue" access="public" returnType="void" output="false" hint="I set a value in the collection.">
	<cfargument name="name" type="string" required="true" hint="I am the name of the value.">
	<cfargument name="value" type="any" required="true" hint="I am the value.">

	<cfreturn variables._state.setValue(argumentCollection=arguments) />
</cffunction>

<cffunction name="getValue" access="public" returnType="any" output="false" hint="I get a value from the collection.">
  <cfargument name="name" hint="I am the name of the value.">
  <cfargument name="default" required="false" type="any" hint="I am a default value to set and return if the value does not exist." />

	<cfreturn variables._state.getValue(argumentCollection=arguments) />
</cffunction>

<cffunction name="removeValue" access="public" returnType="void" output="false" hint="I remove a value from the collection.">
  <cfargument name="name" type="string" required="true" hint="I am the name of the value.">
	
	<cfreturn variables._state.removeValue(argumentCollection=arguments) />
</cffunction>

<cffunction name="valueExists" access="public" returnType="boolean" output="false" hint="DEPRECATED:  Use exists().  Still supported for reverse compatibility.  I state if a value exists.">
	<cfreturn exists(argumentCollection=arguments) />
</cffunction>

<cffunction name="exists" access="public" returnType="boolean" output="false" hint="I state if a value exists.">
  <cfargument name="name" type="string" required="true" hint="I am the name of the value.">

	<cfreturn variables._state.exists(argumentCollection=arguments) />
</cffunction>

<cffunction name="merge" access="public" returnType="void" output="false" hint="I merge an entire struct into the collection.">
  <cfargument name="struct" type="struct" required="true" hint="I am the struct to merge." />

	<cfreturn variables._state.merge(argumentCollection=arguments) />
</cffunction>

<!--- VIEW MANAGEMENT --->
<cffunction name="getViewCollection" access="public" output="false" hint="I return the view collection for the event request.">
	<cfreturn variables._viewCollection />
</cffunction>

<cffunction name="addView" access="public" returnType="void" output="false" hint="I add a rendered view to the view collection.">
  <cfargument name="key" type="string" required="true" hint="I am the name of the view to add.">
  <cfargument name="content" type="string" required="true" hint="I am the HTML of the view.">
  <cfargument name="append" type="boolean" required="false" default="false" hint="Should the HTML be appended on to an existing view of the same name?">
	
	<cfset variables._viewCollection.addRenderedView(argumentCollection=arguments) />
</cffunction>

<cffunction name="getView" access="public" output="false" hint="I get a rendered view by name.">
  <cfargument name="name" required="true" hint="I am the name of the view to get.">
	
	<cfreturn variables._viewCollection.getView(argumentCollection=arguments) />
</cffunction>

<cffunction name="renderView" output="false" hint="I render a view into the view collection.">
  <cfargument name="view" type="any" hint="I am the view to render.">

	<cfset var content = variables._viewRenderer.renderView(this, arguments.view) />
	
	<cfset addView(arguments.view.name, content, arguments.view.append) />
</cffunction>

</cfcomponent>