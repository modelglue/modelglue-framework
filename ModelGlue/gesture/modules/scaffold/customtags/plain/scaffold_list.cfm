<cfif thisTag.executionMode eq "start"><cfexit method="exittemplate" /></cfif>
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
	    <tfoot>
		<tr>
			 <cfloop list="#attributes.displayPropertyList#" index="thisProp">
				<th>#listLast(thisProp,"^")#</th>
			</cfloop>
			<th>&nbsp;</th>	
			<th>&nbsp;</th>	
		</tr>
		<cfif isEmbedded>
			<cfset newLink = attributes.editEvent />
			<cfloop list='#attributes.parentPKList#' index='pk'>
				<cfset newLink = listAppend(newLink,"#pk#=#evaluate('attributes.record.get#pk#()')#","&") />
			</cfloop>
			<th colspan="#listLen(attributes.displayPropertyList)#">
				<a href="#newLink#">Add to #attributes.label#</a>
			</th>
		</cfif>
	    </tfoot>
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
<cfif attributes.onEditForm>
	#attributes.label#
	#theTable#
<cfelse>
	#theTable#
</cfif>
</cfoutput>

<cffunction name="makeColumn" output="true" hint="I generate a <td> for a table column">
	<cfargument name="displayPropertyList" />
	<cfargument name="thisProp" />
	<cfargument name="viewLink" />
	<cfargument name="propValue" />

	<cfoutput>
	<td<cfif listFirst(arguments.displayPropertyList) neq arguments.thisProp> class="criterion"</cfif>>
		<cfif listFirst(arguments.displayPropertyList) eq arguments.thisProp>
			<a href="#arguments.viewLink#">
		</cfif>
		#arguments.propValue#
		<cfif listFirst(arguments.displayPropertyList) eq arguments.thisProp>
			</a>
		</cfif>
	</td>
	</cfoutput>
</cffunction>

<cffunction name="makeRow" output="true" hint="I generate a <tr> for a table row - used with Structs and Arrays of objects">
	<cfargument name="displayPropertyList" />
	<cfargument name="primaryKeyList" />
	<cfargument name="theObject" />
	<cfargument name="viewEvent" />
	<cfargument name="editEvent" />
	<cfargument name="deleteEvent" />

	<cfoutput>
	<tr>	
	    <cfloop list="#arguments.displayPropertyList#"  index="thisProp">
			<cfset viewLink = arguments.viewEvent />
			<cfloop list='#arguments.primaryKeyList#' index='pk'>
				<cfset viewLink = listAppend(viewLink,"#pk#=#evaluate('arguments.theObject.get#pk#()')#","&") />
			</cfloop>
			#makeColumn(arguments.displayPropertyList,thisProp,viewLink,evaluate('arguments.theObject.get#listFirst(thisProp,'^')#()'))#
		</cfloop>
		#makeLinks(viewLink,arguments.viewEvent,arguments.editEvent,arguments.deleteEvent)#
	</tr>
	</cfoutput>
</cffunction>

<cffunction name="makeLinks" output="true" hint="I generate <td>s for the Edit and Delete events">
	<cfargument name="viewLink" />
	<cfargument name="viewEvent" />
	<cfargument name="editEvent" />
	<cfargument name="deleteEvent" />

	<cfoutput>
	<td><a href="#replaceNoCase(arguments.viewLink,arguments.viewEvent,arguments.editEvent)#">Edit</a></td>
	<td><a href="#replaceNoCase(arguments.viewLink,arguments.viewEvent,arguments.deleteEvent)#">Delete</a></td>
	</cfoutput>
</cffunction>

