<cfif thisTag.executionMode eq "start"><cfexit method="exittemplate" /></cfif>
<cfimport taglib="/cfUniForm/" prefix="uform" />
<cfsilent>
	<!--- tag attributes --->
	<cfparam name="attributes.name" type="string" />
	<cfparam name="attributes.valueQuery" type="query" />
	<cfparam name="attributes.queryColumnName" type="string" />
	<cfparam name="attributes.label" type="string" default="#attributes.name#" />
	<cfparam name="attributes.value" type="string" default="" />
	<cfparam name="attributes.nullable" type="boolean" default="true" />
<</cfsilent>
<cfoutput>
<uform:field name="#attributes.name#" type="select">
	<cfif attributes.nullable>
		<uform:option display="" value="" />
	</cfif>
	<cfloop query="attributes.valueQuery">
		<uform:option display="#attributes.valueQuery[attributes.queryColumnName][attributes.valueQuery.currentRow]#" 
				value="#attributes.valueQuery[attributes.queryColumnName][attributes.valueQuery.currentRow]#"
				isSelected="#attributes.value eq attributes.valueQuery[attributes.queryColumnName][attributes.valueQuery.currentRow]#" />
	</cfloop>
</uform:field>
</cfoutput>
