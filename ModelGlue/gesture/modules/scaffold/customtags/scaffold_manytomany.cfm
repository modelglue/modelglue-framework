<cfif thisTag.executionMode eq "start"><cfexit method="exittemplate" /></cfif>
<cfimport taglib="/views/customtags/forms/cfUniForm/" prefix="uform" />
<cfsilent>
	<!--- tag attributes --->
	<cfparam name="attributes.name" type="string" />
	<cfparam name="attributes.objectName" type="string" />
	<cfparam name="attributes.valueQuery" type="query" />
	<cfparam name="attributes.childDescProperty" type="string" />
	<cfparam name="attributes.selectedList" type="string" default="" />
	<cfparam name="attributes.label" type="string" default="#attributes.name#" />
	<cfparam name="attributes.value" type="string" default="" />
	<cfparam name="attributes.nullable" type="boolean" default="true" />
	<cfparam name="attributes.validation" type="struct" default="#structNew()#" />
<</cfsilent>
<cfoutput>
<input type="hidden" name="#attributes.name#" value="" />
<uform:field type="custom">
	#attributes.label#
</uform:field>
<cfloop query="attributes.valueQuery">
	<uform:field label="#attributes.valueQuery[attributes.childDescProperty][attributes.valueQuery.currentRow]#"
		name="#attributes.name#_#attributes.valueQuery[attributes.name][attributes.valueQuery.currentRow]#"
		value="#attributes.valueQuery[attributes.name][attributes.valueQuery.currentRow]#" type="checkbox"
		isChecked="#listFindNoCase(attributes.selectedList, attributes.valueQuery[attributes.name][attributes.valueQuery.currentRow])#"  />
</cfloop>
</cfoutput>
