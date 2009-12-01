<cfcomponent extends="mxunit.framework.TestCase" output="false">

<cffunction name="testSimpleTimedCache" access="public" returntype="void">
	<cfset var cache = createObject("component", "ModelGlue.gesture.externaladapters.contentcaching.SimpleTimedCache").init(5, 2) />
	<cfset var item = "" />
	
	<cfset item = cache.get("key") />
	<cfset assertFalse(item.success, "Item didn't initially fail to retrieve!") />
	
	<cfset item = cache.put("key", "content") />
	<cfset item = cache.get("key") />
	<cfset assertTrue(item.success, "Item didn't initially retrieve!") />

	<!--- Wait and sweep: should be gone based on default. --->
	<cfset item = cache.get("key") />
	<cfset assertTrue(item.success, "Item didn't retrieve before default sweep test!") />
	<cfset sleep(1000) />
	<cfset item = cache.get("key") />
	<cfset assertTrue(item.success, "Item didn't retrieve within acceptable pause in default sweep test!") />
	<cfset sleep(2000) />
	<cfset cache.sweep() />
	<cfset item = cache.get("key") />
	<cfset assertFalse(item.success, "Item retrieved after default sweep!") />
	
	<cfset item = cache.put("key", "content", 4) />
	<!--- Wait and sweep: should be gone based on explicit. --->
	<cfset item = cache.get("key") />
	<cfset assertTrue(item.success, "Item didn't retrieve before explicit sweep test!") />
	<cfset sleep(2000) />
	<cfset item = cache.get("key") />
	<cfset assertTrue(item.success, "Item didn't retrieve within acceptable pause in explicit sweep test!") />
	<cfset sleep(3000) />
	<cfset cache.sweep() />
	<cfset item = cache.get("key") />
	<cfset assertFalse(item.success, "Item retrieved after explicit sweep!") />
	
</cffunction>

</cfcomponent>