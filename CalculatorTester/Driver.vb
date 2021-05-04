Imports System.IO

Module Driver

    Sub Main()

        Dim IdNumber As Integer = 275143
        Dim results As New List(Of Results)
        Dim SettlementCalculator As SettlementCalculator
        SettlementCalculator = SettlementCalculator.Create("SetCalVersion0001")
        SettlementCalculator.Applicant = New Applicant(IdNumber)

        'Logging Destination Of File
        If Not Directory.Exists(String.Format("{0}\logs", My.Application.Info.DirectoryPath)) Then
            Directory.CreateDirectory(String.Format("{0}\logs", My.Application.Info.DirectoryPath))
        End If

        'Location of Log File
        Dim logPath As String = String.Format("{0}\logs\TestCalculator_Log_{1}.log", My.Application.Info.DirectoryPath, Format(Now, "yyyyMMddhhmm"))

        'Instance of StreamWriter
        Using sw As New StreamWriter(logPath, False)

            'Logging Start Of Application
            sw.WriteLine(String.Format("[{0}]Starting Testing Of Calculator!", Now))
            sw.WriteLine(String.Format("[{0}]", Now))

            Console.WriteLine(String.Format("[{0}]Starting Testing Of Calculator!", Now))
            Console.WriteLine(String.Format("[{0}]", Now))

            Try
                results = SettlementCalculator.Calculate()
            Catch ex As Exception
                sw.WriteLine(String.Format("[{0}]Error Ocurred: {1}", Now, ex.Message))
                Console.WriteLine(String.Format("[{0}]Error Ocurred: {1}", Now, ex.Message))
            End Try

            'Display Results Of Calculator
            For Each result As Results In results
                sw.WriteLine("[{0}]Monthly Deposit: {1}", Now, result.MonthlyDeposit)
                sw.WriteLine("[{0}]Settlement Percentage: {1}", Now, result.PercentageOfSettlement)
                sw.WriteLine("[{0}]Settlement Amount: {1}", Now, result.SettlementAmount)
                sw.WriteLine("[{0}]Total Debt: {1}", Now, result.TotalDebt)
                sw.WriteLine("[{0}]Settlement Fee Percentage: {1}", Now, result.SettlementFeePercentage)
                sw.WriteLine("[{0}]Settlement Fee: {1}", Now, result.SettleFeeAmount)
                sw.WriteLine("[{0}]Initial Fees: {1}", Now, result.InititalFeeAmount)
                sw.WriteLine("[{0}]Total Monthly Fees: {1}", Now, result.TotalMonthlyFee)
                sw.WriteLine("[{0}]Monthly Fees: {1}", Now, result.MonthlyRecurringFee)
                sw.WriteLine("[{0}]Total Fees: {1}", Now, result.TotalAmountFees)
                sw.WriteLine("[{0}]Percent (Cost/Total): {1}", Now, result.PercentFeesToCost)
                sw.WriteLine("[{0}]Months: {1}", Now, result.Months)
                sw.WriteLine("[{0}]Years: {1}", Now, result.Years)
                sw.WriteLine("[{0}]", Now)

                Console.WriteLine("[{0}]Monthly Deposit: {1}", Now, result.MonthlyDeposit)
                Console.WriteLine("[{0}]Settlement Percentage: {1}", Now, result.PercentageOfSettlement)
                Console.WriteLine("[{0}]Settlement Amount: {1}", Now, result.SettlementAmount)
                Console.WriteLine("[{0}]Total Debt: {1}", Now, result.TotalDebt)
                Console.WriteLine("[{0}]Settlement Fee Percentage: {1}", Now, result.SettlementFeePercentage)
                Console.WriteLine("[{0}]Settlement Fee: {1}", Now, result.SettleFeeAmount)
                Console.WriteLine("[{0}]Initial Fees: {1}", Now, result.InititalFeeAmount)
                Console.WriteLine("[{0}]Total Monthly Fees: {1}", Now, result.TotalMonthlyFee)
                Console.WriteLine("[{0}]Monthly Fees: {1}", Now, result.MonthlyRecurringFee)
                Console.WriteLine("[{0}]Total Fees: {1}", Now, result.TotalAmountFees)
                Console.WriteLine("[{0}]Percent (Cost/Total): {1}", Now, result.PercentFeesToCost)
                Console.WriteLine("[{0}]Months: {1}", Now, result.Months)
                Console.WriteLine("[{0}]Years: {1}", Now, result.Years)
                Console.WriteLine("[{0}]", Now)

            Next

            'Logging Statement
            sw.WriteLine("[{0}]Terminating Testing Of Calculator! ...", Now)
            Console.WriteLine("[{0}]Terminating Testing Of Calculator! ...", Now)
            Console.Read()

        End Using

    End Sub

End Module
