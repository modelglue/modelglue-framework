<cfcomponent extends="mxunit.framework.TestCase">

<cffunction name="createPopulator" output="false" access="public">
	<cfreturn createObject("component", "ModelGlue.gesture.externaladapters.beanpopulation.CollectionBeanPopulator").init() />
</cffunction>

<cffunction name="createCollection" output="false" access="public">
	<cfreturn createObject("component", "ModelGlue.gesture.collections.MapCollection") />
</cffunction>

<cffunction name="testCreateAndPopulate" returntype="void" access="public">
	<cfset var pop = createPopulator() />
	<cfset var bean = "" />
	<cfset var values = structNew() />
	<cfset var collection = createCollection() />
	<cfset collection.setValue( "implicitProp", "implicitPropValue") />
	<cfset collection.setValue( "explicitProp", "explicitPropValue") />
	
	<cfset bean = pop.populate("ModelGlue.gesture.externaladapters.beanpopulation.test.Bean", collection) />
	
	<cfset assertTrue(bean.initRan, "Init() did not get invoked.") />
	<cfset assertTrue(bean.explicitProp eq "explicitPropValue", "explicit prop not set") />
	<cfset assertTrue(bean.getImplicitProp() eq "implicitPropValue", "implicit prop not set") />
</cffunction>

<cffunction name="testPopulateExisting" returntype="void" access="public">
	<cfset var pop = createPopulator() />
	<cfset var bean = createObject("component", "ModelGlue.gesture.externaladapters.beanpopulation.test.Bean") />
	<cfset var values = structNew() />
	<cfset var collection = createCollection() />
	
	<cfset values.implicitProp = "implicitPropValue" />
	<cfset values.explicitProp = "explicitPropValue" />
	<cfset collection.init( values ) />
	
	<cfset pop.populate(bean, collection) />
	
	<cfset assertTrue(bean.explicitProp eq "explicitPropValue", "explicit prop not set") />
	<cfset assertTrue(bean.getImplicitProp() eq "implicitPropValue", "implicit prop not set") />
</cffunction>

</cfcomponent>