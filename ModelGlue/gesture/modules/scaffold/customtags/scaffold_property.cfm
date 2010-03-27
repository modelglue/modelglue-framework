<cfif thisTag.executionMode eq "start"><cfexit method="exittemplate" /></cfif>
<cfimport taglib="/cfUniForm/" prefix="uform" />
<cfsilent>
	<!--- tag attributes --->
	<cfparam name="attributes.name" type="string" />
	<cfparam name="attributes.type" type="string" />
	<cfparam name="attributes.label" type="string" default="#attributes.name#" />
	<cfparam name="attributes.value" type="string" default="" />
	<cfparam name="attributes.length" type="numeric" default="0" />
	<cfparam name="attributes.event" type="any" />
<</cfsilent>
<cfoutput>
<cfif structKeyExists(attributes,"event") and attributes.event.valueExists(attributes.name)>
	<cfset attributes.value = attributes.event.getValue(attributes.name) />
</cfif>
<cfif attributes.type eq "boolean">
	<uform:field label="#attributes.label#" name="#attributes.name#" type="radio">
		<uform:radio label="Yes" value="1" isChecked="#isBoolean(attributes.value) and attributes.value#" />
		<uform:radio label="No" value="0" isChecked="#isBoolean(attributes.value) and not attributes.value#" />
	</uform:field>
<cfelseif attributes.type eq "date">
	<uform:field label="#attributes.label#" name="#attributes.name#" type="date" value="#attributes.value#" />
<cfelseif attributes.length LTE 65535>
	<uform:field label="#attributes.label#" name="#attributes.name#" type="text" value="#attributes.value#" />
<cfelse>
	<uform:field label="#attributes.label#" name="#attributes.name#" type="textarea" value="#attributes.value#" />
</cfif>
</cfoutput>
