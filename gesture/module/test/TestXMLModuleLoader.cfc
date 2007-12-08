<cfcomponent extends="org.cfcunit.framework.TestCase">
	
<cffunction name="createBootstrapper" access="private">
	<cfreturn createObject("component", "ModelGlue.gesture.loading.ColdSpringBootstrapper") />
</cffunction>

<cffunction name="testSimpleXMLModule" returntype="void" access="public">
	<cfset var boot = createBootstrapper() />
	<cfset var mg = "" />
	<cfset var loader = "" />
	<cfset var obj = "" />
	
	<cfset boot.coldspringPath = "/ModelGlue/gesture/loading/test/ColdSpring.xml" />
	
	<cfset mg = boot.createModelGlue() />
	
	<cfset loader = mg.getInternalBean("modelglue.ModuleLoaderFactory").create("XML") />
	
	<cfset loader.load(mg, "/ModelGlue/gesture/module/test/simpleXmlModule.xml") />
	
	<!--- Test controller loading --->
	<cfset assertTrue(mg.hasEventListener("messageName"), "No listeners for messageName found") />
	<cfset obj = mg.getEventListeners("messageName") />
	<cfset assertTrue(arrayLen(obj) eq 1, "Incorrect number of listeners found (should be 1, was #arrayLen(obj)#)") />
	<cfset obj = obj[1] />
	<cfset assertTrue(GetMetadata(obj.target).name eq "ModelGlue.gesture.module.test.Controller", "Controller not of right type") />
	<cfset assertTrue(obj.listenerFunction eq "listener", "listener function not right name") />
	
	
	<!--- Test event handler loading --->
	
	<!---
	<event-handlers>
		<event-handler name="eventHandlerName">
			<broadcasts>
				<message name="messageName">
					<argument name="argumentName" value="argumentValue" />
				</message>
			</broadcasts>
			<results>
				<result name="resultName" do="eventName" redirect="true" append="appendValue" anchor="anchorValue" preserveState="false" />
				<result do="implicitEventName" redirect="true" append="appendValue" anchor="anchorValue" preserveState="false" />
			</results>
			<views>
				<include name="viewName" template="templateName">
					<value name="valueName" value="valueValue" overwrite="false" />
				</include>
			</views>
		</event-handler>
	</event-handlers>
	--->
	
	<cfset obj = mg.getEventHandler("eventHandlerName") />
	<cfset assertTrue(isObject(obj), "event handler not object!") />
	
	<!--- Messages --->
	<cfset assertTrue(arrayLen(obj.messages) eq 1, "message not found or more than one message found") />
	<cfset assertTrue(obj.messages[1].name eq "messageName", "message name not set") />
	<cfset assertTrue(obj.messages[1].arguments.getValue("argumentName") eq "argumentValue", "argument value not set (result = '#obj.messages[1].arguments.getValue("argumentName")#')") />

	<!--- Results --->
	<cfset assertTrue(structCount(obj.results) eq 2, "results not found or two results not found") />
	<cfset assertTrue(arrayLen(obj.results.resultName) eq 1, "resultName result not  found or more than one result mapped") />
	<cfset assertTrue(obj.results.resultName[1].event eq "eventName", "resultName event prop misdefined") />
	<cfset assertTrue(obj.results.resultName[1].redirect, "resultName redirect prop misdefined") />
	<cfset assertTrue(obj.results.resultName[1].append eq "appendValue", "resultName append prop misdefined") />
	<cfset assertTrue(obj.results.resultName[1].anchor eq "anchorValue", "resultName anchor prop misdefined") />
	<cfset assertFalse(obj.results.resultName[1].preservestate, "resultName preservestate prop misdefined") />

	<cfset assertTrue(arrayLen(obj.results[""]) eq 1, "implicit result result not  found or more than one result mapped") />
	<cfset assertTrue(obj.results[""][1].event eq "implicitEventName", "implicit result event prop misdefined") />
	<cfset assertTrue(obj.results[""][1].redirect, "implicit result redirect prop misdefined") />
	<cfset assertTrue(obj.results[""][1].append eq "appendValue", "implicit result append prop misdefined") />
	<cfset assertTrue(obj.results[""][1].anchor eq "anchorValue", "implicit result anchor prop misdefined") />
	<cfset assertFalse(obj.results[""][1].preservestate, "implicit result preservestate prop misdefined") />
	
	<!--- Views --->
	<cfset assertTrue(arrayLen(obj.views) eq 1, "view not found or more than one view found") />
	<cfset assertTrue(obj.views[1].name eq "viewName", "view name not set") />
	<cfset assertTrue(obj.views[1].template eq "templateName", "view template not set") />
	<cfset assertTrue(structCount(obj.views[1].values) eq 1, "number of values is not one") />
	<cfset assertTrue(structKeyExists(obj.views[1].values, "valueName"), "value named ""valuename"" not found") />
	<cfset assertTrue(obj.views[1].values.valueName.name eq "valueName", "valueName value not named valueName (ugh, that's confusing.)") />	
	<cfset assertTrue(obj.views[1].values.valueName.value eq "valueValue", "valueName value not set to valueValue") />	
	<cfset assertFalse(obj.views[1].values.valueName.overwrite eq "valueValue", "valueName value wasn't set to not overwrite") />	
	
