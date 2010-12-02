<cfcomponent output="false">

<cffunction name="init" output="false" returntype="ModelGlue.gesture.modules.asset.manager.AssetManager">
	<cfargument name="CSSPrefix" type="string" required="true" />
	<cfargument name="IECSSSuffix" type="string" required="true" />
	<cfargument name="IECSSPrefix" type="string" required="true" />
	<cfargument name="CSSSuffix" type="string" required="true" />
	<cfargument name="JSPrefix" type="string" required="true" />
	<cfargument name="JSSuffix" type="string" required="true" />
	
	<cfset variables.CSSPrefix = replaceHTMLEntities(arguments.CSSPrefix) />
	<cfset variables.CSSSuffix = replaceHTMLEntities(arguments.CSSSuffix) />
	<cfset variables.IECSSPrefix = replaceHTMLEntities(arguments.IECSSPrefix) />
	<cfset variables.IECSSSuffix = replaceHTMLEntities(arguments.IECSSSuffix) />
	<cfset variables.JSPrefix = replaceHTMLEntities(arguments.JSPrefix) />
	<cfset variables.JSSuffix = replaceHTMLEntities(arguments.JSSuffix) />
	
	<cfreturn this />
</cffunction>

<!--- Dependencies --->
<cffunction name="setModelGlue" output="false" returntype="void" hint="Sets the MG instance to use.">
	<cfargument name="modelGlue" required="true" type="ModelGlue.gesture.ModelGlue" />
	
	<cfset variables._modelGlue = arguments.modelGlue />
</cffunction>

<!--- Methods --->
<cffunction name="getAssetFileTag" output="false" returntype="string" hint="Returns the rendered HTML tag for an asset file.">
	<cfargument name="type" type="string" required="true" />
	<cfargument name="path" type="string" required="true" />
	<cfargument name="ieOnly" type="boolean" required="false" default="false" />
	
	<cfset var mapping = 0 />
	<cfset var fullPath = "" />
	<cfset var fileFound = false />
	<cfset var assetMappings = variables._modelGlue.configuration.assetMappings />
	
	<cfloop from="1" to="#arrayLen(assetMappings)#" index="mapping">
		<cfset fullPath = assetMappings[mapping] & "/" & arguments.path />
		
		<cfif fileExists(expandPath(fullPath))>
			<cfset fileFound = true />
			<cfbreak />
		</cfif>	
	</cfloop>
	
	<!--- Should this <cfthrow> be removed? Perhaps it's better for missing assets to error silently... --->
	<!--- <cfif not fileFound>
		<cfthrow type="AssetManager.fileNotFound"
			message="The asset file (#arguments.path#) was not found in any registered asset mappings (#arrayToList(assetMappings)#)." />
	</cfif> --->
	
	<cfif arguments.ieOnly and arguments.type is "CSS">
		<cfset arguments.type = "IECSS" />
	</cfif>
	
	<cfreturn variables["#arguments.type#Prefix"] & fullPath & variables["#arguments.type#Suffix"] />
</cffunction>

<cffunction name="renderAssetsInHead" output="false" returntype="void" hint="Renders all assets for the request using <cfhtmlhead>.">
	<cfargument name="transientAssets" type="string" required="true" />
	
	<cfhtmlhead text="#arguments.transientAssets#" />
</cffunction>

<cffunction name="replaceHTMLEntities" output="false" returntype="string" hint="Replaces escaped HTML entities with angle bracket characters.">
	<cfargument name="value" type="string" required="true" />
	
	<cfreturn replaceNoCase(replaceNoCase(value, "&lt;", "<", "all"), "&gt;", ">", "all") />
</cffunction>

</cfcomponent>