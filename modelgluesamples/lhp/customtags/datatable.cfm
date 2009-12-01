<cfsetting enablecfoutputonly=true>
<!---
	Name         : datatable.cfm
	Author       : Raymond Camden 
	Created      : June 02, 2004
	Last Updated : 6/22/06
	History      : JS fix (7/23/04)
				   Minor formatting updates (rkc 8/29/05)
				   finally add sorting (rkc 9/9/05)
				   Add hack for severity (rkc 1/30/06)
				   Add hack for links and null dates (rkc 6/22/06)
				   Edited javascript:checksubmit() function to display confirmation dialog for deletes (11/14/08, Martijn van der Woud) 
	Purpose		 : A VERY app specific datable tag. 
--->

<cfif thisTag.hasEndTag and thisTag.executionMode is "start">
	<cfsetting enablecfoutputonly=false>
	<cfexit method="EXITTEMPLATE">
</cfif>

<cfparam name="attributes.data" type="query">
<cfparam name="attributes.linkcol" default="#listFirst(attributes.data.columnList)#">
<cfparam name="attributes.linkval" default="id">
<cfparam name="attributes.list" default="#attributes.data.columnList#">
<cfparam name="attributes.labellist" default="#attributes.list#">
<cfparam name="url.page" default="1">
<cfparam name="url.sort" default="">
<cfparam name="url.dir" default="asc">

<cfparam name="attributes.deleteMsg" default="Are you sure?">
<cfparam name="attributes.queryString" default="">
<cfparam name="attributes.noadd" default="false">
<cfparam name="attributes.deleteLink" default="#cgi.script_name#?#attributes.queryString#">

<cfset perpage = 20>
<cfset colWidths = structNew()>
<cfset formatCols = structNew()>
<cfset colData = structNew()>
<cfset dontSortList = "">

<!--- allow for datacol overrides --->
<cfif structKeyExists(thisTag,"assocAttribs")>
	<cfset attributes.list = "">
	<cfset attributes.labellist = "">
  
	<cfloop index="x" from="1" to="#arrayLen(thisTag.assocAttribs)#">
		<cfset attributes.list = listAppend(attributes.list, thisTag.assocAttribs[x].name)>
		<cfif structKeyExists(thisTag.assocAttribs[x], "label")>
			<cfset label = thisTag.assocAttribs[x].label>
		<cfelse>
			<cfset label = thisTag.assocAttribs[x].name>
		</cfif>
		<cfif structKeyExists(thisTag.assocAttribs[x], "format")>
			<cfset formatCols[thisTag.assocAttribs[x].name] = thisTag.assocAttribs[x].format>
		</cfif>		
		<cfset attributes.labellist = listAppend(attributes.labellist, label)>
		<cfif structKeyExists(thisTag.assocAttribs[x], "width")>
			<cfset colWidths[label] = thisTag.assocAttribs[x].width>
		</cfif>
		<cfif structKeyExists(thisTag.assocAttribs[x], "data") and len(thisTag.assocAttribs[x].data)>
			<cfset colData[thisTag.assocAttribs[x].name] = thisTag.assocAttribs[x].data>
		</cfif>
		<cfif structKeyExists(thisTag.assocAttribs[x], "sort") and not thisTag.assocAttribs[x].sort>
			<cfset dontSortList = listAppend(dontSortList, thisTag.assocAttribs[x].name)>
		</cfif>
	</cfloop>
</cfif>


<cfif url.dir is not "asc" and url.dir is not "desc">
	<cfset url.dir = "asc">
</cfif>

<cfif len(trim(url.sort)) and len(trim(url.dir))>

	<cfquery name="attributes.data" dbtype="query">
	select 	*
	from	attributes.data
	<!--- Probably should be abstracted --->
	<cfif url.sort is "severityname">
		<cfset sort = "severityrank">
	<cfelse>
		<cfset sort = url.sort>
	</cfif>
	order by 	#sort# #url.dir#
	</cfquery>
</cfif>

<cfif not isNumeric(url.page) or url.page lte 0>
	<cfset url.page = 1>
</cfif>

<cfif isDefined("url.msg")>
	<cfoutput>
	<p>
	<b>#url.msg#</b>
	</p>
	</cfoutput>
</cfif>

<cfoutput>

