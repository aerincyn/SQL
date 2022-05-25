SELECT 
    `customer`.`customer_id`,
    `customer`.`sex_at_birth`,
    `customer`.`birthdate`,
    `occupation`.`occupation`,
    `employment_type`.`employment_type`,
    `country`.`country`,
    `type_of_client_staging17`.`type_of_client` AS `Wholesale/ Retail`,
    `education`.`education`,
    `race`.`race`,
    `marital_status`.`marital_status`,
    `relationship_in_household`.`relationship_in_household`,
    `revenue_table`.`quantity`,
    `revenue_table`.`price`
FROM
    `H_Retail`.`customer`
        INNER JOIN
    `H_Retail`.`occupation` ON `customer`.`occupation_id` = `occupation`.`occupation_id`
        INNER JOIN
    `H_Retail`.`country` ON `customer`.`original_country_of_citizenship_id` = `country`.`country_id`
        INNER JOIN
    `H_Retail`.`education` ON `customer`.`education_id` = `education`.`education_id`
        INNER JOIN
    `H_Retail`.`employment_type` ON `customer`.`employment_type_id` = `employment_type`.`employment_type_id`
        INNER JOIN
    `H_Retail`.`race` ON `customer`.`race_id` = `race`.`race_id`
        INNER JOIN
    `H_Retail`.`marital_status` ON `customer`.`marital_status_id` = `marital_status`.`marital_status_id`
        INNER JOIN
    `H_Retail`.`relationship_in_household` ON `customer`.`relationship_in_household_id` = `relationship_in_household`.`relationship_in_household_id`
        LEFT JOIN
    `H_Retail`.`type_of_client_staging17` ON `customer`.`customer_id` = `type_of_client_staging17`.`customer_id`
        INNER JOIN
    (SELECT 
        `invoice17`.`customer_id`,
            SUM(ABS(`quantity`)) AS `quantity`,
            AVG(`unit_price`) AS `price`
    FROM
        `H_Retail`.`invoice_line`
    INNER JOIN `H_Retail`.`invoice17` ON `invoice17`.`invoice_id` = `invoice_line`.`invoice_id`
    INNER JOIN `H_Retail`.`customer` ON `customer`.`customer_id` = `invoice17`.`customer_id`
    WHERE
        `customer`.`customer_id` != 0
    GROUP BY `invoice17`.`customer_id`) AS `revenue_table` ON `revenue_table`.`customer_id` = `customer`.`customer_id`;