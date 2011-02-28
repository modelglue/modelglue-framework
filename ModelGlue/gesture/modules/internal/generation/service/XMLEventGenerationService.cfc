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

<cffunction name="getViewInclude" output="false">
	<cfargument name="config" />
	
	<cfset var viewPath = "" />
	
	<cfif len(arguments.config.viewLocation)>
		<cfset viewPath = viewPath & arguments.config.viewLocation & "/" />
	</cfif>
	
	<cfset viewPath = viewPath & arguments.config.viewFileName />
	
	<cfreturn viewPath />
</cffunction>

<cffunction name="getViewPath" output="false">
	<cfargument name="config" />
	
	<cfreturn expandPath(variables.viewPath & "/" & getViewInclude(arguments.config)) />
</cffunction>

<cffunction name="generateEvent" access="public" output="false">
	<cfargument name="context" hint="The currently executing event context." />
	<cfargument name="eventName" default="#arguments.context.getValue(arguments.context.getValue("eventValue"))#" hint="The name of the event to generate.  Defaults to eventValue in arguments.context." />
	
	<cfset var eventValues = arguments.context.getAll() />
	<cfset var generationConfig = structNew() />
	
	<cfset generationConfig.eventName = arguments.eventName />
	<cfset arguments.context.copyToScope(generationConfig, "generateMessageListener,messageListenerName,controllerFileName,controllerFunctionName,generateView,viewLocation,viewFileName,type,resultEvent,resultRedirect") />
	
	<cfif generationConfig.generateMessageListener>
		<cfset generateController(generationConfig) />
	</cfif>
	
	<cfif generationConfig.generateView>
		<cfset generateView(generationConfig) />
	</cfif>
	
	<cfif generationConfig.generateMessageListener or generationConfig.generateView>
		<cfset generateEventHandler(generationConfig) />
	</cfif>
</cffunction>

<!--- CONTENT GENERATORS --->
<cffunction name="generateView" outut="false" hint="Writes default view for a given event.">
	<cfargument name="config" />
	
	<cfset var viewFile = getViewPath(arguments.config) />
	
	<!--- Let's not overwrite existing stuff, ok? --->
	<cfif not fileExists(viewFile)>
		<cfset write(viewFile, generateViewContent(arguments.config)) />
	</cfif>
</cffunction>

<cffunction name="generateViewContent" output="false" hint="Generates default view content for a given event.">
	<cfargument name="config" />
	
	<cfset var content = "" />
	
	<cfsavecontent variable="content"><cfoutput><=-- Put HTML and CFML output code you'd like a user to see here. --->
<p>I'm a generated view for the "#arguments.config.eventName#" event.<p>

<p>To edit me, open #getViewPath(arguments.config)#.</p></cfoutput></cfsavecontent>
	
	<cfreturn clean(content) />
</cffunction>

<cffunction name="generateController" output="false" hint="Generates new controller (if necessary) and adds listener function to it.">
	<cfargument name="config" />
	
	<cfset var controllerFile = controllerPathNameFor(arguments.config.controllerFileName) />
	<cfset var controllerType = controllerClassNameFor(arguments.config.controllerFileName) />
	<cfset var ctrlInst = "" />
	
	<cfif not fileExists(controllerFile)>
		<cfset createController(arguments.config, controllerFile) />
	<cfelse>
		<cfset ctrlInst = createObject("component", controllerType) />
		
		<cfif not controllerHasFunction(ctrlInst, arguments.config.controllerFunctionName)>
			<cfset createListenerFunction(ctrlInst, controllerFile, arguments.config) />
		</cfif>
	</cfif>
	
	<cfset createListenerXML(getConfigFile(), controllerType, arguments.config) />
</cffunction>

<cffunction name="createController" output="false">
	<cfargument name="config" />
	<cfargument name="fileName" />

	<cfset var content = "" />
	
	<cfsavecontent variable="content"><cfoutput><cgcomponent output="false" hint="I am a Model-Glue controller." extends="ModelGlue.gesture.controller.Controller">

	<cgfunction name="init" access="public" output="false" hint="Constructor">
		<cgargument name="framework" />

		<cgset super.init(framework) />

		<cgreturn this />
	</cgfunction>

#createListenerFunctionContent(arguments.config)#

</cgcomponent></cfoutput></cfsavecontent>
	
	<cfset content = clean(content) />
	
	<cfset write(arguments.fileName, content) />
</cffunction>

