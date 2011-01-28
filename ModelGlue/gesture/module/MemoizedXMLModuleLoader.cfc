<!---
LICENSE INFORMATION:

Copyright 2011, Joe Rinehart, Dan Wilson

Licensed under the Apache License, Version 2.0 (the "License"); you may not 
use this file except in compliance with the License. 

You may obtain a copy of the License at 

	http://www.apache.org/licenses/LICENSE-2.0 
	
Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR 
CONDITIONS OF ANY KIND, either express or implied. See the License for the 
specific language governing permissions and limitations under the License.

VERSION INFORMATION:

This file is part of @versionLabel@ (@versionNumber@).

The version number in parentheses is in the format versionNumber.subversion.revisionNumber.

If the version number appears as 'versionNumber' surrounded by @ symbols
then this file is a working copy and not part of a release build.
--->


<cfcomponent output="false" hint="I load various bits of the Model Glue config into objects.">


<!--- 

When we last left off, we were going to use the MemoizedModelGlue.cfc to store the parsed XML. 
This means we need to grab it out of this object and shove it in the MG object.
Furthermore, we need to update all the references in this CFC into the MG cfc.

Lastly, we need to rip out the configuration for this ModuleLoader and just have the regular XML Module Loader handle all of this.
 --->

<cffunction name="init" output="false">
	<cfset variables.eventTypes = structNew() />
	<cfset variables.parsedXML = "" />
	<cfreturn this />
</cffunction>

<cffunction name="load" output="false" access="public" returntype="void" hint="I load and parse the config recursively">
	<cfargument name="modelglue" type="ModelGlue.gesture.ModelGlue" hint="The instance of Model-Glue into which a module should be loaded.">
	<cfargument name="path" hint="The .XML file containing the module." />
	<cfargument name="loadedModules" type="struct" default="#structNew()#" hint="Location-keyed collection of modules loaded _during this loading request_ (prevents infinitely recursive loading)." />
	<cfset var moduleLoaderFactory = modelglue.getInternalBean("modelglue.ModuleLoaderFactory") />
	<cfset var parsedXML = "" />
	<cfset var modules = "" />
	<cfset var includes = "" />
	<cfset var loader = "" />
	<cfset var settingBlocks = "" />
	<cfset var i = "" />
	<!---<cfif structKeyExists( variables.hydrateImmediately, arguments.path) IS true AND structKeyExists(loadedModules, arguments.path) IS false>--->
		<!--- We want to use the XML Model Loader to process this immediately so we have a fully up and running Model Glue (I think) --->
	<cfif structKeyExists(loadedModules, arguments.path) IS false>
		<!--- Don't load a module twice. --->
		<cfset arguments.modelglue.ModuleLoaderArray( this ) />
		<cfset arguments.loadedModules[arguments.path] = true />
		<!--- This is a lazy loaded config so we need to process it, and follow the include trail --->
		<cfset parsedXML = loadConfig( arguments.path ) />
		<!--- We want to parse all XML and put it into memory. Ideally inside of a ColdFusion Query so we can manage state and ordinality --->
		<cfset variables.parsedXML = parsedXML />
		
			
		<!--- We load "down the chain" first so that higher-level event handlers override lower-level. --->
		<cfset modules = xmlSearch(parsedXML, "/modelglue/module") />
		<cfloop from="1" to="#arrayLen(modules)#" index="i">
			<cfparam name="modules[i].xmlAttributes.type" default="XML" />
			<cfset loader = moduleLoaderFactory.create(modules[i].xmlAttributes.type) />
			<cfset loader.load(arguments.modelglue, modules[i].xmlAttributes.location, arguments.loadedModules) />
		</cfloop>
		
		<cfset includes = xmlSearch(parsedXML, "/modelglue/include") />
		<cfloop from="1" to="#arrayLen(includes)#" index="i">
			<cfset loader = moduleLoaderFactory.create("XML") />
			<cfset loader.load(arguments.modelglue, includes[i].xmlAttributes.template, arguments.loadedModules) />
		</cfloop>
	
		<!--- Load settings since these aren't going to be cached --->
		<cfset settingBlocks = xmlSearch(parsedXML, "/modelglue/config") />
	
		<cfloop from="1" to="#arrayLen(settingBlocks)#" index="i">
			<cfset loadSettings(arguments.modelglue, settingBlocks[i]) />
		</cfloop>
	
	</cfif>
	
