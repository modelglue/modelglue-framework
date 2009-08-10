
<cfswitch expression="#thisTag.executionMode#">

<cfcase value="start">
	<div class="submit">
</cfcase>
<cfcase value="end">
<cfoutput>
	</div>
</cfoutput>
</cfcase>
</cfswitch>