<cfcomponent output="false" extends="ModelGlue.Core.Event" hint="I represent an event request and its context.  I am what you see as arguments.event.">

<cffunction name="init" access="public" returnType="any" output="false" hint="I build a new EventContext.">
	<cfargument name="eventHandlers" default="#structNew()#" hint="Available event handlers." />
	<cfargument name="messageListeners" default="#structNew()#" hint="Message subscribers." />
	<cfargument name="requestPhases" default="#arrayNew(1)#" hint="Request phases." />
	<cfargument name="modelglue" required="false" hint="The framework itself." />
	<cfargument name="statePersister" required="false" default="#createObject("component", "ModelGlue.gesture.eventrequest.statepersistence.SessionBasedStatePersister")#" hint="StatePersister to use during stateful redirects." />
	<cfargument name="viewRenderer" required="false" default="#createObject("component", "ModelGlue.gesture.view.ViewRenderer")#" hint="ViewRenderer to use to render included views to HTML." />
	<cfargument name="beanPopulator" required="false" default="#createObject("component", "ModelGlue.gesture.externaladapters.beanpopulation.BeanUtilsPopulator").init()#" hint="Populator used by makeEventBean()." />
	<cfargument name="values" required="false" default="#arrayNew(1)#" hint="A single structure or array of structures to merge into this collection." />
	<cfargument name="helpers" required="false" hint="Helpers available as part of the event context." default="#structNew()#" />
	
	<cfset variables._state = createObject("component", "ModelGlue.gesture.collections.MapCollection").init(values) />
	<cfset variables._viewCollection = createObject("component", "ModelGlue.gesture.collections.ViewCollection").init() />
	<cfset variables._readyForExecution = false />
	<cfset variables._initialEvent = "" />
	<cfset variables._currentEventHandler = "" />
	<cfset variables._currentMessage = "" />
	<cfset variables._trace = arrayNew(1) />
	<cfset variables._created = getTickCount() />
	<cfset variables._helpers = arguments.helpers />

	<cfif structKeyExists(arguments, "modelglue")>
		<!--- External maps of listeners and handlers --->
		<cfset variables._listeners = arguments.modelglue.messageListeners />
		<cfset variables._eventHandlers = arguments.modelglue.eventHandlers />
	
		<!--- External list of event phases --->
		<cfset variables._requestPhases = arguments.modelglue.phases />
		
		<cfset variables._modelGlue = arguments.modelglue />
	<cfelse>
		<!--- External maps of listeners and handlers --->
		<cfset variables._listeners = arguments.messageListeners />
		<cfset variables._eventHandlers = arguments.eventHandlers />
	
		<!--- External list of event phases --->
		<cfset variables._requestPhases = arguments.requestPhases />
	</cfif>
	
	<!--- Event Handler and View queues are implemented as linked lists --->
	<cfset variables._nextEventHandler = "" />
	<cfset variables._lastEventHandler = "" />
	<cfset variables._nextView = "" />
	<cfset variables._lastView = "" />
	
	<cfset setStatePersister(arguments.statePersister) />
	<cfset setViewRenderer(arguments.viewRenderer) />
	<cfset setBeanPopulator(arguments.beanPopulator) />

	<cfset resetResults() />

	<cfset trace("Creation", "Event Context Created") />
	 
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

<cffunction name="setRequestPhases" output="false" hint="I set the instance of the view renderer to use when a request is made to render a view.">
	<cfargument name="requestPhases" hint="The view renderer to use." />
	<cfset variables._requestPhases = arguments.requestPhases />	
</cffunction>

<cffunction name="setStatePersister" output="false" hint="I set the mechanism by which this event context should persist and recall its state across requests.">
	<cfargument name="statePersister" />
	
	<cfset variables._statePersister = arguments.statePersister />
</cffunction>

<cffunction name="setBeanPopulator" output="false" hint="I set Populator used by makeEventBean.">
	<cfargument name="beanPopulator" />
	
	<cfset variables._beanPopulator = arguments.beanPopulator />
</cffunction>

<cffunction name="getModelGlue" output="false" hint="Gets the instance of ModelGlue associated with this context.">
	<cfreturn variables._modelGlue />
</cffunction>
						