</cffunction>

<!--- 	Date: 8/23/2010  Usage: I load the config --->
<cffunction name="loadConfig" output="false" access="private" returntype="any" hint="I load the config">
	<cfargument name="path" hint="The .XML file containing the module." />
	<cfset var xml = "" />
	<!--- Expand path if needed. --->
	<!--- try/catch required to work in sandboxed environment --->
	<cftry>
		<cfif not fileExists(arguments.path) and fileExists(expandPath(arguments.path))>
			<cfset arguments.path = expandPath(arguments.path) />
		</cfif>
		<cfcatch>
			<cfset arguments.path = expandPath(arguments.path) />
		</cfcatch>
	</cftry>
		
	<cfif not fileExists(arguments.path)>
		<cfthrow message="The XML module to be loaded from ""#arguments.path#"" can't be loaded because the file can't be found or read."
						 type="ModelGlue.gesture.module.xmlModuleLoader.fileNotFound"
		/>
	</cfif>

	<cffile action="read" file="#arguments.path#" variable="xml" />

	<!--- 
		We don't wrap this in a try / catch:  the native XML parsing exception can be helpful in
		figuring out what is wrong.
	--->
	<cfreturn xmlParse(xml)>
</cffunction>

<cffunction name="loadControllers" output="false" hint="Loads controllers from <controllers> block.">
	<cfargument name="modelglue" />
	<cfargument name="controllersXML" />
	<cfset var ctrlInst = "" />
	<cfset var ctrlXml = "" />
	<cfset var i = "" />

	<cfloop from="1" to="#arrayLen(arguments.controllersXML.xmlChildren)#" index="i">
		<cfset ctrlXml = arguments.controllersXML.xmlChildren[i] />
		<cfset makeController( ctrlXml ) />
	</cfloop>
</cffunction>	

<cffunction name="findControllerDefinition" output="false" hint="Loads controller from controller block.">
	<cfargument name="configurationXML" />
	<cfargument name="ControllerName" type="string" default="" />
	<cfreturn xmlSearch( configurationXML, "/modelglue/controllers/controller[@id='#arguments.ControllerName#']" ) />
</cffunction>

<cffunction name="locateAndMakeController" output="false" hint="Loads Controller from controller block.">
	<cfargument name="modelglue" />
	<cfargument name="ControllerName" type="string" default="" />
	<cfset var i = "" />
	<cfset var controllerDefinitionArray = "" />
	<cfset var j = "" />
	
	<cfset controllerDefinitionArray = findControllerDefinition(variables.parsedXML, arguments.ControllerName ) />
	
	<cfloop from="1" to="#arrayLen( controllerDefinitionArray )#" index="j">
		<cfset makeController(arguments.modelglue, controllerDefinitionArray[j] ) />
	</cfloop>
</cffunction>

