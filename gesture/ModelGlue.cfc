<cfcomponent output="false" extends="ModelGlue.ModelGlue"
	hint="The core of the Model-Glue framework.  Unlike earlier versions, I'm basically just an event dispatcher and a way to get to other core components."
> 

<!---
 Some properties are checked on _every_ request.  In this case, they're 
 exposed as public to avoid the cost of an accessor method.
--->
<cfproperty name="initialized" type="boolean" hint="Is ModelGlue initialized (present in the Application scope) and not needing reconfiguraion? " />

<cffunction name="init" output="false" hint="Constructor.">
	<cfset this.initialized = false />
	<cfset variables._internalBeanFactory = "" />	
	<!---
		The registry of message listeners in Model-Glue. 
		
		In Unity, this was a separate class.  We're going back to the old style
		of a simple structure to lower the number of function calls and streamline
		things.
	--->
	<cfset this.messageListeners = structNew() />

	<!---
		Map of registered controllers
	--->
	<cfset this.controllers = structNew() />
	
	<!---
		The registry of event handlers in Model-Glue. 
		
		In keeping with the "simple" theme of MG3, it's just a struct keyed
		by name.  Yeeha!
	--->
	<cfset this.eventHandlers = structNew() />
	
	<!---
		The phases of an event request.
	--->
	<cfset this.phases = arrayNew(1) />

	<!---
		Configuration settings.
	--->
	<cfset this.configuration = structNew() />
	
	<cfreturn this />
</cffunction>

<!--- FRAMEWORK CONFIGURATION ELEMENTS --->

<!--- Configuration Settings --->
<cffunction name="setModelGlueConfiguration" output="false" hint="Sets the MG Configuration bean instance to use.">
	<cfargument name="configuration" required="true" type="ModelGlue.gesture.configuration.ModelGlueConfiguration" />
	
	<cfset var source = arguments.configuration.getInstance() />
	<cfset var i = "" />
	
	<cfloop collection="#source#" item="i">
		<cfset setConfigSetting(i, source[i]) />
	</cfloop>
</cffunction>

<cffunction name="setConfigSetting" output="false" hint="Sets a configuration setting.">
	<cfargument name="settingName" type="string" hint="The setting name to retrieve." />
	<cfargument name="settingValue" type="string" hint="The value to set." />
	
	<cfset this.configuration[arguments.settingName] = arguments.settingValue />
</cffunction>

<cffunction name="getConfigSetting" output="false" hint="Gets a configuration setting by name.">
	<cfargument name="settingName" type="string" hint="The setting name to retrieve." />
	
	<cfreturn this.configuration[arguments.settingName] />
</cffunction>

<cffunction name="hasConfigSetting" output="false" hint="States if a given config setting exists.">
	<cfargument name="settingName" type="string" hint="The setting name to retrieve." />

	<cfreturn structKeyExists(this.configuration, arguments.settingName) />
</cffunction>

<!--- These are often accessed directly to shrink the stack during execution.  --->
<cffunction name="setRequestPhases" output="false" hint="Sets the request phases to be used in event context execution.">
	<cfargument name="phases" />
	<cfset this.phases = arguments.phases />
</cffunction>

<cffunction name="setEventPopulators" output="false" hint="Sets the populators to be used in event context population.">
	<cfargument name="populators" />
	<cfset this.populators = arguments.populators />
</cffunction>

<cffunction name="setViewRenderer" output="false" hint="Sets the view renderer to use to render output.">
	<cfargument name="viewRenderer" output="false" />

	<cfset var i = "" />
	<cfset var mappings = getConfigSetting("viewMappings") />
	
	<cfset variables._viewRenderer = arguments.viewRenderer />
	
	<cfloop list="#mappings#" index="i">
		<cfset variables._viewRenderer.addViewMapping(i) />
	</cfloop>
</cffunction>

<cffunction name="setStatePersister" output="false" hint="Sets the state persister to use to maintain state during redirects.">
	<cfargument name="statePersister" output="false" />
	<cfset variables._statePersister = arguments.statePersister />
</cffunction>

<cffunction name="setLogRenderer" output="false" hint="Sets the log renderer to use to render the request log.">
	<cfargument name="logRenderer" output="false" />
	<cfset variables._logRenderer = arguments.logRenderer />
</cffunction>

<!--- This is the internal bean factory (may be same as the one used by getBean()). --->
<cffunction name="setInternalBeanFactory" output="false" hint="Sets an inversion of control container to use for internal class resolution.">
	<cfargument name="beanFactory" type="any" required="true" />
	<cfset variables._internalBeanFactory = beanFactory />	
</cffunction>
<cffunction name="getInternalBeanFactory" output="false" hint="Gets the internal bean factory.">
	<cfreturn variables._internalBeanFactory />
</cffunction>
<cffunction name="getInternalBean" output="false" hint="Gets a bean from the internal IoC container.">
	<cfargument name="name" type="string" required="true" />
	<cfreturn variables._internalBeanFactory.getBean(arguments.name) />
</cffunction>

<cffunction name="setIocAdapter" output="false" hint="Sets the IoC adapter to use, wrapping the IoC bean factory used by getBean() (and getConfigBean()).">
	<cfargument name="iocAdapter" output="false" hint="iocAdapter implementation." />
	
	<cfset variables._iocAdapter = arguments.iocAdapter />
