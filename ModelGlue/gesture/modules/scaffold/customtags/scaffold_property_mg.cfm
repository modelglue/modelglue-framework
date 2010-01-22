<cfif thisTag.executionMode eq "start"><cfexit method="exittemplate" /></cfif>
<cfsilent>
	<!--- tag attributes --->
	<cfparam name="attributes.name" type="string" />
	<cfparam name="attributes.type" type="string" />
	<cfparam name="attributes.label" type="string" default="#attributes.name#" />
	<cfparam name="attributes.value" type="string" default="" />
	<cfparam name="attributes.length" type="numeric" default="0" />
<</cfsilent>
<cfoutput>
<tr>	
	<td><label for="#attributes.name#">#attributes.label#</label></td>
	<td>
		<cfif attributes.type eq "boolean">
			<input type="radio" id="#attributes.name#_true" name="#attributes.name#" value="true"<cfif isBoolean(attributes.value) and attributes.value> checked="checked"</cfif>/>
			<label for="#attributes.name#_true"> Yes</label>
			<input type="radio" id="#attributes.name#_false" name="#attributes.name#" value="false"<cfif isBoolean(attributes.value) and not attributes.value >checked="checked"</cfif>/>
			<label for="#attributes.name#_false"> No</label>		
		<cfelseif attributes.length LTE 65535>
			<input type="text" class="input" id="#attributes.name#" name="#attributes.name#" value="<cfif attributes.type eq "date">#dateFormat(attributes.value,'m/d/yyyy')# #timeFormat(attributes.value,'h:mm TT')#<cfelse>#attributes.value#</cfif>" />
		<cfelse>
			<textarea class="input" id="#attributes.name#" name="#attributes.name#">#attributes.value#</textarea>
		</cfif>
	</td>
</tr>
</cfoutput>
