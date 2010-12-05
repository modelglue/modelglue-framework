<cfloop list="#event.getValue("js")#" index="i">
	<cfset event.addJsAssetFile(i) />
</cfloop>
<cfloop list="#event.getValue("css")#" index="i">
	<cfset event.addCssAssetFile(i) />
</cfloop>