<cffunction name="makeController" output="false" hint="Makes a controller from a controller block.">
	<cfargument name="modelglue" />
	<cfargument name="ctrlXml" />
	<cfset var beanId = "" />
	<cfset var ctrlInst = "" />
	<cfset var ctrlVars = "" />
	<cfset var injector = arguments.modelglue.getInternalBean("modelglue.beanInjector") />	
	<cfset var listXml = "" />	
	<cfset var j = "" />
		
		<cfparam name="arguments.ctrlXml.xmlAttributes.type" default="" />
		<cfparam name="arguments.ctrlXml.xmlAttributes.bean" default="" />
		<cfparam name="arguments.ctrlXml.xmlAttributes.id" default="#arguments.ctrlXml.xmlAttributes.type#" />
		<cfparam name="arguments.ctrlXml.xmlAttributes.beans" default="" />
		<cfif len(arguments.ctrlXml.xmlAttributes.bean)>
			<cfset ctrlInst = arguments.modelGlue.getBean(arguments.ctrlXml.xmlAttributes.bean) />
		<cfelse>
			<cfset ctrlInst = createObject("component", arguments.ctrlXml.xmlAttributes.type).init(arguments.modelglue, arguments.ctrlXml.xmlAttributes.id) />
		</cfif>
		
		<!--- In case a controller constructor override doesn't do super() properly.... --->
		<cfset ctrlInst.setModelGlue(arguments.modelglue) />

		<!--- Create injection hooks --->
		<cfset injector.createInjectionHooks(ctrlInst) />
		
		<!--- Always create the "beans" scope, even though it's explicitly created if needed by inject() --->
		<cfset ctrlVars = ctrlInst._modelGlueBeanInjection_getVariablesScope() />
		<cfset ctrlVars.beans = structNew() />
		
		<!--- Inject the cache adapter into the "beans" scope --->
		<cfset ctrlVars.beans.CacheAdapter = arguments.modelglue.cacheAdapter />

		<!--- Perform bean injection: Metadata --->
		<cfset injector.injectBeanByMetadata(ctrlInst) />
		
		<!--- Perform bean injection: XML --->
		<cfloop list="#ctrlXml.xmlAttributes.beans#" index="beanId">
			<cfset injector.injectBean(beanId, ctrlInst) />
		</cfloop>
		
		<cfset injector.injectBeanByMetadata(ctrlInst) />
		<!--- Perform autowiring --->
		<cfset injector.autowire(ctrlInst) />
				
		<!--- Add event listeners --->
		<cfloop from="1" to="#arrayLen(arguments.ctrlXml.xmlChildren)#" index="j">
			<cfset listXml = arguments.ctrlXml.xmlChildren[j] />
			<cfparam name="listXml.xmlAttributes.function" default="" />
			<!--- Function is optional and will be the message, unless explicitly provided --->
			<cfif  len( trim( listXml.xmlAttributes.function ) ) IS 0>
				<cfset listXml.xmlAttributes.function = listXml.xmlAttributes.message >
			</cfif>
			<cfset modelglue.addEventListener(listXml.xmlAttributes.message, ctrlInst, listXml.xmlAttributes.function) />
			<cfset modelglue.addController(arguments.ctrlXml.xmlAttributes.id, ctrlInst) />
		</cfloop>
</cffunction>
	
<cffunction name="loadEventHandlers" output="false" hint="Loads event-handlers from <event-handlers> block.">
	<cfargument name="modelglue" />
	<cfargument name="handlersXML" />
	<cfset var ehXml = "" />
	<cfset var ehInst = "" />
	<cfset var i = "" />
	
	
	<cfloop from="1" to="#arrayLen(arguments.handlersXML.xmlChildren)#" index="i">
		<cfset ehXml = arguments.handlersXML.xmlChildren[i] />
		
		<cfif ehXml.xmlName eq "event-handler">
			<cfset makeEventHandler( modelglue:modelglue, ehXML:ehXml ) />
		</cfif>

	</cfloop>
</cffunction>	

<cffunction name="hasEventHandlerDefinition" output="false" hint="Loads event-handlers from <event-handlers> block.">
	<cfargument name="modelglue" type="ModelGlue.gesture.ModelGlue" hint="The instance of Model-Glue into which a module should be loaded.">
	<cfargument name="eventHandlerName" type="string" default="" />
	<cfreturn arrayLen( findEventHandlerDefinition(variables.parsedXML, arguments.eventHandlerName ) ) />
</cffunction>

<cffunction name="findEventHandlerDefinition" output="false" hint="Loads event-handlers from <event-handlers> block.">
	<cfargument name="configurationXML" />
	<cfargument name="eventHandlerName" type="string" default="" />
	<cfreturn xmlSearch( arguments.configurationXML, "/modelglue/event-handlers/event-handler[@name='#arguments.eventHandlerName#']" )/>
</cffunction>

