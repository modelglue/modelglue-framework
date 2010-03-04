<cfcomponent extends="mxunit.framework.TestCase" output="false">

<cffunction name="setUp" access="public" returntype="void">

	<!--- Create default cache with sweep time of 60 seconds to avoid automatic sweeps in most tests --->
	<cfset variables._cache = createObject("component", "ModelGlue.gesture.externaladapters.contentcaching.SimpleTimedCache").init(60) />

	<!--- Default item timeout of 3 seconds --->
	<cfset variables._cache.setDefaultTimeout(3) />

</cffunction>

<cffunction name="testSimpleTimedCacheGetPutPurge" access="public" returntype="void">

	<cfset var key1 = "foo" />
	<cfset var content1 = "one" />
	<cfset var key2 = "bar" />
	<cfset var content2 = ArrayNew(1) />
	<cfset var key3 = "baz" />
	<cfset var content3 = StructNew() />
	<cfset var item = "" />
	<cfset var key4 = "qux" />
	<cfset var content4 = CreateObject("component", "ModelGlue.Bean.CommonBeans.Example").init() />

	<cfset content2[1] = "two" />
	<cfset content2[2] = "dos" />
	<cfset content3.first = "three" />
	<cfset content3.second = "tres" />
	<cfset content4.setSimpleProperty("four") />
	
	<cfset item = variables._cache.get(key1) />
	<cfset assertFalse(item.success, "Item key1 didn't initially fail to retrieve!") />
	
	<cfset variables._cache.put(key1, content1) />
	<cfset item = variables._cache.get(key1) />
	<cfset assertTrue(item.success, "Item key1 didn't initially retrieve!") />
	<cfset assertEquals(content1, item.content, "Item key1 didn't match contents!") />

	<cfset item = variables._cache.get(key2) />
	<cfset assertFalse(item.success, "Item key2 didn't initially fail to retrieve!") />
	
	<cfset variables._cache.put(key2, content2) />
	<cfset item = variables._cache.get(key2) />
	<cfset assertTrue(item.success, "Item key2 didn't initially retrieve!") />
	<cfset assertEquals(content2, item.content, "Item key2 didn't match contents!") />

	<cfset item = variables._cache.get(key3) />
	<cfset assertFalse(item.success, "Item key3 didn't initially fail to retrieve!") />
	
	<cfset variables._cache.put(key3, content3) />
	<cfset item = variables._cache.get(key3) />
	<cfset assertTrue(item.success, "Item key3 didn't initially retrieve!") />
	<cfset assertEquals(content3, item.content, "Item key3 didn't match contents!") />

	<cfset item = variables._cache.get(key4) />
	<cfset assertFalse(item.success, "Item key4 didn't initially fail to retrieve!") />
	
	<cfset variables._cache.put(key4, content4) />
	<cfset item = variables._cache.get(key4) />
	<cfset assertTrue(item.success, "Item key4 didn't initially retrieve!") />
	<cfset assertEquals(content4, item.content, "Item key4 didn't match contents!") />

	<cfset item = variables._cache.get(key1) />
	<cfset assertTrue(item.success, "Item key1 failed to retrieve after key2 put!") />
	<cfset assertEquals(content1, item.content, "Item key1 didn't match contents after key2 put!") />

	<cfset variables._cache.purge(key1) />
	<cfset item = variables._cache.get(key1) />
	<cfset assertFalse(item.success, "Item key1 didn't purge!") />
	<cfset item = variables._cache.get(key2) />
	<cfset assertTrue(item.success, "Item key2 wrongly purged!") />

</cffunction>

<cffunction name="testSimpleTimedCacheManualSweepDefaultTimeout" access="public" returntype="void">

	<cfset var key1 = "foo" />
	<cfset var contents1 = "one" />
	<cfset var item = "" />

	<cfset variables._cache.put(key1, contents1) />

	<cfset variables._cache.sweep() />
	<cfset item = variables._cache.get(key1) />
	<cfset assertTrue(item.success, "Item didn't retrieve after initial sweep!") />
	<cfset sleep(2000) />
	<cfset variables._cache.sweep() />
	<cfset item = variables._cache.get(key1) />
	<cfset assertTrue(item.success, "Item didn't retrieve after acceptable sweep!") />
	<cfset sleep(2000) />
	<cfset variables._cache.sweep() />
	<cfset item = variables._cache.get(key1) />
	<cfset assertFalse(item.success, "Item retrieved after expiry sweep!") />

