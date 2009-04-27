<cfcomponent output="false" extends="ModelGlue.Util.CGCodeGenerator" hint="Creates new events in a conventions-based XML style.">

<cffunction name="init" output="false">
	<cfargument name="modelglue" required="true" />
	
	<cfset super.init() />
	
	<cfset variables.mg = arguments.modelglue />
	
	<cfset variables.viewPath = arguments.modelglue.configuration.generationViewPath />
</cffunction>

<cffunction name="getControllerDirectory" access="private" output="false">
	<cfif left(variables.mg.configuration.generationControllerPath, 1) eq "/">
		<cfreturn expandPath(variables.mg.configuration.generationControllerPath) />
	<cfelse>
		<cfreturn expandPath("./" & variables.mg.configuration.generationControllerPath) />
	</cfif>
</cffunction>

<cffunction name="getControllerPackage" access="private" output="false">
	<cfset var string = "" />

	<!--- too lazy for a regex right now...if anyone wants to contrib to mg, here's a chance --->
	<cfset string = replace(variables.mg.configuration.generationControllerPath, "/", ".", "all") />
	<cfif left(string, 1) eq ".">
		<cfset string = right(string, len(string) - 1) />
	</cfif>
		
	<cfreturn string />
</cffunction>

<cffunction name="getConfigFile" access="private" output="false">
	<cfif left(variables.mg.configuration.generationModule, 1) eq "/">
		<cfreturn expandPath(variables.mg.configuration.generationModule) />
	<cfelse>
		<cfreturn expandPath("./" & variables.mg.configuration.generationModule) />
	</cfif>
</cffunction>

<cffunction name="generateEvent" access="public" output="false">
	<cfargument name="context" hint="The currently executing event context." />
	<cfargument name="eventName" default="#arguments.context.getValue(arguments.context.getValue("eventValue"))#" hint="The name of the event to generate.  Defaults to eventValue in arguments.context." />
	
	<cfset var type = context.getValue("type", "") />
	
	<!---
	<cflog text="Config file: #getConfigFile()#" />
	<cflog text="Controller path: #controllerPathNameFor(eventName)#" />
	<cflog text="Controller className: #controllerClassNameFor(eventName)#" />
	<cflog text="ViewInclude: #viewIncludeFor(eventName)#" />
	<cflog text="ViewFile: #viewFileFor(eventName)#" />
	<cfabort />
	--->
	
	<cfset generateController(eventName) />
	<cfset generateEventHandler(eventName, type) />
	<cfset generateView(eventName) />
</cffunction>

<!--- CONTENT GENERATORS --->
<cffunction name="generateView" outut="false" hint="Writes default view for a given event.">
	<cfargument name="eventName">
	<cfset var viewFile = viewFileFor(eventName) />
	<!--- Let's not overwrite existing stuff, ok? --->
	<cfif not fileExists(viewFile)>
		<cfset write(viewFile, generateViewContent(eventName)) />
	</cfif>
</cffunction>

<cffunction name="generateViewContent" output="false" hint="Generates default view content for a given event.">
	<cfargument name="eventName">
	
	<cfset var content = "" />
	
	<cfoutput>
	<cfsavecontent variable="content"><=-- Put HTML and CFML output code you'd like a user to see here. --->
<p>I'm a generated view for the "#arguments.eventName#" event.<p>

<p>To edit me, open #viewFileFor(arguments.eventName)#.</p>
	</cfsavecontent>
	</cfoutput>
	
	<cfreturn clean(content) />
</cffunction>

<cffunction name="generateController" output="false" hint="Generates new controller (if necessary) and adds listener function to it.">
	<cfargument name="eventName" />

	<cfset var controllerFile = controllerPathNameFor(eventName) />
	<cfset var controllerType = controllerClassNameFor(eventName) />
	<cfset var ctrlInst = "" />
	
	<cfif not fileExists(controllerFile)>
		<cfset createController(eventName, controllerFile) />
	<cfelse>
		<cfset ctrlInst = createObject("component", controllerClassNameFor(eventName)) />
		
		<cfif not controllerHasFunction(ctrlInst, listenerFunctionNameFor(eventName))>
			<cfset createListenerFunction(ctrlInst, listenerFunctionNameFor(eventName), eventName, controllerFile) />
		</cfif>
	</cfif>
	
	<cfset createListenerXML(getConfigFile(), controllerType, eventName) />
