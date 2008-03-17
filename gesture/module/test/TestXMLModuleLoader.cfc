<cfcomponent extends="mxunit.framework.TestCase">
	
<cffunction name="createBootstrapper" access="private">
	<cfreturn createObject("component", "ModelGlue.gesture.loading.ColdSpringBootstrapper") />
</cffunction>

<cffunction name="testSimpleXMLModule" returntype="void" access="public">
	<cfset var boot = createBootstrapper() />
	<cfset var mg = "" />
	<cfset var loader = "" />
	<cfset var obj = "" />
	<cfset var controllerVars = "" />
	<cfset var beanFactory = "" />

	<cfset boot.coldspringPath = "/ModelGlue/gesture/loading/test/ColdSpring.xml" />
	
	<cfset mg = boot.createModelGlue() />
	
	<cfset beanFactory = mg.getInternalBeanFactory() />
	<cfset beanFactory.loadBeans(expandPath("/ModelGlue/gesture/externaladapters/beaninjection/test/ColdSpring.xml")) />
	
	<cfset loader = mg.getInternalBean("modelglue.ModuleLoaderFactory").create("XML") />
	
	<cfset loader.load(mg, "/ModelGlue/gesture/module/test/simpleXmlModule.xml") />
	
	<!--- Test controller loading --->
	<cfset assertTrue(mg.hasEventListener("messageName"), "No listeners for messageName found") />
	<cfset obj = mg.getEventListeners("messageName") />
	<cfset assertTrue(arrayLen(obj) eq 1, "Incorrect number of listeners found (should be 1, was #arrayLen(obj)#)") />
	<cfset obj = obj[1] />
	<cfset assertTrue(GetMetadata(obj.target).name eq "ModelGlue.gesture.module.test.Controller", "Controller not of right type") />
	<cfset assertTrue(obj.listenerFunction eq "listener", "listener function not right name") />

	<!--- Test controller bean injection / autowiring --->
	<cfset ctrl = mg.getController("controller") />
	<cfset assertTrue(structKeyExists(ctrl, "_modelGlueBeanInjection_getVariablesScope"), "injection hooks not created in controller") />
	<cfset controllerVars = ctrl._modelGlueBeanInjection_getVariablesScope() />
	<cfset assertTrue(structKeyExists(controllerVars, "beans"), "beans scope not created") />
	<cfset assertTrue(structKeyExists(controllerVars.beans, "bean") and isObject(controllerVars.beans.bean), "beans.bean not existent or not object") />
	<cfset assertTrue(isObject(ctrl.getBean2()), "controller not autowired") />
	
	<!--- Test event handler loading --->
	<cfset obj = mg.getEventHandler("eventHandlerName") />
	<cfset assertTrue(isObject(obj), "event handler not object!") />
	<cfset assertTrue(obj.access eq "accessValue", "accessValue not set") />
	<cfset assertTrue(obj.cache eq "cacheValue", "cacheValue not set") />
	<cfset assertTrue(obj.cacheKey eq "cacheKeyValue", "cacheKey not set") />
	<cfset assertTrue(obj.cacheTimeout eq 42, "cacheTimeout not set") />
	
	<!--- Messages --->
	<cfset assertTrue(arrayLen(obj.messages.cfNullKeyWorkaround) eq 1, "message not found or more than one message found") />
	<cfset assertTrue(obj.messages.cfNullKeyWorkaround[1].name eq "messageName", "message name not set") />
	<cfset assertTrue(obj.messages.cfNullKeyWorkaround[1].arguments.getValue("argumentName") eq "argumentValue", "argument value not set (result = '#obj.messages.cfNullKeyWorkaround[1].arguments.getValue("argumentName")#')") />

	<!--- Results --->
	<cfset assertTrue(structCount(obj.results.cfNullKeyWorkaround) eq 2, "results not found or two results not found") />
	<cfset assertTrue(arrayLen(obj.results.cfNullKeyWorkaround.resultName) eq 1, "resultName result not  found or more than one result mapped") />
	<cfset assertTrue(obj.results.cfNullKeyWorkaround.resultName[1].event eq "eventName", "resultName event prop misdefined") />
	<cfset assertTrue(obj.results.cfNullKeyWorkaround.resultName[1].redirect, "resultName redirect prop misdefined") />
	<cfset assertTrue(obj.results.cfNullKeyWorkaround.resultName[1].append eq "appendValue", "resultName append prop misdefined") />
	<cfset assertTrue(obj.results.cfNullKeyWorkaround.resultName[1].anchor eq "anchorValue", "resultName anchor prop misdefined") />
	<cfset assertFalse(obj.results.cfNullKeyWorkaround.resultName[1].preservestate, "resultName preservestate prop misdefined") />

	<cfset assertTrue(arrayLen(obj.results.cfNullKeyWorkaround.cfNullKeyWorkaround) eq 1, "implicit result result not  found or more than one result mapped") />
	<cfset assertTrue(obj.results.cfNullKeyWorkaround.cfNullKeyWorkaround[1].event eq "implicitEventName", "implicit result event prop misdefined") />
	<cfset assertTrue(obj.results.cfNullKeyWorkaround.cfNullKeyWorkaround[1].redirect, "implicit result redirect prop misdefined") />
	<cfset assertTrue(obj.results.cfNullKeyWorkaround.cfNullKeyWorkaround[1].append eq "appendValue", "implicit result append prop misdefined") />
	<cfset assertTrue(obj.results.cfNullKeyWorkaround.cfNullKeyWorkaround[1].anchor eq "anchorValue", "implicit result anchor prop misdefined") />
	<cfset assertFalse(obj.results.cfNullKeyWorkaround.cfNullKeyWorkaround[1].preservestate, "implicit result preservestate prop misdefined") />
	
	<!--- Views --->
	<cfset assertTrue(arrayLen(obj.views.cfNullKeyWorkaround) eq 1, "view not found or more than one view found") />
	<cfset assertTrue(obj.views.cfNullKeyWorkaround[1].name eq "viewName", "view name not set") />
	<cfset assertTrue(obj.views.cfNullKeyWorkaround[1].template eq "templateName", "view template not set") />
	<cfset assertTrue(structCount(obj.views.cfNullKeyWorkaround[1].values) eq 1, "number of values is not one") />
	<cfset assertTrue(structKeyExists(obj.views.cfNullKeyWorkaround[1].values, "valueName"), "value named ""valuename"" not found") />
	<cfset assertTrue(obj.views.cfNullKeyWorkaround[1].values.valueName.name eq "valueName", "valueName value not named valueName (ugh, that's confusing.)") />	
	<cfset assertTrue(obj.views.cfNullKeyWorkaround[1].values.valueName.value eq "valueValue", "valueName value not set to valueValue") />	
	<cfset assertFalse(obj.views.cfNullKeyWorkaround[1].values.valueName.overwrite eq "valueValue", "valueName value wasn't set to not overwrite") />	
	<cfset assertTrue(obj.views.cfNullKeyWorkaround[1].cache eq "cacheValue", "cacheValue not set on view") />
	<cfset assertTrue(obj.views.cfNullKeyWorkaround[1].cacheKey eq "cacheKeyValue", "cacheKey not set on view") />
	<cfset assertTrue(obj.views.cfNullKeyWorkaround[1].cacheTimeout eq 42, "cacheTimeout not set on view") />
	
