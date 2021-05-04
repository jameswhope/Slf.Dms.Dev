Option Explicit On

Imports Drg.Util
Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess

Imports System.Data

Public Class ACHHelper

    Public Shared Function GetACH(ByVal RoutingNumber As String, ByVal UserID As Integer) As Integer

        Dim ACHID As Integer = DataHelper.Nz_int(DataHelper.FieldTop1("tblACH", "ACHID", "RoutingNumber = '" _
            & RoutingNumber & "'", "Created DESC"))

        If ACHID = 0 Then 'not found before

            Dim WebInfo As Helpers.ACHHelper.ACHInfo = Helpers.ACHHelper.GetInfoForRoutingNumber(RoutingNumber)

            If Not WebInfo Is Nothing AndAlso WebInfo.RoutingNumber.Length > 0 Then

                'write to table and return id
                Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

                    DatabaseHelper.AddParameter(cmd, "Address", DataHelper.Zn(WebInfo.Address.Trim))
                    DatabaseHelper.AddParameter(cmd, "ChangeDate", DataHelper.Zn(WebInfo.ChangeDate.Trim))
                    DatabaseHelper.AddParameter(cmd, "City", DataHelper.Zn(WebInfo.City.Trim))
                    DatabaseHelper.AddParameter(cmd, "CustomerName", DataHelper.Zn(WebInfo.CustomerName.Trim))
                    DatabaseHelper.AddParameter(cmd, "InstitutionStatusCode", DataHelper.Zn(WebInfo.InstitutionStatusCode.Trim))
                    DatabaseHelper.AddParameter(cmd, "NewRoutingNumber", DataHelper.Zn(WebInfo.NewRoutingNumber.Trim))
                    DatabaseHelper.AddParameter(cmd, "OfficeCode", DataHelper.Zn(WebInfo.OfficeCode.Trim))
                    DatabaseHelper.AddParameter(cmd, "RecordTypeCode", DataHelper.Zn(WebInfo.RecordTypeCode.Trim))
                    DatabaseHelper.AddParameter(cmd, "RoutingNumber", DataHelper.Zn(WebInfo.RoutingNumber.Trim))
                    DatabaseHelper.AddParameter(cmd, "ServicingFRBNumber", DataHelper.Zn(WebInfo.ServicingFRBNumber.Trim))
                    DatabaseHelper.AddParameter(cmd, "StateCode", DataHelper.Zn(WebInfo.StateCode.Trim))
                    DatabaseHelper.AddParameter(cmd, "TelephoneAreaCode", DataHelper.Zn(WebInfo.TelephoneAreaCode.Trim))
                    DatabaseHelper.AddParameter(cmd, "TelephonePrefixNumber", DataHelper.Zn(WebInfo.TelephonePrefixNumber.Trim))
                    DatabaseHelper.AddParameter(cmd, "TelephoneSuffixNumber", DataHelper.Zn(WebInfo.TelephoneSuffixNumber.Trim))
                    DatabaseHelper.AddParameter(cmd, "ZipCode", DataHelper.Zn(WebInfo.ZipCode.Trim))
                    DatabaseHelper.AddParameter(cmd, "ZipCodeExtension", DataHelper.Zn(WebInfo.ZipCodeExtension.Trim))

                    DatabaseHelper.AddParameter(cmd, "Created", Now)
                    DatabaseHelper.AddParameter(cmd, "CreatedBy", UserID)

                    DatabaseHelper.BuildInsertCommandText(cmd, "tblACH", "ACHID", SqlDbType.Int)

                    Using cmd.Connection

                        cmd.Connection.Open()
                        cmd.ExecuteNonQuery()

                        ACHID = DataHelper.Nz_int(cmd.Parameters("@ACHID").Value)

                    End Using
                End Using

            End If

        End If

        Return ACHID

    End Function
End Class