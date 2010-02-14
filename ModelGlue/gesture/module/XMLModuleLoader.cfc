<cfcomponent output="false" hint="I load an XML-based module into an instance of Model-Glue.">

<cffunction name="init" output="false">
	<cfset variables.eventTypes = structNew() />
	
	<cfreturn this />
</cffunction>

<cffunction name="load" returntype="void" output="false" hint="I perform module loading.">
	<cfargument name="modelglue" type="ModelGlue.gesture.ModelGlue" hint="The instance of Model-Glue into which a module should be loaded.">
	<cfargument name="path" hint="The .XML file containing the module." />
	<cfargument name="loadedModules" type="struct" default="#structNew()#" hint="Location-keyed collection of modules loaded _during this loading request_ (prevents infinitely recursive loading)." />
	
	<cfset var xml = "" />
	<cfset var scaffoldBlocks = "" />
	<cfset var settingBlocks = "" />
	<cfset var controllerBlocks = "" />
	<cfset var etBlocks = "" />
	<cfset var ehBlocks = "" />
	<cfset var modules = "" />
	<cfset var includes = "" />
	<cfset var i = "" />
	<cfset var moduleLoaderFactory = modelglue.getInternalBean("modelglue.ModuleLoaderFactory") />
	<cfset var moduleLoader = "" />
	<cfset var loader = "" />
	
	<!--- Don't load a module twice. --->
	<cfif structKeyExists(loadedModules, arguments.path)>
		<cfreturn />
	</cfif>
	<cfset arguments.loadedModules[arguments.path] = true />
	
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
	<cfset xml = xmlParse(xml)>
	<!--- Load event types --->
	<cfset etBlocks = xmlSearch(xml, "/modelglue/event-types") />
	<cfloop from="1" to="#arrayLen(etBlocks)#" index="i">
		<cfset loadEventTypes(arguments.modelglue, etBlocks[i]) />
	</cfloop>

	<!--- Load scaffolding before the developer event generation so we respect customization --->
	<!--- Don't bother to take any hit at all unless indicated by the developer --->	
	<!--- I think I want to load this after the event types, because the event types might be useful somehow. Undecided. --->
	<cfif arguments.modelglue.getConfigSetting("rescaffold") IS true >	
		<cfset scaffoldBlocks = xmlSearch(xml, "//scaffold") />
		<cfif arrayLen( scaffoldBlocks ) GT 0 >
			<cfset loadScaffolds( arguments.modelglue, scaffoldBlocks ) />
		</cfif>
	</cfif>
	<cfif fileExists( expandPath( arguments.modelglue.getConfigSetting('scaffoldPath') ) ) IS true>
		<!--- This is recursive, but we are using the scaffold path as infiniteloop insurance. --->
		<cfset load( arguments.modelglue, expandPath( arguments.modelglue.getConfigSetting('scaffoldPath') ) , arguments.loadedModules) />
	</cfif>
	
	<!--- We load "down the chain" first so that higher-level event handlers override lower-level. --->
	<cfset modules = xmlSearch(xml, "/modelglue/module") />
	<cfloop from="1" to="#arrayLen(modules)#" index="i">
		<cfparam name="modules[i].xmlAttributes.type" default="XML" />
		<cfset loader = moduleLoaderFactory.create(modules[i].xmlAttributes.type) />
		<cfset loader.load(arguments.modelglue, modules[i].xmlAttributes.location, arguments.loadedModules) />
	</cfloop>
	<cfset includes = xmlSearch(xml, "/modelglue/include") />
	<cfloop from="1" to="#arrayLen(includes)#" index="i">
		<cfset loader = moduleLoaderFactory.create("XML") />
		<cfset loader.load(arguments.modelglue, includes[i].xmlAttributes.template, arguments.loadedModules) />
	</cfloop>

	<!--- Load settings --->
	<cfset settingBlocks = xmlSearch(xml, "/modelglue/config") />

	<cfloop from="1" to="#arrayLen(settingBlocks)#" index="i">
		<cfset loadSettings(arguments.modelglue, settingBlocks[i]) />
	</cfloop>
	
	<!--- Load controllers --->
	<cfset controllerBlocks = xmlSearch(xml, "/modelglue/controllers") />
	
	<cfloop from="1" to="#arrayLen(controllerBlocks)#" index="i">
		<cfset loadControllers(arguments.modelglue, controllerBlocks[i]) />
	</cfloop>

	<!--- Load ehs --->
	<cfset ehBlocks = xmlSearch(xml, "/modelglue/event-handlers") />

	<cfloop from="1" to="#arrayLen(ehBlocks)#" index="i">
		<cfset loadEventHandlers(arguments.modelglue, ehBlocks[i]) />
	</cfloop>

