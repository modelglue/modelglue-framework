<cfif thisTag.executionMode eq "start"><cfexit method="exittemplate" /></cfif>
<cfimport taglib="/modelglueextensions/cfuniform/tags/forms/cfUniForm/" prefix="uform" />
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
		
	<cfset pagerContainer = attributes.name & "Pager" />
	<cfset tableId = attributes.name & "Table" />

	<cfsavecontent variable="tableSorterInit"> <!--- TableSorter jquery requirements --->
		<style type="text/css" title="currentStyle">
			@import "www/themes/blue/style.css";
		</style>
		<script type="text/javascript" language="javascript" src="www/js/jquery-1.3.2.min.js"></script>
		<script type="text/javascript" language="javascript" src="www/js/jquery.tablesorter.min.js"></script>
		<script type="text/javascript" language="javascript" src="www/addons/pager/jquery.tablesorter.pager.js"></script>
		<script type="text/javascript" charset="utf-8">
		$(document).ready(function() {
			<cfoutput>
			$("###tableId#")
				.tablesorter({widthFixed: true, widgets: ["zebra"]})
				.tablesorterPager({container: $("###pagerContainer#"), size: 5});
			</cfoutput>
		});
		</script>
	</cfsavecontent>
	<cfhtmlhead text="#tableSorterInit#">

</cfsilent>
<cfoutput>
<cfsavecontent variable="theTable">
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
</cfsavecontent>

<!--- Produce output here --->
<cfif attributes.onEditForm>
	<uform:field type="custom">
		#attributes.label#
		#theTable#
	</uform:field>
<cfelse>
	#theTable#
</cfif>
</cfoutput>