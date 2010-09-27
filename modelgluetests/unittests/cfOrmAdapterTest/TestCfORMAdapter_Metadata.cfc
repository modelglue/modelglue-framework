component extends="modelgluetests.unittests.gesture.ModelGlueAbstractTestCase" {
	
	function setup() {
		servicePath = "ModelGlue.gesture.modules.orm.cform.cfORMService";
		adapterPath = "ModelGlue.gesture.modules.orm.cform.cfORMAdapter";
		// ormService = createObject("component","ModelGlue.gesture.modules.orm.cform.cfORMService").init();
		ormService = mock(servicePath);
		//createModelGlueIfNotDefined(this.coldspringPath);
		mg = mock("ModelGlue.gesture.ModelGlue");
		ormAdapter = createObject("component",adapterPath).init(mg,ormService);
	}
	

	/* This isn't testing the right thing anymore
	function getCriteriaPropertiesReturnsAllPersistedProperties() {
		ormService.getPropertyNames().returns(ORMGetSessionFactory().getClassMetadata("MainObject").getPropertyNames());
		assertEquals(ArrayToList(ORMGetSessionFactory().getClassMetadata("MainObject").getPropertyNames()),ormAdapter.getCriteriaProperties("MainObject"));
	}
	*/

	function getObjectMetadataReturnsCorrectAlias() {
		assertEquals("MainObject",ormAdapter.getObjectMetadata("MainObject").alias);
	}

	function getObjectMetadataReturnsCorrectLabel() {
		assertEquals("Main Object",ormAdapter.getObjectMetadata("MainObject").label);
		assertEquals("The label for this object",ormAdapter.getObjectMetadata("labelObject").label);
		assertEquals("The label for this object",ormAdapter.getObjectMetadata("displayNameObject").label);
	}

	function getObjectMetadataReturnsCorrectPrimaryKeys() {
		assertEquals("mainId",ArrayToList(ormAdapter.getObjectMetadata("MainObject").primaryKeys));
		assertEquals("Id",ArrayToList(ormAdapter.getObjectMetadata("labelObject").primaryKeys));
	}

	function getObjectMetadataPropertyReturnsCorrectAlias() {
		assertEquals("mainId",ormAdapter.getObjectMetadata("MainObject").properties["mainId"].alias);
		assertEquals("many2one",ormAdapter.getObjectMetadata("MainObject").properties["many2one"].alias);
	}

	function getObjectMetadataPropertyReturnsCorrectName() {
		assertEquals("mainId",ormAdapter.getObjectMetadata("MainObject").properties["mainId"].name);
		assertEquals("many2one",ormAdapter.getObjectMetadata("MainObject").properties["many2one"].name);
	}

	function getObjectMetadataPropertyReturnsCorrectLabel() {
		assertEquals("Main Id",ormAdapter.getObjectMetadata("MainObject").properties["mainId"].label);
		assertEquals("many2one",ormAdapter.getObjectMetadata("MainObject").properties["many2one"].label);
		assertEquals("The label for this property",ormAdapter.getObjectMetadata("labelObject").properties["aLabelledString"].label);
		assertEquals("The label for this property",ormAdapter.getObjectMetadata("displayNameObject").properties["aDisplayNamedString"].label);
	}

	function getObjectMetadataPropertyReturnsCorrectPrimaryKey() {
		assertEquals(true,ormAdapter.getObjectMetadata("MainObject").properties["mainId"].primaryKey);
		assertEquals(false,ormAdapter.getObjectMetadata("MainObject").properties["type_string"].primaryKey);
		assertEquals(false,ormAdapter.getObjectMetadata("MainObject").properties["many2one"].primaryKey);
	}

	function getObjectMetadataPropertyReturnsCorrectNullable() {
		assertEquals(true,ormAdapter.getObjectMetadata("MainObject").properties["type_string"].nullable);
		assertEquals(false,ormAdapter.getObjectMetadata("MainObject").properties["notNullable"].nullable);
	}

	function getObjectMetadataPropertyReturnsCorrectRelationship() {
		assertEquals(true,ormAdapter.getObjectMetadata("MainObject").properties["many2one"].relationship);
		assertEquals(false,ormAdapter.getObjectMetadata("MainObject").properties["type_string"].relationship);
		assertEquals(false,ormAdapter.getObjectMetadata("MainObject").properties["mainid"].relationship);
	}

	function getObjectMetadataPropertyReturnsCorrectPluralRelationship() {
		assertEquals(true,ormAdapter.getObjectMetadata("MainObject").properties["one2many_array"].pluralrelationship);
		assertEquals(true,ormAdapter.getObjectMetadata("MainObject").properties["many2many_array"].pluralrelationship);
		assertEquals(false,ormAdapter.getObjectMetadata("MainObject").properties["many2one"].pluralrelationship);
		assertEquals(false,ormAdapter.getObjectMetadata("MainObject").properties["one2one"].pluralrelationship);
		assertEquals(false,ormAdapter.getObjectMetadata("MainObject").properties["mainid"].pluralrelationship);
		assertEquals(false,ormAdapter.getObjectMetadata("MainObject").properties["type_string"].pluralrelationship);
	}

	function getObjectMetadataPropertyReturnsCorrectSourceObject() {
		assertEquals("",ormAdapter.getObjectMetadata("MainObject").properties["mainid"].sourceObject);
		assertEquals("",ormAdapter.getObjectMetadata("MainObject").properties["type_string"].sourceObject);
		assertEquals("many2one",ormAdapter.getObjectMetadata("MainObject").properties["many2one"].sourceObject);
		assertEquals("one2one",ormAdapter.getObjectMetadata("MainObject").properties["one2one"].sourceObject);
		assertEquals("one2many_array",ormAdapter.getObjectMetadata("MainObject").properties["one2many_array"].sourceObject);
		assertEquals("many2many_array",ormAdapter.getObjectMetadata("MainObject").properties["many2many_array"].sourceObject);
	}

	function getObjectMetadataPropertyReturnsCorrectSourceKey() {
		assertEquals("",ormAdapter.getObjectMetadata("MainObject").properties["mainid"].sourceKey);
		assertEquals("",ormAdapter.getObjectMetadata("MainObject").properties["type_string"].sourceKey);
		assertEquals("many2oneId",ormAdapter.getObjectMetadata("MainObject").properties["many2one"].sourceKey);
		assertEquals("mainId",ormAdapter.getObjectMetadata("MainObject").properties["one2one"].sourceKey);
		assertEquals("one2many_arrayId",ormAdapter.getObjectMetadata("MainObject").properties["one2many_array"].sourceKey);
		assertEquals("many2many_arrayId",ormAdapter.getObjectMetadata("MainObject").properties["many2many_array"].sourceKey);
	}

	function getObjectMetadataPropertyReturnsCorrectsourceColumn() {
		assertEquals("",ormAdapter.getObjectMetadata("MainObject").properties["mainid"].sourceColumn);
		assertEquals("",ormAdapter.getObjectMetadata("MainObject").properties["type_string"].sourceColumn);
		assertEquals("type_string",ormAdapter.getObjectMetadata("MainObject").properties["many2one"].sourceColumn);
	}

	function getObjectMetadataPropertyReturnsCorrectlength() {
		assertEquals(1,ormAdapter.getObjectMetadata("MainObject").properties["type_string"].length);
		assertEquals(65536,ormAdapter.getObjectMetadata("MainObject").properties["ormtype_text"].length);
	}

	/* No longer used, but keeping around in case it needs to come back
	function getObjectMetadataPropertyReturnsCorrectCollectionType() {
		assertEquals("",ormAdapter.getObjectMetadata("MainObject").properties["mainid"]._collectionType);
		assertEquals("",ormAdapter.getObjectMetadata("MainObject").properties["type_string"]._collectionType);
		assertEquals("",ormAdapter.getObjectMetadata("MainObject").properties["many2one"]._collectionType);
		assertEquals("",ormAdapter.getObjectMetadata("MainObject").properties["one2one"]._collectionType);
		assertEquals("array",ormAdapter.getObjectMetadata("MainObject").properties["one2many_array"]._collectionType);
		assertEquals("array",ormAdapter.getObjectMetadata("MainObject").properties["many2many_array"]._collectionType);
		assertEquals("struct",ormAdapter.getObjectMetadata("MainObject").properties["one2many_sruct"]._collectionType);
	}
	*/

	// set up data providers

	// To check for property existence
	mo = EntityNew("MainObject");
	directPropertyList = getMetadata(mo).properties;
	po = EntityNew("ParentObject");
	inheritedPropertyList = getMetadata(po).properties;

	// To check datatypes
	dts = [];
	arrayAppend(dts,{name="mainid", type="numeric"});
	arrayAppend(dts,{name="ormtype_string", type="string"});
	arrayAppend(dts,{name="ormtype_character", type="string"});
	arrayAppend(dts,{name="ormtype_char", type="string"});
	arrayAppend(dts,{name="ormtype_short", type="numeric"});
	arrayAppend(dts,{name="ormtype_integer", type="numeric"});
	arrayAppend(dts,{name="ormtype_int", type="numeric"});
	arrayAppend(dts,{name="ormtype_long", type="numeric"});
	arrayAppend(dts,{name="ormtype_big_decimal", type="numeric"});
	arrayAppend(dts,{name="ormtype_float", type="numeric"});
	arrayAppend(dts,{name="ormtype_double", type="numeric"});
	arrayAppend(dts,{name="ormtype_Boolean", type="boolean"});
	arrayAppend(dts,{name="ormtype_yes_no", type="boolean"});
	arrayAppend(dts,{name="ormtype_true_false", type="boolean"});
	arrayAppend(dts,{name="ormtype_text", type="string"});
	arrayAppend(dts,{name="ormtype_date", type="date"});
	arrayAppend(dts,{name="ormtype_timestamp", type="date"});
	arrayAppend(dts,{name="type_boolean", type="boolean"});
	arrayAppend(dts,{name="type_date", type="date"});
	arrayAppend(dts,{name="type_numeric", type="numeric"});
	arrayAppend(dts,{name="type_string", type="string"});
	arrayAppend(dts,{name="ormtype_binary", type="binary"});
	arrayAppend(dts,{name="ormtype_serializable", type="binary"});
	arrayAppend(dts,{name="ormtype_blob", type="binary"});
	arrayAppend(dts,{name="ormtype_clob", type="string"});
	arrayAppend(dts,{name="type_binary", type="binary"});
	arrayAppend(dts,{name="many2one", type=""});
	arrayAppend(dts,{name="one2many_array", type=""});
	arrayAppend(dts,{name="one2many_sruct", type=""});
	arrayAppend(dts,{name="one2one", type=""});
	arrayAppend(dts,{name="many2many_array", type=""});
	arrayAppend(dts,{name="aParentProperty", type="string"});
	arrayAppend(dts,{name="parentmany2one", type=""});
	arrayAppend(dts,{name="parentone2many_array", type=""});
	arrayAppend(dts,{name="parentone2one", type=""});
	arrayAppend(dts,{name="parentmany2many_array", type=""});

	// To check canBeLabel
	cbl = [];
	arrayAppend(cbl,{length="100",expected=true,name="something"});
	arrayAppend(cbl,{length="65536",expected=false,name="something"});
	arrayAppend(cbl,{expected=false,name="somethingid"});
	arrayAppend(cbl,{ormtype="string", expected=true,name="something"});
	arrayAppend(cbl,{ormtype="character", expected=true,name="something"});
	arrayAppend(cbl,{ormtype="char", expected=true,name="something"});
	arrayAppend(cbl,{ormtype="short", expected=false,name="something"});
	arrayAppend(cbl,{ormtype="integer", expected=false,name="something"});
	arrayAppend(cbl,{ormtype="int", expected=false,name="something"});
	arrayAppend(cbl,{ormtype="long", expected=false,name="something"});
	arrayAppend(cbl,{ormtype="big_decimal", expected=false,name="something"});
	arrayAppend(cbl,{ormtype="float", expected=false,name="something"});
	arrayAppend(cbl,{ormtype="double", expected=false,name="something"});
	arrayAppend(cbl,{ormtype="Boolean", expected=false,name="something"});
	arrayAppend(cbl,{ormtype="yes_no", expected=false,name="something"});
	arrayAppend(cbl,{ormtype="true_false", expected=false,name="something"});
	arrayAppend(cbl,{ormtype="text", expected=false,name="something"});
	arrayAppend(cbl,{ormtype="date", expected=false,name="something"});
	arrayAppend(cbl,{ormtype="timestamp", expected=false,name="something"});
	arrayAppend(cbl,{type="boolean", expected=false,name="something"});
	arrayAppend(cbl,{type="date", expected=false,name="something"});
	arrayAppend(cbl,{type="numeric", expected=false,name="something"});
	arrayAppend(cbl,{type="string", expected=true,name="something"});
	arrayAppend(cbl,{ormtype="binary", expected=false,name="something"});
	arrayAppend(cbl,{ormtype="serializable", expected=false,name="something"});
	arrayAppend(cbl,{ormtype="blob", expected=false,name="something"});
	arrayAppend(cbl,{ormtype="clob", expected=false,name="something"});
	arrayAppend(cbl,{type="binary", expected=false,name="something"});

	
	/**
	* @mxunit:dataprovider "directPropertyList"
	*/
	function getObjectMetadataPropertiesShouldReturnAllDirectProperties(property) {
		props = ormAdapter.getObjectMetadata("MainObject").properties;
		assertTrue(StructKeyExists(props,arguments.property.name),"The property #arguments.property.name# was expected but not found");
	}

	/**
	* @mxunit:dataprovider "inheritedPropertyList"
	*/
	function getObjectMetadataPropertiesShouldReturnAllInheritedProperties(property) {
		props = ormAdapter.getObjectMetadata("MainObject").properties;
		assertTrue(StructKeyExists(props,arguments.property.name),"The property #arguments.property.name# was expected but not found");
	}

	/**
	* @mxunit:dataprovider "dts"
	*/
	function getObjectMetadataPropertyReturnsCfdatatype(property) {
		props = ormAdapter.getObjectMetadata("MainObject").properties;
		assertEquals(arguments.property.type,props[arguments.property.name].cfdatatype,"The property #arguments.property.name# should have a type of #arguments.property.type#.");
	}

	/**
	* @mxunit:dataprovider "cbl"
	*/
	function canBeLabelReturnsAsExpected(prop)  {
		makePublic(ormAdapter,"canBeLabelField");
		assertEquals(arguments.prop.expected,ormAdapter.canBeLabelField(arguments.prop));
	}

}
