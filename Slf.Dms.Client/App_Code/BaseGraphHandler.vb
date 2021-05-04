Imports System.Drawing
Imports System.Drawing.Imaging
Imports System.IO
Imports System.Web

Imports Drg.Util.Helpers
Imports WebChart

Public MustInherit Class BaseGraphHandler
    Implements IHttpHandler

    Private Shared _defaultColors() As Color = New Color() {Color.FromArgb(255, 193, 96), _
        Color.FromArgb(92, 131, 180), Color.FromArgb(165, 88, 124), Color.FromArgb(108, 124, 101), _
        Color.FromArgb(230, 121, 99), Color.FromArgb(88, 160, 154), Color.FromArgb(207, 93, 96), _
        Color.FromArgb(70, 136, 106), Color.FromArgb(245, 63, 97), Color.FromArgb(158, 153, 88), _
        Color.FromArgb(255, 140, 90), Color.FromArgb(122, 151, 173), Color.FromArgb(84, 142, 128), _
        Color.FromArgb(185, 201, 149), Color.FromArgb(196, 196, 196)}

    Public Shared ReadOnly Property DefaultColors() As Color()
        Get
            Return _defaultColors
        End Get
    End Property

    Public ReadOnly Property IsReusable() As Boolean Implements System.Web.IHttpHandler.IsReusable
        Get
            Return True
        End Get
    End Property

    Public Sub ProcessRequest(ByVal context As System.Web.HttpContext) Implements System.Web.IHttpHandler.ProcessRequest
        Dim widthString As String = context.Request.QueryString("width")
        Dim heightString As String = context.Request.QueryString("height")

        Dim width As Integer = StringHelper.ParseInt(widthString, 320)
        Dim height As Integer = StringHelper.ParseInt(heightString, 240)

        Dim engine As ChartEngine = New ChartEngine()

        engine.Size = New Size(width, height)

        Dim charts As ChartCollection = New ChartCollection(engine)

        engine.Charts = charts

        engine.Border.Color = Color.White
        'engine.Border.Color = Color.Gainsboro
        engine.GridLines = WebChart.GridLines.None

        'engine.Title = new ChartText()
        'engine.Title.Text = GetChartTitle(chart)
        'engine.Title.Font = ChartText.DefaultFont
        'engine.Title.ForeColor = Color.Black

        engine.TopPadding = 0
        engine.ChartPadding = 0

        engine.TopChartPadding = 0
        engine.RightChartPadding = 0

        SetupChart(engine, context.Request.QueryString)

        context.Response.ContentType = "image/png"

        Using bmp As Bitmap = engine.GetBitmap()

            PostProcess(bmp)

            Using ms As MemoryStream = New MemoryStream()

                'send bmp to memory stream
                bmp.Save(ms, ImageFormat.Png)

                'send memory stream to output stream
                ms.WriteTo(context.Response.OutputStream)

            End Using
        End Using

    End Sub

    Protected MustOverride Sub SetupChart(ByVal engine As ChartEngine, ByVal queryString As NameValueCollection)

    Protected Overridable Sub PostProcess(ByVal bmp As Bitmap)

    End Sub

End Class