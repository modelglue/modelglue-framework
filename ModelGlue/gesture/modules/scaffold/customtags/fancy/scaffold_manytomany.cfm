<cfif thisTag.executionMode eq "start"><cfexit method="exittemplate" /></cfif>
<cfimport taglib="/ModelGlueExtensions/cfUniform/tags/forms/cfUniform/" prefix="uform" />
<cfsilent>
	<!--- tag attributes --->
	<cfparam name="attributes.name" type="string" />
	<cfparam name="attributes.objectName" type="string" />
	<cfparam name="attributes.valueQuery" type="query" />
	<cfparam name="attributes.childDescProperty" type="string" />
	<cfparam name="attributes.selectedList" type="string" default="" />
	<cfparam name="attributes.label" type="string" default="#attributes.name#" />
<</cfsilent>
<cfoutput>
<uform:field type="custom">
	<input type="hidden" name="#attributes.label#|#attributes.name#" value="" />
	#attributes.label#
</uform:field>
<cfloop query="attributes.valueQuery">
	<uform:field label="#attributes.valueQuery[attributes.childDescProperty][attributes.valueQuery.currentRow]#"
		name="#attributes.label#|#attributes.name#"
		value="#attributes.valueQuery[attributes.name][attributes.valueQuery.currentRow]#" type="checkbox"
		isChecked="#listFindNoCase(attributes.selectedList, attributes.valueQuery[attributes.name][attributes.valueQuery.currentRow])#"  />
</cfloop>
</cfoutput>
