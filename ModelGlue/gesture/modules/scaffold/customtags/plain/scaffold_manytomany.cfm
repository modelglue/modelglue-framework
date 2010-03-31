<cfif thisTag.executionMode eq "start"><cfexit method="exittemplate" /></cfif>
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
<div class="formfield">
	<label for="#attributes.name#"><b>#attributes.label#:</b></label>
	<span class="input">
		<!--- 
		hidden makes the field always defined.  if this was not here, and you deleted this whole field
		from the control, you would wind up deleting all child records during a genericCommit...
		--->
		<input type="hidden" name="#attributes.name#" value="" />
		
		<div class="formfieldinputstack">
			<cfloop query="attributes.valueQuery">
				<label for="#attributes.name#_#attributes.valueQuery[attributes.name][attributes.valueQuery.currentRow]#">
					<input type="checkbox" name="#attributes.name#_#attributes.valueQuery[attributes.name][attributes.valueQuery.currentRow]#" id="#attributes.name#_#attributes.valueQuery[attributes.name][attributes.valueQuery.currentRow]#" value="#attributes.valueQuery[attributes.name][attributes.valueQuery.currentRow]#"<cfif listFindNoCase(attributes.selectedList, attributes.valueQuery[attributes.name][attributes.valueQuery.currentRow])> checked</cfif>/>
					#attributes.valueQuery[attributes.childDescProperty][attributes.valueQuery.currentRow]#
				</label><br />
			</cfloop>
		</div>
	</span>
</div>
</cfoutput>
