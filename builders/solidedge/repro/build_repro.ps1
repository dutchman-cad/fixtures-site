<#
Solid Edge repro-pair generator for cadmpeg issues. One command per issue:

  powershell.exe -NoProfile -STA -ExecutionPolicy Bypass -File .\build_repro.ps1 -Issue 1871

Builds that issue's before/after native pair (plus a STEP copy where the issue uses one) in YOUR Solid Edge,
into a NEW folder named se-repro-<issue>-<version> inside -OutputFolder, then strips your identity from the
files, scans them for it, opens them again, and deletes any pair that fails. Nothing existing is deleted or
overwritten. Your Windows user, computer name, registered owner/organization, full name and profile path are
read on this machine at run time, used in memory only, and are never written to any file or printed.
Please use a licensed copy. Windows PowerShell 5.1 with a Solid Edge that is not already running.
#>
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('1863', '1865', '1866', '1867', '1868', '1869', '1870', '1871', '1872', '1873', '1874')]
    [string]$Issue,
    [string]$OutputFolder = (Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'SolidEdgeRepro')
)
$ErrorActionPreference = 'Stop'
$ReproVersion = '2026.11.22.1'
$source = @'
Option Explicit On
Option Strict Off
Imports System
Imports System.IO
Imports Microsoft.VisualBasic
Imports System.Collections.Generic
Imports System.Web.Script.Serialization

Public Module ReproBuilder
    Public RunFolder As String
    Private programFolder As String
    Private apiTypes As New Dictionary(Of String, Type)()
    <System.Runtime.InteropServices.DllImport("oleaut32.dll", CharSet:=System.Runtime.InteropServices.CharSet.Unicode, PreserveSig:=False)>
    Private Sub LoadTypeLibEx(ByVal filename As String, ByVal kind As Integer, ByRef library As System.Runtime.InteropServices.ComTypes.ITypeLib)
    End Sub
    Private Sub ImportLibrary(ByVal filename As String)
        Try
Dim library As System.Runtime.InteropServices.ComTypes.ITypeLib = Nothing
LoadTypeLibEx(filename, 2, library)
Dim assembly As System.Reflection.Assembly = InteropSink.ConvertLibrary(library)
        For Each loaded As System.Reflection.Assembly In InteropSink.Cache.Values
            For Each item As Type In loaded.GetTypes()
If Not apiTypes.ContainsKey(item.Name) Then apiTypes.Add(item.Name, item)
            Next
        Next
        Catch ex As Exception
If Not ex.Data.Contains("FixtureLine") Then ex.Data("FixtureLine") = Erl()
            Throw
        End Try
    End Sub
    Private Sub InitializeInterop(ByVal app As Object)
        Try
If programFolder IsNot Nothing Then Return
Dim processId As Integer = CInt(app.ProcessID)
If processId = 0 Then Throw New Exception("Cannot find running Solid Edge process")
Dim folder As String = Path.GetDirectoryName(System.Diagnostics.Process.GetProcessById(processId).MainModule.FileName)
ImportLibrary(Path.Combine(folder, "Part.tlb"))
ImportLibrary(Path.Combine(folder, "constant.tlb"))
        programFolder = folder
        Catch ex As Exception
If Not ex.Data.Contains("FixtureLine") Then ex.Data("FixtureLine") = Erl()
            Throw
        End Try
    End Sub
    Private Function ApiType(ByVal name As String) As Type
        Try
If apiTypes.ContainsKey(name) Then Return apiTypes(name)
        ' Additional Solid Edge libraries are discovered under this running install.
        For Each filename As String In Directory.GetFiles(programFolder, "*.tlb")
ImportLibrary(filename)
If apiTypes.ContainsKey(name) Then Return apiTypes(name)
        Next
Throw New Exception("Installed type libraries have no type " & name)
        Catch ex As Exception
If Not ex.Data.Contains("FixtureLine") Then ex.Data("FixtureLine") = Erl()
            Throw
        End Try
    End Function
    Private Function ApiConstant(ByVal group As String, ByVal name As String) As Object
        Try
Return [Enum].Parse(ApiType(group), name, False)
        Catch ex As Exception
If Not ex.Data.Contains("FixtureLine") Then ex.Data("FixtureLine") = Erl()
            Throw
        End Try
    End Function
    Private Function TypedArray(ByVal name As String, ByVal items As Object()) As Array
        Try
Dim element As Type
        Select Case name
            Case "Double" : element = GetType(Double)
            Case "Int32" : element = GetType(Integer)
            Case "Object" : element = GetType(Object)
            Case Else : element = ApiType(name)
        End Select
If element IsNot GetType(Object) AndAlso Not element.IsInterface AndAlso Not element.IsPrimitive AndAlso Not element.IsEnum Then Throw New Exception("Expected an interface, numeric or Object array: " & name)
Dim result As Array = Array.CreateInstance(element, items.Length)
        For i As Integer = 0 To items.Length - 1
result.SetValue(If(element Is GetType(Integer), CType(Convert.ToInt32(items(i)), Object), items(i)), i)
        Next
Return result
        Catch ex As Exception
If Not ex.Data.Contains("FixtureLine") Then ex.Data("FixtureLine") = Erl()
            Throw
        End Try
    End Function
    Private Function PlaneSide(ByVal plane As Object, ByVal axis As Integer, ByVal side As Integer) As Integer
        Try
If side = 3 Then Return side
Dim normal(2) As Double
plane.GetNormal(normal)
If Math.Abs(normal(axis)) < 0.999999 Then Throw New Exception("Extrusion/offset axis is not normal to sketch plane")
Return If(normal(axis) < 0, 3-side, side)
        Catch ex As Exception
If Not ex.Data.Contains("FixtureLine") Then ex.Data("FixtureLine") = Erl()
            Throw
        End Try
    End Function
    Private Function Coordinate(ByVal profile As Object, ByVal x As Double, ByVal y As Double, ByVal z As Double, ByVal index As Integer) As Double
        Try
Dim u, v As Double
profile.Convert3DCoordinate(x, y, z, u, v)
Return If(index = 0, u, v)
        Catch ex As Exception
If Not ex.Data.Contains("FixtureLine") Then ex.Data("FixtureLine") = Erl()
            Throw
        End Try
    End Function
    Private Function BasePlane(ByVal doc As Object, ByVal name As String) As Object
        Try
        ' Identify defaults by measured normals, independent of template plane order.
Dim axis As Integer = If(name = "XY", 2, If(name = "XZ", 1, 0))
Dim matches As New List(Of Object)()
        For i As Integer = 1 To doc.RefPlanes.Count
Dim candidate As Object = doc.RefPlanes.Item(i)
Dim normal(2), root(2) As Double
candidate.GetNormal(normal)
candidate.GetRootPoint(root)
If Math.Abs(normal(axis)) > 0.999999 AndAlso Math.Abs(root(axis)) < 0.0000001 Then matches.Add(candidate)
        Next
If matches.Count <> 1 Then Throw New Exception("Expected one origin reference plane " & name & "; found " & matches.Count)
Return matches(0)
        Catch ex As Exception
If Not ex.Data.Contains("FixtureLine") Then ex.Data("FixtureLine") = Erl()
            Throw
        End Try
    End Function
    Private Function Unique(ByVal matches As List(Of Object), ByVal label As String) As Object
        Try
If matches.Count <> 1 Then Throw New Exception(label & " selector expected one match; found " & matches.Count)
Return matches(0)
        Catch ex As Exception
If Not ex.Data.Contains("FixtureLine") Then ex.Data("FixtureLine") = Erl()
            Throw
        End Try
    End Function
    Private Function EdgeAt(ByVal model As Object, ByVal x As Double, ByVal y As Double, ByVal z As Double, ByVal axis As Integer) As Object
        Try
Dim matches As New List(Of Object)()
Dim edges As Object = model.Body.Edges(ApiConstant("FeatureTopologyQueryTypeConstants", "igQueryAll"))
        For i As Integer = 1 To edges.Count
Dim edge As Object = edges.Item(i)
Dim low(2), high(2) As Double
Dim point() As Double = {x, y, z}
edge.GetRange(low, high)
Dim fits As Boolean = high(axis) - low(axis) > 0.0000001
            For k As Integer = 0 To 2
If point(k) < low(k) - 0.0000001 OrElse point(k) > high(k) + 0.0000001 Then fits = False
If k <> axis AndAlso high(k) - low(k) > 0.0000001 Then fits = False
            Next
