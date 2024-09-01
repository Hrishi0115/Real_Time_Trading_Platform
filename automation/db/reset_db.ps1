# PowerShell script to remove all data (rows) from database

# change to directory containing the SQL reset script

Set-Location -Path "C:\Users\hrish\stbot\db\build"

# Execute the SQL script using psql

& "C:\Program Files\PostgreSQL\16\bin\psql.exe" -U postgres -d trading_platform -f reset_data.sql

# Pause to see output
Read-Host -Prompt "Press Enter to continue"

