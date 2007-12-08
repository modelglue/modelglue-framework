<cfcomponent output="false" hint="I load an XML-based module into an instance of Model-Glue.">

<cffunction name="init" output="false">
	<cfreturn this />
</cffunction>

<cffunction name="load" returntype="void" output="false" hint="I perform module loading.">
	<cfargument name="modelglue" type="ModelGlue.gesture.ModelGlue" hint="The instance of Model-Glue into which a module should be loaded.">
	<cfargument name="path" hint="The .XML file containing the module." />
	<cfargument name="loadedModules" type="struct" default="#structNew()#" hint="Location-keyed collection of modules loaded _during this loading request_ (prevents infinitely recursive loading)." />
	
	<cfset var xml = "" />
	<cfset var controllerBlocks = "" />
	<cfset var ehBlocks = "" />
	<cfset var modules = "" />
	<cfset var includes = "" />
	<cfset var i = "" />
	<cfset var moduleLoaderFactory = modelglue.getInternalBean("modelglue.ModuleLoaderFactory") />
	<cfset var moduleLoader = "" />
	
	<!--- Don't load a module twice. --->
	<cfif structKeyExists(loadedModules, arguments.path)>
		<cfreturn />
	</cfif>
	<cfset arguments.loadedModules[arguments.path] = true />
	
	<cfset arguments.path = expandPath(arguments.path) />
	
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
<cffunction name="loadControllers" output="false" hint="Loads controllers from <controllers> block.">
	<cfargument name="modelglue" />
	<cfargument name="controllersXML" />
	
	<cfset var ctrlInst = "" />
	<cfset var ctrlXml = "" />
	<cfset var listXml = "" />
	<cfset var i = "" />
	
	<cfloop from="1" to="#arrayLen(arguments.controllersXML.xmlChildren)#" index="i">
		<cfset ctrlXml = arguments.controllersXML.xmlChildren[i] />
		<cfset ctrlInst = createObject("component", ctrlXml.xmlAttributes.type).init() />
	
		<cfloop from="1" to="#arrayLen(ctrlXml.xmlChildren)#" index="j">
			<cfset listXml = ctrlXml.xmlChildren[j] />
			<cfset modelglue.addEventListener(listXml.xmlAttributes.message, ctrlInst, listXml.xmlAttributes.function) />
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

		<cfparam name="ehXml.xmlAttributes.type" default="EventHandler" />
				
		<cfset ehInst = ehFactory.create(ehXml.xmlAttributes.type) >

		<cfset ehInst.name = ehXml.xmlAttributes.name />
		
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
		
		
		<cfset modelglue.addEventHandler(ehInst) />
		<!---	
		<cfloop from="1" to="#arrayLen(ehXml.xmlChildren)#" index="i">
			<cfset listXml = ehXml.xmlChildren[i] />
			<cfset modelglue.addEventListener(listXml.xmlAttributes.message, ehInst, listXml.xmlAttributes.function) />
		</cfloop>
		--->
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