If fits Then matches.Add(edge)
        Next
Return Unique(matches, "straight edge")
        Catch ex As Exception
If Not ex.Data.Contains("FixtureLine") Then ex.Data("FixtureLine") = Erl()
            Throw
        End Try
    End Function
    Private Function BindFlangeArguments(ByVal method As System.Reflection.MethodInfo, ByVal values As Object()) As Object()
Dim parameters As System.Reflection.ParameterInfo() = method.GetParameters()
If values.Length <> parameters.Length Then Throw New Exception("Flange argument count differs from installed signature")
Dim args(parameters.Length - 1) As Object
        For i As Integer = 0 To parameters.Length - 1
Dim p As System.Reflection.ParameterInfo = parameters(i)
Dim v As Object = values(i)
Dim target As Type = p.ParameterType
If target.IsByRef Then target = target.GetElementType()
If v IsNot Nothing AndAlso v IsNot System.Reflection.Missing.Value AndAlso target.IsEnum Then v = [Enum].ToObject(target, Convert.ToInt32(v))
            args(i) = v
        Next
Return args
    End Function
    Private Function InvokeFlange(ByVal flanges As Object, ByVal values As Object()) As Object
Dim method As System.Reflection.MethodInfo = ApiType("Flanges").GetMethod("Add")
Return method.Invoke(flanges, BindFlangeArguments(method, values))
    End Function
    Private Sub BlankProperties(ByVal doc As Object)
Dim sets As Object = doc.Properties
Dim summary As Object = doc.SummaryInfo
        summary.Author = ""
        summary.Company = ""
        summary.Manager = ""
        ' LastSavedBy is read-only through SummaryInfo; use the property sets.
        sets.Item("SummaryInformation").Item("Author").Value = ""
        sets.Item("SummaryInformation").Item("Last Author").Value = ""
        sets.Item("DocumentSummaryInformation").Item("Manager").Value = ""
        sets.Item("DocumentSummaryInformation").Item("Company").Value = ""
        ' Also scrub personal fields supplied by templates in ProjectInfo and
        ' ExtendedSummaryInformation, without inventing absent properties.
        For Each group As Object In sets
            For Each prop As Object In group
                ' Solid Edge 2026 lists unnamed placeholder entries (enumerated as Nothing) in
                ' ExtendedSummaryInformation; skip them, and never let one property stop the scrub.
If prop Is Nothing Then Continue For
                Try
