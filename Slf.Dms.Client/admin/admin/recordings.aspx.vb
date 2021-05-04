
Partial Class admin_recordings
    Inherits System.Web.UI.Page

    Private numFiles As Integer
    Private numFolders As Integer
    Private maxSize As Long
    Private avgSize As Double
    Private size As Long

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        RecursiveSearch(txtDir.Text)
        lblFiles.Text = numFiles
        lblFolders.Text = numFolders
        lblMaxSize.Text = FormatNumber(maxSize / 1048576, 2) & " MB"
        lblAvgSize.Text = FormatNumber((size / 1048576) / numFiles, 2) & " MB"
        lblSize.Text = FormatNumber(size / 1073741824, 2) & " GB"
    End Sub

    Private Sub RecursiveSearch(ByRef strDirectory As String)
        Dim di As New IO.DirectoryInfo(strDirectory)
        Dim dirs() As IO.DirectoryInfo = di.GetDirectories
        Dim files() As IO.FileInfo = di.GetFiles

        For Each file As IO.FileInfo In files
            numFiles += 1
            size += file.Length
            If file.Length > maxSize Then
                maxSize = file.Length
            End If
        Next

        For Each dir As IO.DirectoryInfo In dirs
            numFolders += 1
            RecursiveSearch(dir.FullName)
        Next
    End Sub
End Class