</cffunction>

<!--- PRIVATE --->
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

<cffunction name="loadControllers" output="false" hint="Loads controllers from <controllers> block.">
	<cfargument name="modelglue" />
	<cfargument name="controllersXML" />

	
	<cfset var injector = arguments.modelglue.getInternalBean("modelglue.beanInjector") />
	<cfset var ctrlInst = "" />
	<cfset var ctrlXml = "" />
	<cfset var listXml = "" />
	<cfset var ctrlVars = "" />
	<cfset var beanId = "" />
	<cfset var i = "" />
	<cfset var j = "" />

	<cfloop from="1" to="#arrayLen(arguments.controllersXML.xmlChildren)#" index="i">
		<cfset ctrlXml = arguments.controllersXML.xmlChildren[i] />
		
		<cfparam name="ctrlXml.xmlAttributes.type" default="" />
		<cfparam name="ctrlXml.xmlAttributes.bean" default="" />
		<cfparam name="ctrlXml.xmlAttributes.id" default="#ctrlXml.xmlAttributes.type#" />
		<cfparam name="ctrlXml.xmlAttributes.beans" default="" />
		
		<cfif len(ctrlXml.xmlAttributes.bean)>
			<cfset ctrlInst = arguments.modelGlue.getBean(ctrlXml.xmlAttributes.bean) />
		<cfelse>
			<cfset ctrlInst = createObject("component", ctrlXml.xmlAttributes.type).init(arguments.modelglue, ctrlXml.xmlAttributes.id) />
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
		<cfloop from="1" to="#arrayLen(ctrlXml.xmlChildren)#" index="j">
			<cfset listXml = ctrlXml.xmlChildren[j] />
			<cfparam name="listXml.xmlAttributes.function" default="" />
			<!--- Function is optional and will be the message, unless explicitly provided --->
			<cfif  len( trim( listXml.xmlAttributes.function ) ) IS 0>
				<cfset listXml.xmlAttributes.function = listXml.xmlAttributes.message >
			</cfif>
			<cfset modelglue.addEventListener(listXml.xmlAttributes.message, ctrlInst, listXml.xmlAttributes.function) />
			<cfset modelglue.addController(ctrlXml.xmlAttributes.id, ctrlInst) />
		</cfloop>
	</cfloop>
</cffunction>	

<cffunction name="loadEventTypes" output="false" hint="Loads event types from <event-types> block.">
	<cfargument name="modelglue" />
	<cfargument name="typesXML" />
	
	<cfset var etXml = "" />
	<cfset var et = "" />
	<cfset var i = "" />
	<cfset var nodeName = "" />
	<cfset var blockType = "" />
	
	<cfloop from="1" to="#arrayLen(arguments.typesXML.xmlChildren)#" index="i">
		<cfset etXml = arguments.typesXML.xmlChildren[i] /> 
		<cfset et = structNew() />
		<cfset et.name = etXml.xmlAttributes.name />
		
		<cfloop list="before,after" index="blockType">
			<cfset et[blockType] = structNew() />
			<cfloop list="broadcasts,results,views" index="nodeName">
				<cfif structKeyExists(etXml, blockType) and structKeyExists(etXml[blockType], nodeName)>
					<cfset et[blockType][nodeName] = etXml[blockType][nodeName] />
				</cfif>
			</cfloop>
		</cfloop>
			
		<!--- Don't allow overriding --->
		<cfif not structKeyExists(variables.eventTypes, et.name)>
			<cfset variables.eventTypes[et.name] = et />
		</cfif>	
	</cfloop>
</cffunction>

