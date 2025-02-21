EAM01						5.44 	 GB -- WPS
EAM03						7.64 	 GB -- WGL
WISAG_PRD				107.40 GB
WISAG03_PRD			5.62 	 GB 
WISAGAB_PRD			4.10 	 GB
WISAGSITE1_PRD	31.03  GB


DB Name					EAM version	Build
EAM01						11.4			  201906
EAM03						11.4			  201906
WISAG_PRD				12				  202301
WISAG03_PRD			12				  202301
WISAGAB_PRD			12				  202301
WISAGSITE1_PRD	12	  		  202301


EAM SQl DB details
inhydeamwsiag
sa/Hexagon@123
WISAG/WISAG

EAM APP
http://inhydeamwisag.ingrnet.com/web/base/logout?tenant=WISAG_PRD
R5/Hexagon@123

http://inhydeamwisag.ingrnet.com/web/base/logout?tenant=WISAG03_PRD
R5/Hexagon@123

http://inhydeamwisag.ingrnet.com/web/base/logout?tenant=WISAGAB_PRD
R5/Hexagon@123

http://inhydeamwisag.ingrnet.com/web/base/logout?tenant=WISAGSITE1_PRD
R5/Hexagon@123

-- Need to discuss
1) Sequence
2) User Tables / UDS
3) Post Delete Approach
4) Base triggers for Audit and Mail Notification
5) Custom screen  Approach 
6) UDS Approach 

-- Check List For Post Migrations 
1) Need to enable audit triggers 
2) Mail notification trigger reactivations
3) User table creation and Data Move 
4) Colned screen actions

--Inactive -- EAM Object Analysis


-----------------sql dependency quries----


SELECT * FROM sysobjects WHERE LOWER(NAME) ='O7CUSTOM'

SELECT * FROM sysobjects where id =2136043041

SELECT * FROM sys.views where name ='WG_CHK_NEXTPMDUE'

select * from R5EXTENSIBLEFRAMEWORK where  upper(EFR_SOURCECODE) like '%WG_SPLITDESC%'

select * from R5FLEXSQL where upper(FLX_STMT) like  '%WG_SPLITDESC%'

select * from R5QUERIES where  upper(que_text) like  '%WG_SPLITDESC%'

select * from R5HOME where UPPER(HOM_WHERECLAUSE) like  '%WG_SPLITDESC%'

select * from R5GRID where upper(GRD_BASEQUERY) like  '%WG_SPLITDESC%'

select * from R5ALERTSQL where upper(ALS_STMT)  like  '%WG_SPLITDESC%'

SELECT * FROM R5SCHEDULEDJOBS WHERE UPPER (SCJ_JOBNAME)like  '%WG_SPLITDESC%'

SELECT DISTINCT
    o.name AS Object_Name,o.type_desc
    FROM sys.sql_modules        m 
        INNER JOIN sys.objects  o ON m.object_id=o.object_id
    WHERE UPPER(m.definition) Like UPPER('%r5o7_o7get_desc%')
    ORDER BY 2,1

SELECT * FROM syscomments WHERE UPPER([text] )LIKE '%POSUPD_ADD_WG%'

sp_helptext 'r5o7_o7get_desc'


--Objects referenced in the Stored Procedure
SELECT OBJECT_NAME(referencing_id) AS referencing_entity_name,       o.type_desc AS referencing_desciption,       COALESCE(COL_NAME(referencing_id, referencing_minor_id), '(n/a)') AS referencing_minor_id,       referencing_class_desc,      referenced_server_name, referenced_database_name, referenced_schema_name,      referenced_entity_name,       COALESCE(COL_NAME(referenced_id, referenced_minor_id), '(n/a)') AS referenced_column_name,  
    is_caller_dependent, is_ambiguous  
FROM sys.sql_expression_dependencies AS sed  
INNER JOIN sys.objects AS o ON sed.referencing_id = o.object_id  
WHERE UPPER(referencing_id) = OBJECT_ID(N'WISAG03_PRD.O7CUSTOM');  
GO


--Objects referencing Stored procedure
SELECT OBJECT_SCHEMA_NAME ( referencing_id ) AS referencing_schema_name,      OBJECT_NAME(referencing_id) AS referencing_entity_name,       o.type_desc AS referencing_desciption,       COALESCE(COL_NAME(referencing_id, referencing_minor_id), '(n/a)') AS referencing_minor_id,       referencing_class_desc, referenced_class_desc,      referenced_server_name, referenced_database_name, referenced_schema_name,      referenced_entity_name,       COALESCE(COL_NAME(referenced_id, referenced_minor_id), '(n/a)') AS referenced_column_name,  
    is_caller_dependent, is_ambiguous  
FROM sys.sql_expression_dependencies AS sed  
INNER JOIN sys.objects AS o ON sed.referencing_id = o.object_id  
WHERE UPPER(referenced_id) = OBJECT_ID(N'WISAG03_PRD.O7CUSTOM');  
GO 		


select cus_objecttype, COUNT(*) cnt, 'Summary' as Summary 
from customeamobjects left join custom_type on cus_objecttype = object_type
WHERE custom_type = 'DB'
--and not exists (select 1 from enx_objects where cus_objecttype = object_type and cus_objectname = object_name)
GROUP BY cus_objecttype
order by cus_objecttype

select * from custom_type WHERE custom_type = 'DB' AND object_type NOT IN ('TABLE','EXTENDED STORED PROCEDURE'
,'INTERNAL TABLE','PACKAGE BODY','REPLICATION FILTER STORED PROCEDURE','SYSTEM TABLE')
order by object_type

select * from custom_type WHERE custom_type = 'EAM'
order by object_type
