<cfsilent>
	<cfset configPath = event.getModelGlue().getConfigSetting("applicationMapping") & "/" & event.getModelGlue().getConfigSetting("primaryModule") />
	<cffile action="read" file="#expandPath(configPath)#" variable="xmlNodes" />
	<cfset xmlNodes = xmlParse(xmlNodes) />
	<cfset xmlNodes = xmlSearch( xmlNodes, "//scaffold") />
	<cfset itemArray = [] />
	<cfloop from="1" to="#arrayLen( xmlNodes )#" index="i">
			<cfset arrayAppend(itemArray, xmlNodes[i].XmlAttributes['object'] )>
	</cfloop>
	<cfset currentEvent = event.getValue("Event") />
</cfsilent>
<cfoutput>
<div id="navcontainer">
	<ul id="navlist">
		<cfloop array="#itemArray#" index="currentItem">
			<cfset currentClassAdvice = "" />
			<cfif listFirst(currentEvent, ".") IS currentItem>
				<cfset currentClassAdvice = 'current' />
			</cfif>
			<li><a href="#event.linkTo( currentItem & '.List')#" class="#currentClassAdvice#">#CurrentItem#</a></li>
		</cfloop>
	</ul>
</div>
</cfoutput>