USE H_Accounting;

# Check the columns for Profit and Loss
select distinct statement_section, statement_section_code from account as acc
inner join statement_section as state on state.statement_section_id=acc.profit_loss_section_id;
-- A stored procedure, or a stored routine, is like a function in other programming languages
-- We write the code once, and the code can de reused over and over again
-- We can pass on arguments into the stored procedure. i.e. we can give a specific 
-- input to a store procedure
-- For example we could determine the specific for which we want to produce the 
-- profit and loss statement

#  FIRST thing you MUST do whenever writting a stored procedure is to change the DELIMTER
#  The default deimiter in SQL is the semicolon ;
#  Since we will be using the semicolon to start and finish sentences inside the  stored procedure
#  The compiler of SQL won't know if the semicolon is closing the entire Stored Procedure or an line inside
#  Therefore, we change the DELIMITER so we can be explicit about whan we are 
# closing the stored procedure, vs. when
#  we are closing a specific Select command

# drop the procdedure if the procedure exist
DROP PROCEDURE IF EXISTS H_Accounting.ychiang2020_sp;
-- The tpycal delimiter for Stored procedures is a double dollar sign
DELIMITER $$

# Create the procedure
CREATE PROCEDURE H_Accounting.ychiang2020_sp(varCalendarYear SMALLINT) #year
BEGIN
  
	-- We receive as an argument the year for which we will calculate the revenues
    -- This value is stored as an 'YEAR' type in the variable `varCalendarYear`
    -- To avoid confusion among which are fields from a table vs. which are the variables
    -- A good practice is to adopt a naming convention for all variables
    -- In these lines of code we are naming prefixing every variable as "var"
  
	-- We can define variables inside of our procedure
    -- declare many as variables as you want

	# decalre the variables in the statement section of Income Statement in the current year
    #REVS,COGS,SEXP,OEXP,OI,INCTAX
    DECLARE varTotalRevenues DOUBLE DEFAULT 0;
    DECLARE varTotalCOGS DOUBLE DEFAULT 0;
	DECLARE varTotalSEXP DOUBLE DEFAULT 0;
    DECLARE varTotalOEXP DOUBLE DEFAULT 0;
    DECLARE varTotalOI DOUBLE DEFAULT 0;
    DECLARE varTotalINCTAX DOUBLE DEFAULT 0;
	
    # decalre the variables in the statement section of Income Statement in the last year
    DECLARE varTotalRevenues2 DOUBLE DEFAULT 0;
    DECLARE varTotalCOGS2 DOUBLE DEFAULT 0;
	DECLARE varTotalSEXP2 DOUBLE DEFAULT 0;
    DECLARE varTotalOEXP2 DOUBLE DEFAULT 0;
    DECLARE varTotalOI2 DOUBLE DEFAULT 0;
    DECLARE varTotalINCTAX2 DOUBLE DEFAULT 0;
    
	--  We calculate the value of the sales for the given year and we store it into the variable we just declared
    # calcuate the Renevues of the current year
	SELECT 
    SUM(jeli.credit)
INTO varTotalRevenues FROM
    H_Accounting.journal_entry_line_item AS jeli
        INNER JOIN
    H_Accounting.account AS ac ON ac.account_id = jeli.account_id
        INNER JOIN
    H_Accounting.journal_entry AS je ON je.journal_entry_id = jeli.journal_entry_id
        INNER JOIN
    H_Accounting.statement_section AS ss ON ss.statement_section_id = ac.profit_loss_section_id
WHERE
    ss.statement_section_code = 'REV'
        AND YEAR(je.entry_date) = varCalendarYear;

#calcuate the Renevues of the current year
	SELECT 
    SUM(jeli.credit)
INTO varTotalRevenues2 FROM
    H_Accounting.journal_entry_line_item AS jeli
        INNER JOIN
    H_Accounting.account AS ac ON ac.account_id = jeli.account_id
        INNER JOIN
    H_Accounting.journal_entry AS je ON je.journal_entry_id = jeli.journal_entry_id
        INNER JOIN
    H_Accounting.statement_section AS ss ON ss.statement_section_id = ac.profit_loss_section_id
