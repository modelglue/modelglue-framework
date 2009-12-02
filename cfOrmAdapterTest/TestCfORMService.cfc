component extends="modelglue.gesture.test.ModelGlueAbstractTestCase" {
	//this.coldspringPath = "ColdSpring.xml";
	
	function setup() {
		servicePath = "ModelGlue.gesture.modules.orm.cform.cfORMService";
		ormService = createObject("component",variables.servicePath).init();
		entityName = "MainObject";
		col = "mainid";
		crit = {mainid=1};
		listName = "listObject";
	}
	
	function readWithEntityNameReturnsExistingObject() {
		obj = ormService.read(entityName,{mainId=1});
		assertEquals("model.MainObject",getMetaData(obj).name);
		assertEquals(1,obj.getMainId());
	}
	
	function readWithComponentPathAndLastItemIsEntityNameReturnsExistingObject() {
		obj = ormService.read("model.MainObject",{mainId=1});
		assertEquals("model.MainObject",getMetaData(obj).name);
		assertEquals(1,obj.getMainId());
	}
	
	function readWithComponentPathReturnsExistingObject() {
		obj = ormService.read("model.entityName",{somethingDifferentId=1});
		assertEquals("model.entityName",getMetaData(obj).name);
		assertEquals(1,obj.getsomethingDifferentId());
	}
	
	function readWithCompositeKeyReturnsExistingObject() {
		obj = ormService.read("compositeKeyObject",{key1=1,key2="a"});
		assertEquals("model.compositeKeyObject",getMetaData(obj).name);
		assertEquals("b",obj.getAProperty());
	}
	
	function readThrowsOnMissingObject()  mxunit_expectedException="ModelGlue.gesture.orm.cform.cformService.entityNotFound" {
		obj = ormService.read(entityName,{mainId=10000});
	}
	
	function readThrowsIfMoreThanOneRecordFound()  mxunit_expectedException="Application" {
		obj = ormService.read("compositeKeyObject",{key1=1});
	}
	
	function newWithEntityNameReturnsNewObject() {
		obj = ormService.new(entityName);
		assertEquals("model.MainObject",getMetaData(obj).name);
		assertTrue(IsNull(obj.getMainId()),"The mainId property should be NULL for a new object but isn't.");
	}
	
	function newWithComponentPathNameReturnsNewObject() {
		obj = ormService.new("model.MainObject");
		assertEquals("model.MainObject",getMetaData(obj).name);
		assertTrue(IsNull(obj.getMainId()),"The mainId property should be NULL for a new object but isn't.");
	}
	
	function newThrowsIfEntityDoesNotExist()  mxunit_expectedException="Application" {
		obj = ormService.new("blahblah");
	}
	
	function lisReturnsQueryByDefault() {
		list = ormService.list(listName);
		assertEquals(true,isQuery(list));
	}

	function lisReturnsArrayIfAsked() {
		list = ormService.list(entityName=listName,returnType="array");
		assertEquals(true,isArray(list));
	}

	function listWithNoCriteriaShouldReturnAll() {
		list = ormService.list(entityName=listName);
		debug(list);
		assertEquals(4,list.recordCount);
	}

	function listWithNoCriteriaWithSortShouldReturnAllSorted() {
		list = ormService.list(entityName=listName,sortOrder="FirstName desc");
		assertEquals(4,list.recordCount);
		assertEquals("Daniel",list.FirstName[1]);
		assertEquals("Bob",list.FirstName[4]);
	}

	function listWithCriteriaShouldReturnSome() {
		list = ormService.list(entityName=listName,filterCriteria={lastName="Silverberg"});
		assertEquals(3,list.recordCount);
		list = ormService.list(entityName=listName,filterCriteria={firstName="Bob",lastName="Silverberg"});
		assertEquals(1,list.recordCount);
	}

	function listWithCriteriaAndSortShouldReturnSomeSorted() {
		list = ormService.list(entityName=listName,filterCriteria={lastName="Silverberg"},sortOrder="FirstName desc");
		assertEquals(3,list.recordCount);
		assertEquals("Daniel",list.FirstName[1]);
		assertEquals("Bob",list.FirstName[3]);
	}

	function commitSavesNewObjectAndDeleteDeletesIt() {
		obj = entityNew(listName);
		obj.setFirstName("John");
		obj.setLastName("Doe");
		ormService.commit(obj);
		ormFlush();
		pk = obj.getListId();
		objSaved = entityLoadByPK(listName,pk);
		assertEquals("John",objSaved.getFirstName());
		assertEquals("Doe",objSaved.getLastName());
		ormService.delete(objSaved);
		ormFlush();
		objDeleted = entityLoadByPK(listName,pk);
		assertEquals(true,isNull(objDeleted));
	}
	
}
