<cfif thisTag.executionMode eq "start"><cfexit method="exittemplate" /></cfif>
<cfimport taglib="/views/customtags/forms/cfUniForm/" prefix="uform" />
<cfsilent>
	<!--- tag attributes --->
	<cfparam name="attributes.name" type="string" />
	<cfparam name="attributes.type" type="string" />
	<cfparam name="attributes.label" type="string" default="#attributes.name#" />
	<cfparam name="attributes.value" type="string" default="" />
	<cfparam name="attributes.length" type="numeric" default="0" />
<</cfsilent>
<cfoutput>
<cfif attributes.type eq "boolean">
	<uform:field label="#attributes.label#" name="#attributes.name#" type="radio">
		<uform:radio label="Yes" value="1" isChecked="#isBoolean(attributes.value) and attributes.value#" />
		<uform:radio label="No" value="0" isChecked="#isBoolean(attributes.value) and not attributes.value#" />
	</uform:field>
<cfelseif attributes.type eq "date">
	<uform:field name="#attributes.name#" type="date" value="#attributes.value#" />
<cfelseif attributes.length LTE 65535>
	<uform:field name="#attributes.name#" type="text" value="#attributes.value#" />
<cfelse>
	<uform:field name="#attributes.name#" type="textarea" value="#attributes.value#" />
</cfif>
</cfoutput>