<!--- EVENT HANDLER QUEUE MANAGEMENT --->
<cffunction name="addEventHandler" output="false" hint="Queues an event handler to be executed as part of this request.">
	<cfargument name="eventHandler" hint="An EventHandler instance to queue.  Duck-typed for speed." />
	
	<cfset var link = structNew() />

	<cfset link.eventHandler = arguments.eventHandler />
	<cfset link.next = "" />

	<cfset trace("Event Queue", "Queueing event handler: #arguments.eventHandler.name#") />
	
	<cfif variables._readyForExecution and not isObject(variables._initialEvent)>
		<cfset variables._initialEvent = arguments.eventHandler />
	</cfif>

	<cfif not isStruct(variables._nextEventHandler)>
		<cfset variables._nextEventHandler = link />
		<cfset variables._lastEventHandler = link />
	<cfelse>
		<cfset variables._lastEventHandler.next = link />
		<cfset variables._lastEventHandler = link />
	</cfif>	
</cffunction>

<cffunction name="getNextEventHandler" access="public" output="false" hint="Returns the next event handler in the queue.">
	<cfset var eh = variables._nextEventHandler.eventHandler />
	<cfset variables._nextEventHandler = variables._nextEventHandler.next />
	
	<cfreturn eh />
</cffunction>

<cffunction name="hasNextEventHandler" output="false" hint="Returns if there's another event handler in the queue.">
	<cfreturn isStruct(variables._nextEventHandler) />
</cffunction>

<cffunction name="onReadyForExecution" access="public" output="false" hint="Invoked when all ""under the hood"" events (onRequestStart, etc.) are complete.">
	<cfset variables._readyForExecution = true />
</cffunction>

<!--- REQUEST EXECUTION --->
<cffunction name="execute" output="false" hint="Executes the event request.  Duck typed for speed:  returns the request itself.">
	<cfset var i = "" />
	<cfset var exceptionEventHandler = "" />
	
	<!--- Try to execute the event phases or nonphased request --->
	<cftry>
		<cfif isArray(variables._requestPhases) and arrayLen(variables._requestPhases)>
			<cfloop from="1" to="#arrayLen(variables._requestPhases)#" index="i">
				<cfset this.trace(variables._requestPhases[i].name, "Beginning request phase.") /> 
				
				<cfset variables._requestPhases[i].execute(this) />
				
				<cfset this.trace(variables._requestPhases[i].name, "Request phase complete.") /> 
			</cfloop>
		<cfelse>
			<cfset executeEventQueue() />
		</cfif>
		<cfcatch>
			<!--- Bus the exception --->
			<cfset setValue("exception", cfcatch) />
			
			<!--- Trace the exception.  Maybe people will like this ;) --->
			<cfset trace("Exception", cfcatch) />
			
			<cfif structKeyExists(variables, "_modelGlue")>
				<!--- If we're not running the exception handler, queue the exception handler. --->
				<cfset exceptionEventHandler = variables._modelGlue.getConfigSetting("defaultExceptionHandler") />
				
				<cfif isObject(getCurrentEventHandler()) and getCurrentEventHandler().name neq exceptionEventHandler and variables._modelGlue.hasEventHandler(exceptionEventHandler)>
					<cfset addEventHandler(variables._modelGlue.getEventHandler(exceptionEventHandler)) />
					<cfset executeEventQueue() />
				<cfelse>
					<cfrethrow />
				</cfif>
			<cfelse>
				<cfrethrow />
			</cfif>
		</cfcatch>
	</cftry>
	
	<cfreturn this />
</cffunction>

<cffunction name="executeEventQueue" access="public" output="false" hint="Executes all event handlers currently in the event queue and renders queued views.">
	<cfset var eh = "" />
	
	<!--- Run event handlers (broadcast/listener/result addition) --->
	<cfloop condition="isStruct(variables._nextEventHandler)">
		<cfset eh = getNextEventHandler() />
		<cfset executeEventHandler(eh) />
	</cfloop>

	<!--- Render all views queued. --->
	<cfset renderViewQueue() />
</cffunction>

