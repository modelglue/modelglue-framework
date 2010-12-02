<cfif thisTag.executionMode eq "start"><cfexit method="exittemplate" /></cfif>
<cfinclude template="../listHelperFunctions.cfm" />
<cfsilent>
	<!--- tag attributes --->
	<cfparam name="attributes.displayPropertyList" type="string" />
	<cfparam name="attributes.primaryKeyList" type="string" />
	<cfparam name="attributes.theList" type="any" />
	<cfparam name="attributes.viewEvent" type="string" />
	<cfparam name="attributes.editEvent" type="string" />
	<cfparam name="attributes.deleteEvent" type="string" />
	<cfparam name="attributes.name" type="string" />
	<cfparam name="attributes.record" type="any" default="" />
	<cfparam name="attributes.label" type="string" default="" />
	<cfparam name="attributes.parentPKList" type="string" default="" />
	<cfparam name="attributes.onEditForm" type="boolean" default="false" />
	
	<cfset isEmbedded = len(attributes.label) gt 0 /> 
	<cfset tableId = attributes.name & "Table" />

</cfsilent>
<cfoutput>
<cfsavecontent variable="theTable">
	<table id="#tableId#">
	    <thead>
		<tr>
			 <cfloop list="#attributes.displayPropertyList#" index="thisProp">
				<th>#listLast(thisProp,"^")#</th>
			</cfloop>
			<th>&nbsp;</th>	
			<th>&nbsp;</th>	
		</tr>
	    </thead>
		<cfif isEmbedded>
		    <tfoot>
			<cfset newLink = attributes.editEvent />
			<cfloop list='#attributes.parentPKList#' index='pk'>
				<cfset newLink = listAppend(newLink,"#pk#=#evaluate('attributes.record.get#pk#()')#","&") />
			</cfloop>
			<th colspan="#listLen(attributes.displayPropertyList)#">
				<a href="#newLink#">Add to #attributes.label#</a>
			</th>
		    </tfoot>
		</cfif>
	    <tbody>
		<cfif isQuery(attributes.theList)>
		    <cfloop query="attributes.theList">
				<tr>	
				    <cfloop list="#attributes.displayPropertyList#"  index="thisProp">
						<cfset viewLink = attributes.viewEvent />
						<cfloop list='#attributes.primaryKeyList#' index='pk'>
							<cfset viewLink = listAppend(viewLink,"#pk#=#attributes.theList[pk][attributes.theList.currentRow]#","&") />
						</cfloop>
						#makeColumn(attributes.displayPropertyList,thisProp,viewLink,attributes.theList[listFirst(thisProp,'^')][attributes.theList.currentRow])#
					</cfloop>
    				#makeLinks(viewLink,attributes.viewEvent,attributes.editEvent,attributes.deleteEvent)#
				</tr>
			</cfloop>
		<cfelseif isStruct(attributes.theList)>
			<cfloop collection="#attributes.theList#" item="theObject">
				#makeRow(attributes.displayPropertyList,attributes.primaryKeyList,attributes.theList[theObject],attributes.viewEvent,attributes.editEvent,attributes.deleteEvent)#
			</cfloop>
		<cfelseif isArray(attributes.theList)>
			<cfloop from="1" to="#arrayLen(attributes.theList)#" index="theObject">
				#makeRow(attributes.displayPropertyList,attributes.primaryKeyList,attributes.theList[theObject],attributes.viewEvent,attributes.editEvent,attributes.deleteEvent)#
			</cfloop>
		</cfif>
	    </tbody>
	</table>
</cfsavecontent>

<!--- Produce output here --->
<cfif isEmbedded>
	<div class="formfield">
	<label for="#attributes.name#"><b>#attributes.label#:</b></label>
</cfif>
<cfif attributes.onEditForm>
	#attributes.label#
	#theTable#
<cfelse>
	#theTable#
</cfif>
<cfif isEmbedded>
	</div>
</cfif>
</cfoutput>
