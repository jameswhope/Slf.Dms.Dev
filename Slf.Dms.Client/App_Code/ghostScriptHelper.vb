Imports Microsoft.VisualBasic
Imports System.Runtime.InteropServices
Imports System.IO
Public Class ghostScriptHelper
    <DllImport("D:\home\gs\gs8.64\bin\gsdll32.dll", EntryPoint:="gsapi_new_instance", SetLastError:=True, ExactSpelling:=True, CallingConvention:=CallingConvention.StdCall)>
    Private Shared Function gsapi_new_instance(ByRef pinstance As IntPtr, ByVal caller_handle As IntPtr) As Integer
    End Function

    <DllImport("D:\home\gs\gs8.64\bin\gsdll32.dll", EntryPoint:="gsapi_init_with_args", SetLastError:=True, ExactSpelling:=True, CallingConvention:=CallingConvention.StdCall)>
    Private Shared Function gsapi_init_with_args(ByVal instance As IntPtr, ByVal argc As Integer, ByVal argv As IntPtr) As Integer
    End Function

    <DllImport("D:\home\gs\gs8.64\bin\gsdll32.dll", EntryPoint:="gsapi_exit", SetLastError:=True, ExactSpelling:=True, CallingConvention:=CallingConvention.StdCall)>
    Private Shared Function gsapi_exit(ByVal instance As IntPtr) As Integer
    End Function

    <DllImport("D:\home\gs\gs8.64\bin\gsdll32.dll", EntryPoint:="gsapi_delete_instance", SetLastError:=True, ExactSpelling:=True, CallingConvention:=CallingConvention.StdCall)>
    Private Shared Sub gsapi_delete_instance(ByVal instance As IntPtr)
    End Sub
    Public Shared Function PrintPDF(ByVal printerPath As String, ByVal PathToFileToPrint As String) As Boolean
        Dim intReturn, intCounter, intElementCount As Integer
        Dim intGSInstanceHandle As IntPtr
        Dim callerHandle, intptrArgs As IntPtr
        Dim gchandleArgs As GCHandle

        Dim sArgs() As String = GetGeneratedPrintArgs(1, printerPath, PathToFileToPrint)

        intElementCount = sArgs.Length

        Dim aAnsiArgs(intElementCount - 1) As Object
        Dim aPtrArgs(intElementCount - 1) As IntPtr
        Dim aGCHandle(intElementCount - 1) As GCHandle

        For intCounter = 0 To (intElementCount - 1)
            aAnsiArgs(intCounter) = StringToAnsiz(sArgs(intCounter))
            aGCHandle(intCounter) = GCHandle.Alloc(aAnsiArgs(intCounter), GCHandleType.Pinned)
            aPtrArgs(intCounter) = aGCHandle(intCounter).AddrOfPinnedObject()
        Next

        gchandleArgs = GCHandle.Alloc(aPtrArgs, GCHandleType.Pinned)
        intptrArgs = gchandleArgs.AddrOfPinnedObject()

        Try
            intReturn = gsapi_new_instance(intGSInstanceHandle, callerHandle)
            If intReturn < 0 Then
                Cleanup(aGCHandle, gchandleArgs)
                Return False
            End If

            callerHandle = IntPtr.Zero
            intReturn = -1
            intReturn = gsapi_init_with_args(intGSInstanceHandle, intElementCount, intptrArgs)
            If intReturn < 0 Then
                Cleanup(aGCHandle, gchandleArgs)
                Return False
            End If

        Catch ex As DllNotFoundException
            Cleanup(aGCHandle, gchandleArgs)
            Return False
        Finally
            gsapi_exit(intGSInstanceHandle)
            gsapi_delete_instance(intGSInstanceHandle)
        End Try

        Return True
    End Function
    Public Shared Function Convert(ByVal inputFile As String, ByVal outputFile As String, ByVal FirstPageToConvert As Integer, ByVal LastPageToConvert As Integer) As Boolean
        Dim intReturn, intCounter, intElementCount As Integer
        Dim intGSInstanceHandle As IntPtr
        Dim callerHandle, intptrArgs As IntPtr
        Dim gchandleArgs As GCHandle

        Dim sArgs() As String = GetGeneratedArgs(inputFile, outputFile, FirstPageToConvert, LastPageToConvert)

        intElementCount = sArgs.Length

        Dim aAnsiArgs(intElementCount - 1) As Object
        Dim aPtrArgs(intElementCount - 1) As IntPtr
        Dim aGCHandle(intElementCount - 1) As GCHandle

        For intCounter = 0 To (intElementCount - 1)
            aAnsiArgs(intCounter) = StringToAnsiz(sArgs(intCounter))
            aGCHandle(intCounter) = GCHandle.Alloc(aAnsiArgs(intCounter), GCHandleType.Pinned)
            aPtrArgs(intCounter) = aGCHandle(intCounter).AddrOfPinnedObject()
        Next

        gchandleArgs = GCHandle.Alloc(aPtrArgs, GCHandleType.Pinned)
        intptrArgs = gchandleArgs.AddrOfPinnedObject()

        Try
            intReturn = gsapi_new_instance(intGSInstanceHandle, callerHandle)
            If intReturn < 0 Then
                Cleanup(aGCHandle, gchandleArgs)
                Return False
            End If

            callerHandle = IntPtr.Zero
            intReturn = -1
            intReturn = gsapi_init_with_args(intGSInstanceHandle, intElementCount, intptrArgs)
            If intReturn < 0 Then
                Cleanup(aGCHandle, gchandleArgs)
                Return False
            End If

        Catch ex As DllNotFoundException
            Cleanup(aGCHandle, gchandleArgs)
            Return False
        Finally
            gsapi_exit(intGSInstanceHandle)
            gsapi_delete_instance(intGSInstanceHandle)
        End Try

        Return True
    End Function

    Private Shared Function GetGeneratedArgs(ByVal inputPath As String, ByVal outputPath As String, ByVal firstPage As Integer, ByVal lastPage As Integer) As String()
        Return New String() {"-q", "-dQUIET", "-dPARANOIDSAFER", "-dBATCH", "-dNOPAUSE", "-dNOPROMPT", "-dMaxBitmap=500000000", "-dPDFFitPage", String.Format("-dFirstPage={0}", firstPage), String.Format("-dLastPage={0}", lastPage), "-dAlignToPixels=0", "-dGridFitTT=0", "-sDEVICE=jpeg", "-dTextAlphaBits=4", "-dDOINTERPOLATE ", String.Format("-r{0}x{1}", 300, 300), "-dGraphicsAlphaBits=4", "-sPAPERSIZE=a4", "-dFIXEDMEDIA ", String.Format("-sOutputFile={0}", outputPath), inputPath}
    End Function
    Private Shared Function GetGeneratedPrintArgs(ByVal numberOfCopies As Integer, ByVal printerPath As String, ByVal pdfFilePath As String) As String()
        Return New String() {"-dPrinted", "-dBATCH", "-dNOPAUSE", "-dNOSAFER", "-q", String.Format("-dNumCopies={0}", numberOfCopies), "-sDEVICE=ljet4", String.Format("-sOutputFile={0}", printerPath), "-dPDFFitPage", pdfFilePath}
    End Function

    Private Shared Function StringToAnsiz(ByVal original As String) As Byte()

        Dim intElementCount As Integer
        Dim intCounter As Integer
        Dim aAnsi() As Byte
        Dim bChar As Byte
        intElementCount = Len(original)
        ReDim aAnsi(intElementCount + 1)
        For intCounter = 0 To intElementCount - 1
            bChar = Asc(Mid(original, intCounter + 1, 1))
            aAnsi(intCounter) = bChar
        Next intCounter
        aAnsi(intElementCount) = 0
        StringToAnsiz = aAnsi
    End Function

    Private Shared Sub Cleanup(ByRef argStrHandles As GCHandle(), ByRef argPtrsHandle As GCHandle)
        For i As Integer = 0 To (argStrHandles.Length - 1)
            argStrHandles(i).Free()
        Next

        argPtrsHandle.Free()
    End Sub
End Class