<cffunction name="createListenerFunction" output="false">
	<cfargument name="controller" />
	<cfargument name="filename" />
	<cfargument name="config" />
	
	<cfset var filecontent = "" />
	<cfset var content = "" />
	<cfset var constructorPosition = "" />
	
	<cffile action="read" file="#filename#" variable="filecontent">
	
	<cfsavecontent variable="content"><cfoutput>#createListenerFunctionContent(arguments.config)#

</cgcomponent></cfoutput></cfsavecontent>
	
	<cfset content = clean(content) />

	<cfset filecontent = replaceNoCase(filecontent, "</cfcomponent>", content) />

	<cfset write(filename, filecontent) />
</cffunction>

<cffunction name="createListenerFunctionContent" output="false">
	<cfargument name="config" />
	
	<cfset var content = "" />
	
	<cfsavecontent variable="content"><cfoutput>	<cgfunction name="#arguments.config.controllerFunctionName#" output="false" hint="I am a message listener function generated for the ""#arguments.config.eventName#"" event.">
		<cgargument name="event" />

		<=--- 
			Put "behind the scenes" query, form validation, and model interaction code here.

			Use event.getValue("name") to get variables from the FORM and URL scopes.
		--->
	</cgfunction></cfoutput></cfsavecontent>
	
	<cfreturn content />
</cffunction>

