Imports Microsoft.VisualBasic
Imports System
Imports System.Data
Imports System.IO
Imports System.Collections.Generic
Imports System.Text
Imports System.Xml.Serialization

Namespace ssrsDynamicReport

   Public Class TableRdlGenerator

      Private m_fields As List(Of String)

      Public Property Fields() As List(Of String)
         Get
            Return m_fields
         End Get
         Set(ByVal value As List(Of String))
            m_fields = value
         End Set
      End Property

      Public Function CreateTable() As Rdl.TableType
         Dim table As New Rdl.TableType()
         table.Name = "Table1"
         table.Items = New Object() {CreateTableColumns(), CreateHeader(), CreateDetails()}
         table.ItemsElementName = New Rdl.ItemsChoiceType21() {Rdl.ItemsChoiceType21.TableColumns, Rdl.ItemsChoiceType21.Header, Rdl.ItemsChoiceType21.Details}
         Return table
      End Function

      Private Function CreateHeader() As Rdl.HeaderType
         Dim header As New Rdl.HeaderType()
         header.Items = New Object() {CreateHeaderTableRows()}
         header.ItemsElementName = New Rdl.ItemsChoiceType20() {Rdl.ItemsChoiceType20.TableRows}
         Return header
      End Function

      Private Function CreateHeaderTableRows() As Rdl.TableRowsType
         Dim headerTableRows As New Rdl.TableRowsType()
         headerTableRows.TableRow = New Rdl.TableRowType() {CreateHeaderTableRow()}
         Return headerTableRows
      End Function

      Private Function CreateHeaderTableRow() As Rdl.TableRowType
         Dim headerTableRow As New Rdl.TableRowType()
         headerTableRow.Items = New Object() {CreateHeaderTableCells(), "0.25in"}
         Return headerTableRow
      End Function

      Private Function CreateHeaderTableCells() As Rdl.TableCellsType
         Dim headerTableCells As New Rdl.TableCellsType()
         headerTableCells.TableCell = New Rdl.TableCellType(m_fields.Count) {}
         Dim i As Integer
         For i = 0 To m_fields.Count - 1
            headerTableCells.TableCell(i) = CreateHeaderTableCell(m_fields(i))
         Next i
         Return headerTableCells
      End Function

      Private Function CreateHeaderTableCell(ByVal fieldName As String) As Rdl.TableCellType
         Dim headerTableCell As New Rdl.TableCellType()
         headerTableCell.Items = New Object() {CreateHeaderTableCellReportItems(fieldName)}
         Return headerTableCell
      End Function

      Private Function CreateHeaderTableCellReportItems(ByVal fieldName As String) As Rdl.ReportItemsType
         Dim headerTableCellReportItems As New Rdl.ReportItemsType()
         headerTableCellReportItems.Items = New Object() {CreateHeaderTableCellTextbox(fieldName)}
         Return headerTableCellReportItems
      End Function

      Private Function CreateHeaderTableCellTextbox(ByVal fieldName As String) As Rdl.TextboxType
         Dim headerTableCellTextbox As New Rdl.TextboxType()
         headerTableCellTextbox.Name = fieldName + "_Header"
         headerTableCellTextbox.Items = New Object() {fieldName, CreateHeaderTableCellTextboxStyle(), True}
         headerTableCellTextbox.ItemsElementName = New Rdl.ItemsChoiceType14() {Rdl.ItemsChoiceType14.Value, Rdl.ItemsChoiceType14.Style, Rdl.ItemsChoiceType14.CanGrow}
         Return headerTableCellTextbox
      End Function

      Private Function CreateHeaderTableCellTextboxStyle() As Rdl.StyleType
         Dim headerTableCellTextboxStyle As New Rdl.StyleType()
         headerTableCellTextboxStyle.Items = New Object() {"700", "12pt"}
         headerTableCellTextboxStyle.ItemsElementName = New Rdl.ItemsChoiceType5() {Rdl.ItemsChoiceType5.FontWeight, Rdl.ItemsChoiceType5.FontSize}
         Return headerTableCellTextboxStyle
      End Function

      Private Function CreateDetails() As Rdl.DetailsType
         Dim details As New Rdl.DetailsType()
         details.Items = New Object() {CreateTableRows()}
         Return details
      End Function

      Private Function CreateTableRows() As Rdl.TableRowsType
         Dim tableRows As New Rdl.TableRowsType()
         tableRows.TableRow = New Rdl.TableRowType() {CreateTableRow()}
         Return tableRows
      End Function

      Private Function CreateTableRow() As Rdl.TableRowType
         Dim tableRow As New Rdl.TableRowType()
         tableRow.Items = New Object() {CreateTableCells(), "0.25in"}
         Return tableRow
      End Function

      Private Function CreateTableCells() As Rdl.TableCellsType
         Dim tableCells As New Rdl.TableCellsType()
         tableCells.TableCell = New Rdl.TableCellType(m_fields.Count) {}
         Dim i As Integer
         For i = 0 To m_fields.Count - 1
            tableCells.TableCell(i) = CreateTableCell(m_fields(i))
         Next i
         Return tableCells
      End Function

      Private Function CreateTableCell(ByVal fieldName As String) As Rdl.TableCellType
         Dim tableCell As New Rdl.TableCellType()
         tableCell.Items = New Object() {CreateTableCellReportItems(fieldName)}
         Return tableCell
      End Function

      Private Function CreateTableCellReportItems(ByVal fieldName As String) As Rdl.ReportItemsType
         Dim reportItems As New Rdl.ReportItemsType()
         reportItems.Items = New Object() {CreateTableCellTextbox(fieldName)}
         Return reportItems
      End Function

      Private Function CreateTableCellTextbox(ByVal fieldName As String) As Rdl.TextboxType
         Dim textbox As New Rdl.TextboxType()
         textbox.Name = fieldName
         textbox.Items = New Object() {"=Fields!" + fieldName + ".Value", CreateTableCellTextboxStyle(), True}
         textbox.ItemsElementName = New Rdl.ItemsChoiceType14() {Rdl.ItemsChoiceType14.Value, Rdl.ItemsChoiceType14.Style, Rdl.ItemsChoiceType14.CanGrow}
         Return textbox
      End Function

      Private Function CreateTableCellTextboxStyle() As Rdl.StyleType
         Dim style As New Rdl.StyleType()
         style.Items = New Object() {"=iif(RowNumber(Nothing) mod 2, ""White"", ""White"")", "Left"}
         style.ItemsElementName = New Rdl.ItemsChoiceType5() {Rdl.ItemsChoiceType5.BackgroundColor, Rdl.ItemsChoiceType5.TextAlign}
         Return style
      End Function

      Private Function CreateTableColumns() As Rdl.TableColumnsType
         Dim tableColumns As New Rdl.TableColumnsType()
         tableColumns.TableColumn = New Rdl.TableColumnType(m_fields.Count) {}
         Dim i As Integer
         For i = 0 To m_fields.Count - 1
            tableColumns.TableColumn(i) = CreateTableColumn()
         Next i
         Return tableColumns
      End Function

      Private Function CreateTableColumn() As Rdl.TableColumnType
         Dim tableColumn As New Rdl.TableColumnType()
         tableColumn.Items = New Object() {"2in"}
         Return tableColumn
      End Function
   End Class
   Public Class RdlGenerator
      Private m_allFields As List(Of String)
      Private m_selectedFields As List(Of String)

      Public Property AllFields() As List(Of String)
         Get
            Return m_allFields
         End Get
         Set(ByVal value As List(Of String))
            m_allFields = value
         End Set
      End Property

      Public Property SelectedFields() As List(Of String)
         Get
            Return m_selectedFields
         End Get
         Set(ByVal value As List(Of String))
            m_selectedFields = value
         End Set
      End Property

      Private Function CreateReport() As Rdl.Report
         Dim report As New Rdl.Report()
         report.Items = New Object() {CreateDataSources(), CreateBody(), CreateDataSets(), "8.5in"}
         report.ItemsElementName = New Rdl.ItemsChoiceType37() {Rdl.ItemsChoiceType37.DataSources, Rdl.ItemsChoiceType37.Body, Rdl.ItemsChoiceType37.DataSets, Rdl.ItemsChoiceType37.Width}
         Return report
      End Function

      Private Function CreateDataSources() As Rdl.DataSourcesType
         Dim dataSources As New Rdl.DataSourcesType()
         dataSources.DataSource = New Rdl.DataSourceType() {CreateDataSource()}
         Return dataSources
      End Function

      Private Function CreateDataSource() As Rdl.DataSourceType
         Dim dataSource As New Rdl.DataSourceType()
         dataSource.Name = "DummyDataSource"
         dataSource.Items = New Object() {CreateConnectionProperties()}
         Return dataSource
      End Function

      Private Function CreateConnectionProperties() As Rdl.ConnectionPropertiesType
         Dim connectionProperties As New Rdl.ConnectionPropertiesType()
         connectionProperties.Items = New Object() {"", "SQL"}
         connectionProperties.ItemsElementName = New Rdl.ItemsChoiceType() {Rdl.ItemsChoiceType.ConnectString, Rdl.ItemsChoiceType.DataProvider}
         Return connectionProperties
      End Function

      Private Function CreateBody() As Rdl.BodyType
         Dim body As New Rdl.BodyType()
         body.Items = New Object() {CreateReportItems(), "1in"}
         body.ItemsElementName = New Rdl.ItemsChoiceType30() {Rdl.ItemsChoiceType30.ReportItems, Rdl.ItemsChoiceType30.Height}
         Return body
      End Function

      Private Function CreateReportItems() As Rdl.ReportItemsType
         Dim reportItems As New Rdl.ReportItemsType()
         Dim tableGen As New ssrsDynamicReport.TableRdlGenerator()
         tableGen.Fields = m_selectedFields
         reportItems.Items = New Object() {tableGen.CreateTable()}
         Return reportItems
      End Function

      Private Function CreateDataSets() As Rdl.DataSetsType
         Dim dataSets As New Rdl.DataSetsType()
         dataSets.DataSet = New Rdl.DataSetType() {CreateDataSet()}
         Return dataSets
      End Function

      Private Function CreateDataSet() As Rdl.DataSetType
         Dim dataSet As New Rdl.DataSetType()
         dataSet.Name = "MyData"
         dataSet.Items = New Object() {CreateQuery(), CreateFields()}
         Return dataSet
      End Function

      Private Function CreateQuery() As Rdl.QueryType
         Dim query As New Rdl.QueryType()
         query.Items = New Object() {"DummyDataSource", ""}
         query.ItemsElementName = New Rdl.ItemsChoiceType2() {Rdl.ItemsChoiceType2.DataSourceName, Rdl.ItemsChoiceType2.CommandText}
         Return query
      End Function

      Private Function CreateFields() As Rdl.FieldsType
         Dim fields As New Rdl.FieldsType()
         fields.Field = New Rdl.FieldType(m_allFields.Count) {}
         Dim i As Integer
         For i = 0 To m_allFields.Count - 1
            fields.Field(i) = CreateField(m_allFields(i))
         Next i
         Return fields
      End Function

      Private Function CreateField(ByVal fieldName As String) As Rdl.FieldType
         Dim field As New Rdl.FieldType()
         field.Name = fieldName
         field.Items = New Object() {fieldName}
         field.ItemsElementName = New Rdl.ItemsChoiceType1() {Rdl.ItemsChoiceType1.DataField}
         Return field
      End Function

      Public Sub WriteXml(ByVal stream As Stream)
         Dim serializer As New XmlSerializer(GetType(Rdl.Report))
         serializer.Serialize(stream, CreateReport())
      End Sub
   End Class
   Namespace Rdl

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute(AnonymousType:=True), System.Xml.Serialization.XmlRootAttribute(Namespace:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition", IsNullable:=False)> _
      Public Class Report

         Private itemsField() As Object
         Private itemsElementNameField() As ItemsChoiceType37
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("Author", GetType(String)), System.Xml.Serialization.XmlElementAttribute("AutoRefresh", GetType(System.UInt32)), System.Xml.Serialization.XmlElementAttribute("Body", GetType(BodyType)), System.Xml.Serialization.XmlElementAttribute("BottomMargin", GetType(String), DataType:="normalizedString"), System.Xml.Serialization.XmlElementAttribute("Classes", GetType(ClassesType)), System.Xml.Serialization.XmlElementAttribute("Code", GetType(String)), System.Xml.Serialization.XmlElementAttribute("CodeModules", GetType(CodeModulesType)), System.Xml.Serialization.XmlElementAttribute("CustomProperties", GetType(CustomPropertiesType)), System.Xml.Serialization.XmlElementAttribute("DataElementName", GetType(String)), System.Xml.Serialization.XmlElementAttribute("DataElementStyle", GetType(ReportDataElementStyle)), System.Xml.Serialization.XmlElementAttribute("DataSchema", GetType(String)), System.Xml.Serialization.XmlElementAttribute("DataSets", GetType(DataSetsType)), System.Xml.Serialization.XmlElementAttribute("DataSources", GetType(DataSourcesType)), System.Xml.Serialization.XmlElementAttribute("DataTransform", GetType(String)), System.Xml.Serialization.XmlElementAttribute("Description", GetType(String)), System.Xml.Serialization.XmlElementAttribute("EmbeddedImages", GetType(EmbeddedImagesType)), System.Xml.Serialization.XmlElementAttribute("InteractiveHeight", GetType(String), DataType:="normalizedString"), System.Xml.Serialization.XmlElementAttribute("InteractiveWidth", GetType(String), DataType:="normalizedString"), System.Xml.Serialization.XmlElementAttribute("Language", GetType(String)), System.Xml.Serialization.XmlElementAttribute("LeftMargin", GetType(String), DataType:="normalizedString"), System.Xml.Serialization.XmlElementAttribute("PageFooter", GetType(PageHeaderFooterType)), System.Xml.Serialization.XmlElementAttribute("PageHeader", GetType(PageHeaderFooterType)), System.Xml.Serialization.XmlElementAttribute("PageHeight", GetType(String), DataType:="normalizedString"), System.Xml.Serialization.XmlElementAttribute("PageWidth", GetType(String), DataType:="normalizedString"), System.Xml.Serialization.XmlElementAttribute("ReportParameters", GetType(ReportParametersType)), System.Xml.Serialization.XmlElementAttribute("RightMargin", GetType(String), DataType:="normalizedString"), System.Xml.Serialization.XmlElementAttribute("TopMargin", GetType(String), DataType:="normalizedString"), System.Xml.Serialization.XmlElementAttribute("Width", GetType(String), DataType:="normalizedString"), System.Xml.Serialization.XmlChoiceIdentifierAttribute("ItemsElementName")> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlElementAttribute("ItemsElementName"), System.Xml.Serialization.XmlIgnoreAttribute()> _
         Public Property ItemsElementName() As ItemsChoiceType37()
            Get
               Return Me.itemsElementNameField
            End Get
            Set(ByVal value As ItemsChoiceType37())
               Me.itemsElementNameField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property

      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute(Namespace:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
      Public Class BodyType

         Private itemsField() As Object
         Private itemsElementNameField() As ItemsChoiceType30
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("ColumnSpacing", GetType(String), DataType:="normalizedString"), System.Xml.Serialization.XmlElementAttribute("Columns", GetType(System.UInt32)), System.Xml.Serialization.XmlElementAttribute("Height", GetType(String), DataType:="normalizedString"), System.Xml.Serialization.XmlElementAttribute("ReportItems", GetType(ReportItemsType)), System.Xml.Serialization.XmlElementAttribute("Style", GetType(StyleType)), System.Xml.Serialization.XmlChoiceIdentifierAttribute("ItemsElementName")> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlElementAttribute("ItemsElementName"), System.Xml.Serialization.XmlIgnoreAttribute()> _
         Public Property ItemsElementName() As ItemsChoiceType30()
            Get
               Return Me.itemsElementNameField
            End Get
            Set(ByVal value As ItemsChoiceType30())
               Me.itemsElementNameField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute(Namespace:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
      Public Class ReportItemsType

         Private itemsField() As Object
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("Chart", GetType(ChartType)), System.Xml.Serialization.XmlElementAttribute("CustomReportItem", GetType(CustomReportItemType)), System.Xml.Serialization.XmlElementAttribute("Image", GetType(ImageType)), System.Xml.Serialization.XmlElementAttribute("Line", GetType(LineType)), System.Xml.Serialization.XmlElementAttribute("List", GetType(ListType)), System.Xml.Serialization.XmlElementAttribute("Matrix", GetType(MatrixType)), System.Xml.Serialization.XmlElementAttribute("Rectangle", GetType(RectangleType)), System.Xml.Serialization.XmlElementAttribute("Subreport", GetType(SubreportType)), System.Xml.Serialization.XmlElementAttribute("Table", GetType(TableType)), System.Xml.Serialization.XmlElementAttribute("Textbox", GetType(TextboxType))> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute(Namespace:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
      Public Class ChartType

         Private itemsField() As Object
         Private itemsElementNameField() As ItemsChoiceType27
         Private nameField As String
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("Action", GetType(ActionType)), System.Xml.Serialization.XmlElementAttribute("Bookmark", GetType(String)), System.Xml.Serialization.XmlElementAttribute("CategoryAxis", GetType(CategoryAxisType)), System.Xml.Serialization.XmlElementAttribute("CategoryGroupings", GetType(CategoryGroupingsType)), System.Xml.Serialization.XmlElementAttribute("ChartData", GetType(ChartDataType)), System.Xml.Serialization.XmlElementAttribute("ChartElementOutput", GetType(ChartTypeChartElementOutput)), System.Xml.Serialization.XmlElementAttribute("CustomProperties", GetType(CustomPropertiesType)), System.Xml.Serialization.XmlElementAttribute("DataElementName", GetType(String)), System.Xml.Serialization.XmlElementAttribute("DataElementOutput", GetType(ChartTypeDataElementOutput)), System.Xml.Serialization.XmlElementAttribute("DataSetName", GetType(String)), System.Xml.Serialization.XmlElementAttribute("Filters", GetType(FiltersType)), System.Xml.Serialization.XmlElementAttribute("Height", GetType(String), DataType:="normalizedString"), System.Xml.Serialization.XmlElementAttribute("KeepTogether", GetType(Boolean)), System.Xml.Serialization.XmlElementAttribute("Label", GetType(String)), System.Xml.Serialization.XmlElementAttribute("Left", GetType(String), DataType:="normalizedString"), System.Xml.Serialization.XmlElementAttribute("Legend", GetType(LegendType)), System.Xml.Serialization.XmlElementAttribute("LinkToChild", GetType(String)), System.Xml.Serialization.XmlElementAttribute("NoRows", GetType(String)), System.Xml.Serialization.XmlElementAttribute("PageBreakAtEnd", GetType(Boolean)), System.Xml.Serialization.XmlElementAttribute("PageBreakAtStart", GetType(Boolean)), System.Xml.Serialization.XmlElementAttribute("Palette", GetType(ChartTypePalette)), System.Xml.Serialization.XmlElementAttribute("PlotArea", GetType(PlotAreaType)), System.Xml.Serialization.XmlElementAttribute("PointWidth", GetType(System.UInt32)), System.Xml.Serialization.XmlElementAttribute("SeriesGroupings", GetType(SeriesGroupingsType)), System.Xml.Serialization.XmlElementAttribute("Style", GetType(StyleType)), System.Xml.Serialization.XmlElementAttribute("Subtype", GetType(ChartTypeSubtype)), System.Xml.Serialization.XmlElementAttribute("ThreeDProperties", GetType(ThreeDPropertiesType)), System.Xml.Serialization.XmlElementAttribute("Title", GetType(TitleType)), System.Xml.Serialization.XmlElementAttribute("ToolTip", GetType(String)), System.Xml.Serialization.XmlElementAttribute("Top", GetType(String), DataType:="normalizedString"), System.Xml.Serialization.XmlElementAttribute("Type", GetType(ChartTypeType)), System.Xml.Serialization.XmlElementAttribute("ValueAxis", GetType(ValueAxisType)), System.Xml.Serialization.XmlElementAttribute("Visibility", GetType(VisibilityType)), System.Xml.Serialization.XmlElementAttribute("Width", GetType(String), DataType:="normalizedString"), System.Xml.Serialization.XmlElementAttribute("ZIndex", GetType(System.UInt32)), System.Xml.Serialization.XmlChoiceIdentifierAttribute("ItemsElementName")> _
              Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlElementAttribute("ItemsElementName"), System.Xml.Serialization.XmlIgnoreAttribute()> _
         Public Property ItemsElementName() As ItemsChoiceType27()
            Get
               Return Me.itemsElementNameField
            End Get
            Set(ByVal value As ItemsChoiceType27())
               Me.itemsElementNameField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAttributeAttribute(DataType:="normalizedString")> _
         Public Property Name() As String
            Get
               Return Me.nameField
            End Get
            Set(ByVal value As String)
               Me.nameField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute(Namespace:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
      Public Class ActionType

         Private itemsField() As Object
         Private itemsElementNameField() As ItemsChoiceType8
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("BookmarkLink", GetType(String)), System.Xml.Serialization.XmlElementAttribute("Drillthrough", GetType(DrillthroughType)), System.Xml.Serialization.XmlElementAttribute("Hyperlink", GetType(String)), System.Xml.Serialization.XmlElementAttribute("Label", GetType(String)), System.Xml.Serialization.XmlChoiceIdentifierAttribute("ItemsElementName")> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlElementAttribute("ItemsElementName"), System.Xml.Serialization.XmlIgnoreAttribute()> _
         Public Property ItemsElementName() As ItemsChoiceType8()
            Get
               Return Me.itemsElementNameField
            End Get
            Set(ByVal value As ItemsChoiceType8())
               Me.itemsElementNameField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute(Namespace:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
      Public Class DrillthroughType

         Private itemsField() As Object
         Private itemsElementNameField() As ItemsChoiceType7
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("BookmarkLink", GetType(String)), System.Xml.Serialization.XmlElementAttribute("Parameters", GetType(ParametersType)), System.Xml.Serialization.XmlElementAttribute("ReportName", GetType(String)), System.Xml.Serialization.XmlChoiceIdentifierAttribute("ItemsElementName")> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlElementAttribute("ItemsElementName"), System.Xml.Serialization.XmlIgnoreAttribute()> _
         Public Property ItemsElementName() As ItemsChoiceType7()
            Get
               Return Me.itemsElementNameField
            End Get
            Set(ByVal value As ItemsChoiceType7())
               Me.itemsElementNameField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      Public Class ParametersType

         Private parameterField() As ParameterType
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlElementAttribute("Parameter")> _
         Public Property Parameter() As ParameterType()
            Get
               Return Me.parameterField
            End Get
            Set(ByVal value As ParameterType())
               Me.parameterField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      Public Class ParameterType

         Private itemsField() As Object
         Private itemsElementNameField() As ItemsChoiceType6
         Private nameField As String
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("Omit", GetType(String)), System.Xml.Serialization.XmlElementAttribute("Value", GetType(String)), System.Xml.Serialization.XmlChoiceIdentifierAttribute("ItemsElementName")> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlElementAttribute("ItemsElementName"), System.Xml.Serialization.XmlIgnoreAttribute()> _
         Public Property ItemsElementName() As ItemsChoiceType6()
            Get
               Return Me.itemsElementNameField
            End Get
            Set(ByVal value As ItemsChoiceType6())
               Me.itemsElementNameField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAttributeAttribute()> _
         Public Property Name() As String
            Get
               Return Me.nameField
            End Get
            Set(ByVal value As String)
               Me.nameField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition", IncludeInSchema:=False)> _
      Public Enum ItemsChoiceType6
         <System.Xml.Serialization.XmlEnumAttribute("##any:")> Item
         Omit
         Value
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class ClassType

         Private itemsField() As Object
         Private itemsElementNameField() As ItemsChoiceType36
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("ClassName", GetType(String)), System.Xml.Serialization.XmlElementAttribute("InstanceName", GetType(String), DataType:="normalizedString"), System.Xml.Serialization.XmlChoiceIdentifierAttribute("ItemsElementName")> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlElementAttribute("ItemsElementName"), System.Xml.Serialization.XmlIgnoreAttribute()> _
         Public Property ItemsElementName() As ItemsChoiceType36()
            Get
               Return Me.itemsElementNameField
            End Get
            Set(ByVal value As ItemsChoiceType36())
               Me.itemsElementNameField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition", IncludeInSchema:=False)> _
      Public Enum ItemsChoiceType36
         <System.Xml.Serialization.XmlEnumAttribute("##any:")> Item
         ClassName
         InstanceName
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class ClassesType

         Private classField() As ClassType
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlElementAttribute("Class")> _
         Public Property [Class]() As ClassType()
            Get
               Return Me.classField
            End Get
            Set(ByVal value As ClassType())
               Me.classField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class CodeModulesType

         Private codeModuleField() As String
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlElementAttribute("CodeModule")> _
         Public Property CodeModule() As String()
            Get
               Return Me.codeModuleField
            End Get
            Set(ByVal value As String())
               Me.codeModuleField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class EmbeddedImageType

         Private itemsField() As Object
         Private itemsElementNameField() As ItemsChoiceType35
         Private nameField As String
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("ImageData", GetType(String)), System.Xml.Serialization.XmlElementAttribute("MIMEType", GetType(String)), System.Xml.Serialization.XmlChoiceIdentifierAttribute("ItemsElementName")> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlElementAttribute("ItemsElementName"), System.Xml.Serialization.XmlIgnoreAttribute()> _
         Public Property ItemsElementName() As ItemsChoiceType35()
            Get
               Return Me.itemsElementNameField
            End Get
            Set(ByVal value As ItemsChoiceType35())
               Me.itemsElementNameField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAttributeAttribute(DataType:="normalizedString")> _
         Public Property Name() As String
            Get
               Return Me.nameField
            End Get
            Set(ByVal value As String)
               Me.nameField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition", IncludeInSchema:=False)> _
      Public Enum ItemsChoiceType35
         <System.Xml.Serialization.XmlEnumAttribute("##any:")> Item
         ImageData
         MIMEType
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class EmbeddedImagesType

         Private embeddedImageField() As EmbeddedImageType
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlElementAttribute("EmbeddedImage")> _
         Public Property EmbeddedImage() As EmbeddedImageType()
            Get
               Return Me.embeddedImageField
            End Get
            Set(ByVal value As EmbeddedImageType())
               Me.embeddedImageField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class PageHeaderFooterType

         Private itemsField() As Object
         Private itemsElementNameField() As ItemsChoiceType34
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("Height", GetType(String), DataType:="normalizedString"), System.Xml.Serialization.XmlElementAttribute("PrintOnFirstPage", GetType(Boolean)), System.Xml.Serialization.XmlElementAttribute("PrintOnLastPage", GetType(Boolean)), System.Xml.Serialization.XmlElementAttribute("ReportItems", GetType(ReportItemsType)), System.Xml.Serialization.XmlElementAttribute("Style", GetType(StyleType)), System.Xml.Serialization.XmlChoiceIdentifierAttribute("ItemsElementName")> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlElementAttribute("ItemsElementName"), System.Xml.Serialization.XmlIgnoreAttribute()> _
         Public Property ItemsElementName() As ItemsChoiceType34()
            Get
               Return Me.itemsElementNameField
            End Get
            Set(ByVal value As ItemsChoiceType34())
               Me.itemsElementNameField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class StyleType

         Private itemsField() As Object
         Private itemsElementNameField() As ItemsChoiceType5
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("BackgroundColor", GetType(String)), System.Xml.Serialization.XmlElementAttribute("BackgroundGradientEndColor", GetType(String)), System.Xml.Serialization.XmlElementAttribute("BackgroundGradientType", GetType(String)), System.Xml.Serialization.XmlElementAttribute("BackgroundImage", GetType(BackgroundImageType)), System.Xml.Serialization.XmlElementAttribute("BorderColor", GetType(BorderColorStyleWidthType)), System.Xml.Serialization.XmlElementAttribute("BorderStyle", GetType(BorderColorStyleWidthType)), System.Xml.Serialization.XmlElementAttribute("BorderWidth", GetType(BorderColorStyleWidthType)), System.Xml.Serialization.XmlElementAttribute("Calendar", GetType(String)), System.Xml.Serialization.XmlElementAttribute("Color", GetType(String)), System.Xml.Serialization.XmlElementAttribute("Direction", GetType(String)), System.Xml.Serialization.XmlElementAttribute("FontFamily", GetType(String)), System.Xml.Serialization.XmlElementAttribute("FontSize", GetType(String)), System.Xml.Serialization.XmlElementAttribute("FontStyle", GetType(String)), System.Xml.Serialization.XmlElementAttribute("FontWeight", GetType(String)), System.Xml.Serialization.XmlElementAttribute("Format", GetType(String)), System.Xml.Serialization.XmlElementAttribute("Language", GetType(String)), System.Xml.Serialization.XmlElementAttribute("LineHeight", GetType(String)), System.Xml.Serialization.XmlElementAttribute("NumeralLanguage", GetType(String)), System.Xml.Serialization.XmlElementAttribute("NumeralVariant", GetType(String)), System.Xml.Serialization.XmlElementAttribute("PaddingBottom", GetType(String)), System.Xml.Serialization.XmlElementAttribute("PaddingLeft", GetType(String)), System.Xml.Serialization.XmlElementAttribute("PaddingRight", GetType(String)), System.Xml.Serialization.XmlElementAttribute("PaddingTop", GetType(String)), System.Xml.Serialization.XmlElementAttribute("TextAlign", GetType(String)), System.Xml.Serialization.XmlElementAttribute("TextDecoration", GetType(String)), System.Xml.Serialization.XmlElementAttribute("UnicodeBiDi", GetType(String)), System.Xml.Serialization.XmlElementAttribute("VerticalAlign", GetType(String)), System.Xml.Serialization.XmlElementAttribute("WritingMode", GetType(String)), System.Xml.Serialization.XmlChoiceIdentifierAttribute("ItemsElementName")> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlElementAttribute("ItemsElementName"), System.Xml.Serialization.XmlIgnoreAttribute()> _
         Public Property ItemsElementName() As ItemsChoiceType5()
            Get
               Return Me.itemsElementNameField
            End Get
            Set(ByVal value As ItemsChoiceType5())
               Me.itemsElementNameField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class BackgroundImageType

         Private itemsField() As Object
         Private itemsElementNameField() As ItemsChoiceType4
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("BackgroundRepeat", GetType(String)), System.Xml.Serialization.XmlElementAttribute("MIMEType", GetType(String)), System.Xml.Serialization.XmlElementAttribute("Source", GetType(BackgroundImageTypeSource)), System.Xml.Serialization.XmlElementAttribute("Value", GetType(String)), System.Xml.Serialization.XmlChoiceIdentifierAttribute("ItemsElementName")> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlElementAttribute("ItemsElementName"), System.Xml.Serialization.XmlIgnoreAttribute()> _
         Public Property ItemsElementName() As ItemsChoiceType4()
            Get
               Return Me.itemsElementNameField
            End Get
            Set(ByVal value As ItemsChoiceType4())
               Me.itemsElementNameField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute(AnonymousType:=True)> _
      Public Enum BackgroundImageTypeSource
         [External]
         Embedded
         Database
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition", IncludeInSchema:=False)> _
      Public Enum ItemsChoiceType4
         <System.Xml.Serialization.XmlEnumAttribute("##any:")> Item
         BackgroundRepeat
         MIMEType
         Source
         Value
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class BorderColorStyleWidthType

         Private itemsField() As Object
         Private itemsElementNameField() As ItemsChoiceType3
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("Bottom", GetType(String)), System.Xml.Serialization.XmlElementAttribute("Default", GetType(String)), System.Xml.Serialization.XmlElementAttribute("Left", GetType(String)), System.Xml.Serialization.XmlElementAttribute("Right", GetType(String)), System.Xml.Serialization.XmlElementAttribute("Top", GetType(String)), System.Xml.Serialization.XmlChoiceIdentifierAttribute("ItemsElementName")> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlElementAttribute("ItemsElementName"), System.Xml.Serialization.XmlIgnoreAttribute()> _
         Public Property ItemsElementName() As ItemsChoiceType3()
            Get
               Return Me.itemsElementNameField
            End Get
            Set(ByVal value As ItemsChoiceType3())
               Me.itemsElementNameField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition", IncludeInSchema:=False)> _
      Public Enum ItemsChoiceType3
         <System.Xml.Serialization.XmlEnumAttribute("##any:")> Item
         Bottom
         [Default]
         Left
         Right
         Top
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition", IncludeInSchema:=False)> _
      Public Enum ItemsChoiceType5
         <System.Xml.Serialization.XmlEnumAttribute("##any:")> Item
         BackgroundColor
         BackgroundGradientEndColor
         BackgroundGradientType
         BackgroundImage
         BorderColor
         BorderStyle
         BorderWidth
         Calendar
         Color
         Direction
         FontFamily
         FontSize
         FontStyle
         FontWeight
         Format
         Language
         LineHeight
         NumeralLanguage
         NumeralVariant
         PaddingBottom
         PaddingLeft
         PaddingRight
         PaddingTop
         TextAlign
         TextDecoration
         UnicodeBiDi
         VerticalAlign
         WritingMode
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition", IncludeInSchema:=False)> _
      Public Enum ItemsChoiceType34
         <System.Xml.Serialization.XmlEnumAttribute("##any:")> Item
         Height
         PrintOnFirstPage
         PrintOnLastPage
         ReportItems
         Style
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class ParameterValueType

         Private itemsField() As Object
         Private itemsElementNameField() As ItemsChoiceType32
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("Label", GetType(String)), System.Xml.Serialization.XmlElementAttribute("Value", GetType(String)), System.Xml.Serialization.XmlChoiceIdentifierAttribute("ItemsElementName")> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlElementAttribute("ItemsElementName"), System.Xml.Serialization.XmlIgnoreAttribute()> _
         Public Property ItemsElementName() As ItemsChoiceType32()
            Get
               Return Me.itemsElementNameField
            End Get
            Set(ByVal value As ItemsChoiceType32())
               Me.itemsElementNameField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition", IncludeInSchema:=False)> _
      Public Enum ItemsChoiceType32
         <System.Xml.Serialization.XmlEnumAttribute("##any:")> Item
         Label
         Value
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class ParameterValuesType

         Private parameterValueField() As ParameterValueType
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlElementAttribute("ParameterValue")> _
         Public Property ParameterValue() As ParameterValueType()
            Get
               Return Me.parameterValueField
            End Get
            Set(ByVal value As ParameterValueType())
               Me.parameterValueField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class ValidValuesType

         Private itemsField() As Object
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("DataSetReference", GetType(DataSetReferenceType)), System.Xml.Serialization.XmlElementAttribute("ParameterValues", GetType(ParameterValuesType))> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class DataSetReferenceType

         Private itemsField() As Object
         Private itemsElementNameField() As ItemsChoiceType31
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("DataSetName", GetType(String)), System.Xml.Serialization.XmlElementAttribute("LabelField", GetType(String)), System.Xml.Serialization.XmlElementAttribute("ValueField", GetType(String)), System.Xml.Serialization.XmlChoiceIdentifierAttribute("ItemsElementName")> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlElementAttribute("ItemsElementName"), System.Xml.Serialization.XmlIgnoreAttribute()> _
         Public Property ItemsElementName() As ItemsChoiceType31()
            Get
               Return Me.itemsElementNameField
            End Get
            Set(ByVal value As ItemsChoiceType31())
               Me.itemsElementNameField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition", IncludeInSchema:=False)> _
      Public Enum ItemsChoiceType31
         <System.Xml.Serialization.XmlEnumAttribute("##any:")> Item
         DataSetName
         LabelField
         ValueField
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class ValuesType

         Private valueField() As String
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlElementAttribute("Value")> _
         Public Property Value() As String()
            Get
               Return Me.valueField
            End Get
            Set(ByVal value As String())
               Me.valueField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class DefaultValueType

         Private itemsField() As Object
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("DataSetReference", GetType(DataSetReferenceType)), System.Xml.Serialization.XmlElementAttribute("Values", GetType(ValuesType))> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class ReportParameterType

         Private itemsField() As Object
         Private itemsElementNameField() As ItemsChoiceType33
         Private nameField As String
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("AllowBlank", GetType(Boolean)), System.Xml.Serialization.XmlElementAttribute("DataType", GetType(ReportParameterTypeDataType)), System.Xml.Serialization.XmlElementAttribute("DefaultValue", GetType(DefaultValueType)), System.Xml.Serialization.XmlElementAttribute("Hidden", GetType(Boolean)), System.Xml.Serialization.XmlElementAttribute("MultiValue", GetType(Boolean)), System.Xml.Serialization.XmlElementAttribute("Nullable", GetType(Boolean)), System.Xml.Serialization.XmlElementAttribute("Prompt", GetType(String)), System.Xml.Serialization.XmlElementAttribute("UsedInQuery", GetType(ReportParameterTypeUsedInQuery)), System.Xml.Serialization.XmlElementAttribute("ValidValues", GetType(ValidValuesType)), System.Xml.Serialization.XmlChoiceIdentifierAttribute("ItemsElementName")> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlElementAttribute("ItemsElementName"), System.Xml.Serialization.XmlIgnoreAttribute()> _
         Public Property ItemsElementName() As ItemsChoiceType33()
            Get
               Return Me.itemsElementNameField
            End Get
            Set(ByVal value As ItemsChoiceType33())
               Me.itemsElementNameField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAttributeAttribute(DataType:="normalizedString")> _
         Public Property Name() As String
            Get
               Return Me.nameField
            End Get
            Set(ByVal value As String)
               Me.nameField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute(AnonymousType:=True)> _
      Public Enum ReportParameterTypeDataType
         [Boolean]
         DateTime
         [Integer]
         Float
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute(AnonymousType:=True)> _
      Public Enum ReportParameterTypeUsedInQuery
         [False]
         [True]
         [Auto]
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition", IncludeInSchema:=False)> _
      Public Enum ItemsChoiceType33
         <System.Xml.Serialization.XmlEnumAttribute("##any:")> Item
         AllowBlank
         DataType
         DefaultValue
         Hidden
         MultiValue
         Nullable
         Prompt
         UsedInQuery
         ValidValues
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class ReportParametersType

         Private reportParameterField() As ReportParameterType
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlElementAttribute("ReportParameter")> _
         Public Property ReportParameter() As ReportParameterType()
            Get
               Return Me.reportParameterField
            End Get
            Set(ByVal value As ReportParameterType())
               Me.reportParameterField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class DataCellType

         Private dataValueField() As DataValueType
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlElementAttribute("DataValue")> _
         Public Property DataValue() As DataValueType()
            Get
               Return Me.dataValueField
            End Get
            Set(ByVal value As DataValueType())
               Me.dataValueField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class DataValueType

         Private itemsField() As Object
         Private itemsElementNameField() As ItemsChoiceType22
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("Name", GetType(String)), System.Xml.Serialization.XmlElementAttribute("Value", GetType(String)), System.Xml.Serialization.XmlChoiceIdentifierAttribute("ItemsElementName")> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlElementAttribute("ItemsElementName"), System.Xml.Serialization.XmlIgnoreAttribute()> _
         Public Property ItemsElementName() As ItemsChoiceType22()
            Get
               Return Me.itemsElementNameField
            End Get
            Set(ByVal value As ItemsChoiceType22())
               Me.itemsElementNameField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition", IncludeInSchema:=False)> _
      Public Enum ItemsChoiceType22
         <System.Xml.Serialization.XmlEnumAttribute("##any:")> Item
         Name
         Value
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class DataRowType

         Private dataCellField() As DataCellType
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlElementAttribute("DataCell")> _
         Public Property DataCell() As DataCellType()
            Get
               Return Me.dataCellField
            End Get
            Set(ByVal value As DataCellType())
               Me.dataCellField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class DataRowsType

         Private dataRowField() As DataRowType
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlElementAttribute("DataRow")> _
         Public Property DataRow() As DataRowType()
            Get
               Return Me.dataRowField
            End Get
            Set(ByVal value As DataRowType())
               Me.dataRowField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class DataRowGroupingsType

         Private itemsField() As Object
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("DataGroupings", GetType(DataGroupingsType))> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class DataGroupingsType

         Private dataGroupingField() As DataGroupingType
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlElementAttribute("DataGrouping")> _
         Public Property DataGrouping() As DataGroupingType()
            Get
               Return Me.dataGroupingField
            End Get
            Set(ByVal value As DataGroupingType())
               Me.dataGroupingField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class DataGroupingType

         Private itemsField() As Object
         Private itemsElementNameField() As ItemsChoiceType28
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("CustomProperties", GetType(CustomPropertiesType)), System.Xml.Serialization.XmlElementAttribute("DataGroupings", GetType(DataGroupingsType)), System.Xml.Serialization.XmlElementAttribute("Grouping", GetType(GroupingType)), System.Xml.Serialization.XmlElementAttribute("Sorting", GetType(SortingType)), System.Xml.Serialization.XmlElementAttribute("Static", GetType(Boolean)), System.Xml.Serialization.XmlElementAttribute("Subtotal", GetType(Boolean)), System.Xml.Serialization.XmlChoiceIdentifierAttribute("ItemsElementName")> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlElementAttribute("ItemsElementName"), System.Xml.Serialization.XmlIgnoreAttribute()> _
         Public Property ItemsElementName() As ItemsChoiceType28()
            Get
               Return Me.itemsElementNameField
            End Get
            Set(ByVal value As ItemsChoiceType28())
               Me.itemsElementNameField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class CustomPropertiesType

         Private customPropertyField() As CustomPropertyType
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlElementAttribute("CustomProperty")> _
         Public Property CustomProperty() As CustomPropertyType()
            Get
               Return Me.customPropertyField
            End Get
            Set(ByVal value As CustomPropertyType())
               Me.customPropertyField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class CustomPropertyType

         Private itemsField() As Object
         Private itemsElementNameField() As ItemsChoiceType10
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("Name", GetType(String)), System.Xml.Serialization.XmlElementAttribute("Value", GetType(String)), System.Xml.Serialization.XmlChoiceIdentifierAttribute("ItemsElementName")> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlElementAttribute("ItemsElementName"), System.Xml.Serialization.XmlIgnoreAttribute()> _
         Public Property ItemsElementName() As ItemsChoiceType10()
            Get
               Return Me.itemsElementNameField
            End Get
            Set(ByVal value As ItemsChoiceType10())
               Me.itemsElementNameField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition", IncludeInSchema:=False)> _
      Public Enum ItemsChoiceType10
         <System.Xml.Serialization.XmlEnumAttribute("##any:")> Item
         Name
         Value
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class GroupingType

         Private itemsField() As Object
         Private itemsElementNameField() As ItemsChoiceType17
         Private nameField As String
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("CustomProperties", GetType(CustomPropertiesType)), System.Xml.Serialization.XmlElementAttribute("DataCollectionName", GetType(String)), System.Xml.Serialization.XmlElementAttribute("DataElementName", GetType(String)), System.Xml.Serialization.XmlElementAttribute("DataElementOutput", GetType(GroupingTypeDataElementOutput)), System.Xml.Serialization.XmlElementAttribute("Filters", GetType(FiltersType)), System.Xml.Serialization.XmlElementAttribute("GroupExpressions", GetType(GroupExpressionsType)), System.Xml.Serialization.XmlElementAttribute("Label", GetType(String)), System.Xml.Serialization.XmlElementAttribute("PageBreakAtEnd", GetType(Boolean)), System.Xml.Serialization.XmlElementAttribute("PageBreakAtStart", GetType(Boolean)), System.Xml.Serialization.XmlElementAttribute("Parent", GetType(String)), System.Xml.Serialization.XmlChoiceIdentifierAttribute("ItemsElementName")> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlElementAttribute("ItemsElementName"), System.Xml.Serialization.XmlIgnoreAttribute()> _
         Public Property ItemsElementName() As ItemsChoiceType17()
            Get
               Return Me.itemsElementNameField
            End Get
            Set(ByVal value As ItemsChoiceType17())
               Me.itemsElementNameField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAttributeAttribute(DataType:="normalizedString")> _
         Public Property Name() As String
            Get
               Return Me.nameField
            End Get
            Set(ByVal value As String)
               Me.nameField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute(AnonymousType:=True)> _
      Public Enum GroupingTypeDataElementOutput
         Output
         NoOutput
         ContentsOnly
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class FiltersType

         Private filterField() As FilterType
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlElementAttribute("Filter")> _
         Public Property Filter() As FilterType()
            Get
               Return Me.filterField
            End Get
            Set(ByVal value As FilterType())
               Me.filterField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class FilterType

         Private itemsField() As Object
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("FilterExpression", GetType(String)), System.Xml.Serialization.XmlElementAttribute("FilterValues", GetType(FilterValuesType)), System.Xml.Serialization.XmlElementAttribute("Operator", GetType(FilterTypeOperator))> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class FilterValuesType

         Private filterValueField() As String
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlElementAttribute("FilterValue")> _
         Public Property FilterValue() As String()
            Get
               Return Me.filterValueField
            End Get
            Set(ByVal value As String())
               Me.filterValueField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute(AnonymousType:=True)> _
      Public Enum FilterTypeOperator
         Equal
         [Like]
         NotEqual
         GreaterThan
         GreaterThanOrEqual
         LessThan
         LessThanOrEqual
         TopN
         BottomN
         TopPercent
         BottomPercent
         [In]
         Between
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class GroupExpressionsType

         Private groupExpressionField() As String
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlElementAttribute("GroupExpression")> _
         Public Property GroupExpression() As String()
            Get
               Return Me.groupExpressionField
            End Get
            Set(ByVal value As String())
               Me.groupExpressionField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition", IncludeInSchema:=False)> _
      Public Enum ItemsChoiceType17
         <System.Xml.Serialization.XmlEnumAttribute("##any:")> Item
         CustomProperties
         DataCollectionName
         DataElementName
         DataElementOutput
         Filters
         GroupExpressions
         Label
         PageBreakAtEnd
         PageBreakAtStart
         Parent
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class SortingType

         Private sortByField() As SortByType
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlElementAttribute("SortBy")> _
         Public Property SortBy() As SortByType()
            Get
               Return Me.sortByField
            End Get
            Set(ByVal value As SortByType())
               Me.sortByField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class SortByType

         Private itemsField() As Object
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("Direction", GetType(SortByTypeDirection)), System.Xml.Serialization.XmlElementAttribute("SortExpression", GetType(String))> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute(AnonymousType:=True)> _
      Public Enum SortByTypeDirection
         Ascending
         Descending
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition", IncludeInSchema:=False)> _
      Public Enum ItemsChoiceType28
         <System.Xml.Serialization.XmlEnumAttribute("##any:")> Item
         CustomProperties
         DataGroupings
         Grouping
         Sorting
         [Static]
         Subtotal
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class DataColumnGroupingsType

         Private itemsField() As Object
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("DataGroupings", GetType(DataGroupingsType))> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class CustomDataType

         Private itemsField() As Object
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("DataColumnGroupings", GetType(DataColumnGroupingsType)), System.Xml.Serialization.XmlElementAttribute("DataRowGroupings", GetType(DataRowGroupingsType)), System.Xml.Serialization.XmlElementAttribute("DataRows", GetType(DataRowsType)), System.Xml.Serialization.XmlElementAttribute("DataSetName", GetType(String)), System.Xml.Serialization.XmlElementAttribute("Filters", GetType(FiltersType))> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class CustomReportItemType

         Private itemsField() As Object
         Private itemsElementNameField() As ItemsChoiceType29
         Private nameField As String
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("AltReportItem", GetType(ReportItemsType)), System.Xml.Serialization.XmlElementAttribute("Bookmark", GetType(String)), System.Xml.Serialization.XmlElementAttribute("CustomData", GetType(CustomDataType)), System.Xml.Serialization.XmlElementAttribute("CustomProperties", GetType(CustomPropertiesType)), System.Xml.Serialization.XmlElementAttribute("DataElementName", GetType(String)), System.Xml.Serialization.XmlElementAttribute("DataElementOutput", GetType(CustomReportItemTypeDataElementOutput)), System.Xml.Serialization.XmlElementAttribute("Height", GetType(String), DataType:="normalizedString"), System.Xml.Serialization.XmlElementAttribute("Label", GetType(String)), System.Xml.Serialization.XmlElementAttribute("Left", GetType(String), DataType:="normalizedString"), System.Xml.Serialization.XmlElementAttribute("RepeatWith", GetType(String)), System.Xml.Serialization.XmlElementAttribute("Style", GetType(StyleType)), System.Xml.Serialization.XmlElementAttribute("Top", GetType(String), DataType:="normalizedString"), System.Xml.Serialization.XmlElementAttribute("Type", GetType(String)), System.Xml.Serialization.XmlElementAttribute("Visibility", GetType(VisibilityType)), System.Xml.Serialization.XmlElementAttribute("Width", GetType(String), DataType:="normalizedString"), System.Xml.Serialization.XmlElementAttribute("ZIndex", GetType(System.UInt32)), System.Xml.Serialization.XmlChoiceIdentifierAttribute("ItemsElementName")> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlElementAttribute("ItemsElementName"), System.Xml.Serialization.XmlIgnoreAttribute()> _
         Public Property ItemsElementName() As ItemsChoiceType29()
            Get
               Return Me.itemsElementNameField
            End Get
            Set(ByVal value As ItemsChoiceType29())
               Me.itemsElementNameField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAttributeAttribute(DataType:="normalizedString")> _
         Public Property Name() As String
            Get
               Return Me.nameField
            End Get
            Set(ByVal value As String)
               Me.nameField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute(AnonymousType:=True)> _
      Public Enum CustomReportItemTypeDataElementOutput
         Output
         NoOutput
         ContentsOnly
         [Auto]
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class VisibilityType

         Private itemsField() As Object
         Private itemsElementNameField() As ItemsChoiceType9
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("Hidden", GetType(String)), System.Xml.Serialization.XmlElementAttribute("ToggleItem", GetType(String)), System.Xml.Serialization.XmlChoiceIdentifierAttribute("ItemsElementName")> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlElementAttribute("ItemsElementName"), System.Xml.Serialization.XmlIgnoreAttribute()> _
         Public Property ItemsElementName() As ItemsChoiceType9()
            Get
               Return Me.itemsElementNameField
            End Get
            Set(ByVal value As ItemsChoiceType9())
               Me.itemsElementNameField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition", IncludeInSchema:=False)> _
      Public Enum ItemsChoiceType9
         <System.Xml.Serialization.XmlEnumAttribute("##any:")> Item
         Hidden
         ToggleItem
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition", IncludeInSchema:=False)> _
      Public Enum ItemsChoiceType29
         <System.Xml.Serialization.XmlEnumAttribute("##any:")> Item
         AltReportItem
         Bookmark
         CustomData
         CustomProperties
         DataElementName
         DataElementOutput
         Height
         Label
         Left
         RepeatWith
         Style
         Top
         Type
         Visibility
         Width
         ZIndex
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class PlotAreaType

         Private itemsField() As Object
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("Style", GetType(StyleType))> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class ThreeDPropertiesType

         Private itemsField() As Object
         Private itemsElementNameField() As ItemsChoiceType26
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("Clustered", GetType(Boolean)), System.Xml.Serialization.XmlElementAttribute("DepthRatio", GetType(System.UInt32)), System.Xml.Serialization.XmlElementAttribute("DrawingStyle", GetType(ThreeDPropertiesTypeDrawingStyle)), System.Xml.Serialization.XmlElementAttribute("Enabled", GetType(Boolean)), System.Xml.Serialization.XmlElementAttribute("GapDepth", GetType(System.UInt32)), System.Xml.Serialization.XmlElementAttribute("HeightRatio", GetType(System.UInt32)), System.Xml.Serialization.XmlElementAttribute("Inclination", GetType(String), DataType:="integer"), System.Xml.Serialization.XmlElementAttribute("Perspective", GetType(System.UInt32)), System.Xml.Serialization.XmlElementAttribute("ProjectionMode", GetType(ThreeDPropertiesTypeProjectionMode)), System.Xml.Serialization.XmlElementAttribute("Rotation", GetType(String), DataType:="integer"), System.Xml.Serialization.XmlElementAttribute("Shading", GetType(ThreeDPropertiesTypeShading)), System.Xml.Serialization.XmlElementAttribute("WallThickness", GetType(System.UInt32)), System.Xml.Serialization.XmlChoiceIdentifierAttribute("ItemsElementName")> _
              Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlElementAttribute("ItemsElementName"), System.Xml.Serialization.XmlIgnoreAttribute()> _
         Public Property ItemsElementName() As ItemsChoiceType26()
            Get
               Return Me.itemsElementNameField
            End Get
            Set(ByVal value As ItemsChoiceType26())
               Me.itemsElementNameField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute(AnonymousType:=True)> _
      Public Enum ThreeDPropertiesTypeDrawingStyle
         Cube
         Cylinder
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute(AnonymousType:=True)> _
      Public Enum ThreeDPropertiesTypeProjectionMode
         Perspective
         Orthographic
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute(AnonymousType:=True)> _
      Public Enum ThreeDPropertiesTypeShading
         None
         Simple
         Real
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition", IncludeInSchema:=False)> _
      Public Enum ItemsChoiceType26
         <System.Xml.Serialization.XmlEnumAttribute("##any:")> Item
         Clustered
         DepthRatio
         DrawingStyle
         Enabled
         GapDepth
         HeightRatio
         Inclination
         Perspective
         ProjectionMode
         Rotation
         Shading
         WallThickness
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class ValueAxisType

         Private itemsField() As Object
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("Axis", GetType(AxisType))> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class AxisType

         Private itemsField() As Object
         Private itemsElementNameField() As ItemsChoiceType25
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("CrossAt", GetType(String)), System.Xml.Serialization.XmlElementAttribute("Interlaced", GetType(Boolean)), System.Xml.Serialization.XmlElementAttribute("LogScale", GetType(Boolean)), System.Xml.Serialization.XmlElementAttribute("MajorGridLines", GetType(MajorGridLinesType)), System.Xml.Serialization.XmlElementAttribute("MajorInterval", GetType(String)), System.Xml.Serialization.XmlElementAttribute("MajorTickMarks", GetType(AxisTypeMajorTickMarks)), System.Xml.Serialization.XmlElementAttribute("Margin", GetType(Boolean)), System.Xml.Serialization.XmlElementAttribute("Max", GetType(String)), System.Xml.Serialization.XmlElementAttribute("Min", GetType(String)), System.Xml.Serialization.XmlElementAttribute("MinorGridLines", GetType(MinorGridLinesType)), System.Xml.Serialization.XmlElementAttribute("MinorInterval", GetType(String)), System.Xml.Serialization.XmlElementAttribute("MinorTickMarks", GetType(AxisTypeMinorTickMarks)), System.Xml.Serialization.XmlElementAttribute("Reverse", GetType(Boolean)), System.Xml.Serialization.XmlElementAttribute("Scalar", GetType(Boolean)), System.Xml.Serialization.XmlElementAttribute("Style", GetType(StyleType)), System.Xml.Serialization.XmlElementAttribute("Title", GetType(TitleType)), System.Xml.Serialization.XmlElementAttribute("Visible", GetType(Boolean)), System.Xml.Serialization.XmlChoiceIdentifierAttribute("ItemsElementName")> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlElementAttribute("ItemsElementName"), System.Xml.Serialization.XmlIgnoreAttribute()> _
         Public Property ItemsElementName() As ItemsChoiceType25()
            Get
               Return Me.itemsElementNameField
            End Get
            Set(ByVal value As ItemsChoiceType25())
               Me.itemsElementNameField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class MajorGridLinesType

         Private itemsField() As Object
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("ShowGridLines", GetType(Boolean)), System.Xml.Serialization.XmlElementAttribute("Style", GetType(StyleType))> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute(AnonymousType:=True)> _
      Public Enum AxisTypeMajorTickMarks
         None
         Inside
         Outside
         Cross
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class MinorGridLinesType

         Private itemsField() As Object
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("ShowGridLines", GetType(Boolean)), System.Xml.Serialization.XmlElementAttribute("Style", GetType(StyleType))> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute(AnonymousType:=True)> _
      Public Enum AxisTypeMinorTickMarks
         None
         Inside
         Outside
         Cross
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class TitleType

         Private itemsField() As Object
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("Caption", GetType(String)), System.Xml.Serialization.XmlElementAttribute("Position", GetType(TitleTypePosition)), System.Xml.Serialization.XmlElementAttribute("Style", GetType(StyleType))> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute(AnonymousType:=True)> _
      Public Enum TitleTypePosition
         Center
         Near
         Far
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition", IncludeInSchema:=False)> _
      Public Enum ItemsChoiceType25
         <System.Xml.Serialization.XmlEnumAttribute("##any:")> Item
         CrossAt
         Interlaced
         LogScale
         MajorGridLines
         MajorInterval
         MajorTickMarks
         Margin
         Max
         Min
         MinorGridLines
         MinorInterval
         MinorTickMarks
         Reverse
         Scalar
         Style
         Title
         Visible
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class CategoryAxisType

         Private itemsField() As Object
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("Axis", GetType(AxisType))> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class LegendType

         Private itemsField() As Object
         Private itemsElementNameField() As ItemsChoiceType24
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("InsidePlotArea", GetType(Boolean)), System.Xml.Serialization.XmlElementAttribute("Layout", GetType(LegendTypeLayout)), System.Xml.Serialization.XmlElementAttribute("Position", GetType(LegendTypePosition)), System.Xml.Serialization.XmlElementAttribute("Style", GetType(StyleType)), System.Xml.Serialization.XmlElementAttribute("Visible", GetType(Boolean)), System.Xml.Serialization.XmlChoiceIdentifierAttribute("ItemsElementName")> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlElementAttribute("ItemsElementName"), System.Xml.Serialization.XmlIgnoreAttribute()> _
         Public Property ItemsElementName() As ItemsChoiceType24()
            Get
               Return Me.itemsElementNameField
            End Get
            Set(ByVal value As ItemsChoiceType24())
               Me.itemsElementNameField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute(AnonymousType:=True)> _
      Public Enum LegendTypeLayout
         Column
         Row
         Table
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute(AnonymousType:=True)> _
      Public Enum LegendTypePosition
         TopLeft
         TopCenter
         TopRight
         LeftTop
         LeftCenter
         LeftBottom
         RightTop
         RightCenter
         RightBottom
         BottomLeft
         BottomCenter
         BottomRight
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition", IncludeInSchema:=False)> _
      Public Enum ItemsChoiceType24
         <System.Xml.Serialization.XmlEnumAttribute("##any:")> Item
         InsidePlotArea
         Layout
         Position
         Style
         Visible
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class MarkerType

         Private itemsField() As Object
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("Size", GetType(String), DataType:="normalizedString"), System.Xml.Serialization.XmlElementAttribute("Style", GetType(StyleType)), System.Xml.Serialization.XmlElementAttribute("Type", GetType(MarkerTypeType))> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute(AnonymousType:=True)> _
      Public Enum MarkerTypeType
         None
         Square
         Circle
         Diamond
         Triangle
         Cross
         [Auto]
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class DataLabelType

         Private itemsField() As Object
         Private itemsElementNameField() As ItemsChoiceType23
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("Position", GetType(DataLabelTypePosition)), System.Xml.Serialization.XmlElementAttribute("Rotation", GetType(String), DataType:="integer"), System.Xml.Serialization.XmlElementAttribute("Style", GetType(StyleType)), System.Xml.Serialization.XmlElementAttribute("Value", GetType(String)), System.Xml.Serialization.XmlElementAttribute("Visible", GetType(Boolean)), System.Xml.Serialization.XmlChoiceIdentifierAttribute("ItemsElementName")> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlElementAttribute("ItemsElementName"), System.Xml.Serialization.XmlIgnoreAttribute()> _
         Public Property ItemsElementName() As ItemsChoiceType23()
            Get
               Return Me.itemsElementNameField
            End Get
            Set(ByVal value As ItemsChoiceType23())
               Me.itemsElementNameField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute(AnonymousType:=True)> _
      Public Enum DataLabelTypePosition
         [Auto]
         Top
         TopLeft
         TopRight
         Left
         Center
         Right
         BottomLeft
         Bottom
         BottomRight
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition", IncludeInSchema:=False)> _
      Public Enum ItemsChoiceType23
         <System.Xml.Serialization.XmlEnumAttribute("##any:")> Item
         Position
         Rotation
         Style
         Value
         Visible
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class DataValuesType

         Private dataValueField() As DataValueType
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlElementAttribute("DataValue")> _
         Public Property DataValue() As DataValueType()
            Get
               Return Me.dataValueField
            End Get
            Set(ByVal value As DataValueType())
               Me.dataValueField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class DataPointType

         Private itemsField() As Object
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("Action", GetType(ActionType)), System.Xml.Serialization.XmlElementAttribute("DataElementName", GetType(String)), System.Xml.Serialization.XmlElementAttribute("DataElementOutput", GetType(DataPointTypeDataElementOutput)), System.Xml.Serialization.XmlElementAttribute("DataLabel", GetType(DataLabelType)), System.Xml.Serialization.XmlElementAttribute("DataValues", GetType(DataValuesType)), System.Xml.Serialization.XmlElementAttribute("Marker", GetType(MarkerType)), System.Xml.Serialization.XmlElementAttribute("Style", GetType(StyleType))> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute(AnonymousType:=True)> _
      Public Enum DataPointTypeDataElementOutput
         Output
         NoOutput
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class DataPointsType

         Private dataPointField() As DataPointType
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlElementAttribute("DataPoint")> _
         Public Property DataPoint() As DataPointType()
            Get
               Return Me.dataPointField
            End Get
            Set(ByVal value As DataPointType())
               Me.dataPointField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class ChartSeriesType

         Private itemsField() As Object
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("DataPoints", GetType(DataPointsType)), System.Xml.Serialization.XmlElementAttribute("PlotType", GetType(ChartSeriesTypePlotType))> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute(AnonymousType:=True)> _
      Public Enum ChartSeriesTypePlotType
         [Auto]
         Line
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class ChartDataType

         Private chartSeriesField() As ChartSeriesType
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlElementAttribute("ChartSeries")> _
         Public Property ChartSeries() As ChartSeriesType()
            Get
               Return Me.chartSeriesField
            End Get
            Set(ByVal value As ChartSeriesType())
               Me.chartSeriesField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class StaticCategoriesType

         Private staticMemberField() As StaticMemberType
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlElementAttribute("StaticMember")> _
         Public Property StaticMember() As StaticMemberType()
            Get
               Return Me.staticMemberField
            End Get
            Set(ByVal value As StaticMemberType())
               Me.staticMemberField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class StaticMemberType

         Private itemsField() As Object
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("Label", GetType(String))> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class DynamicCategoriesType

         Private itemsField() As Object
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("Grouping", GetType(GroupingType)), System.Xml.Serialization.XmlElementAttribute("Label", GetType(String)), System.Xml.Serialization.XmlElementAttribute("Sorting", GetType(SortingType))> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class CategoryGroupingType

         Private itemsField() As Object
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("DynamicCategories", GetType(DynamicCategoriesType)), System.Xml.Serialization.XmlElementAttribute("StaticCategories", GetType(StaticCategoriesType))> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class CategoryGroupingsType

         Private categoryGroupingField() As CategoryGroupingType
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlElementAttribute("CategoryGrouping")> _
         Public Property CategoryGrouping() As CategoryGroupingType()
            Get
               Return Me.categoryGroupingField
            End Get
            Set(ByVal value As CategoryGroupingType())
               Me.categoryGroupingField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class StaticSeriesType

         Private staticMemberField() As StaticMemberType
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlElementAttribute("StaticMember")> _
         Public Property StaticMember() As StaticMemberType()
            Get
               Return Me.staticMemberField
            End Get
            Set(ByVal value As StaticMemberType())
               Me.staticMemberField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class DynamicSeriesType

         Private itemsField() As Object
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("Grouping", GetType(GroupingType)), System.Xml.Serialization.XmlElementAttribute("Label", GetType(String)), System.Xml.Serialization.XmlElementAttribute("Sorting", GetType(SortingType))> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class SeriesGroupingType

         Private itemsField() As Object
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("DynamicSeries", GetType(DynamicSeriesType)), System.Xml.Serialization.XmlElementAttribute("StaticSeries", GetType(StaticSeriesType))> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class SeriesGroupingsType

         Private seriesGroupingField() As SeriesGroupingType
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlElementAttribute("SeriesGrouping")> _
         Public Property SeriesGrouping() As SeriesGroupingType()
            Get
               Return Me.seriesGroupingField
            End Get
            Set(ByVal value As SeriesGroupingType())
               Me.seriesGroupingField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class DetailsType

         Private itemsField() As Object
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("Grouping", GetType(GroupingType)), System.Xml.Serialization.XmlElementAttribute("Sorting", GetType(SortingType)), System.Xml.Serialization.XmlElementAttribute("TableRows", GetType(TableRowsType)), System.Xml.Serialization.XmlElementAttribute("Visibility", GetType(VisibilityType))> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class TableRowsType

         Private tableRowField() As TableRowType
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlElementAttribute("TableRow")> _
         Public Property TableRow() As TableRowType()
            Get
               Return Me.tableRowField
            End Get
            Set(ByVal value As TableRowType())
               Me.tableRowField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class TableRowType

         Private itemsField() As Object
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("Height", GetType(String), DataType:="normalizedString"), System.Xml.Serialization.XmlElementAttribute("TableCells", GetType(TableCellsType)), System.Xml.Serialization.XmlElementAttribute("Visibility", GetType(VisibilityType))> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class TableCellsType

         Private tableCellField() As TableCellType
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlElementAttribute("TableCell")> _
         Public Property TableCell() As TableCellType()
            Get
               Return Me.tableCellField
            End Get
            Set(ByVal value As TableCellType())
               Me.tableCellField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class TableCellType

         Private itemsField() As Object
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("ColSpan", GetType(System.UInt32)), System.Xml.Serialization.XmlElementAttribute("ReportItems", GetType(ReportItemsType))> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class FooterType

         Private itemsField() As Object
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("RepeatOnNewPage", GetType(Boolean)), System.Xml.Serialization.XmlElementAttribute("TableRows", GetType(TableRowsType))> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class TableGroupType

         Private itemsField() As Object
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("Footer", GetType(FooterType)), System.Xml.Serialization.XmlElementAttribute("Grouping", GetType(GroupingType)), System.Xml.Serialization.XmlElementAttribute("Header", GetType(HeaderType)), System.Xml.Serialization.XmlElementAttribute("Sorting", GetType(SortingType)), System.Xml.Serialization.XmlElementAttribute("Visibility", GetType(VisibilityType))> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class HeaderType

         Private itemsField() As Object
         Private itemsElementNameField() As ItemsChoiceType20
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("FixedHeader", GetType(Boolean)), System.Xml.Serialization.XmlElementAttribute("RepeatOnNewPage", GetType(Boolean)), System.Xml.Serialization.XmlElementAttribute("TableRows", GetType(TableRowsType)), System.Xml.Serialization.XmlChoiceIdentifierAttribute("ItemsElementName")> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlElementAttribute("ItemsElementName"), System.Xml.Serialization.XmlIgnoreAttribute()> _
         Public Property ItemsElementName() As ItemsChoiceType20()
            Get
               Return Me.itemsElementNameField
            End Get
            Set(ByVal value As ItemsChoiceType20())
               Me.itemsElementNameField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition", IncludeInSchema:=False)> _
      Public Enum ItemsChoiceType20
         <System.Xml.Serialization.XmlEnumAttribute("##any:")> Item
         FixedHeader
         RepeatOnNewPage
         TableRows
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class TableGroupsType

         Private tableGroupField() As TableGroupType
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlElementAttribute("TableGroup")> _
         Public Property TableGroup() As TableGroupType()
            Get
               Return Me.tableGroupField
            End Get
            Set(ByVal value As TableGroupType())
               Me.tableGroupField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class TableColumnType

         Private itemsField() As Object
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("FixedHeader", GetType(Boolean)), System.Xml.Serialization.XmlElementAttribute("Visibility", GetType(VisibilityType)), System.Xml.Serialization.XmlElementAttribute("Width", GetType(String), DataType:="normalizedString")> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class TableColumnsType

         Private tableColumnField() As TableColumnType
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlElementAttribute("TableColumn")> _
         Public Property TableColumn() As TableColumnType()
            Get
               Return Me.tableColumnField
            End Get
            Set(ByVal value As TableColumnType())
               Me.tableColumnField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class TableType

         Private itemsField() As Object
         Private itemsElementNameField() As ItemsChoiceType21
         Private nameField As String
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("Action", GetType(ActionType)), System.Xml.Serialization.XmlElementAttribute("Bookmark", GetType(String)), System.Xml.Serialization.XmlElementAttribute("CustomProperties", GetType(CustomPropertiesType)), System.Xml.Serialization.XmlElementAttribute("DataElementName", GetType(String)), System.Xml.Serialization.XmlElementAttribute("DataElementOutput", GetType(TableTypeDataElementOutput)), System.Xml.Serialization.XmlElementAttribute("DataSetName", GetType(String)), System.Xml.Serialization.XmlElementAttribute("DetailDataCollectionName", GetType(String)), System.Xml.Serialization.XmlElementAttribute("DetailDataElementName", GetType(String)), System.Xml.Serialization.XmlElementAttribute("DetailDataElementOutput", GetType(TableTypeDetailDataElementOutput)), System.Xml.Serialization.XmlElementAttribute("Details", GetType(DetailsType)), System.Xml.Serialization.XmlElementAttribute("FillPage", GetType(Boolean)), System.Xml.Serialization.XmlElementAttribute("Filters", GetType(FiltersType)), System.Xml.Serialization.XmlElementAttribute("Footer", GetType(FooterType)), System.Xml.Serialization.XmlElementAttribute("Header", GetType(HeaderType)), System.Xml.Serialization.XmlElementAttribute("Height", GetType(String), DataType:="normalizedString"), System.Xml.Serialization.XmlElementAttribute("KeepTogether", GetType(Boolean)), System.Xml.Serialization.XmlElementAttribute("Label", GetType(String)), System.Xml.Serialization.XmlElementAttribute("Left", GetType(String), DataType:="normalizedString"), System.Xml.Serialization.XmlElementAttribute("LinkToChild", GetType(String)), System.Xml.Serialization.XmlElementAttribute("NoRows", GetType(String)), System.Xml.Serialization.XmlElementAttribute("PageBreakAtEnd", GetType(Boolean)), System.Xml.Serialization.XmlElementAttribute("PageBreakAtStart", GetType(Boolean)), System.Xml.Serialization.XmlElementAttribute("RepeatWith", GetType(String)), System.Xml.Serialization.XmlElementAttribute("Style", GetType(StyleType)), System.Xml.Serialization.XmlElementAttribute("TableColumns", GetType(TableColumnsType)), System.Xml.Serialization.XmlElementAttribute("TableGroups", GetType(TableGroupsType)), System.Xml.Serialization.XmlElementAttribute("ToolTip", GetType(String)), System.Xml.Serialization.XmlElementAttribute("Top", GetType(String), DataType:="normalizedString"), System.Xml.Serialization.XmlElementAttribute("Visibility", GetType(VisibilityType)), System.Xml.Serialization.XmlElementAttribute("Width", GetType(String), DataType:="normalizedString"), System.Xml.Serialization.XmlElementAttribute("ZIndex", GetType(System.UInt32)), System.Xml.Serialization.XmlChoiceIdentifierAttribute("ItemsElementName")> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlElementAttribute("ItemsElementName"), System.Xml.Serialization.XmlIgnoreAttribute()> _
         Public Property ItemsElementName() As ItemsChoiceType21()
            Get
               Return Me.itemsElementNameField
            End Get
            Set(ByVal value As ItemsChoiceType21())
               Me.itemsElementNameField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAttributeAttribute(DataType:="normalizedString")> _
         Public Property Name() As String
            Get
               Return Me.nameField
            End Get
            Set(ByVal value As String)
               Me.nameField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute(AnonymousType:=True)> _
      Public Enum TableTypeDataElementOutput
         Output
         NoOutput
         ContentsOnly
         [Auto]
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute(AnonymousType:=True)> _
      Public Enum TableTypeDetailDataElementOutput
         Output
         NoOutput
         ContentsOnly
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition", IncludeInSchema:=False)> _
      Public Enum ItemsChoiceType21
         <System.Xml.Serialization.XmlEnumAttribute("##any:")> Item
         Action
         Bookmark
         CustomProperties
         DataElementName
         DataElementOutput
         DataSetName
         DetailDataCollectionName
         DetailDataElementName
         DetailDataElementOutput
         Details
         FillPage
         Filters
         Footer
         Header
         Height
         KeepTogether
         Label
         Left
         LinkToChild
         NoRows
         PageBreakAtEnd
         PageBreakAtStart
         RepeatWith
         Style
         TableColumns
         TableGroups
         ToolTip
         Top
         Visibility
         Width
         ZIndex
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class MatrixColumnType

         Private itemsField() As Object
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("Width", GetType(String), DataType:="normalizedString")> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class MatrixColumnsType

         Private matrixColumnField() As MatrixColumnType
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlElementAttribute("MatrixColumn")> _
         Public Property MatrixColumn() As MatrixColumnType()
            Get
               Return Me.matrixColumnField
            End Get
            Set(ByVal value As MatrixColumnType())
               Me.matrixColumnField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class MatrixCellType

         Private itemsField() As Object
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("ReportItems", GetType(ReportItemsType))> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class MatrixCellsType

         Private matrixCellField() As MatrixCellType
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlElementAttribute("MatrixCell")> _
         Public Property MatrixCell() As MatrixCellType()
            Get
               Return Me.matrixCellField
            End Get
            Set(ByVal value As MatrixCellType())
               Me.matrixCellField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class MatrixRowType

         Private itemsField() As Object
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("Height", GetType(String), DataType:="normalizedString"), System.Xml.Serialization.XmlElementAttribute("MatrixCells", GetType(MatrixCellsType))> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class MatrixRowsType

         Private matrixRowField() As MatrixRowType
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlElementAttribute("MatrixRow")> _
         Public Property MatrixRow() As MatrixRowType()
            Get
               Return Me.matrixRowField
            End Get
            Set(ByVal value As MatrixRowType())
               Me.matrixRowField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class StaticRowType

         Private itemsField() As Object
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("ReportItems", GetType(ReportItemsType))> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class StaticRowsType

         Private staticRowField() As StaticRowType
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlElementAttribute("StaticRow")> _
         Public Property StaticRow() As StaticRowType()
            Get
               Return Me.staticRowField
            End Get
            Set(ByVal value As StaticRowType())
               Me.staticRowField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class RowGroupingType

         Private itemsField() As Object
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("DynamicRows", GetType(DynamicColumnsRowsType)), System.Xml.Serialization.XmlElementAttribute("FixedHeader", GetType(Boolean)), System.Xml.Serialization.XmlElementAttribute("StaticRows", GetType(StaticRowsType)), System.Xml.Serialization.XmlElementAttribute("Width", GetType(String), DataType:="normalizedString")> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class DynamicColumnsRowsType

         Private itemsField() As Object
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("Grouping", GetType(GroupingType)), System.Xml.Serialization.XmlElementAttribute("ReportItems", GetType(ReportItemsType)), System.Xml.Serialization.XmlElementAttribute("Sorting", GetType(SortingType)), System.Xml.Serialization.XmlElementAttribute("Subtotal", GetType(SubtotalType)), System.Xml.Serialization.XmlElementAttribute("Visibility", GetType(VisibilityType))> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class SubtotalType

         Private itemsField() As Object
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("DataElementName", GetType(String)), System.Xml.Serialization.XmlElementAttribute("DataElementOutput", GetType(SubtotalTypeDataElementOutput)), System.Xml.Serialization.XmlElementAttribute("Position", GetType(SubtotalTypePosition)), System.Xml.Serialization.XmlElementAttribute("ReportItems", GetType(ReportItemsType)), System.Xml.Serialization.XmlElementAttribute("Style", GetType(StyleType))> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute(AnonymousType:=True)> _
      Public Enum SubtotalTypeDataElementOutput
         Output
         NoOutput
         ContentsOnly
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute(AnonymousType:=True)> _
      Public Enum SubtotalTypePosition
         Before
         After
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class RowGroupingsType

         Private rowGroupingField() As RowGroupingType
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlElementAttribute("RowGrouping")> _
         Public Property RowGrouping() As RowGroupingType()
            Get
               Return Me.rowGroupingField
            End Get
            Set(ByVal value As RowGroupingType())
               Me.rowGroupingField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class StaticColumnType

         Private itemsField() As Object
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("ReportItems", GetType(ReportItemsType))> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class StaticColumnsType

         Private staticColumnField() As StaticColumnType
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlElementAttribute("StaticColumn")> _
         Public Property StaticColumn() As StaticColumnType()
            Get
               Return Me.staticColumnField
            End Get
            Set(ByVal value As StaticColumnType())
               Me.staticColumnField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class ColumnGroupingType

         Private itemsField() As Object
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("DynamicColumns", GetType(DynamicColumnsRowsType)), System.Xml.Serialization.XmlElementAttribute("FixedHeader", GetType(Boolean)), System.Xml.Serialization.XmlElementAttribute("Height", GetType(String), DataType:="normalizedString"), System.Xml.Serialization.XmlElementAttribute("StaticColumns", GetType(StaticColumnsType))> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class ColumnGroupingsType

         Private columnGroupingField() As ColumnGroupingType
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlElementAttribute("ColumnGrouping")> _
         Public Property ColumnGrouping() As ColumnGroupingType()
            Get
               Return Me.columnGroupingField
            End Get
            Set(ByVal value As ColumnGroupingType())
               Me.columnGroupingField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class CornerType

         Private itemsField() As Object
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("ReportItems", GetType(ReportItemsType))> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class MatrixType

         Private itemsField() As Object
         Private itemsElementNameField() As ItemsChoiceType19
         Private nameField As String
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("Action", GetType(ActionType)), System.Xml.Serialization.XmlElementAttribute("Bookmark", GetType(String)), System.Xml.Serialization.XmlElementAttribute("CellDataElementName", GetType(String)), System.Xml.Serialization.XmlElementAttribute("CellDataElementOutput", GetType(MatrixTypeCellDataElementOutput)), System.Xml.Serialization.XmlElementAttribute("ColumnGroupings", GetType(ColumnGroupingsType)), System.Xml.Serialization.XmlElementAttribute("Corner", GetType(CornerType)), System.Xml.Serialization.XmlElementAttribute("CustomProperties", GetType(CustomPropertiesType)), System.Xml.Serialization.XmlElementAttribute("DataElementName", GetType(String)), System.Xml.Serialization.XmlElementAttribute("DataElementOutput", GetType(MatrixTypeDataElementOutput)), System.Xml.Serialization.XmlElementAttribute("DataSetName", GetType(String)), System.Xml.Serialization.XmlElementAttribute("Filters", GetType(FiltersType)), System.Xml.Serialization.XmlElementAttribute("GroupsBeforeRowHeaders", GetType(System.UInt32)), System.Xml.Serialization.XmlElementAttribute("Height", GetType(String), DataType:="normalizedString"), System.Xml.Serialization.XmlElementAttribute("KeepTogether", GetType(Boolean)), System.Xml.Serialization.XmlElementAttribute("Label", GetType(String)), System.Xml.Serialization.XmlElementAttribute("LayoutDirection", GetType(MatrixTypeLayoutDirection)), System.Xml.Serialization.XmlElementAttribute("Left", GetType(String), DataType:="normalizedString"), System.Xml.Serialization.XmlElementAttribute("LinkToChild", GetType(String)), System.Xml.Serialization.XmlElementAttribute("MatrixColumns", GetType(MatrixColumnsType)), System.Xml.Serialization.XmlElementAttribute("MatrixRows", GetType(MatrixRowsType)), System.Xml.Serialization.XmlElementAttribute("NoRows", GetType(String)), System.Xml.Serialization.XmlElementAttribute("PageBreakAtEnd", GetType(Boolean)), System.Xml.Serialization.XmlElementAttribute("PageBreakAtStart", GetType(Boolean)), System.Xml.Serialization.XmlElementAttribute("RepeatWith", GetType(String)), System.Xml.Serialization.XmlElementAttribute("RowGroupings", GetType(RowGroupingsType)), System.Xml.Serialization.XmlElementAttribute("Style", GetType(StyleType)), System.Xml.Serialization.XmlElementAttribute("ToolTip", GetType(String)), System.Xml.Serialization.XmlElementAttribute("Top", GetType(String), DataType:="normalizedString"), System.Xml.Serialization.XmlElementAttribute("Visibility", GetType(VisibilityType)), System.Xml.Serialization.XmlElementAttribute("Width", GetType(String), DataType:="normalizedString"), System.Xml.Serialization.XmlElementAttribute("ZIndex", GetType(System.UInt32)), System.Xml.Serialization.XmlChoiceIdentifierAttribute("ItemsElementName")> _
              Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlElementAttribute("ItemsElementName"), System.Xml.Serialization.XmlIgnoreAttribute()> _
         Public Property ItemsElementName() As ItemsChoiceType19()
            Get
               Return Me.itemsElementNameField
            End Get
            Set(ByVal value As ItemsChoiceType19())
               Me.itemsElementNameField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAttributeAttribute(DataType:="normalizedString")> _
         Public Property Name() As String
            Get
               Return Me.nameField
            End Get
            Set(ByVal value As String)
               Me.nameField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute(AnonymousType:=True)> _
      Public Enum MatrixTypeCellDataElementOutput
         Output
         NoOutput
         ContentsOnly
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute(AnonymousType:=True)> _
      Public Enum MatrixTypeDataElementOutput
         Output
         NoOutput
         ContentsOnly
         [Auto]
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute(AnonymousType:=True)> _
      Public Enum MatrixTypeLayoutDirection
         LTR
         RTL
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition", IncludeInSchema:=False)> _
      Public Enum ItemsChoiceType19
         <System.Xml.Serialization.XmlEnumAttribute("##any:")> Item
         Action
         Bookmark
         CellDataElementName
         CellDataElementOutput
         ColumnGroupings
         Corner
         CustomProperties
         DataElementName
         DataElementOutput
         DataSetName
         Filters
         GroupsBeforeRowHeaders
         Height
         KeepTogether
         Label
         LayoutDirection
         Left
         LinkToChild
         MatrixColumns
         MatrixRows
         NoRows
         PageBreakAtEnd
         PageBreakAtStart
         RepeatWith
         RowGroupings
         Style
         ToolTip
         Top
         Visibility
         Width
         ZIndex
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class ListType

         Private itemsField() As Object
         Private itemsElementNameField() As ItemsChoiceType18
         Private nameField As String
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("Action", GetType(ActionType)), System.Xml.Serialization.XmlElementAttribute("Bookmark", GetType(String)), System.Xml.Serialization.XmlElementAttribute("CustomProperties", GetType(CustomPropertiesType)), System.Xml.Serialization.XmlElementAttribute("DataElementName", GetType(String)), System.Xml.Serialization.XmlElementAttribute("DataElementOutput", GetType(ListTypeDataElementOutput)), System.Xml.Serialization.XmlElementAttribute("DataInstanceElementOutput", GetType(ListTypeDataInstanceElementOutput)), System.Xml.Serialization.XmlElementAttribute("DataInstanceName", GetType(String)), System.Xml.Serialization.XmlElementAttribute("DataSetName", GetType(String)), System.Xml.Serialization.XmlElementAttribute("FillPage", GetType(Boolean)), System.Xml.Serialization.XmlElementAttribute("Filters", GetType(FiltersType)), System.Xml.Serialization.XmlElementAttribute("Grouping", GetType(GroupingType)), System.Xml.Serialization.XmlElementAttribute("Height", GetType(String), DataType:="normalizedString"), System.Xml.Serialization.XmlElementAttribute("KeepTogether", GetType(Boolean)), System.Xml.Serialization.XmlElementAttribute("Label", GetType(String)), System.Xml.Serialization.XmlElementAttribute("Left", GetType(String), DataType:="normalizedString"), System.Xml.Serialization.XmlElementAttribute("LinkToChild", GetType(String)), System.Xml.Serialization.XmlElementAttribute("NoRows", GetType(String)), System.Xml.Serialization.XmlElementAttribute("PageBreakAtEnd", GetType(Boolean)), System.Xml.Serialization.XmlElementAttribute("PageBreakAtStart", GetType(Boolean)), System.Xml.Serialization.XmlElementAttribute("RepeatWith", GetType(String)), System.Xml.Serialization.XmlElementAttribute("ReportItems", GetType(ReportItemsType)), System.Xml.Serialization.XmlElementAttribute("Sorting", GetType(SortingType)), System.Xml.Serialization.XmlElementAttribute("Style", GetType(StyleType)), System.Xml.Serialization.XmlElementAttribute("ToolTip", GetType(String)), System.Xml.Serialization.XmlElementAttribute("Top", GetType(String), DataType:="normalizedString"), System.Xml.Serialization.XmlElementAttribute("Visibility", GetType(VisibilityType)), System.Xml.Serialization.XmlElementAttribute("Width", GetType(String), DataType:="normalizedString"), System.Xml.Serialization.XmlElementAttribute("ZIndex", GetType(System.UInt32)), System.Xml.Serialization.XmlChoiceIdentifierAttribute("ItemsElementName")> _
              Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlElementAttribute("ItemsElementName"), System.Xml.Serialization.XmlIgnoreAttribute()> _
         Public Property ItemsElementName() As ItemsChoiceType18()
            Get
               Return Me.itemsElementNameField
            End Get
            Set(ByVal value As ItemsChoiceType18())
               Me.itemsElementNameField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAttributeAttribute(DataType:="normalizedString")> _
         Public Property Name() As String
            Get
               Return Me.nameField
            End Get
            Set(ByVal value As String)
               Me.nameField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute(AnonymousType:=True)> _
      Public Enum ListTypeDataElementOutput
         Output
         NoOutput
         ContentsOnly
         [Auto]
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute(AnonymousType:=True)> _
      Public Enum ListTypeDataInstanceElementOutput
         Output
         NoOutput
         ContentsOnly
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition", IncludeInSchema:=False)> _
      Public Enum ItemsChoiceType18
         <System.Xml.Serialization.XmlEnumAttribute("##any:")> Item
         Action
         Bookmark
         CustomProperties
         DataElementName
         DataElementOutput
         DataInstanceElementOutput
         DataInstanceName
         DataSetName
         FillPage
         Filters
         Grouping
         Height
         KeepTogether
         Label
         Left
         LinkToChild
         NoRows
         PageBreakAtEnd
         PageBreakAtStart
         RepeatWith
         ReportItems
         Sorting
         Style
         ToolTip
         Top
         Visibility
         Width
         ZIndex
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class SubreportType

         Private itemsField() As Object
         Private itemsElementNameField() As ItemsChoiceType16
         Private nameField As String
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("Action", GetType(ActionType)), System.Xml.Serialization.XmlElementAttribute("Bookmark", GetType(String)), System.Xml.Serialization.XmlElementAttribute("CustomProperties", GetType(CustomPropertiesType)), System.Xml.Serialization.XmlElementAttribute("DataElementName", GetType(String)), System.Xml.Serialization.XmlElementAttribute("DataElementOutput", GetType(SubreportTypeDataElementOutput)), System.Xml.Serialization.XmlElementAttribute("Height", GetType(String), DataType:="normalizedString"), System.Xml.Serialization.XmlElementAttribute("Label", GetType(String)), System.Xml.Serialization.XmlElementAttribute("Left", GetType(String), DataType:="normalizedString"), System.Xml.Serialization.XmlElementAttribute("LinkToChild", GetType(String)), System.Xml.Serialization.XmlElementAttribute("MergeTransactions", GetType(Boolean)), System.Xml.Serialization.XmlElementAttribute("NoRows", GetType(String)), System.Xml.Serialization.XmlElementAttribute("Parameters", GetType(ParametersType)), System.Xml.Serialization.XmlElementAttribute("RepeatWith", GetType(String)), System.Xml.Serialization.XmlElementAttribute("ReportName", GetType(String)), System.Xml.Serialization.XmlElementAttribute("Style", GetType(StyleType)), System.Xml.Serialization.XmlElementAttribute("ToolTip", GetType(String)), System.Xml.Serialization.XmlElementAttribute("Top", GetType(String), DataType:="normalizedString"), System.Xml.Serialization.XmlElementAttribute("Visibility", GetType(VisibilityType)), System.Xml.Serialization.XmlElementAttribute("Width", GetType(String), DataType:="normalizedString"), System.Xml.Serialization.XmlElementAttribute("ZIndex", GetType(System.UInt32)), System.Xml.Serialization.XmlChoiceIdentifierAttribute("ItemsElementName")> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlElementAttribute("ItemsElementName"), System.Xml.Serialization.XmlIgnoreAttribute()> _
         Public Property ItemsElementName() As ItemsChoiceType16()
            Get
               Return Me.itemsElementNameField
            End Get
            Set(ByVal value As ItemsChoiceType16())
               Me.itemsElementNameField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAttributeAttribute(DataType:="normalizedString")> _
         Public Property Name() As String
            Get
               Return Me.nameField
            End Get
            Set(ByVal value As String)
               Me.nameField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute(AnonymousType:=True)> _
      Public Enum SubreportTypeDataElementOutput
         Output
         NoOutput
         ContentsOnly
         [Auto]
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition", IncludeInSchema:=False)> _
      Public Enum ItemsChoiceType16
         <System.Xml.Serialization.XmlEnumAttribute("##any:")> Item
         Action
         Bookmark
         CustomProperties
         DataElementName
         DataElementOutput
         Height
         Label
         Left
         LinkToChild
         MergeTransactions
         NoRows
         Parameters
         RepeatWith
         ReportName
         Style
         ToolTip
         Top
         Visibility
         Width
         ZIndex
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class ImageType

         Private itemsField() As Object
         Private itemsElementNameField() As ItemsChoiceType15
         Private nameField As String
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("Action", GetType(ActionType)), System.Xml.Serialization.XmlElementAttribute("Bookmark", GetType(String)), System.Xml.Serialization.XmlElementAttribute("CustomProperties", GetType(CustomPropertiesType)), System.Xml.Serialization.XmlElementAttribute("DataElementName", GetType(String)), System.Xml.Serialization.XmlElementAttribute("DataElementOutput", GetType(ImageTypeDataElementOutput)), System.Xml.Serialization.XmlElementAttribute("Height", GetType(String), DataType:="normalizedString"), System.Xml.Serialization.XmlElementAttribute("Label", GetType(String)), System.Xml.Serialization.XmlElementAttribute("Left", GetType(String), DataType:="normalizedString"), System.Xml.Serialization.XmlElementAttribute("LinkToChild", GetType(String)), System.Xml.Serialization.XmlElementAttribute("MIMEType", GetType(String)), System.Xml.Serialization.XmlElementAttribute("RepeatWith", GetType(String)), System.Xml.Serialization.XmlElementAttribute("Sizing", GetType(ImageTypeSizing)), System.Xml.Serialization.XmlElementAttribute("Source", GetType(ImageTypeSource)), System.Xml.Serialization.XmlElementAttribute("Style", GetType(StyleType)), System.Xml.Serialization.XmlElementAttribute("ToolTip", GetType(String)), System.Xml.Serialization.XmlElementAttribute("Top", GetType(String), DataType:="normalizedString"), System.Xml.Serialization.XmlElementAttribute("Value", GetType(String)), System.Xml.Serialization.XmlElementAttribute("Visibility", GetType(VisibilityType)), System.Xml.Serialization.XmlElementAttribute("Width", GetType(String), DataType:="normalizedString"), System.Xml.Serialization.XmlElementAttribute("ZIndex", GetType(System.UInt32)), System.Xml.Serialization.XmlChoiceIdentifierAttribute("ItemsElementName")> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlElementAttribute("ItemsElementName"), System.Xml.Serialization.XmlIgnoreAttribute()> _
         Public Property ItemsElementName() As ItemsChoiceType15()
            Get
               Return Me.itemsElementNameField
            End Get
            Set(ByVal value As ItemsChoiceType15())
               Me.itemsElementNameField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAttributeAttribute(DataType:="normalizedString")> _
         Public Property Name() As String
            Get
               Return Me.nameField
            End Get
            Set(ByVal value As String)
               Me.nameField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute(AnonymousType:=True)> _
      Public Enum ImageTypeDataElementOutput
         Output
         NoOutput
         ContentsOnly
         [Auto]
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute(AnonymousType:=True)> _
      Public Enum ImageTypeSizing
         AutoSize
         Fit
         FitProportional
         Clip
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute(AnonymousType:=True)> _
      Public Enum ImageTypeSource
         [External]
         Embedded
         Database
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition", IncludeInSchema:=False)> _
      Public Enum ItemsChoiceType15
         <System.Xml.Serialization.XmlEnumAttribute("##any:")> Item
         Action
         Bookmark
         CustomProperties
         DataElementName
         DataElementOutput
         Height
         Label
         Left
         LinkToChild
         MIMEType
         RepeatWith
         Sizing
         [Source]
         Style
         ToolTip
         Top
         Value
         Visibility
         Width
         ZIndex
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class UserSortType

         Private itemsField() As Object
         Private itemsElementNameField() As ItemsChoiceType13
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("SortExpression", GetType(String)), System.Xml.Serialization.XmlElementAttribute("SortExpressionScope", GetType(String)), System.Xml.Serialization.XmlElementAttribute("SortTarget", GetType(String)), System.Xml.Serialization.XmlChoiceIdentifierAttribute("ItemsElementName")> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlElementAttribute("ItemsElementName"), System.Xml.Serialization.XmlIgnoreAttribute()> _
         Public Property ItemsElementName() As ItemsChoiceType13()
            Get
               Return Me.itemsElementNameField
            End Get
            Set(ByVal value As ItemsChoiceType13())
               Me.itemsElementNameField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition", IncludeInSchema:=False)> _
      Public Enum ItemsChoiceType13
         <System.Xml.Serialization.XmlEnumAttribute("##any:")> Item
         SortExpression
         SortExpressionScope
         SortTarget
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class ToggleImageType

         Private itemsField() As Object
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("InitialState", GetType(String))> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class TextboxType

         Private itemsField() As Object
         Private itemsElementNameField() As ItemsChoiceType14
         Private nameField As String
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("Action", GetType(ActionType)), System.Xml.Serialization.XmlElementAttribute("Bookmark", GetType(String)), System.Xml.Serialization.XmlElementAttribute("CanGrow", GetType(Boolean)), System.Xml.Serialization.XmlElementAttribute("CanShrink", GetType(Boolean)), System.Xml.Serialization.XmlElementAttribute("CustomProperties", GetType(CustomPropertiesType)), System.Xml.Serialization.XmlElementAttribute("DataElementName", GetType(String)), System.Xml.Serialization.XmlElementAttribute("DataElementOutput", GetType(TextboxTypeDataElementOutput)), System.Xml.Serialization.XmlElementAttribute("DataElementStyle", GetType(TextboxTypeDataElementStyle)), System.Xml.Serialization.XmlElementAttribute("Height", GetType(String), DataType:="normalizedString"), System.Xml.Serialization.XmlElementAttribute("HideDuplicates", GetType(String)), System.Xml.Serialization.XmlElementAttribute("Label", GetType(String)), System.Xml.Serialization.XmlElementAttribute("Left", GetType(String), DataType:="normalizedString"), System.Xml.Serialization.XmlElementAttribute("LinkToChild", GetType(String)), System.Xml.Serialization.XmlElementAttribute("RepeatWith", GetType(String)), System.Xml.Serialization.XmlElementAttribute("Style", GetType(StyleType)), System.Xml.Serialization.XmlElementAttribute("ToggleImage", GetType(ToggleImageType)), System.Xml.Serialization.XmlElementAttribute("ToolTip", GetType(String)), System.Xml.Serialization.XmlElementAttribute("Top", GetType(String), DataType:="normalizedString"), System.Xml.Serialization.XmlElementAttribute("UserSort", GetType(UserSortType)), System.Xml.Serialization.XmlElementAttribute("Value", GetType(String)), System.Xml.Serialization.XmlElementAttribute("Visibility", GetType(VisibilityType)), System.Xml.Serialization.XmlElementAttribute("Width", GetType(String), DataType:="normalizedString"), System.Xml.Serialization.XmlElementAttribute("ZIndex", GetType(System.UInt32)), System.Xml.Serialization.XmlChoiceIdentifierAttribute("ItemsElementName")> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlElementAttribute("ItemsElementName"), System.Xml.Serialization.XmlIgnoreAttribute()> _
         Public Property ItemsElementName() As ItemsChoiceType14()
            Get
               Return Me.itemsElementNameField
            End Get
            Set(ByVal value As ItemsChoiceType14())
               Me.itemsElementNameField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAttributeAttribute(DataType:="normalizedString")> _
         Public Property Name() As String
            Get
               Return Me.nameField
            End Get
            Set(ByVal value As String)
               Me.nameField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute(AnonymousType:=True)> _
      Public Enum TextboxTypeDataElementOutput
         Output
         NoOutput
         ContentsOnly
         [Auto]
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute(AnonymousType:=True)> _
      Public Enum TextboxTypeDataElementStyle
         [Auto]
         AttributeNormal
         ElementNormal
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition", IncludeInSchema:=False)> _
      Public Enum ItemsChoiceType14
         <System.Xml.Serialization.XmlEnumAttribute("##any:")> Item
         Action
         Bookmark
         CanGrow
         CanShrink
         CustomProperties
         DataElementName
         DataElementOutput
         DataElementStyle
         Height
         HideDuplicates
         Label
         Left
         LinkToChild
         RepeatWith
         Style
         ToggleImage
         ToolTip
         Top
         UserSort
         Value
         Visibility
         Width
         ZIndex
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class RectangleType

         Private itemsField() As Object
         Private itemsElementNameField() As ItemsChoiceType12
         Private nameField As String
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("Action", GetType(ActionType)), System.Xml.Serialization.XmlElementAttribute("Bookmark", GetType(String)), System.Xml.Serialization.XmlElementAttribute("CustomProperties", GetType(CustomPropertiesType)), System.Xml.Serialization.XmlElementAttribute("DataElementName", GetType(String)), System.Xml.Serialization.XmlElementAttribute("DataElementOutput", GetType(RectangleTypeDataElementOutput)), System.Xml.Serialization.XmlElementAttribute("Height", GetType(String), DataType:="normalizedString"), System.Xml.Serialization.XmlElementAttribute("Label", GetType(String)), System.Xml.Serialization.XmlElementAttribute("Left", GetType(String), DataType:="normalizedString"), System.Xml.Serialization.XmlElementAttribute("LinkToChild", GetType(String)), System.Xml.Serialization.XmlElementAttribute("PageBreakAtEnd", GetType(Boolean)), System.Xml.Serialization.XmlElementAttribute("PageBreakAtStart", GetType(Boolean)), System.Xml.Serialization.XmlElementAttribute("RepeatWith", GetType(String)), System.Xml.Serialization.XmlElementAttribute("ReportItems", GetType(ReportItemsType)), System.Xml.Serialization.XmlElementAttribute("Style", GetType(StyleType)), System.Xml.Serialization.XmlElementAttribute("ToolTip", GetType(String)), System.Xml.Serialization.XmlElementAttribute("Top", GetType(String), DataType:="normalizedString"), System.Xml.Serialization.XmlElementAttribute("Visibility", GetType(VisibilityType)), System.Xml.Serialization.XmlElementAttribute("Width", GetType(String), DataType:="normalizedString"), System.Xml.Serialization.XmlElementAttribute("ZIndex", GetType(System.UInt32)), System.Xml.Serialization.XmlChoiceIdentifierAttribute("ItemsElementName")> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlElementAttribute("ItemsElementName"), System.Xml.Serialization.XmlIgnoreAttribute()> _
         Public Property ItemsElementName() As ItemsChoiceType12()
            Get
               Return Me.itemsElementNameField
            End Get
            Set(ByVal value As ItemsChoiceType12())
               Me.itemsElementNameField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAttributeAttribute(DataType:="normalizedString")> _
         Public Property Name() As String
            Get
               Return Me.nameField
            End Get
            Set(ByVal value As String)
               Me.nameField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute(AnonymousType:=True)> _
      Public Enum RectangleTypeDataElementOutput
         Output
         NoOutput
         ContentsOnly
         [Auto]
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition", IncludeInSchema:=False)> _
      Public Enum ItemsChoiceType12
         <System.Xml.Serialization.XmlEnumAttribute("##any:")> Item
         Action
         Bookmark
         CustomProperties
         DataElementName
         DataElementOutput
         Height
         Label
         Left
         LinkToChild
         PageBreakAtEnd
         PageBreakAtStart
         RepeatWith
         ReportItems
         Style
         ToolTip
         Top
         Visibility
         Width
         ZIndex
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class LineType

         Private itemsField() As Object
         Private itemsElementNameField() As ItemsChoiceType11
         Private nameField As String
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("Action", GetType(ActionType)), System.Xml.Serialization.XmlElementAttribute("Bookmark", GetType(String)), System.Xml.Serialization.XmlElementAttribute("CustomProperties", GetType(CustomPropertiesType)), System.Xml.Serialization.XmlElementAttribute("DataElementName", GetType(String)), System.Xml.Serialization.XmlElementAttribute("DataElementOutput", GetType(LineTypeDataElementOutput)), System.Xml.Serialization.XmlElementAttribute("Height", GetType(String), DataType:="normalizedString"), System.Xml.Serialization.XmlElementAttribute("Label", GetType(String)), System.Xml.Serialization.XmlElementAttribute("Left", GetType(String), DataType:="normalizedString"), System.Xml.Serialization.XmlElementAttribute("LinkToChild", GetType(String)), System.Xml.Serialization.XmlElementAttribute("RepeatWith", GetType(String)), System.Xml.Serialization.XmlElementAttribute("Style", GetType(StyleType)), System.Xml.Serialization.XmlElementAttribute("ToolTip", GetType(String)), System.Xml.Serialization.XmlElementAttribute("Top", GetType(String), DataType:="normalizedString"), System.Xml.Serialization.XmlElementAttribute("Visibility", GetType(VisibilityType)), System.Xml.Serialization.XmlElementAttribute("Width", GetType(String), DataType:="normalizedString"), System.Xml.Serialization.XmlElementAttribute("ZIndex", GetType(System.UInt32)), System.Xml.Serialization.XmlChoiceIdentifierAttribute("ItemsElementName")> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlElementAttribute("ItemsElementName"), System.Xml.Serialization.XmlIgnoreAttribute()> _
         Public Property ItemsElementName() As ItemsChoiceType11()
            Get
               Return Me.itemsElementNameField
            End Get
            Set(ByVal value As ItemsChoiceType11())
               Me.itemsElementNameField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAttributeAttribute(DataType:="normalizedString")> _
         Public Property Name() As String
            Get
               Return Me.nameField
            End Get
            Set(ByVal value As String)
               Me.nameField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute(AnonymousType:=True)> _
      Public Enum LineTypeDataElementOutput
         Output
         NoOutput
         ContentsOnly
         [Auto]
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition", IncludeInSchema:=False)> _
      Public Enum ItemsChoiceType11
         <System.Xml.Serialization.XmlEnumAttribute("##any:")> Item
         Action
         Bookmark
         CustomProperties
         DataElementName
         DataElementOutput
         Height
         Label
         Left
         LinkToChild
         RepeatWith
         Style
         ToolTip
         Top
         Visibility
         Width
         ZIndex
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class QueryParameterType

         Private itemsField() As Object
         Private nameField As String
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("Value", GetType(String))> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAttributeAttribute()> _
         Public Property Name() As String
            Get
               Return Me.nameField
            End Get
            Set(ByVal value As String)
               Me.nameField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class QueryParametersType

         Private queryParameterField() As QueryParameterType
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlElementAttribute("QueryParameter")> _
         Public Property QueryParameter() As QueryParameterType()
            Get
               Return Me.queryParameterField
            End Get
            Set(ByVal value As QueryParameterType())
               Me.queryParameterField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class QueryType

         Private itemsField() As Object
         Private itemsElementNameField() As ItemsChoiceType2
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("CommandText", GetType(String)), System.Xml.Serialization.XmlElementAttribute("CommandType", GetType(QueryTypeCommandType)), System.Xml.Serialization.XmlElementAttribute("DataSourceName", GetType(String)), System.Xml.Serialization.XmlElementAttribute("QueryParameters", GetType(QueryParametersType)), System.Xml.Serialization.XmlElementAttribute("Timeout", GetType(System.UInt32)), System.Xml.Serialization.XmlChoiceIdentifierAttribute("ItemsElementName")> _
              Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlElementAttribute("ItemsElementName"), System.Xml.Serialization.XmlIgnoreAttribute()> _
         Public Property ItemsElementName() As ItemsChoiceType2()
            Get
               Return Me.itemsElementNameField
            End Get
            Set(ByVal value As ItemsChoiceType2())
               Me.itemsElementNameField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute(AnonymousType:=True)> _
      Public Enum QueryTypeCommandType
         [Text]
         StoredProcedure
         TableDirect
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition", IncludeInSchema:=False)> _
      Public Enum ItemsChoiceType2
         <System.Xml.Serialization.XmlEnumAttribute("##any:")> Item
         CommandText
         CommandType
         DataSourceName
         QueryParameters
         Timeout
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class FieldType

         Private itemsField() As Object
         Private itemsElementNameField() As ItemsChoiceType1
         Private nameField As String
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("DataField", GetType(String)), System.Xml.Serialization.XmlElementAttribute("Value", GetType(String)), System.Xml.Serialization.XmlChoiceIdentifierAttribute("ItemsElementName")> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlElementAttribute("ItemsElementName"), System.Xml.Serialization.XmlIgnoreAttribute()> _
         Public Property ItemsElementName() As ItemsChoiceType1()
            Get
               Return Me.itemsElementNameField
            End Get
            Set(ByVal value As ItemsChoiceType1())
               Me.itemsElementNameField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAttributeAttribute(DataType:="normalizedString")> _
         Public Property Name() As String
            Get
               Return Me.nameField
            End Get
            Set(ByVal value As String)
               Me.nameField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition", IncludeInSchema:=False)> _
      Public Enum ItemsChoiceType1
         <System.Xml.Serialization.XmlEnumAttribute("##any:")> Item
         DataField
         Value
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class FieldsType

         Private fieldField() As FieldType
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlElementAttribute("Field")> _
         Public Property Field() As FieldType()
            Get
               Return Me.fieldField
            End Get
            Set(ByVal value As FieldType())
               Me.fieldField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class DataSetType

         Private itemsField() As Object
         Private nameField As String
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("AccentSensitivity", GetType(DataSetTypeAccentSensitivity)), System.Xml.Serialization.XmlElementAttribute("CaseSensitivity", GetType(DataSetTypeCaseSensitivity)), System.Xml.Serialization.XmlElementAttribute("Collation", GetType(String)), System.Xml.Serialization.XmlElementAttribute("Fields", GetType(FieldsType)), System.Xml.Serialization.XmlElementAttribute("Filters", GetType(FiltersType)), System.Xml.Serialization.XmlElementAttribute("KanatypeSensitivity", GetType(DataSetTypeKanatypeSensitivity)), System.Xml.Serialization.XmlElementAttribute("Query", GetType(QueryType)), System.Xml.Serialization.XmlElementAttribute("WidthSensitivity", GetType(DataSetTypeWidthSensitivity))> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAttributeAttribute(DataType:="normalizedString")> _
         Public Property Name() As String
            Get
               Return Me.nameField
            End Get
            Set(ByVal value As String)
               Me.nameField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute(AnonymousType:=True)> _
      Public Enum DataSetTypeAccentSensitivity
         [True]
         [False]
         [Auto]
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute(AnonymousType:=True)> _
      Public Enum DataSetTypeCaseSensitivity
         [True]
         [False]
         [Auto]
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute(AnonymousType:=True)> _
      Public Enum DataSetTypeKanatypeSensitivity
         [True]
         [False]
         [Auto]
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute(AnonymousType:=True)> _
      Public Enum DataSetTypeWidthSensitivity
         [True]
         [False]
         [Auto]
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class DataSetsType

         Private dataSetField() As DataSetType
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlElementAttribute("DataSet")> _
         Public Property DataSet() As DataSetType()
            Get
               Return Me.dataSetField
            End Get
            Set(ByVal value As DataSetType())
               Me.dataSetField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class ConnectionPropertiesType

         Private itemsField() As Object
         Private itemsElementNameField() As ItemsChoiceType
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("ConnectString", GetType(String)), System.Xml.Serialization.XmlElementAttribute("DataProvider", GetType(String)), System.Xml.Serialization.XmlElementAttribute("IntegratedSecurity", GetType(Boolean)), System.Xml.Serialization.XmlElementAttribute("Prompt", GetType(String)), System.Xml.Serialization.XmlChoiceIdentifierAttribute("ItemsElementName")> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlElementAttribute("ItemsElementName"), System.Xml.Serialization.XmlIgnoreAttribute()> _
         Public Property ItemsElementName() As ItemsChoiceType()
            Get
               Return Me.itemsElementNameField
            End Get
            Set(ByVal value As ItemsChoiceType())
               Me.itemsElementNameField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition", IncludeInSchema:=False)> _
      Public Enum ItemsChoiceType
         <System.Xml.Serialization.XmlEnumAttribute("##any:")> Item
         ConnectString
         DataProvider
         IntegratedSecurity
         Prompt
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class DataSourceType

         Private itemsField() As Object
         Private nameField As String
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlAnyElementAttribute(), System.Xml.Serialization.XmlElementAttribute("ConnectionProperties", GetType(ConnectionPropertiesType)), System.Xml.Serialization.XmlElementAttribute("DataSourceReference", GetType(String)), System.Xml.Serialization.XmlElementAttribute("Transaction", GetType(Boolean))> _
         Public Property Items() As Object()
            Get
               Return Me.itemsField
            End Get
            Set(ByVal value As Object())
               Me.itemsField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAttributeAttribute()> _
         Public Property Name() As String
            Get
               Return Me.nameField
            End Get
            Set(ByVal value As String)
               Me.nameField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Diagnostics.DebuggerStepThroughAttribute(), System.ComponentModel.DesignerCategoryAttribute("code"), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition")> _
          Public Class DataSourcesType

         Private dataSourceField() As DataSourceType
         Private anyAttrField() As System.Xml.XmlAttribute

         <System.Xml.Serialization.XmlElementAttribute("DataSource")> _
         Public Property DataSource() As DataSourceType()
            Get
               Return Me.dataSourceField
            End Get
            Set(ByVal value As DataSourceType())
               Me.dataSourceField = value
            End Set
         End Property

         <System.Xml.Serialization.XmlAnyAttributeAttribute()> _
         Public Property AnyAttr() As System.Xml.XmlAttribute()
            Get
               Return Me.anyAttrField
            End Get
            Set(ByVal value As System.Xml.XmlAttribute())
               Me.anyAttrField = value
            End Set
         End Property
      End Class

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition", IncludeInSchema:=False)> _
      Public Enum ItemsChoiceType7
         <System.Xml.Serialization.XmlEnumAttribute("##any:")> Item
         BookmarkLink
         Parameters
         ReportName
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition", IncludeInSchema:=False)> _
      Public Enum ItemsChoiceType8
         <System.Xml.Serialization.XmlEnumAttribute("##any:")> Item
         BookmarkLink
         Drillthrough
         Hyperlink
         Label
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute(AnonymousType:=True)> _
      Public Enum ChartTypeChartElementOutput
         Output
         NoOutput
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute(AnonymousType:=True)> _
      Public Enum ChartTypeDataElementOutput
         Output
         NoOutput
         ContentsOnly
         [Auto]
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute(AnonymousType:=True)> _
      Public Enum ChartTypePalette
         [Default]
         EarthTones
         Excel
         GrayScale
         Light
         Pastel
         SemiTransparent
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute(AnonymousType:=True)> _
      Public Enum ChartTypeSubtype
         Stacked
         PercentStacked
         Plain
         Smooth
         Exploded
         Line
         SmoothLine
         HighLowClose
         OpenHighLowClose
         Candlestick
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute(AnonymousType:=True)> _
      Public Enum ChartTypeType
         Column
         Bar
         Line
         Pie
         Scatter
         Bubble
         Area
         Doughnut
         Stock
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition", IncludeInSchema:=False)> _
      Public Enum ItemsChoiceType27
         <System.Xml.Serialization.XmlEnumAttribute("##any:")> Item
         Action
         Bookmark
         CategoryAxis
         CategoryGroupings
         ChartData
         ChartElementOutput
         CustomProperties
         DataElementName
         DataElementOutput
         DataSetName
         Filters
         Height
         KeepTogether
         Label
         Left
         Legend
         LinkToChild
         NoRows
         PageBreakAtEnd
         PageBreakAtStart
         Palette
         PlotArea
         PointWidth
         SeriesGroupings
         Style
         Subtype
         ThreeDProperties
         Title
         ToolTip
         Top
         Type
         ValueAxis
         Visibility
         Width
         ZIndex
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition", IncludeInSchema:=False)> _
      Public Enum ItemsChoiceType30
         <System.Xml.Serialization.XmlEnumAttribute("##any:")> Item
         ColumnSpacing
         Columns
         Height
         ReportItems
         Style
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute(AnonymousType:=True)> _
      Public Enum ReportDataElementStyle
         AttributeNormal
         ElementNormal
      End Enum

      <System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.42"), System.SerializableAttribute(), System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition", IncludeInSchema:=False)> _
      Public Enum ItemsChoiceType37
         <System.Xml.Serialization.XmlEnumAttribute("##any:")> Item
         Author
         AutoRefresh
         Body
         BottomMargin
         Classes
         Code
         CodeModules
         CustomProperties
         DataElementName
         DataElementStyle
         DataSchema
         DataSets
         DataSources
         DataTransform
         Description
         EmbeddedImages
         InteractiveHeight
         InteractiveWidth
         Language
         LeftMargin
         PageFooter
         PageHeader
         PageHeight
         PageWidth
         ReportParameters
         RightMargin
         TopMargin
         Width
      End Enum

   End Namespace
End Namespace
