<cfcomponent extends="org.cfcunit.framework.TestCase">

<cffunction name="createPopulator" output="false" access="public">
	<cfreturn createObject("component", "ModelGlue.gesture.externaladapters.beanpopulation.BeanUtilsPopulator").init() />
</cffunction>

<cffunction name="testCreateAndPopulate" returntype="void" access="public">
	<cfset var pop = createPopulator() />
	<cfset var values = structNew() />
	<cfset var bean = "" />
	
	<cfset values.implicitProp = "implicitPropValue" />
	<cfset values.explicitProp = "explicitPropValue" />
	
	<cfset bean = pop.populate("ModelGlue.gesture.externaladapters.beanpopulation.test.Bean", values) />
	
	<cfset assertTrue(bean.initRan, "Init() did not get invoked.") />
	<cfset assertTrue(bean.explicitProp eq "explicitPropValue", "explicit prop not set") />
	<cfset assertTrue(bean.getImplicitProp() eq "implicitPropValue", "implicit prop not set") />
</cffunction>

<cffunction name="testPopulateExisting" returntype="void" access="public">
	<cfset var pop = createPopulator() />
	<cfset var bean = createObject("component", "ModelGlue.gesture.externaladapters.beanpopulation.test.Bean") />
	<cfset var values = structNew() />
	
	<cfset values.implicitProp = "implicitPropValue" />
	<cfset values.explicitProp = "explicitPropValue" />
	
	<cfset pop.populate(bean, values) />
	
	<cfset assertTrue(bean.explicitProp eq "explicitPropValue", "explicit prop not set") />
	<cfset assertTrue(bean.getImplicitProp() eq "implicitPropValue", "implicit prop not set") />
</cffunction>

</cfcomponent>