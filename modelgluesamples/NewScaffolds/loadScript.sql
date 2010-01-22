
INSERT INTO Country
VALUES (1,'CA','Canada',1);
INSERT INTO Country
VALUES (2,'US','United States',2);
INSERT INTO Country
VALUES (3,'UK','United Kingdom',99);
INSERT INTO Country
VALUES (0,'','Other',99999);

INSERT INTO province(provinceid, provincename, sortsequence, countryid)
    VALUES (0, 'Other', 3, 0);
INSERT INTO province(provinceid, provincename, sortsequence, countryid)
    VALUES (1, 'Ontario', 1, 1);
INSERT INTO province(provinceid, provincename, sortsequence, countryid)
    VALUES (2, 'Alberta', 1, 1);
INSERT INTO province(provinceid, provincename, sortsequence, countryid)
    VALUES (3, 'British Columbia', 1, 1);
INSERT INTO province(provinceid, provincename, sortsequence, countryid)
    VALUES (4, 'New York', 2, 2);
INSERT INTO province(provinceid, provincename, sortsequence, countryid)
    VALUES (5, 'North Carolina', 2, 2);
INSERT INTO province(provinceid, provincename, sortsequence, countryid)
    VALUES (6, 'Maine', 2, 2);