<script>
function checksubmit() {
	var confirmState=window.confirm("DELETE - are you sure?");
	if (confirmState) {
		if(document.listing.mark.length == null) {
			if(document.listing.mark.checked) {
				document.listing.submit();
				return;
			}
		}
	
		for(i=0; i < document.listing.mark.length; i++) {
			if(document.listing.mark[i].checked) document.listing.submit();
		}
	}
}
</script>

<cfif attributes.data.recordCount gt perpage>
	<p align="right">
	[[
	<cfif url.page gt 1>
		<a href="#cgi.script_name#?page=#url.page-1#&sort=#urlEncodedFormat(url.sort)#&dir=#url.dir#&#attributes.querystring#">Previous</a>
	<cfelse>
		Previous
	</cfif>
	--
	<cfif url.page * perpage lt attributes.data.recordCount>
		<a href="#cgi.script_name#?page=#url.page+1#&sort=#urlEncodedFormat(url.sort)#&dir=#url.dir#&#attributes.querystring#">Next</a>
	<cfelse>
		Next
	</cfif>
	]]
	</p>
</cfif>

<p>
<form name="listing" action="#attributes.deletelink#" method="post">
<table id="listing" cellspacing="0">

	<tr class="hdRow">
		<td width="30">&nbsp;</td>
		<cfset counter = 0>
		<cfloop index="c" list="#attributes.labellist#">
			<cfset counter = counter + 1>
			<cfset col = listGetAt(attributes.list, counter)>
			<cfif url.sort is col and url.dir is "asc">
				<cfset dir = "desc">
			<cfelse>
				<cfset dir = "asc">
			</cfif>
			<td <cfif structKeyExists(colWidths, c)>width="#colWidths[c]#"</cfif> >
			<!--- static rewrites of a few of the columns --->
			<cfif not listFind(dontSortList, col)>
				<a href="#cgi.script_name#?page=#url.page#&sort=#urlEncodedFormat(col)#&dir=#dir#&#attributes.querystring#">#c#</a>
			<cfelse>
				#c#
			</cfif>
			</td>
		</cfloop>
	</tr>
</cfoutput>

<cfif attributes.data.recordCount>
	<cfoutput query="attributes.data" startrow="#(url.page-1)*perpage + 1#" maxrows="#perpage#">
		<tr <cfif currentRow mod 2 is 0>class="dark"</cfif>>
			<td width="20"><input type="checkbox" name="mark" value="#attributes.data[attributes.linkval][currentRow]#"></td>
			<cfloop index="c" list="#attributes.list#">
				<cfif not structKeyExists(colData, c)>
					<cfset value = attributes.data[c][currentRow]>
					<cfset value = htmlEditFormat(value)>
				<cfelse>
					<cfset value = colData[c]>
					<cfset value = replace(value, "$id$", id, "all")>
				</cfif>
				<cfif value is "">
					<cfset value = "&nbsp;">
				</cfif>
				<cfif structKeyExists(formatCols, c)>
					<cfswitch expression="#formatCols[c]#">

						<cfcase value="yesno">
							<cfset value = yesNoFormat(value)>
						</cfcase>
						
						<cfcase value="datetime">
							<cfset value = dateFormat(value,"mm/dd/yy") & " " & timeFormat(value,"h:mm tt")>
						</cfcase>

						<cfcase value="date">
							<cfif value is not "&nbsp;">
								<cfset value = dateFormat(value,"mm/dd/yy")>
							</cfif>
						</cfcase>

						<cfcase value="currency">
							<cfset value = dollarFormat(value)>
						</cfcase>

						<cfcase value="email">
							<cfset value = "<a href=""mailto:#value#"">#value#</a>">
						</cfcase>
						
					</cfswitch>
				</cfif>
				<td>
				<cfif c is attributes.linkcol>
				<a href="#attributes.editlink#&id=#attributes.data[attributes.linkval][currentRow]#">#value#</a>
				<cfelse>
				#value#
				</cfif>
				</td>
			</cfloop>
		</tr>
	</cfoutput>
<cfelse>

</cfif>

<cfoutput>
</table>
</form>
</p>

<p align="right" id="dtable">
[<a href="#attributes.editlink#">Add #attributes.label#</a>] [<a href="javascript:checksubmit()">Delete Selected</a>]
</p>
</cfoutput>

<cfsetting enablecfoutputonly=false>

<cfexit method="EXITTAG">