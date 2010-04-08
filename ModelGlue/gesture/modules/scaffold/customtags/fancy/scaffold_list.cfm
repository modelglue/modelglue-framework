<cfif thisTag.executionMode eq "start"><cfexit method="exittemplate" /></cfif>
<cfimport taglib="/modelglueextensions/jQuery/cfuniform/tags/forms/cfUniForm/" prefix="uform" />
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
	
	<cfset caller.event.addCSSAssetFile( "ui/css/smoothness/jquery-ui-1.8.custom.css" ) />
	<cfset caller.event.addCSSAssetFile( "dataTables/media/css/demo_page.css" ) />
	<cfset caller.event.addCSSAssetFile( "dataTables/media/css/demo_table_jui.css" ) />
	
	<cfoutput>
	<cfsavecontent variable="dataTablesCSS"> <!--- dataTables styling --->
		<style type="text/css" media="all">
			.dataTables_wrapper {
				margin-bottom: 1em;
				min-height: 0;
			}
			.dataTables_wrapper table {
				width: 100%;
			}
			.dataTables_wrapper table th {
				text-align: center;
			}
			.dataTables_wrapper table td.button {
				text-align: center;
			}
			.dataTables_wrapper table a.viewLink {
				background: none;
			}
			
			.ui-button, .ui-dialog {
				font-size: 1em;
			}
			.ui-button-text-only .ui-button-text {
				padding: .2em .6em;
			}
			
			.ctrlHolder .dataTables_wrapper .dataTables_length select {
				border-style: none;
				background-color: none;
				float: none;
				width: auto;
			}
			.ctrlHolder .dataTables_wrapper .dataTables_filter input {
				background-color: none;
				border-style: none;
			}
		</style>
	</cfsavecontent>
	</cfoutput>
	
	<cfset caller.event.addCSSAssetCode( dataTablesCSS ) />
	
	<cfset caller.event.addJSAssetFile( "core/jquery-1.4.2.min.js" ) />
	<cfset caller.event.addJSAssetFile( "ui/js/jquery-ui-1.8.custom.min.js" ) />
	<cfset caller.event.addJSAssetFile( "dataTables/media/js/jquery.dataTables.min.js" ) />
	
	<cfoutput>
	<cfsavecontent variable="dataTablesJS"> <!--- dataTables JavaScript configuration --->
		<script type="text/javascript" charset="utf-8">
			$(document).ready(function() {
				
				var th = $("###tableId# thead th");
				var columns = [];
				
				th.each(function(index) {
					if (index < th.length - 2)
						columns.push( null );
					else
						columns.push( { "bSearchable": false, "bSortable": false } );
				} );
				
				$("###tableId#").dataTable( {
					"aoColumns": columns,
					"bAutoWidth": false,
					"bJQueryUI": true,
					"fnDrawCallback": setButtons
				} );
				
				$("td.delete a").live("click", function() {
					var linkTarget = $(this).attr("href");
					var entityName = "#attributes.name#";
					
					$("<div>Are you sure you wish to delete this " + entityName + "?</div>").appendTo("body").dialog( {
						buttons: {
							Cancel: function() {
								$(this).dialog("close").remove();
							},
							OK: function() {
								window.location.href = linkTarget;
								$(this).dialog("close").remove();
							}
						},
						modal: true,
						title: "Delete " + entityName
					} );
					
					return false;
				} );
				
			} );
			
			function setButtons() {
				$("td.button a, .addLink").button();
			}
		</script>
	</cfsavecontent>
	</cfoutput>
	
	<cfset caller.event.addJSAssetCode( dataTablesJS ) />

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
	<cfif isEmbedded>
		<cfset newLink = attributes.editEvent />
		<cfloop list='#attributes.parentPKList#' index='pk'>
			<cfset newLink = listAppend(newLink,"#pk#=#evaluate('attributes.record.get#pk#()')#","&") />
		</cfloop>
		<a href="#newLink#" class="addLink">Add to #attributes.label#</a>
	</cfif>
</cfsavecontent>

<!--- Produce output here --->
<cfif attributes.onEditForm>
	<uform:field type="custom">
		#attributes.label#
		#theTable#
	</uform:field>
<cfelse>
<div>
	#theTable#
</div>
</cfif>
</cfoutput>
