<cfparam name="attributes.section" />
<cfparam name="attributes.event" />

<cfswitch expression="#thisTag.executionMode#">

<cfcase value="start">
	<cfoutput>
		<strong>#attributes.section.title#</strong>
		<ul class="navlist">
			<cfloop from="1" to="#arrayLen(attributes.section.items)#" index="i">
				<li>
					<cfif structKeyExists(attributes.section.items[i], "renderingTag")>
						<cfmodule template="#attributes.section.items[i].renderingTag#" item="#attributes.section.items[i]#" event="#attributes.event#" />				
					<cfelse>
						<a href="#attributes.event.linkTo(attributes.section.items[i].event)#">#attributes.section.items[i].label#</a>
					</cfif>
				</li>
			</cfloop>
		</ul>	
	</cfoutput>
</cfcase>
<cfcase value="end">
<cfoutput>
</cfoutput>
</cfcase>
</cfswitch>