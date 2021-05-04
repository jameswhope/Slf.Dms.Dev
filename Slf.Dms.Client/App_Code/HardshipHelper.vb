Imports Microsoft.VisualBasic
Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient
Public Class HardshipHelper
#Region "Variables"
    <Serializable()> _
Public Structure ClientHardship
        Public DataClientID As Integer
        Public HardshipID As Integer
        Public MarriageTypeID As Integer
        Public NumberOfChildren As Integer
        Public NumberOfGrandChildren As Integer
        Public IsReceivingStateAssistance As Boolean
        Public IsReceivingStateAssistanceExplain As String
        Public HasClientReFinanced As Boolean
        Public EquityValueOfHome As Double
        Public ReasonForDebt As String
        Public DoApplicantsHaveAssets As Boolean
        Public AdditionalInformation As String
        Public Created As DateTime
        Public CreatedBy As String
        Public LastModified As DateTime
        Public LastModifiedBy As String
        Public IsHardShipActive As Boolean
        Public ClientHardshipIncomes As List(Of HardshipIncome)
        Public ClientHardshipExpense As List(Of HardshipExpense)
        Public ClientHardshipMedicalHistory As List(Of HardshipMedicalHistory)

    End Structure
    <Serializable()> _
    Public Structure HardshipIncome
        Public IncomeID As Integer
    End Structure
    <Serializable()> _
    Public Structure HardshipExpense
        Public ExpenseID As Integer
    End Structure
    <Serializable()> _
    Public Structure HardshipMedicalHistory
        Public MedicalHistoryID As Integer
    End Structure
#End Region
#Region "Methods/Subs"
    Public Shared Function insertHardshipForClient(ByVal hardship As ClientHardship) As ClientHardship
        Dim newHardship As ClientHardship = Nothing

        Return newHardship
    End Function
    Public Shared Function updateHardshipForClient(ByVal hardship As ClientHardship) As ClientHardship
        Dim updateHardship As ClientHardship = Nothing

        Return updateHardship
    End Function
    Public Shared Function getHardshipForClient(ByVal clientID As Integer) As ClientHardship
        Dim hardship As ClientHardship = Nothing
        'Dim sa As New SqlDataAdapter()
        Dim dtHard As DataTable = Nothing
        Dim sqlHard As String = String.Format("stp_hardship_getClientHardship {0}", clientID)

        Try

            Using cn As New SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString)

                If cn.State = ConnectionState.Closed Then cn.Open()
                Using sa As New SqlDataAdapter(sqlHard, cn)
                    sa.Fill(dtHard)
                    hardship = New ClientHardship
                    For Each row As DataRow In dtHard.Rows
                        With hardship
                            .DataClientID = clientID
                            .HardshipID = row("ClientHardshipDataId").ToString
                            .MarriageTypeID = row("MarriageTypeID").ToString
                            .NumberOfChildren = row("NumOfChildren").ToString
                            .NumberOfGrandChildren = row("NumOfGrandChildren").ToString
                            .IsReceivingStateAssistance = row("IsReceivingStateAssistance").ToString
                            .IsReceivingStateAssistanceExplain = row("IsReceivingStateAssistanceExplain").ToString
                            .HasClientReFinanced = row("HasClientReFinanced").ToString
                            .EquityValueOfHome = row("EquityValueOfHome").ToString
                            .ReasonForDebt = row("ReasonForDebt").ToString
                            .DoApplicantsHaveAssets = row("DoApplicantsHaveAssets").ToString
                            .AdditionalInformation = row("AdditionalInformation").ToString
                            .Created = row("Created").ToString
                            .CreatedBy = row("CreatedBy").ToString
                            .LastModified = row("LastModified").ToString
                            .LastModifiedBy = row("LastModifiedBy").ToString
                            .IsHardShipActive = row("IsHardShipActive").ToString

                        End With
                        Exit For
                    Next
                End Using
            End Using
            Return hardship

        Catch ex As Exception
            Throw ex
        Finally
            dtHard.Dispose()
            dtHard = Nothing
        End Try

    End Function

#End Region
#Region "Utilities"

#End Region
    


End Class