WHERE
    ss.statement_section_code = 'REV'
        AND YEAR(je.entry_date) = (varCalendarYear-1);
 
 #calcuate the Cost of Goods and Service of the current year 
 
SELECT 
    SUM(jeli.credit)
INTO varTotalCOGS FROM
    H_Accounting.journal_entry_line_item AS jeli
        INNER JOIN
    H_Accounting.account AS ac ON ac.account_id = jeli.account_id
        INNER JOIN
    H_Accounting.journal_entry AS je ON je.journal_entry_id = jeli.journal_entry_id
        INNER JOIN
    H_Accounting.statement_section AS ss ON ss.statement_section_id = ac.profit_loss_section_id
WHERE
    ss.statement_section_code = 'COGS'
        AND YEAR(je.entry_date) = varCalendarYear;
        
 #calcuate the Cost of Goods and Service of the last year
SELECT 
    SUM(jeli.credit)
INTO varTotalCOGS2 FROM
    H_Accounting.journal_entry_line_item AS jeli
        INNER JOIN
    H_Accounting.account AS ac ON ac.account_id = jeli.account_id
        INNER JOIN
    H_Accounting.journal_entry AS je ON je.journal_entry_id = jeli.journal_entry_id
        INNER JOIN
    H_Accounting.statement_section AS ss ON ss.statement_section_id = ac.profit_loss_section_id
WHERE
    ss.statement_section_code = 'COGS'
        AND YEAR(je.entry_date) = (varCalendarYear-1);
        
 #calcuate the Selling Expenses of the current year
SELECT 
    SUM(jeli.credit)
INTO varTotalSEXP FROM
    H_Accounting.journal_entry_line_item AS jeli
        INNER JOIN
    H_Accounting.account AS ac ON ac.account_id = jeli.account_id
        INNER JOIN
    H_Accounting.journal_entry AS je ON je.journal_entry_id = jeli.journal_entry_id
        INNER JOIN
    H_Accounting.statement_section AS ss ON ss.statement_section_id = ac.profit_loss_section_id
WHERE
    ss.statement_section_code = 'SEXP'
        AND YEAR(je.entry_date) = varCalendarYear;
        
 #calcuate the Selling Expenses of the last year
SELECT 
    SUM(jeli.credit)
INTO varTotalSEXP2 FROM
    H_Accounting.journal_entry_line_item AS jeli
        INNER JOIN
    H_Accounting.account AS ac ON ac.account_id = jeli.account_id
        INNER JOIN
    H_Accounting.journal_entry AS je ON je.journal_entry_id = jeli.journal_entry_id
        INNER JOIN
    H_Accounting.statement_section AS ss ON ss.statement_section_id = ac.profit_loss_section_id
WHERE
    ss.statement_section_code = 'SEXP'
        AND YEAR(je.entry_date) = (varCalendarYear-1);
    
 #calcuate the Other Expenses of the current year
SELECT 
    SUM(jeli.credit)
INTO varTotalOEXP FROM
    H_Accounting.journal_entry_line_item AS jeli
        INNER JOIN
    H_Accounting.account AS ac ON ac.account_id = jeli.account_id
        INNER JOIN
    H_Accounting.journal_entry AS je ON je.journal_entry_id = jeli.journal_entry_id
        INNER JOIN
    H_Accounting.statement_section AS ss ON ss.statement_section_id = ac.profit_loss_section_id
WHERE
    ss.statement_section_code = 'OEXP'
        AND YEAR(je.entry_date) = varCalendarYear;
        
 #calcuate the Other Expenses of the last year
SELECT 
    SUM(jeli.credit)
INTO varTotalOEXP2 FROM
    H_Accounting.journal_entry_line_item AS jeli
        INNER JOIN
    H_Accounting.account AS ac ON ac.account_id = jeli.account_id
        INNER JOIN
    H_Accounting.journal_entry AS je ON je.journal_entry_id = jeli.journal_entry_id
        INNER JOIN
    H_Accounting.statement_section AS ss ON ss.statement_section_id = ac.profit_loss_section_id
WHERE
    ss.statement_section_code = 'OEXP'
        AND YEAR(je.entry_date) = (varCalendarYear-1);
        
 #calcuate the Other Income of the current year