</cffunction>

<cffunction name="testSimpleTimedCacheManualSweepLongerThanDefaultTimeout" access="public" returntype="void">

	<cfset var key1 = "foo" />
	<cfset var contents1 = "one" />
	<cfset var item = "" />

	<cfset variables._cache.put(key1, contents1, 5) />

	<cfset variables._cache.sweep() />
	<cfset item = variables._cache.get(key1) />
	<cfset assertTrue(item.success, "Item didn't retrieve after initial sweep!") />
	<cfset sleep(2000) />
	<cfset variables._cache.sweep() />
	<cfset item = variables._cache.get(key1) />
	<cfset assertTrue(item.success, "Item didn't retrieve after first acceptable sweep!") />
	<cfset sleep(2000) />
	<cfset variables._cache.sweep() />
	<cfset item = variables._cache.get(key1) />
	<cfset assertTrue(item.success, "Item didn't retrieve after second acceptable sweep!") />
	<cfset sleep(2000) />
	<cfset variables._cache.sweep() />
	<cfset item = variables._cache.get(key1) />
	<cfset assertFalse(item.success, "Item retrieved after expiry sweep!") />
	
</cffunction>

<cffunction name="testSimpleTimedCacheManualSweepShorterThanDefaultTimeout" access="public" returntype="void">

	<cfset var key1 = "foo" />
	<cfset var contents1 = "one" />
	<cfset var item = "" />

	<cfset variables._cache.put(key1, contents1, 1) />

	<cfset variables._cache.sweep() />
	<cfset item = variables._cache.get(key1) />
	<cfset assertTrue(item.success, "Item didn't retrieve after initial sweep!") />
	<cfset sleep(2000) />
	<cfset variables._cache.sweep() />
	<cfset item = variables._cache.get(key1) />
	<cfset assertFalse(item.success, "Item retrieved after expiry sweep!") />
	
</cffunction>

<cffunction name="testSimpleTimedCacheLongSweepInterval" access="public" returntype="void">

	<cfset var key1 = "foo" />
	<cfset var contents1 = "one" />
	<cfset var key2 = "bar" />
	<cfset var contents2 = "two" />
	<cfset var key3 = "baz" />
	<cfset var contents3 = "three" />
	<cfset var item = "" />

	<!--- Create a different cache with a sweep interval of 5 seconds and default timeout of 2 seconds --->
	<cfset variables._cache = createObject("component", "ModelGlue.gesture.externaladapters.contentcaching.SimpleTimedCache").init(5) />
	<cfset variables._cache.setDefaultTimeout(2) />

	<cfset variables._cache.put(key1, contents1) />
	<cfset variables._cache.put(key2, contents2, 3) />
	<cfset variables._cache.put(key3, contents3, 7) />
	
	<cfset item = variables._cache.get(key1) />
	<cfset assertTrue(item.success, "Item key1 didn't initially retrieve!") />
	<cfset item = variables._cache.get(key2) />
	<cfset assertTrue(item.success, "Item key2 didn't initially retrieve!") />
	<cfset item = variables._cache.get(key3) />
	<cfset assertTrue(item.success, "Item key3 didn't initially retrieve!") />

	<cfset sleep(1000) />

	<cfset item = variables._cache.get(key1) />
	<cfset assertTrue(item.success, "Item key1 didn't retrieve after first wait!") />
	<cfset item = variables._cache.get(key2) />
	<cfset assertTrue(item.success, "Item key2 didn't retrieve after first wait!") />
	<cfset item = variables._cache.get(key3) />
	<cfset assertTrue(item.success, "Item key3 didn't retrieve after first wait!") />

	<cfset sleep(3000) />

	<cfset item = variables._cache.get(key1) />
	<cfset assertTrue(item.success, "Item key1 didn't retrieve after second wait!") />
	<cfset item = variables._cache.get(key2) />
	<cfset assertTrue(item.success, "Item key2 didn't retrieve after second wait!") />
	<cfset item = variables._cache.get(key3) />
	<cfset assertTrue(item.success, "Item key3 didn't retrieve after second wait!") />

	<cfset sleep(2000) />

	<cfset item = variables._cache.get(key1) />
	<cfset assertFalse(item.success, "Item key1 retrieved after auto sweep!") />
	<cfset item = variables._cache.get(key2) />
	<cfset assertFalse(item.success, "Item key2 retrieved after auto sweep!") />
	<cfset item = variables._cache.get(key3) />
	<cfset assertTrue(item.success, "Item key3 didn't retrieve after auto sweep!") />
	
