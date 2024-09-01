# PowerShell script to rebuild the database

# change to the directory containing the SQL script

Set-Location -Path "C:\Users\hrish\stbot\db\build"

# Execute the SQL script using psql (no password required due to .pgpass, better approach to hardcoding password)

& "C:\Program Files\PostgreSQL\16\bin\psql.exe" -U postgres -d trading_platform -f rebuild_all_tables.sql

# Pause to see output
Read-Host -Prompt "Press Enter to continue"