SELECT 
    (ifnull(SUM(jeli.credit),0))
INTO varTotalOI FROM
    H_Accounting.journal_entry_line_item AS jeli
        INNER JOIN
    H_Accounting.account AS ac ON ac.account_id = jeli.account_id
        INNER JOIN
    H_Accounting.journal_entry AS je ON je.journal_entry_id = jeli.journal_entry_id
        INNER JOIN
    H_Accounting.statement_section AS ss ON ss.statement_section_id = ac.profit_loss_section_id
WHERE
    ss.statement_section_code = 'OI'
        AND YEAR(je.entry_date) = varCalendarYear;


     #calcuate the Other Income of the last year
    SELECT 
    (ifnull(SUM(jeli.credit),0))
INTO varTotalOI2 FROM
    H_Accounting.journal_entry_line_item AS jeli
        INNER JOIN
    H_Accounting.account AS ac ON ac.account_id = jeli.account_id
        INNER JOIN
    H_Accounting.journal_entry AS je ON je.journal_entry_id = jeli.journal_entry_id
        INNER JOIN
    H_Accounting.statement_section AS ss ON ss.statement_section_id = ac.profit_loss_section_id
   WHERE
    ss.statement_section_code = 'OI'
        AND YEAR(je.entry_date) = (varCalendarYear-1);
        
	    
    -- Let's drop the `tmp` table where we will input the data
	-- The IF EXISTS is important. Because if the table does not exist the DROP alone would fail
	-- A store procedure will stop running whenever it faces an error. 
	#drop the table if the table alreayd exist
    DROP TABLE IF EXISTS H_Accounting.ychiang2020_tmp;
  
  #create the table to store the values
  #adding the header names
  #herewe have 5 columns
CREATE TABLE H_Accounting.ychiang2020_tmp (
    `No` VARCHAR(50),
    Item VARCHAR(50),
    current_year VARCHAR(50),
    last_year VARCHAR(50),
    Percentage_change VARCHAR(50)
);
  
  #insert the header
  -- Now we insert the a header for the report
  INSERT INTO H_Accounting.ychiang2020_tmp 
		   (`NO`, Item, current_year,last_year,Percentage_change)
	VALUES ('','PROFIT AND LOSS STATEMENT', 'In Thousand of dollars','','');
  
	#insert the Revenues 
   INSERT INTO H_Accounting.ychiang2020_tmp 
		    (`NO`, Item, current_year,last_year,Percentage_change)
	VALUES 	('Revenue', '', '','','');
    
    #insert the Revenues with its value
INSERT INTO H_Accounting.ychiang2020_tmp
			 (`NO`, Item, current_year,last_year,Percentage_change)
	VALUES 	('','Revenue',format(varTotalRevenues / 1000, 2),format(varTotalRevenues2 / 1000, 2),
    format(((varTotalRevenues-varTotalRevenues2)/varTotalRevenues2)*100,2));

