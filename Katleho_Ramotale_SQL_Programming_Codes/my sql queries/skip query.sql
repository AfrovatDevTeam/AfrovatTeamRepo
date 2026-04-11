select GETDATE()

SELECT Len('Francis')

select * from fnb.Gauteng

select top 3 * from dbo.Finances


select * from fnb.Gauteng


select StaffName, StaffSurname, Amount from dbo.Finances
order by StaffID asc
offset 2 rows
fetch next 3 rows only


select * from dbo.Finances
order by StaffID
offset 1 row
fetch next 2 rows only

select * from dbo.Finances
