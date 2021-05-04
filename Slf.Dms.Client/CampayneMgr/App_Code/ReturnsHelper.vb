Imports Microsoft.VisualBasic
Imports System.ComponentModel
Imports System.Data
Imports System.Data.SqlClient

<DataObject(True)> _
Public Class ReturnsHelper
    Public Shared Sub InsertReturn(ByVal BuyerID As Integer, ByVal FilePath As String, ByVal CreatedBy As Integer)
        Dim fileName As String = IO.Path.GetFileName(FilePath)
        Dim ssql As String = "stp_returns_InsertFile"
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("BuyerID", BuyerID))
        params.Add(New SqlParameter("FileName", fileName))
        params.Add(New SqlParameter("FilePath", FilePath))
        params.Add(New SqlParameter("CreatedBy", CreatedBy))
        SqlHelper.ExecuteNonQuery(ssql, CommandType.StoredProcedure, params.ToArray)
    End Sub
    Public Shared Function GetReturns(ByVal buyerid As Integer) As List(Of ReturnObject)
        GetReturns = New List(Of ReturnObject)

        For i As Integer = 0 To 9
            Dim ro As New ReturnObject
            ro.Firstname = String.Format("LeadFirstName{0}", i)
            ro.lastname = String.Format("LeadLastName{0}", i)
            ro.workphone = String.Format("workphone{0}", i)
            ro.homephone = String.Format("homephone{0}", i)
            ro.Vertical = String.Format("Vertical{0}", i)
            ro.ReturnReason = String.Format("ReturnReason{0}", i)
            ro.Buyer = String.Format("Buyer{0}", i)
            ro.Age = String.Format("Age{0}", i)
            ro.Replace = String.Format("Replace{0}", i)
            ro.Calls = String.Format("Calls{0}", i)
        Next

    End Function
    Public Class ReturnObject
        Private _returnid As Integer
        Public Property returnid() As Integer
            Get
                Return _returnid
            End Get
            Set(ByVal value As Integer)
                _returnid = value
            End Set
        End Property
        Private _Buyer As String
        Public Property Buyer() As String
            Get
                Return _Buyer
            End Get
            Set(ByVal value As String)
                _Buyer = value
            End Set
        End Property
        Private _Vertical As String
        Public Property Vertical() As String
            Get
                Return _Vertical
            End Get
            Set(ByVal value As String)
                _Vertical = value
            End Set
        End Property
        Private _Firstname As String
        Public Property Firstname() As String
            Get
                Return _Firstname
            End Get
            Set(ByVal value As String)
                _Firstname = value
            End Set
        End Property
        Private _lastname As String
        Public Property lastname() As String
            Get
                Return _lastname
            End Get
            Set(ByVal value As String)
                _lastname = value
            End Set
        End Property
        Private _workphone As String
        Public Property workphone() As String
            Get
                Return _workphone
            End Get
            Set(ByVal value As String)
                _workphone = value
            End Set
        End Property
        Private _homephone As String
        Public Property homephone() As String
            Get
                Return _homephone
            End Get
            Set(ByVal value As String)
                _homephone = value
            End Set
        End Property
        Private _ReturnReason As String
        Public Property ReturnReason() As String
            Get
                Return _ReturnReason
            End Get
            Set(ByVal value As String)
                _ReturnReason = value
            End Set
        End Property
        Private _Age As String
        Public Property Age() As String
            Get
                Return _Age
            End Get
            Set(ByVal value As String)
                _Age = value
            End Set
        End Property
        Private _Replace As String
        Public Property Replace() As String
            Get
                Return _Replace
            End Get
            Set(ByVal value As String)
                _Replace = value
            End Set
        End Property
        Private _Calls As String
        Public Property Calls() As String
            Get
                Return _Calls
            End Get
            Set(ByVal value As String)
                _Calls = value
            End Set
        End Property
    End Class
    Public Class ReturnActionTemplate
        Implements ITemplate

#Region "Fields"

        Private _ctlName As String
        Private _lit As ListItemType

#End Region 'Fields

#Region "Constructors"

        Public Sub New(ByVal TypeOfList As ListItemType)
            _lit = TypeOfList
        End Sub

#End Region 'Constructors

#Region "Methods"

        Public Sub InstantiateIn(ByVal container As System.Web.UI.Control) Implements System.Web.UI.ITemplate.InstantiateIn
            Select Case _lit
                Case DataControlRowType.Header
                    Dim lc As New Literal()
                    lc.Text = "Return Code"
                    container.Controls.Add(lc)
                    Exit Select
                Case ListItemType.Item
                    Dim ddl As New DropDownList
                    ddl.Width = New Unit("100%")
                    ddl.ID = "ddlCode"
                    ddl.Items.Add(New ListItem("Call back arranged for a certain time", "CALLBK"))
                    ddl.Items.Add(New ListItem("Contact won't be ready for over 6 months", "6 Mon"))
                    ddl.Items.Add(New ListItem("Contact does not have GED or HS diploma", "GED"))
                    ddl.Items.Add(New ListItem("Contact already dispositioned", "DUPE"))
                    ddl.Items.Add(New ListItem("Contact does not have required information", "INFO"))
                    ddl.Items.Add(New ListItem("Do not call", "DNC"))
                    ddl.Items.Add(New ListItem("Contact already enrolled", "Enroll"))
                    ddl.Items.Add(New ListItem("Contact only wanted financial aid", "FIN"))
                    ddl.Items.Add(New ListItem("Contact was only looking for a job", "JOB"))
                    ddl.Items.Add(New ListItem("No English", "NE"))
                    ddl.Items.Add(New ListItem("Contact was not looking for school info", "Noskol"))
                    ddl.Items.Add(New ListItem("No healthcare schools available", "HC"))
                    ddl.Items.Add(New ListItem("No schools available for trade (welding, truck driving, etc.)", "TRADE"))
                    ddl.Items.Add(New ListItem("No campus schools available", "CAMP"))
                    ddl.Items.Add(New ListItem("No schools available for specific reason", "OTH"))
                    ddl.Items.Add(New ListItem("School(s) found", "YES"))
                    ddl.Items.Add(New ListItem("Contact transferred directly to school", "YES-WT"))
                    ddl.Items.Add(New ListItem("", ""))
                    AddHandler ddl.DataBinding, AddressOf LinkDataBinding
                    container.Controls.Add(ddl)

            End Select
        End Sub

        Private Sub LinkDataBinding(ByVal sender As Object, ByVal e As EventArgs)
            If TypeOf sender Is LinkButton Then
                Dim lnk As LinkButton = TryCast(sender, LinkButton)
                Dim container As GridViewRow = DirectCast(lnk.NamingContainer, GridViewRow)
                'lnk.CommandArgument = DirectCast(container.DataItem, DataRowView)("SaveGuid").ToString()
            End If
            If TypeOf sender Is DropDownList Then
                Dim ddl As DropDownList = TryCast(sender, DropDownList)
                Dim container As GridViewRow = DirectCast(ddl.NamingContainer, GridViewRow)
                Dim val As String = DirectCast(container.DataItem, DataRowView)("status").ToString()
                For Each itm As ListItem In ddl.Items
                    If itm.Value = val Then
                        itm.Selected = True
                        Exit For
                    End If
                Next

            End If
        End Sub

#End Region 'Methods

    End Class
End Class
