<cfif thisTag.executionMode eq "start"><cfexit method="exittemplate" /></cfif>
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
<</cfsilent>
<cfoutput>
<div class="formfield">
	<label for="#attributes.name#"><b>#attributes.label#:</b></label>
	<span class="input">
		<select id="#attributes.name#" name="#attributes.name#">
			<cfif attributes.nullable>
				<option value=""></option>
			</cfif>
			<cfloop query="attributes.valueQuery">
				<option value="#attributes.valueQuery[attributes.name][attributes.valueQuery.currentRow]#"
					<cfif attributes.value eq attributes.valueQuery[attributes.name][attributes.valueQuery.currentRow]> selected="selected"</cfif>
				>
					#attributes.valueQuery[attributes.childDescProperty][attributes.valueQuery.currentRow]#
				</option>
			</cfloop>
		</select>
		<!--- TODO: Delete this?
		<cfmodule template="/ModelGlue/customtags/validationErrors.cfm" property="#attributes.objectName#" validation="#attributes.validation#" />
		--->
	</span>
</div>
</cfoutput>
