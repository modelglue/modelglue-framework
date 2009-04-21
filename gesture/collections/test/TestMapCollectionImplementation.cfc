<cfcomponent extends="modelglue.gesture.test.ModelGlueAbstractTestCase">

<cffunction name="createMapCollectionNoInit" access="private" hint="Creates a basic MapCollection to test without running init().">
	<cfreturn createObject("component", "ModelGlue.gesture.collections.MapCollection") />
</cffunction>

<cffunction name="createMapCollection" access="private" hint="Creates a basic MapCollection to test.  Extend this test class and override this method to test other implementations.">
	<cfreturn createMapCollectionNoInit().init() />
</cffunction>

<cffunction name="testExists" returntype="void" access="public">
	<cfset var col = createMapCollection() />

	<cfset assertFalse(col.exists("setValue"), "found value before definition!") />
	<cfset col.setValue("setValue", "setValue") />
	<cfset assertTrue(col.exists("setValue"), "didn't find value after definition!") />
		
</cffunction>

<cffunction name="testSetAndGetValue" returntype="void" access="public">
	<cfset var col = createMapCollection() />
	<cfset var value = "" />
	
	<cfset value = col.getValue("default", "default")  />
	<cfset assertTrue(value eq "default", "default value not returned") />
	<cfset assertTrue(col.exists("default"), "default value not set into collection") />
		
	<cfset col.setValue("setValue", "setValue") />
	<Cfset assertTrue(col.getValue("setValue") eq "setValue", "explicitly set value not set") />
</cffunction>

<cffunction name="testRemoveValue" returntype="void" access="public">
	<cfset var col = createMapCollection() />

	<cfset col.setValue("setValue", "setValue") />
	<cfset col.removeValue("setValue") />
	<cfset assertFalse(col.exists("setValue"), "found value after removal!") />
</cffunction>

<cffunction name="testGetAll" returntype="void" access="public">
	<cfset var col = createMapCollection() />
	<cfset var ref1 = col.getAll() />
	<cfset var ref2 = col.getAll() />
	
	<cfset col.setValue("setValue", "setValue") />
	<cfset assertTrue(ref1.setValue eq "setValue", "Set didn't update external reference.") />
	<cfset assertTrue(ref1.setValue eq ref2.setValue, "External references not equivalent.") />
</cffunction>

<cffunction name="testMerge" returntype="void" access="public">
	<Cfset var col = createMapCollectionNoInit() />
	<cfset var src1 = structNew() />
		
	<cfset src1.src1val = "src1val" />

	<cfset col.init() />
	<cfset col.merge(src1) />
	
	<cfset assertTrue(col.getValue("src1val") eq "src1val", "First source value not defined properly.") />
</cffunction>

<cffunction name="testArrayInit" returntype="void" access="public">
	<Cfset var col = createMapCollectionNoInit() />
	<cfset var src1 = structNew() />
	<cfset var src2 = structNew() />
	<cfset var sources = arrayNew(1) />
		
	<cfset src1.val = "src1" />
	<cfset src2.val = "src2" />
	
	<cfset src1.src1val = "src1val" />
	<cfset src2.src2val = "src2val" />
	
	<cfset arrayAppend(sources, src1) />
	<cfset arrayAppend(sources, src2) />
	<cfset col.init(values=sources) />

	<cfset assertTrue(col.getValue("val") eq "src2", "Second like-named value not defined properly.") />
	<cfset assertTrue(col.getValue("src1val") eq "src1val", "First source value not defined properly.") />
	<cfset assertTrue(col.getValue("src2val") eq "src2val", "Second source value not defined properly.") />
</cffunction>

<cffunction name="testStructInit" returntype="void" access="public">
	<Cfset var col = createMapCollectionNoInit() />
	<cfset var src1 = structNew() />
		
	<cfset src1.src1val = "src1val" />

	<cfset col.init(values=src1) />
		
	<cfset assertTrue(col.getValue("src1val") eq "src1val", "First source value not defined properly.") />
</cffunction>

</cfcomponent>