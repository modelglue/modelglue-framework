<cfif thisTag.executionMode eq "start"><cfexit method="exittemplate" /></cfif>
<cfimport taglib="/views/customtags/forms/cfUniForm/" prefix="uform" />
<cfsilent>
	<!--- tag attributes --->
	<cfparam name="attributes.displayPropertyList" type="string" />
	<cfparam name="attributes.primaryKeyList" type="string" />
	<cfparam name="attributes.theQuery" type="query" />
	<cfparam name="attributes.viewEvent" type="string" />
	<cfparam name="attributes.editEvent" type="string" />
	<cfparam name="attributes.deleteEvent" type="string" />
	
	<cfsavecontent variable="tableSorterInit"> <!--- TableSorter jquery requirements --->
		<style type="text/css" title="currentStyle">
			@import "www/themes/blue/style.css";
		</style>
		<script type="text/javascript" language="javascript" src="www/js/jquery-1.3.2.min.js"></script>
		<script type="text/javascript" language="javascript" src="www/js/jquery.tablesorter.min.js"></script>
		<script type="text/javascript" language="javascript" src="www/addons/pager/jquery.tablesorter.pager.js"></script>
		<script type="text/javascript" charset="utf-8">
		$(document).ready(function() {
			$("table.tablesorter")
				.tablesorter({widthFixed: true, widgets: ["zebra"]})
				.tablesorterPager({container: $("#pager")});
		});
		</script>
	</cfsavecontent>
	<cfhtmlhead text="#tableSorterInit#">

</cfsilent>
<cfoutput>
<table class="tablesorter">
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
    <cfloop query="attributes.theQuery">
		<tr>	
		    <cfloop list="#attributes.displayPropertyList#"  index="thisProp">
	        	<td><a href="#attributes.viewEvent#<cfloop list='#attributes.primaryKeyList#' index='pk'>&#pk#=#attributes.theQuery[pk][attributes.theQuery.currentRow]#</cfloop>">#attributes.theQuery[listFirst(thisProp,'^')][attributes.theQuery.currentRow]#</a></td>
			</cfloop>
        	<td><a href="#attributes.editEvent#<cfloop list='#attributes.primaryKeyList#' index='pk'>&#pk#=#attributes.theQuery[pk][attributes.theQuery.currentRow]#</cfloop>">Edit</a></td>
        	<td><a href="#attributes.deleteEvent#<cfloop list='#attributes.primaryKeyList#' index='pk'>&#pk#=#attributes.theQuery[pk][attributes.theQuery.currentRow]#</cfloop>">Delete</a></td>
		</tr>
	</cfloop>
    </tbody>
</table>
<div id="pager" class="pager">
	<form>
		<img src="www/addons/pager/icons/first.png" class="first"/>
		<img src="www/addons/pager/icons/prev.png" class="prev"/>
		<input type="text" class="pagedisplay"/>
		<img src="www/addons/pager/icons/next.png" class="next"/>
		<img src="www/addons/pager/icons/last.png" class="last"/>
		<select class="pagesize">
			<option selected="selected"  value="10">10</option>
			<option value="20">20</option>
			<option value="30">30</option>
			<option  value="40">40</option>
		</select>
	</form>
</div>
</cfoutput>
