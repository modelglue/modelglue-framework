INSERT INTO many2one(
            many2oneid, type_boolean, type_date, type_numeric, type_string)
    VALUES (1, true, '2009-11-25', 1, 'a');

INSERT INTO many2many_array(
            many2many_arrayid, type_boolean, type_date, type_numeric, type_string)
    VALUES (1, true, '2009-11-25', 1, 'a');

INSERT INTO many2many_array(
            many2many_arrayid, type_boolean, type_date, type_numeric, type_string)
    VALUES (2, true, '2009-11-25', 1, 'a');

INSERT INTO parentmany2many_array(
            parentmany2many_arrayid, type_boolean, type_date, type_numeric, type_string)
    VALUES (1, true, '2009-11-25', 1, 'a');

INSERT INTO parentmany2many_array(
            parentmany2many_arrayid, type_boolean, type_date, type_numeric, type_string)
    VALUES (2, true, '2009-11-25', 1, 'a');

INSERT INTO many2many_struct(
            many2many_structid, type_boolean, type_date, type_numeric, type_string)
    VALUES (1, true, '2009-11-25', 1, 'a');

INSERT INTO many2many_struct(
            many2many_structid, type_boolean, type_date, type_numeric, type_string)
    VALUES (2, true, '2009-11-25', 1, 'a');

INSERT INTO parentobject(
            mainid, aParentProperty, parentmany2oneid)
    VALUES (1, 'aParentProperty', 1);

INSERT INTO compositekeyobject(key1,key2,aproperty)
VALUES (1,'a','b');
INSERT INTO compositekeyobject(key1,key2,aproperty)
VALUES (1,'b','c');
INSERT INTO compositekeyobject(key1,key2,aproperty)
VALUES (2,'a','d');
INSERT INTO compositekeyobject(key1,key2,aproperty)
VALUES (2,'b','e');


INSERT INTO mainobject(
            mainid, ormtype_string, ormtype_character, ormtype_char, ormtype_short, 
            ormtype_integer, ormtype_int, ormtype_long, ormtype_big_decimal, 
            ormtype_float, ormtype_double, ormtype_boolean, ormtype_yes_no, 
            ormtype_true_false, ormtype_text, ormtype_date, ormtype_timestamp, 
            type_boolean, type_date, type_numeric, type_string, many2oneid,notNullable)
    VALUES (1, 'a', 'a', 'a', 1,
     1, 1, 1, 1.1,
     1.1, 1.1, true, 'y',
     't', 'a', '2009-11-25', '2009-11-25',
     true, '2009-11-25', 1, 'a', 1, 'a');

INSERT INTO one2one(
            mainid, type_boolean, type_date, type_numeric, type_string)
    VALUES (1, true, '2009-11-25', 1, 'a');

INSERT INTO parentone2one(
            mainid, type_boolean, type_date, type_numeric, type_string)
    VALUES (1, true, '2009-11-25', 1, 'a');

INSERT INTO one2many_array(
            one2many_arrayid, type_boolean, type_date, type_numeric, 
            type_string, mainid)
    VALUES (1, true, '2009-11-25', 1, 'a',1);
INSERT INTO one2many_array(
            one2many_arrayid, type_boolean, type_date, type_numeric, 
            type_string, mainid)
    VALUES (2, true, '2009-11-25', 1, 'a',1);
INSERT INTO one2many_array(
            one2many_arrayid, type_boolean, type_date, type_numeric, 
            type_string, mainid)
    VALUES (3, true, '2009-11-25', 1, 'a',1);
            
INSERT INTO parentone2many_array(
            parentone2many_arrayid, type_boolean, type_date, type_numeric, 
            type_string, mainid)
    VALUES (1, true, '2009-11-25', 1, 'a',1);
INSERT INTO parentone2many_array(
            parentone2many_arrayid, type_boolean, type_date, type_numeric, 
            type_string, mainid)
    VALUES (2, true, '2009-11-25', 1, 'a',1);
INSERT INTO parentone2many_array(
            parentone2many_arrayid, type_boolean, type_date, type_numeric, 
            type_string, mainid)
    VALUES (3, true, '2009-11-25', 1, 'a',1);
            
INSERT INTO one2many_struct(
            one2many_structid, type_boolean, type_date, type_numeric, 
            type_string, mainid)
    VALUES (1, true, '2009-11-25', 1, 'a',1);
INSERT INTO one2many_struct(
            one2many_structid, type_boolean, type_date, type_numeric, 
            type_string, mainid)
    VALUES (2, true, '2009-11-25', 1, 'a',1);
INSERT INTO one2many_struct(
            one2many_structid, type_boolean, type_date, type_numeric, 
            type_string, mainid)
    VALUES (3, true, '2009-11-25', 1, 'a',1);

INSERT INTO main_many2many_array(
           many2many_arrayid, mainid)
    VALUES (1, 1);
INSERT INTO main_many2many_array(
            many2many_arrayid, mainid)
    VALUES (2, 1);

INSERT INTO parentmain_many2many_array(
           parentmany2many_arrayid, mainid)
    VALUES (1, 1);
INSERT INTO parentmain_many2many_array(
            parentmany2many_arrayid, mainid)
    VALUES (2, 1);

INSERT INTO listObject(listId,firstName,lastName)
VALUES (1,'Bob','Silverberg');
INSERT INTO listObject(listId,firstName,lastName)
VALUES (2,'Carol','Loffelmann');
INSERT INTO listObject(listId,firstName,lastName)
VALUES (3,'Daniel','Silverberg');
INSERT INTO listObject(listId,firstName,lastName)
VALUES (4,'Colin','Silverberg');

