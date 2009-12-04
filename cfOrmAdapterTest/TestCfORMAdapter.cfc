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
	
	function getORMServiceShouldReturnORMService() {
		assertEquals(servicePath,getMetaData(ormAdapter.getORMService()).name);
	}
	
	/**
	* @mxunit:expectedException "coldspring.NoSuchBeanDefinitionException" 
	*/
	function listWithMissingGWBeanShouldThrow() {
		mg.getBean("gwBean").throws("coldspring.NoSuchBeanDefinitionException");
		list = ormAdapter.list(gatewayMethod="customList",gatewayBean="gwBean",table="MainObject");
	}
	
	/**
	* @mxunit:expectedException "ModelGlue.gesture.orm.cform.cformAdapter.badGatewayMethod" 
	*/
	function listWithMissingGWMethodOnObjectShouldThrow() {
		list = ormAdapter.list(gatewayMethod="customList",table="MainObject");
	}

	/**
	* @mxunit:expectedException "ModelGlue.gesture.orm.cform.cformAdapter.badGatewayMethod" 
	*/
	function listWithExistingGWBeanButMissingMethodShouldThrow() {
		mg.getBean("gwBean").returns(mock());
		list = ormAdapter.list(gatewayMethod="customList",gatewayBean="gwBean",table="MainObject");
	}
	

	function listWithExistingGWMethodAndBeanShouldReturnResult() {
		gw = mock();
		//gw.customList().returns([]);
		/* Cannot seem to mock this one, as it's looking for the method in the object using StructKeyExists()
			Could try injectMethod() instead */
		injectMethod(gw, this, "returnsArray", "customList");
		mg.getBean("gwBean").returns(gw);
		list = ormAdapter.list(gatewayMethod="customList",gatewayBean="gwBean",table="MainObject");
		assertTrue(IsArray(list));
	}

	function listWithExistingGWMethodInObjectShouldReturnResult() {
		mockObject = mock();
		injectMethod(mockObject, this, "returnsArray", "customList");
		ormService.new("MainObject").returns(mockObject);
		list = ormAdapter.list(gatewayMethod="customList",table="MainObject");
		assertTrue(IsArray(list));
	}

	function listWithNoCriteriaDefaultSortShouldReturnAllAscending() {
		ormService.list(obj,{},col & " asc").returns(expected);
		list = ormAdapter.list(table=obj,orderColumn=col);
		assertEquals(expected,list);
		ormService.verify().list(obj,{},col & " asc");
	}

	function listWithNoCriteriaDescSortShouldReturnAllDescending() {
		ormService.list(obj,{},col & " desc").returns(expected);
		list = ormAdapter.list(table=obj,orderColumn=col,orderAscending=false);
		assertEquals(expected,list);
		ormService.verify().list(obj,{},col & " desc");
	}

	function listWithNoCriteriaNoSortShouldReturnAllUnsorted() {
		ormService.list(obj,{}).returns(expected);
		list = ormAdapter.list(table=obj);
		assertEquals(expected,list);
		ormService.verify().list(obj,{});
	}

	function listWithCriteriaDefaultSortShouldReturnSomeAscending() {
		ormService.list(obj,crit,col & " asc").returns(expected);
		list = ormAdapter.list(table=obj,orderColumn=col,criteria=crit);
		assertEquals(expected,list);
		ormService.verify().list(obj,crit,col & " asc");
	}

	function listWithCriteriaDescSortShouldReturnSomeDescending() {
		ormService.list(obj,crit,col & " desc").returns(expected);
		list = ormAdapter.list(table=obj,orderColumn=col,orderAscending=false,criteria=crit);
		assertEquals(expected,list);
		ormService.verify().list(obj,crit,col & " desc");
	}

	function listWithCriteriaNoSortShouldReturnSomeUnsorted() {
		ormService.list(obj,crit).returns(expected);
		list = ormAdapter.list(table=obj,criteria=crit);
		assertEquals(expected,list);
		ormService.verify().list(obj,crit);
	}

	function newWithValidEntityNameReturnsObject() {
		ormService.new(obj).returns(expected);
		newObj = ormAdapter.new(obj);
		assertEquals(expected,newObj);
	}

	/**
	* @mxunit_expectedException "ModelGlue.gesture.orm.cform.cformService.enitityNotFound" 
	*/
	function newWithMissingEntityNameThrows() {
		ormService.new(obj).returns(expected);
		ormService.new("badObj").throws("ModelGlue.gesture.orm.cform.cformService.enitityNotFound");
		newObj = ormAdapter.new("badObj");
	}

	function readWithValidEntityNameReturnsObject() {
		ormService.read(obj,crit).returns(expected);
		theObj = ormAdapter.read(obj,crit);
		assertEquals(expected,theObj);
	}

	function readWithEmptyCriteriaReturnsNewObject() {
		ormService.new(obj).returns(expected);
		theObj = ormAdapter.read(obj,{});
		assertEquals(expected,theObj);
	}

	/**
	* @mxunit:expectedException "ModelGlue.gesture.orm.cform.cformService.enitityNotFound"
	*/
	function readWithMissingEntityNameThrows() {
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
		ormService.commit(obj=1).returns(expected);
		ormAdapter.commit(record=1);
		ormService.verify().commit(obj=1);
	}

	function deleteWithValidKeysCallsServiceWithReturnedObject() {
		ormService.read(obj,crit).returns(expected);
		ormService.delete(expected).returns(expected);
		ormAdapter.delete(obj,crit);
		ormService.verify().delete(expected);
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
