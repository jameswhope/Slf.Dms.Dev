Imports Microsoft.VisualBasic
Imports System.Net

Public Class IPHelper

    Public Shared Function GetIP4Address() As String
        Dim IP4Address As String = String.Empty

        For Each IPA As System.Net.IPAddress In System.Net.Dns.GetHostAddresses(HttpContext.Current.Request.UserHostAddress)
            If IPA.AddressFamily.ToString() = "InterNetwork" Then
                IP4Address = IPA.ToString()
                Exit For
            End If
        Next

        If IP4Address <> String.Empty Then
            Return IP4Address
        End If

        For Each IPA As System.Net.IPAddress In System.Net.Dns.GetHostAddresses(System.Net.Dns.GetHostName())
            If IPA.AddressFamily.ToString() = "InterNetwork" Then
                IP4Address = IPA.ToString()
                Exit For
            End If
        Next

        Return IP4Address
    End Function

    Public Shared Function IsInRange(ByVal ipaddr As String, ByVal loAddress As String, ByVal hiAddress As String) As Boolean
        Dim lngipaddress As UInt32 = IPToLng(ipaddr)
        Return lngipaddress >= IPToLng(loAddress) AndAlso lngipaddress <= IPToLng(hiAddress)
    End Function

    Public Shared Function IPToLng(ByVal IpAddr As String) As UInt32
        Dim b As Byte() = IPAddress.Parse(IpAddr).GetAddressBytes()
        Array.Reverse(b)
        Return BitConverter.ToUInt32(b, 0)
    End Function

    Public Shared Function IsIntranetAddress(ByVal IPAddr As String) As Boolean
        Try
            Dim addr As IPAddress = IPAddress.Parse(IPAddr)

            Dim b As Boolean = IsInRange("192.168.5.13", "192.168.0.1", "192.168.255.254")

            Return IsInRange(IPAddr, "192.168.0.1", "192.168.255.254") OrElse _
                   IPAddress.IsLoopback(addr) OrElse _
                   IsInRange(IPAddr, "172.16.0.1", "172.31.255.254") OrElse _
                   IsInRange(IPAddr, "10.0.0.1", "10.255.255.254")

        Catch ex As Exception
            Return False
        End Try
    End Function

End Class
