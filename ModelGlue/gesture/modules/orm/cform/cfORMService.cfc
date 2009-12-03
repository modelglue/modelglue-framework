component output="false" hint="I am the ColdFusion ORM service." {
	function init() {
		return this;
	}

	string function getPropertyNames(required string entityName) {
		return ORMGetSessionFactory().getClassMetadata(arguments.entityName).getPropertyNames();
	}
	
	any function read(required string entityName, required struct pkStruct) {
		var obj = 0;
	    try {
			obj = entityLoad(ListLast(arguments.entityName,"."),arguments.pkStruct,true);
	    }
	    catch (any e){
			var md = getComponentMetadata(arguments.entityName);
			if (structKeyExists(md,"entityName")) {
				obj = entityLoad(md.entityName,arguments.pkStruct,true);
			} else {
				throw (type="ModelGlue.gesture.orm.cform.cformService.entityNameNotFound",message="You tried to read an entity with an entity of type #arguments.entityName#, but that is not a valid entityName or the component that it points to does not have an entityName attribute.");
			}
	    }
		if (isNull(obj)) {
			throw (type="ModelGlue.gesture.orm.cform.cformService.entityNotFound",message="An entity of type #arguments.entityName# could not be found with the specified criteria");
		}
		return obj;
	}

	any function new(required string entityName) {
	    try {
			return EntityNew(arguments.entityName);
	    }
	    catch (any e){
			return createObject("component",arguments.entityName);
	    }
	}
	
	any function list(required string entityName, struct filterCriteria=StructNew(), string sortOrder="", string returnType="query") {
		var list = EntityLoad(arguments.entityName,arguments.filterCriteria,arguments.sortOrder);
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