</cffunction>

<cffunction name="createController" output="false">
	<cfargument name="eventName" />
	<cfargument name="filename" />

	<cfset var content = "" />
	
	<cfoutput>
	<cfsavecontent variable="content"><cgcomponent output="false" hint="I am a Model-Glue controller." extends="ModelGlue.gesture.controller.Controller">

	<cgfunction name="init" access="public" output="false" hint="Constructor">
		<cgreturn this />
	</cgfunction>

#createListenerFunctionContent(eventName)#

</cgcomponent>
	</cfsavecontent>
	</cfoutput>

	<cfset content = clean(content) />
	
	<cfset write(arguments.filename, content) />
</cffunction>

<cffunction name="createListenerFunction" output="false">
	<cfargument name="controller" />
	<cfargument name="function" />
	<cfargument name="eventName" />
	<cfargument name="filename" />
	
	<cfset var filecontent = "" />
	<cfset var content = "" />
	<cfset var constructorPosition = "" />
	
	<cffile action="read" file="#filename#" variable="filecontent">
	
	<cfoutput>
	<cfsavecontent variable="content">
#createListenerFunctionContent(eventName)#

</cgcomponent>
	</cfsavecontent>
	</cfoutput>
	
	<cfset content = clean(content) />

	<cfset filecontent = replaceNoCase(filecontent, "</cfcomponent>", content) />

	<cfset write(filename, filecontent) />
</cffunction>

<cffunction name="createListenerFunctionContent" output="false">
	<cfargument name="eventName" />
	
	<cfset var function = listenerFunctionNameFor(eventName) />
	<cfset var content = "" />
	
	<cfoutput>
	<cfsavecontent variable="content">
	<cgfunction name="#function#" output="false" hint="I am a message listener function generated for the ""#eventName#"" event.">
		<cgargument name="event" />
		
		<=--- 
			Put "behind the scenes" query, form validation, and model interaction code here.
			  
			Use event.getValue("name") to get variables from the FORM and URL scopes.
		--->
	</cgfunction>
	</cfsavecontent>
	</cfoutput>
	
	<cfreturn content />
</cffunction>

<cffunction name="createListenerXML" output="false">
	<cfargument name="targetFile" />
	<cfargument name="controllerType" />
	<cfargument name="eventName" />
	
	<cfset var xmlString = "" />
	<cfset var xml = "" />
	<cfset var controllersNode = "" />
	<cfset var controllerNode = "" />
	<cfset var listenerNode = "" />
	<cfset var xmlContent = "" />
	
	<cffile action="read" file="#targetFile#" variable="xmlString" />
	
	<cftry>	
		<cfset xml = xmlParse(xmlString) />
		<cfcatch>
			<cfthrow type="XMLEventGenerationService.InvalidModelGlueXML"
							 message="Can't generate <controller> into #targetFile# - it's not valid XML!"
			/>
		</cfcatch>
	</cftry>
	
	<!--- Get / Make <controllers> block --->
	<cfset controllersNode = xmlSearch(xml, "//controllers") />
	<cfif not arrayLen(controllersNode)>
		<cfif arrayLen(xml.xmlRoot.xmlChildren)>
			<cfset arrayInsertAt(xml.xmlRoot.xmlChildren, 1, xmlElemNew(xml, "controllers")) />
		<cfelse>
			<cfset arrayAppend(xml.xmlRoot.xmlChildren, xmlElemNew(xml, "controllers")) />
		</cfif>
	</cfif>
	<cfset controllersNode = xml.xmlRoot.controllers[1] />
	
	<!--- See if we already have a controller for this type --->
	<cfset controllerNode = xmlSearch(xml, "//controllers/controller[@TYPE = '#arguments.controllerType#' or @type = '#arguments.controllerType#' ]") />

	<cfif arrayLen(controllerNode)>
		<cfset controllerNode = controllerNode[1] />
	<cfelse>
		<cfset arrayAppend(controllersNode.xmlChildren, xmlElemNew(xml, "controller")) />
		<cfset controllerNode = controllersNode.xmlChildren[arrayLen(controllersNode.xmlChildren)] />
		<cfset controllerNode.xmlAttributes["type"] = controllerType />
		<cfset controllerNode.xmlAttributes["id"] = listLast(controllerType, ".") />
	</cfif>
	
	<!--- Add listener function --->
	<cfset listenerNode = xmlSearch(xml, "//controllers/controller/message-listener[@message = '#messageNameFor(eventName)#' and @function = '#listenerFunctionNameFor(eventName)#' ]") />
	<cfif not arrayLen(listenerNode)>
		<cfset arrayAppend(controllerNode.xmlChildren, xmlElemNew(xml, "message-listener")) />
		<cfset listenerNode = controllerNode.xmlChildren[arrayLen(controllerNode.xmlChildren)] />
		<cfset listenerNode.xmlAttributes["message"] = messageNameFor(eventName) />
		<cfset listenerNode.xmlAttributes["function"] = listenerFunctionNameFor(eventName) />
	</cfif>
		
	<cfset writeXml(targetFile, xml) />
