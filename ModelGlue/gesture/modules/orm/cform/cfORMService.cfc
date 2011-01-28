/*
LICENSE INFORMATION:

Copyright 2011, Joe Rinehart, Dan Wilson

Licensed under the Apache License, Version 2.0 (the "License"); you may not 
use this file except in compliance with the License. 

You may obtain a copy of the License at 

	http://www.apache.org/licenses/LICENSE-2.0 
	
Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR 
CONDITIONS OF ANY KIND, either express or implied. See the License for the 
specific language governing permissions and limitations under the License.

VERSION INFORMATION:

This file is part of @versionLabel@ (@versionNumber@).

The version number in parentheses is in the format versionNumber.subversion.revisionNumber.

If the version number appears as 'versionNumber' surrounded by @ symbols
then this file is a working copy and not part of a release build.
*/


component output="false" hint="I am the ColdFusion ORM service." {
	function init() {
		return this;
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

