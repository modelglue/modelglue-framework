<cfcomponent extends="ModelGlue.gesture.modules.asset.manager.AssetManager" hint="i extend the asset manager to allow setting a request as secure and placing assets into the request scope rather than <cfhtmlhead>">

	<cfset variables.secure = false />
	
	<cffunction name="setSecure">
		<cfargument name="secure" />
		<cfset variables.secure = arguments.secure />
	</cffunction>

	<cffunction name="isSecureRequest" output="false" access="private">
		<cfreturn variables.secure />
	</cffunction>
	
	<cffunction name="renderAssetsInHead" output="false" returntype="any">
		<cfargument name="transientAssets" type="string" required="true" />
		<cfset request.assets = arguments.transientAssets />
	</cffunction>	

</cfcomponent>