</cffunction>

<cffunction name="testFormattedXMLModule" returntype="void" access="public">
	<cfset var boot = createBootstrapper() />
	<cfset var mg = "" />
	<cfset var loader = "" />
	<cfset var obj = "" />
	<cfset var controllerVars = "" />
	<cfset var beanFactory = "" />

	<cfset boot.coldspringPath = "/ModelGlue/gesture/loading/test/ColdSpring.xml" />
	
	<cfset mg = boot.createModelGlue() />
	
	<cfset beanFactory = mg.getInternalBeanFactory() />
	<cfset beanFactory.loadBeans(expandPath("/ModelGlue/gesture/externaladapters/beaninjection/test/ColdSpring.xml")) />
	
	<cfset loader = mg.getInternalBean("modelglue.ModuleLoaderFactory").create("XML") />
	
	<cfset loader.load(mg, "/ModelGlue/gesture/module/test/formattedXmlModule.xml") />
	
	<!--- Test event handler loading --->
	<cfset obj = mg.getEventHandler("eventHandlerName") />
	<cfset assertTrue(isObject(obj), "event handler not object!") />
	
	<!--- Messages --->
	<cfset assertTrue(arrayLen(obj.messages.explicitFormat) eq 1, "message not found or more than one message found") />
	<cfset assertTrue(obj.messages.explicitFormat[1].name eq "formatMessageName", "message name not set") />

	<!--- Results --->
	<cfset assertTrue(structCount(obj.results.explicitFormat) eq 2, "results not found or two results not found") />
	<cfset assertTrue(arrayLen(obj.results.explicitFormat.formatResultName) eq 1, "resultName result not  found or more than one result mapped") />
	<cfset assertTrue(obj.results.explicitFormat.formatResultName[1].event eq "formatEventName", "resultName event prop misdefined") />

	<cfset assertTrue(arrayLen(obj.results.explicitFormat.cfNullKeyWorkaround) eq 1, "implicit result result not  found or more than one result mapped") />
	<cfset assertTrue(obj.results.explicitFormat.cfNullKeyWorkaround[1].event eq "formatImplicitEventName", "implicit result event prop misdefined") />
	
	<!--- Views --->
	<cfset assertTrue(arrayLen(obj.views.explicitFormat) eq 1, "view not found or more than one view found") />
	<cfset assertTrue(obj.views.explicitFormat[1].name eq "formatViewName", "view name not set") />
	