<cffunction name="locateAndMakeEventHandler" output="false" hint="Loads event-handlers from <event-handlers> block.">
	<cfargument name="modelglue" />
	<cfargument name="eventHandlerName" type="string" default="" />
	<cfset var eventHandlerDefinitionArray = "" />
	<cfset var j = "" />
	
	<!--- Since the last one loaded wins, let's start from the end --->
	<cfset eventHandlerDefinitionArray = findEventHandlerDefinition(variables.parsedXML, arguments.eventHandlerName ) />
	
	<cfloop from="1" to="#arrayLen( eventHandlerDefinitionArray)#" index="j">
		<cfset makeEventHandler(arguments.modelglue, eventHandlerDefinitionArray[j] )  />
	</cfloop>
</cffunction>

<cffunction name="makeEventHandler" output="false" hint="Loads event-handlers from <event-handlers> block.">
	<cfargument name="modelglue" />
	<cfargument name="ehXML" type="string" required="true"/>
	<cfset var ehInst = "" />
	<cfset var childXml = "" />
	<cfset var ehFactory = arguments.modelglue.getInternalBean("modelglue.EventHandlerFactory") />
	<!--- existence of a single type key or a list causes this to be xml-defined typed event --->
	<cfset var isXmlTypeList = false />
	<cfset var i = "" />
	<!--- Make some sensible defaults --->
	<cfparam name="arguments.handlersXML.XmlAttributes.defaultType" default="EventHandler" />
	<cfparam name="arguments.ehXml.xmlAttributes.type" default="#arguments.handlersXML.XmlAttributes.defaultType#" />
	<cfparam name="arguments.ehXml.xmlAttributes.access" default="public" />
	<cfparam name="arguments.ehXml.xmlAttributes.cache" default="false" />
	<cfparam name="arguments.ehXml.xmlAttributes.cacheKey" default="" />
	<cfparam name="arguments.ehXml.xmlAttributes.cacheKeyValues" default="" />
	<cfparam name="arguments.ehXml.xmlAttributes.cacheTimeout" default="0" />
	<cfparam name="arguments.ehXml.xmlAttributes.extensible" default="false" />
	<cfset isXmlTypeList = structKeyExists(variables.eventTypes, arguments.ehXml.xmlAttributes.type) or find(",", arguments.ehXml.xmlAttributes.type) />

		<cftry>
			<!--- If the event-handler already exists, get a reference to it --->
			<cfif arguments.modelglue.hasEventHandler(arguments.ehXml.xmlAttributes.name)>
				<cfset ehInst = arguments.modelglue.getEventHandler(arguments.ehXml.xmlAttributes.name) />
				
				<!--- If it's not an "extensible" event-handler, create a new eh object--->
				<cfif not ehInst.extensible>
					<cfset ehInst = ehFactory.create("EventHandler") />
				</cfif>
			<!--- Otherwise, try to instantiate the type. --->
			<cfelse>
				<cfset ehInst = ehFactory.create(arguments.ehXml.xmlAttributes.type) >
			</cfif>
			<!--- If the type is not found, force a base EventHandler to be created --->
			<cfcatch>
				<cfset ehInst = ehFactory.create("EventHandler") />
			</cfcatch>
		</cftry>
		
		<cfset ehInst.beforeConfiguration() />
		
		<!--- If an XML-defined type is defined, load its "before" elements --->
		<cfif isXmlTypeList>
			<cfset addTypedElementsToEventHandler("before", ehInst, arguments.ehXml.xmlAttributes.type) />
		</cfif>
					
		<cfset ehInst.name = arguments.ehXml.xmlAttributes.name />
		<cfset ehInst.access = arguments.ehXml.xmlAttributes.access />
		
		<cfif isBoolean(arguments.ehXml.xmlAttributes.cache)>
			<cfset ehInst.cache = arguments.ehXml.xmlAttributes.cache />
		</cfif>
		<cfset ehInst.cacheKey = arguments.ehXml.xmlAttributes.cacheKey />
		<cfset ehInst.cacheKeyValues = arguments.ehXml.xmlAttributes.cacheKeyValues />
		<cfset ehInst.cacheTimeout = arguments.ehXml.xmlAttributes.cacheTimeout />
		
		<cfif len(ehInst.cache) and not len(ehInst.cacheKey)>
			<cfset ehInst.cacheKey = "eventHandler." & ehInst.name />
		</cfif>

		<cfif isBoolean(arguments.ehXml.xmlAttributes.extensible)>
			<cfset ehInst.extensible = arguments.ehXml.xmlAttributes.extensible />
		</cfif>
		
		<!--- Load messages --->
		<cfset childXml = xmlSearch(arguments.ehXml, "broadcasts") />
		
		<cfloop from="1" to="#arrayLen(childXml)#" index="i">
			<cfset loadMessages(ehInst, childXml[i]) />
		</cfloop>
		
		<!--- Load results --->
		<cfset childXml = xmlSearch(arguments.ehXml, "results") />
		
		<cfloop from="1" to="#arrayLen(childXml)#" index="i">
			<cfset loadResults(ehInst, childXml[i]) />
		</cfloop>
		
		
		<!--- Load views --->
		<cfset childXml = xmlSearch(arguments.ehXml, "views") />
		
		<cfloop from="1" to="#arrayLen(childXml)#" index="i">
			<cfset loadViews(ehInst, childXml[i]) />
		</cfloop>
		
		<cfset ehInst.afterConfiguration() />

		<!--- If an XML-defined type is defined, load its "after" elements --->
		<cfif isXmlTypeList>
			<cfset addTypedElementsToEventHandler("after", ehInst, arguments.ehXml.xmlAttributes.type) />
		</cfif>

	<cfset arguments.modelglue.addEventHandler(ehInst) />

