<cfcomponent output="false" hint="I load an XML-based module into an instance of Model-Glue.">

<cffunction name="init" output="false">
	<cfreturn this />
</cffunction>

<cffunction name="load" returntype="void" output="false" hint="I perform module loading.">
	<cfargument name="modelglue" type="ModelGlue.gesture.ModelGlue" hint="The instance of Model-Glue into which a module should be loaded.">
	<cfargument name="path" hint="The .XML file containing the module." />
	<cfargument name="loadedModules" type="struct" default="#structNew()#" hint="Location-keyed collection of modules loaded _during this loading request_ (prevents infinitely recursive loading)." />
	
	<cfset var xml = "" />
	<cfset var settingBlocks = "" />
	<cfset var controllerBlocks = "" />
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
	<cfif not fileExists(arguments.path) and fileExists(expandPath(arguments.path))>
		<cfset arguments.path = expandPath(arguments.path) />
	</cfif>
	
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
					<cfif getMetadata(iocAdapter).name neq "ModelGlue.Bean.BeanFactory">
						<cfset iocAdapter = createObject("component", "ModelGlue.gesture.externaladapters.ioc.ChiliBeansAdapter").init("") />
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
						<cflog text="XMLMODLOADER:  loaded from #j#" />
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
					<cfset arguments.modelglue.getInternalBean("modelglue.viewRenderer").addViewMapping(tmpArray[j]) />
				</cfloop>
				<!---
				<cfset arguments.modelglue.setConfigSetting("viewMappings", val) />
				--->
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

	
	<cfset var injector = arguments.modelglue.getInternalBean("modelglue.controllerBeanInjector") />
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
			<cfset modelglue.addEventListener(listXml.xmlAttributes.message, ctrlInst, listXml.xmlAttributes.function) />
			<cfset modelglue.addController(ctrlXml.xmlAttributes.id, ctrlInst) />
		</cfloop>
	</cfloop>
</cffunction>	

<cffunction name="loadEventHandlers" output="false" hint="Loads controllers from <controllers> block.">
	<cfargument name="modelglue" />
	<cfargument name="handlersXML" />
	
	<cfset var ehInst = "" />
	<cfset var ehXml = "" />
	<cfset var childXml = "" />
	<cfset var i = "" />
	<cfset var j = "" />
	<cfset var ehFactory = arguments.modelglue.getInternalBean("modelglue.EventHandlerFactory") />
	
	<cfloop from="1" to="#arrayLen(arguments.handlersXML.xmlChildren)#" index="i">
		<cfset ehXml = arguments.handlersXML.xmlChildren[i] />
		
		<cfif ehXml.xmlName eq "event-handler">

			<cfparam name="ehXml.xmlAttributes.type" default="EventHandler" />
			<cfparam name="ehXml.xmlAttributes.access" default="public" />
			<cfparam name="ehXml.xmlAttributes.cache" default="false" />
			<cfparam name="ehXml.xmlAttributes.cacheKey" default="" />
			<cfparam name="ehXml.xmlAttributes.cacheKeyValues" default="" />
			<cfparam name="ehXml.xmlAttributes.cacheTimeout" default="0" />
					
			<cfset ehInst = ehFactory.create(ehXml.xmlAttributes.type) >
	
			<cfset ehInst.beforeConfiguration() />
			
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
			
			<cfset modelglue.addEventHandler(ehInst) />
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
	
		<cfset msgInst.name = msgXml.xmlAttributes.name />
		
		<cfloop from="1" to="#arrayLen(msgXml.xmlChildren)#" index="j">
			<cfset argXml = msgXml.xmlChildren[j] />
			<cfset msgInst.arguments.setValue(argXml.xmlAttributes.name, argXml.xmlAttributes.value) />
		</cfloop>
		
		<cfif structKeyExists(arguments.broadcastsXml.xmlAttributes, "format")>
			<cfset arguments.eventHandler.addMessage(msgInst, arguments.broadcastsXml.xmlAttributes.format) />
		<cfelse>
			<cfset arguments.eventHandler.addMessage(msgInst) />
		</cfif>
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

		<cfif structKeyExists(arguments.resultsXml.xmlAttributes, "format")>
			<cfset arguments.eventHandler.addResult(resInst, arguments.resultsXml.xmlAttributes.format) />
		<cfelse>
			<cfset arguments.eventHandler.addResult(resInst) />
		</cfif>
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
	
		<cfset viewInst.name = viewXml.xmlAttributes.name />
		<cfset viewInst.template = viewXml.xmlAttributes.template />
		
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

		<cfif structKeyExists(arguments.viewsXml.xmlAttributes, "format")>
			<cfset arguments.eventHandler.addView(viewInst, arguments.viewsXml.xmlAttributes.format) />
		<cfelse>
			<cfset arguments.eventHandler.addView(viewInst) />
		</cfif>

	</cfloop>
</cffunction>

</cfcomponent>