<cffunction name="executeEventHandler" output="false" hint="Executes an event handler:  invokes listener functions, handles results, and queues views for rendering.">
	<cfargument name="eventHandler" hint="The event handler to execute.  Duck-typed for speed." />
	
	<cfset var message = "" />
	<cfset var results = "" />
	<cfset var result = "" />
	
	<cfset var i = "" />
	<cfset var j = "" />
	<cfset var requestFormat = getValue("requestFormat", "") />
		
	<cfset variables._currentEventHandler = arguments.eventHandler />
	
	<cfset this.trace("Event Handler", "Execute ""#arguments.eventHandler.name#""", "<event-handler name=""#arguments.eventHAndler.name#"">") /> 
	
	<!--- 
		Invoke "" message broadcasts.  Code repeated for format, if necessary, to 
		avoid string parsing - this is a per-request invocation!
	--->
	<cfloop from="1" to="#arrayLen(arguments.eventHandler.messages.cfNullKeyWorkaround)#" index="i">
		<cfset message = arguments.eventHandler.messages.cfNullKeyWorkaround[i] />
		
		<cfset variables._currentMessage = message />

		<cfset this.trace("Message Broadcast", "Broadcasting ""#message.name#""", "<message name=""#message.name#"">") /> 

		<cfif structKeyExists(variables._listeners, message.name)>
			<cfloop from="1" to="#arrayLen(variables._listeners[message.name])#" index="j">
				<cfset this.trace("Message Listener", "Invoking #variables._listeners[message.name][j].listenerFunction# in #getMetadata(variables._listeners[message.name][j].target).name#", "<message-listener message=""#message.name#"" function=""#variables._listeners[message.name][j].listenerFunction#"" />") /> 
				<cfset variables._listeners[message.name][j].invokeListener(this) />
			</cfloop>
		</cfif>
	</cfloop>
	<cfif len(requestFormat) and structKeyExists(arguments.eventHandler.messages, requestFormat)>
		<cfloop from="1" to="#arrayLen(arguments.eventHandler.messages[requestFormat])#" index="i">
			<cfset message = arguments.eventHandler.messages[requestFormat][i] />
			
			<cfset variables._currentMessage = message />
	
			<cfset this.trace("Message Broadcast", "Broadcasting ""#message.name#""", "<message name=""#message.name#"">") /> 
	
			<cfif structKeyExists(variables._listeners, message.name)>
				<cfloop from="1" to="#arrayLen(variables._listeners[message.name])#" index="j">
					<cfset this.trace("Message Listener", "Invoking #variables._listeners[message.name][j].listenerFunction# in #getMetadata(variables._listeners[message.name][j].target).name#", "<message-listener message=""#message.name#"" function=""#variables._listeners[message.name][j].listenerFunction#"" />") /> 
					<cfset variables._listeners[message.name][j].invokeListener(this) />
				</cfloop>
			</cfif>
		</cfloop>
	</cfif>
		
	<!--- Get, queue, and reset results. --->
	<cfset results = getResults() />
	
	<!--- Queue explicit results: repetitive on purpose. --->
	<cfloop from="1" to="#arrayLen(results)#" index="i">
		<cfif len(results[i]) and arguments.eventHandler.hasResult(results[i]) and isArray(arguments.eventHandler.results.cfNullKeyWorkaround[results[i]])>
			<cfloop from="1" to="#arrayLen(arguments.eventHandler.results.cfNullKeyWorkaround[results[i]])#" index="j">
				<cfset result = arguments.eventHandler.results.cfNullKeyWorkaround[results[i]][j] />
				
				<cfset this.trace("Result", "Explicit result ""#result.name#"" added, queing event ""#result.event#""", "<result name=""#result.name#"" do=""#result.event#"" />") /> 

				<cfif result.redirect>
					<cfset forward(result.event, result.preserveState, false, result.append, result.anchor) />
				<cfelse>
					<cfset addEventHandler(variables._eventHandlers[arguments.eventHandler.results.cfNullKeyWorkaround[results[i]][j].event]) />
				</cfif>
			</cfloop>
		</cfif>
	</cfloop>
	<cfif len(requestFormat)>
		
		<cfloop from="1" to="#arrayLen(results)#" index="i">
			<cfif len(results[i]) and arguments.eventHandler.hasResult(results[i], requestFormat) and isArray(arguments.eventHandler.results[requestFormat][results[i]])>
				<cfloop from="1" to="#arrayLen(arguments.eventHandler.results[requestFormat][results[i]])#" index="j">
					<cfset result = arguments.eventHandler.results[requestFormat][results[i]][j] />
					
					<cfset this.trace("Result", "Explicit result ""#result.name#"" added, queing event ""#result.event#""", "<result name=""#result.name#"" do=""#result.event#"" />") /> 
	
					<cfif result.redirect>
						<cfset forward(result.event, result.preserveState, false, result.append, result.anchor) />
					<cfelse>
						<cfset addEventHandler(variables._eventHandlers[arguments.eventHandler.results[requestFormat][results[i]][j].event]) />
					</cfif>
				</cfloop>
			</cfif>
		</cfloop>
	</cfif>
	
	<!--- Queue implicit results --->
	<cfif structKeyExists(arguments.eventHandler.results.cfNullKeyWorkaround, "cfNullKeyWorkaround") and isArray(arguments.eventHandler.results.cfNullKeyWorkaround.cfNullKeyWorkaround)>
		<cfset results = arguments.eventHandler.results.cfNullKeyWorkaround.cfNullKeyWorkaround />
		
		<cfloop from="1" to="#arrayLen(results)#" index="i">
				<cfset result = results[i] />

				<cfset this.trace("Result", "Implicit result queing event ""#result.event#""", "<result do=""#result.event#"" />") /> 

				<cfif result.redirect>
					<cfset forward(result.event, result.preserveState, false, result.append, result.anchor) />
				<cfelse>
					<cfset addEventHandler(variables._eventHandlers[results[i].event]) />
				</cfif>
		</cfloop>
	</cfif>
	<cfif len(requestFormat) and structKeyExists(arguments.eventHandler.results, requestFormat)>
		<cfif structKeyExists(arguments.eventHandler.results[requestFormat], "cfNullKeyWorkaround") 
					and isArray(arguments.eventHandler.results[requestFormat].cfNullKeyWorkaround)>
			<cfset results = arguments.eventHandler.results[requestFormat].cfNullKeyWorkaround />
			
			<cfloop from="1" to="#arrayLen(results)#" index="i">
					<cfset result = results[i] />
	
					<cfset this.trace("Result", "Implicit result queing event ""#result.event#""", "<result do=""#result.event#"" />") /> 
	
					<cfif result.redirect>
						<cfset forward(result.event, result.preserveState, false, result.append, result.anchor) />
					<cfelse>
						<cfset addEventHandler(variables._eventHandlers[results[i].event]) />
					</cfif>
			</cfloop>
		</cfif>
	</cfif>
		
	<!--- Reset results --->
	<cfset resetResults() />
	
	<!--- Queue views.  Repetitive on purpose - speed over elegance here. --->
	<cfloop from="1" to="#arrayLen(arguments.eventHandler.views.cfNullKeyWorkaround)#" index="i">
		<cfset queueView(arguments.eventHandler.views.cfNullKeyWorkaround[i]) />
	</cfloop>
	<cfif len(requestFormat) and structKeyExists(arguments.eventHandler.views, requestFormat)>
		<cfloop from="1" to="#arrayLen(arguments.eventHandler.views[requestFormat])#" index="i">
			<cfset queueView(arguments.eventHandler.views[requestFormat][i]) />
		</cfloop>
	</cfif>