</cffunction>	


<cffunction name="loadMessages" output="false" hint="Loads messages from a <broadcasts> block into an event handler.">
	<cfargument name="eventHandler" />
	<cfargument name="broadcastsXml" />
	
	<cfset var msgXml = "" />
	<cfset var msgInst = "" />
	<cfset var argXml = "" />
	<cfset var i = "" />
	<cfset var j = "" />
	
	
	<cfloop from="1" to="#arrayLen(arguments.broadcastsXml.xmlChildren)#" index="i">
		<cfset msgXml = arguments.broadcastsXml.xmlChildren[i] />
		<cfset msgInst = createObject("component", "ModelGlue.gesture.eventhandler.Message") />
		
		<cfparam name="arguments.broadcastsXml.xmlAttributes.format" default="" />
	
		<cfset msgInst.name = msgXml.xmlAttributes.name />
		<cfset msgInst.format = arguments.broadcastsXml.xmlAttributes.format />
		
		<cfloop from="1" to="#arrayLen(msgXml.xmlChildren)#" index="j">
			<cfset argXml = msgXml.xmlChildren[j] />
			<cfset msgInst.arguments.setValue(argXml.xmlAttributes.name, argXml.xmlAttributes.value) />
		</cfloop>
		
		<cfset arguments.eventHandler.addMessage(msgInst) />
	</cfloop>
</cffunction>

<cffunction name="loadResults" output="false" hint="Loads results from a <results> block into an event handler.">
	<cfargument name="eventHandler" />
	<cfargument name="resultsXml" />

	<cfset var resXml = "" />
	<cfset var resInst = "" />
	<cfset var argXml = "" />
	<cfset var i = "" />
	<cfset var j = "" />
	
	
	<cfloop from="1" to="#arrayLen(arguments.resultsXml.xmlChildren)#" index="i">
		<cfset resXml = arguments.resultsXml.xmlChildren[i] />
		<cfset resInst = createObject("component", "ModelGlue.gesture.eventhandler.Result") />
		
		<cfparam name="arguments.resultsXml.xmlAttributes.format" default="" />
		
		<cfset resInst.format = arguments.resultsXml.xmlAttributes.format />
		
		<cfloop collection="#resXml.xmlAttributes#" item="j">
			<cfswitch expression="#j#">
				<cfcase value="do">
					<cfset resInst.event = resXml.xmlAttributes[j] />
				</cfcase>
				<cfcase value="redirect,preserveState">
					<cfif not isBoolean(resXml.xmlAttributes[j])>
						<cfthrow message="Error adding results for event handler ""#eventHandler.name#"": On a result tag, #j# must be a true/false value!" />						
					</cfif>
					<cfset resInst[j] = resXml.xmlAttributes[j] />
				</cfcase>
				<cfdefaultcase>
					<cfset resInst[j] = resXml.xmlAttributes[j] />
				</cfdefaultcase>
			</cfswitch>
		</cfloop>

		<cfset arguments.eventHandler.addResult(resInst) />
	</cfloop>
