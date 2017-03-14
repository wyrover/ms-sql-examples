CREATE DATABASE Accounting
ON
  (NAME = 'Accounting',
   FILENAME = 'c:\Program Files\Microsoft SQL Server\mssql\data\AccountingData.mdf',
   SIZE = 10,
   MAXSIZE = 50,
   FILEGROWTH = 5)
LOG ON
  (NAME = 'AccountingLog',
   FILENAME = 'c:\Program Files\Microsoft SQL Server\mssql\data\AccountingLog.ldf',
   SIZE = 5MB,
   MAXSIZE = 25MB,
   FILEGROWTH = 5MB)

GO
