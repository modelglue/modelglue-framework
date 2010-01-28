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
	<cfif isQuery(attributes.theList)>
	    <cfloop query="attributes.theList">
			<tr>	
			    <cfloop list="#attributes.displayPropertyList#"  index="thisProp">
		        	<td><a href="#attributes.viewEvent#<cfloop list='#attributes.primaryKeyList#' index='pk'>&#pk#=#attributes.theList[pk][attributes.theList.currentRow]#</cfloop>">#attributes.theList[listFirst(thisProp,'^')][attributes.theList.currentRow]#</a></td>
				</cfloop>
	        	<td><a href="#attributes.editEvent#<cfloop list='#attributes.primaryKeyList#' index='pk'>&#pk#=#attributes.theList[pk][attributes.theList.currentRow]#</cfloop>">Edit</a></td>
	        	<td><a href="#attributes.deleteEvent#<cfloop list='#attributes.primaryKeyList#' index='pk'>&#pk#=#attributes.theList[pk][attributes.theList.currentRow]#</cfloop>">Delete</a></td>
			</tr>
		</cfloop>
	<cfelseif isStruct(attributes.theList)>
		<cfloop collection="#attributes.theList#" item="theObject">
			<tr>	
			    <cfloop list="#attributes.displayPropertyList#"  index="thisProp">
		        	<td><a href="#attributes.viewEvent#<cfloop list='#attributes.primaryKeyList#' index='pk'>&#pk#=#evaluate('attributes.theList[theObject].get#pk#()')#</cfloop>">#evaluate('attributes.theList[theObject].get#listFirst(thisProp,'^')#()')#</a></td>
				</cfloop>
	        	<td><a href="#attributes.editEvent#<a href="#attributes.viewEvent#<cfloop list='#attributes.primaryKeyList#' index='pk'>&#pk#=#evaluate('attributes.theList[theObject].get#pk#()')#</cfloop>">Edit</a></td>
	        	<td><a href="#attributes.deleteEvent#<a href="#attributes.viewEvent#<cfloop list='#attributes.primaryKeyList#' index='pk'>&#pk#=#evaluate('attributes.theList[theObject].get#pk#()')#</cfloop>">Delete</a></td>
			</tr>
		</cfloop>
	<cfelseif isArray(attributes.theList)>
		<cfloop from="1" to="#arrayLen(attributes.theList)#" index="theObject">
			<tr>	
			    <cfloop list="#attributes.displayPropertyList#"  index="thisProp">
		        	<td><a href="#attributes.viewEvent#<cfloop list='#attributes.primaryKeyList#' index='pk'>&#pk#=#evaluate('attributes.theList[theObject].get#pk#()')#</cfloop>">#evaluate('attributes.theList[theObject].get#listFirst(thisProp,'^')#()')#</a></td>
				</cfloop>
	        	<td><a href="#attributes.editEvent#<a href="#attributes.viewEvent#<cfloop list='#attributes.primaryKeyList#' index='pk'>&#pk#=#evaluate('attributes.theList[theObject].get#pk#()')#</cfloop>">Edit</a></td>
	        	<td><a href="#attributes.deleteEvent#<a href="#attributes.viewEvent#<cfloop list='#attributes.primaryKeyList#' index='pk'>&#pk#=#evaluate('attributes.theList[theObject].get#pk#()')#</cfloop>">Delete</a></td>
			</tr>
		</cfloop>
	</cfif>
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
