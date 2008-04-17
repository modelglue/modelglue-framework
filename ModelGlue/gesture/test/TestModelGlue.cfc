<cfcomponent extends="org.cfcunit.framework.TestCase" hint="Tests EventHandler, Message, View, and Result CFCs.">

<cffunction name="createModelGlueNoInit" access="private">
	<cfreturn createObject("component", "ModelGlue.gesture.ModelGlue") />
</cffunction>

<cffunction name="createModelGlue" access="private">
	<cfreturn createModelGlueNoInit().init() />
</cffunction>

<cffunction name="createEventHandler" access="private">
	<cfreturn createObject("component", "ModelGlue.gesture.eventhandler.EventHandler") />
</cffunction>

<cffunction name="createBootstrappedModelGlue" access="private">
	<cfset var boot = createObject("component", "ModelGlue.gesture.loading.XMLColdSpringBootstrapper") />
	<cfset boot.coldspringPath = "/ModelGlue/gesture/configuration/ModelGlueConfiguration.xml" />
	<cfset boot.initialModulePath = "/ModelGlue/gesture/test/primaryModule.xml" />
	<cfset boot.storeModelGlue() />
	
	<cfreturn boot.createModelGlue() />
</cffunction>

<!--- LISTENER REGISTRATION TESTS --->
<cffunction name="testAddEventListener" returntype="void" access="public">
	<cfset var mg = createModelGlue() />
	<cfset var listeners = "" />
	
	<cfset assertFalse(mg.hasEventListener("message"), "should have no listener for ""message"" before adding listener!") />
	
	<cfset mg.addEventListener("message", this, "stub_listenerFunction") />
	
	<cfset assertTrue(mg.hasEventListener("message"), "no listener for ""message"" after add!") />
	
	<cfset listeners = mg.getEventListeners("message") />
	<cfset assertTrue(arrayLen(listeners) eq 1, "should have 1 listener after add") />
	<cfset assertTrue(getMetadata(listeners[1]).name eq "ModelGlue.gesture.eventhandler.MessageListener", "a MessageListener instance should exist after add") />

	<cfset mg.addEventListener("message", this, "stub_listenerFunction") />
	
	<cfset listeners = mg.getEventListeners("message") />
	<cfset assertTrue(arrayLen(listeners) eq 2, "should have 2 listeners after second add") />
	
</cffunction>

<cffunction name="stub_listenerFunction">
</cffunction>

<!--- EVENT HANDLER REGISTRATION TESTS --->
<cffunction name="testAddEventHandler" returntype="void" access="public">
	<cfset var mg = createModelGlue() />
	<cfset var eh = createEventHandler() />
	
	<cfset eh.name = "eventHandler" />
	
	<cfset mg.addEventHandler(eh) />

	<cfset eh = mg.getEventHandler(eh.name) />
	
	<cfset assertTrue(eh.name eq "eventHandler", "event handler not returned!") />
</cffunction>

<!--- PHASED INVOCATION TESTS --->
<cffunction name="testPhase_Initialization" returntype="void" access="public">
	<cfset var mg = createBootstrappedModelGlue() />
	
	<cfset mg.handleRequest() />
	
	<cfset assertTrue(getMetadata(application.modelglue).name eq "ModelGlue.gesture.ModelGlue", "ModelGlue not in app scope!") />
</cffunction>

<cffunction name="testPhase_Population" returntype="void" access="public">
	<cfset var mg = createBootstrappedModelGlue() />
	<cfset var context = "" />

	<cfset structClear(form) />
	<cfset structClear(url) />

	<cfset form.someFormKey = "someFormValue" />
	<cfset url.someUrlKey = "someUrlValue" />
	<cfset form.conflictKey = "formConflictValue" />
	<cfset url.conflictKey = "urlConflictValue" />
	
	<cfset context = mg.handleRequest()  />
	
	<cfset assertTrue(context.getValue("someFormKey") eq "someFormValue", "form value not populated") />
	<cfset assertTrue(context.getValue("someUrlKey") eq "someUrlValue", "form value not populated") />
	<cfset assertTrue(context.getValue("conflictKey") eq "formConflictValue", "conflict value not recognized from form") />
		
</cffunction>

<cffunction name="testPhase_StatefulRedirectPopulation" returntype="void" access="public">
	<cfset var mg = createBootstrappedModelGlue() />
	<cfset var context = "" />

	<cfset structClear(form) />
	<cfset structClear(url) />
	
	<cfset form.conflictKey = "formConflictValue" />

	<cfset session._modelgluePreservedState.preservedValueName = "preservedValue" /> 	
	<cfset session._modelgluePreservedState.conflictKey = "sessionConflictValue" /> 	
	<cfset context = mg.handleRequest()  />
	
	<cfset assertTrue(context.getValue("preservedValueName") eq "preservedValue", "preserved value not populated") />
	<cfset assertFalse(structKeyExists(session, "_modelgluePreservedState"), "preserved state not cleared") />
	<cfset assertTrue(context.getValue("conflictKey") eq "formConflictValue", "conflict value not recognized from form") />
</cffunction>

</cfcomponent>