Dim key As String = CStr(prop.Name).Replace(" ", "").Replace("-", "").ToLowerInvariant()
If New List(Of String)(New String() {"author", "company", "lastauthor", "lastsavedby", "manager", "username", "hardware"}).Contains(key) Then prop.Value = ""
                Catch ex As Exception
                    ' Read-only or unnamed entries are left as they are.
                End Try
            Next
        Next
    End Sub
    Private flangeSide As Integer=1
    Private flangeThickness As Object=1
    Private flangeZ As Double=0.002
    Private flangeSuccess As Boolean=False
    Private phase As String
    Private app As Object
    Private owned As Boolean
    Private serializer As New JavaScriptSerializer()
    Private rows As New List(Of Object)()
    Private Function Volume(ByVal doc As Object) As Double
        Dim v As Double=0
        For i As Integer=1 To doc.Models.Count
            v+=CDbl(doc.Models.Item(i).Body.Volume)
        Next
        Return v
    End Function
    Private Function Measure(ByVal doc As Object, ByVal asm As Boolean) As Dictionary(Of String,Object)
        Dim r As New Dictionary(Of String,Object)
        If asm Then
            r("occurrences")=CInt(doc.Occurrences.Count)
            Dim v As Double=0
            For i As Integer=1 To doc.Occurrences.Count
                v+=Volume(doc.Occurrences.Item(i).OccurrenceDocument)
            Next
            r("volume_m3")=v
            r("bodies")=CInt(doc.Occurrences.Count)
            r("features")=0
        Else
            r("volume_m3")=Volume(doc)
            r("bodies")=CInt(doc.Models.Count)
            Dim shells As Integer=0
            For i As Integer=1 To doc.Models.Count
                shells+=CInt(doc.Models.Item(i).Body.Shells.Count)
            Next
            r("shells")=shells
            Dim n As Integer=0
            ' Ordered per-type collections in this installation are document-wide aliases.
            ' Take the maximum per type across Models, avoiding duplicate global counts.
            Dim totals As New Dictionary(Of String,Integer)
            Dim counts As New Dictionary(Of String,Object)
            For i As Integer=1 To doc.Models.Count
                Dim m As Object=doc.Models.Item(i)
                For Each name As String In New String(){"ExtrudedProtrusions","ExtrudedCutouts","RevolvedProtrusions","Holes","Rounds","Chamfers","Patterns","MirrorCopies","Tabs","Flanges"}
                    Try
                        Dim c As Object=CallByName(m,name,CallType.Get)
                        Dim k As Integer=CInt(c.Count)
                        If k>0 Then
                            counts(i.ToString() & "/" & name)=k
                            If Not totals.ContainsKey(name) OrElse totals(name)<k Then totals(name)=k
                        End If
                    Catch
                    End Try
                Next
            Next
            For Each k As Integer In totals.Values
                n+=k
            Next
            r("features")=n
            r("feature_collections")=counts
            r("profilesets")=CInt(doc.ProfileSets.Count)
            r("occurrences")=0
        End If
        Return r
    End Function
    Private Sub Changed(ByVal doc As Object, ByVal before As Double, ByVal increase As Boolean)
        Dim after As Double=Volume(doc)
        If Double.IsNaN(after) OrElse Math.Abs(after-before)<1.0E-15 OrElse (increase AndAlso after<=before) Then Throw New Exception("feature-volume-check")
    End Sub
    Private Function NewDoc(ByVal kind As String, ByVal inch As Boolean) As Object
        phase="new-document"
        Dim label As String=If(inch,"ANSI Inch","ANSI Metric")
        Dim stem As String=If(inch,"ansi inch ","ansi metric ")
        Dim type As String=If(kind="psm","SheetMetal",If(kind="asm","Assembly","Part"))
        Dim template As String=Path.Combine(Path.GetDirectoryName(programFolder),"Template",label,stem & If(kind="psm","sheet metal",If(kind="asm","assembly","part")) & "." & kind)
        Dim doc As Object=app.Documents.Add("SolidEdge." & type & "Document",template)
        If kind<>"asm" Then doc.ModelingMode=2
        Return doc
    End Function
    Private Function Rect(ByVal doc As Object, ByVal plane As Object, ByVal a As Double(), ByVal b As Double(), ByVal c As Double(), ByVal d As Double(), Optional ByVal circle As Boolean=False) As Object
        phase="rectangle"
        Dim p As Object=doc.ProfileSets.Add().Profiles.Add(plane)
        Dim pts As Double()()={a,b,c,d}
        Dim lines(3) As Object
        For i As Integer=0 To 3
            Dim x As Double()=pts(i), y As Double()=pts((i+1) Mod 4)
            lines(i)=p.Lines2d.AddBy2Points(Coordinate(p,x(0),x(1),x(2),0),Coordinate(p,x(0),x(1),x(2),1),Coordinate(p,y(0),y(1),y(2),0),Coordinate(p,y(0),y(1),y(2),1))
        Next
        For i As Integer=0 To 3
            p.Relations2d.AddKeypoint(lines(i),1,lines((i+1) Mod 4),0)
        Next
        If circle Then p.Circles2d.AddByCenterRadius(Coordinate(p,0.02,0.015,0,0),Coordinate(p,0.02,0.015,0,1),0.005)
        If CInt(p.[End](1))<>0 Then Throw New Exception("profile-validation")
        Return p
    End Function
    Private Function XYRect(ByVal doc As Object, ByVal x As Double, ByVal y As Double, ByVal w As Double, ByVal h As Double, Optional ByVal z As Double=0, Optional ByVal circle As Boolean=False) As Object
        Dim plane As Object=BasePlane(doc,"XY")
        If z<>0 Then plane=doc.RefPlanes.AddParallelByDistance(plane,Math.Abs(z),If(z>0,2,1))
        Return Rect(doc,plane,New Double(){x,y,z},New Double(){x+w,y,z},New Double(){x+w,y+h,z},New Double(){x,y+h,z},circle)
    End Function
    Private Function Block(ByVal doc As Object, Optional ByVal x As Double=0, Optional ByVal depth As Double=0.02) As Object
        Dim p As Object=XYRect(doc,x,0,0.04,0.03)
        Dim arr As Array=TypedArray("Profile",New Object(){p})
        phase="base-extrude"
        Dim model As Object=doc.Models.AddFiniteExtrudedProtrusion(1,arr,PlaneSide(BasePlane(doc,"XY"),2,2),depth)
        p.Visible=False
        Return model
    End Function
    Private Function Hole(ByVal doc As Object, ByVal model As Object) As Object
        phase="hole"
        Dim plane As Object=doc.RefPlanes.AddParallelByDistance(BasePlane(doc,"XY"),0.02,2)
        Dim p As Object=doc.ProfileSets.Add().Profiles.Add(plane)
        p.Holes2d.Add(Coordinate(p,0.01,0.01,0.02,0),Coordinate(p,0.01,0.01,0.02,1))
        If CInt(p.[End](1))<>0 Then Throw New Exception("hole-profile-validation")
        Dim hd As Object=doc.HoleDataCollection.Add(ApiConstant("FeaturePropertyConstants","igRegularHole"),0.004,0.0,0.0,0.0,0.0,0)
        Dim before As Double=Volume(doc)
        Dim f As Object=model.Holes.AddThroughAll(p,1,hd)
        Changed(doc,before,False)
        p.Visible=False
        Return f
    End Function
    Private Sub AddOperation(ByVal doc As Object, ByVal model As Object, ByVal operation As String)
        Dim before As Double=Volume(doc)
        Dim f As Object=Nothing, p As Object=Nothing, plane As Object=Nothing, e As Object=Nothing
        phase=operation
        Select Case operation
        Case "cut"
            p=XYRect(doc,0.01,0.01,0.01,0.01,0.02)
            phase="cut"
            f=model.ExtrudedCutouts.AddFinite(p,1,1,0.005)
        Case "revolve"
            plane=BasePlane(doc,"XZ")
            p=Rect(doc,plane,New Double(){0.005,0,0.015},New Double(){0.01,0,0.015},New Double(){0.01,0,0.03},New Double(){0.005,0,0.03})
            Dim axisline As Object=p.Lines2d.AddBy2Points(Coordinate(p,0,0,0,0),Coordinate(p,0,0,0,1),Coordinate(p,0,0,0.04,0),Coordinate(p,0,0,0.04,1))
            Dim axis As Object=p.SetAxisOfRevolution(axisline)
            phase="revolve"
            f=model.RevolvedProtrusions.AddFinite(p,axis,2,2,Math.PI*2)
        Case "hole"
            f=Hole(doc,model)
        Case "fillet","chamfer"
            e=EdgeAt(model,0.04,0.03,0.01,2)
            Dim edges As Array=TypedArray("Edge",New Object(){e})
            If operation="fillet" Then
                Dim radii As Array=TypedArray("Double",New Object(){0.002})
                f=model.Rounds.Add(1,edges,radii)
            Else
                f=model.Chamfers.AddEqualSetback(1,edges,0.002)
            End If
        Case "pattern","mirror"
            ' One off-center additive boss is the seed; it is present in both sides.
            Dim seed As Object=model.ExtrudedProtrusions.Item(2)
            Dim seeds As Array=TypedArray("ExtrudedProtrusion",New Object(){seed})
            If operation="pattern" Then
                f=model.Patterns.AddByRectangular(1,seeds,BasePlane(doc,"XY"),2,2,0.01,0.01,0,ApiConstant("PatternOffsetTypeConstants","sePatternFixedOffset"),0)
            Else
                plane=doc.RefPlanes.AddParallelByDistance(BasePlane(doc,"YZ"),0.02,2)
                f=model.MirrorCopies.Add(plane,1,seeds)
            End If
        Case "flange"
            phase="flange-edge"
            e=EdgeAt(model,0.02,0.03,flangeZ,0)
            phase="flange-collection"
            Dim fc As Object=model.Flanges
            If fc Is Nothing Then Throw New Exception("flange-collection-unavailable")
            phase="flange-add"
            Dim missing As Object=System.Reflection.Missing.Value
            f=InvokeFlange(fc,New Object(){e,flangeSide,0.01,System.Reflection.Missing.Value,0.001,System.Reflection.Missing.Value,System.Reflection.Missing.Value,System.Reflection.Missing.Value,System.Reflection.Missing.Value,System.Reflection.Missing.Value,0.44,System.Reflection.Missing.Value,Math.PI/2,134,44,0.0})
        Case Else
            Throw New Exception("unknown-operation")
        End Select
        phase=operation & "-volume"
        Changed(doc,before,operation="revolve" OrElse operation="pattern" OrElse operation="mirror" OrElse operation="flange")
        If p IsNot Nothing Then p.Visible=False
    End Sub
    Private Sub Seed(ByVal doc As Object, ByVal model As Object)
        Dim p As Object=XYRect(doc,0.005,0.005,0.004,0.004,0.02)
        phase="seed-boss"
        Dim before As Double=Volume(doc)
        model.ExtrudedProtrusions.AddFinite(p,2,2,0.005)
        Changed(doc,before,True)
        p.Visible=False
    End Sub
    Private savedVolumes As New Dictionary(Of String,Double)
    Private Sub Save(ByVal doc As Object, ByVal basename As String, ByVal ext As String)
        BlankProperties(doc)
        phase="save-native"
        Dim v As Double=-1
        If ext<>"asm" Then v=Volume(doc)
        doc.SaveAs(Path.Combine(RunFolder,basename & "." & ext))
        savedVolumes(basename & "." & ext)=v
        ' The sketch pair is compared on its native files only.
        If basename.Contains("1869") Then Return
        phase="save-step"
        doc.SaveAs(Path.Combine(RunFolder,basename & ".stp"))
    End Sub
    ' Issue 1869: the circle sketch is consumed by a feature, because a sketch that no feature uses is not saved in the file.
    ' It sits on a reference plane at the height of the top face; the face itself is refused as a sketch target.
    Private Sub CircleBoss(ByVal doc As Object, ByVal model As Object)
        phase="boss-plane"
        Dim plane As Object=doc.RefPlanes.AddParallelByDistance(BasePlane(doc,"XY"),0.01,2)
        Dim p As Object=doc.ProfileSets.Add().Profiles.Add(plane)
        phase="boss-circle"
        p.Circles2d.AddByCenterRadius(Coordinate(p,0.012,0.007,0.01,0),Coordinate(p,0.012,0.007,0.01,1),0.005)
        If CInt(p.[End](1))<>0 Then Throw New Exception("circle-profile-validation")
        Dim before As Double=Volume(doc)
        phase="boss-extrude"
        model.ExtrudedProtrusions.AddFinite(p,2,2,0.005)
        Changed(doc,before,True)
        p.Visible=False
    End Sub
    Private Sub ExpectMm3(ByVal doc As Object, ByVal expected As Double)
        If Math.Abs(Volume(doc)*1.0E+9-expected)>0.001 Then Throw New Exception("volume-check")
    End Sub
    Private Sub Pair(ByVal issue As String, ByVal what As String, ByVal operation As String, Optional ByVal ext As String="par")
        Dim doc As Object=Nothing
        Dim basename As String="se-" & issue & "-" & what
        Dim row As New Dictionary(Of String,Object) From {{"pair",basename},{"status","failed"}}
        Try
            doc=NewDoc(ext,False)
            Dim model As Object=Nothing
            If operation="empty" Then
            ElseIf operation="flange" Then
                Dim p As Object=XYRect(doc,0,0,0.04,0.03)
                doc.SetGlobalParameter(ApiConstant("SheetMetalGlobalConstants","seSheetMetalGlobalMaterialThickness"),0.002)
                doc.SetGlobalParameter(ApiConstant("SheetMetalGlobalConstants","seSheetMetalGlobalBendRadius"),0.001)
                doc.SetGlobalParameter(ApiConstant("SheetMetalGlobalConstants","seSheetMetalGlobalNeutralFactor"),0.44)
                phase="base-tab"
                model=doc.Models.AddBaseTab(p,PlaneSide(BasePlane(doc,"XY"),2,2))
                p.Visible=False
            ElseIf operation="sketch" Then
                model=Block(doc,0,0.01)
                ExpectMm3(doc,12000)
            Else
                model=Block(doc)
                If operation="pattern" OrElse operation="mirror" Then Seed(doc,model)
            End If
            row("before")=Measure(doc,False)
            Save(doc,basename & "-before",ext)
            If operation="empty" Then
                model=Block(doc)
            ElseIf operation="bodies" Then
                doc.Models.AddBody(ApiConstant("AddBodyTypeConstants","igPartType"),"Block2")
                model=Block(doc,0.06)
                If CInt(doc.Models.Count)<>2 Then Throw New Exception("expected-two-models")
            ElseIf operation="units" Then
                doc.Close(False,System.Reflection.Missing.Value,False)
                doc=Nothing
                doc=NewDoc("par",True)
                model=Block(doc)
            ElseIf operation="sketch" Then
                CircleBoss(doc,model)
                ExpectMm3(doc,12000+Math.PI*25*5)
            Else
                If operation="flange" Then
                    doc.Close(False,System.Reflection.Missing.Value,False)
                    doc=Nothing
                    doc=NewDoc("psm",False)
                    Dim p As Object=XYRect(doc,0,0,0.04,0.03)
                    doc.SetGlobalParameter(ApiConstant("SheetMetalGlobalConstants","seSheetMetalGlobalMaterialThickness"),0.002)
                    doc.SetGlobalParameter(ApiConstant("SheetMetalGlobalConstants","seSheetMetalGlobalBendRadius"),0.001)
                    doc.SetGlobalParameter(ApiConstant("SheetMetalGlobalConstants","seSheetMetalGlobalNeutralFactor"),0.44)
                    model=doc.Models.AddBaseTab(p,PlaneSide(BasePlane(doc,"XY"),2,2))
                    p.Visible=False
                    doc.Activate()
                End If
                model=doc.Models.Item(1)
                AddOperation(doc,model,operation)
            End If
            row("after")=Measure(doc,False)
            Save(doc,basename & "-after",ext)
            row("status")="built"
            If operation="flange" Then flangeSuccess=True
        Catch ex As Exception
            row("failed_phase")=phase
            row("error_type")=ex.GetType().Name
            row("hresult")=ex.HResult
            Dim errors As New List(Of Object)
            Dim inner As Exception=ex
            While inner IsNot Nothing
                errors.Add(New Dictionary(Of String,Object) From {{"type",inner.GetType().Name},{"hresult",inner.HResult}})
                inner=inner.InnerException
            End While
            row("errors")=errors
        Finally
            If doc IsNot Nothing Then doc.Close(False,System.Reflection.Missing.Value,False)
            rows.Add(row)
            File.WriteAllText(Path.Combine(RunFolder,"build-results.json"),serializer.Serialize(rows))
        End Try
    End Sub
    Private Sub AssemblyPair()
        Dim doc As Object=Nothing
        Dim row As New Dictionary(Of String,Object) From {{"pair","se-1874-placements"},{"status","failed"}}
        Try
            doc=NewDoc("asm",False)
            phase="assembly-place-one"
            Dim o As Object=doc.Occurrences.AddByFilename(Path.Combine(RunFolder,"se-1863-stream-map-after.par"))
            o.PutTransform(0,0,0,0,0,0)
            row("before")=Measure(doc,True)
            Save(doc,"se-1874-placements-before","asm")
            phase="assembly-place-two"
            o=doc.Occurrences.AddByFilename(Path.Combine(RunFolder,"se-1863-stream-map-after.par"))
            o.PutTransform(0.06,0,0,0,0,0)
            row("after")=Measure(doc,True)
            Save(doc,"se-1874-placements-after","asm")
            row("status")="built"
        Catch ex As Exception
            row("failed_phase")=phase
            row("error_type")=ex.GetType().Name
            row("hresult")=ex.HResult
            Dim errors As New List(Of Object)
            Dim inner As Exception=ex
            While inner IsNot Nothing
                errors.Add(New Dictionary(Of String,Object) From {{"type",inner.GetType().Name},{"hresult",inner.HResult}})
                inner=inner.InnerException
            End While
            row("errors")=errors
        Finally
            If doc IsNot Nothing Then doc.Close(False,System.Reflection.Missing.Value,False)
            rows.Add(row)
            File.WriteAllText(Path.Combine(RunFolder,"build-results.json"),serializer.Serialize(rows))
        End Try
    End Sub
    Private Function StartApp() As Object
        Dim existing As New List(Of Integer)
        For Each proc As System.Diagnostics.Process In System.Diagnostics.Process.GetProcessesByName("Edge")
            existing.Add(proc.Id)
        Next
        Dim a As Object=Activator.CreateInstance(Type.GetTypeFromProgID("SolidEdge.Application"))
        owned=Not existing.Contains(CInt(a.ProcessID))
        If Not owned Then Throw New Exception("separate-instance-required")
        a.Visible=True
        a.DisplayAlerts=False
        Return a
    End Function
    Public Function Failures() As Integer
        Dim n As Integer=0
        For Each row As Object In rows
            If CStr(row("status"))<>"built" Then n+=1
        Next
        Return n
    End Function
    Public Function SavedFiles() As String()
        Dim names As New List(Of String)()
        For Each key As String In savedVolumes.Keys
            names.Add(key)
        Next
        Return names.ToArray()
    End Function
    ' Builds the pairs for one cadmpeg issue into a fresh folder.
    Public Sub Run(ByVal output As String, ByVal issue As String)
        RunFolder=output
        If Directory.Exists(output) Then Throw New Exception("Fresh output required")
        Directory.CreateDirectory(output)
        Try
            app=StartApp()
            InitializeInterop(app)
            File.WriteAllText(Path.Combine(output,"instance.json"),serializer.Serialize(New Dictionary(Of String,Object) From {{"separate",True},{"version",CStr(app.Version)}}))
            Select Case issue
            Case "1863" : Pair("1863","stream-map","empty")
            Case "1865" : Pair("1865","bodies","bodies")
            Case "1866" : Pair("1866","bodies","bodies")
            Case "1867" : Pair("1867","units","units")
            Case "1868" : Pair("1868","feature-tree","cut")
            Case "1869" : Pair("1869","profile","sketch")
            Case "1870" : Pair("1870","extrude-revolve","revolve")
            Case "1871"
                Pair("1871","hole","hole")
                Pair("1871","fillet","fillet")
                Pair("1871","chamfer","chamfer")
            Case "1872"
                Pair("1872","pattern","pattern")
                Pair("1872","mirror","mirror")
            Case "1873" : Pair("1873","flange","flange","psm")
            Case "1874"
                ' The assembly places the part from the 1863 pair; that pair is built (and checked) first.
                Pair("1863","stream-map","empty")
                AssemblyPair()
            Case Else : Throw New Exception("unknown-issue")
            End Select
        Finally
            If owned AndAlso app IsNot Nothing AndAlso CInt(app.Documents.Count)=0 Then
                app.Quit()
            ElseIf app IsNot Nothing Then
                File.WriteAllText(Path.Combine(output,"instance-left-open.txt"),"Documents remain; no untracked documents closed.")
            End If
        End Try
    End Sub
    ' Opens each saved file again (after the privacy pass) and compares it with what was measured before saving.
    ' Returns the file names that do not reopen as built.
    Public Function Verify(ByVal folder As String, ByVal names As String()) As String()
        RunFolder=folder
        Dim failed As New List(Of String)()
        app=StartApp()
        Try
            For Each fileName As String In names
                Dim doc As Object=Nothing
                Try
                    doc=app.Documents.Open(Path.Combine(folder,fileName))
                    If fileName.EndsWith(".asm") Then
                        If CInt(doc.Occurrences.Count)<1 Then Throw New Exception("reopen-occurrences")
                    Else
                        Dim measured As Double=Volume(doc)
                        Dim expected As Double=savedVolumes(fileName)
                        If Math.Abs(measured-expected)>Math.Max(1.0E-12,Math.Abs(expected)*0.000001) Then Throw New Exception("reopen-volume")
                    End If
                Catch ex As Exception
                    failed.Add(fileName)
                Finally
                    If doc IsNot Nothing Then doc.Close(False,System.Reflection.Missing.Value,False)
                End Try
            Next
        Finally
            If owned AndAlso CInt(app.Documents.Count)=0 Then app.Quit()
        End Try
        Return failed.ToArray()
    End Function
