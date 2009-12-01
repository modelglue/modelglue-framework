component extends="modelglue.gesture.test.ModelGlueAbstractTestCase" {
	this.coldspringPath = "/MGCFORMAdapterTest/ColdSpring.xml";
	
	function setup() {
		obj = "MainObject";
		col = "mainid";
		crit = {mainid=1};
		expected = "yooray!";
		servicePath = "ModelGlue.gesture.modules.orm.cform.cfORMService";
		adapterPath = "ModelGlue.gesture.modules.orm.cform.cfORMAdapter";
		// ormService = createObject("component","ModelGlue.gesture.modules.orm.cform.cfORMService").init();
		ormService = mock(servicePath,"typeSafe");
		//createModelGlueIfNotDefined(this.coldspringPath);
		mg = mock("ModelGlue.gesture.ModelGlue");
		ormAdapter = createObject("component",adapterPath).init(mg,ormService);
		//debug(getMetaData(mg));
	}
	
	function ormAdapterCanBeCreated() {
		assertEquals(adapterPath,getMetaData(ormAdapter).name);
	}
	
	function getORMServiceShouldReturnORMService() {
		assertEquals(servicePath,getMetaData(ormAdapter.getORMService()).name);
	}
	
	function listWithMissingGWBeanShouldThrow() mxunit_expectedException="coldspring.NoSuchBeanDefinitionException" {
		mg.getBean("gwBean").throws("coldspring.NoSuchBeanDefinitionException");
		list = ormAdapter.list(gatewayMethod="customList",gatewayBean="gwBean",entityName="MainObject");
	}
	
	function listWithMissingGWMethodOnObjectShouldThrow() mxunit_expectedException="ModelGlue.gesture.orm.cform.cformAdapter.badGatewayMethod" {
		list = ormAdapter.list(gatewayMethod="customList",entityName="MainObject");
	}

	function listWithExistingGWBeanButMissingMethodShouldThrow() mxunit_expectedException="ModelGlue.gesture.orm.cform.cformAdapter.badGatewayMethod" {
		mg.getBean("gwBean").returns(mock());
		list = ormAdapter.list(gatewayMethod="customList",gatewayBean="gwBean",entityName="MainObject");
	}
	

	function listWithExistingGWMethodAndBeanShouldReturnResult() {
		gw = mock();
		//gw.customList().returns([]);
		/* Cannot seem to mock this one, as it's looking for the method in the object using StructKeyExists()
			Could try injectMethod() instead */
		injectMethod(gw, this, "returnsArray", "customList");
		mg.getBean("gwBean").returns(gw);
		list = ormAdapter.list(gatewayMethod="customList",gatewayBean="gwBean",entityName="MainObject");
		assertTrue(IsArray(list));
	}

	function listWithExistingGWMethodInObjectShouldReturnResult() {
		mockObject = mock();
		injectMethod(mockObject, this, "returnsArray", "customList");
		ormService.new("MainObject").returns(mockObject);
		list = ormAdapter.list(gatewayMethod="customList",entityName="MainObject");
		debug(list);
		assertTrue(IsArray(list));
	}

	function listWithNoCriteriaDefaultSortShouldReturnAllAscending() {
		ormService.list(obj,{},col,true).returns(expected);
		list = ormAdapter.list(entityName=obj,orderColumn=col);
		assertEquals(expected,list);
		ormService.verify().list(obj,{},col,true);
	}

	function listWithNoCriteriaDescSortShouldReturnAllDescending() {
		ormService.list(obj,{},col,false).returns(expected);
		list = ormAdapter.list(entityName=obj,orderColumn=col,orderAscending=false);
		assertEquals(expected,list);
		ormService.verify().list(obj,{},col,false);
	}

	function listWithNoCriteriaNoSortShouldReturnAllUnsorted() {
		ormService.list(obj,{},"",true).returns(expected);
		list = ormAdapter.list(entityName=obj);
		assertEquals(expected,list);
		ormService.verify().list(obj,{},"",true);
	}

	function listWithCriteriaDefaultSortShouldReturnSomeAscending() {
		ormService.list(obj,crit,col,true).returns(expected);
		list = ormAdapter.list(entityName=obj,orderColumn=col,criteria=crit);
		debug(list);
		assertEquals(expected,list);
		ormService.verify().list(obj,crit,col,true);
	}

	function listWithCriteriaDescSortShouldReturnSomeDescending() {
		ormService.list(obj,crit,col,false).returns(expected);
		list = ormAdapter.list(entityName=obj,orderColumn=col,orderAscending=false,criteria=crit);
		assertEquals(expected,list);
		ormService.verify().list(obj,crit,col,false);
	}

	function listWithCriteriaNoSortShouldReturnSomeUnsorted() {
		ormService.list(obj,crit,"",true).returns(expected);
		list = ormAdapter.list(entityName=obj,criteria=crit);
		assertEquals(expected,list);
		ormService.verify().list(obj,crit,"",true);
	}

	function newWithValidEntityNameReturnsObject() {
		ormService.new(obj).returns(expected);
		newObj = ormAdapter.new(obj);
		assertEquals(expected,newObj);
	}

	function newWithMissingEntityNameThrows() mxunit_expectedException="ModelGlue.gesture.orm.cform.cformService.enitityNotFound" {
		ormService.new(obj).returns(expected);
		ormService.new("badObj").throws("ModelGlue.gesture.orm.cform.cformService.enitityNotFound");
		newObj = ormAdapter.new("badObj");
	}

	function readWithValidEntityNameReturnsObject() {
		ormService.read(obj,crit).returns(expected);
		theObj = ormAdapter.read(obj,crit);
		assertEquals(expected,theObj);
	}

	function readWithMissingEntityNameThrows()  mxunit_expectedException="ModelGlue.gesture.orm.cform.cformService.enitityNotFound" {
		ormService.read(obj,crit).returns(expected);
		ormService.read("badObj",crit).throws("ModelGlue.gesture.orm.cform.cformService.enitityNotFound");
		theObj = ormAdapter.read("badObj",crit);
	}
	
	function validateReturnsEmptyErrorCollection() {
		errors = ormAdapter.validate(obj,"");
		assertEquals("ModelGlue.Util.ValidationErrorCollection",getMetaData(errors).name);
		assertEquals(false,errors.hasErrors());
	}

	function commitCallsService() {
		ormService.commit(theObject="").returns(expected);
		ormAdapter.commit(theObject="");
		ormService.verify().commit(theObject="");
	}

	function deleteWithValidKeysCallsServiceWithReturnedObject() {
		ormService.read(obj,crit).returns(expected);
		ormService.delete(expected).returns(expected);
		ormAdapter.delete(obj,crit);
		ormService.verify().delete(expected);
	}

	function deleteWithInvalidKeysThrows() mxunit_expectedException="ModelGlue.gesture.orm.cform.cformAdapter.objectNotFound" {
		injectMethod(ormService, this, "returnsNull", "read");
		//ormService.read(obj,crit).returns(JavaCast("null", 0));
		ormAdapter.delete(obj,crit);
	}

	// private methods for injectMethod and extra setup
	
	private function returnsArray() {
		return [];
	}

	private function returnsNull() {
		return JavaCast("null", 0);
	}
	
	private function createProperties(aDate) {
		var props = {};
		props.ormtype_string = "string";
		props.ormtype_character = "c";
		props.ormtype_char = "c";
		props.ormtype_short = 2;
		props.ormtype_integer = 2;
		props.ormtype_int = 2;
		props.ormtype_long = 2;
		props.ormtype_big_decimal = 2;
		props.ormtype_float = 2;
		props.ormtype_double = 2;
		props.ormtype_Boolean = false;
		props.ormtype_yes_no = "no";
		props.ormtype_true_false = "false";
		props.ormtype_text = "text";
		props.ormtype_date = arguments.aDate;
		props.ormtype_timestamp = arguments.aDate;
		props.type_boolean = false;
		props.type_date = arguments.aDate;
		props.type_numeric = 2;
		props.type_string = "string";
		return props;
	}

}
