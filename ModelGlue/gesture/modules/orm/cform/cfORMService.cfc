component output="false" hint="I am the ColdFusion ORM service." {
	function init() {
		return this;
	}

	string function getPropertyNames(required string entityName) {
		return ORMGetSessionFactory().getClassMetadata(arguments.entityName).getPropertyNames();
	}
	
	any function read(required string entityName, required struct pkStruct) {
		var obj = entityLoad(arguments.entityName,arguments.pkStruct,true);
		if (isNull(obj)) {
			throw (type="ModelGlue.gesture.orm.cform.cformService.entityNotFound",message="An entity of type #arguments.entityName# could not be found with the specified criteria");
			
		}
		return obj;
	}

	any function new(required string entityName) {
		return EntityNew(arguments.entityName);
	}
	
	any function list(required string entityName, struct filterCriteria=StructNew(), string sortOrder="", string returnType="query") {
		var list = EntityLoad(arguments.entityName,arguments.filterCriteria,sortOrder);
		if (arguments.returnType eq "query") {
			list = EntitytoQuery(list);
		} 
		return list;
	}
	
	any function commit(required any obj) {
		EntitySave(arguments.obj);
	}
	
	any function delete(required any obj) {
		EntityDelete(arguments.obj);
	}

}

