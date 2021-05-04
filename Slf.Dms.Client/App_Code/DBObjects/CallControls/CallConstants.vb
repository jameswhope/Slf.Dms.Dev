Imports Microsoft.VisualBasic
Imports ININ.IceLib.Interactions

Public Class CallConstants
    Public Const HttpSession_UserInfo As String = "UserInfo"
    Public Const HttpSession_Username As String = "Username"
    Public Const HttpSession_Password As String = "Password"
    Public Const HttpSession_CICServer As String = "CIC Server"
    Public Const HttpSession_Session As String = "Session"
    Public Const HttpSession_StatusDescriptions As String = "StatusDescriptions"
    Public Const HttpSession_UserStatus As String = "UserStatus"

    ' CACHE KEYS
    Public Const Cache_Session As String = "Session"

    ' NECESSARY ATTRIBUTES NEEDED TO PERFORM ACTIONS ON INTERACTIONS
    Public Shared _NecessaryAttributes As String() = {InteractionAttributeName.Capabilities, _
                                                        InteractionAttributeName.State, _
                                                        InteractionAttributeName.StateDescription, _
                                                        InteractionAttributeName.CallIdKey, _
                                                        InteractionAttributeName.RemoteAddress, _
                                                        InteractionAttributeName.RemoteName, _
                                                        InteractionAttributeName.InitiationTime, _
                                                        InteractionAttributeName.Direction, _
                                                        InteractionAttributeName.LocalAddress, _
                                                        InteractionAttributeName.WorkgroupQueueName, _
                                                        InteractionAttributeName.WorkgroupQueueDisplayName, _
                                                        InteractionAttributeName.LocalName}
End Class