<cffunction name="loadEventHandlers" output="false" hint="Loads event-handlers from <event-handlers> block.">
	<cfargument name="modelglue" />
	<cfargument name="handlersXML" />
	
	<cfset var ehInst = "" />
	<cfset var ehXml = "" />
	<cfset var isXmlTypeList = false />
	<cfset var xmlTypeName = "" />
	<cfset var childXml = "" />
	<cfset var i = "" />
	<cfset var j = "" />
	<cfset var ehFactory = arguments.modelglue.getInternalBean("modelglue.EventHandlerFactory") />
	
	<cfloop from="1" to="#arrayLen(arguments.handlersXML.xmlChildren)#" index="i">
		<cfset ehXml = arguments.handlersXML.xmlChildren[i] />
		
		<cfif ehXml.xmlName eq "event-handler">
			<cfparam name="arguments.handlersXML.XmlAttributes.defaultType" default="EventHandler" />
			<cfparam name="ehXml.xmlAttributes.type" default="#arguments.handlersXML.XmlAttributes.defaultType#" />
			<cfparam name="ehXml.xmlAttributes.access" default="public" />
			<cfparam name="ehXml.xmlAttributes.cache" default="false" />
			<cfparam name="ehXml.xmlAttributes.cacheKey" default="" />
			<cfparam name="ehXml.xmlAttributes.cacheKeyValues" default="" />
			<cfparam name="ehXml.xmlAttributes.cacheTimeout" default="0" />
			<cfparam name="ehXml.xmlAttributes.extensible" default="false" />

			<!--- existence of a single type key or a list causes this to be xml-defined typed event --->
			<cfif structKeyExists(variables.eventTypes, ehXml.xmlAttributes.type)
						or find(",", ehXml.xmlAttributes.type)
			>
				<cfset isXmlTypeList = "true" />
			</cfif>

			<cftry>
				<!--- If the event-handler already exists, get a reference to it --->
				<cfif modelglue.hasEventHandler(ehXml.xmlAttributes.name)>
					<cfset ehInst = modelglue.getEventHandler(ehXml.xmlAttributes.name) />
					
					<!--- If it's not an "extensible" event-handler, create a new eh object--->
					<cfif not ehInst.extensible>
						<cfset ehInst = ehFactory.create("EventHandler") />
					</cfif>
				<!--- Otherwise, try to instantiate the type. --->
				<cfelse>
					<cfset ehInst = ehFactory.create(ehXml.xmlAttributes.type) >
				</cfif>
				<!--- If the type is not found, force a base EventHandler to be created --->
				<cfcatch>
					<cfset ehInst = ehFactory.create("EventHandler") />
				</cfcatch>
			</cftry>
			
			<cfset ehInst.beforeConfiguration() />
			
			<!--- If an XML-defined type is defined, load its "before" elements --->
			<cfif isXmlTypeList>
				<cfset addTypedElementsToEventHandler("before", ehInst, ehXml.xmlAttributes.type) />
			</cfif>
						
			<cfset ehInst.name = ehXml.xmlAttributes.name />
			<cfset ehInst.access = ehXml.xmlAttributes.access />
			
			<cfif isBoolean(ehXml.xmlAttributes.cache)>
				<cfset ehInst.cache = ehXml.xmlAttributes.cache />
			</cfif>
			<cfset ehInst.cacheKey = ehXml.xmlAttributes.cacheKey />
			<cfset ehInst.cacheKeyValues = ehXml.xmlAttributes.cacheKeyValues />
			<cfset ehInst.cacheTimeout = ehXml.xmlAttributes.cacheTimeout />
			
			<cfif len(ehInst.cache) and not len(ehInst.cacheKey)>
				<cfset ehInst.cacheKey = "eventHandler." & ehInst.name />
			</cfif>

			<cfif isBoolean(ehXml.xmlAttributes.extensible)>
				<cfset ehInst.extensible = ehXml.xmlAttributes.extensible />
			</cfif>
			
			<!--- Load messages --->
			<cfset childXml = xmlSearch(ehXml, "broadcasts") />
			
			<cfloop from="1" to="#arrayLen(childXml)#" index="i">
				<cfset loadMessages(ehInst, childXml[i]) />
			</cfloop>
			
			<!--- Load results --->
			<cfset childXml = xmlSearch(ehXml, "results") />
			
			<cfloop from="1" to="#arrayLen(childXml)#" index="i">
				<cfset loadResults(ehInst, childXml[i]) />
			</cfloop>
			
			
			<!--- Load views --->
			<cfset childXml = xmlSearch(ehXml, "views") />
			
			<cfloop from="1" to="#arrayLen(childXml)#" index="i">
				<cfset loadViews(ehInst, childXml[i]) />
			</cfloop>
			
			<cfset ehInst.afterConfiguration() />

			<!--- If an XML-defined type is defined, load its "after" elements --->
			<cfif isXmlTypeList>
				<cfset addTypedElementsToEventHandler("after", ehInst, ehXml.xmlAttributes.type) />
			</cfif>
						
			<cfset modelglue.addEventHandler(ehInst) />
		</cfif>

	</cfloop>
