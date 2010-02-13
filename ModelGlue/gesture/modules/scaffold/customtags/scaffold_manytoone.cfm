<cfif thisTag.executionMode eq "start"><cfexit method="exittemplate" /></cfif>
<cfimport taglib="/views/customtags/forms/cfUniForm/" prefix="uform" />
<cfsilent>
	<!--- tag attributes --->
	<cfparam name="attributes.name" type="string" />
	<cfparam name="attributes.objectName" type="string" />
	<cfparam name="attributes.valueQuery" type="query" />
	<cfparam name="attributes.childDescProperty" type="string" />
	<cfparam name="attributes.label" type="string" default="#attributes.name#" />
	<cfparam name="attributes.value" type="string" default="" />
	<cfparam name="attributes.nullable" type="boolean" default="true" />
	<cfparam name="attributes.validation" type="struct" default="#structNew()#" />
	<cfparam name="attributes.readonly" type="boolean" default="false" />
<</cfsilent>
<cfoutput>
<uform:field name="#attributes.name#" type="select">
	<cfif attributes.nullable>
		<uform:option display="" value="" />
	</cfif>
	<cfloop query="attributes.valueQuery">
		<cfif not attributes.readonly or attributes.value eq attributes.valueQuery[attributes.name][attributes.valueQuery.currentRow]>
			<uform:option display="#attributes.valueQuery[attributes.childDescProperty][attributes.valueQuery.currentRow]#" 
					value="#attributes.valueQuery[attributes.name][attributes.valueQuery.currentRow]#"
					isSelected="#attributes.value eq attributes.valueQuery[attributes.name][attributes.valueQuery.currentRow]#" />
		</cfif>
	</cfloop>
</uform:field>
</cfoutput>
