<cfset event.setValue("title", "Milestones")>
<cfset projects = event.getValue("projects")>
<cfset root = event.getValue("myself")>
<cfset lastproject = event.getValue("lastproject")>

<script>
$(document).ready(function() {
	$("#project").change(function() {
		var selproject = $("#project option:selected").val()
		if(selproject == '') { $("#milestonelist").html(""); return; }
		$("#milestonelist").html("<img src='images/ajax-loader.gif'>")
		<cfoutput>$("##milestonelist").load('#root#page.milestonelist&project='+selproject)</cfoutput>
	})
	
	<cfif lastproject neq "">
	<cfoutput>$("##milestonelist").load('#root#page.milestonelist&project=#lastproject#')</cfoutput>
	</cfif>
})
</script>	

<h2 class="red">Milestones</h2>	

<cfoutput>
<form name="pForm" method="get">
<p>
<b>Project:</b>
<select name="project" id="project">
<option vaue=""></option>
<cfloop query="projects">
<option value="#id#" <cfif lastproject is id>selected</cfif>>#name#</option>
</cfloop>
</select>
</p>
</form>
</cfoutput>

<div id="milestonelist"></div>