</cffunction>

<cffunction name="testCacheKeyConventions" returntype="void" access="public">
	<cfset var boot = createBootstrapper() />
	<cfset var mg = "" />
	<cfset var loader = "" />
	<cfset var obj = "" />
	<cfset var controllerVars = "" />
	<cfset var beanFactory = "" />

	<cfset boot.coldspringPath = "/ModelGlue/gesture/loading/test/ColdSpring.xml" />
	
	<cfset mg = boot.createModelGlue() />
	
	<cfset beanFactory = mg.getInternalBeanFactory() />
	<cfset beanFactory.loadBeans(expandPath("/ModelGlue/gesture/externaladapters/beaninjection/test/ColdSpring.xml")) />
	
	<cfset loader = mg.getInternalBean("modelglue.ModuleLoaderFactory").create("XML") />
	
	<cfset loader.load(mg, "/ModelGlue/gesture/module/test/simpleXmlModule.xml") />
	
	<!--- applicationCacheKeyConventions --->
	<cfset obj = mg.getEventHandler("applicationCacheKeyConventions") />
	<cfset assertTrue(obj.cacheKey eq "application.eventHandler.applicationCacheKeyConventions", "app event cache key not set") />
	<cfset assertTrue(obj.views.cfNullKeyWorkaround[1].cacheKey eq "application.eventHandler.applicationCacheKeyConventions.view.1", "app view cache key not set") />
	
	<!--- sessionCacheKeyConventions --->
	<cfset obj = mg.getEventHandler("sessionCacheKeyConventions") />
	<cfset assertTrue(obj.cacheKey eq "session.eventHandler.sessionCacheKeyConventions", "session event cache key not set") />
	<cfset assertTrue(obj.views.cfNullKeyWorkaround[1].cacheKey eq "session.eventHandler.sessionCacheKeyConventions.view.1", "session view cache key not set") />
</cffunction>

<cffunction name="testIncludeStyleMasterXMLModule" returntype="void" access="public">
	<cfset var boot = createBootstrapper() />
	<cfset var mg = "" />
	<cfset var loader = "" />
	<cfset var obj = "" />
	<cfset var beanFactory = "" />
	
	<cfset boot.coldspringPath = "/ModelGlue/gesture/loading/test/ColdSpring.xml" />
	
	<cfset mg = boot.createModelGlue() />
	
	<cfset beanFactory = mg.getInternalBeanFactory() />
	<cfset beanFactory.loadBeans(expandPath("/ModelGlue/gesture/externaladapters/beaninjection/test/ColdSpring.xml")) />
	
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
	<cfset var beanFactory = "" />
	
	<cfset boot.coldspringPath = "/ModelGlue/gesture/loading/test/ColdSpring.xml" />
	
	<cfset mg = boot.createModelGlue() />
	
	<cfset beanFactory = mg.getInternalBeanFactory() />
	<cfset beanFactory.loadBeans(expandPath("/ModelGlue/gesture/externaladapters/beaninjection/test/ColdSpring.xml")) />
	
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
	<cfset var beanFactory = "" />
	
	<cfset boot.coldspringPath = "/ModelGlue/gesture/loading/test/ColdSpring.xml" />
	
	<cfset mg = boot.createModelGlue() />
	
	<cfset loader = mg.getInternalBean("modelglue.ModuleLoaderFactory").create("XML") />
	
	<cfset loader.load(mg, "/ModelGlue/gesture/module/test/recursiveXmlModule.xml") />
	
	<!--- Not going into an infinite loop = passing. --->	