</cffunction>

<cffunction name="loadSettings" output="false" hint="Loads settings from <settings> block.">
	<cfargument name="modelglue" />
	<cfargument name="settingsXML" />
	
	<cfset var settingXml = "" />
	<cfset var val = "" />
	<cfset var i = "" />
	<cfset var j = "" />
	<cfset var tmpArray = "" />
	<cfset var iocAdapter = "" />
	
	<!--- First pass through settings to catch some (beanFactoryLoader) that must be caught _first_ --->
	<cfloop from="1" to="#arrayLen(arguments.settingsXML.xmlChildren)#" index="i">
		<cfset settingXml = arguments.settingsXML.xmlChildren[i] />
		
		<cfswitch expression="#settingXml.xmlAttributes.name#">
			<!--- 
				Reverse-compatibility hook:  "beanFactoryLoader" is a 1.x setting
				that allowed switching between ChiliBeans and ColdSpring.
				
				Now, if it's detected and set to the old ChiliBeans loader (which 
				doesn't even exist anymore!), we shift the IoC adapter to the
				ChiliBeansAdapter.
			---> 
			<cfcase value="beanFactoryLoader">
				<cfif settingXml.xmlAttributes.value eq "ModelGlue.Core.ChiliBeansLoader">
					<cfset iocAdapter = arguments.modelGlue.getIocAdapter() />
					
					<!--- If we're not currently using ChiliBeans, shift to it. --->
					<cfif getMetadata(iocAdapter).name neq "ModelGlue.gesture.externaladapters.ioc.ChiliBeansAdapter">
						<cfset iocAdapter = createObject("component", "ModelGlue.gesture.externaladapters.ioc.ChiliBeansAdapter").init("") />
						<cfset arguments.modelglue.setIocAdapter(iocAdapter) />
					</cfif>
			<!--- Check for legacy applications switching from ChiliBeans to ColdSpring ---> 
				<cfelseif settingXml.xmlAttributes.value eq "ModelGlue.Core.ColdSpringLoader">
					<cfset iocAdapter = arguments.modelGlue.getIocAdapter() />
					
					<!--- If we're not currently using ColdSpring, shift to it. --->
					<cfif getMetadata(iocAdapter).name neq "ModelGlue.gesture.externaladapters.ioc.ColdSpringAdapter">
						<cfset iocAdapter = createObject("component", "ModelGlue.gesture.externaladapters.ioc.ColdSpringAdapter").init() />
						<cfset iocAdapter.setBeanFactory(arguments.modelglue.getInternalBeanFactory()) />
						<cfset arguments.modelglue.setIocAdapter(iocAdapter) />
					</cfif>
					
				</cfif>
				
			</cfcase>
		</cfswitch>
	</cfloop>
	<cfloop from="1" to="#arrayLen(arguments.settingsXML.xmlChildren)#" index="i">
		<cfset settingXml = arguments.settingsXML.xmlChildren[i] />
		
		<cfswitch expression="#settingXml.xmlAttributes.name#">
			<cfcase value="beanMappings">
				<cfset iocAdapter = arguments.modelGlue.getIocAdapter() />
				<cfloop list="#settingXml.xmlAttributes.value#" index="j">
						<cfset iocAdapter.loadBeanDefinitionsFromFile(j) />
				</cfloop>
			</cfcase>
			<cfcase value="viewMappings">
				<!---
				<cfset val = arguments.modelGlue.getConfigSetting("viewMappings") />
				<cfset arrayAppend(val, settingXml.xmlAttributes.value) />
				--->
				<cfset tmpArray = listToArray(settingXml.xmlAttributes.value) />
				<cfloop from="1" to="#arrayLen(tmpArray)#" index="j">
					<cfset arrayAppend(arguments.modelglue.configuration.viewMappings, tmpArray[j]) />
					<!--- <cfset arguments.modelglue.getInternalBean("modelglue.viewRenderer").addViewMapping(tmpArray[j]) /> --->
				</cfloop>
				<!---
				<cfset arguments.modelglue.setConfigSetting("viewMappings", val) />
				--->
			</cfcase>
			<cfcase value="helperMappings">
				<cfset tmpArray = listToArray(settingXml.xmlAttributes.value) />
				<cfloop from="1" to="#arrayLen(tmpArray)#" index="j">
					<!--- Skip duplicate helper mappings to avoid duplicated helper injection later --->
					<cfif not ListFindNoCase(arguments.modelglue.configuration.helperMappings, tmpArray[j])>
						<cfset arguments.modelglue.configuration.helperMappings = listAppend( arguments.modelglue.configuration.helperMappings,  tmpArray[j] ) />
					</cfif>
				</cfloop>			
			</cfcase>
			<cfdefaultcase>
				<cfset arguments.modelglue.setConfigSetting(settingXml.xmlAttributes.name, settingXml.xmlAttributes.value) />
			</cfdefaultcase>
		</cfswitch>

	</cfloop>
		