<cffunction name="createListenerXML" output="false">
	<cfargument name="targetFile" />
	<cfargument name="controllerType" />
	<cfargument name="config" />
	
	<cfset var xmlString = "" />
	<cfset var xml = "" />
	<cfset var xmlContent = "" />
	<cfset var line = chr(13) & chr(10) />
	<cfset var tab = chr(9) />
	<cfset var isDirty = false />
	
	<cffile action="read" file="#arguments.targetFile#" variable="xmlString" />
	
	<cftry>	
		<cfset xml = xmlParse(xmlString) />
		<cfcatch>
			<cfthrow type="XMLEventGenerationService.InvalidModelGlueXML"
							 message="Can't generate <controller> into #arguments.targetFile# - it's not valid XML!"
			/>
		</cfcatch>
	</cftry>
	
	<!--- Get / Make <controllers> block --->
	<cfif not arrayLen(xmlSearch(xml, "//controllers"))>
		<cfset xmlContent = "#line##line##tab#<controllers>#line##tab#</controllers>" />
		<cfset xmlString = REReplaceNoCase(xmlString, "(<modelglue[^>]+>)", "\1#xmlContent#") />
		<cfset isDirty = true />
	</cfif>
	
	<!--- See if we already have a controller for this type --->
	<cfif isDirty or not arrayLen(xmlSearch(xml, "//controllers/controller[@TYPE = '#arguments.controllerType#' or @type = '#arguments.controllerType#' ]"))>
		<cfset xmlContent = '#line##tab##tab##line##tab##tab#<controller id="#listLast(arguments.controllerType, ".")#" type="#arguments.controllerType#">#line##tab##tab#</controller>' />
		<cfset xmlString = REReplaceNoCase(xmlString, "[\n\r\t]+(</controllers>)", "#xmlContent##line##tab##tab##line##tab#\1") />
		<cfset isDirty = true />
	</cfif>
	
	<!--- Add listener function --->
	<cfif isDirty or not arrayLen(xmlSearch(xml, "//controllers/controller/message-listener[translate(@message, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz') = '#lCase(arguments.config.messageListenerName)#' and translate(@function, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz') = '#lCase(arguments.config.controllerFunctionName)#' ]"))>
		<cfset xmlContent = '#line##tab##tab##tab#<message-listener message="#arguments.config.messageListenerName#"' />
		
		<cfif arguments.config.messageListenerName neq arguments.config.controllerFunctionName>
			<cfset xmlContent = xmlContent & ' function="#arguments.config.controllerFunctionName#"' />
		</cfif>
		
		<cfset xmlContent = xmlContent & ' />' />
		 
		<cfset xmlString = REReplaceNoCase(xmlString, "[\n\r\t]+(</controller>)", "#xmlContent##line##tab##tab#\1") />
		<cfset isDirty = true />
	</cfif>
	
	<cfif isDirty>
		<cfset write(targetFile, xmlString) />
	</cfif>
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
	<cfargument name="config" />
	
	<cfset var targetFile = getConfigFile() />
	<cfset var xmlString = "" />
	<cfset var xml = "" />
	<cfset var xmlContent = "" />
	<cfset var line = chr(13) & chr(10) />
	<cfset var tab = chr(9) />
	<cfset var isDirty = false />
	
	<!--- Get all event handlers --->
	
	<cffile action="read" file="#targetFile#" variable="xmlString" />
	
	<cftry>	
		<cfset xml = xmlParse(xmlString) />
		<cfcatch>
			<cfthrow type="XMLEventGenerationService.InvalidModelGlueXML"
							 message="Can't generate <event-handler> into #targetFile# - it's not valid XML!"
			/>
		</cfcatch>
	</cftry>
	
	<!--- Get / Make <event-handlers> block --->
	<cfif not arrayLen(xmlSearch(xml, "//event-handlers"))>
		<cfset xmlContent = "#line##line##tab#<event-handlers>#line##tab#</event-handlers>" />
		
		<cfif REFindNoCase("</event-types>", xmlString)>
			<cfset xmlString = REReplaceNoCase(xmlString, "(</event-types>)", "\1#xmlContent#") />
		<cfelseif REFindNoCase("</controllers>", xmlString)>
			<cfset xmlString = REReplaceNoCase(xmlString, "(</controllers>)", "\1#xmlContent#") />
		<cfelse>
			<cfset xmlString = REReplaceNoCase(xmlString, "(<modelglue[^>]+>)", "\1#xmlContent#") />
		</cfif>
		
		<cfset isDirty = true />
	</cfif>
	
	<!--- If we don't have a match --->
	<cfif isDirty or not arrayLen(xmlSearch(xml, "//event-handlers/event-handler[translate(@name, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz') = '#lCase(arguments.config.eventName)#']"))>
		<cfset xmlContent = '#line##tab##tab##line##tab##tab#<event-handler name="#arguments.config.eventName#"' />
		
		<cfif len(arguments.config.type)>
			<cfset xmlContent = xmlContent & ' type="#arguments.config.type#"' />
		</cfif>
		
		<cfset xmlContent = xmlContent & '>' />
		
		<cfif arguments.config.generateMessageListener>
			<cfset xmlContent = xmlContent & '#line##tab##tab##tab#<broadcasts>#line##tab##tab##tab##tab#<message name="#arguments.config.messageListenerName#" />#line##tab##tab##tab#</broadcasts>' />
		</cfif>
		
		<cfif len(arguments.config.resultEvent)>
			<cfset xmlContent = xmlContent & '#line##tab##tab##tab#<results>#line##tab##tab##tab##tab#<result do="#arguments.config.resultEvent#"' />
			
			<cfif arguments.config.resultRedirect>
				<cfset xmlContent = xmlContent & ' redirect="true"' />
			</cfif>
			
			<cfset xmlContent = xmlContent & ' />#line##tab##tab##tab#</results>' />
		</cfif>
		
		<cfif arguments.config.generateView>
			<cfset xmlContent = xmlContent & '#line##tab##tab##tab#<views>#line##tab##tab##tab##tab#<view name="body" template="#getViewInclude(arguments.config)#" />#line##tab##tab##tab#</views>' />
		</cfif>
		
		<cfset xmlContent = xmlContent & '#line##tab##tab#</event-handler>' />
		<cfset xmlString = REReplaceNoCase(xmlString, "[\n\r\t]+(</event-handlers>)", "#xmlContent##line##tab##tab##line##tab#\1") />
		<cfset isDirty = true />
	</cfif> 
	
	<cfif isDirty>
		<cfset write(targetFile, xmlString) />
	</cfif>
</cffunction>

<!--- CONVENTIONAL NAME HELPERS --->
<cffunction name="controllerPathNameFor" output="false">
	<cfargument name="string" />

	<cfset var result = "" />
	
	<cfif len(arguments.string)>
		<cfset result = arguments.string />
	<cfelse>
		<cfset result = "Controller.cfc" />
	</cfif>
	
	<cfset result = "#getControllerDirectory()#/#result#" />
	
	<cfreturn result />
</cffunction>

<cffunction name="controllerClassNameFor" output="false">
	<cfargument name="string" />
	
	<cfset var result = "" />
	
	<cfif len(arguments.string)>
		<cfset result = listFirst(arguments.string, ".") />
	<cfelse>
		<cfset result = "Controller" />
	</cfif>
	
	<cfset result = "#getControllerPackage()#.#result#" />
		
	<cfreturn result />
</cffunction>

</cfcomponent>