End Module
Public Class InteropSink
    Implements System.Runtime.InteropServices.ITypeLibImporterNotifySink
    Public Shared Cache As New Dictionary(Of String, System.Reflection.Assembly)()
    Public Sub ReportEvent(ByVal kind As System.Runtime.InteropServices.ImporterEventKind, ByVal code As Integer, ByVal message As String) Implements System.Runtime.InteropServices.ITypeLibImporterNotifySink.ReportEvent
    End Sub
    Public Function ResolveRef(ByVal library As Object) As System.Reflection.Assembly Implements System.Runtime.InteropServices.ITypeLibImporterNotifySink.ResolveRef
Return ConvertLibrary(DirectCast(library, System.Runtime.InteropServices.ComTypes.ITypeLib))
    End Function
    Public Shared Function ConvertLibrary(ByVal library As System.Runtime.InteropServices.ComTypes.ITypeLib) As System.Reflection.Assembly
Dim name As String = System.Runtime.InteropServices.Marshal.GetTypeLibName(library)
If Cache.ContainsKey(name) Then Return Cache(name)
Dim converter As New System.Runtime.InteropServices.TypeLibConverter()
Dim result As System.Reflection.Assembly = converter.ConvertTypeLibToAssembly(library, "Interop." & name & ".dll", System.Runtime.InteropServices.TypeLibImporterFlags.None, New InteropSink(), Nothing, Nothing, "Interop." & name, Nothing)
        Cache.Add(name, result)
