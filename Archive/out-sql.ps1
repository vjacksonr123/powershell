##############################################################################

##

## out-sql.ps1

##

## by Alexey Yeltsov, Microsoft Corp.

##

## Export pipeline contents into a new SQL table

##

## Parameters:

##    $SqlServer        - SQL Server

##    $Database      - Database name

##    $Table         - Table name

##    $DropExisting  - Drop $Table if it already exists and recreate it

##                    (default $false)

##    $RowId         - Add identity column named $RowId and make it a primary key.

##                    (default "RowID". Can pass $null if identity is not needed)

##

##

## Examples:

##   

##    #First, load the function

##    . .\out-sql.ps1

##

##    #Export processes to table Process in database Scratch on local sql server

##    get-process | out-sql -SqlServer . -database Scratch -table Process -dropexisting $true

##

##    #Export volume details from 4 servers into a table

##    @("Server1","Server2","Server3","Server4") `

##    | % {$Server = $_ ; Get-WMIObject Win32_Volume -computer $Server } `

##    | Select-Object `

##        SystemName, `

##        Name, `

##        @{Name="CapacityGb";Expression={[math]::truncate($_.Capacity / 1Gb)}}, `

##        @{Name="FreeGb";Expression={[math]::truncate($_.FreeSpace / 1Gb)}} `

##    | out-sql -sqlserver . -database Scratch -table DiskVolume -dropexisting $true

##

##

##

##############################################################################

 

function Out-Sql($SqlServer=$null,$Database=$null,$Table=$null,$DropExisting=$false,$RowId="RowID") {

  begin

  {

       $Line = 0

       [string]$CreateTable = ""

       if(-not $SqlServer) { throw 'Out-Sql expects $SqlServer parameter' }

       if(-not $Database) { throw 'Out-Sql expects $Database parameter' }

       if(-not $Table) { throw 'Out-Sql expects $Table parameter' }

       if($DropExisting) { write-debug "Note: If the table exists, it WILL be dropped and re-created."}

 

       $SqlConnectionString = "  Provider=sqloledb;" +

                           "  Data Source=$SqlServer;" +

                    "  Initial Catalog=$Database;" +

                    "  Integrated Security=SSPI;"

 

       write-debug "Will open connection to SQL server ""$SqlServer"" and will populate table ""$Table."""

       write-debug "Connection string: `n$SqlConnectionString"

       $SqlConnection = New-Object System.Data.OleDb.OleDbConnection $SqlConnectionString

       $SqlCommand = New-Object System.Data.OleDb.OleDbCommand "",$SqlConnection

       $SqlConnection.Open()

  }

  process

  {

       $Line ++

 

       $Properties = $_.PSObject.Properties

       if (-not $Properties)

       {

         throw "Out-Sql expects object to be passed on the pipeline. The object must have .PSObject.Properties collection."

       }

 

       #if we're at the first line, initialize the table

       if ($Line -eq 1)

       {

              #initialize SQL connection and create table

             

              if($DropExisting) { $CreateTable += "IF OBJECT_ID('$Table') IS NOT NULL DROP TABLE $Table;`n"}

             

              $CreateTable +="CREATE TABLE $Table ( `n"

             

              $col = 0

              if ($RowId)

              {

                     $col++;

                     $CreateTable +="$RowId INT NOT NULL IDENTITY(1,1) PRIMARY KEY CLUSTERED `n"

              }

              foreach($Property in $Properties)

              {

                     $col++;

                     if ($col -gt 1) { $CreateTable +="," }

                    

                     # In below, why not use "if ($Property.Value -is [datetime])"?

                     # Because access can be denied to the value, but Property.TypeNameOfValue would still be accessible!

                     if ($Property.TypeNameOfValue -eq "System.DateTime")

                     {

                           $CreateTable +="$($Property.Name) DATETIME NULL `n"

                     }

                     else

                     {

                           $CreateTable +="$($Property.Name) NVARCHAR(MAX) NULL `n"

                     }

              }

 

              $CreateTable +=")"

      

              write-debug "Will execute SQL to create table: `n$CreateTable"

                    

              $SqlCommand.CommandText = $CreateTable

             

              $rows = $SqlCommand.ExecuteNonQuery()

             

       }

      

       #Prepare SQL insert statement and execute it

       $InsertStatement = "INSERT $Table VALUES("

       $col = 0

       foreach($Property in $Properties)

       {

              $col++;

              if ($col -gt 1) { $InsertStatement += "," }

             

              #In the INSERT statement, do speacial tratment for Nulls, Dates and XML. Other special cases can be added as needed.

              if (-not $Property.Value)

              {

                     $InsertStatement += "null `n"

              }

              elseif ($Property.Value -is [datetime])

              {

                     $InsertStatement += "'" + $Property.Value.ToString("yyyy-MM-dd HH:mm:ss.fff") + "'`n"

              }

              elseif ($Property.Value -is [System.Xml.XmlNode] -or $Property.Value -is [System.Xml.XmlElement])

              {

                     $InsertStatement += "'" + ([string]$($Property.Value.Get_OuterXml())).Replace("'","''") + "'`n"

              }

              else

              {

                     $InsertStatement += "'" + ([string]$($Property.Value)).Replace("'","''") + "'`n"

              }

       }

       $InsertStatement +=")"

 

       write-debug "Running insert statement: `n $InsertStatement"

 

       $SqlCommand.CommandText = $InsertStatement

       $rows = $SqlCommand.ExecuteNonQuery()

  }

  end

  {

       write-debug "closing SQL connection..."

       $SqlConnection.Close()

  }

}