</cffunction>	

<cffunction name="loadViews" output="false" hint="Loads views from a <views> block into an event handler.">
	<cfargument name="eventHandler" />
	<cfargument name="viewsXml" />
	
	<cfset var viewXml = "" />
	<cfset var viewInst = "" />
	<cfset var valueXml = "" />
	<cfset var valueInst = "" />
	<cfset var i = "" />
	<cfset var j = "" />

	<cfloop from="1" to="#arrayLen(arguments.viewsXml.xmlChildren)#" index="i">
		<cfset viewXml = arguments.viewsXml.xmlChildren[i] />
		<cfset viewInst = createObject("component", "ModelGlue.gesture.eventhandler.View") />
		
		<cfparam name="arguments.viewsXml.xmlAttributes.format" default="" />
		
		<cfset viewInst.name = viewXml.xmlAttributes.name />
		<cfset viewInst.template = viewXml.xmlAttributes.template />
		<cfset viewInst.format = arguments.viewsXml.xmlAttributes.format />
		
		<cfparam name="viewXml.xmlAttributes.append" default="false" />
		<cfparam name="viewXml.xmlAttributes.cache" default="false" />
		<cfparam name="viewXml.xmlAttributes.cacheKey" default="" />
		<cfparam name="viewXml.xmlAttributes.cacheKeyValues" default="" />
		<cfparam name="viewXml.xmlAttributes.cacheTimeout" default="0" />

		<cfset viewInst.append = viewXml.xmlAttributes.append />
		<cfif isBoolean(viewXml.xmlAttributes.cache)>
			<cfset viewInst.cache = viewXml.xmlAttributes.cache />
		</cfif>
		<cfset viewInst.cacheKey = viewXml.xmlAttributes.cacheKey />
		<cfset viewInst.cacheKeyValues = viewXml.xmlAttributes.cacheKeyValues />
		<cfset viewInst.cacheTimeout = viewXml.xmlAttributes.cacheTimeout />
		
		<cfif len(viewInst.cache) and not len(viewInst.cacheKey)>
			<cfset viewInst.cacheKey = "eventHandler." & arguments.eventHandler.name & ".view.#i#" />
		</cfif>

		<cfloop from="1" to="#arrayLen(viewXml.xmlChildren)#" index="j">
			<cfset valueXml = viewXml.xmlChildren[j] />
			<cfset valueInst = createObject("component", "ModelGlue.gesture.eventhandler.Value") />
			
			<cfset valueInst.name = valueXml.xmlAttributes.name />
			<cfset valueInst.value = valueXml.xmlAttributes.value />

			<cfif structKeyExists(valueXml.xmlAttributes, "overwrite")>
				<cfif not isBoolean(valueXml.xmlAttributes.overwrite)>
					<cfthrow message="Error adding view for event handler ""#eventHandler.name#"": On a view tag, overwrite must be a true/false value!" />						
				</cfif>
				<cfset valueInst.overwrite = valueXml.xmlAttributes.overwrite />
			</cfif>

			<cfset viewInst.addValue(valueInst) />
		</cfloop>

		<cfset arguments.eventHandler.addView(viewInst) />

	</cfloop>
</cffunction>	


</cfcomponent>
