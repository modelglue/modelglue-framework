<cfif thisTag.executionMode eq "start"><cfexit method="exittemplate" /></cfif>
<cfimport taglib="/views/customtags/forms/cfUniForm/" prefix="uform" />
<cfsilent>
	<!--- tag attributes --->
	<cfparam name="attributes.displayPropertyList" type="string" />
	<cfparam name="attributes.primaryKeyList" type="string" />
	<cfparam name="attributes.theList" type="any" />
	<cfparam name="attributes.viewEvent" type="string" />
	<cfparam name="attributes.editEvent" type="string" />
	<cfparam name="attributes.deleteEvent" type="string" />
	<cfparam name="attributes.name" type="string" />
	<cfparam name="attributes.label" type="string" default="" />
	
	<cfset pagerContainer = attributes.name & "Pager" />
	<cfset tableId = attributes.name & "Table" />
	<cfset columnList = "" />
	<cfloop list="#attributes.displayPropertyList#" index="thisProp">
		<cfset columnList = listAppend(columnList,"""" & listLast(thisProp,"^") & """") />
	</cfloop>

	<cfsavecontent variable="tableSorterInit"> <!--- TableSorter jquery requirements --->
		<style type="text/css" title="currentStyle">
			@import "www/themes/blue/style.css";
		</style>
		<script type="text/javascript" language="javascript" src="www/js/jquery-1.3.2.min.js"></script>
		<script type="text/javascript" language="javascript" src="www/js/jquery.tablesorter.min.js"></script>
		<script type="text/javascript" language="javascript" src="www/addons/pager/jquery.tablesorter.pager.js"></script>
		<script type="text/javascript" src="www/js/jquery.uitablefilter.js"></script>
		<script type="text/javascript" charset="utf-8">
		<cfoutput>
		var #attributes.name#FilterText = "";
		var #attributes.name#ColumnArray = [#columnList#];
		</cfoutput>

		$(document).ready(function() {
			function filterTable(pagerId) {
				var prefix = pagerId.replace("Pager","");
				var tableId = prefix + "Table";
				var filterText = eval(prefix + "FilterText");
				var columnArray = eval(prefix + "ColumnArray");
			    for (i = 0; i < columnArray.length; i++) {
					$("#" + tableId + " tbody tr").find("td:eq(" + i + ")").filter(".criterion").unbind(".uifilter");
					$("#" + tableId + " tbody tr").find("td:eq(" + i + ")").filter(".criterion").bind("click.uifilter",(function(){
						clickedText = $(this).text();
						alert(clickedText);
						filterText = ((filterText == clickedText) ? "" : clickedText);
						$.uiTableFilter($("#" + tableId), filterText, columnArray[i]);
					}));
				}
			}
			
			<cfoutput>
			$("###tableId#")
				.tablesorter({widthFixed: true, widgets: ["zebra"]})
				.tablesorterPager({container: $("###pagerContainer#"), size: 5});
			filterTable("#attributes.name#");
			
			$("###pagerContainer#").click(function(){
				filterTable("#attributes.name#");
			});

			</cfoutput>
		});

		</script>
	</cfsavecontent>
	<cfhtmlhead text="#tableSorterInit#">

</cfsilent>
<cfoutput>
<cfif len(attributes.label) neq 0>
	<div class="formfield">
		<label for="#attributes.label#"><b>#attributes.label#:</b></label>
		<span class="input">
</cfif>
			<table id="#tableId#" class="tablesorter">
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
			<div id="#pagerContainer#" class="pager">
				<form>
					<img src="www/addons/pager/icons/first.png" class="first"/>
					<img src="www/addons/pager/icons/prev.png" class="prev"/>
					<input type="text" class="pagedisplay"/>
					<img src="www/addons/pager/icons/next.png" class="next"/>
					<img src="www/addons/pager/icons/last.png" class="last"/>
					<select class="pagesize">
						<option selected="selected" value="5">5</option>
						<option value="10">10</option>
						<option value="20">20</option>
						<option value="30">30</option>
						<option value="40">40</option>
					</select>
				</form>
			</div>
<cfif len(attributes.label) neq 0>
		</span>
	</div>
	<br />
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