</cffunction>


<cffunction name="testIncludeStyleMasterXMLModule" returntype="void" access="public">
	<cfset var boot = createBootstrapper() />
	<cfset var mg = "" />
	<cfset var loader = "" />
	<cfset var obj = "" />
	
	<cfset boot.coldspringPath = "/ModelGlue/gesture/loading/test/ColdSpring.xml" />
	
	<cfset mg = boot.createModelGlue() />
	
	<cfset loader = mg.getInternalBean("modelglue.ModuleLoaderFactory").create("XML") />
	
	<cfset loader.load(mg, "/ModelGlue/gesture/module/test/includeStyleMasterXmlModule.xml") />
	
	<cfset assertTrue(mg.hasEventListener("messageName"), "No listeners for messageName found") />
	<cfset obj = mg.getEventHandler("eventHandlerName") />
	<cfset assertTrue(isObject(obj), "event handler not object!") />
</cffunction>

<cffunction name="testMasterXMLModule" returntype="void" access="public">
	<cfset var boot = createBootstrapper() />
	<cfset var mg = "" />
	<cfset var loader = "" />
	<cfset var obj = "" />
	
	<cfset boot.coldspringPath = "/ModelGlue/gesture/loading/test/ColdSpring.xml" />
	
	<cfset mg = boot.createModelGlue() />
	
	<cfset loader = mg.getInternalBean("modelglue.ModuleLoaderFactory").create("XML") />
	
	<cfset loader.load(mg, "/ModelGlue/gesture/module/test/masterXmlModule.xml") />
	
	<cfset assertTrue(mg.hasEventListener("messageName"), "No listeners for messageName found") />
	<cfset obj = mg.getEventHandler("eventHandlerName") />
	<cfset assertTrue(isObject(obj), "event handler not object!") />
</cffunction>

<cffunction name="testRecursiveXMLModule" returntype="void" access="public">
	<cfset var boot = createBootstrapper() />
	<cfset var mg = "" />
	<cfset var loader = "" />
	<cfset var obj = "" />
	
	<cfset boot.coldspringPath = "/ModelGlue/gesture/loading/test/ColdSpring.xml" />
	
	<cfset mg = boot.createModelGlue() />
	
	<cfset loader = mg.getInternalBean("modelglue.ModuleLoaderFactory").create("XML") />
	
	<cfset loader.load(mg, "/ModelGlue/gesture/module/test/recursiveXmlModule.xml") />
	
	<!--- Not going into an infinite loop = passing. --->	
</cffunction>

</cfcomponent>