</cffunction>

<cffunction name="controllerHasFunction" output="false">
	<cfargument name="controller" />
	<cfargument name="function" />
	
	<cfset var md = getMetadata(controller) />
	<cfset var i = "" />
	
	<cfif not structKeyExists(md, "functions")>
		<cfreturn false />
	</cfif>
	
	<cfif not arrayLen(md.functions)>
		<cfreturn false />
	</cfif>
	
	<cfloop from="1" to="#arrayLen(md.functions)#" index="i">
		<cfif md.functions[i].name eq function>
			<cfreturn true />
		</cfif>
	</cfloop>
	
	<cfreturn false />
</cffunction>

<cffunction name="generateEventHandler" output="false">
	<cfargument name="eventName" />
	<cfargument name="type" />
	
	<cfset var targetFile = getConfigFile() />
	<cfset var xmlString = "" />
	<cfset var xml = "" />
	<cfset var ehsNode = "" />
	<cfset var ehNodes = "" />
	<cfset var ehNode = "" />
	<cfset var bNode = "" />
	<cfset var mNode = "" />
	<cfset var rNode = "" />
	<cfset var vNode = "" />
	<cfset var iNode = "" />
	<cfset var i = "" />
	
	<!--- Get all event handlers --->
	
	<cffile action="read" file="#targetFile#" variable="xmlString" />
	
	<cftry>	
		<cfset xml = xmlParse(xmlString) />
		<cfcatch>
			<cfthrow type="XMLEventGenerationService.InvalidModelGlueXML"
							 message="Can't generate <controller> into #targetFile# - it's not valid XML!"
			/>
		</cfcatch>
	</cftry>
	
	<!--- Get / Make <event-handlers> block --->
	<cfset ehsNode = xmlSearch(xml, "//event-handlers") />
	<cfif not arrayLen(ehsNode)>
		<cfset arrayAppend(xml.xmlRoot.xmlChildren, xmlElemNew(xml, "event-handlers")) />
	</cfif>
	<cfset ehsNode = xml.xmlRoot.xmlChildren[arrayLen(xml.xmlRoot.xmlChildren)] />

	<!--- If we don't have a match --->
	<cfset ehNode = xmlSearch(xml, "//event-handlers/event-handler[@name='#eventName#']")>
	<cfif not arrayLen(ehNode)>
		<cfset ehNodes = xmlSearch(xml, "//event-handlers/event-handler")>

		<!--- Go until we're alphabetically greater or we're at end --->
		<cfloop from="1" to="#arrayLen(ehNodes)#" index="i">
			<cfif structKeyExists(ehNodes[i].xmlAttributes, "name") and compareNoCase(ehNodes[i].xmlAttributes.name, eventName) gte 0>
				<cfbreak />	
			</cfif>
		</cfloop>
		
		<cfif i gt arrayLen(ehNodes) and arrayLen(ehNodes)>
			<cfset i = arrayLen(ehNodes) />
		</cfif>
		
		<!--- Write event-handler tag --->
		<cfif i eq 1>
			<cfset arrayAppend(ehsNode.xmlChildren, xmlElemNew(xml, "event-handler")) />
			<cfset ehNode = ehsNode.xmlChildren[arrayLen(ehsNode.xmlChildren)] />
		<cfelse>
			<cfset arrayInsertAt(ehsNode.xmlChildren, i, xmlElemNew(xml, "event-handler")) />
			<cfset ehNode = ehsNode.xmlChildren[i] />
		</cfif>
		
		<cfset ehNode.xmlAttributes["name"] = eventName />
		
		<cfif len(type)>
			<cfset ehNode.xmlAttributes["type"] = type />
		</cfif>		

		<cfset bNode = xmlElemNew(xml, "broadcasts") />
		<cfset mNode = xmlElemNew(xml, "message") />
		<cfset mNode.xmlAttributes["name"] = messageNameFor(eventName) />

		<cfset arrayAppend(bNode.xmlChildren, mNode) />
		
		<cfset rNode = xmlElemNew(xml, "results") />

		<cfset vNode = xmlElemNew(xml, "views") />
		<cfset iNode = xmlElemNew(xml, "include") />
		<cfset iNode.xmlAttributes["name"] = "body" />
		<cfset iNode.xmlAttributes["template"] = viewIncludeFor(eventName) />

		<cfset arrayAppend(vNode.xmlChildren, iNode) />
		
		<cfset arrayAppend(ehNode.xmlChildren, bNode) />
		<cfset arrayAppend(ehNode.xmlChildren, rNode) />
		<cfset arrayAppend(ehNode.xmlChildren, vNode) />
	</cfif> 
	
	<cfset writeXml(targetFile, xml) />