#insert the Other Income with its value
      INSERT INTO H_Accounting.ychiang2020_tmp
		    (`NO`, Item, current_year,last_year,Percentage_change)
	VALUES 	('', 'Other Income', format(varTotalOI / 1000, 2),format(varTotalOI2 / 1000, 2),
      format(((varTotalOI-varTotalOI2)/varTotalOI2)*100,2));
  
  #calclulate and insert the Total Revenues with its value (other income + Revenues)
  	INSERT INTO H_Accounting.ychiang2020_tmp
			(`NO`, Item, current_year,last_year,Percentage_change)
	VALUES 	('','Total Revenue',format((varTotalOI+varTotalRevenues)/1000,2),format((varTotalOI2+varTotalRevenues2)/1000,2),
    format(((varTotalOI+varTotalRevenues-varTotalOI2-varTotalRevenues2)/(varTotalOI2+varTotalRevenues2))*100,2));
  
  #insert the Expenses with its value
    INSERT INTO H_Accounting.ychiang2020_tmp 
		  (`NO`, Item, current_year,last_year,Percentage_change)
	VALUES 	('Expenses', '', '','','');
  
  #insert the Cost of Good and Service with its value
    INSERT INTO H_Accounting.ychiang2020_tmp 
		   (`NO`, Item, current_year,last_year,Percentage_change)
	VALUES 	('', 'Cost of Good and Service', format(varTotalCOGS / 1000, 2),format(varTotalCOGS2 / 1000, 2),
    format(((varTotalCOGS-varTotalCOGS2)/varTotalCOGS2)*100,2));
    
     #insert the Selling Expenses with its value
     INSERT INTO H_Accounting.ychiang2020_tmp 
	        (`NO`, Item, current_year,last_year,Percentage_change)
	VALUES 	('', 'Selling Expenses', format(varTotalSEXP / 1000, 2),format(varTotalSEXP2 / 1000, 2),
    format(((varTotalSEXP-varTotalSEXP2)/varTotalSEXP2)*100,2));
    
     #insert the Other Expenses with its value
     INSERT INTO H_Accounting.ychiang2020_tmp
		  (`NO`, Item, current_year,last_year,Percentage_change)
	VALUES 	('', 'Other Expenses', format(varTotalOEXP / 1000, 2),format(varTotalOEXP2 / 1000, 2),
    format(((varTotalOEXP-varTotalOEXP2)/varTotalOEXP2)*100,2));
    
  #calculate and insert the Profit Before Income Tax with its value
         INSERT INTO H_Accounting.ychiang2020_tmp
		   (`NO`, Item, current_year,last_year,Percentage_change)
	VALUES 	('Profit Before Income Tax','', format((varTotalRevenues - varTotalCOGS - varTotalSEXP - varTotalOEXP + varTotalOI) / 1000, 2),
    format((varTotalRevenues2 - varTotalCOGS2 - varTotalSEXP2 - varTotalOEXP2 + varTotalOI2) / 1000, 2),'');

  #insert the Income Tax with its value
    INSERT INTO H_Accounting.ychiang2020_tmp
		(`NO`, Item, current_year,last_year,Percentage_change)
	VALUES 	('', 'Income Tax', format(varTotalINCTAX / 1000, 2),format(varTotalINCTAX2 / 1000, 2),'');

#calculate and insert the Gross Profit and Gross Loss with its value
      INSERT INTO H_Accounting.ychiang2020_tmp
		   (`NO`, Item, current_year,last_year,Percentage_change)
	VALUES 	('Gross Profit/Gross Loss','', 
    format((varTotalRevenues - varTotalCOGS - varTotalSEXP - varTotalOEXP + varTotalOI - varTotalINCTAX) / 1000, 2),
    format((varTotalRevenues2 - varTotalCOGS2 - varTotalSEXP2 - varTotalOEXP2 + varTotalOI2 - varTotalINCTAX2) / 1000, 2),
    format((((varTotalRevenues - varTotalCOGS - varTotalSEXP - varTotalOEXP + varTotalOI - varTotalINCTAX)-
    (varTotalRevenues2 - varTotalCOGS2 - varTotalSEXP2 - varTotalOEXP2 + varTotalOI2 - varTotalINCTAX2))/
    (varTotalRevenues2 - varTotalCOGS2 - varTotalSEXP2 - varTotalOEXP2 + varTotalOI2 - varTotalINCTAX2))*100,2));
 
     # Ratio
	# (Gross Profit or Gross Loss /revenue) = Net Profit Margin
	# NPM = (varTotalRevenues - varTotalCOGS - varTotalSEXP - varTotalOEXP + varTotalOI - varTotalINCTAX)/varTotalRevenues
#	INSERT INTO H_Accounting.ychiang2020_tmp
#		(`NO`, Item, current_year,last_year,Percentage_change)
#	VALUES 	('', 'Net Profit Margin', format((varTotalRevenues - varTotalCOGS - varTotalSEXP 
 #   - varTotalOEXP + varTotalOI - varTotalINCTAX)/varTotalRevenuesarTotalINCTAX2),'','');

#end of the procedure     
END $$
DELIMITER ;

# THE LINE ABOVES CHANGES BACK OUR DELIMETER TO OUR USUAL ;
# call the stored procedure 
CALL H_Accounting.ychiang2020_sp(2019);

#print the result in the table which we inserted
SELECT * FROM H_Accounting.ychiang2020_tmp;
