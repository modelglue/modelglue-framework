<cfcomponent output="false">
	
	<cffunction name="init" access="public" returntype="ScaffoldManager">
		<cfargument name="ModelGlueConfiguration" type="struct" required="true"/>
		<cfargument name="scaffoldBeanRegistryList" type="array" required="true"/>
		<cfargument name="scaffoldCustomTagMappingsList" type="array" required="true"/>
		<cfset  variables._MGConfig.scaffoldCFPath = arguments.ModelGlueConfiguration.getFullGeneratedViewMapping() />
		<cfset  variables._MGConfig.expandedScaffoldFilePath= replace( expandPath( variables._MGConfig.scaffoldCFPath ), "\", "/", "all" )   />
		<cfset  variables._MGConfig.scaffoldXMLFilePath= replace( expandPath( arguments.ModelGlueConfiguration.getScaffoldPath() ) , "\",  "/", "all")   />
		<cfset  variables._MGConfig.shouldRescaffold= arguments.ModelGlueConfiguration.getRescaffold() />
		<cfset  variables._MGConfig.scaffoldCustomTagMappings = unwind(arguments.scaffoldCustomTagMappingsList,false) />
		<!--- Custom tag mappings in MG config override those in scaffolds --->
		<cfset  structAppend( variables._MGConfig.scaffoldCustomTagMappings, arguments.ModelGlueConfiguration.getScaffoldCustomTagMappings() ) />
		<cfset  variables._scaffoldBeanRegistry = unwind(arguments.scaffoldBeanRegistryList) />
		<!--- Only bother hitting the disk if we are rescaffolding --->
		<cfif variables._MGConfig.shouldRescaffold IS true>
			<cfset makeSureConfigFileExists() />
			<cfset makeSureViewMappingFolderExists() />
		</cfif>
		<cfreturn this />
	</cffunction>
	
	<cffunction name="addScaffoldTemplate" output="false" access="public" returntype="struct" hint="I add a scaffolding bean configuration to the known scaffolding beans">
		<cfargument name="scaffoldBeanRegistry" type="struct" required="true"/>
		<cfset var unpackedRegistry = unwind( arguments.scaffoldBeanRegistry )>
		<cfset var thisTemplate= "" />
		<cfloop collection="#unpackedRegistry#" item="thisTemplate">
			<cfset variables._scaffoldBeanRegistry[ thisTemplate ] = unpackedRegistry[ thisTemplate ]  />
		</cfloop>
		<cfreturn arguments.scaffoldBeanRegistry />
	</cffunction>
	
	<cffunction name="generate" output="false" access="public" returntype="void" hint="I generate the scaffolds and load them into the model glue memory space">
		<cfargument name="scaffolds" />
		<cfset var scaffoldsXMLContent = "" />
		<cfset var inflatedScaffoldArray = arrayNew( 1 ) />
		<cfset var i = "" />
		<cfset var _ormAdapter = findOrmAdapter()  />
		
		<!--- OK, so inflate the scaffolds using the beans configured (or overridden) in the ColdSpring bean factories --->
		<cfloop from="1" to="#arrayLen( arguments.scaffolds )#" index="i">
			<cfset arrayAppend( inflatedScaffoldArray, new( arguments.scaffolds[i].type, _ormAdapter.getObjectMetadata( arguments.scaffolds[i].object ), arguments.scaffolds[i].propertylist, arguments.scaffolds[i].eventType )) />
		</cfloop>
		
		<!--- Yes this line is rediculously long, but we want to control whitespace, don't we?' --->
		<!--- Gen the XML --->
 		<cfsavecontent variable="scaffoldsXMLContent"><cfloop from="1" to="#arrayLen( inflatedScaffoldArray )#" index="i"><cfif inflatedScaffoldArray[i].hasXMLGeneration IS true ><cfoutput>#inflatedScaffoldArray[i].makeMGXMLWithMetadata()#</cfoutput></cfif></cfloop></cfsavecontent>
		
		<!--- For any scaffolds that contain XML content, inject the scaffold tag child nodes into the generated XML.  --->
		<cfloop from="1" to="#arrayLen( arguments.scaffolds )#" index="i">
			<cfif arrayLen(arguments.scaffolds[i].childXML)>
				<cfset scaffoldsXMLContent = injectScaffoldXML(scaffoldsXMLContent, "#arguments.scaffolds[i].object#.#arguments.scaffolds[i].type#", arguments.scaffolds[i].childXML) />
			</cfif>
		</cfloop>
		
		<cfset writeToDisk( variables._MGConfig.scaffoldXMLFilePath, scaffoldsXMLContent ) />
		
		<!--- Gen the Views --->
		<cfloop from="1" to="#arrayLen( inflatedScaffoldArray )#" index="i">
			<cfif inflatedScaffoldArray[i].hasViewGeneration IS true >
				<cfset cftemplate(	inflatedScaffoldArray[i].loadMetadata(),
												getTemplateCustomTagImportScript() & inflatedScaffoldArray[i].loadViewTemplateWithMetadata(),
												inflatedScaffoldArray[i].makeFullFilePathAndNameForView( variables._MGConfig.expandedScaffoldFilePath ) ) />
			</cfif>
		</cfloop>
	</cffunction>
	
	<cffunction name="writeToDisk" output="false" access="private" returntype="void" hint="I save the generated scaffolds.xml file to disk">
		<cfargument name="location" type="string" required="true" />
		<cfargument name="scaffoldXMLString" type="string" required="true" />
		<cffile action="write" file="#arguments.location#" output="#makeTopOuterNode() & arguments.scaffoldXMLString & makeBottomOuterNode()#" />
	</cffunction>
	
	<cffunction name="injectScaffoldXML" access="private" output="false" returntype="string" hint="I inject XML nodes from the body of a scaffold tag into each generated event handler that matches an [object].[type] naming convention.">
		<cfargument name="scaffoldsXMLContent" type="string" required="true" hint="I am the string of generated scaffold XML." />
		<cfargument name="scaffoldNodeName" type="string" required="true" hint="I am the name of the event handler node that will be targeted for injection." />
		<cfargument name="scaffoldXMLNodes" type="array" required="true" hint="I am the array of XML child nodes to inject." />
		
		<cfset var targetIndex = "" />
		<cfset var targetNode = "" />
		<cfset var targetChildren = "" />
		<cfset var sourceIndex = "" />
		<cfset var sourceNode = "" />
		<cfset var sourceChildren = "" />
		<cfset var childIndex = "" />
		<cfset var childNode = "" />
		<cfset var childNames = "" />
		<cfset var childResults = "" />
		<cfset var xmlString = "" />
		
		<!--- Create an XML document variable from the generated XML string concatenated with the outer nodes. --->
		<cfset var scaffoldGeneratedContent = xmlParse(makeTopOuterNode() & arguments.scaffoldsXMLContent & makeBottomOuterNode()) />
		<!--- Create an array of the event handler nodes in the document. --->
		<cfset var eventHandlers = xmlSearch(scaffoldGeneratedContent, "//event-handlers/event-handler") />
		
		<!--- Iterate over the event handler array, performing a case-insensitive test for the match to the targeted event handler name, and creating a reference to it. --->
		<cfloop from="1" to="#arrayLen(eventHandlers)#" index="targetIndex">
			<cfif eventHandlers[targetIndex].XmlAttributes.name is arguments.scaffoldNodeName>
				<cfset targetNode = eventHandlers[targetIndex] />
				<cfbreak />
			</cfif>
		</cfloop>
		
		<!--- Iterate over the array of nodes to inject. --->
		<cfloop from="1" to="#arrayLen(arguments.scaffoldXMLNodes)#" index="sourceIndex">
			<!--- Create a reference to the current source node (broadcasts, results or views). --->
			<cfset sourceNode = arguments.scaffoldXMLNodes[sourceIndex] />
			
			<!--- If the source node does not exist in the target node, create it. --->
			<cfif not structKeyExists(targetNode, sourceNode.XmlName)>
				<cfset targetNode.XmlChildren[arrayLen(targetNode.XmlChildren) + 1] = xmlElemNew(scaffoldGeneratedContent, sourceNode.XmlName) />
			</cfif>
			
			<!--- Create a reference to the array of child nodes of the target (message, result, view or include). --->
			<cfset targetChildren = targetNode[sourceNode.XmlName].XmlChildren />
			
			<!--- Iterate over the children of the target node, detecting existing nodes to avoid overwriting. --->
			<cfloop from="1" to="#arrayLen(targetChildren)#" index="childIndex">
				<!--- Create a reference to the current child node. --->
				<cfset childNode = targetChildren[childIndex] />
				
				<!--- If the node has a name attribute, append it to the childNames list --->
				<cfif structKeyExists(childNode.XmlAttributes, "name")>
					<cfset childNames = listAppend(childNames, childNode.XmlAttributes.name) />
				</cfif>
				
				<!--- If the node has a do attribute, append it to the childResults list --->
				<cfif structKeyExists(childNode.XmlAttributes, "do")>
					<cfset childResults = listAppend(childResults, childNode.XmlAttributes.do) />
				</cfif>
			</cfloop>
			
			<!--- Create a reference to the array of child nodes of the source (message, result, view or include). --->
			<cfset sourceChildren = sourceNode.XmlChildren />
			
			<!--- Iterate over the children of the source node, appending them to the target node. --->
			<cfloop from="1" to="#arrayLen(sourceChildren)#" index="childIndex">
				<!--- Create a reference to the current child node. --->
				<cfset childNode = sourceChildren[childIndex] />
				
				<!--- If the current child node does not already exist under the target node, copy the source child node to the target. --->
				<cfif (structKeyExists(childNode.XmlAttributes, "name") and not listFindNoCase(childNames, childNode.XmlAttributes.name))
					or (structKeyExists(childNode.XmlAttributes, "do") and not listFindNoCase(childResults, childNode.XmlAttributes.do))>
					<cfset setChildNode(scaffoldGeneratedContent, targetChildren, childNode) />
				</cfif>
			</cfloop>
		</cfloop>
		
		<!--- Create XML string. --->
		<cfset xmlString = toString(scaffoldGeneratedContent["modelglue"]["event-handlers"]) />
		
		<!--- Clean up the XML. --->
		<cfset xmlString = cleanXMLString(xmlString) />
		
		<cfreturn xmlString />
	</cffunction>
	
	<cffunction name="setChildNode" access="private" output="false" returntype="void" hint="I make a deep copy of a message, result, view or include XML node and append it to an array of child nodes in another XML document.">
		<cfargument name="xmlDocument" type="any" required="true" hint="I am the new XML document that will receive the copied node." />
		<cfargument name="parentArray" type="array" required="true" hint="I am the XML child array of the parent node that will receive the copied node." />
		<cfargument name="node" type="any" required="true" hint="I am the node to copy." />
		
		<cfset var attribute = "" />
		<cfset var childIndex = "" />
		<cfset var childNode = "" />
		<cfset var childAttribute = "" />
		
		<!--- Append a new node to the parent's child node array. --->
		<cfset arrayAppend(arguments.parentArray, xmlElemNew(arguments.xmlDocument, arguments.node.XmlName)) />
		
		<!--- Iterate over the attributes of the node to copy, setting each attribute into the new node. --->
		<cfloop collection="#arguments.node.XmlAttributes#" item="attribute">
			<cfset arguments.parentArray[arrayLen(arguments.parentArray)].XmlAttributes[attribute] = arguments.node.XmlAttributes[attribute] />
		</cfloop>
		
		<!--- Iterate over the XML child nodes of the node to copy. --->
		<cfloop from="1" to="#arrayLen(arguments.node.XmlChildren)#" index="childIndex">
			<!--- Create a reference to the current child node. --->
			<cfset childNode = arguments.node.XmlChildren[childIndex] />
			
			<!--- Append a new child node to the newly-copied node. --->
			<cfset arrayAppend(arguments.parentArray[arrayLen(arguments.parentArray)].XmlChildren, xmlElemNew(arguments.xmlDocument, childNode.XmlName)) />
			
			<!--- Iterate over the attributes of the child node to copy, setting each attribute into the new child node. --->
			<cfloop collection="#childNode.XmlAttributes#" item="childAttribute">
				<cfset arguments.parentArray[arrayLen(arguments.parentArray)].XmlChildren[childIndex].XmlAttributes[childAttribute] = childNode.XmlAttributes[childAttribute] />
			</cfloop>
		</cfloop>
	</cffunction>
	
	<cffunction name="cleanXMLString" output="false" access="private" returntype="string" hint="I format an XML string for legibility by humans.">
		<cfargument name="xmlSource" type="string" required="true" />
		
		<cfset var br = chr(13) & chr(10) />
		<cfset var tb = chr(9) />
		
		<!--- Break apart dynamically-inserted XML nodes. --->
		<cfset var xmlString = reReplace(arguments.xmlSource, "><", ">#br##tb##tb#<", "all") />
		
		<!--- Ensure consistent whitespace after each event handler block. --->
		<cfset xmlString = reReplaceNoCase(xmlString, "</event-handler>\s+[\r\n]+\s+", "</event-handler>#br##tb##tb##br##tb##tb#", "all") />
		
		<!--- Standardize indention levels for child tags of event handler. --->
		<cfset xmlString = reReplaceNoCase(xmlString, "\t*<(/?(broadcasts|results|views))", "#tb##tb##tb#<\1", "all") />
		<cfset xmlString = reReplaceNoCase(xmlString, "\t*<(/?(message|result|view|include)[^s])", "#tb##tb##tb##tb#<\1", "all") />
		<cfset xmlString = reReplaceNoCase(xmlString, "\t*<(/?(argument|value))", "#tb##tb##tb##tb##tb#<\1", "all") />
		
		<!--- Extract only event handler nodes. --->
		<cfset xmlString = reReplaceNoCase(xmlString, '<\?xml version="1\.0" encoding="UTF-8"\?>\s+<event-handlers>\s+', '') />
		<cfset xmlString = reReplaceNoCase(xmlString, '\s*</event-handlers>', '') />
		
		<cfreturn xmlString />
	</cffunction>
	
	<cffunction name="makeSureConfigFileExists" output="false" access="private" returntype="void" hint="I make sure the scaffold config file exists">
		<cfset var content = makeTopOuterNode() &  makeBottomOuterNode() />
		<cfif fileExists( variables._MGConfig.scaffoldXMLFilePath ) IS false>
			<cffile action="write" file="#variables._MGConfig.scaffoldXMLFilePath#" output="#content#" />
		</cfif>
	</cffunction>
	
	<cffunction name="makeSureViewMappingFolderExists" output="false" access="private" returntype="void" hint="I make sure the scaffold config file exists">
		<cfif directoryExists( variables._MGConfig.expandedScaffoldFilePath ) IS false>
			<cfdirectory action="create" directory="#variables._MGConfig.expandedScaffoldFilePath#">
		</cfif>
	</cffunction>

	<cffunction name="makeTopOuterNode" output="false" access="private" returntype="string" hint="I return the top portion of the file">
		<cfreturn ('<?xml version="1.0" encoding="UTF-8"?>
<!-- Warning! This file is generated and will be overwritten whenever ModelGlue feels like it. Do Not Make Your Customizations Here!-->
<modelglue xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
			xsi:noNamespaceSchemaLocation="http://www.model-glue.com/schema/gesture/ModelGlue-strict.xsd">

	<event-handlers>
') />
	</cffunction>

	<cffunction name="makeBottomOuterNode" output="false" access="private" returntype="string" hint="I return the top portion of the file">
		<cfreturn ('
	</event-handlers>

</modelglue>') />
	</cffunction>

	<cffunction name="findORMAdapter" output="false" access="private" returntype="any" hint="I find the ORM Adapter if one was loaded. If not, I cry like a baby">
		<cftry>
			<cfreturn variables._modelGlue.getInternalBean("OrmAdapter") />
			<cfcatch type="coldspring.NoSuchBeanDefinitionException">
				<cfthrow type="ModelGlue.Scaffolding" message="Scaffolding Requires Functional Configured ORM Adapter" detail="You tried to scaffold something and we can't find an ORMAdapter. Either configure one, or figure out what is wrong with the one you configured. Sorry, we can't help you." />
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="new" output="false" access="private" returntype="any" hint="I make a new instance of a scaffoldbean">
		<cfargument name="name" type="string" required="true"/>
		<cfargument name="constructorArgs" type="struct" default="#structNew()#"/>
		<cfargument name="propertylist" type="string" default=""/>
		<cfargument name="eventType" type="string" default="" />
		<cfset var beanConstructor = structNew() />
		<!--- mix in the arguments --->
		<cfset structAppend( beanConstructor, arguments ) />
		<!--- now specifically get the constructor args out and mix those in --->
		<cfset structAppend( beanConstructor, arguments.constructorArgs ) />
		<!--- mix in the stuff from the original config. --->
		<cfset structAppend( beanConstructor, variables._scaffoldBeanRegistry[ arguments.name ] ) />
		<cfset beanConstructor.advice = findAdvice( arguments.name ) ><!--- todo: This doesn't work yet.'--->
		<!--- make the object and return it --->
		<cfreturn createobject("component", variables._scaffoldBeanRegistry[ arguments.name ].class ).init( argumentcollection:beanConstructor ) />
	</cffunction>

	<cffunction name="nukeConfigFile" output="false" access="public" returntype="void" hint="I get rid of the scaffold config file">
		<cfif fileExists( variables._MGConfig.scaffoldXMLFilePath ) IS true>
			<cffile action="delete" file="#variables._MGConfig.scaffoldXMLFilePath#" />
		</cfif>
	</cffunction>

	<cffunction name="getModelGlue" access="public" output="false" returntype="any">
		<cfreturn variables._modelGlue />
	</cffunction>
	
	<cffunction name="setModelGlue" access="public" output="false" returntype="void">
		<cfargument name="ModelGlue" type="ModelGlue.gesture.ModelGlue" required="true" />
		<cfset variables._modelGlue = arguments.ModelGlue />
	</cffunction>

	<cffunction name="unwind" output="false" access="private" returntype="struct" hint="I unwind an array of registry structs and convert them to a single master struct">
		<cfargument name="registryList" type="array" required="true"/>
		<cfargument name="mergeEntries" type="boolean" required="false" default="true" hint="True: new entries are merged into existing ones. False: new entries replace existing ones."/>
		<cfset var masterRegistry = structNew() />
		<cfset var thisRegistry = "" />
		<cfset var thisRegistryEntry = "" />
		<cfset var i = 0 />
		<cfloop index="i" from="1" to="#ArrayLen(arguments.registryList)#">
			<cfset thisRegistry = arguments.registryList[i] />
			<!--- If element is an object, assume it is a factory bean and get the value it contains --->
			<cfif IsObject(thisRegistry)>
				<cfset thisRegistry = thisRegistry.getObject() />
			</cfif>
			<cfloop collection="#thisRegistry#" item="thisRegistryEntry">
				<cfif arguments.mergeEntries and StructKeyExists( masterRegistry, thisRegistryEntry ) and IsStruct( masterRegistry[ thisRegistryEntry ] ) >
					<cfset StructAppend( masterRegistry[ thisRegistryEntry ], thisRegistry[ thisRegistryEntry ] ) />
				<cfelse>
					<cfset masterRegistry[ thisRegistryEntry ] = thisRegistry[ thisRegistryEntry ] />
				</cfif>
			</cfloop>
		</cfloop>
		<cfreturn masterRegistry />
	</cffunction>
	
	<cffunction name="findAdvice" access="private" output="false" returntype="struct" hint="I am advice for the specific object. You can alter the behaviour of the scaffolding by configuring advice per object in coldspring.">
		<cfargument name="name" type="string" default="" />
		<cfreturn structNew() />
	</cffunction>
	
	<cffunction name="cftemplate" returntype="string" access="public" output="no" hint="I generate a script using a cf-template and its associated metadata. This is modified from cftemplate.riaforge.org">
		<cfargument name="Metadata" type="any" required="yes" hint="The metadata required for generation." />
		<cfargument name="TemplateScript" type="string" required="yes" hint="I am the content conforming to the CF Template syntax.">
		<cfargument name="DestinationFilePath" type="string" required="yes" hint="The physical path to publish the generated script to including the file name and file extension.">
		<cfset var TemplateScratchpadName = "#CreateUUID()#.cfm">
		<cfset var GeneratedScript = "" />
		<cfset var OpenTagString = "<<"/>
		<cfset var CloseTagString = ">>"/>
		<cfset var VariableString = "%"/>
		<cfset var EscapedVariableString = "%%"/>

		<cfscript>
			// TRANSFORM TEMPLATE FOR PROCESSING
			// Turn CF Template tag and variable identifiers into arbritrary strings
			arguments.TemplateScript = Replace(arguments.TemplateScript, OpenTagString, "!!START_CFTEMPLATE!!", "all");
			arguments.TemplateScript = Replace(arguments.TemplateScript, CloseTagString, "!!END_CFTEMPLATE!!", "all");
			arguments.TemplateScript = Replace(arguments.TemplateScript, EscapedVariableString, "!!EscapedVariableString!!", "all");
			arguments.TemplateScript = Replace(arguments.TemplateScript, VariableString, "!!VariableString!!", "all");
	
			// Turn ColdFusion tag and variable identifiers into arbritrary strings
			arguments.TemplateScript = Replace(arguments.TemplateScript, "<", "!!START_CF_TAG!!", "all");
			arguments.TemplateScript = Replace(arguments.TemplateScript, ">", "!!END_CF_TAG!!", "all");
			arguments.TemplateScript = Replace(arguments.TemplateScript, "####", "!!EscapedCFVariableString!!", "all");
			arguments.TemplateScript = Replace(arguments.TemplateScript, "##", "!!CFVariableString!!", "all");
			
			// Turn CF Template tag and variable identifiers into ColdFusion tag and variable identifiers
			arguments.TemplateScript = Replace(arguments.TemplateScript, "!!START_CFTEMPLATE!!", "<", "all");
			arguments.TemplateScript = Replace(arguments.TemplateScript, "!!END_CFTEMPLATE!!", ">", "all");
			arguments.TemplateScript = Replace(arguments.TemplateScript, "!!VariableString!!", "##", "all");
			
		</cfscript>
		
		<!--- Save the transformed template to the scratchpad directory for parsing --->
		<cffile action="write" addnewline="yes" file="#variables._MGConfig.expandedScaffoldFilePath#/#TemplateScratchpadName#" output="#TemplateScript#" fixnewline="no">
		<!--- Run the template to generate code --->
		<cfsavecontent variable="GeneratedScript"><cfinclude template="#variables._MGConfig.scaffoldCFPath#/#TemplateScratchpadName#"></cfsavecontent>
		<!--- Delete any scratchpad files --->
		<cfif fileExists( "#variables._MGConfig.expandedScaffoldFilePath#/#TemplateScratchpadName#" )>
			<cffile action="delete" file="#variables._MGConfig.expandedScaffoldFilePath#/#TemplateScratchpadName#">
		</cfif>

		<cfscript>
			// Transform the code back to CF
			GeneratedScript = Replace(GeneratedScript, "!!START_CF_TAG!!", "<", "all");
			GeneratedScript = Replace(GeneratedScript, "!!END_CF_TAG!!", ">", "all");
			GeneratedScript = Replace(GeneratedScript, "!!EscapedCFVariableString!!", "####", "all");
			GeneratedScript = Replace(GeneratedScript, "!!CFVariableString!!", "##", "all");
			GeneratedScript = Replace(GeneratedScript, "!!EscapedVariableString!!", EscapedVariableString, "all");
		</cfscript>

		<cffile action="write" addnewline="no" file="#DestinationFilePath#" output="#GeneratedScript#" fixnewline="no">
	</cffunction>

	<cffunction name="spaceCap" output="false" access="private" returntype="string" hint="I return a string with a space before each capital letter: author Mark W. Breneman (Mark@vividmedia.com) ">
		<cfargument name="x" type="string" required="true" />
		<cfreturn Replace(REReplace(x, "([.^[:upper:]])", " \1", "all"), "_", "", "all") />
	</cffunction>
	
	<cffunction name="makeQuerySourcedPrimaryKeyURLString" output="false" access="public" returntype="string" hint="I make a url string for the primary keys of this object">
		<cfargument name="_alias" type="string" required="true"/>
		<cfargument name="_primaryKeyList" type="string" required="true"/>
		<cfset var urlString = "" />
		<cfset var pk = "" />
		<cfloop list="#arguments._primaryKeyList#" index="pk">
			<cfset urlString = listAppend( urlString, "&#pk#=###arguments._alias#Query.#pk###") />
		</cfloop>
		<cfreturn urlString />
	</cffunction>
	
	<cffunction name="makeBeanSourcedPrimaryKeyURLString" output="false" access="public" returntype="string" hint="I make a url string for the primary keys of this object">
		<cfargument name="_alias" type="string" required="true"/>
		<cfargument name="_primaryKeyList" type="string" required="true"/>
		<cfset var urlString = "" />
		<cfset var pk = "" />
		<cfloop list="#arguments._primaryKeyList#" index="pk">
			<cfset urlString = listAppend( urlString, "&#pk#=###arguments._alias#Record.get#pk#()##") />
		</cfloop>
		<cfreturn urlString />
	</cffunction>
	
	<cffunction name="makePrimaryKeyHiddenFields" output="false" access="public" returntype="string" hint="I make hidden fields for the primary keys of this object">
		<cfargument name="_alias" type="string" required="true"/>
		<cfargument name="_primaryKeyList" type="string" required="true"/>
		<cfset var hiddenFieldString = "" />
		<cfset var pk = "" />
		<cfloop list="#arguments._primaryKeyList#" index="pk">
			<cfset hiddenFieldString = listAppend( hiddenFieldString, '
				<cfif event.valueExists("#pk#")>
					<input type="hidden" name="#pk#" value="###arguments._alias#Record.get#pk#()##">
				</cfif>', " ") />
		</cfloop>
		<cfreturn hiddenFieldString />
	</cffunction>
	
	<cffunction name="makePrimaryKeyCheckForIsNew" output="false" access="public" returntype="string" hint="I make an evaluation to find out whether or not this is an existing record">
		<cfargument name="_alias" type="string" required="true"/>
		<cfargument name="_primaryKeyList" type="string" required="true"/>
		<cfset var PrimaryKeyCheck = "" />
		<cfset var pk = "" />
		<cfloop list="#arguments._primaryKeyList#" index="pk">
			<cfset PrimaryKeyCheck = listAppend( PrimaryKeyCheck, "#arguments._alias#Record.get#pk#()", "&") />
		</cfloop>
		<cfreturn "len( trim(" & PrimaryKeyCheck & ") ) and val(" & PrimaryKeyCheck & ") neq 0" />
	</cffunction>

	<cffunction name="getIsNullable" output="false" access="public" returntype="string" hint="I return whether a property is nullable or not">
		<cfargument name="prop" type="any" required="true"/>
		<cfreturn arguments.prop.nullable is true or arguments.prop.nullable eq 1 />
	</cffunction>

	<cffunction name="isDisplayProperty" output="false" access="public" returntype="string" hint="Should this property be displayed on list, view and edit screens?">
		<cfargument name="propertyName" type="string" required="true"/>
		<cfargument name="metadata" type="struct" required="true"/>
		
		<cfreturn listFindNoCase(arguments.metadata.primaryKeyList,arguments.propertyName) IS false AND arguments.metadata.properties[arguments.propertyName].relationship IS false AND (NOT structKeyExists(arguments.metadata.properties[arguments.propertyName],"_persistent") or arguments.metadata.properties[arguments.propertyName]._persistent IS true) />
	</cffunction>

	<cffunction name="getDisplayPropertyList" output="false" access="public" returntype="string" hint="I return a list item (propertyName and Label) if the property should be included in a listing screen">
		<cfargument name="orderedPropertyList" type="string" required="true"/>
		<cfargument name="metadata" type="struct" required="true"/>
		
		<cfset var prop = "" />
		<cfset var displayPropertyList = "" />
		<cfloop list="#arguments.orderedPropertyList#" index="prop">
			<cfif isDisplayProperty(prop,arguments.metadata)>
				<cfset displayPropertyList = listAppend(displayPropertyList,prop & "^" & arguments.metadata.properties[prop].label) />
			</cfif>
		</cfloop>
		<cfreturn displayPropertyList />
	</cffunction>

	<cffunction name="getTemplateCustomTagImportScript" output="false" access="private" returntype="string" hint="I return the cftemplate script that imports the custom tag mappings for scaffolded views">
		<cfreturn ('<cfsilent><<cfoutput>>
	<<cfloop collection="%variables._MGConfig.scaffoldCustomTagMappings%" item="variables.customTagPrefix">>
		<cfimport prefix="%customTagPrefix%" taglib="%variables._MGConfig.scaffoldCustomTagMappings[variables.customTagPrefix]%" /><</cfloop>>
<</cfoutput>>
</cfsilent>'
		) />
	</cffunction>
	
</cfcomponent>