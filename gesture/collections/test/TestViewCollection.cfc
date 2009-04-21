<cfcomponent extends="mxunit.framework.TestCase">

<cffunction name="createViewCollectionNoInit" access="private" hint="Creates a basic ViewCollection to test without running init().">
	<cfreturn createObject("component", "ModelGlue.gesture.collections.ViewCollection") />
</cffunction>

<cffunction name="createViewCollection" access="private" hint="Creates a basic ViewCollection to test.  Extend this test class and override this method to test other implementations.">
	<cfreturn createViewCollectionNoInit().init() />
</cffunction>

<cffunction name="testAddRenderedView" returntype="void" access="public">
	<cfset var col = createViewCollection() />

	<cfset col.addRenderedView("content", "renderedContent", false) />
	
	<cfset assertTrue(col.getView("content") eq "renderedContent", "renderedContent not returned") />
	
	<cfset col.addRenderedView("content", "appendedContent", true) />
	
	<cfset assertTrue(col.getView("content") eq "renderedContentappendedContent", "renderedContentappendedContent not returned") />
</cffunction>

<cffunction name="testGetView" returntype="void" access="public">
	<cfset var col = createViewCollection() />

	<cfset col.addRenderedView("content", "renderedContent", false) />
	
	<cfset assertTrue(col.getView("content") eq "renderedContent", "renderedContent not returned") />
</cffunction>

<cffunction name="testExists" returntype="void" access="public">
	<cfset var col = createViewCollection() />

	<cfset assertFalse(col.exists("content"), "exists returned true before rendering") />

	<cfset col.addRenderedView("content", "renderedContent", false) />
	
	<cfset assertTrue(col.exists("content"), "exists returned false after rendering") />
</cffunction>

<cffunction name="testGetAll" returntype="void" access="public">
	<cfset var col = createViewCollection() />
	<cfset var colRef = "" />
	
	<cfset col.addRenderedView("content", "renderedContent", false) />
	
	<cfset colRef = col.getAll() />
	
	<cfset colRef.content = "alteredContent" />
	
	<cfset assertTrue(col.getView("content") neq colRef.content, "modifying getAll() result modified internal content!") />
</cffunction>

<cffunction name="testGetFinalView" returntype="void" access="public">
	<cfset var col = createViewCollection() />

	<cfset col.addRenderedView("content", "renderedContent", false) />
	<cfset assertTrue(col.getFinalView() eq "renderedContent", "getFinalView failed first check") />

	<cfset col.addRenderedView("content2", "renderedContent2", false) />
	<cfset assertTrue(col.getFinalView() eq "renderedContent2", "getFinalView failed second check") />
</cffunction>


</cfcomponent>