</cffunction>

<cffunction name="testSettingParsing_arbitrary" returntype="void" access="public">
	<cfset var boot = createBootstrapper() />
	<cfset var mg = "" />
	<cfset var loader = "" />
	<cfset var obj = "" />
	<cfset var beanFactory = "" />
	
	<cfset boot.coldspringPath = "/ModelGlue/gesture/loading/test/ColdSpring.xml" />
	
	<cfset mg = boot.createModelGlue() />
	
	<cfset beanFactory = mg.getInternalBeanFactory() />
	<cfset beanFactory.loadBeans(expandPath("/ModelGlue/gesture/externaladapters/beaninjection/test/ColdSpring.xml")) />
	
	<cfset loader = mg.getInternalBean("modelglue.ModuleLoaderFactory").create("XML") />

	<cfset loader.load(mg, "/ModelGlue/gesture/module/test/simpleXmlModule.xml") />

	<cfset assertTrue(mg.getConfigSetting("arbitrarySetting") eq "arbitrarySettingValue", "arbitrary setting not set") />
</cffunction>

<cffunction name="testSettingParsing_viewMappings" returntype="void" access="public">
	<cfset var boot = createBootstrapper() />
	<cfset var mg = "" />
	<cfset var loader = "" />
	<cfset var obj = "" />
	<cfset var viewRenderer = "" />
	<cfset var beanFactory = "" />
	
	<cfset boot.coldspringPath = "/ModelGlue/gesture/loading/test/ColdSpring.xml" />
	
	<cfset mg = boot.createModelGlue() />
	
	<cfset beanFactory = mg.getInternalBeanFactory() />
	<cfset beanFactory.loadBeans(expandPath("/ModelGlue/gesture/externaladapters/beaninjection/test/ColdSpring.xml")) />
	
	<cfset loader = mg.getInternalBean("modelglue.ModuleLoaderFactory").create("XML") />

	<cfset mg.setConfigSetting("viewMappings", "initialViewMapping") />
	
	<cfset loader.load(mg, "/ModelGlue/gesture/module/test/simpleXmlModule.xml") />

	<cfset assertTrue(mg.getConfigSetting("viewMappings") eq "initialViewMapping,viewMappingsValue", "viewMappingsValue not appended (was: '#mg.getConfigSetting("viewMappings")#')") />
	
	<cfset viewRenderer = mg.getInternalBean("modelglue.viewRenderer") />
	
	<cfset assertTrue(arrayToList(viewRenderer.getViewMappings()) eq "initialViewMapping,viewMappingsValue", "viewMappingsValue not in viewRenderer's mappings (was: '#arrayToList(viewRenderer.getViewMappings())#')") />
	
</cffunction>

<cffunction name="testSettingParsing_beanMappings_coldSpring" returntype="void" access="public">
	<cfset var boot = createBootstrapper() />
	<cfset var mg = "" />
	<cfset var loader = "" />
	<cfset var obj = "" />
	<cfset var beanFactory = "" />
	
	<cfset boot.coldspringPath = "/ModelGlue/gesture/loading/test/ColdSpring.xml" />
	
	<cfset mg = boot.createModelGlue() />
	
	<cfset beanFactory = mg.getInternalBeanFactory() />
	<cfset beanFactory.loadBeans(expandPath("/ModelGlue/gesture/externaladapters/beaninjection/test/ColdSpring.xml")) />
	
	<cfset loader = mg.getInternalBean("modelglue.ModuleLoaderFactory").create("XML") />

	<cfset mg.setConfigSetting("viewMappings", "initialViewMapping") />
	
	<cfset loader.load(mg, "/ModelGlue/gesture/module/test/simpleXmlModule.xml") />
	
	<cfset obj = mg.getBean("mapCollection") />

	<!--- If we don't throw error, we made it. --->
</cffunction>
	
</cfcomponent>