component extends="ModelGlue.unity.orm.AbstractORMAdapter" hint="I am a concrete implementation of a Model-Glue ORM adapter."  {
	
	function init(framework,ormService) {
		variables._mg = arguments.framework;
		variables._ormService = arguments.ormService;
		variables._mdCache = structNew();
		variables._cpCache = structNew();
		variables._pkCache = structNew();
		return this;
	}
	
	any function getORMService() {
		return variables._ormService;
	}
	
	struct function getObjectMetadata(required string table) {
		if (not structKeyExists(variables._mdCache, arguments.table)) {
			variables._mdCache[arguments.table] = generateObjectMetadata(arguments.table);
		}
		return variables._mdCache[arguments.table];
	}

	string function getCriteriaProperties(required string table) {
		if (not structKeyExists(variables._cpCache, arguments.table)) {
			variables._cpCache[arguments.table] = ArrayToList(variables._ormService.getPropertyNames());
		}
		return variables._cpCache[arguments.table];
	}

	any function list(required string entityName, struct criteria=StructNew(), string orderColumn="", boolean orderAscending=true, string gatewayMethod, string gatewayBean) {
		if (structKeyExists(arguments,"gatewayMethod")) {
			if (not structKeyExists(arguments, "gatewayBean")) {
				local.gw = variables._ormService.new(arguments.entityName);
				if (not structKeyExists(gw, arguments.gatewayMethod)) {
					throw(type="ModelGlue.gesture.orm.cform.cformAdapter.badGatewayMethod" message="The gateway method specified (#arguments.gatewayMethod#) does not exist on the Entity ""#arguments.entityName#"".");
				}
			} else {
				local.gw = variables._mg.getBean(arguments.gatewayBean);
				if (not structKeyExists(gw, arguments.gatewayMethod)) {
					throw(type="ModelGlue.gesture.orm.cform.cformAdapter.badGatewayMethod" message="The gateway method specified (#arguments.gatewayMethod#) does not exist on the GatewayBean ""#arguments.gatewayBean#"".");
				}
			}
			
			//return Evaluate("gw.#arguments.gatewayMethod#(argumentCollection=arguments.criteria)");
			local.method = gw[arguments.gatewayMethod];
			return local.method(argumentCollection=arguments.criteria);
		} else {
			return variables._ormService.list(arguments.entityName,arguments.criteria,arguments.orderColumn,arguments.orderAscending);
		}
	}
	
	any function new(required string entityName) {
		return variables._ormService.new(arguments.entityName);
	}
	
	any function read(required string entityName, required struct ids) {
		return variables._ormService.read(arguments.entityName,arguments.ids);
	}
	
	any function validate(required string entityName, required any theObject) {
		return createObject("component", "ModelGlue.Util.ValidationErrorCollection").init();
	}
	
	any function assemble(required any event, required any target) {

		var entityName = arguments.event.getArgument("object");
		var md = getObjectMetadata(entityName);
		var record = arguments.target;
		var childIndex = 1;

		// Update all direct properties	- this will capture inherited properties as well
		if (arguments.event.argumentExists("properties")) {
			arguments.event.makeEventBean(theObject, arguments.event.getArgument("properties", ""));
		} else {
			arguments.event.makeEventBean(theObject);
		}
		
		// Do relationships
		for (i=1; i <= ArrayLen(md.properties); i++) {
			var property = md.properties[i];
			if (property.relationship) {
				var sourceObject = listLast(property.sourceObject, ".");
				if (property.pluralRelationship) {
					// one-to-many and many-to-many
					var eventKey = property.alias & "|" & property.sourceKey;
					if (arguments.event.valueExists(eventKey)) {
						var getMethod = record["get#property.alias#"];
						var hasMethod = record["has#property.alias#"];
						var removeMethod = record["remove#property.alias#"];
						var addMethod = record["add#property.alias#"];
						var children = getMethod();
						// remove all existing
						while (hasMethod()) {
							removeMethod(children[1]);
						}
						// add any requested
						var selectedChildIds = ListToArray(arguments.event.getValue(eventKey));
						for (childIndex=1; childIndex <= ArrayLen(selectedChildIds); childIndex++) { 
						
							criteria[property.sourceKey] = selectedChildIds[childIndex];
							var targetObject = read(sourceObject, criteria);
							// NOTE: Read could return an empty object - how to deal with that? No getIsPersisted() method
							if (not IsNull(targetObject)) {
								addMethod(targetObject);
							}
						}
					}
				} else {
					// one-to-one and many-to-one
					var criteria = {};
					var newValue = arguments.event.getValue(sourceObject);
					var method = record["set#sourceObject#"];
					if (len(newValue)) {
						criteria[property.sourceKey] = arguments.event.getValue(sourceObject);
						var targetObject = read(sourceObject, criteria);
						// NOTE: Read could return an empty object - how to deal with that? No getIsPersisted() method
						if (not IsNull(targetObject)) {
							method(targetObject);
						}
					} else {
						// Remove the source object - but does that make sense? This seems to be a built-in assumption of the scaffolding system
						method(JavaCast("null", 0));
					}
				}
			
			}
			
		}
		
	}

	any function commit(string entityName, required any theObject) {
		return variables._ormService.commit(theObject=arguments.theObject);
	}
	
	any function delete(required string entityName, required struct ids) {
		local.obj = read(arguments.entityName,arguments.ids);
		if (IsNull(local.obj)) {
			throw(type="ModelGlue.gesture.orm.cform.cformAdapter.objectNotFound" message="The object requested to be deleted was not found in the database.");
		} else {
			return variables._ormService.delete(local.obj);
		}
	}

	// private methods used to generate metadata
	
	private struct function generateObjectMetadata(required string entityName) {
		var md = {};
		var entity = EntityNew(arguments.entityName);
		var omd = getMetadata(entity);
		md.alias = arguments.entityName;
		md.label = getLabel(omd,arguments.entityName);
		md._cfcproperties = setCfcProperties(omd);
		var props = processProperties(md._cfcproperties);
		md.properties = props.properties;
		md._primaryKey = props.primaryKey;
		return md;
	}
	
	private struct function generateObjectPKInfo(required string entityName) {
		var pki = {pkName="",labelProperty=""};
		var entity = EntityNew(arguments.entityName);
		var md = getMetadata(entity);
		var props = setCfcProperties(md);
		var i =1;
		if (StructKeyExists(md,"joinColumn")) {
			pki.pkName = md.joinColumn;
		} else {
			for (i=1; i <= ArrayLen(props); i++) {
				var p = props[i];
				if (StructKeyExists(p,"fieldtype") and p.fieldtype eq "id") {
					pki.pkName = ListAppend(pki.pkName,p.name);
				}
			}
		}
		pki.labelProperty = props[1].name; 
		for (i=1; i <= ArrayLen(props); i++) {
			var p = props[i];
			if (canBeLabelField(p)) {
				pki.labelProperty = p.name;
				break; 
			}
		}
		return pki;
	}

	private string function getLabel(required struct md, required string entityName) {
		var label = "";
		var labelAttributes = ["label","displayName"];
		var i =1;
		for (i=1; i <= ArrayLen(labelAttributes); i++) {
			if (StructKeyExists(arguments.md,labelAttributes[i])) {
				label = arguments.md[labelAttributes[i]];
				break;
			}
		}
		if (not Len(label)) {
			label = determineLabel(arguments.entityName);
		}
		return label;
	}
	
	private array function setCfcProperties(required struct md,array props=ArrayNew(1)) {
		var i =1;
		for (i=1; i <= ArrayLen(arguments.md.properties); i++) {
			if (not ArrayContains(arguments.props,arguments.md.properties[i].name)) {
				arrayAppend(arguments.props,arguments.md.properties[i]);
			}
		}
		if (arguments.md.extends.fullname neq "WEB-INF.cftags.component") {
			arguments.props = setCfcProperties(arguments.md.extends,arguments.props);
		}
		return arguments.props;
	}
	
	private struct function processProperties(required array props) {
		var propertyInfo = {properties = {},primaryKey=""};
		var i =1;
		for (i=1; i <= ArrayLen(arguments.props); i++) {
			var p = arguments.props[i];
			var prop = {};
			prop.alias = p.name;
			prop.name = p.name;
			prop.label = getLabel(p,p.Name);
			if (not StructKeyExists(p,"fieldtype") or ListFindNoCase("id,column",p.fieldtype)) {
				prop.cfdatatype = getCfDatatype(p);
			} else {
				prop.cfdatatype = "";
			}
			if (StructKeyExists(p,"fieldtype") and p.fieldtype eq "id") {
				prop.primaryKey = true;
				propertyInfo.primaryKey = ListAppend(propertyInfo.primaryKey,p.name);
			} else {
				prop.primaryKey = false;
			}
			if (StructKeyExists(p,"notnull")) {
				prop.nullable = not p.notnull;
			} else {
				prop.nullable = true;
			}
			if (StructKeyExists(p,"fieldtype") and not ListFindNoCase("id,column",p.fieldtype)) {
				prop.relationship = true;
			} else {
				prop.relationship = false;
			}
			if (StructKeyExists(p,"fieldtype") and ListFindNoCase("one-to-many,many-to-many",p.fieldtype)) {
				prop.pluralrelationship = true;
			} else {
				prop.pluralrelationship = false;
			}
			if (StructKeyExists(p,"cfc")) {
				prop.sourceObject = p.cfc;
				var pkInfo = getObjectPKInfo(p.cfc);
				prop.sourceKey = pkInfo.pkName;
				prop.sourceColumn = pkInfo.labelProperty;
			} else {
				prop.sourceObject = "";
				prop.sourceKey = "";
				prop.sourceColumn = "";
			}
			propertyInfo.properties[p.name] = prop;
		}
		return propertyInfo;
	}
	
	private string function getCfDatatype(required struct prop) {
		var cfdatatype = "string";
		if (StructKeyExists(arguments.prop,"type")) {
			cfdatatype = arguments.prop.type;
		} else {
			if (StructKeyExists(arguments.prop,"ormtype")) {
				switch (arguments.prop.ormtype) {
					case "short": case "integer": case "int": case "long": case "big_decimal": case "float": case "double":
						cfdatatype = "numeric";
						break;
					case "boolean": case "yes_no": case "true_false":
						cfdatatype = "boolean";
						break;
					case "date": case "timestamp": 
						cfdatatype = "date";
						break;
					case "binary": case "serializable": case "blob":
						cfdatatype = "binary";
						break;
				}
			} else {
				if (StructKeyExists(arguments.prop,"generator") and arguments.prop.generator neq "assigned") {
					cfdatatype = "numeric";
				}
			}
			
		}
		return cfdatatype;
	}

	private boolean function canBeLabelField(required struct prop) {
		var canBe = true;
		if (getCfDatatype(arguments.prop) neq "string" 
			or right(arguments.prop.name,2) eq "id"
			or (StructKeyExists(arguments.prop,"length") and arguments.prop.length gt 65534)
			or StructKeyExists(arguments.prop,"ormtype") and listFindNoCase("text,clob",arguments.prop.ormtype)) {
			return false;
		} else {
			return true;
		}
	}

	private struct function getObjectPKInfo(required string table) {
		if (not structKeyExists(variables._pkCache, arguments.table)) {
			variables._pkCache[arguments.table] = generateObjectPKInfo(arguments.table);
		}
		return variables._pkCache[arguments.table];
	}

}