Return result
    End Function
End Class

'@

# Privacy pass: written for the C# 5 compiler that Windows PowerShell 5.1 uses. The identity terms arrive as arguments at run time.
$privacy = @'
using System;
using System.Collections.Generic;
using System.IO;
using System.IO.Compression;
using System.Runtime.InteropServices;
using System.Runtime.InteropServices.ComTypes;
using System.Text;
using System.Text.RegularExpressions;

public static class ReproPrivacy {
  [ComImport, Guid("0000000b-0000-0000-C000-000000000046"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
  public interface IStorage {
    void CreateStream(string n, uint m, uint r1, uint r2, out IStream s); void OpenStream(string n, IntPtr r1, uint m, uint r2, out IStream s);
    void CreateStorage(string n, uint m, uint r1, uint r2, out IStorage s); void OpenStorage(string n, IStorage p, uint m, IntPtr x, uint r, out IStorage s);
    void CopyTo(uint c, IntPtr i, IntPtr x, IStorage d); void MoveElementTo(string n, IStorage d, string nn, uint f); void Commit(uint f); void Revert();
    void EnumElements(uint r1, IntPtr r2, uint r3, out IEnumSTATSTG e); void DestroyElement(string n); void RenameElement(string o, string n);
    void SetElementTimes(string n, IntPtr c, IntPtr a, IntPtr m); void SetClass(ref Guid c); void SetStateBits(uint b, uint m); void Stat(out System.Runtime.InteropServices.ComTypes.STATSTG s, uint f);
  }
  [ComImport, Guid("0000000d-0000-0000-C000-000000000046"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
  public interface IEnumSTATSTG { [PreserveSig] int Next(uint c, [Out, MarshalAs(UnmanagedType.LPArray)] System.Runtime.InteropServices.ComTypes.STATSTG[] e, out uint f); void Skip(uint c); void Reset(); void Clone(out IEnumSTATSTG e); }
  [DllImport("ole32.dll")] static extern int StgCreateDocfile([MarshalAs(UnmanagedType.LPWStr)] string n, uint m, uint r, out IStorage s);
  [DllImport("ole32.dll")] static extern int StgOpenStorage([MarshalAs(UnmanagedType.LPWStr)] string n, IntPtr p, uint m, IntPtr x, uint r, out IStorage s);
  const uint RW_EXCL = 0x12;  // read/write, exclusive
  const uint RD_EXCL = 0x10;  // read, exclusive

  public sealed class Needle { public byte[] Bytes; public int Width; public int Category; }

  static bool Word(byte b) { return (b >= 48 && b <= 57) || (b >= 65 && b <= 90) || (b >= 97 && b <= 122); }
  static bool Same(byte[] a, byte[] b) { if (a.Length != b.Length) return false; for (int i = 0; i < a.Length; i++) if (a[i] != b[i]) return false; return true; }

  // Every term in the encodings a CAD file may hold it in: Latin-1, UTF-8 and UTF-16LE, matched case-insensitively.
  static List<Needle> Needles(string[] terms, int[] cats) {
    List<Needle> list = new List<Needle>();
    for (int t = 0; t < terms.Length; t++) {
      string low = terms[t].ToLowerInvariant();
      bool latin = true;
      foreach (char c in low) if (c > 255) latin = false;
      byte[] l1 = latin ? Encoding.GetEncoding(28591).GetBytes(low) : null;
      byte[] u8 = Encoding.UTF8.GetBytes(low);
      if (l1 != null) list.Add(new Needle { Bytes = l1, Width = 1, Category = cats[t] });
      if (l1 == null || !Same(l1, u8)) list.Add(new Needle { Bytes = u8, Width = 1, Category = cats[t] });
      list.Add(new Needle { Bytes = Encoding.Unicode.GetBytes(low), Width = 2, Category = cats[t] });
    }
    return list;
  }

  // A match counts only when the characters around it are not letters or digits, so a short name never
  // rewrites part of an ordinary word or of binary data. write=true replaces a hit with same-length filler.
  static int Patch(byte[] d, Needle nd, bool write) {
    byte[] from = nd.Bytes; int w = nd.Width; int hits = 0;
    for (int i = 0; i + from.Length <= d.Length; i++) {
      byte first = d[i]; if (first >= 65 && first <= 90) first = (byte)(first + 32);
      if (first != from[0]) continue;
      if (i - w >= 0 && Word(d[i - w]) && (w == 1 || d[i - w + 1] == 0)) continue;
      int after = i + from.Length;
      if (after + w <= d.Length && Word(d[after]) && (w == 1 || d[after + 1] == 0)) continue;
      bool hit = true;
      for (int j = 0; j < from.Length && hit; j++) { byte a = d[i + j], b = from[j]; if (a != b && !(a >= 65 && a <= 90 && a + 32 == b)) hit = false; }
      if (!hit) continue;
      hits++;
      if (write) {
        for (int j = 0; j < from.Length; j++) d[i + j] = (byte)((w == 2 && j % 2 == 1) ? 0 : (j < w ? 'x' : '0'));
        i += from.Length - 1;
      }
    }
    return hits;
  }

  static void CountAll(byte[] d, List<Needle> ns, int[] counts) { foreach (Needle n in ns) counts[n.Category] += Patch(d, n, false); }

  // Zlib members inside a stream (CAD files compress large parts of their streams), each bounded in size.
  static void ScanBytes(byte[] d, List<Needle> ns, int[] counts, ref long budget) {
    CountAll(d, ns, counts);
    for (int i = 0; i + 6 < d.Length && budget > 0; i++) {
      if (d[i] != 0x78 || ((d[i] << 8) | d[i + 1]) % 31 != 0) continue;
      MemoryStream outp = new MemoryStream();
      try {
        using (MemoryStream ms = new MemoryStream(d, i + 2, d.Length - i - 2))
        using (DeflateStream z = new DeflateStream(ms, CompressionMode.Decompress)) {
          byte[] buf = new byte[65536]; int n;
          while ((n = z.Read(buf, 0, buf.Length)) > 0) { outp.Write(buf, 0, n); if (outp.Length > 67108864) break; }
        }
      } catch (Exception) { }
      if (outp.Length >= 8) { budget -= outp.Length; CountAll(outp.ToArray(), ns, counts); }
    }
  }

  static List<KeyValuePair<string, int>> Entries(IStorage st) {
    List<KeyValuePair<string, int>> names = new List<KeyValuePair<string, int>>();
    IEnumSTATSTG en; st.EnumElements(0, IntPtr.Zero, 0, out en);
    System.Runtime.InteropServices.ComTypes.STATSTG[] one = new System.Runtime.InteropServices.ComTypes.STATSTG[1]; uint got;
    while (en.Next(1, one, out got) == 0 && got == 1) names.Add(new KeyValuePair<string, int>(one[0].pwcsName, one[0].type));
    Marshal.ReleaseComObject(en);
    return names;
  }

  static byte[] ReadAll(IStream s) {
    System.Runtime.InteropServices.ComTypes.STATSTG ss; s.Stat(out ss, 1);
    byte[] data = new byte[ss.cbSize]; byte[] chunk = new byte[1048576]; int off = 0;
    IntPtr got = Marshal.AllocHGlobal(4);
    try {
      s.Seek(0, 0, IntPtr.Zero);
      while (off < data.Length) {
        int want = Math.Min(chunk.Length, data.Length - off);
        s.Read(chunk, want, got); int n = Marshal.ReadInt32(got);
        if (n <= 0) break;
        Buffer.BlockCopy(chunk, 0, data, off, n); off += n;
      }
    } finally { Marshal.FreeHGlobal(got); }
    if (off != data.Length) throw new Exception("stream read");
    return data;
  }

  static void ScanStorage(IStorage st, List<Needle> ns, int[] counts, ref long budget) {
    foreach (KeyValuePair<string, int> kv in Entries(st)) {
      CountAll(Encoding.Unicode.GetBytes(kv.Key), ns, counts);
      if (kv.Value == 1) {
        IStorage sub; st.OpenStorage(kv.Key, null, RD_EXCL, IntPtr.Zero, 0, out sub);
        try { ScanStorage(sub, ns, counts, ref budget); } finally { Marshal.ReleaseComObject(sub); }
      } else if (kv.Value == 2) {
        IStream s; st.OpenStream(kv.Key, IntPtr.Zero, RD_EXCL, 0, out s);
        try { ScanBytes(ReadAll(s), ns, counts, ref budget); } finally { Marshal.ReleaseComObject(s); }
      }
    }
  }

  // Identity hits per category in a compound file: the raw bytes, every storage and stream name, every stream, and every zlib member inside a stream.
  public static int[] Scan(string path, string[] terms, int[] cats, int categoryCount) {
    List<Needle> ns = Needles(terms, cats); int[] counts = new int[categoryCount]; long budget = 536870912L;
    CountAll(File.ReadAllBytes(path), ns, counts);
    IStorage st; int hr = StgOpenStorage(path, IntPtr.Zero, RD_EXCL, IntPtr.Zero, 0, out st);
    if (hr != 0) throw new Exception("not a compound file");
    try { ScanStorage(st, ns, counts, ref budget); } finally { Marshal.ReleaseComObject(st); }
    return counts;
  }

  // Identity hits per category in any other file (a STEP copy, the results file, the log) and in a plain name.
  public static int[] CountFile(string path, string[] terms, int[] cats, int categoryCount) {
    int[] counts = new int[categoryCount]; CountAll(File.ReadAllBytes(path), Needles(terms, cats), counts); return counts;
  }
  public static int[] CountText(string text, string[] terms, int[] cats, int categoryCount) {
    int[] counts = new int[categoryCount]; CountAll(Encoding.UTF8.GetBytes(text), Needles(terms, cats), counts); return counts;
  }

  // Blank the author, last-author and company properties of the two standard property sets.
  public static int BlankIdentity(string file) {
    IStorage st;
    if (StgOpenStorage(file, IntPtr.Zero, RW_EXCL, IntPtr.Zero, 0, out st) != 0) throw new Exception("identity property storage");
    int count = 0;
    try {
      foreach (string name in new string[] { "\u0005SummaryInformation", "\u0005DocumentSummaryInformation" }) {
        IStream stream = null;
        try { st.OpenStream(name, IntPtr.Zero, RW_EXCL, 0, out stream); } catch (COMException) { continue; }
        try {
          byte[] b = ReadAll(stream);
          if (b.Length < 48) continue;
          int section = (int)BitConverter.ToUInt32(b, 44);
          if (section < 0 || section + 8 > b.Length) throw new Exception("identity property bounds");
          int n = (int)BitConverter.ToUInt32(b, section + 4);
          if (n < 0 || n > 1000 || section + 8 + 8 * n > b.Length) throw new Exception("identity property bounds");
          for (int i = 0; i < n; i++) {
            uint id = BitConverter.ToUInt32(b, section + 8 + 8 * i);
            if (!(name == "\u0005SummaryInformation" ? (id == 4 || id == 8) : (id == 15))) continue;
            int p = section + (int)BitConverter.ToUInt32(b, section + 12 + 8 * i);
            if (p < 0 || p + 8 > b.Length) throw new Exception("identity property bounds");
            uint vt = BitConverter.ToUInt32(b, p); int len = (int)BitConverter.ToUInt32(b, p + 4);
            if (vt != 30 && vt != 31) continue;
            int bytes = len * (vt == 31 ? 2 : 1);
            if (len < 0 || p + 8 + bytes > b.Length) throw new Exception("identity property bounds");
            if (len < 1) continue;
            Array.Clear(b, p + 8, bytes); Buffer.BlockCopy(BitConverter.GetBytes(1), 0, b, p + 4, 4); count++;
          }
          stream.Seek(0, 0, IntPtr.Zero); stream.Write(b, b.Length, IntPtr.Zero); stream.Commit(0);
        } finally { Marshal.ReleaseComObject(stream); }
      }
      st.Commit(0);
    } finally { Marshal.ReleaseComObject(st); }
    return count;
  }

  static int Replace(IStorage st, List<Needle> ns) {
    int total = 0;
    foreach (KeyValuePair<string, int> kv in Entries(st)) {
      if (kv.Value == 1) {
        IStorage sub; st.OpenStorage(kv.Key, null, RW_EXCL, IntPtr.Zero, 0, out sub);
        try { total += Replace(sub, ns); sub.Commit(0); } finally { Marshal.ReleaseComObject(sub); }
      } else if (kv.Value == 2) {
        IStream s; st.OpenStream(kv.Key, IntPtr.Zero, RW_EXCL, 0, out s);
        try {
          byte[] data = ReadAll(s); int n = 0;
          foreach (Needle nd in ns) n += Patch(data, nd, true);
          if (n > 0) { s.Seek(0, 0, IntPtr.Zero); s.Write(data, data.Length, IntPtr.Zero); s.Commit(0); total += n; }
        } finally { Marshal.ReleaseComObject(s); }
      }
    }
    return total;
  }

  // Overwrite every stream named JVisibleData, at any storage depth, with zeros of the same length (removing it would make the file unopenable). Returns how many were zeroed.
  static int ZeroVisible(IStorage st) {
    int total = 0;
    foreach (KeyValuePair<string, int> kv in Entries(st)) {
      if (kv.Value == 1) {
        IStorage sub; st.OpenStorage(kv.Key, null, RW_EXCL, IntPtr.Zero, 0, out sub);
        try { total += ZeroVisible(sub); sub.Commit(0); } finally { Marshal.ReleaseComObject(sub); }
      } else if (kv.Value == 2 && string.Equals(kv.Key, "JVisibleData", StringComparison.OrdinalIgnoreCase)) {
        IStream s; st.OpenStream(kv.Key, IntPtr.Zero, RW_EXCL, 0, out s);
        try {
          byte[] data = ReadAll(s);
          Array.Clear(data, 0, data.Length);
          s.Seek(0, 0, IntPtr.Zero); s.Write(data, data.Length, IntPtr.Zero); s.Commit(0); total++;
        } finally { Marshal.ReleaseComObject(s); }
      }
    }
    return total;
  }
  public static int BlankVisible(string path) {
    IStorage st;
    if (StgOpenStorage(path, IntPtr.Zero, RW_EXCL, IntPtr.Zero, 0, out st) != 0) throw new Exception("not a compound file");
    int n;
    try { n = ZeroVisible(st); st.Commit(0); } finally { Marshal.ReleaseComObject(st); }
    return n;
  }

  // Replace this machine's identity terms inside every stream with same-length filler, then copy the file into a
  // fresh compound file so stale bytes from earlier saves are dropped. Returns the number of replacements.
  public static int Strip(string path, string[] terms, int[] cats) {
    List<Needle> ns = Needles(terms, cats);
    IStorage st; int hr = StgOpenStorage(path, IntPtr.Zero, RW_EXCL, IntPtr.Zero, 0, out st);
    if (hr != 0) throw new Exception("not a compound file");
    int n = Replace(st, ns); st.Commit(0);
    string tmp = path + ".compact"; IStorage fresh;
    hr = StgCreateDocfile(tmp, 0x1012, 0, out fresh);
    if (hr != 0) { Marshal.ReleaseComObject(st); throw new Exception("compact failed"); }
    st.CopyTo(0, IntPtr.Zero, IntPtr.Zero, fresh);
    System.Runtime.InteropServices.ComTypes.STATSTG meta; st.Stat(out meta, 1); Guid clsid = meta.clsid; fresh.SetClass(ref clsid);
    fresh.Commit(0); Marshal.ReleaseComObject(fresh); Marshal.ReleaseComObject(st);
    File.Delete(path); File.Move(tmp, path);
    return n;
  }
}

// STEP copy: keep the geometry and reference graph; blank every string in the data section, drop comments, fix dates and times, write a neutral header.
public static class StepNeutral {
  public static string Clean(string s, string name) {
    StringBuilder nc = new StringBuilder(); bool str = false, comment = false;
    for (int i = 0; i < s.Length; i++) {
      char c = s[i];
      if (comment) { if (c == '*' && i + 1 < s.Length && s[i + 1] == '/') { comment = false; i++; nc.Append(' '); } continue; }
      if (!str && c == '/' && i + 1 < s.Length && s[i + 1] == '*') { comment = true; i++; continue; }
      nc.Append(c);
      if (c == '\'') { if (str && i + 1 < s.Length && s[i + 1] == '\'') { nc.Append(s[++i]); } else str = !str; }
    }
    if (str || comment) throw new Exception("step-lexical-framing");
    string text = nc.ToString();
    Match schema = Regex.Match(text, @"FILE_SCHEMA\s*\((.*?)\)\s*;", RegexOptions.Singleline | RegexOptions.IgnoreCase);
    if (!schema.Success || !Regex.IsMatch(schema.Groups[1].Value, @"^\s*\(\s*'[A-Za-z0-9_ {}.]+'\s*\)\s*$")) throw new Exception("step-schema-framing");
    int begin = text.IndexOf("DATA;", StringComparison.OrdinalIgnoreCase), end = text.LastIndexOf("ENDSEC;", StringComparison.OrdinalIgnoreCase);
    if (begin < 0 || end <= begin) throw new Exception("step-data-framing");
    string data = text.Substring(begin + 5, end - begin - 5);
    StringBuilder clean = new StringBuilder();
    for (int i = 0; i < data.Length; i++) {
      if (data[i] != '\'') { clean.Append(data[i]); continue; }
      clean.Append("''");
      bool closed = false;
      while (++i < data.Length) { if (data[i] == '\'') { if (i + 1 < data.Length && data[i + 1] == '\'') { i++; continue; } closed = true; break; } }
      if (!closed) throw new Exception("step-data-string-framing");
    }
    data = clean.ToString();
    data = Regex.Replace(data, @"\bCALENDAR_DATE\s*\(\s*\d+\s*,\s*\d+\s*,\s*\d+\s*\)", "CALENDAR_DATE(2026,1,1)", RegexOptions.IgnoreCase);
    data = Regex.Replace(data, @"\bLOCAL_TIME\s*\(\s*[^,()]+\s*,\s*[^,()]+\s*,\s*[^,()]+\s*,", "LOCAL_TIME(0,0,0.,", RegexOptions.IgnoreCase);
    data = Regex.Replace(data, @"\bCOORDINATED_UNIVERSAL_TIME_OFFSET\s*\(\s*[^,()]+\s*,\s*[^,()]+\s*,\s*[^,()]+\s*\)", "COORDINATED_UNIVERSAL_TIME_OFFSET(0,0,.AHEAD.)", RegexOptions.IgnoreCase);
    return "ISO-10303-21;\nHEADER;\nFILE_DESCRIPTION(('purpose-made repro'),'2;1');\nFILE_NAME('" + name + "','2026-01-01T00:00:00',(''),(''),'Fixture Builder','Fixture Builder','');\nFILE_SCHEMA(" + schema.Groups[1].Value + ");\nENDSEC;\nDATA;" + data + "ENDSEC;\nEND-ISO-10303-21;\n";
  }
}
'@
Add-Type -TypeDefinition $privacy -Language CSharp -ReferencedAssemblies 'System.dll', 'System.Core.dll'

# ---------------------------------------------------------------------------------------------------------------
# Run: new folder, build, privacy pass, reopen, final scan. Console output and files carry counts and the run
# folder NAME only, never a path, a user name or a machine name.
$categoryNames = @('windows_user', 'profile_path', 'computer_name', 'registered_owner', 'registered_organization', 'full_name')
$identity = New-Object 'System.Collections.Generic.List[object]'
function Add-Term([int]$category, $value) {
    if ($value -isnot [string]) { return }
    $text = $value.Trim()
    if ($text.Length -lt 3) { return }
    foreach ($known in $script:identity) { if ($known.Term -ieq $text) { return } }
    $script:identity.Add([pscustomobject]@{ Category = $category; Term = $text })
}
# Read on this machine, kept in memory, never written anywhere.
Add-Term 0 $env:USERNAME
Add-Term 1 $env:USERPROFILE
if ($env:USERNAME) { Add-Term 1 ('Users\' + $env:USERNAME) }
Add-Term 2 $env:COMPUTERNAME
$windowsKey = Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -ErrorAction SilentlyContinue
if ($windowsKey) { Add-Term 3 $windowsKey.RegisteredOwner; Add-Term 4 $windowsKey.RegisteredOrganization }
$fullName = $null
try { $fullName = (Get-WmiObject Win32_UserAccount -Filter ("Name='" + ([string]$env:USERNAME).Replace("'", "''") + "' AND LocalAccount=True") -ErrorAction SilentlyContinue).FullName } catch { }
Add-Term 5 $fullName
if ($fullName) { foreach ($part in ($fullName -split '\s+')) { Add-Term 5 $part } }
if ($identity.Count -eq 0) { Write-Host 'FAIL: no identity terms could be read on this machine, so no file can be scanned.'; exit 1 }
# Longest first, so a full name is replaced before its parts.
$ordered = @($identity | Sort-Object { $_.Term.Length } -Descending)
[string[]]$termText = @($ordered | ForEach-Object { $_.Term })
[int[]]$termCategory = @($ordered | ForEach-Object { $_.Category })
$categoryCount = $categoryNames.Count

function Get-Reason($err) {
    $e = $err.Exception
    while ($e.InnerException) { $e = $e.InnerException }
    if ($e.Message -match '^[a-z][a-z0-9-]{2,40}$') { return $e.Message }
    return $e.GetType().Name + ' 0x' + ('{0:x8}' -f $e.HResult)
}
function Total([int[]]$counts) { $t = 0; foreach ($c in $counts) { $t += $c }; return $t }

$parent = [IO.Path]::GetFullPath($OutputFolder)
New-Item -ItemType Directory -Force -Path $parent | Out-Null
$stem = 'se-repro-' + $Issue + '-' + $ReproVersion
$runName = $stem
$serial = 2
while (Test-Path -LiteralPath (Join-Path $parent $runName)) { $runName = $stem + '-' + $serial; $serial++ }
$run = Join-Path $parent $runName
$logFile = Join-Path $run 'repro.log'
function Say([string]$line) {
    Write-Host $line
    if (Test-Path -LiteralPath $script:run) { Add-Content -LiteralPath $script:logFile -Value $line -Encoding ASCII }
}

$failedPairs = New-Object 'System.Collections.Generic.List[object]'
$fileRows = New-Object 'System.Collections.Generic.List[object]'
function Pair-Key([string]$fileName) { return ($fileName -replace '-(before|after)\.[a-z]+$', '') }
function Fail-Pair([string]$fileName, [string]$reason) {
    $key = Pair-Key $fileName
    foreach ($f in @(Get-ChildItem -LiteralPath $script:run -File | Where-Object { $_.Name.StartsWith($key + '-') })) {
        Remove-Item -LiteralPath $f.FullName -Force
    }
    # The assembly pair (issue 1874) places the part of the 1863 pair, so it cannot stand without it.
    if ($key -eq 'se-1863-stream-map' -and $script:Issue -eq '1874') {
        foreach ($f in @(Get-ChildItem -LiteralPath $script:run -File | Where-Object { $_.Name.StartsWith('se-1874-placements-') })) { Remove-Item -LiteralPath $f.FullName -Force }
    }
    if (-not ($script:failedPairs | Where-Object { $_.pair -eq $key })) { $script:failedPairs.Add([pscustomobject]@{ pair = $key; reason = $reason }) }
    Say ('FAILED pair ' + $key + ': ' + $reason + '; its files were deleted')
}

$buildStopped = $false
try {
    Add-Type -TypeDefinition $source -Language VisualBasic -ReferencedAssemblies 'System.dll', 'System.Core.dll', 'Microsoft.VisualBasic.dll', 'System.Web.Extensions.dll'
} catch { Write-Host ('FAIL: the builder did not compile (' + (Get-Reason $_) + ')'); exit 1 }

try {
    [ReproBuilder]::Run($run, $Issue)
} catch {
    $buildStopped = $true
}
if (-not (Test-Path -LiteralPath $run)) { Write-Host 'FAIL: the run folder was not created.'; exit 1 }
Add-Content -LiteralPath $logFile -Value ('Run folder: ' + $runName) -Encoding ASCII
Add-Content -LiteralPath $logFile -Value ('Builder version: ' + $ReproVersion + ', issue ' + $Issue) -Encoding ASCII
Write-Host ('Run folder: ' + $runName + ' (inside the folder you passed)')
if ($buildStopped) {
    foreach ($f in @(Get-ChildItem -LiteralPath $run -File | Where-Object { $_.Extension -in '.par', '.psm', '.asm', '.stp' })) { Remove-Item -LiteralPath $f.FullName -Force }
    Say 'FAIL: the build stopped before it finished; every file it had saved was deleted.'
}

# Pairs the build itself reported as failed.
$resultsFile = Join-Path $run 'build-results.json'
if ((-not $buildStopped) -and (Test-Path -LiteralPath $resultsFile)) {
    $built = Get-Content -LiteralPath $resultsFile -Raw | ConvertFrom-Json
    foreach ($row in @($built)) {
        if ($row.status -ne 'built') { Fail-Pair ($row.pair + '-before.x') ('build ' + $row.failed_phase) }
    }
}

# Privacy pass on every saved file: blank properties, replace the terms, compact, scan. A file that still shows a term fails its pair.
$native = @()
if (-not $buildStopped) { $native = @(Get-ChildItem -LiteralPath $run -File | Where-Object { $_.Extension -in '.par', '.psm', '.asm' } | Sort-Object Name) }
foreach ($f in $native) {
    if (-not (Test-Path -LiteralPath $f.FullName)) { continue }
    try {
        $blanked = [ReproPrivacy]::BlankIdentity($f.FullName)
        $replaced = [ReproPrivacy]::Strip($f.FullName, $termText, $termCategory)
        # Last write to the file: nothing may re-save it through Solid Edge after this (the reopen check closes without saving).
        $visible = [ReproPrivacy]::BlankVisible($f.FullName)
        $found = [int[]][ReproPrivacy]::Scan($f.FullName, $termText, $termCategory, $categoryCount)
    } catch { Fail-Pair $f.Name ('privacy-pass ' + (Get-Reason $_)); continue }
    $hits = Total $found
    Say ($f.Name + ': properties blanked ' + $blanked + ', replaced ' + $replaced + ', data blocks zeroed ' + $visible + ', identity hits after ' + $hits)
    if ($hits -gt 0) { Fail-Pair $f.Name ('identity-scan ' + $hits + ' hits'); continue }
}
$steps = @()
if (-not $buildStopped) { $steps = @(Get-ChildItem -LiteralPath $run -File | Where-Object { $_.Extension -eq '.stp' } | Sort-Object Name) }
foreach ($f in $steps) {
    if (-not (Test-Path -LiteralPath $f.FullName)) { continue }
    try {
        # Solid Edge can still be finishing the STEP file: wait until it ends with the STEP trailer and stops growing.
        $ready = $false
        for ($wait = 0; $wait -lt 60 -and -not $ready; $wait++) {
            $len = (Get-Item -LiteralPath $f.FullName).Length
            $text = $null
            try { $text = [IO.File]::ReadAllText($f.FullName) } catch [IO.IOException] { }
            if ($text -and $text.TrimEnd().EndsWith('END-ISO-10303-21;') -and (Get-Item -LiteralPath $f.FullName).Length -eq $len) { $ready = $true } else { Start-Sleep -Milliseconds 500 }
        }
        if (-not $ready) { throw 'step-not-complete' }
        $clean = [StepNeutral]::Clean([IO.File]::ReadAllText($f.FullName), $f.Name)
        [IO.File]::WriteAllText($f.FullName, $clean, [Text.Encoding]::ASCII)
        $found = [int[]][ReproPrivacy]::CountFile($f.FullName, $termText, $termCategory, $categoryCount)
    } catch { Fail-Pair $f.Name ('privacy-pass ' + (Get-Reason $_)); continue }
    $hits = Total $found
    Say ($f.Name + ': neutralized, identity hits after ' + $hits)
    if ($hits -gt 0) { Fail-Pair $f.Name ('identity-scan ' + $hits + ' hits') }
}

# Reopen what is left, to prove the privacy pass kept the files valid.
if (-not $buildStopped) {
    $recorded = @([ReproBuilder]::SavedFiles())
    $toOpen = @($recorded | Where-Object { Test-Path -LiteralPath (Join-Path $run $_) } | Sort-Object)
    if ($toOpen.Count -gt 0) {
        try {
            $notOpened = @([ReproBuilder]::Verify($run, [string[]]$toOpen))
            foreach ($name in $notOpened) { Fail-Pair $name 'reopen-mismatch' }
            Say ('Reopened ' + ($toOpen.Count - $notOpened.Count) + ' of ' + $toOpen.Count + ' native files')
        } catch {
            foreach ($name in $toOpen) { if (Test-Path -LiteralPath (Join-Path $run $name)) { Fail-Pair $name ('reopen ' + (Get-Reason $_)) } }
        }
    }
}

# Normalise file times, then write the results (counts only) and scan the whole folder one last time.
$kept = @(Get-ChildItem -LiteralPath $run -File | Where-Object { $_.Extension -in '.par', '.psm', '.asm', '.stp' } | Sort-Object Name)
$fixed = [datetime]'2026-01-01T00:00:00Z'
foreach ($f in $kept) {
    $f.CreationTimeUtc = $fixed; $f.LastWriteTimeUtc = $fixed; $f.LastAccessTimeUtc = $fixed
    $fileRows.Add([ordered]@{ name = $f.Name; bytes = $f.Length; sha256 = (Get-FileHash -LiteralPath $f.FullName -Algorithm SHA256).Hash.ToLower(); identity_hits = 0; reopened = ($f.Extension -ne '.stp') })
}
$termCounts = [ordered]@{}
for ($i = 0; $i -lt $categoryCount; $i++) { $termCounts[$categoryNames[$i]] = @($termCategory | Where-Object { $_ -eq $i }).Count }
$verdict = 'PASS'
if ($buildStopped -or $failedPairs.Count -gt 0 -or $kept.Count -eq 0) { $verdict = 'FAIL' }
$summary = [ordered]@{ tool = 'build_repro.ps1'; version = $ReproVersion; issue = $Issue; run_folder = $runName; verdict = $verdict; identity_terms_read_by_category = $termCounts; files = $fileRows.ToArray(); failed_pairs = $failedPairs.ToArray() }
$summary | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath (Join-Path $run 'results.json') -Encoding ASCII
$leaks = 0
foreach ($f in @(Get-ChildItem -LiteralPath $run -File)) {
    try {
        if ($f.Extension -in '.par', '.psm', '.asm') { $found = [int[]][ReproPrivacy]::Scan($f.FullName, $termText, $termCategory, $categoryCount) }
        else { $found = [int[]][ReproPrivacy]::CountFile($f.FullName, $termText, $termCategory, $categoryCount) }
        $nameHits = Total ([int[]][ReproPrivacy]::CountText($f.Name, $termText, $termCategory, $categoryCount))
    } catch { $found = [int[]]@(1, 0, 0, 0, 0, 0); $nameHits = 0 }
    if ((Total $found) + $nameHits -gt 0) {
        $leaks++
        if ($f.Extension -in '.par', '.psm', '.asm', '.stp') { Fail-Pair $f.Name 'final-identity-scan' } else { Remove-Item -LiteralPath $f.FullName -Force }
    }
}
if ($leaks -gt 0) { $verdict = 'FAIL' }
$total = @(Get-ChildItem -LiteralPath $run -File | Where-Object { $_.Extension -in '.par', '.psm', '.asm', '.stp' }).Count
Say ('Result: ' + $verdict + '; ' + $total + ' files kept, ' + $failedPairs.Count + ' pairs deleted, ' + $leaks + ' files failed the final scan.')
Write-Host ('Output folder name: ' + $runName)
if ($verdict -eq 'PASS') { exit 0 } else { exit 1 }
