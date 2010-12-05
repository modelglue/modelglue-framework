<cfcomponent output="false">

	<cffunction name="init" output="false">
		<cfargument name="Templates" type="struct" required="false" default="#structnew()#" />
		<cfargument name="AssetHosts" type="array" required="false" default="#arraynew(1)#" />
		<cfargument name="AssetHostsSSL" type="array" required="false" default="#arraynew(1)#" />
	
		<cfset var tpl = "" />
	
		<cfset variables.templates = structnew() />
		<!--- assign some sensible defaults for templates for the common types --->
		<cfset variables.templates["CSS"] = '<link type="text/css" rel="stylesheet" media="all" href="{{path}}" />' />
		<cfset variables.templates["IECSS"] = '<!--[if lte ie 8]><link type="text/css" rel="stylesheet" media="all" href="{{path}}" /><![endif]-->' />
		<cfset variables.templates["JS"] = '<script type="text/javascript" src="{{path}}"></script>' />
		<cfset variables.templates["ASSETNOTFOUND"] = '<!--ERROR: AssetManager could not locate asset {{path}} -->' />
		<!--- override with user defined templates --->
		<cfloop collection="#arguments.Templates#" item="tpl">
			<cfset variables.templates[tpl] = arguments.Templates[tpl] />
		</cfloop>
		
		<cfset variables.AssetHosts = arguments.AssetHosts />
		<cfset variables.AssetHostsSSL = arguments.AssetHostsSSL />
		<cfset variables.UseAssetHosts = arraylen(variables.AssetHosts) GT 0 />
		<cfset variables.AssetHostIndex = 1 />
		<cfset variables.AssetHostSSLIndex = 1 />
		<cfset variables.AssetCache = structnew() />
		
		<cfif NOT arraylen(variables.AssetHostsSSL)>
			<cfset variables.AssetHostsSSL = variables.AssetHosts />
		</cfif>
			
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
		<cfargument name="event" type="any" required="true" /> 
		
		<cfset var mapping = 0 />
		<cfset var pathToTest = "" />
		<cfset var fullPath = "" />
		<cfset var secure = isSecureRequest() />
		<cfset var assetHtml = "" /> 
		<cfset var assetKey = hash("#arguments.type#_#yesnoformat(secure)#_#arguments.path#") />
		<cfset var data = structnew() />
		<cfset var aseetMappingAdvice = arguments.event.getValue("AssetMappingAdvice") />
		<cfset var assetMappings = listToArray(listappend(aseetMappingAdvice, arrayToList(variables._modelGlue.configuration.assetMappings))) /> <!--- yuck! --->
		<cfset var hasProtocol = false />
		<cfset var assetFound = false />

		<cfif arguments.ieOnly and arguments.type is "CSS">
			<cfset arguments.type = "IECSS" />
		</cfif>
	
		<!--- if we've previously rendered this asset, just return the html
			  we cache the html to ensure that resources are always served from 
			  the same hostname (if we're using them) this helps maximise
			  browser cache hits --->
		<cfif structKeyExists(variables.AssetCache, assetKey)>
			<cfreturn variables.AssetCache[assetKey] />

		<!--- is the asset already a full url with protocol ? --->
		<cfelseif refind("^https?://", arguments.path)>
			<cfset fullpath = arguments.path />
			<cfset hasProtocol = true />
			<cfset assetFound = true />

		<!--- loop over mappings to try and find the asset --->
		<cfelse>
			<cfloop from="1" to="#arrayLen(assetMappings)#" index="mapping">
				<cfset pathToTest = assetMappings[mapping] & "/" & arguments.path />
				<cfif fileExists(expandPath(pathToTest))>
					<cfset fullPath = pathToTest />
					<cfset assetFound = true />
					<cfbreak />
				</cfif>	
			</cfloop>
		</cfif>
		
		<!--- if we're using hostnames, prepend one --->
		<cfif assetFound AND UseAssetHosts AND NOT hasProtocol>
			<cfset fullpath = getNextAssetHost(secure) & fullPath />
		</cfif>

		<!--- missing asset --->
		<cfif assetFound>
			<cfset data.path = fullpath />
		<cfelse>
			<cfset data.path = arguments.path />
			<cfset arguments.type = "ASSETNOTFOUND" />
			<cfset arguments.event.addTraceStatement("Assets", "Could not locate asset ('#arguments.path#')", "", "WARNING") />
		</cfif>
		
		<!--- render the template --->
		<cfset assetHtml = stringFormat(variables.templates[arguments.type], data) & chr(10) />
		
		<!--- store the html in the cache --->
		<cfset variables.AssetCache[assetKey] = assetHtml />
		<cfreturn assetHtml />
	</cffunction>
	
	<cffunction name="getNextAssetHost" access="private" output="false">
		<cfargument name="secure" default="false" />
		<cfset var domain = "" />
		
		<cfif arguments.secure>
			<cfif variables.AssetHostSSLIndex GT arraylen(variables.AssetHostsSSL)>
				<cfset variables.AssetHostSSLIndex = 1 />
			</cfif>
			<cfset domain = variables.AssetHostsSSL[variables.AssetHostSSLIndex] /> 
			<cfset variables.AssetHostSSLIndex = variables.AssetHostSSLIndex + 1 />
		<cfelse>
			<cfif variables.AssetHostIndex GT arraylen(variables.AssetHosts)>
				<cfset variables.AssetHostIndex = 1 />
			</cfif>
			<cfset domain = variables.AssetHosts[variables.AssetHostIndex] /> 
			<cfset variables.AssetHostIndex = variables.AssetHostIndex + 1 />
		</cfif>
		
		<cfreturn domain />
	</cffunction>
	
	<cffunction name="isSecureRequest" output="false" access="private">
		<cfreturn CGI.HTTPS IS "ON" />
	</cffunction>
	
	<cffunction name="renderAssetsInHead" output="false" returntype="void" hint="Renders all assets for the request using <cfhtmlhead>.">
		<cfargument name="transientAssets" type="string" required="true" />
		<cfhtmlhead text="#arguments.transientAssets#" />
	</cffunction>
	
	<cffunction name="stringFormat" output="false" access="private">
		<cfargument name="string" type="string" required="true" />
		<cfargument name="data" type="struct" required="true" />
		<cfset var i = "" />
		<cfloop collection="#data#" item="i">
			<cfset arguments.string = replaceNoCase(arguments.string, "{{#i#}}", arguments.data[i], "all") />
		</cfloop>		
		<cfreturn arguments.string />
	</cffunction>

</cfcomponent>