</cffunction>

<!--- EVENT KNOWLEDGE --->
<cffunction name="getCurrentEventHandler" access="private" hint="Returns the current event handler.  Not something to be manipulated at runtime (private)!">
	<cfreturn variables._currentEventHandler />
</cffunction>

<cffunction name="getEventHandlerName" access="private" hint="Returns the name of the currently executing event handler.">
	<cfreturn getCurrentEventHandler().name />
</cffunction>

<cffunction name="getInitialEventHandler" output="false" hint="Returns the initial event in this request.">
	<cfreturn variables._initialEvent />
</cffunction>

<cffunction name="getInitialEventHandlerName" access="private" hint="Returns the name of the user-requested event handler.">
	<cfreturn getInitialEventHandler().name />
</cffunction>

<cffunction name="getArgument" access="public" hint="Gets a value of an argument from the currently broadcast message.">
	<cfargument name="name" type="string" required="true" />
	<cfargument name="default" type="string" required="false" />
	
	<cfif structKeyExists(arguments, "default")>
		<cfreturn variables._currentMessage.arguments.getValue(arguments.name, arguments.default) />
	<cfelse>
		<cfreturn variables._currentMessage.arguments.getValue(arguments.name) />
	</cfif>
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

<!--- LOCATION MANAGEMENT --->
<cffunction name="forwardToUrl" access="public" hint="Forwards to a given URL, optionally storing state across the redirect.">
	<cfargument name="url" type="string" hint="The URL to redirect to using <cflocation />">
	<cfargument name="preserveState" type="boolean" required="false" default="false" hint="Preserve state across the redirect?" />
	<cfargument name="addToken" type="boolean" default="false" hint="Should session tokens be added to the url?">
	
	<cfif arguments.preserveState>
		<cfset saveState() />
	</cfif>
	
	<cflocation url="#arguments.url#" addToken="#arguments.addToken#" />
</cffunction>

<cffunction name="forward" access="public" hint="Forwards the request to a given event name, optionally storing state across the redirect.">
	<cfargument name="eventName" type="string" hint="Name of the event to forward to." />
	<cfargument name="preserveState" type="boolean" required="false" default="false" hint="Preserve state across the redirect?" />
	<cfargument name="addToken" type="boolean" default="false" hint="Should session tokens be added to the url?">
	<cfargument name="append" default="" hint="The list of values to append." />
	<cfargument name="anchor" default="" hint="The anchor literal for the resultant URL." />

	<cfset var urlManager = variables._modelglue.getInternalBean("modelglue.urlManager") />
	
	<cfset var url = urlManager.linkTo(this, arguments.eventName, arguments.append, arguments.anchor) />
	
	<cfset forwardToUrl(url, arguments.preserveState, arguments.addToken) /> 
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