</cffunction>	

<cffunction name="addTypedElementsToEventHandler" output="false" hint="Loads a block (before/after) from an XML event type into an event handler">
	<cfargument name="block" hint="Before/after" />
	<cfargument name="eh" hint="Event handler instance" />
	<cfargument name="types" hint="List of types" />
	
	<cfset var typename = "" />
	<cfset var moduleBlock = "" />
	<cfset var i = "" />
	
	<cfloop list="#arguments.types#" index="typename">
		<cfif structKeyExists(variables.eventTypes, typeName)>
			
			<cfset moduleBlock = variables.eventTypes[typeName][block] />
			<!--- Load any broadcasts if we have any  and respect the possibility of multiple views blocks (like for requestformats ). --->
			<cfif structKeyExists(moduleBlock, "broadcasts") IS true>
				<cfloop from="1" to="#arrayLen(moduleBlock.broadcasts)#" index="i">
					<cfset loadMessages(eh, moduleBlock.broadcasts[i]) />
				</cfloop>
			</cfif>
			<!--- Load any results if we have any  and respect the possibility of multiple views blocks (like for requestformats ) --->
			<cfif structKeyExists(moduleBlock, "results") IS true>
				<cfloop from="1" to="#arrayLen(moduleBlock.results)#" index="i">
					<cfset loadResults(eh, moduleBlock.results[i]) />
				</cfloop>
			</cfif>
			<!--- Load any views if we have any and respect the possibility of multiple views blocks (like for requestformats ) --->
			<cfif structKeyExists(moduleBlock, "views") IS true>
				<cfloop from="1" to="#arrayLen(moduleBlock.views)#" index="i">
					<cfset loadViews(eh, moduleBlock.views[i]) />
				</cfloop>
			</cfif>

		</cfif>
	</cfloop>
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

<cffunction name="loadScaffolds" output="false" hint="I load the scaffold tags">
	<cfargument name="modelGlue" />
	<cfargument name="scaffoldsXML" />
	<cfset var scaffoldsArray = arrayNew(1) />
	<cfset var objectMetadata = "" />
	<cfset var i = 0 />
	<cfset var iType = "" />
	<cfset var S = "" />
	<!--- As the great Bob Marley said, no scaffolds, no problem mon --->
	<cfif arrayLen( scaffoldsXML ) IS 0>
		<cfreturn >
	</cfif>
	<!---OK, we have scaffolds, so rip over them--->
	<cfloop from="1" to="#arrayLen( arguments.scaffoldsXML )#" index="i">
		<!---  we'll store metadata in a struct for now --->
		<cfset objectMetadata = structNew() />
		<cfset objectMetadata = arguments.scaffoldsXML[i].XmlAttributes />
		<!--- default the types to the configured defaultscaffolds --->
		<cfparam name="objectmetadata.type" default="#arguments.modelglue.getConfigSetting('defaultScaffolds')#" />
		<cfparam name="objectmetadata.propertylist" default="" />
		<cfparam name="objectmetadata['event-type']" default="" />
		<cfloop list="#objectmetadata.type#" index="iType">
			<cfset S =createObject("component", "ModelGlue.gesture.eventhandler.Scaffold") /> 
			<!--- now make a seperate object for each type --->
			<cfset S.object = objectMetadata.object />
			<cfset S.type = iType />
			<cfset S.propertylist = objectmetadata.propertylist />
			<cfset S.eventType = objectMetadata["event-type"] />
			<cfset S.childXML = arguments.scaffoldsXML[i].XmlChildren />
			<!--- then store the metadata in the scaffolds array --->
			<cfset arrayAppend( scaffoldsArray, S) />
		</cfloop>
	</cfloop>
	<cfset arguments.modelglue.getScaffoldManager().generate( scaffoldsArray ) />
	
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