</cffunction>

<!--- CONVENTIONAL NAME HELPERS --->
<cffunction name="listenerFunctionNameFor" output="false">
	<cfargument name="string" />

	<cfset var result = "" />
	<cfset var term="" />
	
	<cfif listLen(arguments.string, ".") gt 1>
		<cfset arguments.string = listDeleteAt(arguments.string, 1, ".") />
		
		<cfloop list="#arguments.string#" index="term" delimiters=".">
			<cfif len(result)>
				<cfset result = result & uCase(left(term, 1)) & right(term, len(term) - 1) />
			<cfelse>
				<cfset result = term />
			</cfif>	
		</cfloop>
	<cfelse>
		<cfreturn arguments.string />
	</cfif>
		
	<cfreturn result />
</cffunction>

<cffunction name="controllerPathNameFor" output="false">
	<cfargument name="string" />

	<cfset var result = "" />
	<cfset var term= "" />
	
	<cfset var noun = listFirst(arguments.string, ".") />
	
	<cfif listLen(arguments.string, ".") gt 1>
		<cfset result = "#uCase(left(noun, 1))##right(noun, len(noun) - 1)#Controller" />
	<cfelse>
		<cfset result = "Controller" />
	</cfif>
	
	<cfset result = "#getControllerDirectory()#/#result#.cfc" />
		
	<cfreturn result />
</cffunction>

<cffunction name="controllerClassNameFor" output="false">
	<cfargument name="string" />

	<cfset var result = "" />
	<cfset var term= "" />
	
	<cfset var noun = listFirst(arguments.string, ".") />
	
	<cfif listLen(arguments.string, ".") gt 1>
		<cfset result = "#uCase(left(noun, 1))##right(noun, len(noun) - 1)#Controller" />
	<cfelse>
		<cfset result = "Controller" />
	</cfif>
	
	<cfset result = "#getControllerPackage()#.#result#" />
		
	<cfreturn result />
</cffunction>

<cffunction name="messageNameFor" output="false">
	<cfargument name="string" />

	<cfreturn arguments.string />
</cffunction>

<cffunction name="viewIncludeFor" output="false">
	<cfargument name="string" />
	
	<cfreturn replaceNoCase(string, ".", "/", "all") & ".cfm" />
</cffunction>

<cffunction name="viewFileFor" output="false">
	<cfargument name="string" />
	
	<cfreturn expandPath(variables.viewPath & "/" & viewIncludeFor(string)) />
</cffunction>

</cfcomponent>