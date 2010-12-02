component extends="ModelGlue.unity.orm.AbstractORMAdapter" hint="I am a concrete implementation of a Model-Glue ORM adapter."  {
	
	function init(framework,ormService,ormName="cfOrm") {
		variables._mg = arguments.framework;
		variables._ormService = arguments.ormService;
		variables._ormName = arguments.ormName;
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
			var props = getObjectMetadata(arguments.table).properties;
			var prop = 0;
			var list = "";
			for (prop in props) {
				if (not props[prop].relationship) {
					list = listAppend(list,prop);
				}
			}
			variables._cpCache[arguments.table] = list;
		}
		return variables._cpCache[arguments.table];
	}

	any function list(required string table, struct criteria=StructNew(), string orderColumn="", boolean orderAscending=true, string gatewayMethod, string gatewayBean) {
		if (structKeyExists(arguments,"gatewayMethod")) {
			if (not structKeyExists(arguments, "gatewayBean")) {
				var gw = variables._ormService.new(arguments.table);
				if (not structKeyExists(gw, arguments.gatewayMethod)) {
					throw(type="ModelGlue.gesture.orm.cform.cformAdapter.badGatewayMethod" message="The gateway method specified (#arguments.gatewayMethod#) does not exist on the Entity ""#arguments.table#"".");
				}
			} else {
				var gw = variables._mg.getBean(arguments.gatewayBean);
				if (not structKeyExists(gw, arguments.gatewayMethod)) {
					throw(type="ModelGlue.gesture.orm.cform.cformAdapter.badGatewayMethod" message="The gateway method specified (#arguments.gatewayMethod#) does not exist on the GatewayBean ""#arguments.gatewayBean#"".");
				}
			}
			
			return Evaluate("gw.#arguments.gatewayMethod#(argumentCollection=arguments.criteria)");
		} else {
			if (len(arguments.orderColumn)) {
				if (arguments.orderAscending) {
					arguments.orderColumn = arguments.orderColumn & " asc";
				} else {
					arguments.orderColumn = arguments.orderColumn & " desc";
				}
				return variables._ormService.list(arguments.table,arguments.criteria,arguments.orderColumn);
			} else {
				return variables._ormService.list(arguments.table,arguments.criteria);
			}
		}
	}
	
	any function new(required string table) {
		return variables._ormService.new(arguments.table);
	}
	
	any function read(required string table, required struct ids) {
		// Dennis says: "You do need to make sure that read(table,criteria) returns a new entity when StructIsEmpty(criteria)"
		if (structIsEmpty(arguments.ids)) {
			return variables._ormService.new(arguments.table);
		} else {
			return variables._ormService.read(arguments.table,arguments.ids);
		}
	}
	
	any function validate(required string table, required any theObject) {
		return createObject("component", "ModelGlue.Util.ValidationErrorCollection").init();
	}
	
	any function assemble(required any event, required any target) {

		var entityName = arguments.event.getArgument("object");
		var props = getObjectMetadata(entityName).properties;
		var p = 0;
		var property = 0;
		var childIndex = 1;
		var childKey = 0;
		var errorCollection = createObject("component", "ModelGlue.Util.ValidationErrorCollection").init();
		var record = arguments.target;
		var childIndex = 1;

		// Update all direct properties	- this will capture inherited properties as well
		if (arguments.event.argumentExists("properties")) {
			arguments.event.makeEventBean(record, arguments.event.getArgument("properties", ""));
		} else {
			arguments.event.makeEventBean(record);
		}
		
		// Do relationships
		for (p in props) {
			property = props[p];
			if (property.relationship) {
				if (property.pluralRelationship) {
					// one-to-many and many-to-many
					var eventKey = property.alias & "|" & property.sourceKey;
					if (arguments.event.valueExists(eventKey)) {
						var children = evaluate("record.get#property.alias#()");
						if (not IsNull(children)) {
							// remove all existing
							if (isArray(children)) {
								// collection is an array
								while (evaluate("record.has#property._singularname#()")) {
									evaluate("record.remove#property._singularname#(children[1])");
								}
							} else {
								// collection is a struct
								while (evaluate("record.has#property._singularname#()")) {
									childKey = listFirst(structKeyList(children));
									evaluate("record.remove#property._singularname#(childKey)");
								}
							}
						}
						// add any requested
						var selectedChildIds = ListToArray(arguments.event.getValue(eventKey));
						for (childIndex=1; childIndex <= ArrayLen(selectedChildIds); childIndex++) { 
							criteria[property.sourceKey] = selectedChildIds[childIndex];
							var targetObject = read(property.sourceObject, criteria);
							if (not IsNull(targetObject)) {
								if (property._collectiontype IS "array") {
									// collection is an array
									evaluate("record.add#property._singularname#(targetObject)");
								} else {
									// collection is a structure
									childKey = evaluate("targetObject.get#property._structKeyColumn#()");
									evaluate("record.add#property._singularname#(childKey,targetObject)");
								}
							}
						}
					}
				} else {
					// one-to-one and many-to-one
					var criteria = {};
					var newValue = arguments.event.getValue(property.sourceKey);
					if (len(newValue)) {
						criteria[property.sourceKey] = newValue;
						var targetObject = read(property.sourceObject, criteria);
						evaluate("record.set#property.alias#(targetObject)");
					} else {
						// Remove the source object - but does that make sense? This seems to be a built-in assumption of the scaffolding system
						evaluate("record.set#property.alias#(JavaCast('null', 0))");
					}
				}
			}
			
		}
		
		return errorCollection;
		
	}

	any function commit(string table, required any record) {
		variables._ormService.commit(obj=arguments.record);
	}
	
	any function delete(required string table, required struct primaryKeys) {
		var obj = read(arguments.table,arguments.primaryKeys);
		variables._ormService.delete(obj);
	}

	// private methods used to generate metadata
	
	private struct function generateObjectMetadata(required string entityName) {
		var md = {};
		var entity = EntityNew(arguments.entityName);
		var omd = getMetadata(entity);
		md.ormName = variables._ormName;
		md.alias = arguments.entityName;
		md.label = getLabel(omd,arguments.entityName);
		md._cfcproperties = setCfcProperties(omd);
		var props = processProperties(md._cfcproperties);
		md.properties = props.properties;
		md.primaryKeys = props.primaryKeys;
		if (structKeyExists(omd,"orderedPropertyList")) {
			md.orderedPropertyList = omd.orderedPropertyList;
		} else {
			md.orderedPropertyList = listSort(structKeyList(md.properties),"textnocase");
		}
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
		if(structKeyExists(arguments.md, "properties")) {
			for (i=1; i <= ArrayLen(arguments.md.properties); i++) {
				if (not ArrayContains(arguments.props,arguments.md.properties[i].name)) {
					arrayAppend(arguments.props,arguments.md.properties[i]);
				}
			}
		}
		if (arguments.md.extends.fullname neq "WEB-INF.cftags.component") {
			arguments.props = setCfcProperties(arguments.md.extends,arguments.props);
		}
		return arguments.props;
	}
	
	private struct function processProperties(required array props) {
		var propertyInfo = {properties = {},primaryKeys = []};
		var i =1;
		for (i=1; i <= ArrayLen(arguments.props); i++) {
			var p = arguments.props[i];
			var prop = {};
			prop.alias = p.name;
			prop.name = p.name;
			prop.label = getLabel(p,p.Name);
			prop.length = getLength(p);
			if (not StructKeyExists(p,"fieldtype") or ListFindNoCase("id,column",p.fieldtype)) {
				prop.cfdatatype = getCfDatatype(p);
			} else {
				prop.cfdatatype = "";
			}
			
			if (StructKeyExists(p,"fieldtype") and p.fieldtype eq "id") {
				prop.primaryKey = true;
				ArrayAppend(propertyInfo.primaryKeys,p.name);
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
			if (prop.relationship) {
				prop.relationshiptype = p.fieldtype;
			} else {
				prop.relationshiptype = "";
			}
			if (StructKeyExists(p,"fieldtype") and ListFindNoCase("one-to-many,many-to-many",p.fieldtype)) {
				prop.pluralrelationship = true;
				prop._collectionType = p.type;
				if (p.type eq "struct") {
					prop._structKeyColumn = p.structKeyColumn;
					prop._structKeyType = p.structKeyType;
				}
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
			if (StructKeyExists(p,"singularname")) {
				prop._singularname = p.singularname;
			} else {
				prop._singularname = p.name;
			}
			if (not StructKeyExists(p,"persistent") or p.persistent is true) {
				prop._persistent = true;
			} else {
				prop._persistent = false;
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
		if (getCfDatatype(arguments.prop) neq "string" 
			or right(arguments.prop.name,2) eq "id"
			or (StructKeyExists(arguments.prop,"length") and arguments.prop.length gt 65535)
			or StructKeyExists(arguments.prop,"ormtype") and listFindNoCase("text,clob",arguments.prop.ormtype)) {
			return false;
		} else {
			return true;
		}
	}

	private boolean function getLength(required struct prop) {
		if ((StructKeyExists(arguments.prop,"length") and arguments.prop.length gt 65535)
			or StructKeyExists(arguments.prop,"ormtype") and listFindNoCase("text,clob",arguments.prop.ormtype)) {
			return 65536;
		} else {
			return 0;
		}
	}

	private struct function getObjectPKInfo(required string table) {
		if (not structKeyExists(variables._pkCache, arguments.table)) {
			variables._pkCache[arguments.table] = generateObjectPKInfo(arguments.table);
		}
		return variables._pkCache[arguments.table];
	}

}
