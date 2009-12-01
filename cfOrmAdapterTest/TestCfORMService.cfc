component extends="modelglue.gesture.test.ModelGlueAbstractTestCase" {
	//this.coldspringPath = "ColdSpring.xml";
	
	function setup() {
		variables.servicePath = "ModelGlue.gesture.modules.orm.cform.cfORMService";
		variables.ormService = createObject("component",variables.servicePath).init();
	}
	
	function ormServiceCanBeCreated() {
		assertEquals(variables.servicePath,getMetaData(variables.ormService).name);
	}
	
	function MainObjectCanBeRetrieved() {
		MainObject = EntityLoadByPK("MainObject",1);
		assertEquals(1,MainObject.getMainId());
	}
	

}
