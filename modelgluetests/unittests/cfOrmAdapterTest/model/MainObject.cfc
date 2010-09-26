component persistent="true" extends="ParentObject" joincolumn="mainId" hint="The main object that contains properties for everything being tested." output="false" {
	//property name="mainId" fieldtype="id" generator="native";
	property name="ormtype_string" ormtype="string";
	property name="ormtype_character" ormtype="character";
	property name="ormtype_char" ormtype="char";
	property name="ormtype_short" ormtype="short";
	property name="ormtype_integer" ormtype="integer";
	property name="ormtype_int" ormtype="int";
	property name="ormtype_long" ormtype="long";
	property name="ormtype_big_decimal" ormtype="big_decimal";
	property name="ormtype_float" ormtype="float";
	property name="ormtype_double" ormtype="double";
	property name="ormtype_Boolean" ormtype="boolean";
	property name="ormtype_yes_no" ormtype="yes_no";
	property name="ormtype_true_false" ormtype="true_false";
	property name="ormtype_text" ormtype="text";
	property name="ormtype_date" ormtype="date";
	property name="ormtype_timestamp" ormtype="timestamp";
	property name="ormtype_binary" ormtype="binary";
	property name="ormtype_serializable" ormtype="serializable";
	property name="ormtype_blob" ormtype="blob";
	property name="ormtype_clob" ormtype="clob";
	property name="type_binary" type="binary";
	property name="type_boolean" type="boolean";
	property name="type_date" type="date";
	//property name="type_guid" type="guid";
	property name="type_numeric" type="numeric";
	property name="type_string" type="string";
	//property name="type_uuid" type="uuid";
	property name="notNullable" notnull="true";

	property name="many2one" fieldtype="many-to-one" cfc="many2one" fkcolumn="many2oneId";
	property name="one2many_array" fieldtype="one-to-many" cfc="one2many_array" fkcolumn="mainId" type="array" inverse="true" singularname="singleName";
	property name="one2many_sruct" fieldtype="one-to-many" cfc="one2many_struct" fkcolumn="mainId" type="struct" structkeycolumn="one2many_structId" inverse="true";
	property name="one2one" fieldtype="one-to-one" cfc="one2one";
	property name="many2many_array" fieldtype="many-to-many" cfc="many2many_array" linktable="main_many2many_array" type="array" inverse="true" fkcolumn="mainId";
	//property name="many2many_struct" fieldtype="many-to-many" cfc="many2many_struct" linktable="main_many2many_struct" type="struct" structkeycolumn="many2many_structId" inverse="true" fkcolumn="mainId";
	
}