<cffunction name="saveState" access="public" returntype="void" output="false" hint="I save all state to session._modelglue.preservedState (if no exceptions are thrown!).">
	<cfset variables._statePersister.save(this) />
</cffunction>

<cffunction name="loadState" access="public" returntype="void" output="false" hint="I save all state to session._modelglue.preservedState (if no exceptions are thrown!).">
	<cftry>
		<cfset variables._statePersister.load(this) />
		<cfcatch></cfcatch>
	</cftry>
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

<cffunction name="renderView" access="public" output="false" hint="I render a view into the view collection.">
  <cfargument name="view" type="any" hint="I am the view to render.">

	<cfset var content = variables._viewRenderer.renderView(this, arguments.view, variables._helpers) />
	
	<cfset addView(arguments.view.name, content, arguments.view.append) />
</cffunction>

<cffunction name="queueView" access="private" returnType="void" output="false" hint="I add a view to the queue of views to render.">
  <cfargument name="view" type="any" hint="I am the view to queue.">

	<cfset var link = structNew() />

	<cfset link.view = arguments.view />
	<cfset link.next = "" />

	<cfset trace("View Queue", "View queued: #view.template#") />
	
	<cfif not isStruct(variables._nextView)>
		<cfset variables._nextView = link />
		<cfset variables._lastView = link />
	<cfelse>
		<cfset variables._lastView.next = link />
		<cfset variables._lastView = link />
	</cfif>	
	
</cffunction>

<cffunction name="getNextView" access="private" output="false" hint="Returns the next view in the queue.">
	<cfset var view = variables._nextView.view />
	<cfset variables._nextView = variables._nextView.next />

	<cfreturn view />
</cffunction>

<cffunction name="renderViewQueue" access="private" returnType="void" output="false" hint="I render all views currently in the queue.">
	<cfset var view = "" />

	<cfloop condition="isStruct(variables._nextView)">
		<cfset view = getNextView() />

		<cfset this.trace("Views", "Rendering view ""#view.name#"" (#view.template#)", "<include name=""#view.name#"" template=""#view.template#"" />") /> 

		<cfset renderView(view) />
	</cfloop>
</cffunction>

<cffunction name="getLastRendereredView" access="public" returntype="string" output="false" hint="Gets the last renderered view content.">
	<cfreturn variables._viewCollection.getFinalView() />
</cffunction>

<!--- TRACE LOG --->
<cffunction name="getTrace" access="public" returntype="array" output="false" hint="Gets the trace log for the event context.">
	<cfreturn variables._trace />
</cffunction>

<cffunction name="getCreated" access="public" returntype="numeric" output="false" hint="Gets the tick count for when this event context was initialized.">
	<cfreturn variables._created />
</cffunction>

<cffunction name="trace" access="public" returnType="Void" output="false" hint="I add a message to the trace log.">
  <cfargument name="type" type="string" />
  <cfargument name="message" type="any" />
  <cfargument name="tag" type="string" default="" />
  <cfargument name="traceType" type="string" default="OK" />

	<cfset arguments.time = getTickCount() />
	
	<cfif not isSimpleValue(arguments.message)>
		<cfsavecontent variable="arguments.message"><cfdump var="#arguments.message#" /></cfsavecontent>
	</cfif>
	
	<cfset arrayAppend(variables._trace, arguments) />
</cffunction>


<!--- BEAN POPULATION --->
<cffunction name="makeEventBean" access="public" returnType="any" output="false" hint="Populates a CFC instance's properties with like-named event values (or the list of values passed in the VALUES argument).">
	<cfargument name="target" type="any" hint="An instance of a CFC or the name of a CFC to instantiate and populate." />
	<cfargument name="fields" type="string" default="" hint="(Optional) List of properties to populate." />
	
	<cfset var source = "" />
	<cfset var i = "" />
	
	<!--- 
				TODO:  Building this secondary struct for a field-limited population is inefficient.  
				BeanUtils should be updated with this feature, and then the populator adapter
				changed.
	--->
	<cfif len(fields)>
		<cfset source = structNew() />
		
		<cfloop list="#arguments.fields#" index="i">
			<cfset source[i] = getValue(i) />
		</cfloop>
	<cfelse>
		<cfset source = getAll() />
	</cfif>
	
	<cfreturn variables._beanPopulator.populate(arguments.target, source) />
</cffunction>

</cfcomponent>