</cffunction>
<cffunction name="getIocAdapter" output="false" hint="Gets the IoC adapter in use (wraps the IoC bean factory used by getBean() (and getConfigBean())).">
	<cfreturn variables._iocAdapter />
</cffunction>
<cffunction name="getBean" output="false" hint="Gets a bean from the IoC adapter.  Replaces the deprecated getConfigBean().">
	<cfargument name="name" output="false" hint="The name / id of the bean to retrieve." />
	
	<cfreturn variables._iocAdapter.getBean(arguments.name) />
</cffunction>
<cffunction name="getConfigBean" output="false" hint="Deprecated.  Use getBean().">
	<cfargument name="name" output="false" hint="The name / id of the bean to retrieve." />
	
	<cfreturn getBean(arguments.name) />
</cffunction>

<!--- EVENT INVOCATION --->
<cffunction name="handleRequest" output="false" hint="Runs an event request, returning the EventContext.  Duck-typed return for speed.">
	<cfset var ctx = createObject("component", "ModelGlue.gesture.eventrequest.EventContext").init(
										modelglue=this,
										viewRenderer=variables._viewRenderer,
										statePersister=variables._statePersister
						 			 ) 
	/>
	
	<cfset ctx.execute() />
	
	<cfreturn ctx />
</cffunction>

<!--- EVENT LISTENER MANAGEMENT --->
<cffunction name="addEventListener" output="false" returntype="ModelGlue.gesture.ModelGlue" hint="Adds a component and a function in that component (by name, so it need not be defined at time of add) to be fired in response to a message name.">
	<cfargument name="messageName" type="string" required="true" hint="The message name to listen for." />
	<cfargument name="listenerInstance" type="any" required="true" hint="The component that wishes to act as a listener." />
	<cfargument name="listenerFunctionName" type="string" required="true" hint="The name of the listener function to fire.  A warning (but not an exception) will be added to the EventRequest if it's not defined at time of invocation." />
	
	<cfset var listener = createObject("component", "ModelGlue.gesture.eventhandler.MessageListener") />

	<Cflog text="adding listener for #messageName# (#listenerFunctionName#)" />
	
	<cfif not hasEventListener(arguments.messageName)>
		<cfset this.messageListeners[arguments.messageName] = arrayNew(1) />
	</cfif>
	
	<cfset listener.target = arguments.listenerInstance />
	<cfset listener.listenerFunction = arguments.listenerFunctionName />
	
	<cfset arrayAppend(this.messageListeners[arguments.messageName], listener) />
	
	<cfreturn this />
</cffunction>

<cffunction name="hasEventListener" output="false" returntype="boolean" hint="Does at least one listener exist for the given message name?">
	<cfargument name="messageName" type="string" required="true" hint="The message name to check for listeners for." />
	
	<cfreturn structKeyExists(this.messageListeners, arguments.messageName) />
</cffunction>

<cffunction name="getEventListeners" output="false" returntype="array" hint="Returns listeners for a given message.  If none exist, you'll get a key not defined error - we're going for speed, not friendliness, as this is one of the most heavily hit methods in Model-Glue.">
	<cfargument name="messageName" type="string" required="true" hint="The message name to return listeners for." />
	
	<cfreturn this.messageListeners[arguments.messageName] />
</cffunction>

<!--- CONTROLLER MANAGEMENT --->
<cffunction name="addController" output="false" returntype="void" hint="Registers a controller with the framework.">
	<cfargument name="controllerId" type="string" hint="Unique ID.  Will replace existing controller in the controller registry, but _not_ existing event listeners!">
	<cfargument name="controllerInstance" type="any" />
	
	<cfset this.controllers[arguments.controllerId] = arguments.controllerInstance />
</cffunction>

<cffunction name="getController" output="false" returntype="any" hint="Gets a controller by id.">
	<cfargument name="controllerId" type="string" />
	
	<cfreturn this.controllers[arguments.controllerId] />
</cffunction>

<!--- EVENT HANDLER MANAGEMENT --->
<cffunction name="addEventHandler" output="false" returntype="ModelGlue.gesture.ModelGlue" hint="I add an event handler.">
	<cfargument name="eventHandler" type="ModelGlue.gesture.eventhandler.EventHandler" required="true" hint="The event handler to add." />
	
	<cfset var i = "" />
	
	<cfset this.eventHandlers[arguments.eventHandler.name] = arguments.eventHandler />
	
	<cfreturn this />
</cffunction>

<cffunction name="getEventHandler" output="false" hint="I get an event handler by name.  If one doesn't exist, a struct key not found error is thrown - this is a heavy hit method, so it's about speed, not being nice.">
	<cfargument name="eventHandlerName" type="string" required="true" hint="The event handler to return." />
	
	<cfreturn this.eventHandlers[arguments.eventHandlerName] />
</cffunction>

<cffunction name="hasEventHandler" output="false" hint="Does an event handler by the given name exist?">
	<cfargument name="eventHandlerName" type="string" required="true" hint="The event handler in question." />
	
	<cfreturn structKeyExists(this.eventHandlers, arguments.eventHandlerName) />
</cffunction>

<!--- LOGGING --->
<cffunction name="renderContextLog" output="false" returntype="string" hint="I return a rendered version of an EventContext's request log.">
	<cfargument name="eventContext" />
	
	<cfreturn variables._logRenderer.renderLog(arguments.eventContext) />
</cffunction>

</cfcomponent>