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