</cffunction>

<cffunction name="testSimpleTimedCacheShortSweepInterval" access="public" returntype="void">

	<cfset var key1 = "foo" />
	<cfset var contents1 = "one" />
	<cfset var key2 = "bar" />
	<cfset var contents2 = "two" />
	<cfset var key3 = "baz" />
	<cfset var contents3 = "three" />
	<cfset var item = "" />

	<!--- Create a different cache with a sweep interval of 2 seconds and default timeout of 6 seconds --->
	<cfset variables._cache = createObject("component", "ModelGlue.gesture.externaladapters.contentcaching.SimpleTimedCache").init(2) />
	<cfset variables._cache.setDefaultTimeout(8) />

	<cfset variables._cache.put(key1, contents1) />
	<cfset variables._cache.put(key2, contents2, 4) />
	<cfset variables._cache.put(key3, contents3, 12) />
	
	<cfset item = variables._cache.get(key1) />
	<cfset assertTrue(item.success, "Item key1 didn't initially retrieve!") />
	<cfset item = variables._cache.get(key2) />
	<cfset assertTrue(item.success, "Item key2 didn't initially retrieve!") />
	<cfset item = variables._cache.get(key3) />
	<cfset assertTrue(item.success, "Item key3 didn't initially retrieve!") />

	<!--- Auto-sweep after this wait (no expirations) --->
	<cfset sleep(3000) />

	<cfset item = variables._cache.get(key1) />
	<cfset assertTrue(item.success, "Item key1 didn't retrieve after first auto sweep!") />
	<cfset item = variables._cache.get(key2) />
	<cfset assertTrue(item.success, "Item key2 didn't retrieve after first auto sweep!") />
	<cfset item = variables._cache.get(key3) />
	<cfset assertTrue(item.success, "Item key3 didn't retrieve after first auto sweep!") />

	<!--- No auto-sweep after this wait (key2 expires but should not be sweeped) --->
	<cfset sleep(2000) />

	<cfset item = variables._cache.get(key1) />
	<cfset assertTrue(item.success, "Item key1 didn't retrieve after non-auto-sweep wait!") />
	<cfset item = variables._cache.get(key2) />
	<cfset assertTrue(item.success, "Item key2 didn't retrieve after non-auto-sweep wait!") />
	<cfset item = variables._cache.get(key3) />
	<cfset assertTrue(item.success, "Item key3 didn't retrieve after non-auto-sweep wait!") />

	<!--- Auto-sweep after this wait (key2 should be sweeped) --->
	<cfset sleep(2000) />

	<cfset item = variables._cache.get(key1) />
	<cfset assertTrue(item.success, "Item key1 didn't retrieve after second auto sweep!") />
	<cfset item = variables._cache.get(key2) />
	<cfset assertFalse(item.success, "Item key2 retrieved after expiry auto sweep!") />
	<cfset item = variables._cache.get(key3) />
	<cfset assertTrue(item.success, "Item key3 didn't retrieve after second auto sweep!") />

	<!--- Auto-sweep after this wait (key1 expires and should be sweeped) --->
	<cfset sleep(3000) />

	<cfset item = variables._cache.get(key1) />
	<cfset assertFalse(item.success, "Item key1 retrieved after expiry auto sweep!") />
	<cfset item = variables._cache.get(key3) />
	<cfset assertTrue(item.success, "Item key3 didn't retrieve after third auto sweep!") />
	
</cffunction>

</cfcomponent>