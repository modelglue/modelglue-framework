component persistent="true" output="false"
{
	property name="many2oneId" fieldtype="id" generator="native";
	property name="type_binary" type="binary";
	property name="type_boolean" type="boolean";
	property name="type_date" type="date";
	//property name="type_guid" type="guid";
	property name="type_numeric" type="numeric";
	property name="type_string" type="string";
	//property name="type_uuid" type="uuid";

	property name="mainObjects" fieldtype="one-to-many" cfc="MainObject" fkcolumn="many2oneId" type="array" inverse="true";

}
