component persistent="true" output="false"
{
	property name="parentmany2many_arrayId" fieldtype="id" generator="native";
	property name="type_binary" type="binary";
	property name="type_boolean" type="boolean";
	property name="type_date" type="date";
	//property name="type_guid" type="guid";
	property name="type_numeric" type="numeric";
	property name="type_string" type="string";
	//property name="type_uuid" type="uuid";

	property name="ParentObjects_array" fieldtype="many-to-many" cfc="ParentObject" linktable="parentmain_many2many_array" type="array" fkcolumn="parentmany2many_arrayId";

}
