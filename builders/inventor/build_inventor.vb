Option Explicit On
Option Strict Off
AddReference "System.Web.Extensions.dll"
AddReference "System.IO.Compression.FileSystem.dll"
AddReference "System.IO.Compression.dll"
Imports System.Collections.Generic
Imports System.Web.Script.Serialization
Imports System.IO
Imports System.IO.Compression
Imports System.Text.RegularExpressions
' Generated original iLogic rule. Paste the entire file in the iLogic editor.
Private app As Object
Private cd As Object
Private tg As Object
Private sk As Object
Private last As Object
Private lastProfile As Object
Private refs As Dictionary(Of String, Object)
Private opIndex As Integer
Private surfaceNames As New List(Of String)()
Private openPathSketches As New List(Of Integer)()
Private smThickness As Double = 0
Private outputRoot As String
' Every run writes to a NEW folder <script name>-Inventor-<builder version> (then -2, -3, ...) inside the
' output folder. An existing folder is never reused, cleared or overwritten.
Private Const ScriptName As String = "build_inventor"
Private Const BuilderVersion As String = "2026.11.26.1"
Private planes As Dictionary(Of String, Object)
' Sketch points created so far in the current sketch, and projected lines (2016-2021 connect new geometry to them).
Private joints As New List(Of Object)()
Private projected As New List(Of Object)()
Private recipeWatch As System.Diagnostics.Stopwatch
Private Const RecipeSeconds As Integer = 240

Function Legacy() As Boolean
    ' Inventor 2016 to 2021 (major 20 to 21).
    Return CInt(app.SoftwareVersion.Major) < 22
End Function

Sub CheckClock()
    ' One recipe never runs for more than 4 minutes: fail with a clear message instead of a stuck batch.
    If recipeWatch IsNot Nothing AndAlso recipeWatch.Elapsed.TotalSeconds > RecipeSeconds Then
        Throw New Exception("recipe stopped after " & RecipeSeconds & " seconds; Inventor was too slow on this recipe")
    End If
End Sub

Sub Main()
    Dim major As Integer = CInt(ThisApplication.SoftwareVersion.Major)
    app = If(major < 22, ComProxy.Wrap(ThisApplication), ThisApplication)
    tg = app.TransientGeometry
    Dim output As String = InputBox("Output folder for fixture files", "Inventor fixtures", PublicOutput)
    If output = "" Then
        Return
    End If
    Try
        RefuseOutput(output)
    Catch ex As InvalidOperationException
        MsgBox(ex.Message)
        Return
    End Try
    ' Run with Inventor's own dialogs switched off (SilentOperation) and put the old value back at the end, also on error.
    Dim previousSilent As Object = Nothing
    Dim silentChanged As Boolean = False
    Try
        If major >= 20 Then
            previousSilent = app.SilentOperation
            app.SilentOperation = True
            silentChanged = True
        End If
    Catch ex As Exception
    End Try
    ' Inventor writes its user name into every file it saves (Last Saved By): the neutral name for the run, the old one back in Finally
    Dim previousUser As Object = Nothing
    Dim userChanged As Boolean = False
    Try
        If major >= 20 Then
            previousUser = app.GeneralOptions.UserName
            app.GeneralOptions.UserName = "Fixture Builder"
            userChanged = True
        End If
    Catch ex As Exception
    End Try
    Try
        RunRecipes(major, output)
    Catch ex As Exception
        MsgBox(ScrubText(ex.ToString()))   ' a stack trace names the profile folder: scrubbed before it is shown
    Finally
        If silentChanged Then
            Try
                app.SilentOperation = previousSilent
            Catch ex As Exception
            End Try
        End If
        If userChanged Then
            Try
                app.GeneralOptions.UserName = previousUser
            Catch ex As Exception
            End Try
        End If
        If outputRootNow <> "" AndAlso Not outputSwept Then
            ' a crash or Ctrl+C: every file of the run gets its last look all the same
            Try
                If SweepOutput(outputRootNow, New List(Of String)(), New List(Of Object)()) > 0 Then
                    MsgBox("Some files of this run carry your user profile and could not be removed: delete this folder, do not send it: " & ScrubText(outputRootNow))
                Else
                    MsgBox("This run stopped before it finished. The folder was cleaned but holds no zip: do not send it.")
                End If
            Catch ex As Exception
                MsgBox("The last look at this run's folder failed: delete this folder, do not send it.")
            End Try
        End If
    End Try
End Sub

Function Stamp() As String
    Return DateTime.UtcNow.ToString("yyyy-MM-dd'T'HH:mm:ss'Z'", System.Globalization.CultureInfo.InvariantCulture)
End Function

Sub ActivateMasterLod(doc As Object, major As Integer)
    ' 2016-2021 assemblies: the Master Level of Detail must be active or a save asks for a user-named one.
    ' 2022 and newer use Model States instead, so skip them.
    If major >= 26 Then
        Return
    End If
    Try
        doc.ComponentDefinition.RepresentationsManager.LevelOfDetailRepresentations.Item(1).Activate()
    Catch ex As Exception
    End Try
End Sub

Sub RunRecipes(major As Integer, output As String)
    Dim serializer As New JavaScriptSerializer()
    serializer.MaxJsonLength = Integer.MaxValue
    Dim designs As Object = serializer.DeserializeObject(String.Concat(New String() {"[{""id"":""P01a"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_center"",""c"":[0,0,0],""w"":20,""h"":30}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":10,""direction"":""+"",""op"":""new"",""extent"":""distance""}],""scripted"":true,""why_not"":""""},{""id"":""P01b"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_center"",""c"":[0,0,0],""w"":20,""h"":30}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":12,""direction"":""+"",""op"":""new"",""extent"":""distance""}],""scripted"":true,""why_not"":""""},{""id"":""P02a"",""ops"":[{""type"":""sketch"",""plane"":""XZ"",""entities"":[{""type"":""rect_2pt"",""p1"":[20,0,0],""p2"":[30,0,40]}],""dims"":true},{""type"":""revolve"",""profile"":""last"",""axis"":""Z"",""angle"":360,""op"":""new""}],""scripted"":true,""why_not"":""""},{""id"":""P02b"",""ops"":[{""type"":""sketch"",""plane"":""XZ"",""entities"":[{""type"":""rect_2pt"",""p1"":[20,0,0],""p2"":[30,0,40]}],""dims"":true},{""type"":""revolve"",""profile"":""last"",""axis"":",
"""Z"",""angle"":270,""op"":""new""}],""scripted"":true,""why_not"":""""},{""id"":""P03a"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_center"",""c"":[0,0,0],""w"":20,""h"":30}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":10,""direction"":""+"",""op"":""new"",""extent"":""distance""},{""type"":""hole"",""at"":[0,0,10],""on_face"":{""face"":{""contains"":[0,0,10],""normal"":""+Z""}},""hole_type"":""simple"",""dia"":5,""through_all"":true}],""scripted"":true,""why_not"":""""},{""id"":""P03b"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_center"",""c"":[0,0,0],""w"":20,""h"":30}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":10,""direction"":""+"",""op"":""new"",""extent"":""distance""},{""type"":""hole"",""at"":[0,0,10],""on_face"":{""face"":{""contains"":[0,0,10],""normal"":""+Z""}},""hole_type"":""counterbore"",""dia"":5,""through_all"":true,""cb_dia"":9,""cb_depth"":3}],""scripted"":true,""why_not"":""""},{""id"":""P04a"",""ops"":[{""type"":""sketch"",""pl",
"ane"":""XY"",""entities"":[{""type"":""rect_center"",""c"":[0,0,0],""w"":20,""h"":30}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":10,""direction"":""+"",""op"":""new"",""extent"":""distance""},{""type"":""fillet"",""edges"":[{""edge"":{""through"":[10,15,5],""dir"":""Z""}}],""r"":2}],""scripted"":true,""why_not"":""""},{""id"":""P04b"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_center"",""c"":[0,0,0],""w"":20,""h"":30}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":10,""direction"":""+"",""op"":""new"",""extent"":""distance""},{""type"":""fillet"",""edges"":[{""edge"":{""through"":[10,15,5],""dir"":""Z""}}],""r"":3}],""scripted"":true,""why_not"":""""},{""id"":""P04c"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_center"",""c"":[0,0,0],""w"":20,""h"":30}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":10,""direction"":""+"",""op"":""new"",""extent"":""distance""},{""type"":""fillet"",""edges"":[{""edge"":{""through"":[10,15,5],""dir"":""",
"Z""}},{""edge"":{""through"":[-10,15,5],""dir"":""Z""}}],""r"":2}],""scripted"":true,""why_not"":""""},{""id"":""P04d"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_center"",""c"":[0,0,0],""w"":20,""h"":30}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":10,""direction"":""+"",""op"":""new"",""extent"":""distance""},{""type"":""fillet_variable"",""edge"":{""edge"":{""through"":[10,15,5],""dir"":""Z""}},""r_start"":{""at"":[10,15,0],""r"":1},""r_end"":{""at"":[10,15,10],""r"":3},""intermediate_points"":[],""transition"":""default""}],""scripted"":true,""why_not"":""""},{""id"":""P04e"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_center"",""c"":[0,0,0],""w"":20,""h"":30}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":10,""direction"":""+"",""op"":""new"",""extent"":""distance""},{""type"":""fillet_variable"",""edge"":{""edge"":{""through"":[10,15,5],""dir"":""Z""}},""r_start"":{""at"":[10,15,0],""r"":3},""r_end"":{""at"":[10,15,10],""r"":1},""intermediat",
"e_points"":[],""transition"":""default""}],""scripted"":true,""why_not"":""""},{""id"":""P05a"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_center"",""c"":[0,0,0],""w"":20,""h"":30}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":10,""direction"":""+"",""op"":""new"",""extent"":""distance""},{""type"":""chamfer"",""edge"":{""edge"":{""through"":[0,15,10],""dir"":""X""}},""mode"":""distance"",""d1"":1,""flip"":false}],""scripted"":true,""why_not"":""""},{""id"":""P05b"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_center"",""c"":[0,0,0],""w"":20,""h"":30}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":10,""direction"":""+"",""op"":""new"",""extent"":""distance""},{""type"":""chamfer"",""edge"":{""edge"":{""through"":[0,15,10],""dir"":""X""}},""mode"":""distance"",""d1"":1.5,""flip"":false}],""scripted"":true,""why_not"":""""},{""id"":""P05c"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_center"",""c"":[0,0,0],""w"":20,""h"":30}],""d",
"ims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":10,""direction"":""+"",""op"":""new"",""extent"":""distance""},{""type"":""chamfer"",""edge"":{""edge"":{""through"":[0,15,10],""dir"":""X""}},""mode"":""two_distances"",""d1"":1,""flip"":false,""d2"":2}],""scripted"":true,""why_not"":""""},{""id"":""P05d"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_center"",""c"":[0,0,0],""w"":20,""h"":30}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":10,""direction"":""+"",""op"":""new"",""extent"":""distance""},{""type"":""chamfer"",""edge"":{""edge"":{""through"":[0,15,10],""dir"":""X""}},""mode"":""two_distances"",""d1"":1,""flip"":true,""d2"":2}],""scripted"":true,""why_not"":""""},{""id"":""P05e"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_center"",""c"":[0,0,0],""w"":20,""h"":30}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":10,""direction"":""+"",""op"":""new"",""extent"":""distance""},{""type"":""chamfer"",""edge"":{""edge"":{""through"":[0,15,10]",
",""dir"":""X""}},""mode"":""distance_angle"",""d1"":2,""flip"":false,""angle"":30,""ref_face"":{""face"":{""contains"":[0,0,10],""normal"":""+Z""}}}],""scripted"":true,""why_not"":""""},{""id"":""P05f"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_center"",""c"":[0,0,0],""w"":20,""h"":30}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":10,""direction"":""+"",""op"":""new"",""extent"":""distance""},{""type"":""chamfer"",""edge"":{""edge"":{""through"":[0,15,10],""dir"":""X""}},""mode"":""distance_angle"",""d1"":2,""flip"":true,""angle"":30,""ref_face"":{""face"":{""contains"":[0,0,10],""normal"":""+Z""}}}],""scripted"":true,""why_not"":""""},{""id"":""P06a"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_center"",""c"":[0,0,0],""w"":20,""h"":30}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":10,""direction"":""+"",""op"":""new"",""extent"":""distance""},{""type"":""shell"",""remove_faces"":[{""face"":{""contains"":[0,0,10],""normal"":""+Z""}}],""thickness"":1.",
"5,""direction"":""inside""}],""scripted"":true,""why_not"":""""},{""id"":""P06b"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_center"",""c"":[0,0,0],""w"":20,""h"":30}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":10,""direction"":""+"",""op"":""new"",""extent"":""distance""},{""type"":""shell"",""remove_faces"":[{""face"":{""contains"":[0,0,10],""normal"":""+Z""}}],""thickness"":2,""direction"":""inside""}],""scripted"":true,""why_not"":""""},{""id"":""P07a"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_2pt"",""p1"":[0,0,0],""p2"":[60,40,0]}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":5,""direction"":""+"",""op"":""new"",""extent"":""distance""},{""type"":""hole"",""at"":[5,5,5],""on_face"":{""face"":{""contains"":[5,5,5],""normal"":""+Z""}},""hole_type"":""simple"",""dia"":4,""through_all"":true,""name"":""hole""},{""type"":""pattern_rect"",""feature"":""hole"",""dir1"":{""axis"":""X"",""count"":3,""spacing"":10},""dir2"":{""axis"":""Y"",""count"":2,""",
"spacing"":10}}],""scripted"":true,""why_not"":""""},{""id"":""P07b"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_2pt"",""p1"":[0,0,0],""p2"":[60,40,0]}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":5,""direction"":""+"",""op"":""new"",""extent"":""distance""},{""type"":""hole"",""at"":[5,5,5],""on_face"":{""face"":{""contains"":[5,5,5],""normal"":""+Z""}},""hole_type"":""simple"",""dia"":4,""through_all"":true,""name"":""hole""},{""type"":""pattern_rect"",""feature"":""hole"",""dir1"":{""axis"":""X"",""count"":4,""spacing"":10},""dir2"":{""axis"":""Y"",""count"":2,""spacing"":10}}],""scripted"":true,""why_not"":""""},{""id"":""P08a"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""circle"",""c"":[0,0,0],""r"":30}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":5,""direction"":""+"",""op"":""new"",""extent"":""distance""},{""type"":""hole"",""at"":[20,0,5],""on_face"":{""face"":{""contains"":[20,0,5],""normal"":""+Z""}},""hole_type"":""simple"",""dia"":6,""through_a",
"ll"":true,""name"":""hole""},{""type"":""pattern_circ"",""feature"":""hole"",""axis"":""Z"",""count"":6,""angle"":360}],""scripted"":true,""why_not"":""""},{""id"":""P08b"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""circle"",""c"":[0,0,0],""r"":30}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":5,""direction"":""+"",""op"":""new"",""extent"":""distance""},{""type"":""hole"",""at"":[20,0,5],""on_face"":{""face"":{""contains"":[20,0,5],""normal"":""+Z""}},""hole_type"":""simple"",""dia"":6,""through_all"":true,""name"":""hole""},{""type"":""pattern_circ"",""feature"":""hole"",""axis"":""Z"",""count"":8,""angle"":360}],""scripted"":true,""why_not"":""""},{""id"":""P09a"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_center"",""c"":[0,0,0],""w"":20,""h"":30}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":10,""direction"":""+"",""op"":""new"",""extent"":""distance""},{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_center"",""c"":[0,15,5],""w"":5,""h"":5",
"}],""dims"":true,""name"":""boss_profile"",""on_face"":{""face"":{""contains"":[0,15,5],""normal"":""+Y""}}},{""type"":""extrude"",""profile"":""last"",""distance"":5,""direction"":""+"",""op"":""join"",""extent"":""distance"",""axis"":""Y"",""name"":""boss""},{""type"":""app_specific"",""app"":""inventor"",""op"":""mirror"",""params"":{""features"":[""boss""],""plane"":""XZ""}}],""scripted"":true,""why_not"":""""},{""id"":""P09b"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_center"",""c"":[0,0,0],""w"":20,""h"":30}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":10,""direction"":""+"",""op"":""new"",""extent"":""distance""},{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_center"",""c"":[0,15,5],""w"":6,""h"":5}],""dims"":true,""name"":""boss_profile"",""on_face"":{""face"":{""contains"":[0,15,5],""normal"":""+Y""}}},{""type"":""extrude"",""profile"":""last"",""distance"":5,""direction"":""+"",""op"":""join"",""extent"":""distance"",""axis"":""Y"",""name"":""boss""},{""type"":""app_specific"",""app"":""",
"inventor"",""op"":""mirror"",""params"":{""features"":[""boss""],""plane"":""XZ""}}],""scripted"":true,""why_not"":""""},{""id"":""P10a"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""line"",""a"":[0,0,0],""b"":[30,0,0]},{""type"":""arc"",""a"":[30,0,0],""b"":[40,10,0],""c"":[30,10,0],""r"":10},{""type"":""line"",""a"":[40,10,0],""b"":[40,30,0]}],""dims"":true,""name"":""path""},{""type"":""sketch"",""plane"":{""normal"":""X"",""origin"":[0,0,0]},""entities"":[{""type"":""circle"",""c"":[0,0,0],""r"":2}],""dims"":true,""name"":""profile""},{""type"":""sweep"",""profile"":""profile"",""path"":""path""}],""scripted"":true,""why_not"":""""},{""id"":""P10b"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""line"",""a"":[0,0,0],""b"":[30,0,0]},{""type"":""arc"",""a"":[30,0,0],""b"":[40,10,0],""c"":[30,10,0],""r"":10},{""type"":""line"",""a"":[40,10,0],""b"":[40,30,0]}],""dims"":true,""name"":""path""},{""type"":""sketch"",""plane"":{""normal"":""X"",""origin"":[0,0,0]},""entities"":[{""type"":""circle"",""c"":[0,0,0],""r"":2.5}",
"],""dims"":true,""name"":""profile""},{""type"":""sweep"",""profile"":""profile"",""path"":""path""}],""scripted"":true,""why_not"":""""},{""id"":""P11a"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_center"",""c"":[0,0,0],""w"":20,""h"":20}],""dims"":true,""name"":""bottom""},{""type"":""sketch"",""plane"":{""base"":""XY"",""offset"":30},""entities"":[{""type"":""circle"",""c"":[0,0,30],""r"":5}],""dims"":true,""name"":""top""},{""type"":""loft"",""profiles"":[""bottom"",""top""]}],""scripted"":true,""why_not"":""""},{""id"":""P11b"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_center"",""c"":[0,0,0],""w"":20,""h"":20}],""dims"":true,""name"":""bottom""},{""type"":""sketch"",""plane"":{""base"":""XY"",""offset"":40},""entities"":[{""type"":""circle"",""c"":[0,0,40],""r"":5}],""dims"":true,""name"":""top""},{""type"":""loft"",""profiles"":[""bottom"",""top""]}],""scripted"":true,""why_not"":""""},{""id"":""P12a"",""ops"":[{""type"":""app_specific"",""app"":""inventor"",""op"":""parameter"",""params"":{""name"":""plate",
"_w"",""value"":20,""units"":""mm""}},{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_center"",""c"":[0,0,0],""w"":20,""h"":30}],""dims"":true,""width_expression"":""plate_w""},{""type"":""extrude"",""profile"":""last"",""distance"":10,""direction"":""+"",""op"":""new"",""extent"":""distance"",""distance_expression"":""plate_w/2""}],""scripted"":true,""why_not"":""""},{""id"":""P12b"",""ops"":[{""type"":""app_specific"",""app"":""inventor"",""op"":""parameter"",""params"":{""name"":""plate_w"",""value"":25,""units"":""mm""}},{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_center"",""c"":[0,0,0],""w"":25,""h"":30}],""dims"":true,""width_expression"":""plate_w""},{""type"":""extrude"",""profile"":""last"",""distance"":12.5,""direction"":""+"",""op"":""new"",""extent"":""distance"",""distance_expression"":""plate_w/2""}],""scripted"":true,""why_not"":""""},{""id"":""P13a"",""ops"":[{""type"":""sketch"",""plane"":{""base"":""XY"",""offset"":15},""entities"":[{""type"":""circle"",""c"":[0,0,15],""r"":5}],""dims"":true},{""type"":""ext",
"rude"",""profile"":""last"",""distance"":5,""direction"":""+"",""op"":""new"",""extent"":""distance""}],""scripted"":true,""why_not"":""""},{""id"":""P13b"",""ops"":[{""type"":""sketch"",""plane"":{""base"":""XY"",""offset"":20},""entities"":[{""type"":""circle"",""c"":[0,0,20],""r"":5}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":5,""direction"":""+"",""op"":""new"",""extent"":""distance""}],""scripted"":true,""why_not"":""""},{""id"":""P14a"",""ops"":[{""type"":""app_specific"",""app"":""inventor"",""op"":""sketch3d"",""params"":{""name"":""path"",""entities"":[{""type"":""line"",""a"":[0,0,0],""b"":[20,0,0]},{""type"":""line"",""a"":[20,0,0],""b"":[20,20,10]}],""dims"":true}},{""type"":""sketch"",""plane"":{""normal"":""X"",""origin"":[0,0,0]},""entities"":[{""type"":""circle"",""c"":[0,0,0],""r"":1.5}],""dims"":true,""name"":""profile""},{""type"":""sweep"",""profile"":""profile"",""path"":""path""}],""scripted"":true,""why_not"":""""},{""id"":""P14b"",""ops"":[{""type"":""app_specific"",""app"":""inventor"",""op"":""sketch3d"",""params"":{""name""",
":""path"",""entities"":[{""type"":""line"",""a"":[0,0,0],""b"":[20,0,0]},{""type"":""line"",""a"":[20,0,0],""b"":[20,20,15]}],""dims"":true}},{""type"":""sketch"",""plane"":{""normal"":""X"",""origin"":[0,0,0]},""entities"":[{""type"":""circle"",""c"":[0,0,0],""r"":1.5}],""dims"":true,""name"":""profile""},{""type"":""sweep"",""profile"":""profile"",""path"":""path""}],""scripted"":true,""why_not"":""""},{""id"":""P15a"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_center"",""c"":[0,0,0],""w"":20,""h"":30}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":10,""direction"":""+"",""op"":""new"",""extent"":""distance""},{""type"":""app_specific"",""app"":""inventor"",""op"":""appearance"",""params"":{""target"":""part"",""color"":""red""}}],""scripted"":true,""why_not"":""""},{""id"":""P15b"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_center"",""c"":[0,0,0],""w"":20,""h"":30}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":10,""direction"":""+"",""op"":""new"",""exten",
"t"":""distance""},{""type"":""app_specific"",""app"":""inventor"",""op"":""appearance"",""params"":{""target"":""part"",""color"":""red""}},{""type"":""app_specific"",""app"":""inventor"",""op"":""appearance"",""params"":{""target"":{""face"":{""contains"":[0,0,10],""normal"":""+Z""}},""color"":""blue""}}],""scripted"":true,""why_not"":""""},{""id"":""P16a"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""circle"",""c"":[0,0,0],""r"":2.5}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":20,""direction"":""+"",""op"":""new"",""extent"":""distance""}],""scripted"":true,""why_not"":""""},{""id"":""X01a"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_2pt"",""p1"":[0,0,0],""p2"":[20,10,0]},{""type"":""rect_2pt"",""p1"":[30,0,0],""p2"":[50,10,0]}],""dims"":true},{""type"":""extrude"",""profile"":[{""pick"":[10,5,0]},{""pick"":[40,5,0]}],""distance"":5,""direction"":""+"",""op"":""new"",""extent"":""distance""}],""scripted"":true,""why_not"":""""},{""id"":""X01b"",""ops"":[{""type"":""sketch"",""plan",
"e"":""XY"",""entities"":[{""type"":""rect_2pt"",""p1"":[0,0,0],""p2"":[20,10,0]},{""type"":""rect_2pt"",""p1"":[30,0,0],""p2"":[50,10,0]}],""dims"":true},{""type"":""extrude"",""profile"":[{""pick"":[40,5,0]},{""pick"":[10,5,0]}],""distance"":5,""direction"":""+"",""op"":""new"",""extent"":""distance""}],""scripted"":true,""why_not"":""""},{""id"":""X01c"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_2pt"",""p1"":[0,0,0],""p2"":[20,10,0]},{""type"":""rect_2pt"",""p1"":[30,0,0],""p2"":[50,10,0]}],""dims"":true},{""type"":""extrude"",""profile"":{""pick"":[40,5,0]},""distance"":5,""direction"":""+"",""op"":""new"",""extent"":""distance""}],""scripted"":true,""why_not"":""""},{""id"":""X02a"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_center"",""c"":[0,0,0],""w"":40,""h"":30},{""type"":""circle"",""c"":[0,0,0],""r"":5}],""dims"":true},{""type"":""extrude"",""profile"":{""pick"":[10,0,0]},""distance"":5,""direction"":""+"",""op"":""new"",""extent"":""distance""}],""scripted"":true,""why_not"":""""},{",
"""id"":""X02b"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_center"",""c"":[0,0,0],""w"":40,""h"":30},{""type"":""circle"",""c"":[0,0,0],""r"":5}],""dims"":true},{""type"":""extrude"",""profile"":{""pick"":[0,0,0]},""distance"":5,""direction"":""+"",""op"":""new"",""extent"":""distance""}],""scripted"":true,""why_not"":""""},{""id"":""X02c"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_center"",""c"":[0,0,0],""w"":40,""h"":30},{""type"":""circle"",""c"":[0,0,0],""r"":5}],""dims"":true},{""type"":""extrude"",""profile"":[{""pick"":[10,0,0]},{""pick"":[0,0,0]}],""distance"":5,""direction"":""+"",""op"":""new"",""extent"":""distance""}],""scripted"":true,""why_not"":""""},{""id"":""X03a"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_2pt"",""p1"":[0,0,0],""p2"":[30,20,0]},{""type"":""rect_2pt"",""p1"":[20,10,0],""p2"":[50,30,0]}],""dims"":true},{""type"":""extrude"",""profile"":{""pick"":[25,15,0]},""distance"":5,""direction"":""+"",""op"":""new"",""extent"":""distance""}],""s",
"cripted"":true,""why_not"":""""},{""id"":""X03b"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_2pt"",""p1"":[0,0,0],""p2"":[30,20,0]},{""type"":""rect_2pt"",""p1"":[20,10,0],""p2"":[50,30,0]}],""dims"":true},{""type"":""extrude"",""profile"":[{""pick"":[25,15,0]},{""pick"":[5,5,0]}],""distance"":5,""direction"":""+"",""op"":""new"",""extent"":""distance""}],""scripted"":true,""why_not"":""""},{""id"":""X03c"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_2pt"",""p1"":[0,0,0],""p2"":[30,20,0]},{""type"":""rect_2pt"",""p1"":[20,10,0],""p2"":[50,30,0]}],""dims"":true},{""type"":""extrude"",""profile"":[{""pick"":[25,15,0]},{""pick"":[5,5,0]},{""pick"":[45,25,0]}],""distance"":5,""direction"":""+"",""op"":""new"",""extent"":""distance""}],""scripted"":true,""why_not"":""""},{""id"":""X04a"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_center"",""c"":[0,0,0],""w"":20,""h"":30}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":10,""direction"":""+""",
",""op"":""new"",""extent"":""distance""},{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""line"",""a"":[-5,15,10],""b"":[-5,5,10]},{""type"":""line"",""a"":[-5,5,10],""b"":[5,5,10]},{""type"":""line"",""a"":[5,5,10],""b"":[5,15,10]}],""dims"":true,""on_face"":{""face"":{""contains"":[0,0,10],""normal"":""+Z""}},""project"":[{""edge"":{""through"":[0,15,10],""dir"":""X""}}]},{""type"":""extrude"",""profile"":""last"",""distance"":5,""direction"":""+"",""op"":""join"",""extent"":""distance""}],""scripted"":true,""why_not"":""""},{""id"":""X04b"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_center"",""c"":[0,0,0],""w"":20,""h"":30}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":10,""direction"":""+"",""op"":""new"",""extent"":""distance""},{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""line"",""a"":[-5,15,10],""b"":[-5,5,10]},{""type"":""line"",""a"":[-5,5,10],""b"":[5,5,10]},{""type"":""line"",""a"":[5,5,10],""b"":[5,15,10]}],""dims"":true,""on_face"":{""face"":{""contains"":[0,0,1",
"0],""normal"":""+Z""}},""project"":[{""edge"":{""through"":[0,15,10],""dir"":""X""}}]},{""type"":""extrude"",""profile"":""last"",""distance"":3,""direction"":""-"",""op"":""cut"",""extent"":""distance""}],""scripted"":true,""why_not"":""""},{""id"":""X05a"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_2pt"",""p1"":[0,0,0],""p2"":[20,20,0]},{""type"":""rect_2pt"",""p1"":[30,0,0],""p2"":[50,20,0]}],""dims"":true,""name"":""shared""},{""type"":""extrude"",""profile"":{""sketch"":""shared"",""pick"":[10,10,0]},""distance"":5,""direction"":""+"",""op"":""new"",""extent"":""distance""},{""type"":""extrude"",""profile"":{""sketch"":""shared"",""pick"":[40,10,0]},""distance"":10,""direction"":""+"",""op"":""new"",""extent"":""distance""}],""scripted"":true,""why_not"":""""},{""id"":""X05b"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_2pt"",""p1"":[0,0,0],""p2"":[20,20,0]},{""type"":""rect_2pt"",""p1"":[30,0,0],""p2"":[50,20,0]}],""dims"":true,""name"":""shared""},{""type"":""extrude"",""profile"":{""sketch"":",
"""shared"",""pick"":[10,10,0]},""distance"":5,""direction"":""+"",""op"":""new"",""extent"":""distance""},{""type"":""extrude"",""profile"":{""sketch"":""shared"",""pick"":[40,10,0]},""distance"":15,""direction"":""+"",""op"":""new"",""extent"":""distance""}],""scripted"":true,""why_not"":""""},{""id"":""X06a"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""line"",""a"":[-10,0,0],""b"":[10,0,0]},{""type"":""arc"",""a"":[10,0,0],""through"":[0,10,0],""b"":[-10,0,0]}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":5,""direction"":""+"",""op"":""new"",""extent"":""distance""}],""scripted"":true,""why_not"":""""},{""id"":""X06b"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""line"",""a"":[-10,0,0],""b"":[10,0,0]},{""type"":""arc"",""a"":[-10,0,0],""through"":[0,10,0],""b"":[10,0,0]}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":5,""direction"":""+"",""op"":""new"",""extent"":""distance""}],""scripted"":true,""why_not"":""""},{""id"":""X06c"",""ops"":[{""type"":""sketch"",""pl",
"ane"":""XY"",""entities"":[{""type"":""line"",""a"":[-10,-5,0],""b"":[10,-5,0]},{""type"":""arc"",""a"":[10,-5,0],""through"":[15,0,0],""b"":[10,5,0]},{""type"":""line"",""a"":[10,5,0],""b"":[-10,5,0]},{""type"":""arc"",""a"":[-10,5,0],""through"":[-15,0,0],""b"":[-10,-5,0]}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":5,""direction"":""+"",""op"":""new"",""extent"":""distance""}],""scripted"":true,""why_not"":""""},{""id"":""X07a"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_center"",""c"":[0,0,0],""w"":20,""h"":30},{""type"":""line"",""a"":[-10,-15,0],""b"":[10,15,0],""construction"":true},{""type"":""line"",""a"":[-10,15,0],""b"":[10,-15,0],""construction"":true}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":10,""direction"":""+"",""op"":""new"",""extent"":""distance""}],""scripted"":true,""why_not"":""""},{""id"":""X07b"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_center"",""c"":[0,0,0],""w"":20,""h"":30},{""type"":""line"",""a"":[-10,-15,",
"0],""b"":[10,15,0],""construction"":false},{""type"":""line"",""a"":[-10,15,0],""b"":[10,-15,0],""construction"":true}],""dims"":true},{""type"":""extrude"",""profile"":[{""pick"":[-5,0,0]},{""pick"":[5,0,0]}],""distance"":10,""direction"":""+"",""op"":""new"",""extent"":""distance""}],""scripted"":true,""why_not"":""""},{""id"":""X08a"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_center"",""c"":[0,0,0],""w"":20,""h"":30}],""dims"":true,""fillets"":[{""at"":[10,15,0],""r"":3}]},{""type"":""extrude"",""profile"":""last"",""distance"":10,""direction"":""+"",""op"":""new"",""extent"":""distance""}],""scripted"":true,""why_not"":""""},{""id"":""X08b"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_center"",""c"":[0,0,0],""w"":20,""h"":30}],""dims"":true,""fillets"":[{""at"":[10,15,0],""r"":5}]},{""type"":""extrude"",""profile"":""last"",""distance"":10,""direction"":""+"",""op"":""new"",""extent"":""distance""}],""scripted"":true,""why_not"":""""},{""id"":""X09a"",""ops"":[{""type"":""app_specific"",""app",
""":""inventor"",""op"":""interpolation_spline_sketch"",""params"":{""plane"":""XY"",""points"":[[-20,0,0],[0,-10,0],[20,0,0],[0,10,0]],""closed"":true,""dims"":true}},{""type"":""extrude"",""profile"":""last"",""distance"":5,""direction"":""+"",""op"":""new"",""extent"":""distance""}],""scripted"":true,""why_not"":""""},{""id"":""X10a"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""circle"",""c"":[10,0,0],""r"":1}],""dims"":true},{""type"":""app_specific"",""app"":""inventor"",""op"":""coil"",""params"":{""axis"":""Y"",""direction"":""+"",""pitch"":5,""revolutions"":4,""taper"":0,""size_type"":""pitch_revolution"",""rotation"":""default"",""ends"":""default""}}],""scripted"":true,""why_not"":""""},{""id"":""X10b"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""circle"",""c"":[10,0,0],""r"":1}],""dims"":true},{""type"":""app_specific"",""app"":""inventor"",""op"":""coil"",""params"":{""axis"":""Y"",""direction"":""-"",""pitch"":5,""revolutions"":4,""taper"":0,""size_type"":""pitch_revolution"",""rotation"":""defa",
"ult"",""ends"":""default""}}],""scripted"":true,""why_not"":""""},{""id"":""X10c"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""circle"",""c"":[10,0,0],""r"":1}],""dims"":true},{""type"":""app_specific"",""app"":""inventor"",""op"":""coil"",""params"":{""axis"":""Y"",""direction"":""+"",""pitch"":5,""revolutions"":4,""taper"":0,""size_type"":""pitch_revolution"",""rotation"":""opposite_default"",""ends"":""default""}}],""scripted"":true,""why_not"":""""},{""id"":""X10d"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""circle"",""c"":[10,0,0],""r"":1}],""dims"":true},{""type"":""app_specific"",""app"":""inventor"",""op"":""coil"",""params"":{""axis"":""Y"",""direction"":""+"",""pitch"":5,""revolutions"":4,""taper"":0,""size_type"":""revolution_height"",""rotation"":""default"",""ends"":""default"",""height"":20}}],""scripted"":true,""why_not"":""""},{""id"":""X10e"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""circle"",""c"":[10,0,0],""r"":1}],""dims"":true},{""type"":""app_specific"",""app"":""",
"inventor"",""op"":""coil"",""params"":{""axis"":""Y"",""direction"":""+"",""pitch"":5,""revolutions"":4,""taper"":0,""size_type"":""pitch_height"",""rotation"":""default"",""ends"":""default"",""height"":20}}],""scripted"":true,""why_not"":""""},{""id"":""X10f"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""circle"",""c"":[10,0,0],""r"":1}],""dims"":true},{""type"":""app_specific"",""app"":""inventor"",""op"":""coil"",""params"":{""axis"":""Y"",""direction"":""+"",""pitch"":5,""revolutions"":4,""taper"":0,""size_type"":""spiral"",""rotation"":""default"",""ends"":""default""}}],""scripted"":true,""why_not"":""""},{""id"":""X10g"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""circle"",""c"":[8,-6,0],""r"":1},{""type"":""line"",""a"":[0,0,0],""b"":[30,40,0],""construction"":true}],""dims"":true},{""type"":""app_specific"",""app"":""inventor"",""op"":""coil"",""params"":{""axis"":{""line"":[[0,0,0],[30,40,0]]},""direction"":""+"",""pitch"":5,""revolutions"":4,""taper"":0,""size_type"":""pitch_revolution"",""rotation",
""":""default"",""ends"":""default""}}],""scripted"":true,""why_not"":""""},{""id"":""X11a"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""line"",""a"":[-10,0,0],""b"":[10,0,0]},{""type"":""arc"",""a"":[10,0,0],""through"":[0,10,0],""b"":[-10,0,0]}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":30,""direction"":""+"",""op"":""new"",""extent"":""distance""},{""type"":""sketch"",""plane"":{""base"":""XZ"",""offset"":30},""entities"":[{""type"":""rect_2pt"",""p1"":[-3,30,12],""p2"":[3,30,18]}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""direction"":""-"",""op"":""join"",""extent"":""to_face"",""axis"":""Y"",""to_face"":{""face"":{""contains"":[0,10,15],""normal"":""+Y""}}}],""scripted"":true,""why_not"":""""},{""id"":""X11b"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""line"",""a"":[-10,0,0],""b"":[10,0,0]},{""type"":""arc"",""a"":[10,0,0],""through"":[0,10,0],""b"":[-10,0,0]}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":30,""direction"":""+"",""op"":""n",
"ew"",""extent"":""distance""},{""type"":""sketch"",""plane"":{""base"":""XZ"",""offset"":30},""entities"":[{""type"":""rect_2pt"",""p1"":[-3,30,12],""p2"":[3,30,18]}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""direction"":""-"",""op"":""join"",""extent"":""to_face"",""axis"":""Y"",""to_face"":{""face"":{""contains"":[0,0,15],""normal"":""-Y""}}}],""scripted"":true,""why_not"":""""},{""id"":""X12a"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_center"",""c"":[0,0,0],""w"":60,""h"":40}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":5,""direction"":""+"",""op"":""new"",""extent"":""distance""},{""type"":""hole"",""at"":[0,0,5],""on_face"":{""face"":{""contains"":[0,0,5],""normal"":""+Z""}},""hole_type"":""simple"",""dia"":4,""through_all"":true,""name"":""hole""},{""type"":""pattern_rect"",""feature"":""hole"",""dir1"":{""axis"":""X"",""count"":3,""spacing"":10},""dir2"":{""axis"":""Y"",""count"":2,""spacing"":10}}],""scripted"":true,""why_not"":""""},{""id"":""X12b"",""ops"":[{""type"":""sketch"",""plane",
""":""XY"",""entities"":[{""type"":""rect_center"",""c"":[0,0,0],""w"":60,""h"":40}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":5,""direction"":""+"",""op"":""new"",""extent"":""distance""},{""type"":""hole"",""at"":[0,0,5],""on_face"":{""face"":{""contains"":[0,0,5],""normal"":""+Z""}},""hole_type"":""simple"",""dia"":4,""through_all"":true,""name"":""hole""},{""type"":""pattern_rect"",""feature"":""hole"",""dir1"":{""axis"":""X"",""count"":3,""spacing"":10,""flip"":true},""dir2"":{""axis"":""Y"",""count"":2,""spacing"":10}}],""scripted"":true,""why_not"":""""},{""id"":""X12c"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_center"",""c"":[0,0,0],""w"":60,""h"":40}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":5,""direction"":""+"",""op"":""new"",""extent"":""distance""},{""type"":""hole"",""at"":[0,0,5],""on_face"":{""face"":{""contains"":[0,0,5],""normal"":""+Z""}},""hole_type"":""simple"",""dia"":4,""through_all"":true,""name"":""hole""},{""type"":""pattern_rect"",""feature"":""hole"",""",
"dir1"":{""axis"":""X"",""count"":3,""spacing"":10},""dir2"":{""axis"":""Y"",""count"":2,""spacing"":10,""flip"":true}}],""scripted"":true,""why_not"":""""},{""id"":""X13a"",""ops"":[{""type"":""sketch"",""plane"":""XZ"",""entities"":[{""type"":""rect_2pt"",""p1"":[20,0,0],""p2"":[30,0,40]}],""dims"":true},{""type"":""revolve"",""profile"":""last"",""axis"":""Z"",""angle"":270,""op"":""new""}],""scripted"":true,""why_not"":""""},{""id"":""X13b"",""ops"":[{""type"":""sketch"",""plane"":""XZ"",""entities"":[{""type"":""rect_2pt"",""p1"":[20,0,0],""p2"":[30,0,40]}],""dims"":true},{""type"":""revolve"",""profile"":""last"",""axis"":""Z"",""angle"":270,""op"":""new"",""direction"":""-""}],""scripted"":true,""why_not"":""""},{""id"":""X14a"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_center"",""c"":[0,0,0],""w"":20,""h"":30}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":10,""direction"":""+"",""op"":""new"",""extent"":""distance""},{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_center"",""c"":[0,15,5],""w"":",
"5,""h"":5}],""dims"":true,""name"":""boss_profile"",""on_face"":{""face"":{""contains"":[0,15,5],""normal"":""+Y""}}},{""type"":""extrude"",""profile"":""last"",""distance"":5,""direction"":""+"",""op"":""join"",""extent"":""distance"",""axis"":""Y"",""name"":""boss""},{""type"":""fillet"",""edges"":[{""edge"":{""through"":[-2.5,17.5,2.5],""dir"":""Y""}},{""edge"":{""through"":[-2.5,17.5,7.5],""dir"":""Y""}},{""edge"":{""through"":[2.5,17.5,2.5],""dir"":""Y""}},{""edge"":{""through"":[2.5,17.5,7.5],""dir"":""Y""}}],""r"":1,""name"":""fillet""},{""type"":""app_specific"",""app"":""inventor"",""op"":""mirror"",""params"":{""features"":[""boss"",""fillet""],""plane"":""XZ""}}],""scripted"":true,""why_not"":""""},{""id"":""X14b"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_center"",""c"":[0,0,0],""w"":20,""h"":30}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":10,""direction"":""+"",""op"":""new"",""extent"":""distance""},{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_center"",""c"":[0,15,5],""w"":",
"5,""h"":5}],""dims"":true,""name"":""boss_profile"",""on_face"":{""face"":{""contains"":[0,15,5],""normal"":""+Y""}}},{""type"":""extrude"",""profile"":""last"",""distance"":5,""direction"":""+"",""op"":""join"",""extent"":""distance"",""axis"":""Y"",""name"":""boss""},{""type"":""fillet"",""edges"":[{""edge"":{""through"":[-2.5,17.5,2.5],""dir"":""Y""}},{""edge"":{""through"":[-2.5,17.5,7.5],""dir"":""Y""}},{""edge"":{""through"":[2.5,17.5,2.5],""dir"":""Y""}},{""edge"":{""through"":[2.5,17.5,7.5],""dir"":""Y""}}],""r"":1,""name"":""fillet""},{""type"":""app_specific"",""app"":""inventor"",""op"":""mirror"",""params"":{""features"":[""boss""],""plane"":""XZ""}}],""scripted"":true,""why_not"":""""},{""id"":""X15a"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_center"",""c"":[0,0,0],""w"":20,""h"":30}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":10,""direction"":""+"",""op"":""new"",""extent"":""distance""},{""type"":""chamfer"",""edge"":{""edge"":{""through"":[10,0,10],""dir"":""Y""}},""mode"":""distance"",""d1"":1",
",""flip"":false},{""type"":""fillet"",""edges"":[{""edge"":{""through"":[10,15,5],""dir"":""Z""}}],""r"":2}],""scripted"":true,""why_not"":""""},{""id"":""X15b"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_center"",""c"":[0,0,0],""w"":20,""h"":30}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":10,""direction"":""+"",""op"":""new"",""extent"":""distance""},{""type"":""fillet"",""edges"":[{""edge"":{""through"":[10,15,5],""dir"":""Z""}}],""r"":2}],""scripted"":true,""why_not"":""""},{""id"":""E01a"",""ops"":[{""type"":""app_specific"",""app"":""inventor"",""op"":""work_plane"",""params"":{""plane"":""XY"",""offset"":12}},{""type"":""app_specific"",""app"":""inventor"",""op"":""work_plane"",""params"":{""plane"":""XY"",""offset"":-3}},{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_center"",""c"":[0,0,0],""w"":20,""h"":30}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":10,""direction"":""+"",""op"":""new"",""extent"":""distance""}],""scripted"":true,""why_not"":""""},{""id"":""E",
"01b"",""ops"":[{""type"":""app_specific"",""app"":""inventor"",""op"":""work_plane"",""params"":{""plane"":""XY"",""offset"":12}},{""type"":""app_specific"",""app"":""inventor"",""op"":""work_plane"",""params"":{""plane"":""XY"",""offset"":-3}},{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_center"",""c"":[0,0,0],""w"":20,""h"":30}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":10,""direction"":""sym"",""op"":""new"",""extent"":""distance""}],""scripted"":true,""why_not"":""""},{""id"":""E01c"",""ops"":[{""type"":""app_specific"",""app"":""inventor"",""op"":""work_plane"",""params"":{""plane"":""XY"",""offset"":12}},{""type"":""app_specific"",""app"":""inventor"",""op"":""work_plane"",""params"":{""plane"":""XY"",""offset"":-3}},{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_center"",""c"":[0,0,0],""w"":20,""h"":30}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":10,""direction"":""two_sides"",""op"":""new"",""extent"":""distance"",""distance2"":4}],""scripted"":true,""why_not"":""""",
"},{""id"":""E01d"",""ops"":[{""type"":""app_specific"",""app"":""inventor"",""op"":""work_plane"",""params"":{""plane"":""XY"",""offset"":12}},{""type"":""app_specific"",""app"":""inventor"",""op"":""work_plane"",""params"":{""plane"":""XY"",""offset"":-3}},{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_center"",""c"":[0,0,0],""w"":20,""h"":30}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":10,""direction"":""+"",""op"":""new"",""extent"":""to_face"",""to_plane"":{""base"":""XY"",""offset"":12}}],""scripted"":true,""why_not"":""""},{""id"":""E01e"",""ops"":[{""type"":""app_specific"",""app"":""inventor"",""op"":""work_plane"",""params"":{""plane"":""XY"",""offset"":12}},{""type"":""app_specific"",""app"":""inventor"",""op"":""work_plane"",""params"":{""plane"":""XY"",""offset"":-3}},{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_center"",""c"":[0,0,0],""w"":20,""h"":30}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":10,""direction"":""+"",""op"":""new"",""extent"":""between"",""from_pla",
"ne"":{""base"":""XY"",""offset"":-3},""to_plane"":{""base"":""XY"",""offset"":12}}],""scripted"":true,""why_not"":""""},{""id"":""E01f"",""ops"":[{""type"":""app_specific"",""app"":""inventor"",""op"":""work_plane"",""params"":{""plane"":""XY"",""offset"":12}},{""type"":""app_specific"",""app"":""inventor"",""op"":""work_plane"",""params"":{""plane"":""XY"",""offset"":-3}},{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_center"",""c"":[0,0,0],""w"":20,""h"":30}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":10,""direction"":""+"",""op"":""new"",""extent"":""distance"",""taper"":-5}],""scripted"":true,""why_not"":""""},{""id"":""E02a"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_center"",""c"":[0,0,0],""w"":20,""h"":30}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":10,""direction"":""+"",""op"":""new"",""extent"":""distance""},{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""circle"",""c"":[0,0,0],""r"":8}],""dims"":true},{""type"":""extrude"",""profile"":""last",
""",""distance"":15,""direction"":""+"",""op"":""new"",""extent"":""distance""}],""scripted"":true,""why_not"":""""},{""id"":""E02b"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_center"",""c"":[0,0,0],""w"":20,""h"":30}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":10,""direction"":""+"",""op"":""new"",""extent"":""distance""},{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""circle"",""c"":[0,0,0],""r"":8}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":15,""direction"":""+"",""op"":""join"",""extent"":""distance""}],""scripted"":true,""why_not"":""""},{""id"":""E02c"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_center"",""c"":[0,0,0],""w"":20,""h"":30}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":10,""direction"":""+"",""op"":""new"",""extent"":""distance""},{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""circle"",""c"":[0,0,0],""r"":8}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":15",
",""direction"":""+"",""op"":""cut"",""extent"":""distance""}],""scripted"":true,""why_not"":""""},{""id"":""E02d"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_center"",""c"":[0,0,0],""w"":20,""h"":30}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":10,""direction"":""+"",""op"":""new"",""extent"":""distance""},{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""circle"",""c"":[0,0,0],""r"":8}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":15,""direction"":""+"",""op"":""intersect"",""extent"":""distance""}],""scripted"":true,""why_not"":""""},{""id"":""E02e"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_center"",""c"":[0,0,0],""w"":20,""h"":30}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":10,""direction"":""+"",""op"":""new"",""extent"":""distance""},{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""circle"",""c"":[0,0,0],""r"":8}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":15,""directio",
"n"":""+"",""op"":""cut"",""extent"":""through_all""}],""scripted"":true,""why_not"":""""},{""id"":""E03a"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_2pt"",""p1"":[0,0,0],""p2"":[100,60,0]}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":10,""direction"":""+"",""op"":""new"",""extent"":""distance""},{""type"":""app_specific"",""app"":""inventor"",""op"":""work_plane"",""params"":{""plane"":""YZ"",""offset"":30}},{""type"":""app_specific"",""app"":""inventor"",""op"":""split"",""params"":{""method"":""solid"",""tool"":{""base"":""YZ"",""offset"":30}}}],""scripted"":true,""why_not"":""""},{""id"":""E03b"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_2pt"",""p1"":[0,0,0],""p2"":[100,60,0]}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":10,""direction"":""+"",""op"":""new"",""extent"":""distance""},{""type"":""app_specific"",""app"":""inventor"",""op"":""work_plane"",""params"":{""plane"":""YZ"",""offset"":30}},{""type"":""app_specific"",""app"":""inventor"",""op"":""s",
"plit"",""params"":{""tool"":{""base"":""YZ"",""offset"":30},""method"":""trim"",""remove"":""+X""}}],""scripted"":true,""why_not"":""""},{""id"":""E03c"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_2pt"",""p1"":[0,0,0],""p2"":[100,60,0]}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":10,""direction"":""+"",""op"":""new"",""extent"":""distance""},{""type"":""app_specific"",""app"":""inventor"",""op"":""work_plane"",""params"":{""plane"":""YZ"",""offset"":30}},{""type"":""app_specific"",""app"":""inventor"",""op"":""split"",""params"":{""tool"":{""base"":""YZ"",""offset"":30},""method"":""trim"",""remove"":""-X""}}],""scripted"":true,""why_not"":""""},{""id"":""E03d"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_2pt"",""p1"":[0,0,0],""p2"":[100,60,0]}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":10,""direction"":""+"",""op"":""new"",""extent"":""distance""},{""type"":""app_specific"",""app"":""inventor"",""op"":""work_plane"",""params"":{""plane"":""YZ"",""offset"":",
"30}},{""type"":""app_specific"",""app"":""inventor"",""op"":""split"",""params"":{""tool"":{""base"":""YZ"",""offset"":30},""method"":""face"",""faces"":[{""face"":{""contains"":[50,30,10],""normal"":""+Z""}}]}}],""scripted"":true,""why_not"":""""},{""id"":""E03e"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_2pt"",""p1"":[0,0,0],""p2"":[100,60,0]}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":10,""direction"":""+"",""op"":""new"",""extent"":""distance""},{""type"":""app_specific"",""app"":""inventor"",""op"":""work_plane"",""params"":{""plane"":""YZ"",""offset"":30}},{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""line"",""a"":[30,-10,0],""b"":[30,70,0]}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":30,""direction"":""sym"",""op"":""new"",""extent"":""distance"",""surface"":true,""name"":""surface""},{""type"":""app_specific"",""app"":""inventor"",""op"":""split"",""params"":{""method"":""solid"",""tool"":""surface""}}],""scripted"":true,""why_not"":""""},{""id"":""S01a"",""",
"ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_2pt"",""p1"":[0,0,0],""p2"":[100,60,0]}],""dims"":true},{""type"":""sheetmetal"",""action"":""base_flange"",""app"":{""thickness"":2,""bend_radius"":1,""k_factor"":0.44,""corner_relief"":""round"",""corner_relief_size"":4,""corner_gap"":0.5,""bend_relief"":""default"",""direction"":""+Z"",""profile"":""last""}}],""scripted"":true,""why_not"":""""},{""id"":""S01b"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_2pt"",""p1"":[0,0,0],""p2"":[100,60,0]}],""dims"":true},{""type"":""sheetmetal"",""action"":""base_flange"",""app"":{""thickness"":2.5,""bend_radius"":1,""k_factor"":0.44,""corner_relief"":""round"",""corner_relief_size"":4,""corner_gap"":0.5,""bend_relief"":""default"",""direction"":""+Z"",""profile"":""last""}}],""scripted"":true,""why_not"":""""},{""id"":""S02a"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_2pt"",""p1"":[0,0,0],""p2"":[100,60,0]}],""dims"":true},{""type"":""sheetmetal"",""action"":""ba",
"se_flange"",""app"":{""thickness"":2,""bend_radius"":1,""k_factor"":0.44,""corner_relief"":""round"",""corner_relief_size"":4,""corner_gap"":0.5,""bend_relief"":""default"",""direction"":""+Z"",""profile"":""last""}},{""type"":""sheetmetal"",""action"":""flange"",""app"":{""edges"":[{""edge"":{""through"":[50,60,2],""dir"":""X""}}],""height"":20,""angle"":90,""direction"":""+Z"",""height_datum"":""default"",""bend_position"":""default""}}],""scripted"":true,""why_not"":""""},{""id"":""S02b"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_2pt"",""p1"":[0,0,0],""p2"":[100,60,0]}],""dims"":true},{""type"":""sheetmetal"",""action"":""base_flange"",""app"":{""thickness"":2,""bend_radius"":1,""k_factor"":0.44,""corner_relief"":""round"",""corner_relief_size"":4,""corner_gap"":0.5,""bend_relief"":""default"",""direction"":""+Z"",""profile"":""last""}},{""type"":""sheetmetal"",""action"":""flange"",""app"":{""edges"":[{""edge"":{""through"":[50,60,2],""dir"":""X""}}],""height"":25,""angle"":90,""direction"":""+Z"",""height_",
"datum"":""default"",""bend_position"":""default""}}],""scripted"":true,""why_not"":""""},{""id"":""S02c"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_2pt"",""p1"":[0,0,0],""p2"":[100,60,0]}],""dims"":true},{""type"":""sheetmetal"",""action"":""base_flange"",""app"":{""thickness"":2,""bend_radius"":1,""k_factor"":0.44,""corner_relief"":""round"",""corner_relief_size"":4,""corner_gap"":0.5,""bend_relief"":""default"",""direction"":""+Z"",""profile"":""last""}},{""type"":""sheetmetal"",""action"":""flange"",""app"":{""edges"":[{""edge"":{""through"":[50,60,2],""dir"":""X""}}],""height"":20,""angle"":60,""direction"":""+Z"",""height_datum"":""default"",""bend_position"":""default""}}],""scripted"":true,""why_not"":""""},{""id"":""S02d"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_2pt"",""p1"":[0,0,0],""p2"":[100,60,0]}],""dims"":true},{""type"":""sheetmetal"",""action"":""base_flange"",""app"":{""thickness"":2,""bend_radius"":1,""k_factor"":0.44,""corner_relief"":""round"",""corner_rel",
"ief_size"":4,""corner_gap"":0.5,""bend_relief"":""default"",""direction"":""+Z"",""profile"":""last""}},{""type"":""sheetmetal"",""action"":""flange"",""app"":{""edges"":[{""edge"":{""through"":[50,60,2],""dir"":""X""}}],""height"":20,""angle"":90,""direction"":""+Z"",""height_datum"":""alternative_default_record_option"",""bend_position"":""default""}}],""scripted"":true,""why_not"":""""},{""id"":""S02e"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_2pt"",""p1"":[0,0,0],""p2"":[100,60,0]}],""dims"":true},{""type"":""sheetmetal"",""action"":""base_flange"",""app"":{""thickness"":2,""bend_radius"":1,""k_factor"":0.44,""corner_relief"":""round"",""corner_relief_size"":4,""corner_gap"":0.5,""bend_relief"":""default"",""direction"":""+Z"",""profile"":""last""}},{""type"":""sheetmetal"",""action"":""flange"",""app"":{""edges"":[{""edge"":{""through"":[50,60,2],""dir"":""X""}}],""height"":20,""angle"":90,""direction"":""+Z"",""height_datum"":""default"",""bend_position"":""alternative_default_record_option""}}],""",
"scripted"":false,""why_not"":""sheetmetal flange bend_position: FlangeDefinition has no bend-position member (HeightDatumType is the only placement option the Inventor API exposes)""},{""id"":""S02f"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_2pt"",""p1"":[0,0,0],""p2"":[100,60,0]}],""dims"":true},{""type"":""sheetmetal"",""action"":""base_flange"",""app"":{""thickness"":2,""bend_radius"":1,""k_factor"":0.44,""corner_relief"":""round"",""corner_relief_size"":4,""corner_gap"":0.5,""bend_relief"":""default"",""direction"":""+Z"",""profile"":""last""}},{""type"":""sheetmetal"",""action"":""flange"",""app"":{""edges"":[{""edge"":{""through"":[50,60,2],""dir"":""X""}}],""height"":20,""angle"":90,""direction"":""+Z"",""height_datum"":""default"",""bend_position"":""default"",""width_type"":""width"",""offset"":20,""width"":50,""from_corner"":[0,60,2]}}],""scripted"":true,""why_not"":""""},{""id"":""S02g"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_2pt"",""p1"":[",
"0,0,0],""p2"":[100,60,0]}],""dims"":true},{""type"":""sheetmetal"",""action"":""base_flange"",""app"":{""thickness"":2,""bend_radius"":1,""k_factor"":0.44,""corner_relief"":""round"",""corner_relief_size"":4,""corner_gap"":0.5,""bend_relief"":""default"",""direction"":""+Z"",""profile"":""last""}},{""type"":""sheetmetal"",""action"":""flange"",""app"":{""edges"":[{""edge"":{""through"":[50,60,2],""dir"":""X""}}],""height"":20,""angle"":90,""direction"":""+Z"",""height_datum"":""default"",""bend_position"":""default"",""width_type"":""offset"",""offset1"":10,""offset2"":30}}],""scripted"":true,""why_not"":""""},{""id"":""S02h"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_2pt"",""p1"":[0,0,0],""p2"":[100,60,0]}],""dims"":true},{""type"":""sheetmetal"",""action"":""base_flange"",""app"":{""thickness"":2,""bend_radius"":1,""k_factor"":0.44,""corner_relief"":""round"",""corner_relief_size"":4,""corner_gap"":0.5,""bend_relief"":""default"",""direction"":""+Z"",""profile"":""last""}},{""type"":""sheetmetal"",""acti",
"on"":""flange"",""app"":{""edges"":[{""edge"":{""through"":[50,60,2],""dir"":""X""}}],""height"":20,""angle"":90,""direction"":""+Z"",""height_datum"":""default"",""bend_position"":""default"",""bend_relief_depth"":1}}],""scripted"":true,""why_not"":""""},{""id"":""S02i"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_2pt"",""p1"":[0,0,0],""p2"":[100,60,0]}],""dims"":true},{""type"":""sheetmetal"",""action"":""base_flange"",""app"":{""thickness"":2,""bend_radius"":1,""k_factor"":0.44,""corner_relief"":""round"",""corner_relief_size"":4,""corner_gap"":0.5,""bend_relief"":""default"",""direction"":""+Z"",""profile"":""last""}},{""type"":""sheetmetal"",""action"":""flange"",""app"":{""edges"":[{""edge"":{""through"":[50,60,2],""dir"":""X""}}],""height"":20,""angle"":90,""direction"":""+Z"",""height_datum"":""default"",""bend_position"":""default"",""bend_transition"":""arc_unless_default_then_straight_line""}}],""scripted"":true,""why_not"":""""},{""id"":""S03a"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entitie",
"s"":[{""type"":""rect_2pt"",""p1"":[0,0,0],""p2"":[100,60,0]}],""dims"":true},{""type"":""sheetmetal"",""action"":""base_flange"",""app"":{""thickness"":2,""bend_radius"":1,""k_factor"":0.44,""corner_relief"":""round"",""corner_relief_size"":4,""corner_gap"":0.5,""bend_relief"":""default"",""direction"":""+Z"",""profile"":""last""}},{""type"":""sheetmetal"",""action"":""flange"",""app"":{""edges"":[{""edge"":{""through"":[50,60,2],""dir"":""X""}},{""edge"":{""through"":[100,30,2],""dir"":""Y""}}],""height"":20,""angle"":90,""direction"":""+Z"",""height_datum"":""default"",""bend_position"":""default"",""bend_radius"":1,""corner_relief"":""round"",""corner_relief_size"":4,""corner_gap"":0.5}}],""scripted"":true,""why_not"":""""},{""id"":""S03b"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_2pt"",""p1"":[0,0,0],""p2"":[100,60,0]}],""dims"":true},{""type"":""sheetmetal"",""action"":""base_flange"",""app"":{""thickness"":2,""bend_radius"":1,""k_factor"":0.44,""corner_relief"":""round"",""corner_relief_size"":4,",
"""corner_gap"":0.5,""bend_relief"":""default"",""direction"":""+Z"",""profile"":""last""}},{""type"":""sheetmetal"",""action"":""flange"",""app"":{""edges"":[{""edge"":{""through"":[50,60,2],""dir"":""X""}},{""edge"":{""through"":[100,30,2],""dir"":""Y""}}],""height"":20,""angle"":90,""direction"":""+Z"",""height_datum"":""default"",""bend_position"":""default"",""bend_radius"":1,""corner_relief"":""square"",""corner_relief_size"":4,""corner_gap"":0.5}}],""scripted"":true,""why_not"":""""},{""id"":""S03c"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_2pt"",""p1"":[0,0,0],""p2"":[100,60,0]}],""dims"":true},{""type"":""sheetmetal"",""action"":""base_flange"",""app"":{""thickness"":2,""bend_radius"":1,""k_factor"":0.44,""corner_relief"":""round"",""corner_relief_size"":4,""corner_gap"":0.5,""bend_relief"":""default"",""direction"":""+Z"",""profile"":""last""}},{""type"":""sheetmetal"",""action"":""flange"",""app"":{""edges"":[{""edge"":{""through"":[50,60,2],""dir"":""X""}},{""edge"":{""through"":[100,30,2],""dir"":""",
"Y""}}],""height"":20,""angle"":90,""direction"":""+Z"",""height_datum"":""default"",""bend_position"":""default"",""bend_radius"":1,""corner_relief"":""tear"",""corner_relief_size"":4,""corner_gap"":0.5}}],""scripted"":true,""why_not"":""""},{""id"":""S03d"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_2pt"",""p1"":[0,0,0],""p2"":[100,60,0]}],""dims"":true},{""type"":""sheetmetal"",""action"":""base_flange"",""app"":{""thickness"":2,""bend_radius"":1,""k_factor"":0.44,""corner_relief"":""round"",""corner_relief_size"":4,""corner_gap"":0.5,""bend_relief"":""default"",""direction"":""+Z"",""profile"":""last""}},{""type"":""sheetmetal"",""action"":""flange"",""app"":{""edges"":[{""edge"":{""through"":[50,60,2],""dir"":""X""}},{""edge"":{""through"":[100,30,2],""dir"":""Y""}}],""height"":20,""angle"":90,""direction"":""+Z"",""height_datum"":""default"",""bend_position"":""default"",""bend_radius"":1,""corner_relief"":""round"",""corner_relief_size"":5,""corner_gap"":0.5}}],""scripted"":true,""why_not"":""""},{""",
"id"":""S03e"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_2pt"",""p1"":[0,0,0],""p2"":[100,60,0]}],""dims"":true},{""type"":""sheetmetal"",""action"":""base_flange"",""app"":{""thickness"":2,""bend_radius"":1,""k_factor"":0.44,""corner_relief"":""round"",""corner_relief_size"":4,""corner_gap"":0.5,""bend_relief"":""default"",""direction"":""+Z"",""profile"":""last""}},{""type"":""sheetmetal"",""action"":""flange"",""app"":{""edges"":[{""edge"":{""through"":[50,60,2],""dir"":""X""}},{""edge"":{""through"":[100,30,2],""dir"":""Y""}}],""height"":20,""angle"":90,""direction"":""+Z"",""height_datum"":""default"",""bend_position"":""default"",""bend_radius"":1,""corner_relief"":""round"",""corner_relief_size"":4,""corner_gap"":0.8}}],""scripted"":true,""why_not"":""""},{""id"":""S03f"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_2pt"",""p1"":[0,0,0],""p2"":[100,60,0]}],""dims"":true},{""type"":""sheetmetal"",""action"":""base_flange"",""app"":{""thickness"":2,""bend_radius"":1,""k_fact",
"or"":0.44,""corner_relief"":""round"",""corner_relief_size"":4,""corner_gap"":0.5,""bend_relief"":""default"",""direction"":""+Z"",""profile"":""last""}},{""type"":""sheetmetal"",""action"":""flange"",""app"":{""edges"":[{""edge"":{""through"":[50,60,2],""dir"":""X""}},{""edge"":{""through"":[100,30,2],""dir"":""Y""}}],""height"":20,""angle"":90,""direction"":""+Z"",""height_datum"":""default"",""bend_position"":""default"",""bend_radius"":1,""corner_relief"":""round"",""corner_relief_size"":4,""corner_gap"":0.5,""bend_relief"":""round"",""bend_relief_width"":""default""}}],""scripted"":true,""why_not"":""""},{""id"":""S04a"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_2pt"",""p1"":[0,0,0],""p2"":[100,60,0]}],""dims"":true},{""type"":""sheetmetal"",""action"":""base_flange"",""app"":{""thickness"":2,""bend_radius"":1,""k_factor"":0.44,""corner_relief"":""round"",""corner_relief_size"":4,""corner_gap"":0.5,""bend_relief"":""default"",""direction"":""+Z"",""profile"":""last""}},{""type"":""sheetmetal"",""acti",
"on"":""flange"",""app"":{""edges"":[{""edge"":{""through"":[50,60,2],""dir"":""X""}}],""height"":20,""angle"":90,""direction"":""+Z"",""height_datum"":""default"",""bend_position"":""default""}},{""type"":""sheetmetal"",""action"":""hem"",""app"":{""edge"":{""edge"":{""through"":[50,60,20],""dir"":""X""},""feature"":""flange_free_edge""},""hem_type"":""single"",""direction"":""-Y"",""gap"":1,""length"":8}}],""scripted"":true,""why_not"":""""},{""id"":""S04b"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_2pt"",""p1"":[0,0,0],""p2"":[100,60,0]}],""dims"":true},{""type"":""sheetmetal"",""action"":""base_flange"",""app"":{""thickness"":2,""bend_radius"":1,""k_factor"":0.44,""corner_relief"":""round"",""corner_relief_size"":4,""corner_gap"":0.5,""bend_relief"":""default"",""direction"":""+Z"",""profile"":""last""}},{""type"":""sheetmetal"",""action"":""flange"",""app"":{""edges"":[{""edge"":{""through"":[50,60,2],""dir"":""X""}}],""height"":20,""angle"":90,""direction"":""+Z"",""height_datum"":""default"",""bend_position"":""d",
"efault""}},{""type"":""sheetmetal"",""action"":""hem"",""app"":{""edge"":{""edge"":{""through"":[50,60,20],""dir"":""X""},""feature"":""flange_free_edge""},""hem_type"":""single"",""direction"":""-Y"",""gap"":1.5,""length"":8}}],""scripted"":true,""why_not"":""""},{""id"":""S04c"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_2pt"",""p1"":[0,0,0],""p2"":[100,60,0]}],""dims"":true},{""type"":""sheetmetal"",""action"":""base_flange"",""app"":{""thickness"":2,""bend_radius"":1,""k_factor"":0.44,""corner_relief"":""round"",""corner_relief_size"":4,""corner_gap"":0.5,""bend_relief"":""default"",""direction"":""+Z"",""profile"":""last""}},{""type"":""sheetmetal"",""action"":""flange"",""app"":{""edges"":[{""edge"":{""through"":[50,60,2],""dir"":""X""}}],""height"":20,""angle"":90,""direction"":""+Z"",""height_datum"":""default"",""bend_position"":""default""}},{""type"":""sheetmetal"",""action"":""hem"",""app"":{""edge"":{""edge"":{""through"":[50,60,20],""dir"":""X""},""feature"":""flange_free_edge""},""hem_type"":""double"",""",
"direction"":""-Y"",""gap"":""default"",""length"":""default""}}],""scripted"":true,""why_not"":""""},{""id"":""S04d"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_2pt"",""p1"":[0,0,0],""p2"":[100,60,0]}],""dims"":true},{""type"":""sheetmetal"",""action"":""base_flange"",""app"":{""thickness"":2,""bend_radius"":1,""k_factor"":0.44,""corner_relief"":""round"",""corner_relief_size"":4,""corner_gap"":0.5,""bend_relief"":""default"",""direction"":""+Z"",""profile"":""last""}},{""type"":""sheetmetal"",""action"":""flange"",""app"":{""edges"":[{""edge"":{""through"":[50,60,2],""dir"":""X""}}],""height"":20,""angle"":90,""direction"":""+Z"",""height_datum"":""default"",""bend_position"":""default""}},{""type"":""sheetmetal"",""action"":""hem"",""app"":{""edge"":{""edge"":{""through"":[50,60,20],""dir"":""X""},""feature"":""flange_free_edge""},""hem_type"":""teardrop"",""direction"":""-Y"",""gap"":""default"",""length"":""default""}}],""scripted"":true,""why_not"":""""},{""id"":""S04e"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""e",
"ntities"":[{""type"":""rect_2pt"",""p1"":[0,0,0],""p2"":[100,60,0]}],""dims"":true},{""type"":""sheetmetal"",""action"":""base_flange"",""app"":{""thickness"":2,""bend_radius"":1,""k_factor"":0.44,""corner_relief"":""round"",""corner_relief_size"":4,""corner_gap"":0.5,""bend_relief"":""default"",""direction"":""+Z"",""profile"":""last""}},{""type"":""sheetmetal"",""action"":""flange"",""app"":{""edges"":[{""edge"":{""through"":[50,60,2],""dir"":""X""}}],""height"":20,""angle"":90,""direction"":""+Z"",""height_datum"":""default"",""bend_position"":""default""}},{""type"":""sheetmetal"",""action"":""hem"",""app"":{""edge"":{""edge"":{""through"":[50,60,20],""dir"":""X""},""feature"":""flange_free_edge""},""hem_type"":""rolled"",""direction"":""-Y"",""gap"":""default"",""length"":""default""}}],""scripted"":true,""why_not"":""""},{""id"":""S04f"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_2pt"",""p1"":[0,0,0],""p2"":[100,60,0]}],""dims"":true},{""type"":""sheetmetal"",""action"":""base_flange"",""app"":{""thickness"":2,",
"""bend_radius"":1,""k_factor"":0.44,""corner_relief"":""round"",""corner_relief_size"":4,""corner_gap"":0.5,""bend_relief"":""default"",""direction"":""+Z"",""profile"":""last""}},{""type"":""sheetmetal"",""action"":""flange"",""app"":{""edges"":[{""edge"":{""through"":[50,60,2],""dir"":""X""}}],""height"":20,""angle"":90,""direction"":""+Z"",""height_datum"":""default"",""bend_position"":""default""}},{""type"":""sheetmetal"",""action"":""hem"",""app"":{""edge"":{""edge"":{""through"":[50,60,20],""dir"":""X""},""feature"":""flange_free_edge""},""hem_type"":""single"",""direction"":""+Y"",""gap"":1,""length"":8}}],""scripted"":true,""why_not"":""""},{""id"":""S04g"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_2pt"",""p1"":[0,0,0],""p2"":[100,60,0]}],""dims"":true},{""type"":""sheetmetal"",""action"":""base_flange"",""app"":{""thickness"":2,""bend_radius"":1,""k_factor"":0.44,""corner_relief"":""round"",""corner_relief_size"":4,""corner_gap"":0.5,""bend_relief"":""default"",""direction"":""+Z"",""profile"":""last""}",
"},{""type"":""sheetmetal"",""action"":""flange"",""app"":{""edges"":[{""edge"":{""through"":[50,60,2],""dir"":""X""}}],""height"":20,""angle"":90,""direction"":""+Z"",""height_datum"":""default"",""bend_position"":""default""}},{""type"":""sheetmetal"",""action"":""hem"",""app"":{""edge"":{""edge"":{""through"":[50,60,20],""dir"":""X""},""feature"":""flange_free_edge""},""hem_type"":""single"",""direction"":""-Y"",""gap"":1,""length"":12}}],""scripted"":true,""why_not"":""""},{""id"":""S05a"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_2pt"",""p1"":[0,0,0],""p2"":[100,60,0]}],""dims"":true},{""type"":""sheetmetal"",""action"":""base_flange"",""app"":{""thickness"":2,""bend_radius"":1,""k_factor"":0.44,""corner_relief"":""round"",""corner_relief_size"":4,""corner_gap"":0.5,""bend_relief"":""default"",""direction"":""+Z"",""profile"":""last""}},{""type"":""sheetmetal"",""action"":""flange"",""app"":{""edges"":[{""edge"":{""through"":[50,60,2],""dir"":""X""}},{""edge"":{""through"":[100,30,2],""dir"":""Y""}}],""height"":20,",
"""angle"":90,""direction"":""+Z"",""height_datum"":""default"",""bend_position"":""default"",""bend_radius"":1,""corner_relief"":""round"",""corner_relief_size"":4,""corner_gap"":0.5}},{""type"":""sheetmetal"",""action"":""flat_pattern"",""app"":{""save_state"":""folded""}}],""scripted"":true,""why_not"":""""},{""id"":""S06a"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_2pt"",""p1"":[0,0,0],""p2"":[100,60,0]}],""dims"":true},{""type"":""sheetmetal"",""action"":""base_flange"",""app"":{""thickness"":2,""bend_radius"":1,""k_factor"":0.44,""corner_relief"":""round"",""corner_relief_size"":4,""corner_gap"":0.5,""bend_relief"":""default"",""direction"":""+Z"",""profile"":""last""}},{""type"":""sheetmetal"",""action"":""flange"",""app"":{""edges"":[{""edge"":{""through"":[50,60,2],""dir"":""X""}}],""height"":20,""angle"":90,""direction"":""+Z"",""height_datum"":""default"",""bend_position"":""default"",""bend_relief"":""round"",""bend_relief_width"":3}}],""scripted"":true,""why_not"":""""},{""id"":""S06b"",""ops"":[{",
"""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_2pt"",""p1"":[0,0,0],""p2"":[100,60,0]}],""dims"":true},{""type"":""sheetmetal"",""action"":""base_flange"",""app"":{""thickness"":2,""bend_radius"":1,""k_factor"":0.44,""corner_relief"":""round"",""corner_relief_size"":4,""corner_gap"":0.5,""bend_relief"":""default"",""direction"":""+Z"",""profile"":""last""}},{""type"":""sheetmetal"",""action"":""flange"",""app"":{""edges"":[{""edge"":{""through"":[50,60,2],""dir"":""X""}}],""height"":20,""angle"":90,""direction"":""+Z"",""height_datum"":""default"",""bend_position"":""default"",""bend_relief"":""straight"",""bend_relief_width"":3}}],""scripted"":true,""why_not"":""""},{""id"":""S06c"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_2pt"",""p1"":[0,0,0],""p2"":[100,60,0]}],""dims"":true},{""type"":""sheetmetal"",""action"":""base_flange"",""app"":{""thickness"":2,""bend_radius"":1,""k_factor"":0.44,""corner_relief"":""round"",""corner_relief_size"":4,""corner_gap"":0.5,""bend_relief"":""defaul",
"t"",""direction"":""+Z"",""profile"":""last""}},{""type"":""sheetmetal"",""action"":""flange"",""app"":{""edges"":[{""edge"":{""through"":[50,60,2],""dir"":""X""}}],""height"":20,""angle"":90,""direction"":""+Z"",""height_datum"":""default"",""bend_position"":""default"",""bend_relief"":""default"",""bend_relief_width"":3}}],""scripted"":true,""why_not"":""""},{""id"":""S06d"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_2pt"",""p1"":[0,0,0],""p2"":[100,60,0]}],""dims"":true},{""type"":""sheetmetal"",""action"":""base_flange"",""app"":{""thickness"":2,""bend_radius"":1,""k_factor"":0.44,""corner_relief"":""round"",""corner_relief_size"":4,""corner_gap"":0.5,""bend_relief"":""default"",""direction"":""+Z"",""profile"":""last""}},{""type"":""sheetmetal"",""action"":""flange"",""app"":{""edges"":[{""edge"":{""through"":[50,60,2],""dir"":""X""}}],""height"":20,""angle"":90,""direction"":""+Z"",""height_datum"":""default"",""bend_position"":""default"",""bend_relief"":""round"",""bend_relief_width"":""default""}}],""scri",
"pted"":true,""why_not"":""""},{""id"":""S07a"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_2pt"",""p1"":[0,0,0],""p2"":[100,60,0]}],""dims"":true},{""type"":""sheetmetal"",""action"":""base_flange"",""app"":{""thickness"":2,""bend_radius"":1,""k_factor"":0.44,""corner_relief"":""round"",""corner_relief_size"":4,""corner_gap"":0.5,""bend_relief"":""default"",""direction"":""+Z"",""profile"":""last""}},{""type"":""sheetmetal"",""action"":""corner_round"",""app"":{""corners"":[[100,60,2]],""r"":3}}],""scripted"":true,""why_not"":""""},{""id"":""S07b"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_2pt"",""p1"":[0,0,0],""p2"":[100,60,0]}],""dims"":true},{""type"":""sheetmetal"",""action"":""base_flange"",""app"":{""thickness"":2,""bend_radius"":1,""k_factor"":0.44,""corner_relief"":""round"",""corner_relief_size"":4,""corner_gap"":0.5,""bend_relief"":""default"",""direction"":""+Z"",""profile"":""last""}},{""type"":""sheetmetal"",""action"":""corner_round"",""app"":{""corners"":[[100,6",
"0,2]],""r"":5}}],""scripted"":true,""why_not"":""""},{""id"":""S07c"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_2pt"",""p1"":[0,0,0],""p2"":[100,60,0]}],""dims"":true},{""type"":""sheetmetal"",""action"":""base_flange"",""app"":{""thickness"":2,""bend_radius"":1,""k_factor"":0.44,""corner_relief"":""round"",""corner_relief_size"":4,""corner_gap"":0.5,""bend_relief"":""default"",""direction"":""+Z"",""profile"":""last""}},{""type"":""sheetmetal"",""action"":""corner_round"",""app"":{""corners"":[[0,0,2],[100,0,2],[100,60,2],[0,60,2]],""r"":3}}],""scripted"":true,""why_not"":""""},{""id"":""S08a"",""ops"":[{""type"":""sketch"",""plane"":""XZ"",""entities"":[{""type"":""line"",""a"":[0,0,0],""b"":[50,0,0]},{""type"":""line"",""a"":[50,0,0],""b"":[50,0,30]}],""dims"":true},{""type"":""sheetmetal"",""action"":""contour_flange"",""app"":{""thickness"":2,""bend_radius"":1,""k_factor"":0.44,""corner_relief"":""round"",""corner_relief_size"":4,""corner_gap"":0.5,""bend_relief"":""default"",""profile"":""last"",""wi",
"dth"":40,""axis"":""Y"",""thickness_side"":""default""}}],""scripted"":true,""why_not"":"""",""open_path_sketches"":[0]},{""id"":""S08b"",""ops"":[{""type"":""sketch"",""plane"":""XZ"",""entities"":[{""type"":""line"",""a"":[0,0,0],""b"":[50,0,0]},{""type"":""line"",""a"":[50,0,0],""b"":[50,0,30]}],""dims"":true},{""type"":""sheetmetal"",""action"":""contour_flange"",""app"":{""thickness"":2,""bend_radius"":1,""k_factor"":0.44,""corner_relief"":""round"",""corner_relief_size"":4,""corner_gap"":0.5,""bend_relief"":""default"",""profile"":""last"",""width"":50,""axis"":""Y"",""thickness_side"":""default""}}],""scripted"":true,""why_not"":"""",""open_path_sketches"":[0]},{""id"":""S09a"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_2pt"",""p1"":[0,0,0],""p2"":[100,60,0]}],""dims"":true},{""type"":""sheetmetal"",""action"":""base_flange"",""app"":{""thickness"":2,""bend_radius"":1,""k_factor"":0.44,""corner_relief"":""round"",""corner_relief_size"":4,""corner_gap"":0.5,""bend_relief"":""default"",""direction"":""+",
"Z"",""profile"":""last""}},{""type"":""sketch"",""plane"":""YZ"",""entities"":[{""type"":""line"",""a"":[0,0,2],""b"":[0,0,22]},{""type"":""line"",""a"":[0,0,22],""b"":[0,10,22]}],""dims"":true},{""type"":""sheetmetal"",""action"":""contour_flange"",""app"":{""profile"":""last"",""edge"":{""edge"":{""through"":[50,0,2],""dir"":""X""}},""extent"":""edge"",""failure_policy"":""retry_other_material_side_then_preserve_failed_feature""}}],""scripted"":true,""why_not"":"""",""open_path_sketches"":[2]},{""id"":""S09b"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_2pt"",""p1"":[0,0,0],""p2"":[100,60,0]}],""dims"":true},{""type"":""sheetmetal"",""action"":""base_flange"",""app"":{""thickness"":2,""bend_radius"":1,""k_factor"":0.44,""corner_relief"":""round"",""corner_relief_size"":4,""corner_gap"":0.5,""bend_relief"":""default"",""direction"":""+Z"",""profile"":""last""}},{""type"":""sketch"",""plane"":""YZ"",""entities"":[{""type"":""line"",""a"":[0,0,2],""b"":[0,0,22]},{""type"":""line"",""a"":[0,0,22],""b"":[0,15,22]}]",
",""dims"":true},{""type"":""sheetmetal"",""action"":""contour_flange"",""app"":{""profile"":""last"",""edge"":{""edge"":{""through"":[50,0,2],""dir"":""X""}},""extent"":""edge"",""failure_policy"":""retry_other_material_side_then_preserve_failed_feature""}}],""scripted"":true,""why_not"":"""",""open_path_sketches"":[2]},{""id"":""S10a"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_2pt"",""p1"":[0,0,0],""p2"":[100,60,0]}],""dims"":true},{""type"":""sheetmetal"",""action"":""base_flange"",""app"":{""thickness"":2,""bend_radius"":1,""k_factor"":0.44,""corner_relief"":""round"",""corner_relief_size"":4,""corner_gap"":0.5,""bend_relief"":""default"",""direction"":""+Z"",""profile"":""last""}},{""type"":""sketch"",""plane"":{""base"":""XZ"",""offset"":65},""entities"":[{""type"":""rect_2pt"",""p1"":[0,65,10],""p2"":[100,65,30]}],""dims"":true},{""type"":""sheetmetal"",""action"":""face"",""app"":{""profile"":""last"",""thickness"":2,""direction"":""-Y""}},{""type"":""sheetmetal"",""action"":""bend"",""app"":{""edges""",
":[{""edge"":{""through"":[50,60,2],""dir"":""X""}},{""edge"":{""through"":[50,65,10],""dir"":""X""}}],""options"":""default""}}],""scripted"":true,""why_not"":""""},{""id"":""S11a"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_2pt"",""p1"":[0,0,0],""p2"":[100,60,0]}],""dims"":true},{""type"":""sheetmetal"",""action"":""base_flange"",""app"":{""thickness"":2,""bend_radius"":1,""k_factor"":0.44,""corner_relief"":""round"",""corner_relief_size"":4,""corner_gap"":0.5,""bend_relief"":""default"",""direction"":""+Z"",""profile"":""last""}},{""type"":""sheetmetal"",""action"":""flange"",""app"":{""edges"":[{""edge"":{""through"":[50,60,2],""dir"":""X""}}],""height"":20,""angle"":90,""direction"":""+Z"",""height_datum"":""default"",""bend_position"":""default""}},{""type"":""sheetmetal"",""action"":""unfold"",""app"":{""stationary_face"":{""face"":{""contains"":[50,30,2],""normal"":""+Z""}},""bend"":""flange_bend""}}],""scripted"":true,""why_not"":""""},{""id"":""S11b"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":",
"[{""type"":""rect_2pt"",""p1"":[0,0,0],""p2"":[100,60,0]}],""dims"":true},{""type"":""sheetmetal"",""action"":""base_flange"",""app"":{""thickness"":2,""bend_radius"":1,""k_factor"":0.44,""corner_relief"":""round"",""corner_relief_size"":4,""corner_gap"":0.5,""bend_relief"":""default"",""direction"":""+Z"",""profile"":""last""}},{""type"":""sheetmetal"",""action"":""flange"",""app"":{""edges"":[{""edge"":{""through"":[50,60,2],""dir"":""X""}}],""height"":20,""angle"":90,""direction"":""+Z"",""height_datum"":""default"",""bend_position"":""default""}},{""type"":""sheetmetal"",""action"":""unfold"",""app"":{""stationary_face"":{""face"":{""contains"":[50,30,2],""normal"":""+Z""}},""bend"":""flange_bend""}},{""type"":""sheetmetal"",""action"":""refold"",""app"":{""bend"":""flange_bend""}}],""scripted"":true,""why_not"":""""},{""id"":""S12a"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_2pt"",""p1"":[0,0,0],""p2"":[100,60,0]}],""dims"":true},{""type"":""sheetmetal"",""action"":""base_flange"",""app"":{""thickness"":2,""b",
"end_radius"":1,""k_factor"":0.44,""corner_relief"":""round"",""corner_relief_size"":4,""corner_gap"":0.5,""bend_relief"":""default"",""direction"":""+Z"",""profile"":""last""}},{""type"":""sheetmetal"",""action"":""flange"",""app"":{""edges"":[{""edge"":{""through"":[50,60,2],""dir"":""X""}}],""height"":20,""angle"":90,""direction"":""+Z"",""height_datum"":""default"",""bend_position"":""default""}},{""type"":""sheetmetal"",""action"":""unfold"",""app"":{""stationary_face"":{""face"":{""contains"":[50,30,2],""normal"":""+Z""}},""bend"":""flange_bend""}},{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_2pt"",""p1"":[40,50,2],""p2"":[60,66,2]}],""dims"":true,""on_face"":{""face"":{""contains"":[50,55,2],""normal"":""+Z""}}},{""type"":""sheetmetal"",""action"":""cut"",""app"":{""profile"":""last"",""extent"":""through_all""}},{""type"":""sheetmetal"",""action"":""refold"",""app"":{""bend"":""flange_bend""}}],""scripted"":true,""why_not"":""""},{""id"":""S13a"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_",
"2pt"",""p1"":[0,0,0],""p2"":[100,60,0]}],""dims"":true},{""type"":""sheetmetal"",""action"":""base_flange"",""app"":{""thickness"":2,""bend_radius"":1,""k_factor"":0.44,""corner_relief"":""round"",""corner_relief_size"":4,""corner_gap"":0.5,""bend_relief"":""default"",""direction"":""+Z"",""profile"":""last""}},{""type"":""hole"",""at"":[10,10,2],""on_face"":{""face"":{""contains"":[10,10,2],""normal"":""+Z""}},""hole_type"":""simple"",""dia"":6,""through_all"":true,""name"":""hole""}],""scripted"":true,""why_not"":""""},{""id"":""S13b"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_2pt"",""p1"":[0,0,0],""p2"":[100,60,0]}],""dims"":true},{""type"":""sheetmetal"",""action"":""base_flange"",""app"":{""thickness"":2,""bend_radius"":1,""k_factor"":0.44,""corner_relief"":""round"",""corner_relief_size"":4,""corner_gap"":0.5,""bend_relief"":""default"",""direction"":""+Z"",""profile"":""last""}},{""type"":""hole"",""at"":[10,10,2],""on_face"":{""face"":{""contains"":[10,10,2],""normal"":""+Z""}},""hole_type"":""simpl",
"e"",""dia"":6,""through_all"":true,""name"":""hole""},{""type"":""pattern_rect"",""feature"":""hole"",""dir1"":{""axis"":""X"",""count"":3,""spacing"":15},""dir2"":{""axis"":""Y"",""count"":1,""spacing"":15},""name"":""pattern""}],""scripted"":true,""why_not"":""""},{""id"":""S13c"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_2pt"",""p1"":[0,0,0],""p2"":[100,60,0]}],""dims"":true},{""type"":""sheetmetal"",""action"":""base_flange"",""app"":{""thickness"":2,""bend_radius"":1,""k_factor"":0.44,""corner_relief"":""round"",""corner_relief_size"":4,""corner_gap"":0.5,""bend_relief"":""default"",""direction"":""+Z"",""profile"":""last""}},{""type"":""hole"",""at"":[10,10,2],""on_face"":{""face"":{""contains"":[10,10,2],""normal"":""+Z""}},""hole_type"":""simple"",""dia"":6,""through_all"":true,""name"":""hole""},{""type"":""pattern_rect"",""feature"":""hole"",""dir1"":{""axis"":""X"",""count"":3,""spacing"":15},""dir2"":{""axis"":""Y"",""count"":1,""spacing"":15},""name"":""pattern""},{""type"":""app_specific"",""app"":""inventor"",""",
"op"":""work_plane"",""params"":{""plane"":""YZ"",""offset"":50}},{""type"":""app_specific"",""app"":""inventor"",""op"":""mirror"",""params"":{""features"":[""hole"",""pattern""],""plane"":{""base"":""YZ"",""offset"":50}}}],""scripted"":true,""why_not"":""""},{""id"":""S13d"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_2pt"",""p1"":[0,0,0],""p2"":[100,60,0]}],""dims"":true},{""type"":""sheetmetal"",""action"":""base_flange"",""app"":{""thickness"":2,""bend_radius"":1,""k_factor"":0.44,""corner_relief"":""round"",""corner_relief_size"":4,""corner_gap"":0.5,""bend_relief"":""default"",""direction"":""+Z"",""profile"":""last""}},{""type"":""hole"",""at"":[10,10,2],""on_face"":{""face"":{""contains"":[10,10,2],""normal"":""+Z""}},""hole_type"":""simple"",""dia"":6,""through_all"":true,""name"":""hole""},{""type"":""pattern_rect"",""feature"":""hole"",""dir1"":{""axis"":""X"",""count"":3,""spacing"":15},""dir2"":{""axis"":""Y"",""count"":1,""spacing"":15},""name"":""pattern""},{""type"":""app_specific"",""app"":""inventor"",""op"":""",
"work_plane"",""params"":{""plane"":""YZ"",""offset"":50}},{""type"":""app_specific"",""app"":""inventor"",""op"":""mirror"",""params"":{""features"":[""hole"",""pattern""],""plane"":{""base"":""YZ"",""offset"":50}}},{""type"":""sheetmetal"",""action"":""flat_pattern"",""app"":{""save_state"":""folded""}}],""scripted"":true,""why_not"":""""},{""id"":""S14a"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_2pt"",""p1"":[0,0,0],""p2"":[100,60,0]}],""dims"":true},{""type"":""sheetmetal"",""action"":""base_flange"",""app"":{""thickness"":2,""bend_radius"":1,""k_factor"":0.44,""corner_relief"":""round"",""corner_relief_size"":4,""corner_gap"":0.5,""bend_relief"":""default"",""direction"":""+Z"",""profile"":""last""}},{""type"":""sheetmetal"",""action"":""flange"",""app"":{""edges"":[{""edge"":{""through"":[50,60,2],""dir"":""X""}}],""height"":20,""angle"":90,""direction"":""+Z"",""height_datum"":""default"",""bend_position"":""default""}},{""type"":""app_specific"",""app"":""inventor"",""op"":""work_plane"",""params"":{""plane"":""X",
"Z"",""offset"":30}},{""type"":""app_specific"",""app"":""inventor"",""op"":""mirror"",""params"":{""features"":[""flange""],""plane"":{""base"":""XZ"",""offset"":30}}}],""scripted"":true,""why_not"":""""},{""id"":""S15a"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_2pt"",""p1"":[0,0,0],""p2"":[100,60,0]}],""dims"":true},{""type"":""sheetmetal"",""action"":""base_flange"",""app"":{""thickness"":2,""bend_radius"":1,""k_factor"":0.44,""corner_relief"":""round"",""corner_relief_size"":4,""corner_gap"":0.5,""bend_relief"":""default"",""direction"":""+Z"",""profile"":""last""}},{""type"":""sheetmetal"",""action"":""corner_round"",""app"":{""corners"":[[100,60,2],[0,60,2]],""r"":3}}],""scripted"":true,""why_not"":""""},{""id"":""S15b"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_2pt"",""p1"":[0,0,0],""p2"":[100,60,0]}],""dims"":true},{""type"":""sheetmetal"",""action"":""base_flange"",""app"":{""thickness"":2,""bend_radius"":1,""k_factor"":0.44,""corner_relief"":""round"",""corner_relief_",
"size"":4,""corner_gap"":0.5,""bend_relief"":""default"",""direction"":""+Z"",""profile"":""last""}},{""type"":""sheetmetal"",""action"":""corner_round"",""app"":{""corners"":[[100,60,2],[0,60,2]],""r"":3}},{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""rect_2pt"",""p1"":[-5,50,2],""p2"":[10,65,2]}],""dims"":true,""on_face"":{""face"":{""contains"":[50,30,2],""normal"":""+Z""}}},{""type"":""sheetmetal"",""action"":""cut"",""app"":{""profile"":""last"",""extent"":""through_all""}}],""scripted"":true,""why_not"":""""},{""id"":""A01a"",""ops"":[{""type"":""assembly"",""insert"":{""recipe"":""P01a"",""at"":[0,0,0],""grounded"":true,""name"":""block""}},{""type"":""assembly"",""insert"":{""recipe"":""P02a"",""at"":""off_to_side_default"",""grounded"":false,""name"":""ring""}}],""scripted"":true,""why_not"":""""},{""id"":""A01b"",""ops"":[{""type"":""assembly"",""insert"":{""recipe"":""P01a"",""at"":[0,0,0],""grounded"":true,""name"":""block""}},{""type"":""assembly"",""insert"":{""recipe"":""P02a"",""at"":""off_to_side_default"",""grounded"":fals",
"e,""name"":""ring""}},{""type"":""assembly"",""component"":""block"",""grounded"":false}],""scripted"":true,""why_not"":""""},{""id"":""A01c"",""ops"":[{""type"":""assembly"",""insert"":{""recipe"":""P01a"",""at"":[0,0,0],""grounded"":true,""name"":""block""}},{""type"":""assembly"",""insert"":{""recipe"":""P02a"",""at"":""off_to_side_default"",""grounded"":false,""name"":""ring""}},{""type"":""assembly"",""component"":""ring"",""grounded"":true}],""scripted"":true,""why_not"":""""},{""id"":""A01d"",""ops"":[{""type"":""assembly"",""insert"":{""recipe"":""P01a"",""at"":[0,0,0],""grounded"":true,""name"":""block""}},{""type"":""assembly"",""insert"":{""recipe"":""P02a"",""at"":""off_to_side_default"",""grounded"":false,""name"":""ring""}},{""type"":""assembly"",""component"":""ring"",""visible"":false}],""scripted"":true,""why_not"":""""},{""id"":""A01e"",""ops"":[{""type"":""assembly"",""insert"":{""recipe"":""P01a"",""at"":[0,0,0],""grounded"":true,""name"":""block""}},{""type"":""assembly"",""insert"":{""recipe"":""P02a"",""at"":""off_to_side_default"",""ground",
"ed"":false,""name"":""ring""}},{""type"":""assembly"",""component"":""ring"",""suppressed"":true}],""scripted"":true,""why_not"":""""},{""id"":""A02a"",""ops"":[{""type"":""assembly"",""insert"":{""recipe"":""P01a"",""at"":[0,0,0],""grounded"":true,""name"":""block""}},{""type"":""assembly"",""insert"":{""recipe"":""P02a"",""at"":""off_to_side_default"",""grounded"":false,""name"":""ring""}},{""type"":""assembly"",""constraint"":{""type"":""mate"",""a"":{""face"":{""contains"":[25,0,0],""normal"":""-Z""},""component"":""ring""},""b"":{""face"":{""contains"":[0,0,10],""normal"":""+Z""},""component"":""block""},""offset"":0}}],""scripted"":true,""why_not"":""""},{""id"":""A02b"",""ops"":[{""type"":""assembly"",""insert"":{""recipe"":""P01a"",""at"":[0,0,0],""grounded"":true,""name"":""block""}},{""type"":""assembly"",""insert"":{""recipe"":""P02a"",""at"":""off_to_side_default"",""grounded"":false,""name"":""ring""}},{""type"":""assembly"",""constraint"":{""type"":""mate"",""a"":{""face"":{""contains"":[25,0,0],""normal"":""-Z""},""component"":""ring""},""b"":{""face""",
":{""contains"":[0,0,10],""normal"":""+Z""},""component"":""block""},""offset"":5}}],""scripted"":true,""why_not"":""""},{""id"":""A03a"",""ops"":[{""type"":""assembly"",""insert"":{""recipe"":""P01a"",""at"":[0,0,0],""grounded"":true,""name"":""block""}},{""type"":""assembly"",""insert"":{""recipe"":""P02a"",""at"":""off_to_side_default"",""grounded"":false,""name"":""ring""}},{""type"":""assembly"",""constraint"":{""type"":""flush"",""a"":{""face"":{""contains"":[25,0,0],""normal"":""-Z""},""component"":""ring""},""b"":{""face"":{""contains"":[0,0,0],""normal"":""-Z""},""component"":""block""},""offset"":0}}],""scripted"":true,""why_not"":""""},{""id"":""A03b"",""ops"":[{""type"":""assembly"",""insert"":{""recipe"":""P01a"",""at"":[0,0,0],""grounded"":true,""name"":""block""}},{""type"":""assembly"",""insert"":{""recipe"":""P02a"",""at"":""off_to_side_default"",""grounded"":false,""name"":""ring""}},{""type"":""assembly"",""constraint"":{""type"":""flush"",""a"":{""face"":{""contains"":[25,0,0],""normal"":""-Z""},""component"":""ring""},""b"":{""face"":{""contains",
""":[0,0,0],""normal"":""-Z""},""component"":""block""},""offset"":5}}],""scripted"":true,""why_not"":""""},{""id"":""A04a"",""ops"":[{""type"":""assembly"",""insert"":{""recipe"":""P01a"",""at"":[0,0,0],""grounded"":true,""name"":""block""}},{""type"":""assembly"",""insert"":{""recipe"":""P02a"",""at"":""off_to_side_default"",""grounded"":false,""name"":""ring""}},{""type"":""assembly"",""constraint"":{""type"":""angle"",""a"":{""face"":{""contains"":[0,0,10],""normal"":""+Z""},""component"":""block""},""b"":{""face"":{""contains"":[25,0,40],""normal"":""+Z""},""component"":""ring""},""angle"":30}}],""scripted"":true,""why_not"":""""},{""id"":""A04b"",""ops"":[{""type"":""assembly"",""insert"":{""recipe"":""P01a"",""at"":[0,0,0],""grounded"":true,""name"":""block""}},{""type"":""assembly"",""insert"":{""recipe"":""P02a"",""at"":""off_to_side_default"",""grounded"":false,""name"":""ring""}},{""type"":""assembly"",""constraint"":{""type"":""angle"",""a"":{""face"":{""contains"":[0,0,10],""normal"":""+Z""},""component"":""block""},""b"":{""face"":{""contains"":[25,0,4",
"0],""normal"":""+Z""},""component"":""ring""},""angle"":45}}],""scripted"":true,""why_not"":""""},{""id"":""A05a"",""ops"":[{""type"":""assembly"",""insert"":{""recipe"":""P03a"",""at"":[0,0,0],""grounded"":true}},{""type"":""assembly"",""insert"":{""recipe"":""P16a"",""at"":""default""}},{""type"":""assembly"",""constraint"":{""type"":""insert"",""a"":{""edge"":{""through"":[2.5,0,0],""tangent"":[0,1,0]},""component"":""P16a""},""b"":{""edge"":{""through"":[2.5,0,10],""tangent"":[0,1,0]},""component"":""P03a""},""offset"":0}}],""scripted"":true,""why_not"":""""},{""id"":""A05b"",""ops"":[{""type"":""assembly"",""insert"":{""recipe"":""P03a"",""at"":[0,0,0],""grounded"":true}},{""type"":""assembly"",""insert"":{""recipe"":""P16a"",""at"":""default""}},{""type"":""assembly"",""constraint"":{""type"":""insert"",""a"":{""edge"":{""through"":[2.5,0,0],""tangent"":[0,1,0]},""component"":""P16a""},""b"":{""edge"":{""through"":[2.5,0,10],""tangent"":[0,1,0]},""component"":""P03a""},""offset"":2}}],""scripted"":true,""why_not"":""""},{""id"":""A06a"",""ops"":[{""type",
""":""assembly"",""insert"":{""recipe"":""P01a"",""at"":[0,0,0],""grounded"":true}},{""type"":""assembly"",""insert"":{""recipe"":""P16a"",""at"":""default""}},{""type"":""assembly"",""constraint"":{""type"":""tangent"",""a"":{""face"":{""contains"":[2.5,0,10],""normal"":""+X""},""component"":""P16a""},""b"":{""face"":{""contains"":[0,0,10],""normal"":""+Z""},""component"":""P01a""},""solution"":""outside""}}],""scripted"":true,""why_not"":""""},{""id"":""A06b"",""ops"":[{""type"":""assembly"",""insert"":{""recipe"":""P01a"",""at"":[0,0,0],""grounded"":true}},{""type"":""assembly"",""insert"":{""recipe"":""P16a"",""at"":""default""}},{""type"":""assembly"",""constraint"":{""type"":""tangent"",""a"":{""face"":{""contains"":[2.5,0,10],""normal"":""+X""},""component"":""P16a""},""b"":{""face"":{""contains"":[0,0,10],""normal"":""+Z""},""component"":""P01a""},""solution"":""inside""}}],""scripted"":true,""why_not"":""""},{""id"":""A07a"",""ops"":[{""type"":""assembly"",""insert"":{""recipe"":""P01a"",""at"":[0,0,0],""grounded"":true,""name"":""block""}},{""type"":""assembl",
"y"",""insert"":{""recipe"":""P02a"",""at"":""off_to_side_default"",""grounded"":false,""name"":""ring""}},{""type"":""assembly"",""pattern"":{""component"":""ring"",""dir1"":{""axis"":""X"",""count"":3,""spacing"":70},""dir2"":{""axis"":""Y"",""count"":1,""spacing"":70}}}],""scripted"":true,""why_not"":""""},{""id"":""A07b"",""ops"":[{""type"":""assembly"",""insert"":{""recipe"":""P01a"",""at"":[0,0,0],""grounded"":true,""name"":""block""}},{""type"":""assembly"",""insert"":{""recipe"":""P02a"",""at"":""off_to_side_default"",""grounded"":false,""name"":""ring""}},{""type"":""assembly"",""pattern"":{""component"":""ring"",""dir1"":{""axis"":""X"",""count"":4,""spacing"":70},""dir2"":{""axis"":""Y"",""count"":1,""spacing"":70}}}],""scripted"":true,""why_not"":""""},{""id"":""A08a"",""ops"":[{""type"":""assembly"",""insert"":{""recipe"":""P01a"",""at"":[0,0,0],""grounded"":true,""name"":""block""}},{""type"":""assembly"",""insert"":{""recipe"":""P02a"",""at"":""off_to_side_default"",""grounded"":false,""name"":""ring""}},{""type"":""app_specific"",""app"":""inventor"",""op",
""":""model_state"",""params"":{""name"":""second"",""suppress"":[""ring""],""active"":""master""}}],""scripted"":true,""why_not"":""""},{""id"":""A08b"",""ops"":[{""type"":""assembly"",""insert"":{""recipe"":""P01a"",""at"":[0,0,0],""grounded"":true,""name"":""block""}},{""type"":""assembly"",""insert"":{""recipe"":""P02a"",""at"":""off_to_side_default"",""grounded"":false,""name"":""ring""}},{""type"":""app_specific"",""app"":""inventor"",""op"":""model_state"",""params"":{""name"":""second"",""suppress"":[""ring""],""active"":""second""}}],""scripted"":true,""why_not"":""""},{""id"":""A09a"",""ops"":[{""type"":""assembly"",""insert"":{""recipe"":""P01a"",""at"":[0,0,0],""grounded"":true,""name"":""block""}},{""type"":""assembly"",""insert"":{""recipe"":""P02a"",""at"":""off_to_side_default"",""grounded"":false,""name"":""ring""}},{""type"":""app_specific"",""app"":""inventor"",""op"":""view_representation"",""params"":{""name"":""View1"",""hide"":[""ring""],""active"":""Default""}}],""scripted"":true,""why_not"":""""},{""id"":""A09b"",""ops"":[{""type"":""assembly"",",
"""insert"":{""recipe"":""P01a"",""at"":[0,0,0],""grounded"":true,""name"":""block""}},{""type"":""assembly"",""insert"":{""recipe"":""P02a"",""at"":""off_to_side_default"",""grounded"":false,""name"":""ring""}},{""type"":""app_specific"",""app"":""inventor"",""op"":""view_representation"",""params"":{""name"":""View1"",""hide"":[""ring""],""active"":""View1""}}],""scripted"":true,""why_not"":""""},{""id"":""A10a"",""ops"":[{""type"":""assembly"",""insert"":{""recipe"":""P01a"",""at"":[0,0,0],""grounded"":true,""name"":""block""}},{""type"":""assembly"",""insert"":{""recipe"":""P02a"",""at"":""off_to_side_default"",""grounded"":false,""name"":""ring""}},{""type"":""app_specific"",""app"":""inventor"",""op"":""appearance"",""params"":{""target"":{""component"":""block""},""color"":""blue""}}],""scripted"":true,""why_not"":""""},{""id"":""A10b"",""ops"":[{""type"":""assembly"",""insert"":{""recipe"":""P01a"",""at"":[0,0,0],""grounded"":true,""name"":""block""}},{""type"":""assembly"",""insert"":{""recipe"":""P02a"",""at"":""off_to_side_default"",""grounded"":false,""n",
"ame"":""ring""}},{""type"":""app_specific"",""app"":""inventor"",""op"":""appearance"",""params"":{""target"":{""component"":""block""},""color"":""green""}}],""scripted"":true,""why_not"":""""},{""id"":""A11a"",""ops"":[{""type"":""assembly"",""place"":{""part"":""P01a"",""name"":""block"",""at"":[0,0,0],""grounded"":true}},{""type"":""assembly"",""place"":{""part"":""P01a"",""name"":""block2"",""at"":[40,0,0],""grounded"":false,""turn"":[[""Z"",90]]}}],""scripted"":true,""why_not"":""""},{""id"":""A11b"",""ops"":[{""type"":""assembly"",""place"":{""part"":""P01a"",""name"":""block"",""at"":[0,0,0],""grounded"":true}},{""type"":""assembly"",""place"":{""part"":""P01a"",""name"":""block2"",""at"":[40,0,20],""grounded"":false,""turn"":[[""X"",180]]}}],""scripted"":true,""why_not"":""""},{""id"":""A11c"",""ops"":[{""type"":""assembly"",""place"":{""part"":""P01a"",""name"":""block"",""at"":[0,0,0],""grounded"":true}},{""type"":""assembly"",""place"":{""part"":""P01a"",""name"":""block2"",""at"":[40,0,0],""grounded"":false,""turn"":[[""Y"",90]]}}],""scripted"":true,""why_n",
"ot"":""""},{""id"":""A12a"",""ops"":[{""type"":""assembly"",""subassembly"":{""name"":""A12-sub"",""ops"":[{""type"":""assembly"",""place"":{""part"":""P01a"",""name"":""block"",""at"":[0,0,0],""grounded"":true}},{""type"":""assembly"",""place"":{""part"":""P16a"",""name"":""pin"",""at"":[0,0,10],""grounded"":true}}]}},{""type"":""assembly"",""place"":{""part"":""P02a"",""name"":""ring"",""at"":[0,0,0],""grounded"":true}},{""type"":""assembly"",""place"":{""name"":""sub"",""at"":[60,0,0],""grounded"":false,""sub"":""A12-sub""}}],""scripted"":true,""why_not"":""""},{""id"":""A12b"",""ops"":[{""type"":""assembly"",""subassembly"":{""name"":""A12-sub"",""ops"":[{""type"":""assembly"",""place"":{""part"":""P01a"",""name"":""block"",""at"":[0,0,0],""grounded"":true}},{""type"":""assembly"",""place"":{""part"":""P16a"",""name"":""pin"",""at"":[0,0,10],""grounded"":true}}]}},{""type"":""assembly"",""place"":{""part"":""P02a"",""name"":""ring"",""at"":[0,0,0],""grounded"":true}},{""type"":""assembly"",""place"":{""name"":""sub"",""at"":[60,0,0],""grounded"":false,""sub"":""A12-su",
"b""}},{""type"":""assembly"",""component"":""sub"",""grounded"":true}],""scripted"":true,""why_not"":""""},{""id"":""A12c"",""ops"":[{""type"":""assembly"",""subassembly"":{""name"":""A12-sub"",""ops"":[{""type"":""assembly"",""place"":{""part"":""P01a"",""name"":""block"",""at"":[0,0,0],""grounded"":true}},{""type"":""assembly"",""place"":{""part"":""P16a"",""name"":""pin"",""at"":[0,0,10],""grounded"":true}}]}},{""type"":""assembly"",""place"":{""part"":""P02a"",""name"":""ring"",""at"":[0,0,0],""grounded"":true}},{""type"":""assembly"",""place"":{""name"":""sub"",""at"":[60,0,0],""grounded"":false,""turn"":[[""Z"",90]],""sub"":""A12-sub""}}],""scripted"":true,""why_not"":""""},{""id"":""A13a"",""ops"":[{""type"":""assembly"",""subassembly"":{""name"":""A13-pair"",""ops"":[{""type"":""assembly"",""place"":{""part"":""P01a"",""name"":""block"",""at"":[0,0,0],""grounded"":true}},{""type"":""assembly"",""place"":{""part"":""P16a"",""name"":""pin"",""at"":[0,0,10],""grounded"":true}}]}},{""type"":""assembly"",""subassembly"":{""name"":""A13-mid"",""ops"":[{""type"":""asse",
"mbly"",""place"":{""part"":""P02a"",""name"":""ring"",""at"":[0,0,0],""grounded"":true}},{""type"":""assembly"",""place"":{""name"":""pair"",""at"":[0,0,0],""grounded"":true,""sub"":""A13-pair""}}]}},{""type"":""assembly"",""place"":{""name"":""mid"",""at"":[0,0,0],""grounded"":true,""sub"":""A13-mid""}}],""scripted"":true,""why_not"":""""},{""id"":""A13b"",""ops"":[{""type"":""assembly"",""subassembly"":{""name"":""A13-pair"",""ops"":[{""type"":""assembly"",""place"":{""part"":""P01a"",""name"":""block"",""at"":[0,0,0],""grounded"":true}},{""type"":""assembly"",""place"":{""part"":""P16a"",""name"":""pin"",""at"":[0,0,10],""grounded"":true}}]}},{""type"":""assembly"",""subassembly"":{""name"":""A13-mid"",""ops"":[{""type"":""assembly"",""place"":{""part"":""P02a"",""name"":""ring"",""at"":[0,0,0],""grounded"":true}},{""type"":""assembly"",""place"":{""name"":""pair"",""at"":[0,0,0],""grounded"":true,""sub"":""A13-pair""}}]}},{""type"":""assembly"",""place"":{""name"":""mid"",""at"":[0,0,0],""grounded"":true,""sub"":""A13-mid""}},{""type"":""assembly"",""place"":{""na",
"me"":""mid2"",""at"":[80,0,0],""grounded"":false,""turn"":[[""Z"",90]],""sub"":""A13-mid""}}],""scripted"":true,""why_not"":""""},{""id"":""A14a"",""ops"":[{""type"":""assembly"",""place"":{""part"":""P01a"",""name"":""block"",""at"":[0,0,0],""grounded"":true}},{""type"":""assembly"",""place"":{""part"":""P01a"",""name"":""block2"",""at"":[0,0,10],""grounded"":false}},{""type"":""assembly"",""motion"":{""kind"":""rigid"",""moving"":""block2"",""fixed"":""block"",""at"":[0,0,10],""axis"":""Z"",""limits"":{},""pose"":{}}}],""scripted"":true,""why_not"":""""},{""id"":""A14b"",""ops"":[{""type"":""assembly"",""place"":{""part"":""P01a"",""name"":""block"",""at"":[0,0,0],""grounded"":true}},{""type"":""assembly"",""place"":{""part"":""P01a"",""name"":""block2"",""at"":[5,0,10],""grounded"":false}},{""type"":""assembly"",""motion"":{""kind"":""rigid"",""moving"":""block2"",""fixed"":""block"",""at"":[0,0,10],""axis"":""Z"",""limits"":{},""pose"":{},""offset"":[5,0,0]}}],""scripted"":true,""why_not"":""""},{""id"":""A14c"",""ops"":[{""type"":""assembly"",""place"":{""part"":""P01a",
""",""name"":""block"",""at"":[0,0,0],""grounded"":true}},{""type"":""assembly"",""place"":{""part"":""P01a"",""name"":""block2"",""at"":[0,0,10],""grounded"":false,""turn"":[[""Z"",180]]}},{""type"":""assembly"",""motion"":{""kind"":""rigid"",""moving"":""block2"",""fixed"":""block"",""at"":[0,0,10],""axis"":""Z"",""limits"":{},""pose"":{}}}],""scripted"":true,""why_not"":""""},{""id"":""A15a"",""ops"":[{""type"":""assembly"",""place"":{""part"":""P02a"",""name"":""ring"",""at"":[0,0,0],""grounded"":true}},{""type"":""assembly"",""place"":{""part"":""P01a"",""name"":""block"",""at"":[0,0,0],""grounded"":false}},{""type"":""assembly"",""motion"":{""kind"":""revolute"",""moving"":""block"",""fixed"":""ring"",""at"":[0,0,0],""axis"":""Z"",""limits"":{""rotation_deg"":[-45,90]},""pose"":{""angle_deg"":0}}}],""scripted"":true,""why_not"":""""},{""id"":""A15b"",""ops"":[{""type"":""assembly"",""place"":{""part"":""P02a"",""name"":""ring"",""at"":[0,0,0],""grounded"":true}},{""type"":""assembly"",""place"":{""part"":""P01a"",""name"":""block"",""at"":[0,0,0],""grounded"":false}",
"},{""type"":""assembly"",""motion"":{""kind"":""revolute"",""moving"":""block"",""fixed"":""ring"",""at"":[0,0,0],""axis"":""Z"",""limits"":{""rotation_deg"":[-45,90]},""pose"":{""angle_deg"":30}}}],""scripted"":true,""why_not"":""""},{""id"":""A15c"",""ops"":[{""type"":""assembly"",""place"":{""part"":""P02a"",""name"":""ring"",""at"":[0,0,0],""grounded"":true}},{""type"":""assembly"",""place"":{""part"":""P01a"",""name"":""block"",""at"":[0,0,0],""grounded"":false}},{""type"":""assembly"",""motion"":{""kind"":""revolute"",""moving"":""block"",""fixed"":""ring"",""at"":[0,0,0],""axis"":""Z"",""limits"":{""rotation_deg"":[0,180]},""pose"":{""angle_deg"":90}}}],""scripted"":true,""why_not"":""""},{""id"":""A16a"",""ops"":[{""type"":""assembly"",""place"":{""part"":""P01a"",""name"":""block"",""at"":[0,0,0],""grounded"":true}},{""type"":""assembly"",""place"":{""part"":""P01a"",""name"":""block2"",""at"":[0,0,10],""grounded"":false}},{""type"":""assembly"",""motion"":{""kind"":""slider"",""moving"":""block2"",""fixed"":""block"",""at"":[10,0,10],""axis"":""X"",""limits"":",
"{""travel_mm"":[-20,20]},""pose"":{""travel_mm"":0}}}],""scripted"":true,""why_not"":""""},{""id"":""A16b"",""ops"":[{""type"":""assembly"",""place"":{""part"":""P01a"",""name"":""block"",""at"":[0,0,0],""grounded"":true}},{""type"":""assembly"",""place"":{""part"":""P01a"",""name"":""block2"",""at"":[0,0,10],""grounded"":false}},{""type"":""assembly"",""motion"":{""kind"":""slider"",""moving"":""block2"",""fixed"":""block"",""at"":[10,0,10],""axis"":""X"",""limits"":{""travel_mm"":[-20,20]},""pose"":{""travel_mm"":20}}}],""scripted"":true,""why_not"":""""},{""id"":""A16c"",""ops"":[{""type"":""assembly"",""place"":{""part"":""P01a"",""name"":""block"",""at"":[0,0,0],""grounded"":true}},{""type"":""assembly"",""place"":{""part"":""P01a"",""name"":""block2"",""at"":[0,0,10],""grounded"":false}},{""type"":""assembly"",""motion"":{""kind"":""slider"",""moving"":""block2"",""fixed"":""block"",""at"":[10,0,10],""axis"":""X"",""limits"":{""travel_mm"":[0,40]},""pose"":{""travel_mm"":40}}}],""scripted"":true,""why_not"":""""},{""id"":""A17a"",""ops"":[{""type"":""assembly",
""",""place"":{""part"":""P02a"",""name"":""ring"",""at"":[0,0,0],""grounded"":true}},{""type"":""assembly"",""place"":{""part"":""P01a"",""name"":""block"",""at"":[0,0,0],""grounded"":false}},{""type"":""assembly"",""motion"":{""kind"":""cylindrical"",""moving"":""block"",""fixed"":""ring"",""at"":[0,0,0],""axis"":""Z"",""limits"":{""travel_mm"":[0,40]},""pose"":{""travel_mm"":0,""angle_deg"":0}}}],""scripted"":true,""why_not"":""""},{""id"":""A17b"",""ops"":[{""type"":""assembly"",""place"":{""part"":""P02a"",""name"":""ring"",""at"":[0,0,0],""grounded"":true}},{""type"":""assembly"",""place"":{""part"":""P01a"",""name"":""block"",""at"":[0,0,0],""grounded"":false}},{""type"":""assembly"",""motion"":{""kind"":""cylindrical"",""moving"":""block"",""fixed"":""ring"",""at"":[0,0,0],""axis"":""Z"",""limits"":{""travel_mm"":[0,40]},""pose"":{""travel_mm"":35,""angle_deg"":45}}}],""scripted"":true,""why_not"":""""},{""id"":""A18a"",""ops"":[{""type"":""assembly"",""place"":{""part"":""P01a"",""name"":""block"",""at"":[0,0,0],""grounded"":true}},{""type"":""assembly"",""pla",
"ce"":{""part"":""P01a"",""name"":""block2"",""at"":[0,0,10],""grounded"":false}},{""type"":""assembly"",""motion"":{""kind"":""planar"",""moving"":""block2"",""fixed"":""block"",""at"":[0,0,10],""axis"":""Z"",""limits"":{""u_mm"":[-20,20],""v_mm"":[-20,20],""rotation_deg"":[-90,90]},""pose"":{""u_mm"":0,""v_mm"":0,""angle_deg"":0}}}],""scripted"":true,""why_not"":""""},{""id"":""A18b"",""ops"":[{""type"":""assembly"",""place"":{""part"":""P01a"",""name"":""block"",""at"":[0,0,0],""grounded"":true}},{""type"":""assembly"",""place"":{""part"":""P01a"",""name"":""block2"",""at"":[0,0,10],""grounded"":false}},{""type"":""assembly"",""motion"":{""kind"":""planar"",""moving"":""block2"",""fixed"":""block"",""at"":[0,0,10],""axis"":""Z"",""limits"":{""u_mm"":[-20,20],""v_mm"":[-20,20],""rotation_deg"":[-90,90]},""pose"":{""u_mm"":15,""v_mm"":5,""angle_deg"":30}}}],""scripted"":true,""why_not"":""""},{""id"":""A18c"",""ops"":[{""type"":""assembly"",""place"":{""part"":""P01a"",""name"":""block"",""at"":[0,0,0],""grounded"":true}},{""type"":""assembly"",""place"":{""part",
""":""P01a"",""name"":""block2"",""at"":[0,0,10],""grounded"":false}},{""type"":""assembly"",""motion"":{""kind"":""planar"",""moving"":""block2"",""fixed"":""block"",""at"":[0,0,10],""axis"":""Z"",""limits"":{""u_mm"":[-20,20],""v_mm"":[-20,20],""rotation_deg"":[-90,90]},""pose"":{""u_mm"":20,""v_mm"":-20,""angle_deg"":90}}}],""scripted"":true,""why_not"":""""},{""id"":""A19a"",""ops"":[{""type"":""assembly"",""place"":{""part"":""P01a"",""name"":""block"",""at"":[0,0,-10],""grounded"":true}},{""type"":""assembly"",""place"":{""part"":""P16a"",""name"":""pin"",""at"":[0,0,0],""grounded"":false}},{""type"":""assembly"",""motion"":{""kind"":""ball"",""moving"":""pin"",""fixed"":""block"",""at"":[0,0,0],""axis"":""Z"",""limits"":{},""pose"":{}}}],""scripted"":true,""why_not"":""""},{""id"":""A19b"",""ops"":[{""type"":""assembly"",""place"":{""part"":""P01a"",""name"":""block"",""at"":[0,0,-10],""grounded"":true}},{""type"":""assembly"",""place"":{""part"":""P16a"",""name"":""pin"",""at"":[0,0,0],""grounded"":false}},{""type"":""assembly"",""motion"":{""kind"":""ball"",""mo",
"ving"":""pin"",""fixed"":""block"",""at"":[0,0,0],""axis"":""Z"",""limits"":{},""pose"":{""tilt_deg"":30,""tilt_axis"":""X""}}}],""scripted"":true,""why_not"":""""},{""id"":""A19c"",""ops"":[{""type"":""assembly"",""place"":{""part"":""P01a"",""name"":""block"",""at"":[0,0,-10],""grounded"":true}},{""type"":""assembly"",""place"":{""part"":""P16a"",""name"":""pin"",""at"":[0,0,0],""grounded"":false}},{""type"":""assembly"",""motion"":{""kind"":""ball"",""moving"":""pin"",""fixed"":""block"",""at"":[0,0,0],""axis"":""Z"",""limits"":{""cone_half_angle_deg"":45},""pose"":{""tilt_deg"":45,""tilt_axis"":""Y""}}}],""scripted"":true,""why_not"":""""},{""id"":""A20a"",""ops"":[{""type"":""assembly"",""place"":{""part"":""P04a"",""name"":""fillet"",""at"":[0,0,0],""grounded"":true}},{""type"":""assembly"",""mirror"":{""component"":""fillet"",""name"":""fillet_m"",""plane"":{""base"":""YZ"",""offset"":20},""at"":[40,0,0],""part_name"":""A20a-mirror""}}],""scripted"":true,""why_not"":""""},{""id"":""A20b"",""ops"":[{""type"":""assembly"",""place"":{""part"":""P04a"",""name"":""fillet""",
",""at"":[0,0,0],""grounded"":true}},{""type"":""assembly"",""mirror"":{""component"":""fillet"",""name"":""fillet_m"",""plane"":{""base"":""XZ"",""offset"":40},""at"":[0,80,0],""part_name"":""A20b-mirror""}}],""scripted"":true,""why_not"":""""},{""id"":""A20c"",""ops"":[{""type"":""assembly"",""place"":{""part"":""P04a"",""name"":""fillet"",""at"":[0,0,0],""grounded"":true}},{""type"":""assembly"",""mirror"":{""component"":""fillet"",""name"":""fillet_m"",""plane"":{""base"":""YZ"",""offset"":20},""at"":[40,0,0],""part_name"":""P04a-mirrored""}}],""scripted"":true,""why_not"":""""},{""id"":""A21a"",""ops"":[{""type"":""assembly"",""subassembly"":{""name"":""A21-pair"",""ops"":[{""type"":""assembly"",""place"":{""part"":""P01a"",""name"":""block"",""at"":[0,0,0],""grounded"":true}},{""type"":""assembly"",""place"":{""part"":""P16a"",""name"":""pin"",""at"":[0,0,10],""grounded"":true}}]}},{""type"":""assembly"",""place"":{""name"":""pair"",""at"":[0,0,0],""grounded"":true,""sub"":""A21-pair""}},{""type"":""assembly"",""pattern"":{""component"":""pair"",""dir1"":{""ax",
"is"":""X"",""count"":3,""spacing"":40},""dir2"":{""axis"":""Y"",""count"":1,""spacing"":40}}}],""scripted"":true,""why_not"":""""},{""id"":""A21b"",""ops"":[{""type"":""assembly"",""subassembly"":{""name"":""A21-pair"",""ops"":[{""type"":""assembly"",""place"":{""part"":""P01a"",""name"":""block"",""at"":[0,0,0],""grounded"":true}},{""type"":""assembly"",""place"":{""part"":""P16a"",""name"":""pin"",""at"":[0,0,10],""grounded"":true}}]}},{""type"":""assembly"",""place"":{""name"":""pair"",""at"":[0,0,0],""grounded"":true,""sub"":""A21-pair""}},{""type"":""assembly"",""pattern"":{""component"":""pair"",""dir1"":{""axis"":""X"",""count"":2,""spacing"":25},""dir2"":{""axis"":""Y"",""count"":1,""spacing"":25}}}],""scripted"":true,""why_not"":""""},{""id"":""A21c"",""ops"":[{""type"":""assembly"",""subassembly"":{""name"":""A21-pair"",""ops"":[{""type"":""assembly"",""place"":{""part"":""P01a"",""name"":""block"",""at"":[0,0,0],""grounded"":true}},{""type"":""assembly"",""place"":{""part"":""P16a"",""name"":""pin"",""at"":[0,0,10],""grounded"":true}}]}},{""type"":""assembly"",""",
"place"":{""name"":""pair"",""at"":[0,0,0],""grounded"":true,""sub"":""A21-pair""}},{""type"":""assembly"",""pattern"":{""component"":""pair"",""dir1"":{""axis"":""Y"",""count"":3,""spacing"":40},""dir2"":{""axis"":""X"",""count"":1,""spacing"":40}}}],""scripted"":true,""why_not"":""""},{""id"":""A22a"",""ops"":[{""type"":""assembly"",""subassembly"":{""name"":""A21-pair"",""ops"":[{""type"":""assembly"",""place"":{""part"":""P01a"",""name"":""block"",""at"":[0,0,0],""grounded"":true}},{""type"":""assembly"",""place"":{""part"":""P16a"",""name"":""pin"",""at"":[0,0,10],""grounded"":true}}]}},{""type"":""assembly"",""place"":{""name"":""pair"",""at"":[40,0,0],""grounded"":true,""sub"":""A21-pair""}},{""type"":""assembly"",""pattern"":{""component"":""pair"",""circular"":{""axis"":""Z"",""count"":3,""total_deg"":360,""orient"":""rotate""}}}],""scripted"":true,""why_not"":""""},{""id"":""A22b"",""ops"":[{""type"":""assembly"",""subassembly"":{""name"":""A21-pair"",""ops"":[{""type"":""assembly"",""place"":{""part"":""P01a"",""name"":""block"",""at"":[0,0,0],""grounded"":true",
"}},{""type"":""assembly"",""place"":{""part"":""P16a"",""name"":""pin"",""at"":[0,0,10],""grounded"":true}}]}},{""type"":""assembly"",""place"":{""name"":""pair"",""at"":[40,0,0],""grounded"":true,""sub"":""A21-pair""}},{""type"":""assembly"",""pattern"":{""component"":""pair"",""circular"":{""axis"":""Z"",""count"":2,""total_deg"":360,""orient"":""rotate""}}}],""scripted"":true,""why_not"":""""},{""id"":""A23a"",""ops"":[{""type"":""assembly"",""place"":{""part"":""P01a"",""name"":""block"",""at"":[0,0,0],""grounded"":true,""linked"":true}},{""type"":""assembly"",""place"":{""part"":""P16a"",""name"":""pin"",""at"":[40,0,0],""grounded"":false,""linked"":true}}],""scripted"":true,""why_not"":""""},{""id"":""A23b"",""ops"":[{""type"":""assembly"",""place"":{""part"":""P01a"",""name"":""block"",""at"":[0,0,0],""grounded"":true,""linked"":true}},{""type"":""assembly"",""place"":{""part"":""P16a"",""name"":""pin"",""at"":[40,0,0],""grounded"":false,""linked"":true}}],""scripted"":false,""why_not"":""Inventor keeps every placed part as a link to its own file",
": there is no embedded copy to break the link to""},{""id"":""A23c"",""ops"":[{""type"":""assembly"",""place"":{""part"":""P01a"",""name"":""block"",""at"":[0,0,0],""grounded"":true,""linked"":true,""copy_as"":""A23c-P01a""}},{""type"":""assembly"",""place"":{""part"":""P16a"",""name"":""pin"",""at"":[40,0,0],""grounded"":false,""linked"":true}},{""type"":""assembly"",""edit_source"":{""component"":""block"",""height"":12}}],""scripted"":true,""why_not"":""""},{""id"":""A24a"",""ops"":[{""type"":""assembly"",""subassembly"":{""name"":""A24-pair"",""ops"":[{""type"":""assembly"",""place"":{""part"":""P01a"",""name"":""block"",""at"":[0,0,0],""grounded"":true}},{""type"":""assembly"",""place"":{""part"":""P16a"",""name"":""pin"",""at"":[0,0,10],""grounded"":false}},{""type"":""assembly"",""name"":""pinmate"",""constraint"":{""type"":""mate"",""a"":{""face"":{""contains"":[0,0,10],""normal"":""-Z""},""component"":""pin""},""b"":{""face"":{""contains"":[0,0,10],""normal"":""+Z""},""component"":""block""},""offset"":0}}]}},{""type"":""assembly"",""place"":{""name",
""":""pair1"",""at"":[0,0,0],""grounded"":true,""sub"":""A24-pair""}},{""type"":""assembly"",""place"":{""name"":""pair2"",""at"":[50,0,0],""grounded"":true,""sub"":""A24-pair""}},{""type"":""assembly"",""flexible"":{""component"":""pair2"",""on"":true}},{""type"":""assembly"",""move_child"":{""component"":""pair2"",""child"":""pin"",""by"":[6,0,0]}}],""scripted"":true,""why_not"":""""},{""id"":""A24b"",""ops"":[{""type"":""assembly"",""subassembly"":{""name"":""A24-pair"",""ops"":[{""type"":""assembly"",""place"":{""part"":""P01a"",""name"":""block"",""at"":[0,0,0],""grounded"":true}},{""type"":""assembly"",""place"":{""part"":""P16a"",""name"":""pin"",""at"":[0,0,10],""grounded"":false}},{""type"":""assembly"",""name"":""pinmate"",""constraint"":{""type"":""mate"",""a"":{""face"":{""contains"":[0,0,10],""normal"":""-Z""},""component"":""pin""},""b"":{""face"":{""contains"":[0,0,10],""normal"":""+Z""},""component"":""block""},""offset"":0}}]}},{""type"":""assembly"",""place"":{""name"":""pair1"",""at"":[0,0,0],""grounded"":true,""sub"":""A24-pair""}},{""type"":""ass",
"embly"",""place"":{""name"":""pair2"",""at"":[50,0,0],""grounded"":true,""sub"":""A24-pair""}},{""type"":""assembly"",""flexible"":{""component"":""pair2"",""on"":true}},{""type"":""assembly"",""move_child"":{""component"":""pair2"",""child"":""pin"",""by"":[6,0,0]}},{""type"":""assembly"",""flexible"":{""component"":""pair1"",""on"":true}},{""type"":""assembly"",""move_child"":{""component"":""pair1"",""child"":""pin"",""by"":[-6,0,0]}}],""scripted"":true,""why_not"":""""},{""id"":""A25a"",""ops"":[{""type"":""assembly"",""place"":{""part"":""P01a"",""name"":""block"",""at"":[0,0,0],""grounded"":true}},{""type"":""assembly"",""place"":{""part"":""P16a"",""name"":""pin"",""at"":[0,0,10],""grounded"":false}},{""type"":""assembly"",""place"":{""part"":""P02a"",""name"":""ring"",""at"":[60,0,0],""grounded"":true}},{""type"":""assembly"",""name"":""pinmate"",""constraint"":{""type"":""mate"",""a"":{""face"":{""contains"":[0,0,10],""normal"":""-Z""},""component"":""pin""},""b"":{""face"":{""contains"":[0,0,10],""normal"":""+Z""},""component"":""block""},""offset"":0}}],",
"""scripted"":true,""why_not"":""""},{""id"":""A25b"",""ops"":[{""type"":""assembly"",""place"":{""part"":""P01a"",""name"":""block"",""at"":[0,0,0],""grounded"":true}},{""type"":""assembly"",""place"":{""part"":""P16a"",""name"":""pin"",""at"":[0,0,10],""grounded"":false}},{""type"":""assembly"",""place"":{""part"":""P02a"",""name"":""ring"",""at"":[60,0,0],""grounded"":true}},{""type"":""assembly"",""name"":""pinmate"",""constraint"":{""type"":""mate"",""a"":{""face"":{""contains"":[0,0,10],""normal"":""-Z""},""component"":""pin""},""b"":{""face"":{""contains"":[0,0,10],""normal"":""+Z""},""component"":""block""},""offset"":0}},{""type"":""assembly"",""component"":""pin"",""suppressed"":true}],""scripted"":true,""why_not"":""""},{""id"":""A25c"",""ops"":[{""type"":""assembly"",""place"":{""part"":""P01a"",""name"":""block"",""at"":[0,0,0],""grounded"":true}},{""type"":""assembly"",""place"":{""part"":""P16a"",""name"":""pin"",""at"":[0,0,10],""grounded"":false}},{""type"":""assembly"",""place"":{""part"":""P02a"",""name"":""ring"",""at"":[60,0,0],""grounded"":true}},{""",
"type"":""assembly"",""name"":""pinmate"",""constraint"":{""type"":""mate"",""a"":{""face"":{""contains"":[0,0,10],""normal"":""-Z""},""component"":""pin""},""b"":{""face"":{""contains"":[0,0,10],""normal"":""+Z""},""component"":""block""},""offset"":0}},{""type"":""assembly"",""component"":""ring"",""suppressed"":true}],""scripted"":true,""why_not"":""""},{""id"":""A25d"",""ops"":[{""type"":""assembly"",""place"":{""part"":""P01a"",""name"":""block"",""at"":[0,0,0],""grounded"":true}},{""type"":""assembly"",""place"":{""part"":""P16a"",""name"":""pin"",""at"":[0,0,10],""grounded"":false}},{""type"":""assembly"",""place"":{""part"":""P02a"",""name"":""ring"",""at"":[60,0,0],""grounded"":true}},{""type"":""assembly"",""name"":""pinmate"",""constraint"":{""type"":""mate"",""a"":{""face"":{""contains"":[0,0,10],""normal"":""-Z""},""component"":""pin""},""b"":{""face"":{""contains"":[0,0,10],""normal"":""+Z""},""component"":""block""},""offset"":0}},{""type"":""assembly"",""suppress_constraint"":""pinmate""}],""scripted"":true,""why_not"":""""},{""id"":""A26a"",""ops"":[{",
"""type"":""assembly"",""ipart"":{""name"":""A26a-block"",""from"":""P01a"",""parameter"":""Height"",""members"":[{""name"":""Default"",""value"":10},{""name"":""Tall"",""value"":12}]}},{""type"":""assembly"",""place"":{""ipart"":""A26a-block"",""member"":""Tall"",""name"":""block"",""at"":[0,0,0],""grounded"":true}},{""type"":""assembly"",""place"":{""part"":""P16a"",""name"":""pin"",""at"":[0,0,12],""grounded"":false}},{""type"":""assembly"",""name"":""pinmate"",""constraint"":{""type"":""mate"",""a"":{""face"":{""contains"":[0,0,12],""normal"":""-Z""},""component"":""pin""},""b"":{""face"":{""contains"":[0,0,12],""normal"":""+Z""},""component"":""block""},""offset"":0}}],""scripted"":true,""why_not"":""""},{""id"":""A26b"",""ops"":[{""type"":""assembly"",""ipart"":{""name"":""A26b-block"",""from"":""P01a"",""parameter"":""Height"",""members"":[{""name"":""Default"",""value"":10},{""name"":""Tall"",""value"":12}]}},{""type"":""assembly"",""place"":{""ipart"":""A26b-block"",""member"":""Default"",""name"":""block"",""at"":[0,0,0],""grounded"":true}},{""type"":""assembl",
"y"",""place"":{""part"":""P16a"",""name"":""pin"",""at"":[0,0,10],""grounded"":false}},{""type"":""assembly"",""name"":""pinmate"",""constraint"":{""type"":""mate"",""a"":{""face"":{""contains"":[0,0,10],""normal"":""-Z""},""component"":""pin""},""b"":{""face"":{""contains"":[0,0,10],""normal"":""+Z""},""component"":""block""},""offset"":0}}],""scripted"":true,""why_not"":""""},{""id"":""D04a"",""ops"":[{""type"":""sketch"",""plane"":""XZ"",""entities"":[{""type"":""line"",""a"":[0,0,0],""b"":[40,0,0]},{""type"":""line"",""a"":[40,0,0],""b"":[40,0,5]},{""type"":""line"",""a"":[40,0,5],""b"":[5,0,5]},{""type"":""line"",""a"":[5,0,5],""b"":[5,0,30]},{""type"":""line"",""a"":[5,0,30],""b"":[0,0,30]},{""type"":""line"",""a"":[0,0,30],""b"":[0,0,0]}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":30,""direction"":""+"",""op"":""new"",""extent"":""distance"",""axis"":""Y""},{""type"":""hole"",""at"":[25,15,5],""on_face"":{""face"":{""contains"":[25,15,5],""normal"":""+Z""}},""hole_type"":""simple"",""dia"":6,""through_all"":true}],""scripted"":true,",
"""why_not"":""""},{""id"":""D05a"",""ops"":[{""type"":""drawing"",""model"":""D04a"",""template"":""default_metric"",""title_block"":""default"",""views"":[{""type"":""base"",""orientation"":""show_L"",""scale"":""1:1""},{""type"":""projected"",""direction"":""vertical""},{""type"":""projected"",""direction"":""beside""}],""dims"":true,""dimensions"":[{""type"":""linear"",""value"":40,""between"":[[0,0,0],[40,0,0]]},{""type"":""linear"",""value"":30,""between"":[[0,0,0],[0,0,30]]},{""type"":""linear"",""value"":5,""between"":[[40,0,0],[40,0,5]]},{""type"":""linear"",""value"":25,""between"":[[0,15,5],[25,15,5]]}],""export"":{""format"":""DXF"",""version"":[2018,2000],""scale"":""1:1"",""text"":""not_exploded""}}],""scripted"":true,""why_not"":""""},{""id"":""D06a"",""ops"":[{""type"":""sketch"",""plane"":""XY"",""entities"":[{""type"":""line"",""a"":[0,0,0],""b"":[60,0,0]},{""type"":""line"",""a"":[60,0,0],""b"":[60,20,0]},{""type"":""line"",""a"":[60,20,0],""b"":[40,40,0]},{""type"":""line"",""a"":[40,40,0],""b"":[0,40,0]},{""type"":""line"",""a"":[0,",
"40,0],""b"":[0,0,0]}],""dims"":true},{""type"":""extrude"",""profile"":""last"",""distance"":10,""direction"":""+"",""op"":""new"",""extent"":""distance""},{""type"":""hole"",""at"":[20,20,10],""on_face"":{""face"":{""contains"":[20,20,10],""normal"":""+Z""}},""hole_type"":""simple"",""dia"":10,""through_all"":true}],""scripted"":true,""why_not"":""""},{""id"":""D07a"",""ops"":[{""type"":""drawing"",""model"":""D06a"",""title_block"":""default"",""sheets"":[{""size"":""A4"",""orientation"":""portrait"",""views"":[{""type"":""base"",""scale"":""1:1"",""labels"":true},{""type"":""projected"",""direction"":""vertical"",""scale"":""1:2"",""labels"":true},{""type"":""projected"",""direction"":""beside"",""scale"":""2:1"",""labels"":true}],""dimensions"":[{""type"":""linear"",""value"":60},{""type"":""aligned"",""value"":28.28},{""type"":""radius"",""value"":5},{""type"":""angle"",""edges"":[[[60,20],[40,40]],[[40,40],[0,40]]]}]},{""size"":""Letter"",""orientation"":""landscape"",""views"":[{""type"":""base"",""scale"":""1:1"",""labels"":true},{""type"":""project",
"ed"",""direction"":""vertical"",""scale"":""1:2"",""labels"":true},{""type"":""projected"",""direction"":""beside"",""scale"":""2:1"",""labels"":true}]}],""dims"":true,""export"":{""format"":""DXF"",""all_sheets"":true,""version"":[2018,2000],""scale"":""1:1"",""text"":""not_exploded""}}],""scripted"":true,""why_not"":""""},{""id"":""D11a"",""ops"":[{""type"":""drawing"",""model"":""D04a"",""standard"":""ISO"",""units"":""mm"",""sheet"":""A4"",""orientation"":""landscape"",""title_block"":{""title"":""D04a drawing"",""designer"":""Fixture Builder""},""views"":[{""type"":""base"",""orientation"":""Front"",""scale"":""1:1""},{""type"":""projected"",""orientation"":""Right""},{""type"":""projected"",""orientation"":""Top""},{""type"":""iso"",""scale"":""1:2""},{""type"":""section"",""label"":""A-A"",""line"":{""x"":25,""direction"":""vertical""}}],""dims"":true,""dimensions"":[{""type"":""linear"",""value"":40,""expect"":40,""between"":[[0,0,0],[40,0,0]]},{""type"":""linear"",""value"":30,""expect"":30,""between"":[[0,0,0],[0,0,30]]},{""type"":""linear"",""valu",
"e"":5,""expect"":5,""between"":[[40,0,0],[40,0,5]]},{""type"":""linear"",""value"":25,""expect"":25,""between"":[[0,15,5],[25,15,5]]}],""export"":{""format"":""DXF"",""pdf"":true,""version"":[2018,2000],""scale"":""1:1"",""text"":""not_exploded""}}],""scripted"":true,""why_not"":""""},{""id"":""D12a"",""ops"":[{""type"":""drawing"",""model"":""D06a"",""standard"":""ISO"",""units"":""mm"",""sheet"":""A4"",""orientation"":""landscape"",""title_block"":{""title"":""D06a drawing"",""designer"":""Fixture Builder""},""views"":[{""type"":""base"",""orientation"":""Front"",""scale"":""1:1""},{""type"":""projected"",""orientation"":""Right""},{""type"":""projected"",""orientation"":""Top""},{""type"":""iso"",""scale"":""1:2""},{""type"":""section"",""label"":""A-A"",""line"":{""x"":20,""direction"":""vertical""}}],""dims"":true,""dimensions"":[{""type"":""linear"",""value"":60,""expect"":60,""between"":[[0,0,0],[60,0,0]]},{""type"":""linear"",""value"":40,""expect"":40,""between"":[[0,0,10],[0,40,10]]},{""type"":""linear"",""value"":10,""expect"":10,""between",
""":[[60,0,0],[60,0,10]]},{""type"":""linear"",""value"":20,""expect"":20,""between"":[[0,20,10],[20,20,10]]},{""type"":""linear"",""value"":20,""expect"":20,""between"":[[60,0,10],[60,20,10]]}],""export"":{""format"":""DXF"",""pdf"":true,""version"":[2018,2000],""scale"":""1:1"",""text"":""not_exploded""}}],""scripted"":true,""why_not"":""""},{""id"":""D13a"",""ops"":[{""type"":""drawing"",""model"":""P03a"",""standard"":""ISO"",""units"":""mm"",""sheet"":""A4"",""orientation"":""landscape"",""title_block"":{""title"":""P03a drawing"",""designer"":""Fixture Builder""},""views"":[{""type"":""base"",""orientation"":""Front"",""scale"":""1:1""},{""type"":""projected"",""orientation"":""Right""},{""type"":""projected"",""orientation"":""Top""},{""type"":""iso"",""scale"":""1:2""},{""type"":""section"",""label"":""A-A"",""line"":{""x"":0,""direction"":""vertical""}}],""dims"":true,""dimensions"":[{""type"":""linear"",""value"":20,""expect"":20,""between"":[[-10,-15,10],[10,-15,10]]},{""type"":""linear"",""value"":30,""expect"":30,""between"":[[-10,-15,",
"10],[-10,15,10]]},{""type"":""linear"",""value"":10,""expect"":10,""between"":[[10,-15,0],[10,-15,10]]},{""type"":""linear"",""value"":10,""expect"":10,""between"":[[-10,0,10],[0,0,10]]},{""type"":""linear"",""value"":15,""expect"":15,""between"":[[0,-15,10],[0,0,10]]}],""export"":{""format"":""DXF"",""pdf"":true,""version"":[2018,2000],""scale"":""1:1"",""text"":""not_exploded""}}],""scripted"":true,""why_not"":""""},{""id"":""D14a"",""ops"":[{""type"":""drawing"",""model"":""P03b"",""standard"":""ISO"",""units"":""mm"",""sheet"":""A4"",""orientation"":""landscape"",""title_block"":{""title"":""P03b drawing"",""designer"":""Fixture Builder""},""views"":[{""type"":""base"",""orientation"":""Front"",""scale"":""1:1""},{""type"":""projected"",""orientation"":""Right""},{""type"":""projected"",""orientation"":""Top""},{""type"":""iso"",""scale"":""1:2""},{""type"":""section"",""label"":""A-A"",""line"":{""x"":0,""direction"":""vertical""}}],""dims"":true,""dimensions"":[{""type"":""linear"",""value"":20,""expect"":20,""between"":[[-10,-15,10],[10,-1",
"5,10]]},{""type"":""linear"",""value"":30,""expect"":30,""between"":[[-10,-15,10],[-10,15,10]]},{""type"":""linear"",""value"":10,""expect"":10,""between"":[[10,-15,0],[10,-15,10]]},{""type"":""linear"",""value"":10,""expect"":10,""between"":[[-10,0,10],[0,0,10]]},{""type"":""linear"",""value"":15,""expect"":15,""between"":[[0,-15,10],[0,0,10]]}],""export"":{""format"":""DXF"",""pdf"":true,""version"":[2018,2000],""scale"":""1:1"",""text"":""not_exploded""}}],""scripted"":true,""why_not"":""""},{""id"":""D15a"",""ops"":[{""type"":""drawing"",""model"":""P07a"",""standard"":""ISO"",""units"":""mm"",""sheet"":""A4"",""orientation"":""landscape"",""title_block"":{""title"":""P07a drawing"",""designer"":""Fixture Builder""},""views"":[{""type"":""base"",""orientation"":""Front"",""scale"":""1:1""},{""type"":""projected"",""orientation"":""Right""},{""type"":""projected"",""orientation"":""Top""},{""type"":""iso"",""scale"":""1:2""},{""type"":""section"",""label"":""A-A"",""line"":{""x"":5,""direction"":""vertical""}}],""dims"":true,""dimensions"":[{""",
"type"":""linear"",""value"":60,""expect"":60,""between"":[[0,0,5],[60,0,5]]},{""type"":""linear"",""value"":40,""expect"":40,""between"":[[0,0,5],[0,40,5]]},{""type"":""linear"",""value"":5,""expect"":5,""between"":[[60,0,0],[60,0,5]]},{""type"":""linear"",""value"":5,""expect"":5,""between"":[[0,5,5],[5,5,5]]},{""type"":""linear"",""value"":10,""expect"":10,""between"":[[5,5,5],[15,5,5]]},{""type"":""linear"",""value"":10,""expect"":10,""between"":[[5,5,5],[5,15,5]]}],""export"":{""format"":""DXF"",""pdf"":true,""version"":[2018,2000],""scale"":""1:1"",""text"":""not_exploded""}}],""scripted"":true,""why_not"":""""},{""id"":""D16a"",""ops"":[{""type"":""drawing"",""model"":""P08a"",""standard"":""ISO"",""units"":""mm"",""sheet"":""A4"",""orientation"":""landscape"",""title_block"":{""title"":""P08a drawing"",""designer"":""Fixture Builder""},""views"":[{""type"":""base"",""orientation"":""Front"",""scale"":""1:1""},{""type"":""projected"",""orientation"":""Right""},{""type"":""projected"",""orientation"":""Top""},{""type"":""iso"",""scale"":""",
"1:2""},{""type"":""section"",""label"":""A-A"",""line"":{""x"":20,""direction"":""vertical""}}],""dims"":true,""dimensions"":[{""type"":""linear"",""value"":60,""expect"":60,""between"":[[-30,0,5],[30,0,5]]},{""type"":""linear"",""value"":5,""expect"":5,""between"":[[30,0,0],[30,0,5]]},{""type"":""linear"",""value"":20,""expect"":20,""between"":[[0,0,5],[20,0,5]]},{""type"":""linear"",""value"":40,""expect"":40,""between"":[[-20,0,5],[20,0,5]]}],""export"":{""format"":""DXF"",""pdf"":true,""version"":[2018,2000],""scale"":""1:1"",""text"":""not_exploded""}}],""scripted"":true,""why_not"":""""},{""id"":""D17a"",""ops"":[{""type"":""drawing"",""model"":""P06a"",""standard"":""ISO"",""units"":""mm"",""sheet"":""A4"",""orientation"":""landscape"",""title_block"":{""title"":""P06a drawing"",""designer"":""Fixture Builder""},""views"":[{""type"":""base"",""orientation"":""Front"",""scale"":""1:1""},{""type"":""projected"",""orientation"":""Right""},{""type"":""projected"",""orientation"":""Top""},{""type"":""iso"",""scale"":""1:2""},{""type"":""section"",""l",
"abel"":""A-A"",""line"":{""x"":0,""direction"":""vertical""}}],""dims"":true,""dimensions"":[{""type"":""linear"",""value"":20,""expect"":20,""between"":[[-10,-15,10],[10,-15,10]]},{""type"":""linear"",""value"":30,""expect"":30,""between"":[[-10,-15,10],[-10,15,10]]},{""type"":""linear"",""value"":10,""expect"":10,""between"":[[10,-15,0],[10,-15,10]]},{""type"":""linear"",""value"":1.5,""expect"":1.5,""between"":[[-10,0,10],[-8.5,0,10]]},{""type"":""linear"",""value"":1.5,""expect"":1.5,""between"":[[0,-15,10],[0,-13.5,10]]}],""export"":{""format"":""DXF"",""pdf"":true,""version"":[2018,2000],""scale"":""1:1"",""text"":""not_exploded""}}],""scripted"":true,""why_not"":""""},{""id"":""D18a"",""ops"":[{""type"":""drawing"",""model"":""P06b"",""standard"":""ISO"",""units"":""mm"",""sheet"":""A4"",""orientation"":""landscape"",""title_block"":{""title"":""P06b drawing"",""designer"":""Fixture Builder""},""views"":[{""type"":""base"",""orientation"":""Front"",""scale"":""1:1""},{""type"":""projected"",""orientation"":""Right""},{""type"":""pr",
"ojected"",""orientation"":""Top""},{""type"":""iso"",""scale"":""1:2""},{""type"":""section"",""label"":""A-A"",""line"":{""x"":0,""direction"":""vertical""}}],""dims"":true,""dimensions"":[{""type"":""linear"",""value"":20,""expect"":20,""between"":[[-10,-15,10],[10,-15,10]]},{""type"":""linear"",""value"":30,""expect"":30,""between"":[[-10,-15,10],[-10,15,10]]},{""type"":""linear"",""value"":10,""expect"":10,""between"":[[10,-15,0],[10,-15,10]]},{""type"":""linear"",""value"":2,""expect"":2,""between"":[[-10,0,10],[-8,0,10]]},{""type"":""linear"",""value"":2,""expect"":2,""between"":[[0,-15,10],[0,-13,10]]}],""export"":{""format"":""DXF"",""pdf"":true,""version"":[2018,2000],""scale"":""1:1"",""text"":""not_exploded""}}],""scripted"":true,""why_not"":""""}]"}))
    Dim version As String = CStr(app.SoftwareVersion.DisplayVersion)
    Dim build As String = CStr(app.SoftwareVersion.BuildIdentifier)
    Dim folderName As String = "Inventor-" & Token(version) & "-" & Token(build)
    ' Optional subset and shared folder (environment: FIXTURE_RECIPES, FIXTURE_SHARED_FOLDER): see RecipeFilter.
    Dim only As List(Of String) = RecipeFilter()
    designs = SelectDesigns(designs, only)
    Dim sharedFolder As Boolean = (CStr(Environment.GetEnvironmentVariable("FIXTURE_SHARED_FOLDER")).Trim() = "1")
    Dim root As String
    If sharedFolder Then
        Directory.CreateDirectory(output)
        root = output
    Else
        root = NewOutputFolder(output, ScriptName & "-Inventor-" & BuilderVersion)
    End If
    outputRootNow = root
    Dim logPath As String = Path.Combine(root, "run.log")
    If Not (sharedFolder AndAlso File.Exists(logPath)) Then
        File.WriteAllText(logPath, root & vbCrLf, New System.Text.UTF8Encoding(False))
    End If
    outputRoot = root
    Dim prior As List(Of Object) = If(sharedFolder, LoadPriorResults(root, serializer), New List(Of Object)())
    Dim built As New Dictionary(Of String, Boolean)()
    For Each old As Object In prior
        If IsBuilt(root, old) Then
            built(CStr(old("id"))) = True
        End If
    Next
    If only IsNot Nothing OrElse sharedFolder Then
        File.AppendAllText(logPath, Stamp() & " run mode: " & CStr(CType(designs, System.Collections.ICollection).Count) & " recipes selected" & If(sharedFolder, ", shared folder", "") & vbCrLf)
    End If
    Dim results As New List(Of Object)()
    Dim archiveFiles As New List(Of String)()
    For Each design As Object In designs
        If built.ContainsKey(CStr(design("id"))) Then
            results.Add(New Dictionary(Of String, Object) From {{"id", design("id")}, {"status", "skipped_built"}, {"error", ""}, {"built_in", Path.GetFileName(root)}, {"files", New String() {}}, {"app", "Inventor"}, {"version", version}, {"build", build}, {"seconds", 0}, {"output_folder", Path.GetFileName(root)}})
            File.AppendAllText(logPath, Stamp() & " " & CStr(design("id")) & " skipped_built: built in " & Path.GetFileName(root) & vbCrLf)
            Continue For
        End If
        Dim watch As System.Diagnostics.Stopwatch = System.Diagnostics.Stopwatch.StartNew()
        recipeWatch = watch
        File.AppendAllText(logPath, Stamp() & " START " & CStr(design("id")) & vbCrLf)
        Dim row As New Dictionary(Of String, Object) From {{"id", design("id")}, {"status", "failed"}, {"error", ""}, {"files", New String() {}}, {"app", "Inventor"}, {"version", version}, {"build", build}, {"output_folder", Path.GetFileName(root)}}
        Dim doc As Object = Nothing
        Try
            If major < 20 Then
                Throw New NotSupportedException("needs Inventor 2016+")
            End If
            If Not Regex.IsMatch(CStr(design("id")), "^[A-Za-z0-9_-]+$") Then
                Throw New Exception("Invalid recipe identifier")
            End If
            If Not CBool(G(design, "scripted", True)) Then
                Throw New NotSupportedException(CStr(G(design, "why_not", "Recipe marked not scripted")))
            End If
            surfaceNames = New List(Of String)()
            For Each operation As Object In design("ops")
                Preflight(operation)
            Next
            Dim docType As Integer = 12290
            For Each operation As Object In design("ops")
                If CStr(operation("type")) = "assembly" Then
                    docType = 12291
                End If
            Next
            doc = app.Documents.Add(docType, MetricTemplate(docType), True)
            If docType = 12291 Then
                ActivateMasterLod(doc, major)
            End If
            For Each operation As Object In design("ops")
                If CStr(operation("type")) = "sheetmetal" Then
                    doc.SubType = "{9C464203-9BAE-11D3-8BAD-0060B0CE6BB4}"
                    Exit For
                End If
            Next
            tg = app.TransientGeometry
            cd = doc.ComponentDefinition
            refs = New Dictionary(Of String, Object)()
            smThickness = 0
            last = Nothing
            lastProfile = Nothing
            sk = Nothing
            opIndex = 0
            openPathSketches = New List(Of Integer)()
            If design.ContainsKey("open_path_sketches") Then
                For Each pathIndex As Object In design("open_path_sketches")
                    openPathSketches.Add(CInt(pathIndex))
                Next
            End If
            planes = New Dictionary(Of String, Object)()
            joints = New List(Of Object)()
            projected = New List(Of Object)()
            For Each operation As Object In design("ops")
                Try
                    BuildOp(operation)
                Catch ex As NotSupportedException
                    Throw
                Catch ex As Exception
                    ' run.log names the failing step; the error text stays exactly the application's.
                    Dim stepName As String = CStr(operation("type"))
                    If operation.ContainsKey("op") Then stepName &= "." & CStr(operation("op"))
                    If operation.ContainsKey("action") Then stepName &= "." & CStr(operation("action"))
                    File.AppendAllText(logPath, Stamp() & " " & CStr(design("id")) & " failing step " & CStr(opIndex + 1) & " " & stepName & vbCrLf)
                    Throw
                End Try
            Next
            If Not doc.Update2(False) Then
                Throw New Exception("Inventor document update failed")
            End If
            BlankProperties(doc)
            If docType = 12291 Then
                ActivateMasterLod(doc, major)
            End If
            Dim native As String = CStr(design("id")) & If(docType = 12291, ".iam", ".ipt")
            Dim stepFile As String = CStr(design("id")) & ".step"
            doc.SaveAs(Path.Combine(root, native), False)
            ExportStep(doc, Path.Combine(root, stepFile))
            row("files") = New String() {native, stepFile}
            archiveFiles.Add(native)
            archiveFiles.Add(stepFile)
            row("status") = "ok"
        Catch ex As NotSupportedException
            row("status") = "not_scripted"
            row("error") = SafeError(ex.Message, root)
        Catch ex As Exception
            row("error") = SafeError(ex.Message, root)
        Finally
            If doc IsNot Nothing Then
                Try
                    doc.Close(True)
                Catch ex As Exception
                    If CStr(row("status")) = "ok" Then
                        row("status") = "failed"
                        row("error") = SafeError(ex.Message, root)
                    End If
                End Try
            End If
        End Try
        PrivacyCheckRow(root, row, archiveFiles)
        row("seconds") = watch.Elapsed.TotalSeconds
        results.Add(row)
        File.AppendAllText(logPath, Stamp() & " " & CStr(row("id")) & " " & CStr(row("status")) & If(CStr(row("error")) <> "", ": " & CStr(row("error")), "") & vbCrLf)
        If sharedFolder Then
            ' a batch that dies half way still leaves every finished recipe in results.json
            File.WriteAllText(Path.Combine(root, "results.json"), serializer.Serialize(MergeResults(prior, results)), New System.Text.UTF8Encoding(False))
        End If
    Next
    Dim finalRows As List(Of Object) = If(sharedFolder, MergeResults(prior, results), results)
    If sharedFolder Then
        archiveFiles.Clear()
        For Each finalRow As Object In finalRows
            If CStr(finalRow("status")) = "ok" Then
                For Each fileName As Object In CType(finalRow("files"), System.Collections.IEnumerable)
                    archiveFiles.Add(CStr(fileName))
                Next
            End If
        Next
    End If
    File.WriteAllText(Path.Combine(root, "results.json"), serializer.Serialize(finalRows), New System.Text.UTF8Encoding(False))
    archiveFiles.Add("results.json")
    Dim stuckFiles As Integer = SweepOutput(root, archiveFiles, finalRows)
    ' the sweep may have failed rows: results.json says so (and is looked at once more)
    File.WriteAllText(Path.Combine(root, "results.json"), ScrubText(serializer.Serialize(finalRows)), New System.Text.UTF8Encoding(False))
    stuckFiles += SweepOutput(root, archiveFiles, finalRows)
    outputSwept = True
    If stuckFiles > 0 Then
        MsgBox("Some files of this run carry your user profile and could not be removed: delete this folder, do not send it: " & ScrubText(root))
    End If
    Dim zipPath As String = Path.Combine(root, folderName & ".zip")
    Using zipStream As New FileStream(zipPath, If(sharedFolder, FileMode.Create, FileMode.CreateNew))
        Using archive As New ZipArchive(zipStream, ZipArchiveMode.Create)
            For Each fileName As String In archiveFiles
                ZipFileExtensions.CreateEntryFromFile(archive, Path.Combine(root, fileName), folderName & "/" & fileName, CompressionLevel.Optimal)
            Next
        End Using
    End Using
    File.AppendAllText(logPath, "Fixture Builder output folder: " & root & vbCrLf)
    Dim okCount As Integer = 0, failCount As Integer = 0, skipCount As Integer = 0
    For Each finalRow As Object In finalRows
        Select Case CStr(finalRow("status"))
            Case "ok" : okCount += 1
            Case "failed" : failCount += 1
            Case "not_scripted" : skipCount += 1
        End Select
    Next
    Dim finishText As String = FinishMessage(finalRows.Count, okCount, failCount, skipCount, zipPath)
    File.AppendAllText(logPath, finishText.Replace(vbLf, vbCrLf) & vbCrLf)
    ' Unattended (FIXTURE_UNATTENDED=1 or a shared-folder batch): no Explorer window and no message box, only the log line above.
    Dim unattended As Boolean = sharedFolder OrElse (CStr(Environment.GetEnvironmentVariable("FIXTURE_UNATTENDED")).Trim() = "1")
    If Not unattended Then
        ' A person is at the screen: show the zip in Explorer, then the message.
        Try
            System.Diagnostics.Process.Start("explorer.exe", "/select,""" & zipPath & """")
        Catch revealEx As Exception
        End Try
        MsgBox(finishText, MsgBoxStyle.Information, "Inventor fixtures")
    End If
End Sub

' --- Privacy: nothing of this machine's user profile goes into the zip (same rules as the Python builder) ---
' Default output C:\Users\Public\FixtureOut; a folder in the profile or OneDrive is refused; every file a recipe keeps is scanned (raw bytes,
' ASCII and UTF-16, and zlib/gzip streams inside it): a hit fails the row and deletes its files. Counts only, the match is never shown.
Const PublicOutput As String = "C:\Users\Public\FixtureOut"
Private outputRootNow As String = ""      ' the folder of the run in progress: Main sweeps it whatever ended the run
Private outputSwept As Boolean = False   ' the run's own final sweep happened
Function ProfilePaths() As List(Of String)
    ' the profile, a network home, every OneDrive root, a redirected Documents folder
    Dim found As New List(Of String)()
    Dim values As New List(Of String)()
    For Each key As String In New String() {"USERPROFILE", "HOMESHARE", "OneDrive", "OneDriveConsumer", "OneDriveCommercial"}
        values.Add(If(Environment.GetEnvironmentVariable(key), ""))
    Next
    Try
        values.Add(Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments))
    Catch ex As Exception
    End Try
    For Each raw As String In values
        Dim value As String = raw.Trim().TrimEnd("\"c, "/"c)
        If value.Length > 3 AndAlso Not found.Contains(value) Then
            found.Add(value)
        End If
    Next
    Return found
End Function
Function GuardedName(raw As String) As String
    ' a name that is also an ordinary path part or word cannot be told from it: only the profile path is looked for then
    Dim value As String = If(raw, "").Trim().Trim("\"c, "/"c)
    If value.Length >= 3 AndAlso Not New String() {"public", "default", "system", "administrator", "admin", "user", "users", "guest", "test", "temp", "tmp", "owner", "home", "data", "work", "docs", "documents", "desktop", "downloads", "windows", "program", "files", "appdata", "local", "roaming", "autodesk", "inventor", "templates", "metric", "english", "fixture", "fixtures", "output", "results", "build", "builder"}.Contains(value.ToLowerInvariant()) Then
        Return value
    End If
    Return ""
End Function
Function UserNames() As List(Of String)
    ' looked for as a path part: the user name, the profile folder's leaf (often not the user name: jsmith.ACME), the domain
    Dim found As New List(Of String)()
    Dim profile As String = If(Environment.GetEnvironmentVariable("USERPROFILE"), "").Trim().TrimEnd("\"c, "/"c).Replace("/", "\")
    Dim leaf As String = If(profile.Contains("\"), profile.Substring(profile.LastIndexOf("\"c) + 1), "")
    For Each candidate As String In New String() {If(Environment.GetEnvironmentVariable("USERNAME"), ""), leaf, If(Environment.GetEnvironmentVariable("USERDOMAIN"), "")}
        Dim value As String = GuardedName(candidate)
        If value <> "" AndAlso Not found.Exists(Function(x) String.Equals(x, value, StringComparison.OrdinalIgnoreCase)) Then
            found.Add(value)
        End If
    Next
    Return found
End Function
Function ComputerWords() As List(Of String)
    ' looked for as a whole word: the computer name and the logon server
    Dim found As New List(Of String)()
    For Each candidate As String In New String() {If(Environment.GetEnvironmentVariable("COMPUTERNAME"), ""), If(Environment.GetEnvironmentVariable("LOGONSERVER"), "").TrimStart("\"c, "/"c)}
        Dim value As String = GuardedName(candidate)
        If value.Length >= 4 AndAlso Not found.Exists(Function(x) String.Equals(x, value, StringComparison.OrdinalIgnoreCase)) Then
            found.Add(value)
        End If
    Next
    Return found
End Function
Sub RefuseOutput(output As String)
    Dim text As String = output.Replace("/", "\").ToLowerInvariant()
    Dim bad As Boolean = text.Contains("onedrive")
    For Each profile As String In ProfilePaths()
        Dim lowered As String = profile.Replace("/", "\").ToLowerInvariant()
        If text = lowered OrElse text.StartsWith(lowered & "\") Then
            bad = True
        End If
    Next
    For Each name As String In UserNames().Concat(ComputerWords())
        If (text & "\").Contains("\" & name.ToLowerInvariant() & "\") Then
            bad = True
        End If
    Next
    ' any other C:\Users\<name> (not Public, Default, All Users, Shared) is somebody's profile too
    If Regex.IsMatch(text & "\", "(?:[a-z]:)?[\\/]+users[\\/]+(?!(?:public|default|all users|shared)(?![a-z0-9_~$.-]))[^\\/\s""'<>|*?:]") Then
        bad = True
    End If
    If bad Then
        Throw New InvalidOperationException("The output folder is in your user profile or OneDrive, so the files would carry your name inside them. Use " & PublicOutput & " (or another folder outside your profile and OneDrive).")
    End If
End Sub
Function PrivacyHitsInText(text As String, patterns As List(Of Regex)) As Integer
    Dim count As Integer = 0
    For Each pattern As Regex In patterns
        count += pattern.Matches(text).Count
    Next
    Return count
End Function
Function PrivacyHitsInBytes(data As Byte(), patterns As List(Of Regex)) As Integer
    Dim latin As System.Text.Encoding = System.Text.Encoding.GetEncoding(28591)
    Dim best As Integer = PrivacyHitsInText(latin.GetString(data), patterns)
    best = Math.Max(best, PrivacyHitsInText(System.Text.Encoding.Unicode.GetString(data), patterns))
    best = Math.Max(best, PrivacyHitsInText(System.Text.Encoding.UTF8.GetString(data), patterns))   ' a Cyrillic or accented name in UTF-8
    If data.Length > 1 Then
        Dim shifted(data.Length - 2) As Byte
        Array.Copy(data, 1, shifted, 0, shifted.Length)
        best = Math.Max(best, PrivacyHitsInText(System.Text.Encoding.Unicode.GetString(shifted), patterns))
    End If
    Return best
End Function
Function PrivacyPatterns() As List(Of Regex)
    Dim patterns As New List(Of Regex)()
    Dim ci As RegexOptions = RegexOptions.IgnoreCase
    patterns.Add(New Regex("(?:[A-Za-z]:)?[\\/]+Users[\\/]+(?!(?:public|default|all users|shared)(?![A-Za-z0-9_~$.-]))[^\\/\s""'<>|*?:\x00]", ci))
    patterns.Add(New Regex("OneDrive", ci))
    For Each profile As String In ProfilePaths()
        For Each form As String In New String() {profile, profile.Replace("\", "/"), profile.Replace("/", "\")}
            patterns.Add(New Regex(Regex.Escape(form), ci))
        Next
    Next
    For Each name As String In UserNames()
        patterns.Add(New Regex("[\\/]" & Regex.Escape(name) & "[\\/]", ci))
    Next
    For Each word As String In ComputerWords()   ' a computer name or logon server: a whole word, wherever it stands
        patterns.Add(New Regex("(?<![A-Za-z0-9])" & Regex.Escape(word) & "(?![A-Za-z0-9])", ci))
    Next
    Return patterns
End Function
Function PrivacyHits(path As String) As Integer
    Dim patterns As List(Of Regex) = PrivacyPatterns()
    Dim data As Byte() = File.ReadAllBytes(path)
    Dim total As Integer = PrivacyHitsInBytes(data, patterns)
    For position As Integer = 0 To data.Length - 3
        Dim isZlib As Boolean = data(position) = &H78 AndAlso (data(position + 1) = &H1 OrElse data(position + 1) = &H5E OrElse data(position + 1) = &H9C OrElse data(position + 1) = &HDA)
        Dim isGzip As Boolean = data(position) = &H1F AndAlso data(position + 1) = &H8B
        If isZlib OrElse isGzip Then
            Try
                Using source As New MemoryStream(data, position + If(isZlib, 2, 0), data.Length - position - If(isZlib, 2, 0))
                    Using inflater As Stream = If(isZlib, CType(New DeflateStream(source, CompressionMode.Decompress), Stream), CType(New GZipStream(source, CompressionMode.Decompress), Stream))
                        Using inflated As New MemoryStream()
                            Dim buffer(8191) As Byte
                            Dim got As Integer = inflater.Read(buffer, 0, buffer.Length)
                            While got > 0 AndAlso inflated.Length < 8388608
                                inflated.Write(buffer, 0, got)
                                got = inflater.Read(buffer, 0, buffer.Length)
                            End While
                            If inflated.Length >= 16 Then
                                total += PrivacyHitsInBytes(inflated.ToArray(), patterns)
                            End If
                        End Using
                    End Using
                End Using
            Catch ex As Exception
            End Try
        End If
    Next
    Return total
End Function
Function RemoveFile(path As String) As Boolean
    ' fail closed: the file does not stay with its content. Delete (three tries), and if it cannot be deleted, truncate it.
    For attempt As Integer = 1 To 3
        Try
            If File.Exists(path) Then
                File.Delete(path)
            End If
            Return True
        Catch ex As Exception
            System.Threading.Thread.Sleep(200 * attempt)
        End Try
    Next
    Try
        Using truncated As New FileStream(path, FileMode.Create)
        End Using
    Catch ex As Exception
    End Try
    Return Not File.Exists(path) OrElse New FileInfo(path).Length = 0
End Function
Function FileLeaks(path As String) As Integer
    Try
        Return PrivacyHits(path)
    Catch ex As Exception
        Return 1   ' a file that cannot be read or scanned counts as a hit
    End Try
End Function
Sub PrivacyCheckRow(root As String, row As Object, archiveFiles As List(Of String))
    If CStr(row("status")) <> "ok" Then
        Return
    End If
    Dim bad As String = ""
    Dim hits As Integer = 0
    For Each name As String In CType(row("files"), String())
        Dim target As String = Path.Combine(root, name)
        If Not File.Exists(target) Then
            Continue For
        End If
        Dim found As Integer = FileLeaks(target)
        If found > 0 AndAlso bad = "" Then
            bad = name
            hits = found
        End If
    Next
    If bad <> "" Then
        For Each kept As String In CType(row("files"), String())
            RemoveFile(Path.Combine(root, kept))
            archiveFiles.Remove(kept)
        Next
        row("status") = "failed"
        row("files") = New String() {}
        row("error") = bad & " carries the profile path or user name of this machine (" & hits & " hits): its files were removed, not shipped"
    End If
End Sub
Function SweepOutput(root As String, archiveFiles As List(Of String), rows As List(Of Object)) As Integer
    Dim stuck As Integer = 0
    ' last look before the zip: EVERY file under the output folder (the zip excepted), text files scrubbed first, then byte-scanned
    For Each target As String In Directory.GetFiles(root, "*", SearchOption.AllDirectories)
        If target.EndsWith(".zip", StringComparison.OrdinalIgnoreCase) Then
            Continue For
        End If
        If New String() {".json", ".log", ".txt", ".csv", ".md", ".ini"}.Contains(Path.GetExtension(target).ToLowerInvariant()) Then
            Try
                RedactProfile(target)
            Catch ex As Exception
            End Try
        End If
        If FileLeaks(target) > 0 Then
            If Not RemoveFile(target) Then
                stuck += 1
            End If
            Dim relative As String = target.Substring(root.Length).TrimStart("\"c, "/"c)
            archiveFiles.Remove(relative)
            For Each row As Object In rows   ' a row that listed the file is not ok any more, and ships none of its files
                If CStr(row("status")) = "ok" Then
                    Dim listed As Boolean = False
                    For Each name As Object In CType(row("files"), System.Collections.IEnumerable)
                        If String.Equals(CStr(name), relative, StringComparison.OrdinalIgnoreCase) Then
                            listed = True
                        End If
                    Next
                    If listed Then
                        For Each name As Object In CType(row("files"), System.Collections.IEnumerable)
                            If Not RemoveFile(Path.Combine(root, CStr(name))) Then
                                stuck += 1
                            End If
                            archiveFiles.Remove(CStr(name))
                        Next
                        row("status") = "failed"
                        row("files") = New String() {}
                        row("error") = relative & " carries the profile path or user name of this machine: its files were removed, not shipped"
                    End If
                End If
            Next
        End If
    Next
    Return stuck
End Function
Const PathChars As String = "[^\\/\r\n""'<>|*?:\x00]"
' the whole path tail after a folder: inner parts may hold spaces and brackets (Dropbox (Acme Corp)), the last part stops at a space
Const PathTail As String = "(?:[\\/][^\\/\r\n""'<>|*?:\x00]*(?=[\\/]))*(?:[\\/][^\\/\s""'<>|*?:\x00]*)?"
Function ShortenTail(tail As String, marker As String) As String
    Dim kept As String = tail.TrimEnd("."c, ","c, ";"c, "!"c, ")"c, "]"c, "}"c)
    Return marker & If(kept.Length > 0, "\<path>", "") & tail.Substring(kept.Length)
End Function
Function ScrubText(text As String) As String
    ' \\server\share becomes %UNC%; the profile (network home, OneDrive roots, redirected Documents) with the WHOLE path after it becomes
    ' %USERPROFILE%\<path>; any other C:\Users\<name> too (a name with a space, an 8.3 name, a path that ends a sentence); the user name, profile
    ' leaf and domain as a path part become %USERNAME%; the computer name %COMPUTERNAME%
    Dim ci As RegexOptions = RegexOptions.IgnoreCase
    text = Regex.Replace(text, "\\\\[^\\/\s""'<>|*?:\x00]+[\\/][^\\/\s""'<>|*?:\x00]+", "%UNC%")
    Dim profiles As List(Of String) = ProfilePaths()
    profiles.Sort(Function(a, b) b.Length.CompareTo(a.Length))
    For Each profile As String In profiles
        For Each form As String In New String() {profile, profile.Replace("\", "/"), profile.Replace("\", "\\")}
            text = Regex.Replace(text, Regex.Escape(form) & "(?<tail>" & PathTail & ")", Function(m As Match) ShortenTail(m.Groups("tail").Value, "%USERPROFILE%"), ci)
        Next
    Next
    text = Regex.Replace(text, "(?:[A-Za-z]:)?[\\/]+Users[\\/]+(?!(?:public|default|all users|shared)(?![A-Za-z0-9_~$.-]))(?<name>" & PathChars & "+(?=[\\/])|[^\\/\s""'<>|*?:\x00]+)(?<tail>" & PathTail & ")", Function(m As Match) If(m.Groups("tail").Value <> "", ShortenTail(m.Groups("tail").Value, "%USERPROFILE%"), "%USERPROFILE%" & m.Groups("name").Value.Substring(m.Groups("name").Value.TrimEnd("."c, ","c, ";"c, "!"c, ")"c, "]"c, "}"c).Length)), ci)
    For Each name As String In UserNames()
        text = Regex.Replace(text, "(?<lead>[\\/])" & Regex.Escape(name) & "(?<tail>(?=[\\/])" & PathTail & ")", Function(m As Match) m.Groups("lead").Value & ShortenTail(m.Groups("tail").Value, "%USERNAME%"), ci)
    Next
    For Each word As String In ComputerWords()
        text = Regex.Replace(text, "(?<![A-Za-z0-9])" & Regex.Escape(word) & "(?![A-Za-z0-9])", "%COMPUTERNAME%", ci)
    Next
    Return text
End Function
Sub RedactProfile(path As String)
    File.WriteAllText(path, ScrubText(File.ReadAllText(path)), New System.Text.UTF8Encoding(False))
End Sub
Function FinishMessage(total As Integer, built As Integer, failed As Integer, notScripted As Integer, zipPath As String) As String
    Return CStr(total) & " recipe" & If(total = 1, "", "s") & ": " & CStr(built) & " built, " & CStr(failed) & " failed, " & CStr(notScripted) & " not scripted (details in run.log)." & vbLf & "Next: send this zip to Dutchy in a Discord direct message:" & vbLf & zipPath
End Function

Function RecipeFilter() As List(Of String)
    ' FIXTURE_RECIPES: recipe ids separated by spaces, commas or lines ('#' starts a comment), or the path of a text file
    ' holding them. Nothing set: every recipe runs.
    Dim value As String = Environment.GetEnvironmentVariable("FIXTURE_RECIPES")
    If value Is Nothing OrElse value.Trim() = "" Then
        Return Nothing
    End If
    value = value.Trim()
    Try
        If File.Exists(value) Then
            value = File.ReadAllText(value)
        End If
    Catch ex As Exception
    End Try
    Dim ids As New List(Of String)()
    For Each line As String In value.Split(New Char() {ChrW(10), ChrW(13)}, StringSplitOptions.RemoveEmptyEntries)
        Dim body As String = line
        If body.IndexOf("#"c) >= 0 Then
            body = body.Substring(0, body.IndexOf("#"c))
        End If
        For Each token As String In body.Split(New Char() {" "c, ","c, ChrW(9)}, StringSplitOptions.RemoveEmptyEntries)
            If Not ids.Contains(token) Then
                ids.Add(token)
            End If
        Next
    Next
    Return ids
End Function

Function SelectDesigns(designs As Object, only As List(Of String)) As Object
    ' Only the listed recipes, in the builder's own order; an unknown id stops the run before anything is built.
    If only Is Nothing Then
        Return designs
    End If
    Dim picked As New List(Of Object)()
    Dim known As New List(Of String)()
    For Each design As Object In designs
        known.Add(CStr(design("id")))
        If only.Contains(CStr(design("id"))) Then
            picked.Add(design)
        End If
    Next
    Dim unknown As New List(Of String)()
    For Each name As String In only
        If Not known.Contains(name) Then
            unknown.Add(name)
        End If
    Next
    If unknown.Count > 0 Then
        Throw New Exception("Unknown recipe identifier(s): " & String.Join(", ", unknown.ToArray()))
    End If
    Return picked.ToArray()
End Function

Function LoadPriorResults(root As String, serializer As JavaScriptSerializer) As List(Of Object)
    Dim rows As New List(Of Object)()
    Dim resultsPath As String = System.IO.Path.Combine(root, "results.json")
    Try
        If File.Exists(resultsPath) Then
            For Each row As Object In CType(serializer.DeserializeObject(File.ReadAllText(resultsPath)), System.Collections.IEnumerable)
                If TypeOf row Is Dictionary(Of String, Object) AndAlso CType(row, Dictionary(Of String, Object)).ContainsKey("id") Then
                    rows.Add(row)
                End If
            Next
        End If
    Catch ex As Exception
        rows.Clear()
    End Try
    Return rows
End Function

Function IsBuilt(root As String, row As Object) As Boolean
    ' Built: status ok and every file it names is in the folder.
    Dim found As Integer = 0
    If CStr(row("status")) <> "ok" Then
        Return False
    End If
    For Each fileName As Object In CType(row("files"), System.Collections.IEnumerable)
        If Not File.Exists(System.IO.Path.Combine(root, CStr(fileName))) Then
            Return False
        End If
        found += 1
    Next
    Return found > 0
End Function

Function MergeResults(prior As List(Of Object), rows As List(Of Object)) As List(Of Object)
    ' Earlier rows stay; a recipe run again replaces its row; skipped_built never replaces the ok row it points at.
    Dim merged As New List(Of Object)(prior)
    For Each row As Object In rows
        Dim at As Integer = -1
        For i As Integer = 0 To merged.Count - 1
            If CStr(merged(i)("id")) = CStr(row("id")) Then
                at = i
            End If
        Next
        If CStr(row("status")) = "skipped_built" Then
            If at < 0 Then
                merged.Add(row)
            End If
        ElseIf at < 0 Then
            merged.Add(row)
        Else
            merged(at) = row
        End If
    Next
    Return merged
End Function

Function NewOutputFolder(parent As String, baseName As String) As String
    ' Never reuse an existing folder: take the first of base, base-2, base-3, ... that does not exist.
    Directory.CreateDirectory(parent)
    Dim number As Integer = 1
    Do
        Dim candidate As String = Path.Combine(parent, If(number = 1, baseName, baseName & "-" & CStr(number)))
        If Not Directory.Exists(candidate) AndAlso Not File.Exists(candidate) Then
            Directory.CreateDirectory(candidate)
            Return candidate
        End If
        number += 1
    Loop
End Function

Function G(o As Object, key As String, fallback As Object) As Object
    If o.ContainsKey(key) Then
        Return o(key)
    End If
    Return fallback
End Function

Function Token(value As String) As String
    Return Regex.Replace(value, "[^A-Za-z0-9_.-]", "-")
End Function

Function SafeError(value As String, root As String) As String
    Dim text As String = Regex.Replace(value.Replace(root, "<output>"), "[A-Za-z]:[\\/][^\r\n""']+", "<path>")
    Return Regex.Replace(text, "\\\\[^\\\s""']+\\[^\r\n""']*", "<path>")   ' a UNC path
End Function

Sub Preflight(o As Object)
    If CStr(o("type")) = "drawing" Then
        Throw New NotSupportedException("drawing: the Python builder (build_inventor.py) builds drawings; the iLogic rule does not script them")
    End If
    Dim supported As String = "|sketch|extrude|revolve|hole|fillet|fillet_variable|chamfer|pattern_rect|pattern_circ|shell|loft|sweep|thread|assembly|sheetmetal|app_specific|"
    If Not supported.Contains("|" & CStr(o("type")) & "|") Then
        Throw New NotSupportedException(CStr(o("type")) & ": native adapter not implemented")
    End If
    If CStr(o("type")) = "app_specific" Then
        If CStr(o("app")) <> "inventor" OrElse Not "|work_plane|parameter|mirror|coil|sketch3d|split|interpolation_spline_sketch|view_representation|appearance|model_state|".Contains("|" & CStr(o("op")) & "|") Then
            Throw New NotSupportedException("app_specific " & CStr(o("op")) & ": native adapter not implemented")
        End If
    End If
    If CStr(o("type")) = "app_specific" AndAlso CStr(o("op")) = "model_state" AndAlso CInt(app.SoftwareVersion.Major) < 26 Then
        Throw New NotSupportedException("needs Inventor 2022+; app_specific model_state: model states do not exist before 2022")
    End If
    If CStr(o("type")) = "app_specific" AndAlso CStr(o("op")) = "coil" Then
        Dim p As Object = o("params")
        If Not "|pitch_revolution|revolution_height|pitch_height|spiral|".Contains("|" & CStr(p("size_type")) & "|") Then
            Throw New NotSupportedException("coil size type " & CStr(p("size_type")))
        End If
        If CDbl(G(p, "taper", 0)) <> 0 OrElse CStr(G(p, "ends", "default")) <> "default" Then
            Throw New NotSupportedException("coil taper/ends overrides: not scripted")
        End If
    End If
    If CStr(o("type")) = "app_specific" AndAlso CStr(o("op")) = "sketch3d" Then
        For Each entity As Object In o("params")("entities")
            If CStr(entity("type")) <> "line" Then
                Throw New NotSupportedException("3D sketch entity " & CStr(entity("type")) & ": only 3D lines are scripted")
            End If
        Next
    End If
    If CStr(o("type")) = "app_specific" AndAlso CStr(o("op")) = "split" Then
        Dim p As Object = o("params")
        If Not (TypeOf p("tool") Is Dictionary(Of String, Object) OrElse (TypeOf p("tool") Is String AndAlso surfaceNames.Contains(CStr(p("tool"))))) OrElse Not "|solid|trim|face|".Contains("|" & CStr(p("method")) & "|") Then
            Throw New NotSupportedException("split requires a work-plane tool or a surface made by an earlier extrude, and solid, trim or face mode")
        End If
    End If
    If CStr(o("type")) = "fillet_variable" Then
        If G(o, "intermediate_points", New Object() {}).Length > 0 OrElse CStr(G(o, "transition", "default")) <> "default" Then
            Throw New NotSupportedException("variable fillet intermediate points/transition: native adapter not implemented")
        End If
    End If
    If CStr(o("type")) = "sheetmetal" Then
        Dim action As String = CStr(G(o, "action", "unknown"))
        Dim parameters As Object = G(o, "app", New Dictionary(Of String, Object)())
        If Not "|base_flange|face|flange|flat_pattern|corner_round|contour_flange|bend|unfold|refold|cut|hem|".Contains("|" & action & "|") Then
            Throw New NotSupportedException("sheetmetal " & action & ": native adapter not implemented")
        End If
        If action = "cut" AndAlso CStr(G(parameters, "extent", "")) <> "through_all" Then
            Throw New NotSupportedException("sheetmetal cut: only through_all is scripted")
        End If
        If (action = "unfold" OrElse action = "refold") AndAlso CStr(G(parameters, "bend", "")) <> "flange_bend" Then
            Throw New NotSupportedException("sheetmetal unfold/refold: requires an unambiguous flange_bend reference")
        End If
        If action = "corner_round" AndAlso G(parameters, "corners", New Object() {}).Length = 0 Then
            Throw New NotSupportedException("sheetmetal corner_round needs corner points")
        End If
        If action = "contour_flange" Then
            Dim contourExtent As String = CStr(G(parameters, "extent", "distance"))
            If contourExtent <> "distance" AndAlso contourExtent <> "edge" Then
                Throw New NotSupportedException("sheetmetal contour_flange by edge extent: a contour flange attached to an edge needs a straight edge that touches the sketch plane")
            End If
            If contourExtent = "distance" AndAlso Not parameters.ContainsKey("width") Then
                Throw New NotSupportedException("sheetmetal contour_flange by edge extent: a contour flange attached to an edge needs a straight edge that touches the sketch plane")
            End If
            If contourExtent = "edge" AndAlso Not parameters.ContainsKey("edge") Then
                Throw New NotSupportedException("sheetmetal contour_flange by edge extent: a contour flange attached to an edge needs a straight edge that touches the sketch plane")
            End If
        End If
        If action = "hem" Then
            Dim hemDirection As String = CStr(G(parameters, "direction", ""))
            If Not parameters.ContainsKey("edge") OrElse Not "|single|double|teardrop|rolled|".Contains("|" & CStr(G(parameters, "hem_type", "")) & "|") OrElse hemDirection.Length <> 2 OrElse Not "+-".Contains(hemDirection.Substring(0, 1)) OrElse Not "XYZ".Contains(hemDirection.Substring(1)) Then
                Throw New NotSupportedException("sheetmetal hem: hem needs one flange_free_edge, a single/double/teardrop/rolled type and a -/+ X/Y/Z fold direction")
            End If
        End If
        If action = "flange" Then
            Dim allowed As String = "|edges|height|angle|direction|height_datum|bend_position|bend_radius|corner_relief|corner_relief_size|corner_gap|bend_relief|bend_relief_width|bend_relief_depth|bend_transition|width_type|width|offset|from_corner|offset1|offset2|"
            For Each key As String In parameters.Keys
                If Not allowed.Contains("|" & key & "|") Then
                    Throw New NotSupportedException("sheetmetal flange overrides " & key & ": this flange override is not implemented")
                End If
            Next
            If CStr(G(parameters, "bend_position", "default")) <> "default" Then
                Throw New NotSupportedException("sheetmetal flange bend_position: FlangeDefinition has no bend-position member (HeightDatumType is the only placement option the Inventor API exposes)")
            End If
            If CStr(G(parameters, "height_datum", "default")) <> "default" AndAlso CStr(G(parameters, "height_datum", "default")) <> "alternative_default_record_option" Then
                Throw New NotSupportedException("sheetmetal flange height_datum " & CStr(parameters("height_datum")) & ": this flange override is not implemented")
            End If
            If Not "|default|round|straight|tear|".Contains("|" & CStr(G(parameters, "bend_relief", "default")) & "|") Then
                Throw New NotSupportedException("sheetmetal flange bend_relief " & CStr(parameters("bend_relief")) & ": this flange override is not implemented")
            End If
            Dim widthKind As String = CStr(G(parameters, "width_type", ""))
            If widthKind <> "" AndAlso widthKind <> "width" AndAlso widthKind <> "offset" Then
                Throw New NotSupportedException("sheetmetal flange width_type " & widthKind & ": this flange override is not implemented")
            End If
            If widthKind = "width" AndAlso Not (parameters.ContainsKey("width") AndAlso parameters.ContainsKey("offset") AndAlso parameters.ContainsKey("from_corner")) Then
                Throw New NotSupportedException("sheetmetal flange width needs width, offset and from_corner")
            End If
            If widthKind = "offset" AndAlso Not (parameters.ContainsKey("offset1") AndAlso parameters.ContainsKey("offset2")) Then
                Throw New NotSupportedException("sheetmetal flange offset width needs offset1 and offset2")
            End If
        End If
        If CStr(G(parameters, "save_state", "folded")) <> "folded" Then
            Throw New NotSupportedException("sheetmetal flat pattern saved state: native adapter not implemented")
        End If
    End If
    If CStr(o("type")) = "assembly" Then
        For Each pythonOnly As String In New String() {"place", "subassembly", "motion", "mirror", "suppress_constraint", "flexible", "move_child", "edit_source", "ipart"}
            If o.ContainsKey(pythonOnly) Then
                Throw New NotSupportedException("assembly " & pythonOnly & ": run from the Python builder (build_inventor.py)")
            End If
        Next
        If o.ContainsKey("pattern") AndAlso o("pattern").ContainsKey("circular") Then
            Throw New NotSupportedException("assembly circular pattern: run from the Python builder (build_inventor.py)")
        End If
    End If
    If CStr(o("type")) = "assembly" AndAlso Not (o.ContainsKey("insert") OrElse o.ContainsKey("constraint") OrElse o.ContainsKey("pattern") OrElse o.ContainsKey("component")) Then
        Throw New NotSupportedException("assembly action: native adapter not implemented")
    End If
    If CStr(o("type")) = "sketch" Then
        For Each entity As Object In o("entities")
            If Not "|rect_center|rect_2pt|circle|line|arc|point|".Contains("|" & CStr(entity("type")) & "|") Then
                Throw New NotSupportedException("sketch entity " & CStr(entity("type")) & ": native adapter not implemented")
            End If
        Next
    End If
    If CStr(o("type")) = "sketch" Then
        For Each corner As Object In G(o, "fillets", New Object() {})
            If Not corner.ContainsKey("at") OrElse Not corner.ContainsKey("r") Then
                Throw New NotSupportedException("sketch fillets need at and r")
            End If
        Next
    End If
    If "|extrude|revolve|sweep|loft|".Contains("|" & CStr(o("type")) & "|") AndAlso o.ContainsKey("profile") Then
        If TypeOf o("profile") Is Dictionary(Of String, Object) OrElse TypeOf o("profile") Is Object() Then
            Dim picks As Object() = If(TypeOf o("profile") Is Object(), o("profile"), New Object() {o("profile")})
            Dim names As New HashSet(Of String)()
            For Each pick As Object In picks
                If Not TypeOf pick Is Dictionary(Of String, Object) OrElse Not pick.ContainsKey("pick") OrElse pick("pick").Length <> 3 Then
                    Throw New NotSupportedException("profile region picks need a world point per region")
                End If
                names.Add(CStr(G(pick, "sketch", "")))
            Next
            If picks.Length = 0 OrElse names.Count <> 1 Then
                Throw New NotSupportedException("profile region picks across several sketches: one sketch per feature")
            End If
        End If
    End If
    If CStr(o("type")) = "extrude" Then
        If CBool(G(o, "surface", False)) Then
            If CStr(G(o, "extent", "distance")) <> "distance" OrElse CStr(G(o, "profile", "last")) <> "last" OrElse Not o.ContainsKey("name") Then
                Throw New NotSupportedException("extrude surface: only a named surface from the last sketch with a distance is scripted")
            End If
            surfaceNames.Add(CStr(o("name")))
        End If
        If CStr(G(o, "direction", "+")) = "two_sides" AndAlso Not o.ContainsKey("distance2") Then
            Throw New NotSupportedException("extrude two_sides needs distance2")
        End If
        If o.ContainsKey("distance2") AndAlso CStr(G(o, "direction", "+")) <> "two_sides" Then
            Throw New NotSupportedException("extrude distance2 without two_sides")
        End If
        If Not "|distance|through_all|to_face|between|".Contains("|" & CStr(G(o, "extent", "distance")) & "|") Then
            Throw New NotSupportedException("extrude extent " & CStr(o("extent")) & ": native adapter not implemented")
        End If
        If CStr(G(o, "extent", "distance")) = "to_face" AndAlso Not (o.ContainsKey("to_face") OrElse o.ContainsKey("to_plane")) Then
            Throw New NotSupportedException("extrude to_face needs to_face or to_plane")
        End If
        If CStr(G(o, "extent", "distance")) = "between" AndAlso Not (o.ContainsKey("from_plane") AndAlso o.ContainsKey("to_plane")) Then
            Throw New NotSupportedException("extrude between needs from_plane and to_plane")
        End If
    End If
End Sub

Function MetricTemplate(docType As Integer) As String
    ' https://help.autodesk.com/cloudhelp/2026/ENU/Inventor-API/files/SystemOfMeasureEnum.htm
    Const kMetricSystemOfMeasure As Integer = 8962
    Try
        Dim template As String = CStr(app.FileManager.GetTemplateFile(docType, kMetricSystemOfMeasure))
        If String.IsNullOrEmpty(template) OrElse Not File.Exists(template) Then
            Throw New Exception("template file missing")
        End If
        Return template
    Catch ex As Exception
        Throw New Exception("Metric template unavailable for document type " & CStr(docType) & "; install metric part/assembly templates", ex)
    End Try
End Function


Function P3(a As Object) As Object
    Return app.TransientGeometry.CreatePoint(CDbl(a(0))/10, CDbl(a(1))/10, CDbl(a(2))/10)
End Function

Function Local2(a As Object) As Double()
    If a.Length = 3 Then
        Dim point As Object = sk.ModelToSketchSpace(P3(a))
        Return New Double() {point.X*10, point.Y*10}
    End If
    Return New Double() {CDbl(a(0)), CDbl(a(1))}
End Function

Function P2(a As Object) As Object
    Dim local As Double() = Local2(a)
    Return app.TransientGeometry.CreatePoint2d(local(0)/10, local(1)/10)
End Function

Function Plane(value As Object) As Object
    If TypeOf value Is String Then
        Select Case CStr(value)
            Case "YZ"
                Return cd.WorkPlanes.Item(1)
            Case "XZ"
                Return cd.WorkPlanes.Item(2)
            Case Else
                Return cd.WorkPlanes.Item(3)
        End Select
    End If
    Dim basis As String
    Dim offset As Double
    If value.ContainsKey("normal") Then
        Dim bases As String() = {"YZ", "XZ", "XY"}
        basis = bases("XYZ".IndexOf(CStr(value("normal"))))
        offset = CDbl(value("origin")("XYZ".IndexOf(CStr(value("normal")))))
    Else
        basis = CStr(value("base"))
        offset = CDbl(value("offset"))
    End If
    Dim key As String = basis & ":" & CStr(offset)
    If planes.ContainsKey(key) Then
        Return planes(key)
    End If
    ' The XZ origin plane's native normal points -Y on newer Inventor and +Y on 2016: try the newer sign, measure where the
    ' plane landed and redo it on the other side when it is not at the asked position.
    Dim signed As Double = If(basis = "XZ", -offset, offset)
    Dim result As Object = cd.WorkPlanes.AddByPlaneAndOffset(Plane(basis), signed/10)
    Dim root As Object = result.Plane.RootPoint
    Dim landed As Double = If(basis = "YZ", CDbl(root.X), If(basis = "XZ", CDbl(root.Y), CDbl(root.Z)))*10
    If Math.Abs(landed - offset) > 0.001 Then
        result.Delete()
        result = cd.WorkPlanes.AddByPlaneAndOffset(Plane(basis), -signed/10)
    End If
    planes(key) = result
    Return result
End Function

Function Axis(value As String) As Object
    Return cd.WorkAxes.Item("XYZ".IndexOf(value)+1)
End Function

Function Collection(values As IEnumerable(Of Object), Optional kind As String = "Object") As Object
    Dim result As Object
    Select Case kind
        Case "Edge"
            result = app.TransientObjects.CreateEdgeCollection()
        Case "Face"
            result = app.TransientObjects.CreateFaceCollection()
        Case Else
            result = app.TransientObjects.CreateObjectCollection()
    End Select
    For Each value As Object In values
        result.Add(value)
    Next
    Return result
End Function

Function Reference(value As Object) As Object
    If value Is Nothing OrElse CStr(value) = "last" Then
        Return last
    End If
    Return refs(CStr(value))
End Function

Function Profile(value As Object) As Object
    If TypeOf value Is Dictionary(Of String, Object) OrElse TypeOf value Is Object() Then
        Return RegionProfile(value)
    End If
    Dim result As Object = lastProfile
    If value IsNot Nothing AndAlso CStr(value) <> "last" Then
        result = Reference(value)
    End If
    Try
        Return result.Profiles.AddForSolid()
    Catch ex As System.MissingMemberException
        Return result
    End Try
End Function

Function Outline(profilePath As Object) As List(Of Double())
    Dim points As New List(Of Double())()
    For i As Integer = 1 To profilePath.Count
        CheckClock()
        Dim entry As Object = profilePath.Item(i)
        Dim geometry As Object = entry.Curve
        Dim curveType As Integer = CInt(entry.CurveType)
        If curveType = 5252 OrElse curveType = 5253 Then
            ' Circle2d / Arc2d. Geometry is clipped and oriented by the profile.
            ' Read the curve once: a 0.001 rad step makes thousands of points, and a COM call per point took minutes on Inventor 2016.
            Dim start As Double = 0
            Dim sweep As Double = 2*Math.PI
            If curveType = 5253 Then
                start = CDbl(geometry.StartAngle)
                sweep = CDbl(geometry.SweepAngle)
            End If
            Dim radius As Double = CDbl(geometry.Radius)
            Dim centreX As Double = CDbl(geometry.Center.X)
            Dim centreY As Double = CDbl(geometry.Center.Y)
            Dim stepAngle As Double = Math.Min(0.001, 2*Math.Acos(Math.Max(-1, 1-0.000001/(radius*10))))
            Dim count As Integer = Math.Max(2, CInt(Math.Ceiling(Math.Abs(sweep)/stepAngle)))
            For j As Integer = 0 To count-1
                Dim angle As Double = start + sweep*j/count
                points.Add(New Double() {(centreX+radius*Math.Cos(angle))*10, (centreY+radius*Math.Sin(angle))*10})
            Next
        ElseIf curveType = 5251 Then
            points.Add(New Double() {geometry.StartPoint.X*10, geometry.StartPoint.Y*10})
        Else
            Throw New NotSupportedException("profile region picks over unsupported sketch curves")
        End If
    Next
    Return points
End Function

Function Inside(polygon As List(Of Double()), point As Double()) As Boolean
    Dim hit As Boolean = False
    For i As Integer = 0 To polygon.Count-1
        Dim a As Double() = polygon(i)
        Dim b As Double() = polygon((i+polygon.Count-1) Mod polygon.Count)
        If (a(1)>point(1)) <> (b(1)>point(1)) Then
            If point(0) < (b(0)-a(0))*(point(1)-a(1))/(b(1)-a(1))+a(0) Then
                hit = Not hit
            End If
        End If
    Next
    Return hit
End Function

Function OnBoundary(polygon As List(Of Double()), point As Double()) As Boolean
    For i As Integer = 0 To polygon.Count-1
        Dim a As Double() = polygon(i)
        Dim b As Double() = polygon((i+polygon.Count-1) Mod polygon.Count)
        Dim dx As Double = b(0)-a(0)
        Dim dy As Double = b(1)-a(1)
        Dim length2 As Double = dx*dx+dy*dy
        Dim t As Double = 0
        If length2 <> 0 Then
            t = Math.Max(0, Math.Min(1, ((point(0)-a(0))*dx+(point(1)-a(1))*dy)/length2))
        End If
        If Math.Sqrt((point(0)-a(0)-t*dx)^2+(point(1)-a(1)-t*dy)^2) <= 0.000101 Then
            Return True
        End If
    Next
    Return False
End Function

Function PolygonArea(polygon As List(Of Double())) As Double
    Dim total As Double = 0
    For i As Integer = 0 To polygon.Count-1
        Dim a As Double() = polygon(i)
        Dim b As Double() = polygon((i+polygon.Count-1) Mod polygon.Count)
        total += b(0)*a(1)-a(0)*b(1)
    Next
    Return Math.Abs(total)/2
End Function

Function RegionProfile(value As Object) As Object
    Dim picks As Object() = If(TypeOf value Is Object(), value, New Object() {value})
    Dim source As Object = lastProfile
    If picks(0).ContainsKey("sketch") Then
        source = Reference(picks(0)("sketch"))
    End If
    Dim previous As Object = sk
    sk = source
    Try
        Dim localPicks As New List(Of Double())()
        For Each pick As Object In picks
            localPicks.Add(Local2(pick("pick")))
        Next
        Dim result As Object = source.Profiles.AddForSolid(False)
        Dim paths As New List(Of Object)()
        Dim polygons As New List(Of List(Of Double()))()
        For i As Integer = 1 To result.Count
            paths.Add(result.Item(i))
            polygons.Add(Outline(result.Item(i)))
        Next
        Dim keep As New Dictionary(Of Integer, Boolean)()
        For Each point As Double() In localPicks
            Dim target As Integer = -1
            For i As Integer = 0 To paths.Count-1
                If OnBoundary(polygons(i), point) Then
                    Throw New Exception("Region pick lies on or within tolerance of a profile boundary")
                End If
                If Inside(polygons(i), point) Then
                    If target = -1 OrElse PolygonArea(polygons(i)) < PolygonArea(polygons(target)) Then
                        target = i
                    End If
                End If
            Next
            If target = -1 Then
                Throw New Exception("Region pick matched no closed region")
            End If
            keep(target) = True
            For j As Integer = 0 To paths.Count-1
                If j <> target AndAlso PolygonArea(polygons(j)) < PolygonArea(polygons(target)) AndAlso Not OnBoundary(polygons(target), polygons(j)(0)) AndAlso Inside(polygons(target), polygons(j)(0)) Then
                    Dim immediate As Boolean = True
                    For k As Integer = 0 To paths.Count-1
                        If k <> j AndAlso PolygonArea(polygons(j)) < PolygonArea(polygons(k)) AndAlso PolygonArea(polygons(k)) < PolygonArea(polygons(target)) AndAlso Inside(polygons(k), polygons(j)(0)) AndAlso Inside(polygons(target), polygons(k)(0)) Then
                            immediate = False
                        End If
                    Next
                    If immediate AndAlso Not keep.ContainsKey(j) Then
                        keep(j) = False
                    End If
                End If
            Next
        Next
        For Each index As Integer In keep.Keys
            result.Item(index + 1).AddsMaterial = keep(index)
        Next
        For i As Integer = paths.Count-1 To 0 Step -1
            If Not keep.ContainsKey(i) Then
                result.Item(i + 1).Delete()
            End If
        Next
        Return result
    Finally
        sk = previous
    End Try
End Function

Sub SketchFillet(corner As Object, lines As List(Of Object))
    Dim at As Double() = Local2(corner("at"))
    Dim touching As New List(Of Object)()
    Dim points As New List(Of Object)()
    For Each line As Object In lines
        Dim a As Object = line.StartSketchPoint.Geometry
        Dim b As Object = line.EndSketchPoint.Geometry
        If (Math.Abs(a.X*10-at(0))<0.0001 AndAlso Math.Abs(a.Y*10-at(1))<0.0001) OrElse (Math.Abs(b.X*10-at(0))<0.0001 AndAlso Math.Abs(b.Y*10-at(1))<0.0001) Then
            touching.Add(line)
            points.Add(tg.CreatePoint2d((a.X+b.X)/2, (a.Y+b.Y)/2))
        End If
    Next
    If touching.Count <> 2 Then
        Throw New Exception("Sketch fillet corner must match exactly two lines")
    End If
    sk.SketchArcs.AddByFillet(touching(0), touching(1), CDbl(corner("r"))/10, points(0), points(1))
End Sub

Function SketchCurves(source As Object) As Object
    Dim curves As New List(Of Object)()
    Dim entities As Object
    If source.Type = 83936256 Then
        entities = source.SketchEntities3D
    Else
        entities = source.SketchEntities
    End If
    For i As Integer = 1 To entities.Count
        Dim entity As Object = entities.Item(i)
        If entity.Type <> 83896576 AndAlso entity.Type <> 83937792 Then
            If Not entity.Construction Then curves.Add(entity)
        End If
    Next
    Return Collection(curves)
End Function

Function SelectorWhy(kind As String, query As Object) As String
    Dim why As String = ""
    If kind = "edge" Then
        If query.ContainsKey("dir") Then why &= ", direction " & CStr(query("dir"))
        If query.ContainsKey("tangent") Then why &= ", tangent given"
    ElseIf kind = "face" Then
        If query.ContainsKey("normal") Then why &= ", normal " & CStr(query("normal"))
    End If
    Return why
End Function

Function SelectGeometry(selector As Object) As Object
    If CInt(app.SoftwareVersion.Major) < 22 Then
        If Not cd.Document.Update2(False) Then
            ' Inventor 2016 answers False while a profile sketch waits to be used (S09); a second plain Update decides.
            Try
                cd.Document.Update()
            Catch ex As Exception
                Throw New Exception("Inventor document update failed before selection: " & ex.Message)
            End Try
        End If
    End If
    Dim kind As String = ""
    For Each key As String In selector.Keys
        If "|edge|face|vertex|".Contains("|" & key & "|") Then
            kind = key
        End If
    Next
    If selector.ContainsKey("body") Then
        Throw New NotSupportedException("body-scoped B-rep selectors: native adapter not implemented")
    End If
    Dim occurrence As Object = Nothing
    Dim bodies As Object = Nothing
    If selector.ContainsKey("component") Then
        occurrence = Reference(selector("component"))
        bodies = occurrence.Definition.SurfaceBodies
    Else
        bodies = cd.SurfaceBodies
    End If
    Dim query As Object = selector(kind)
    Dim location As Object = query
    If kind = "edge" Then
        location = query("through")
    ElseIf kind = "face" Then
        location = query("contains")
    End If
    Dim point As Object = P3(location)
    Dim matches As New List(Of Object)()
    Dim tested As Integer = 0
    Dim nearest As Double = -1
    For i As Integer = 1 To bodies.Count
        Dim body As Object = bodies.Item(i)
        Dim entities As Object
        Select Case kind
            Case "edge"
                entities = body.Edges
            Case "face"
                entities = body.Faces
            Case Else
                entities = body.Vertices
        End Select
        For j As Integer = 1 To entities.Count
            Dim entity As Object = entities.Item(j)
            Dim gap As Double = CDbl(app.MeasureTools.GetMinimumDistance(entity, point))
            tested += 1
            If nearest < 0 OrElse gap < nearest Then
                nearest = gap
            End If
            If gap > 0.00001 Then
                Continue For
            End If
            If kind = "edge" AndAlso query.ContainsKey("dir") Then
                Dim vector As Object
                Try
                    vector = entity.Geometry.Direction
                Catch
                    Continue For
                End Try
                Dim components As Double() = {vector.X, vector.Y, vector.Z}
                If Math.Abs(Math.Abs(components("XYZ".IndexOf(CStr(query("dir")))))-1) > 0.000001 Then
                    Continue For
                End If
            End If
            If kind = "edge" AndAlso query.ContainsKey("tangent") Then
                Dim tangent As Double()
                Try
                    Dim vector As Object = entity.Geometry.Direction
                    tangent = New Double() {vector.X, vector.Y, vector.Z}
                Catch
                    Dim normal As Object = entity.Geometry.Normal
                    Dim center As Object = entity.Geometry.Center
                    Dim radial As Double() = {point.X-center.X, point.Y-center.Y, point.Z-center.Z}
                    tangent = New Double() {normal.Y*radial(2)-normal.Z*radial(1), normal.Z*radial(0)-normal.X*radial(2), normal.X*radial(1)-normal.Y*radial(0)}
                End Try
                Dim expected As Object = query("tangent")
                Dim dot As Double = 0
                Dim magA As Double = 0
                Dim magB As Double = 0
                For k As Integer = 0 To 2
                    dot += tangent(k)*CDbl(expected(k))
                    magA += tangent(k)*tangent(k)
                    magB += CDbl(expected(k))*CDbl(expected(k))
                Next
                If magA*magB = 0 OrElse Math.Abs(Math.Abs(dot/Math.Sqrt(magA*magB))-1) > 0.000001 Then
                    Continue For
                End If
            End If
            If kind = "face" AndAlso query.ContainsKey("normal") Then
                Dim coordinates As Double() = {CDbl(location(0))/10, CDbl(location(1))/10, CDbl(location(2))/10}
                Dim normals(2) As Double
                If TypeOf entity.Evaluator Is ComProxy Then
                    Dim normalArgs As Object() = {coordinates, normals}
                    CType(entity.Evaluator, ComProxy).InvokeNamed("GetNormalAtPoint", normalArgs)
                    normals = CType(normalArgs(1), Double())
                Else
                    entity.Evaluator.GetNormalAtPoint(coordinates, normals)
                End If
                Dim desired As String = CStr(query("normal"))
                Dim sign As Integer = If(desired.StartsWith("-"), -1, 1)
                If Math.Abs(normals("XYZ".IndexOf(desired.Substring(desired.Length-1))) * sign - 1) > 0.000001 Then
                    Continue For
                End If
            End If
            matches.Add(entity)
        Next
    Next
    If kind = "face" AndAlso matches.Count > 1 AndAlso CoplanarFaces(matches) Then
        ' Faces of one plane (a flat pattern keeps the top of the sheet in several pieces) name the same sketch plane.
        matches = New List(Of Object)() From {matches(0)}
    End If
    If matches.Count <> 1 Then
        Throw New Exception("Geometric selector matched " & matches.Count & " entities; expected exactly one (" & kind & " at (" & CStr(location(0)) & ", " & CStr(location(1)) & ", " & CStr(location(2)) & ") mm" & SelectorWhy(kind, query) & "; " & tested & " " & kind & "(s) tested, nearest " & Math.Round(nearest*10, 4) & " mm away)")
    End If
    If occurrence IsNot Nothing Then
        Dim proxy As Object = Nothing
        If TypeOf occurrence Is ComProxy Then
            proxy = LegacyGeometryProxy(occurrence, matches(0))
        Else
            occurrence.CreateGeometryProxy(matches(0), proxy)
        End If
        Return proxy
    End If
    Return matches(0)
End Function

Function JoinPoint(a As Object) As Object
    ' The Point2d for a sketch position, or on Inventor 2016-2021 the existing SketchPoint already at that position.
    If Legacy() Then
        Dim local As Double() = Local2(a)
        For Each existing As Object In joints
            Dim place As Object = existing.Geometry
            If Math.Abs(CDbl(place.X)*10-local(0)) < 0.0001 AndAlso Math.Abs(CDbl(place.Y)*10-local(1)) < 0.0001 Then
                Return existing
            End If
        Next
    End If
    Return P2(a)
End Function

Sub RememberPoints(first As Object, second As Object, third As Object)
    If Not Legacy() Then
        Return
    End If
    For Each point As Object In New Object() {first, second, third}
        If point IsNot Nothing AndAlso Not joints.Contains(point) Then
            joints.Add(point)
        End If
    Next
End Sub

Sub NoteProjected(entity As Object)
    ' A projected edge: its end points are joinable, and a line that ends in its middle gets a coincident constraint.
    If Not Legacy() Then
        Return
    End If
    Try
        projected.Add(entity)
        RememberPoints(entity.StartSketchPoint, entity.EndSketchPoint, Nothing)
    Catch ex As Exception
    End Try
End Sub

Sub TouchProjected(point As Object)
    ' Inventor 2016-2021 only close a profile at a line that ends on a projected edge when a coincident constraint says so.
    If Not Legacy() Then
        Return
    End If
    For Each edge As Object In projected
        Try
            Dim a As Object = edge.StartSketchPoint.Geometry
            Dim b As Object = edge.EndSketchPoint.Geometry
            Dim p As Object = point.Geometry
            Dim dx As Double = CDbl(b.X)-CDbl(a.X)
            Dim dy As Double = CDbl(b.Y)-CDbl(a.Y)
            Dim length2 As Double = dx*dx+dy*dy
            If length2 = 0 Then
                Continue For
            End If
            Dim t As Double = ((CDbl(p.X)-CDbl(a.X))*dx+(CDbl(p.Y)-CDbl(a.Y))*dy)/length2
            Dim offX As Double = CDbl(p.X)-CDbl(a.X)-t*dx
            Dim offY As Double = CDbl(p.Y)-CDbl(a.Y)-t*dy
            If t > 0.000001 AndAlso t < 0.999999 AndAlso Math.Sqrt(offX*offX+offY*offY)*10 < 0.0001 Then
                sk.GeometricConstraints.AddCoincident(point, edge)
            End If
        Catch ex As Exception
        End Try
    Next
End Sub

Function ContourOnEdge(path As Object, selector As Object) As Object
    ' A contour flange attached to an existing edge: the edge goes into CreateContourFlangeDefinition as its second argument
    ' (without it the flange is a base flange and Add is refused), the width extent is the whole edge or its measured length.
    Dim edge As Object = SelectGeometry(selector)
    Dim failures As String = ""
    For form As Integer = 1 To 4
        Try
            Dim edges As Object = Collection(New Object() {edge}, "Edge")
            Dim definition As Object
            If form <= 2 Then
                definition = cd.Features.ContourFlangeFeatures.CreateContourFlangeDefinition(path, edges)
            Else
                definition = InteropCall("ContourFlangeFeatures", cd.Features.ContourFlangeFeatures, "CreateContourFlangeDefinition", New Object() {path, edges})
            End If
            If form Mod 2 = 1 Then
                InteropCall("ContourFlangeDefinition", definition, "SetEdgeWidthExtent", New Object() {edge})
            Else
                Dim direction As Integer = 20993
                Dim width As Double = EdgeWidth(selector, direction)
                definition.SetDistanceExtent(width/10, direction)
            End If
            Try
                Return cd.Features.ContourFlangeFeatures.Add(definition)
            Catch
                ' failure_policy: retry on the other material side; the application's own error stands if that fails too.
                definition.ExtentDirection = If(CInt(definition.ExtentDirection) = 20993, 20994, 20993)
                Return cd.Features.ContourFlangeFeatures.Add(definition)
            End Try
        Catch ex As Exception
            failures &= " [form " & form & ": " & ex.Message & "]"
        End Try
    Next
    Throw New Exception("contour flange on an edge refused in every form:" & failures)
End Function

Function CoplanarFaces(faces As List(Of Object)) As Boolean
    Try
        Dim first As Object = faces(0).Geometry
        Dim n As Object = first.Normal
        For i As Integer = 1 To faces.Count - 1
            Dim other As Object = faces(i).Geometry
            Dim m As Object = other.Normal
            If Math.Abs(Math.Abs(n.X*m.X + n.Y*m.Y + n.Z*m.Z) - 1) > 0.000001 Then Return False
            If Math.Abs((other.RootPoint.X - first.RootPoint.X)*n.X + (other.RootPoint.Y - first.RootPoint.Y)*n.Y + (other.RootPoint.Z - first.RootPoint.Z)*n.Z) > 0.00001 Then Return False
        Next
        Return True
    Catch
        Return False
    End Try
End Function

Function TrimLeftWrongSide(parameters As Object) As Boolean
    ' True when the solid that is left lies on the side the recipe says to remove (checked on the range box along the tool's normal).
    Dim tool As Object = parameters("tool")
    If Not TypeOf tool Is Dictionary(Of String, Object) OrElse Not tool.ContainsKey("offset") Then Return False
    Dim axis As Integer = "XYZ".IndexOf(CStr(parameters("remove")).Substring(1, 1))
    Dim normalAxis As Integer = If(CStr(tool("base")) = "YZ", 0, If(CStr(tool("base")) = "XZ", 1, 2))
    If axis <> normalAxis Then Return False
    Dim place As Double = CDbl(tool("offset"))
    For i As Integer = 1 To cd.SurfaceBodies.Count
        If cd.SurfaceBodies.Item(i).IsSolid Then
            Dim box As Object = cd.SurfaceBodies.Item(i).RangeBox
            Dim low As Double = {CDbl(box.MinPoint.X), CDbl(box.MinPoint.Y), CDbl(box.MinPoint.Z)}(axis)*10
            Dim high As Double = {CDbl(box.MaxPoint.X), CDbl(box.MaxPoint.Y), CDbl(box.MaxPoint.Z)}(axis)*10
            If CStr(parameters("remove")).StartsWith("+") Then
                Return high > place + 0.001
            End If
            Return low < place - 0.001
        End If
    Next
    Return False
End Function

Function BodiesVolume() As Double
    Dim total As Double = 0
    Try
        cd.Document.Update2(False)
    Catch
    End Try
    For i As Integer = 1 To cd.SurfaceBodies.Count
        total += CDbl(cd.SurfaceBodies.Item(i).Volume(0.0001))
    Next
    Return total
End Function

Function InteropCall(typeName As String, target As Object, method As String, args As Object()) As Object
    ' Calls a member through the Inventor interop assembly's own type (a vtable call with typed arguments). The late-bound
    ' IDispatch route is refused with E_FAIL by some members on Inventor 2016.
    Dim interop As System.Reflection.Assembly = Nothing
    For Each loaded As System.Reflection.Assembly In AppDomain.CurrentDomain.GetAssemblies()
        If loaded.GetName().Name = "Autodesk.Inventor.Interop" Then interop = loaded
    Next
    If interop Is Nothing Then
        Dim bin As String = System.IO.Path.GetDirectoryName(System.Diagnostics.Process.GetCurrentProcess().MainModule.FileName)
        interop = System.Reflection.Assembly.LoadFrom(System.IO.Path.Combine(bin, "Public Assemblies", "Autodesk.Inventor.Interop.dll"))
    End If
    Dim kind As Type = interop.GetType("Inventor." & typeName)
    Dim raw As Object() = New Object(args.Length - 1) {}
    For i As Integer = 0 To args.Length - 1
        raw(i) = ComProxy.Unwrap(args(i))
    Next
    Try
        Return ComProxy.Wrap(kind.InvokeMember(method, System.Reflection.BindingFlags.InvokeMethod, Nothing, ComProxy.Unwrap(target), raw))
    Catch ex As System.Reflection.TargetInvocationException
        Throw ex.InnerException
    End Try
End Function

Function LegacyRectPattern(features As Object, o As Object) As Object
    ' Inventor 2016-2021 has no pattern CreateDefinition: RectangularPatternFeatures.Add only. Counts go as Integer
    ' (a Double count is refused), spacing in centimeters. The forms run from the typed interop call to late-bound ones.
    Dim d1 As Object = o("dir1")
    Dim d2 As Object = Nothing
    If o.ContainsKey("dir2") Then
        d2 = o("dir2")
    End If
    Dim failures As String = ""
    For form As Integer = 1 To 6
        Try
            Dim count1 As Object = CInt(d1("count"))
            Dim gap1 As Object = CDbl(d1("spacing"))/10
            Dim count2 As Object = Nothing
            Dim gap2 As Object = Nothing
            If d2 IsNot Nothing Then
                count2 = CInt(d2("count"))
                gap2 = CDbl(d2("spacing"))/10
            End If
            If form = 2 OrElse form = 5 Then
                count1 = CStr(CInt(d1("count")))
                gap1 = CStr(CDbl(d1("spacing"))) & " mm"
                If d2 IsNot Nothing Then
                    count2 = CStr(CInt(d2("count")))
                    gap2 = CStr(CDbl(d2("spacing"))) & " mm"
                End If
            End If
            Dim natural1 As Boolean = Not CBool(G(d1, "flip", False))
            If form <= 2 Then
                ' Through the interop type (a vtable call), not IDispatch: the late-bound Add is refused on 2016.
                If d2 Is Nothing Then
                    Return InteropCall("RectangularPatternFeatures", cd.Features.RectangularPatternFeatures, "Add", New Object() {features, Axis(CStr(d1("axis"))), natural1, count1, gap1})
                End If
                Return InteropCall("RectangularPatternFeatures", cd.Features.RectangularPatternFeatures, "Add", New Object() {features, Axis(CStr(d1("axis"))), natural1, count1, gap1, 33537, Type.Missing, Axis(CStr(d2("axis"))), Not CBool(G(d2, "flip", False)), count2, gap2})
            End If
            Dim patterns As Object = ComProxy.Wrap(cd.Features.RectangularPatternFeatures)
            Dim args As Object() = {features, Axis(CStr(d1("axis"))), natural1, count1, gap1}
            If d2 IsNot Nothing Then
                If form >= 4 Then
                    args = New Object() {features, Axis(CStr(d1("axis"))), natural1, count1, gap1, 33537, System.Reflection.Missing.Value, Axis(CStr(d2("axis"))), Not CBool(G(d2, "flip", False)), count2, gap2, 33537, System.Reflection.Missing.Value, 47361, 33793}
                Else
                    args = New Object() {features, Axis(CStr(d1("axis"))), natural1, count1, gap1, 33537, System.Reflection.Missing.Value, Axis(CStr(d2("axis"))), Not CBool(G(d2, "flip", False)), count2, gap2}
                End If
            End If
            Return CType(patterns, ComProxy).InvokeNamed("Add", args)
        Catch ex As Exception
            failures &= " [form " & form & ": " & ex.Message & "]"
        End Try
    Next
    Throw New Exception("rectangular pattern refused in every form:" & failures)
End Function

Function LegacyCircPattern(features As Object, o As Object) As Object
    ' Inventor 2016-2021: CircularPatternFeatures.Add (no CreateDefinition before 2017): typed interop call first, then
    ' late-bound through InvokeNamed. Integer count, angle as a string with unit or as radians.
    Dim failures As String = ""
    For form As Integer = 1 To 5
        Try
            Dim count As Object = CInt(o("count"))
            Dim angle As Object = CStr(G(o, "angle", 360)) & " deg"
            If form = 2 OrElse form = 5 Then
                count = CStr(CInt(o("count")))
            End If
            If form = 3 Then
                angle = CDbl(G(o, "angle", 360)) * Math.PI / 180
            End If
            If form <= 3 Then
                Return InteropCall("CircularPatternFeatures", cd.Features.CircularPatternFeatures, "Add", New Object() {features, Axis(CStr(o("axis"))), True, count, angle, True})
            End If
            Dim patterns As Object = ComProxy.Wrap(cd.Features.CircularPatternFeatures)
            Dim args As Object() = {features, Axis(CStr(o("axis"))), True, count, angle, True}
            Return CType(patterns, ComProxy).InvokeNamed("Add", args)
        Catch ex As Exception
            failures &= " [form " & form & ": " & ex.Message & "]"
        End Try
    Next
    Throw New Exception("circular pattern refused in every form:" & failures)
End Function

Function LegacyGeometryProxy(occurrence As Object, native As Object) As Object
    ' Inventor 2016: the proxy comes back through a ByRef Object. A bare Nothing reaches Inventor as an untyped
    ' variant and fails with DISP_E_TYPEMISMATCH; hand it a null IDispatch first.
    Dim failures As String = ""
    For form As Integer = 1 To 2
        Try
            Dim holder As Object = Nothing
            If form = 1 Then
                holder = New System.Runtime.InteropServices.DispatchWrapper(Nothing)
            End If
            Dim proxyArgs As Object() = {native, holder}
            CType(occurrence, ComProxy).InvokeNamed("CreateGeometryProxy", proxyArgs)
            If proxyArgs(1) IsNot Nothing AndAlso Not TypeOf proxyArgs(1) Is System.Runtime.InteropServices.DispatchWrapper Then
                Return proxyArgs(1)
            End If
            failures &= " [form " & form & ": no proxy returned]"
        Catch ex As Exception
            failures &= " [form " & form & ": " & ex.Message & "]"
        End Try
    Next
    Throw New Exception("occurrence geometry proxy refused in every form:" & failures)
End Function

Function LegacyConstraint(constraint As Object, a As Object, b As Object, offset As Double) As Object
    ' Inventor 2016-2021 assembly constraints: the offset as a number (centimeters), then as an expression string.
    Dim failures As String = ""
    For form As Integer = 1 To 2
        Try
            Dim distance As Object = offset
            If form = 2 Then
                distance = CStr(offset*10) & " mm"
            End If
            Select Case CStr(constraint("type"))
                Case "mate"
                    Return cd.Constraints.AddMateConstraint(a, b, distance)
                Case "flush"
                    Return cd.Constraints.AddFlushConstraint(a, b, distance)
                Case "insert"
                    Return cd.Constraints.AddInsertConstraint(a, b, CBool(G(constraint, "axes_opposed", True)), distance)
                Case "angle"
                    Return cd.Constraints.AddAngleConstraint(a, b, CStr(constraint("angle")) & " deg")
                Case "tangent"
                    Return cd.Constraints.AddTangentConstraint(a, b, CStr(G(constraint, "solution", "outside")) = "inside", distance)
                Case Else
                    Throw New NotSupportedException("assembly constraint " & CStr(constraint("type")))
            End Select
        Catch ex As NotSupportedException
            Throw
        Catch ex As Exception
            failures &= " [form " & form & ": " & ex.Message & "]"
        End Try
    Next
    Throw New Exception("assembly constraint refused in every form:" & failures)
End Function

Function Relief(value As String) As Integer
    Select Case value
        Case "round"
            Return 28417
        Case "square"
            Return 28418
        Case "tear"
            Return 28419
        Case Else
            Throw New NotSupportedException("sheetmetal corner relief " & value)
    End Select
End Function

' A document-owned copy of a library appearance whose diffuse color is the named plain color.
Function AppearanceAsset(color As String) As Object
    Dim title As String = "Fixture " & color
    Dim existing As Object = cd.Document.AppearanceAssets
    For i As Integer = 1 To CInt(existing.Count)
        If CStr(existing.Item(i).DisplayName) = title Then Return existing.Item(i)
    Next
    Dim rgb As Integer() = New Integer() {255, 0, 0}
    Select Case color
        Case "green"
            rgb = New Integer() {0, 160, 0}
        Case "blue"
            rgb = New Integer() {0, 0, 255}
        Case "yellow"
            rgb = New Integer() {255, 220, 0}
        Case "orange"
            rgb = New Integer() {255, 128, 0}
        Case "white"
            rgb = New Integer() {255, 255, 255}
        Case "black"
            rgb = New Integer() {0, 0, 0}
        Case "grey", "gray"
            rgb = New Integer() {128, 128, 128}
    End Select
    Dim libraries As Object = app.AssetLibraries
    For i As Integer = 1 To CInt(libraries.Count)
        Dim assets As Object = libraries.Item(i).AppearanceAssets
        For j As Integer = 1 To CInt(assets.Count)
            Dim candidate As Object = assets.Item(j)
            Try
                candidate.Item("generic_diffuse")
            Catch
                Continue For
            End Try
            Dim copy As Object = candidate.CopyTo(cd.Document, True)
            copy.DisplayName = title
            copy.Item("generic_diffuse").Value = app.TransientObjects.CreateColor(rgb(0), rgb(1), rgb(2))
            Return copy
        Next
    Next
    Throw New NotSupportedException("appearance: no library appearance with a generic_diffuse color was found")
End Function

Function BuildAppearance(parameters As Object) As Object
    Dim asset As Object = AppearanceAsset(CStr(parameters("color")))
    Dim target As Object = parameters("target")
    If TypeOf target Is String Then
        cd.Document.ActiveAppearance = asset
    ElseIf target.ContainsKey("face") Then
        SelectGeometry(target).Appearance = asset
    Else
        Reference(target("component")).Appearance = asset
    End If
    Return asset
End Function

Function EdgeEnds(edge As Object) As Object()
    Return New Object() {edge.StartVertex.Point, edge.StopVertex.Point}
End Function

' Width and extent direction of a contour flange spanning a whole straight edge that starts on the sketch plane.
Function EdgeWidth(selector As Object, ByRef direction As Integer) As Double
    Dim edge As Object = SelectGeometry(selector)
    Dim ends As Object() = EdgeEnds(edge)
    Dim length As Double = CDbl(ends(0).DistanceTo(ends(1)))*10
    Dim normal As Object = sk.PlanarEntityGeometry.Normal
    Dim origin As Object = sk.PlanarEntityGeometry.RootPoint
    Dim sides(1) As Double
    For i As Integer = 0 To 1
        sides(i) = ((ends(i).X - origin.X)*normal.X + (ends(i).Y - origin.Y)*normal.Y + (ends(i).Z - origin.Z)*normal.Z)*10
    Next
    If Math.Min(Math.Abs(sides(0)), Math.Abs(sides(1))) > 0.0001 OrElse length < 0.0001 Then
        Throw New NotSupportedException("sheetmetal contour_flange by edge extent: a contour flange attached to an edge needs a straight edge that touches the sketch plane")
    End If
    Dim far As Double = If(Math.Abs(sides(0)) < Math.Abs(sides(1)), sides(1), sides(0))
    direction = If(far > 0, 20993, 20994)
    Return length
End Function

' Height datum, bend relief options, bend transition and width extents of an edge flange.
Sub FlangeOverrides(definition As Object, parameters As Object)
    If CStr(G(parameters, "height_datum", "default")) <> "default" Then
        ' kPositiveExtentDirection, HeightDatumTypeEnum.kHeightDatumInner
        definition.SetDistanceHeightExtent(CDbl(parameters("height"))/10, 20993, 75522)
    End If
    Dim shape As String = CStr(G(parameters, "bend_relief", "default"))
    If shape <> "default" OrElse CStr(G(parameters, "bend_relief_width", "default")) <> "default" OrElse parameters.ContainsKey("bend_relief_depth") OrElse parameters.ContainsKey("bend_transition") Then
        Dim options As Object = definition.BendOptions
        If parameters.ContainsKey("bend_relief") Then
            options.BendReliefShape = If(shape = "round", 27906, If(shape = "straight", 27905, If(shape = "tear", 27908, 27907)))
        End If
        If parameters.ContainsKey("bend_relief_depth") Then
            options.BendReliefDepth = CDbl(parameters("bend_relief_depth"))/10
        End If
        If CStr(G(parameters, "bend_relief_width", "default")) <> "default" Then
            Try
                options.BendReliefWidth = CDbl(parameters("bend_relief_width"))/10
            Catch
                ' Inventor 2016 refuses a width the default depth (half a thickness) cannot hold with E_INVALIDARG: deepen the relief to one thickness.
                If parameters.ContainsKey("bend_relief_depth") Then Throw
                options.BendReliefDepth = If(smThickness > 0, smThickness, 1.0)/10
                options.BendReliefWidth = CDbl(parameters("bend_relief_width"))/10
            End Try
        End If
        If parameters.ContainsKey("bend_transition") Then
            ' "arc unless default then straight line": try the arc transition, fall back to a straight line.
            Try
                options.BendTransition = 28164
            Catch
                options.BendTransition = 28163
            End Try
        End If
        definition.BendOptions = options
    End If
    Dim widthKind As String = CStr(G(parameters, "width_type", ""))
    If widthKind = "width" OrElse widthKind = "offset" Then
        If CInt(app.SoftwareVersion.Major) < 29 Then
            Throw New NotSupportedException("flange width extents need Inventor 2025+ (FlangeEdgeSet was added in 2025)")
        End If
        Dim edges As New List(Of Object)()
        For Each selector As Object In parameters("edges")
            edges.Add(SelectGeometry(selector))
        Next
        Dim edgeSet As Object = definition.AddFlangeEdgeSet(Collection(edges, "Edge"))
        If widthKind = "width" Then
            Dim corner As Object = SelectGeometry(New Dictionary(Of String, Object) From {{"vertex", parameters("from_corner")}})
            edgeSet.SetWidthOffsetWidthExtent(CDbl(parameters("width"))/10, CDbl(parameters("offset"))/10, corner, True)
        Else
            edgeSet.SetOffsetdWidthExtent(edges(0).StartVertex, CDbl(parameters("offset1"))/10, edges(0).StopVertex, CDbl(parameters("offset2"))/10)
        End If
    End If
End Sub

' Hem on a free flange edge; the fold side is checked on the finished body and flipped once if wrong.
' The hem names the flange's free edge by a point on it. Inventor measures a flange's height from the far face of the base
' (the booklet's point is one thickness higher), so when nothing sits on that point the edge one thickness lower is the free edge.
Function SelectFreeEdge(selector As Object) As Object
    Try
        Return SelectGeometry(selector)
    Catch ex As Exception
        If Not ex.Message.StartsWith("Geometric selector matched 0 ") Then Throw
        Dim query As Object = selector("edge")
        Dim through As Object = query("through")
        Dim thickness As Double = If(smThickness > 0, smThickness, 1.0)
        Dim found As Object = Nothing
        Dim count As Integer = 0
        For axis As Integer = 0 To 2
            If query.ContainsKey("dir") AndAlso axis = "XYZ".IndexOf(CStr(query("dir"))) Then Continue For
            For Each delta As Double In New Double() {-thickness, thickness}
                Dim moved As New List(Of Object)()
                For k As Integer = 0 To 2
                    moved.Add(CDbl(through(k)) + If(k = axis, delta, 0))
                Next
                Dim shifted As New Dictionary(Of String, Object)()
                For Each pair As KeyValuePair(Of String, Object) In query
                    shifted(pair.Key) = pair.Value
                Next
                shifted("through") = moved
                Dim retry As New Dictionary(Of String, Object)()
                retry("edge") = shifted
                Try
                    found = SelectGeometry(retry)
                    count += 1
                Catch
                End Try
            Next
        Next
        If count <> 1 Then Throw
        Return found
    End Try
End Function

Function BuildHem(parameters As Object) As Object
    Dim edge As Object = SelectFreeEdge(parameters("edge"))
    Dim direction As String = CStr(parameters("direction"))
    Dim axis As Integer = "XYZ".IndexOf(direction.Substring(direction.Length-1))
    Dim sign As Integer = If(direction.StartsWith("-"), -1, 1)
    Dim coordinate As Double = CDbl(parameters("edge")("edge")("through")(axis))
    Dim thickness As Double = If(smThickness > 0, smThickness, 1.0)
    Dim kind As String = CStr(parameters("hem_type"))
    Dim gap As Double = If(CStr(G(parameters, "gap", "default")) = "default", thickness, CDbl(parameters("gap")))
    Dim length As Double = If(CStr(G(parameters, "length", "default")) = "default", 4*thickness, CDbl(parameters("length")))
    Dim failure As Exception = Nothing
    For Each flip As Boolean In New Boolean() {False, True}
        Dim definition As Object = cd.Features.HemFeatures.CreateHemDefinition(Collection(New Object() {edge}, "Edge"))
        If kind = "single" Then
            definition.SetSingleHemType(gap/10, length/10)
        ElseIf kind = "double" Then
            definition.SetDoubleHemType(gap/10, length/10)
        ElseIf kind = "teardrop" Then
            definition.SetTeardropHemType(thickness/10, Math.PI*270/180)
        Else
            definition.SetRolledHemType(thickness/10, Math.PI)
        End If
        definition.IsOnEdgeSide = ((sign > 0) <> flip)
        Dim feature As Object = Nothing
        Try
            feature = cd.Features.HemFeatures.Add(definition)
        Catch ex As Exception
            failure = ex
            Continue For
        End Try
        Dim box As Object = cd.SurfaceBodies.Item(1).RangeBox
        Dim top As Double = If(axis = 0, CDbl(box.MaxPoint.X), If(axis = 1, CDbl(box.MaxPoint.Y), CDbl(box.MaxPoint.Z)))*10
        If (top > coordinate + 0.05) = (sign > 0) Then
            refs("hem") = feature
            Return feature
        End If
        feature.Delete()
        failure = New NotSupportedException("hem folded to the wrong side instead of " & direction)
    Next
    Throw failure
End Function

Function BuildSheetMetal(o As Object) As Object
    Dim parameters As Object = o("app")
    Dim action As String = CStr(o("action"))
    If action = "bend" Then
        Dim edges As New List(Of Object)()
        For Each selector As Object In parameters("edges")
            edges.Add(SelectGeometry(selector))
        Next
        Dim definition As Object = cd.Features.BendFeatures.CreateBendDefinition(Collection(edges, "Edge"))
        Return cd.Features.BendFeatures.Add(definition)
    End If
    If action = "unfold" OrElse action = "refold" Then
        If cd.Bends.Count <> 1 OrElse Not refs.ContainsKey("flange") Then
            Throw New NotSupportedException("sheetmetal flange_bend requires exactly one bend in the part")
        End If
        If action = "unfold" Then
            refs("stationary_selector") = parameters("stationary_face")
        End If
        If Not refs.ContainsKey("stationary_selector") Then
            Throw New NotSupportedException("sheetmetal refold needs a preceding unfold stationary face")
        End If
        Dim face As Object
        If action = "unfold" Then
            face = SelectGeometry(refs("stationary_selector"))
            refs("stationary_face") = face
        Else
            face = refs("stationary_face")
        End If
        Dim bends As Object = Collection(New Object() {cd.Bends.Item(1)})
        If action = "unfold" Then
            Return cd.Features.UnfoldFeatures.Add(face, bends)
        End If
        Return cd.Features.RefoldFeatures.Add(face, bends)
    End If
    If action = "cut" Then
        Dim definition As Object = cd.Features.CutFeatures.CreateCutDefinition(Profile(G(parameters, "profile", "last")))
        definition.SetThroughAllExtent(20994)
        Return cd.Features.CutFeatures.Add(definition)
    End If
    If action = "corner_round" Then
        Dim edges As New List(Of Object)()
        For Each corner As Object In parameters("corners")
            edges.Add(SelectGeometry(New Dictionary(Of String, Object) From {{"edge", New Dictionary(Of String, Object) From {{"through", corner}, {"dir", "Z"}}}}))
        Next
        Dim definition As Object = cd.Features.CornerRoundFeatures.CreateCornerRoundDefinition(Collection(edges, "Edge"), CDbl(parameters("r"))/10)
        Return cd.Features.CornerRoundFeatures.Add(definition)
    End If
    If action = "base_flange" OrElse action = "face" OrElse action = "contour_flange" Then
        If action <> "face" AndAlso parameters.ContainsKey("thickness") Then
            Try
            Dim style As Object = cd.ActiveSheetMetalStyle.Copy("FixtureRule")
            Try
                style.Thickness = CStr(parameters("thickness")) & " mm"
            Catch When Legacy()
                ' Some 2016 documents refuse this; cd.Thickness below sets the thickness for the part anyway.
            End Try
            style.BendRadius = CStr(G(parameters, "bend_radius", 1)) & " mm"
            style.CornerReliefShape = Relief(CStr(G(parameters, "corner_relief", "round")))
            style.CornerReliefSize = CStr(G(parameters, "corner_relief_size", 4)) & " mm"
            style.GapSize = CStr(G(parameters, "corner_gap", 0.5)) & " mm"
            style.UnfoldMethod = cd.UnfoldMethods.AddLinearUnfoldMethod("FixtureUnfold", CStr(G(parameters, "k_factor", 0.44)))
            style.Activate()
            Catch When Legacy() AndAlso action = "contour_flange"
                ' This 2016 document refuses edits to the copied style; the contour flange definition carries its own bend radius.
            End Try
        End If
        If parameters.ContainsKey("thickness") Then
            cd.UseSheetMetalStyleThickness = False
            cd.Thickness.Expression = CStr(parameters("thickness")) & " mm"
            smThickness = CDbl(parameters("thickness"))
        End If
        If action = "contour_flange" Then
            Dim contourPath As Object = cd.Features.CreateSpecifiedPath(SketchCurves(sk))
            If CStr(G(parameters, "extent", "distance")) = "edge" Then
                Return ContourOnEdge(contourPath, parameters("edge"))
            End If
            Dim contourDefinition As Object = cd.Features.ContourFlangeFeatures.CreateContourFlangeDefinition(contourPath)
            If Legacy() AndAlso parameters.ContainsKey("bend_radius") Then
                contourDefinition.BendRadius = CDbl(parameters("bend_radius"))/10
            End If
            contourDefinition.SetDistanceExtent(CDbl(parameters("width"))/10, 20993)
            Return cd.Features.ContourFlangeFeatures.Add(contourDefinition)
        End If
        Dim definition As Object = cd.Features.FaceFeatures.CreateFaceFeatureDefinition(Profile(G(parameters, "profile", "last")))
        Dim desired As String = CStr(G(parameters, "direction", "+Z"))
        Dim normal As Object = sk.PlanarEntityGeometry.Normal
        Dim components As Double() = {normal.X, normal.Y, normal.Z}
        Dim component As Double = components("XYZ".IndexOf(desired.Substring(desired.Length-1)))
        If Math.Abs(component) < 0.999999 Then
            Throw New NotSupportedException("sheetmetal face direction must be normal to its sketch")
        End If
        definition.Direction = If(component * If(desired.StartsWith("-"), -1, 1) > 0, 20993, 20994)
        Return cd.Features.FaceFeatures.Add(definition)
    End If
    If action = "flange" Then
        Dim edges As New List(Of Object)()
        For Each selector As Object In parameters("edges")
            edges.Add(SelectGeometry(selector))
        Next
        Dim definition As Object = cd.Features.FlangeFeatures.CreateFlangeDefinition(Collection(edges, "Edge"), CStr(parameters("angle")) & " deg", CDbl(parameters("height"))/10)
        If CStr(G(parameters, "direction", "+Z")) <> "+Z" Then
            Throw New NotSupportedException("sheetmetal flange direction override: native adapter not implemented")
        End If
        If parameters.ContainsKey("bend_radius") Then
            definition.BendRadius = CDbl(parameters("bend_radius"))/10
        End If
        If parameters.ContainsKey("corner_relief") Then
            Dim corners As Object = definition.CornerOptions
            corners.CornerReliefShape = Relief(CStr(parameters("corner_relief")))
            corners.CornerReliefSize = CDbl(parameters("corner_relief_size"))/10
            definition.CornerOptions = corners
        End If
        If parameters.ContainsKey("corner_gap") Then
            definition.MiterGap = CDbl(parameters("corner_gap"))/10
        End If
        FlangeOverrides(definition, parameters)
        Dim result As Object = cd.Features.FlangeFeatures.Add(definition)
        refs("flange") = result
        Return result
    End If
    If action = "hem" Then
        Return BuildHem(parameters)
    End If
    cd.Unfold()
    cd.FlatPattern.ExitEdit()
    Return cd.FlatPattern
End Function

Function BuildAssembly(o As Object) As Object
    If o.ContainsKey("insert") Then
        Dim insert As Object = o("insert")
        If insert.ContainsKey("file") Then
            Throw New NotSupportedException("assembly external files: supply a generated recipe reference for privacy")
        End If
        Dim target As String = Path.Combine(outputRoot, CStr(insert("recipe")) & ".ipt")
        If Not File.Exists(target) Then
            Throw New NotSupportedException("assembly dependency unavailable: " & CStr(insert("recipe")))
        End If
        Dim matrix As Object = tg.CreateMatrix()
        Dim at As Object = G(insert, "at", New Double() {0,0,0})
        If TypeOf at Is String Then
            at = If(CStr(at) = "off_to_side_default", New Double() {70,0,0}, New Double() {0,0,0})
        End If
        matrix.SetTranslation(tg.CreateVector(CDbl(at(0))/10, CDbl(at(1))/10, CDbl(at(2))/10), False)
        Dim occurrence As Object = cd.Occurrences.Add(target, matrix)
        occurrence.Grounded = CBool(G(insert, "grounded", False))
        refs(CStr(G(insert, "name", insert("recipe")))) = occurrence
        refs(CStr(insert("recipe"))) = occurrence
        Return occurrence
    End If
    If o.ContainsKey("constraint") Then
        Dim constraint As Object = o("constraint")
        Dim a As Object = SelectGeometry(constraint("a"))
        Dim b As Object = SelectGeometry(constraint("b"))
        Dim offset As Double = CDbl(G(constraint, "offset", 0))/10
        If Legacy() Then
            Return LegacyConstraint(constraint, a, b, offset)
        End If
        Select Case CStr(constraint("type"))
            Case "mate"
                Return cd.Constraints.AddMateConstraint(a, b, offset)
            Case "flush"
                Return cd.Constraints.AddFlushConstraint(a, b, offset)
            Case "insert"
                Return cd.Constraints.AddInsertConstraint(a, b, CBool(G(constraint, "axes_opposed", True)), offset)
            Case "angle"
                Return cd.Constraints.AddAngleConstraint(a, b, CStr(constraint("angle")) & " deg")
            Case "tangent"
                Return cd.Constraints.AddTangentConstraint(a, b, CStr(G(constraint, "solution", "outside")) = "inside", offset)
            Case Else
                Throw New NotSupportedException("assembly constraint " & CStr(constraint("type")))
        End Select
    End If
    If o.ContainsKey("pattern") Then
        Dim pattern As Object = o("pattern")
        Dim d1 As Object = pattern("dir1")
        If pattern.ContainsKey("dir2") Then
            Dim d2 As Object = pattern("dir2")
            Return cd.OccurrencePatterns.AddRectangularPattern(Collection(New Object() {Reference(pattern("component"))}), Axis(CStr(d1("axis"))), Not CBool(G(d1, "flip", False)), CDbl(d1("spacing"))/10, d1("count"), Axis(CStr(d2("axis"))), Not CBool(G(d2, "flip", False)), CDbl(d2("spacing"))/10, d2("count"))
        End If
        Return cd.OccurrencePatterns.AddRectangularPattern(Collection(New Object() {Reference(pattern("component"))}), Axis(CStr(d1("axis"))), Not CBool(G(d1, "flip", False)), CDbl(d1("spacing"))/10, d1("count"))
    End If
    If o.ContainsKey("component") Then
        Dim occurrence As Object = Reference(o("component"))
        If o.ContainsKey("grounded") Then
            occurrence.Grounded = o("grounded")
        End If
        If o.ContainsKey("visible") Then
            occurrence.Visible = o("visible")
        End If
        If o.ContainsKey("suppressed") Then
            If CBool(o("suppressed")) Then
                occurrence.Suppress()
            Else
                occurrence.Unsuppress()
            End If
        End If
        Return occurrence
    End If
    Throw New NotSupportedException("assembly action: native adapter not implemented")
End Function

Sub BuildOp(o As Object)
    CheckClock()
    Dim f As Object = cd.Features
    Dim result As Object = Nothing
    Dim operation As Integer = 20481
    Select Case CStr(G(o, "op", "join"))
        Case "new"
            operation = 20485
        Case "cut"
            operation = 20482
        Case "intersect"
            operation = 20483
    End Select
    Dim direction As Integer = 20993
    If CStr(G(o, "direction", "+")) = "-" Then
        direction = 20994
    ElseIf CStr(G(o, "direction", "+")) = "sym" Then
        direction = 20995
    End If
    If CStr(o("type")) = "hole" AndAlso Not o.ContainsKey("direction") Then
        ' Inventor 2016-2021 take the hole direction along the sketch normal of the face; newer versions into the material.
        direction = If(Legacy(), 20993, 20994)
    End If
    Select Case CStr(o("type"))
        Case "app_specific"
            Dim app_specific_parameters As Object = o("params")
            Select Case CStr(o("op"))
                Case "work_plane"
                    result = Plane(New Dictionary(Of String, Object) From {{"base", app_specific_parameters("plane")}, {"offset", app_specific_parameters("offset")}})
                Case "split"
                    ' a named surface: its WorkSurface is the last one in the part
                    Dim splitTool As Object = If(TypeOf app_specific_parameters("tool") Is String AndAlso surfaceNames.Contains(CStr(app_specific_parameters("tool"))), cd.WorkSurfaces.Item(cd.WorkSurfaces.Count), Plane(app_specific_parameters("tool")))
                    If CStr(app_specific_parameters("method")) = "face" Then
                        Dim faces As New List(Of Object)()
                        For Each selector As Object In app_specific_parameters("faces")
                            faces.Add(SelectGeometry(selector))
                        Next
                        result = f.SplitFeatures.SplitFaces(splitTool, False, Collection(faces))
                    Else
                        Dim solids As New List(Of Object)()
                        For splitIndex As Integer = 1 To cd.SurfaceBodies.Count
                            If cd.SurfaceBodies.Item(splitIndex).IsSolid Then
                                solids.Add(cd.SurfaceBodies.Item(splitIndex))
                            End If
                        Next
                        If solids.Count <> 1 Then
                            Throw New NotSupportedException("split body selection requires exactly one solid")
                        End If
                        If CStr(app_specific_parameters("method")) = "solid" Then
                            result = f.SplitFeatures.SplitBody(splitTool, solids(0))
                        Else
                            Dim positive As Boolean = CStr(app_specific_parameters("remove")).StartsWith("+")
                            If CStr(G(app_specific_parameters("tool"), "base", "")) = "XZ" Then
                                positive = Not positive
                            End If
                            result = f.SplitFeatures.TrimSolid(splitTool, solids(0), positive)
                            If TrimLeftWrongSide(app_specific_parameters) Then
                                ' The side flag means the other side on this Inventor: redo the trim the other way round.
                                result.Delete()
                                For splitIndex As Integer = 1 To cd.SurfaceBodies.Count
                                    If cd.SurfaceBodies.Item(splitIndex).IsSolid Then
                                        result = f.SplitFeatures.TrimSolid(splitTool, cd.SurfaceBodies.Item(splitIndex), Not positive)
                                        Exit For
                                    End If
                                Next
                            End If
                        End If
                    End If
                    If TypeOf app_specific_parameters("tool") Is String AndAlso surfaceNames.Contains(CStr(app_specific_parameters("tool"))) Then
                        splitTool.Visible = False ' the surface is only the tool: the export keeps just the split solids
                    End If
                Case "appearance"
                    result = BuildAppearance(app_specific_parameters)
                Case "model_state"
                    If CInt(app.SoftwareVersion.Major) < 26 Then
                        Throw New NotSupportedException("needs Inventor 2022+; model states do not exist before 2022")
                    End If
                    Dim primary As Object = cd.ModelStates.Item(1)
                    result = cd.ModelStates.Add(app_specific_parameters("name"))
                    result.Activate()
                    For Each suppressed As Object In app_specific_parameters("suppress")
                        Reference(suppressed).Suppress()
                    Next
                    If CStr(app_specific_parameters("active")) = "master" Then
                        primary.Activate()
                    End If
                Case "view_representation"
                    Dim manager As Object = cd.RepresentationsManager
                    Dim initial As Object = manager.ActiveDesignViewRepresentation
                    result = manager.DesignViewRepresentations.Add(app_specific_parameters("name"))
                    result.Activate()
                    For Each hidden As Object In app_specific_parameters("hide")
                        Reference(hidden).Visible = False
                    Next
                    If CStr(app_specific_parameters("active")) = "Default" Then
                        initial.Activate()
                    End If
                Case "interpolation_spline_sketch"
                    result = cd.Sketches.Add(Plane(G(app_specific_parameters, "plane", "XY")))
                    sk = result
                    Dim fitPoints As New List(Of Object)()
                    For Each fit As Object In app_specific_parameters("points")
                        fitPoints.Add(P2(fit))
                    Next
                    Dim spline As Object = result.SketchSplines.Add(Collection(fitPoints))
                    spline.Closed = CBool(G(app_specific_parameters, "closed", False))
                    If CBool(G(app_specific_parameters, "dims", True)) Then
                        result.GeometricConstraints.AddGround(spline)
                    End If
                    lastProfile = result
                Case "sketch3d"
                    result = cd.Sketches3D.Add()
                    Dim firstLine As Object = Nothing
                    For Each entity3D As Object In app_specific_parameters("entities")
                        Dim line3D As Object = result.SketchLines3D.AddByTwoPoints(P3(entity3D("a")), P3(entity3D("b")))
                        If CBool(G(app_specific_parameters, "dims", True)) Then
                            result.GeometricConstraints3D.AddGround(line3D)
                        End If
                        If firstLine Is Nothing Then
                            firstLine = line3D
                        End If
                    Next
                    refs(CStr(app_specific_parameters("name"))) = result
                    refs(CStr(app_specific_parameters("name")) & ".path") = firstLine
                Case "coil"
                    Dim coilAxis As Object = app_specific_parameters("axis")
                    If TypeOf coilAxis Is String Then
                        coilAxis = Axis(CStr(coilAxis))
                    Else
                        coilAxis = sk.SketchLines.AddByTwoPoints(P2(coilAxis("line")(0)), P2(coilAxis("line")(1)))
                        coilAxis.Construction = True
                    End If
                    Dim coilProfile As Object = Profile("last")
                    Dim reversed As Boolean = CStr(G(app_specific_parameters, "direction", "+")) = "-"
                    Dim clockwise As Boolean = CStr(G(app_specific_parameters, "rotation", "default")) <> "default"
                    Select Case CStr(app_specific_parameters("size_type"))
                        Case "pitch_revolution"
                            result = f.CoilFeatures.AddByPitchAndRevolution(coilProfile, coilAxis, CDbl(app_specific_parameters("pitch"))/10, CDbl(app_specific_parameters("revolutions")), 20481, reversed, clockwise)
                        Case "revolution_height"
                            result = f.CoilFeatures.AddByRevolutionAndHeight(coilProfile, coilAxis, CDbl(app_specific_parameters("revolutions")), CDbl(app_specific_parameters("height"))/10, 20481, reversed, clockwise)
                        Case "pitch_height"
                            result = f.CoilFeatures.AddByPitchAndHeight(coilProfile, coilAxis, CDbl(app_specific_parameters("pitch"))/10, CDbl(app_specific_parameters("height"))/10, 20481, reversed, clockwise)
                        Case "spiral"
                            result = f.CoilFeatures.AddSpiral(coilProfile, coilAxis, CDbl(app_specific_parameters("pitch"))/10, CDbl(app_specific_parameters("revolutions")), 20481, reversed, clockwise)
                    End Select
                Case "parameter"
                    result = cd.Parameters.UserParameters.AddByExpression(app_specific_parameters("name"), CStr(app_specific_parameters("value")) & " " & CStr(G(app_specific_parameters, "units", "mm")), G(app_specific_parameters, "units", "mm"))
                Case "mirror"
                    Dim app_specific_features As New List(Of Object)()
                    For Each app_specific_value As Object In app_specific_parameters("features")
                        app_specific_features.Add(Reference(app_specific_value))
                    Next
                    result = cd.Features.MirrorFeatures.Add(Collection(app_specific_features), Plane(app_specific_parameters("plane")), False, 47361)
            End Select
        Case "sheetmetal"
            result = BuildSheetMetal(o)
        Case "assembly"
            result = BuildAssembly(o)
        Case "sketch"
            Dim sketch_plane As Object
            If o.ContainsKey("on_face") Then
                sketch_plane = SelectGeometry(o("on_face"))
            Else
                sketch_plane = Me.Plane(G(o, "plane", "XY"))
            End If
            sk = cd.Sketches.Add(sketch_plane)
            joints = New List(Of Object)()
            projected = New List(Of Object)()
            Dim filletLines As New List(Of Object)()
            If o.ContainsKey("project") Then
                For Each sketch_selector As Object In o("project")
                    NoteProjected(sk.AddByProjectingEntity(SelectGeometry(sketch_selector)))
                Next
            End If
            For Each sketch_entity As Object In o("entities")
                Select Case CStr(sketch_entity("type"))
                    Case "rect_center", "rect_2pt"
                        Dim sketch_a As Double()
                        Dim sketch_b As Double()
                        If CStr(sketch_entity("type")) = "rect_center" Then
                            Dim sketch_c As Double() = Local2(sketch_entity("c"))
                            Dim sketch_w As Double = CDbl(sketch_entity("w"))/2
                            Dim sketch_h As Double = CDbl(sketch_entity("h"))/2
                            sketch_a = New Double() {sketch_c(0)-sketch_w, sketch_c(1)-sketch_h}
                            sketch_b = New Double() {sketch_c(0)+sketch_w, sketch_c(1)+sketch_h}
                        Else
                            sketch_a = Local2(sketch_entity("p1"))
                            sketch_b = Local2(sketch_entity("p2"))
                        End If
                        Dim sketch_lines As Object = sk.SketchLines.AddAsTwoPointRectangle(P2(sketch_a), P2(sketch_b))
                        For sketch_i As Integer = 1 To sketch_lines.Count
                            filletLines.Add(sketch_lines.Item(sketch_i))
                        Next
                        If CBool(G(o, "dims", True)) Then
                            Dim sketch_width As Object = sk.DimensionConstraints.AddTwoPointDistance(sketch_lines.Item(1).StartSketchPoint, sketch_lines.Item(1).EndSketchPoint, 19201, P2(New Double() {sketch_a(0), sketch_a(1)-5}))
                            If o.ContainsKey("width_expression") Then
                                sketch_width.Parameter.Expression = o("width_expression")
                            End If
                            sk.DimensionConstraints.AddTwoPointDistance(sketch_lines.Item(2).StartSketchPoint, sketch_lines.Item(2).EndSketchPoint, 19202, P2(New Double() {sketch_b(0)+5, sketch_a(1)}))
                            sk.GeometricConstraints.AddGround(sketch_lines.Item(1).StartSketchPoint)
                        End If
                    Case "circle"
                        Dim sketch_circle As Object = sk.SketchCircles.AddByCenterRadius(P2(sketch_entity("c")), CDbl(sketch_entity("r"))/10)
                        If CBool(G(o, "dims", True)) Then
                            sk.DimensionConstraints.AddDiameter(sketch_circle, P2(sketch_entity("c")))
                            sk.GeometricConstraints.AddGround(sketch_circle.CenterSketchPoint)
                        End If
                    Case "line"
                        ' 2016-2021 do not join a new line to an existing endpoint at the same place, so the outline stays
                        ' open and cannot become a profile: reuse that SketchPoint (JoinPoint is plain P2 on newer versions).
                        Dim sketch_line As Object = sk.SketchLines.AddByTwoPoints(JoinPoint(sketch_entity("a")), JoinPoint(sketch_entity("b")))
                        RememberPoints(sketch_line.StartSketchPoint, sketch_line.EndSketchPoint, Nothing)
                        filletLines.Add(sketch_line)
                        sketch_line.Construction = CBool(G(sketch_entity, "construction", False))
                        If CBool(G(o, "dims", True)) AndAlso Not (Legacy() AndAlso openPathSketches.Contains(opIndex)) Then
                            Try
                                sk.DimensionConstraints.AddTwoPointDistance(sketch_line.StartSketchPoint, sketch_line.EndSketchPoint, 19203, P2(sketch_entity("a")))
                                If Not o.ContainsKey("project") Then
                                    sk.GeometricConstraints.AddGround(sketch_line.StartSketchPoint)
                                End If
                            Catch ex As Exception When Legacy()
                                ' A joined outline can already be fully constrained; on 2016-2021 a refused dimension is not an error.
                            End Try
                        End If
                        TouchProjected(sketch_line.StartSketchPoint)
                        TouchProjected(sketch_line.EndSketchPoint)
                    Case "arc"
                        Dim sketch_arc As Object
                        If sketch_entity.ContainsKey("through") Then
                            sketch_arc = sk.SketchArcs.AddByThreePoints(JoinPoint(sketch_entity("a")), P2(sketch_entity("through")), JoinPoint(sketch_entity("b")))
                        ElseIf sketch_entity.ContainsKey("a") Then
                            sketch_arc = sk.SketchArcs.AddByCenterStartEndPoint(P2(sketch_entity("c")), JoinPoint(sketch_entity("a")), JoinPoint(sketch_entity("b")), CBool(G(sketch_entity, "counterclockwise", True)))
                        Else
                            Dim sketch_c As Double() = Local2(G(sketch_entity, "c", G(sketch_entity, "centre", Nothing)))
                            Dim sketch_radius As Double = CDbl(sketch_entity("r"))
                            Dim sketch_angleA As Double = CDbl(sketch_entity("start_angle"))*Math.PI/180
                            Dim sketch_angleB As Double = CDbl(sketch_entity("end_angle"))*Math.PI/180
                            sketch_arc = sk.SketchArcs.AddByCenterStartEndPoint(P2(sketch_c), P2(New Double() {sketch_c(0)+sketch_radius*Math.Cos(sketch_angleA), sketch_c(1)+sketch_radius*Math.Sin(sketch_angleA)}), P2(New Double() {sketch_c(0)+sketch_radius*Math.Cos(sketch_angleB), sketch_c(1)+sketch_radius*Math.Sin(sketch_angleB)}), CBool(G(sketch_entity, "counterclockwise", True)))
                        End If
                        RememberPoints(sketch_arc.StartSketchPoint, sketch_arc.EndSketchPoint, Nothing)
                        If CBool(G(o, "dims", True)) Then
                            Try
                                sk.DimensionConstraints.AddRadius(sketch_arc, P2(G(sketch_entity, "a", G(sketch_entity, "c", G(sketch_entity, "centre", Nothing)))))
                                sk.GeometricConstraints.AddGround(sketch_arc.CenterSketchPoint)
                            Catch ex As Exception When Legacy()
                                ' Joined to its neighbors the arc can already be constrained; not an error on 2016-2021.
                            End Try
                        End If
                        TouchProjected(sketch_arc.StartSketchPoint)
                        TouchProjected(sketch_arc.EndSketchPoint)
                    Case "point"
                        sk.SketchPoints.Add(P2(sketch_entity("p")), True)
                End Select
            Next
            For Each corner As Object In G(o, "fillets", New Object() {})
                SketchFillet(corner, filletLines)
            Next
            lastProfile = sk
            result = sk
            If o.ContainsKey("name") Then
                refs(CStr(o("name")) & ".profile") = sk
            End If
        Case "extrude"
            If o.ContainsKey("axis") AndAlso direction <> 20995 Then
                Dim extrude_normal As Object = sk.PlanarEntityGeometry.Normal
                Dim extrude_components As Double() = {extrude_normal.X, extrude_normal.Y, extrude_normal.Z}
                If extrude_components("XYZ".IndexOf(CStr(o("axis")))) < 0 Then
                    direction = If(direction = 20993, 20994, 20993)
                End If
            End If
            For extrude_try As Integer = 1 To 2
            Try
            Dim extrude_surface As Boolean = CBool(G(o, "surface", False))
            ' 20484 = kSurfaceOperation: the open path of the last sketch becomes a surface profile
            Dim extrude_definition As Object = f.ExtrudeFeatures.CreateExtrudeDefinition(If(extrude_surface, lastProfile.Profiles.AddForSurface(), Profile(G(o, "profile", "last"))), If(extrude_surface, 20484, operation))
            If CStr(G(o, "extent", "distance")) = "through_all" Then
                extrude_definition.SetThroughAllExtent(direction)
            ElseIf CStr(G(o, "extent", "distance")) = "to_face" Then
                Dim target As Object
                If o.ContainsKey("to_face") Then
                    target = SelectGeometry(o("to_face"))
                Else
                    target = Plane(o("to_plane"))
                End If
                extrude_definition.SetToExtent(target, False)
            ElseIf CStr(G(o, "extent", "distance")) = "between" Then
                extrude_definition.SetFromToExtent(Plane(o("from_plane")), False, Plane(o("to_plane")), False)
            ElseIf CStr(G(o, "direction", "+")) = "two_sides" Then
                extrude_definition.SetDistanceExtent(CDbl(o("distance"))/10, 20993)
                extrude_definition.SetDistanceExtentTwo(CDbl(o("distance2"))/10)
            Else
                extrude_definition.SetDistanceExtent(G(o, "distance_expression", CDbl(o("distance"))/10), direction)
            End If
            If o.ContainsKey("taper") Then
                extrude_definition.TaperAngle = CStr(o("taper")) & " deg"
            End If
            result = f.ExtrudeFeatures.Add(extrude_definition)
            Exit For
            Catch When Legacy() AndAlso extrude_try = 1 AndAlso sk IsNot Nothing AndAlso sk.DimensionConstraints.Count > 0
                ' 2016-2021 refuse to extrude a polyline outline that has a dimension on every line (E_FAIL): take the
                ' dimensions off and extrude it again.
                Do While sk.DimensionConstraints.Count > 0
                    sk.DimensionConstraints.Item(1).Delete()
                Loop
            End Try
            Next
        Case "revolve"
            result = f.RevolveFeatures.AddByAngle(Profile(G(o, "profile", "last")), Axis(CStr(G(o, "axis", "Z"))), CStr(G(o, "angle", 360)) & " deg", direction, operation)
        Case "hole"
            Dim hole_face As Object = SelectGeometry(G(o, "face", G(o, "on_face", Nothing)))
            Dim hole_holeSketch As Object = cd.Sketches.Add(hole_face)
            Dim hole_points As New List(Of Object)()
            Dim hole_locations As Object() = If(TypeOf o("at")(0) Is Object(), o("at"), New Object() {o("at")})
            For Each hole_at As Object In hole_locations
                hole_points.Add(hole_holeSketch.SketchPoints.Add(hole_holeSketch.ModelToSketchSpace(P3(hole_at)), True))
            Next
            Dim hole_placement As Object = f.HoleFeatures.CreateSketchPlacementDefinition(Collection(hole_points))
            Dim hole_diameter As Double = CDbl(o("dia"))/10
            Dim hole_subtype As String = CStr(G(o, "hole_type", G(o, "kind", "simple")))
            ' Inventor 2016 takes the hole direction against the sketch normal on some faces: a hole that removed nothing is
            ' deleted and made again the other way round.
            For hole_attempt As Integer = 1 To 2
            Dim hole_before As Double = BodiesVolume()
            If hole_attempt = 2 Then
                result.Delete()
                direction = If(direction = 20993, 20994, 20993)
                hole_face = SelectGeometry(G(o, "face", G(o, "on_face", Nothing)))   ' the deleted hole invalidated the old face
                hole_holeSketch = cd.Sketches.Add(hole_face)
                hole_points.Clear()
                For Each hole_at As Object In hole_locations
                    hole_points.Add(hole_holeSketch.SketchPoints.Add(hole_holeSketch.ModelToSketchSpace(P3(hole_at)), True))
                Next
                hole_placement = f.HoleFeatures.CreateSketchPlacementDefinition(Collection(hole_points))
            End If
            If CBool(G(o, "through_all", False)) Then
                Select Case hole_subtype
                    Case "simple"
                        result = f.HoleFeatures.AddDrilledByThroughAllExtent(hole_placement, hole_diameter, direction)
                    Case "counterbore"
                        result = f.HoleFeatures.AddCBoreByThroughAllExtent(hole_placement, hole_diameter, direction, CDbl(o("cb_dia"))/10, CDbl(o("cb_depth"))/10)
                    Case "countersink"
                        result = f.HoleFeatures.AddCSinkByThroughAllExtent(hole_placement, hole_diameter, direction, CDbl(o("cs_dia"))/10, CStr(o("cs_angle")) & " deg")
                End Select
            Else
                Dim hole_depth As Double = CDbl(o("depth"))/10
                Dim hole_flat As Boolean = CStr(G(o, "tip", "angle")) = "flat"
                Dim hole_tipAngle As String = CStr(G(o, "tip_angle", 118)) & " deg"
                Select Case hole_subtype
                    Case "simple"
                        result = f.HoleFeatures.AddDrilledByDistanceExtent(hole_placement, hole_diameter, hole_depth, direction, hole_flat, hole_tipAngle)
                    Case "counterbore"
                        result = f.HoleFeatures.AddCBoreByDistanceExtent(hole_placement, hole_diameter, hole_depth, direction, CDbl(o("cb_dia"))/10, CDbl(o("cb_depth"))/10, hole_flat, hole_tipAngle)
                    Case "countersink"
                        result = f.HoleFeatures.AddCSinkByDistanceExtent(hole_placement, hole_diameter, hole_depth, direction, CDbl(o("cs_dia"))/10, CStr(o("cs_angle")) & " deg", hole_flat, hole_tipAngle)
                End Select
            End If
            If Not Legacy() OrElse Math.Abs(BodiesVolume() - hole_before) > 0.000001 Then
                Exit For
            End If
            Next
        Case "fillet"
            Dim fillet_edges As New List(Of Object)()
            For Each fillet_selector As Object In o("edges")
                fillet_edges.Add(SelectGeometry(fillet_selector))
            Next
            result = f.FilletFeatures.AddSimple(Collection(fillet_edges, "Edge"), CDbl(o("r"))/10)
        Case "fillet_variable"
            Dim fillet_variable_edge As Object = SelectGeometry(o("edge"))
            If fillet_variable_edge.StartVertex Is Nothing OrElse fillet_variable_edge.StopVertex Is Nothing Then
                Throw New NotSupportedException("variable fillet requires an open edge with endpoints")
            End If
            Dim fillet_variable_first As Object = o("r_start")
            Dim fillet_variable_final As Object = o("r_end")
            If fillet_variable_edge.StartVertex.Point.DistanceTo(P3(fillet_variable_first("at"))) > 0.00001 Then
                Dim fillet_variable_swap As Object = fillet_variable_first
                fillet_variable_first = fillet_variable_final
                fillet_variable_final = fillet_variable_swap
            End If
            If fillet_variable_edge.StartVertex.Point.DistanceTo(P3(fillet_variable_first("at"))) > 0.00001 OrElse fillet_variable_edge.StopVertex.Point.DistanceTo(P3(fillet_variable_final("at"))) > 0.00001 Then
                Throw New NotSupportedException("variable fillet radius locations must be the selected edge endpoints")
            End If
            Dim fillet_variable_definition As Object = f.FilletFeatures.CreateFilletDefinition()
            fillet_variable_definition.AddVariableRadiusEdgeSet(Collection(New Object() {fillet_variable_edge}, "Edge"), CDbl(fillet_variable_first("r"))/10, CDbl(fillet_variable_final("r"))/10)
            result = f.FilletFeatures.Add(fillet_variable_definition)
        Case "chamfer"
            Dim chamfer_edge As Object = SelectGeometry(o("edge"))
            Dim chamfer_edges As Object = Collection(New Object() {chamfer_edge}, "Edge")
            Dim chamfer_mode As String = CStr(G(o, "mode", "distance"))
            If chamfer_mode = "distance" Then
                result = f.ChamferFeatures.AddUsingDistance(chamfer_edges, CDbl(o("d1"))/10)
            Else
                Dim chamfer_face As Object = chamfer_edge.Faces.Item(1)
                If o.ContainsKey("ref_face") Then
                    chamfer_face = SelectGeometry(o("ref_face"))
                End If
                If CBool(G(o, "flip", False)) Then
                    If chamfer_edge.Faces.Count <> 2 Then
                        Throw New Exception("Chamfer flip requires exactly two adjacent faces")
                    End If
                    chamfer_face = If(chamfer_edge.Faces.Item(1) Is chamfer_face, chamfer_edge.Faces.Item(2), chamfer_edge.Faces.Item(1))
                End If
                If chamfer_mode = "two_distances" Then
                    result = f.ChamferFeatures.AddUsingTwoDistances(chamfer_edges, chamfer_face, CDbl(o("d1"))/10, CDbl(o("d2"))/10)
                ElseIf chamfer_mode = "distance_angle" Then
                    result = f.ChamferFeatures.AddUsingDistanceAndAngle(chamfer_edges, chamfer_face, CDbl(o("d1"))/10, CStr(o("angle")) & " deg")
                Else
                    Throw New NotSupportedException("chamfer mode " & chamfer_mode)
                End If
            End If
        Case "pattern_rect"
            Dim pattern_rect_d As Object = o("dir1")
            Dim pattern_rect_features As Object = Collection(New Object() {Reference(G(o, "feature", "last"))})
            If Legacy() Then
                result = LegacyRectPattern(pattern_rect_features, o)
            Else
                Dim pattern_rect_definition As Object = f.RectangularPatternFeatures.CreateDefinition(pattern_rect_features, Axis(CStr(pattern_rect_d("axis"))), Not CBool(G(pattern_rect_d, "flip", False)), pattern_rect_d("count"), CDbl(pattern_rect_d("spacing"))/10)
                If o.ContainsKey("dir2") Then
                    Dim pattern_rect_d2 As Object = o("dir2")
                    pattern_rect_definition.YDirectionEntity = Axis(CStr(pattern_rect_d2("axis")))
                    pattern_rect_definition.NaturalYDirection = Not CBool(G(pattern_rect_d2, "flip", False))
                    pattern_rect_definition.YCount = pattern_rect_d2("count")
                    pattern_rect_definition.YSpacing = CDbl(pattern_rect_d2("spacing"))/10
                End If
                result = f.RectangularPatternFeatures.AddByDefinition(pattern_rect_definition)
            End If
        Case "pattern_circ"
            If Legacy() Then
                result = LegacyCircPattern(Collection(New Object() {Reference(G(o, "feature", "last"))}), o)
            Else
                Dim pattern_circ_definition As Object = f.CircularPatternFeatures.CreateDefinition(Collection(New Object() {Reference(G(o, "feature", "last"))}), Axis(CStr(o("axis"))), True, o("count"), CStr(G(o, "angle", 360)) & " deg", True)
                result = f.CircularPatternFeatures.AddByDefinition(pattern_circ_definition)
            End If
        Case "shell"
            Dim shell_faces As New List(Of Object)()
            For Each shell_selector As Object In o("remove_faces")
                shell_faces.Add(SelectGeometry(shell_selector))
            Next
            Dim shell_shellDirection As Integer = 41217
            If CStr(G(o, "direction", "inside")) = "outside" Then
                shell_shellDirection = 41218
            ElseIf CStr(G(o, "direction", "inside")) = "both" Then
                shell_shellDirection = 41219
            End If
            Dim shell_definition As Object = f.ShellFeatures.CreateShellDefinition(Collection(shell_faces, "Face"), CDbl(o("thickness"))/10, shell_shellDirection)
            result = f.ShellFeatures.Add(shell_definition)
        Case "loft"
            Dim loft_profiles As New List(Of Object)()
            For Each loft_value As Object In o("profiles")
                loft_profiles.Add(Profile(loft_value))
            Next
            Dim loft_definition As Object = f.LoftFeatures.CreateLoftDefinition(Collection(loft_profiles), operation)
            result = f.LoftFeatures.Add(loft_definition)
        Case "sweep"
            Dim sweep_definition As Object = f.SweepFeatures.CreateSweepDefinition(104449, Profile(o("profile")), f.CreateSpecifiedPath(SketchCurves(Reference(o("path")))), operation)
            result = f.SweepFeatures.Add(sweep_definition)
        Case "thread"
            Dim thread_spec As Object = o("spec")
            If Not TypeOf thread_spec Is Dictionary(Of String, Object) Then
                Throw New NotSupportedException("thread.spec requires family, designation, class and internal")
            End If
            If Not thread_spec.ContainsKey("start_edge") Then
                Throw New NotSupportedException("thread.spec.start_edge geometric selector is required")
            End If
            Dim thread_info As Object = f.ThreadFeatures.CreateStandardThreadInfo(CBool(G(thread_spec, "internal", False)), CBool(G(thread_spec, "right_handed", True)), thread_spec("family"), thread_spec("designation"), G(thread_spec, "class", "6g"))
            result = f.ThreadFeatures.Add(SelectGeometry(o("face")), SelectGeometry(thread_spec("start_edge")), thread_info, CBool(G(thread_spec, "reversed", False)), CBool(G(thread_spec, "full_length", True)), CDbl(G(thread_spec, "length", 0))/10, CDbl(G(thread_spec, "offset", 0))/10)
        Case Else
            Throw New NotSupportedException(CStr(o("type")) & ": native adapter not implemented")
    End Select
    last = result
    refs(CStr(o("type"))) = result
    refs(CStr(opIndex)) = result
    opIndex += 1
    If o.ContainsKey("name") Then
        refs(CStr(o("name"))) = result
    End If
End Sub

Sub BlankProperties(doc As Object)
    Dim names As String = "|Author|Company|Manager|Last Saved By|Designer|Engineer|Checked By|Creator|"
    For i As Integer = 1 To doc.PropertySets.Count
        Dim props As Object = doc.PropertySets.Item(i)
        For j As Integer = 1 To props.Count
            Dim prop As Object = props.Item(j)
            If names.Contains("|" & CStr(prop.Name) & "|") Then
                Try
                    prop.Value = If(CStr(prop.Name) = "Author" OrElse CStr(prop.Name) = "Last Saved By", "Fixture Builder", "")
                Catch
                    If CStr(prop.Name) <> "Last Saved By" Then
                        Throw
                    End If
                End Try
            End If
        Next
    Next
End Sub

Sub ExportStep(doc As Object, target As String)
    Dim translator As Object = app.ApplicationAddIns.ItemById("{90AF7F40-0C01-11D5-8E83-0010B541CD80}")
    Dim context As Object = app.TransientObjects.CreateTranslationContext()
    context.Type = 13059
    Dim options As Object = app.TransientObjects.CreateNameValueMap()
    If Not translator.HasSaveCopyAsOptions(doc, context, options) Then
        Throw New Exception("STEP translator has no save options")
    End If
    options.Value("ApplicationProtocolType") = 3
    Dim medium As Object = app.TransientObjects.CreateDataMedium()
    medium.FileName = target
    translator.SaveCopyAs(doc, context, options, medium)
    SanitizeStep(target)
End Sub
Function StepFields(text As String) As List(Of String)
    ' the top-level comma separated fields of a STEP header entity's argument list (quotes and parentheses respected)
    Dim fields As New List(Of String)()
    Dim depth As Integer = 0
    Dim quoted As Boolean = False
    Dim start As Integer = 0
    For index As Integer = 0 To text.Length - 1
        Dim ch As Char = text(index)
        If ch = "'"c Then
            quoted = Not quoted
        ElseIf Not quoted AndAlso ch = "("c Then
            depth += 1
        ElseIf Not quoted AndAlso ch = ")"c Then
            depth -= 1
        ElseIf Not quoted AndAlso depth = 0 AndAlso ch = ","c Then
            fields.Add(text.Substring(start, index - start).Trim())
            start = index + 1
        End If
    Next
    fields.Add(text.Substring(start).Trim())
    Return fields
End Function
Sub SanitizeStep(target As String)
    ' the STEP header's FILE_NAME holds the full output path, the author and the organization: the bare file name, Fixture Builder for both
    ' and no authorization text, so a custom output folder never travels in the file
    Dim latin As System.Text.Encoding = System.Text.Encoding.GetEncoding(28591)
    Dim data As Byte() = File.ReadAllBytes(target)
    Dim head As String = latin.GetString(data, 0, Math.Min(data.Length, 131072))
    Dim found As Match = Regex.Match(head, "FILE_NAME\s*\((.*?)\)\s*;", RegexOptions.Singleline)
    If Not found.Success Then
        Return
    End If
    Dim fields As List(Of String) = StepFields(found.Groups(1).Value)
    If fields.Count < 4 Then
        Return
    End If
    fields(0) = "'" & Path.GetFileName(target).Replace("'", "") & "'"
    fields(2) = "('Fixture Builder')"
    fields(3) = "('Fixture Builder')"
    If fields.Count >= 7 Then
        fields(6) = "''"
    End If
    Dim entity As String = "FILE_NAME(" & String.Join(",", fields.ToArray()) & ");"
    Dim text As String = latin.GetString(data)
    File.WriteAllBytes(target, latin.GetBytes(text.Substring(0, found.Index) & entity & text.Substring(found.Index + found.Length)))
End Sub


' --- Inventor 2016 COM proxy (fixtures lead, 11-20) ---
' Inventor 2016's IDispatch refuses some calls the way VB's late binder makes them (DISP_E_MEMBERNOTFOUND on
' AddTwoPointDistance / AddGround); the same calls work through Type.InvokeMember. ComProxy is a DLR object that
' VB 10's late binder honors: it forwards each member access through InvokeMember, wraps returned COM objects
' (one proxy per COM object, so Is still compares identity) and unwraps arguments.
<System.Reflection.DefaultMember("Item")>
Public Class ComProxy
    Inherits System.Dynamic.DynamicObject
    Implements System.Collections.IEnumerable
    Public ReadOnly Target As Object
    Private Shared ReadOnly Cache As New System.Runtime.CompilerServices.ConditionalWeakTable(Of Object, ComProxy)()
    Private Sub New(ByVal target As Object)
        Me.Target = target
    End Sub
    Public Shared Function Wrap(ByVal value As Object) As Object
        If value Is Nothing OrElse TypeOf value Is ComProxy OrElse Not System.Runtime.InteropServices.Marshal.IsComObject(value) Then Return value
        Return Cache.GetValue(value, Function(v) New ComProxy(v))
    End Function
    Public Shared Function Unwrap(ByVal value As Object) As Object
        Dim p As ComProxy = TryCast(value, ComProxy)
        If p IsNot Nothing Then Return p.Target
        Dim arr As Object() = TryCast(value, Object())
        If arr IsNot Nothing Then
            Dim copy(arr.Length - 1) As Object
            For i As Integer = 0 To arr.Length - 1 : copy(i) = Unwrap(arr(i)) : Next
            Return copy
        End If
        Return value
    End Function
    Private Shared Function Args(ByVal values As Object()) As Object()
        Dim copy(values.Length - 1) As Object
        For i As Integer = 0 To values.Length - 1 : copy(i) = Unwrap(values(i)) : Next
        Return copy
    End Function
    Private Function CallMember(ByVal name As String, ByVal flags As System.Reflection.BindingFlags, ByVal values As Object()) As Object
        ' Output arguments (e.g. Evaluator.GetNormalAtPoint(coordinates, normals)) must go ByRef: pass Nothing and
        ' arrays by reference and copy what Inventor wrote back into the caller's argument array.
        Dim raw As Object() = Args(values)
        Dim modifiers As System.Reflection.ParameterModifier() = Nothing
        If raw.Length > 0 Then
            Dim m As New System.Reflection.ParameterModifier(raw.Length)
            Dim any As Boolean = False
            For i As Integer = 0 To raw.Length - 1
                If raw(i) Is Nothing OrElse TypeOf raw(i) Is Array OrElse TypeOf raw(i) Is System.Runtime.InteropServices.DispatchWrapper Then m(i) = True : any = True
            Next
            If any Then modifiers = New System.Reflection.ParameterModifier() {m}
        End If
        Dim result As Object = Target.GetType().InvokeMember(name, flags, Nothing, Target, raw, modifiers, Nothing, Nothing)
        If modifiers IsNot Nothing Then
            For i As Integer = 0 To raw.Length - 1
                If modifiers(0)(i) Then values(i) = Wrap(raw(i))
            Next
        End If
        Return Wrap(result)
    End Function
    Private Function CallEither(ByVal name As String, ByVal first As System.Reflection.BindingFlags, ByVal second As System.Reflection.BindingFlags, ByVal values As Object()) As Object
        ' Try the natural dispatch form, then the other one, then both: Inventor 2016 accepts different forms per member.
        Dim attempts As System.Reflection.BindingFlags() = {first, second, first Or second}
        Dim lastError As Exception = Nothing
        For Each flags As System.Reflection.BindingFlags In attempts
            Try
                Return CallMember(name, flags, values)
            Catch ex As System.Reflection.TargetInvocationException
                Dim com As System.Runtime.InteropServices.COMException = TryCast(ex.InnerException, System.Runtime.InteropServices.COMException)
                ' A real error from Inventor (not "member not found" / "bad parameter count") is the answer.
                If com Is Nothing OrElse (com.ErrorCode <> &H80020003 AndAlso com.ErrorCode <> &H8002000E) Then Throw ex.InnerException
                lastError = ex.InnerException
            Catch ex As System.Runtime.InteropServices.COMException
                If ex.ErrorCode <> &H80020003 AndAlso ex.ErrorCode <> &H8002000E Then Throw
                lastError = ex
            Catch ex As System.Reflection.TargetParameterCountException
                lastError = ex
            Catch ex As System.MissingMethodException
                lastError = ex
            Catch ex As System.MissingMemberException
                lastError = ex
            End Try
        Next
        Throw lastError
    End Function
    Public Overrides Function TryInvokeMember(ByVal binder As System.Dynamic.InvokeMemberBinder, ByVal values As Object(), ByRef result As Object) As Boolean
        result = CallEither(binder.Name, System.Reflection.BindingFlags.InvokeMethod, System.Reflection.BindingFlags.GetProperty, values)
        Return True
    End Function
    Public Overrides Function TryGetMember(ByVal binder As System.Dynamic.GetMemberBinder, ByRef result As Object) As Boolean
        ' VB's binder reads obj.Method before invoking it with arguments; a member that needs arguments
        ' comes back as a bound method that the following call invokes.
        If binder.Name = "AddForSolid" Then
            result = New BoundMethod(Me, binder.Name)
            Return True
        End If
        Try
            result = CallEither(binder.Name, System.Reflection.BindingFlags.GetProperty, System.Reflection.BindingFlags.InvokeMethod, New Object() {})
        Catch ex As System.Reflection.TargetParameterCountException
            result = New BoundMethod(Me, binder.Name)
        Catch ex As System.Runtime.InteropServices.COMException When ex.ErrorCode = &H8002000E OrElse ex.ErrorCode = &H80020003
            result = New BoundMethod(Me, binder.Name)
        End Try
        Return True
    End Function
    Friend Sub SetNamed(ByVal name As String, ByVal values As Object())
        Try
            Target.GetType().InvokeMember(name, System.Reflection.BindingFlags.SetProperty, Nothing, Target, Args(values))
        Catch ex As System.Reflection.TargetInvocationException
            ' VB copies ByRef arguments back, e.g. GetTemplateFile(t) after Documents.Add(..., GetTemplateFile(t), ...)
            ' or CreatePath(x) after CreateSweepDefinition(..., CreatePath(x), ...). A member with no setter
            ' (DISP_E_MEMBERNOTFOUND on the put) is a method or read-only: that copy-back is never a real write.
            Dim com As System.Runtime.InteropServices.COMException = TryCast(ex.InnerException, System.Runtime.InteropServices.COMException)
            If com IsNot Nothing AndAlso com.ErrorCode = &H80020003 Then Return
            ' Otherwise, a copy-back of the value the member already returns is a no-op too.
            Dim keys(values.Length - 2) As Object
            Array.Copy(values, keys, values.Length - 1)
            Dim current As Object = Nothing
            Try
                current = Unwrap(InvokeNamed(name, keys))
            Catch
                Throw ex.InnerException
            End Try
            Dim wanted As Object = Unwrap(values(values.Length - 1))
            If current Is wanted OrElse (current IsNot Nothing AndAlso wanted IsNot Nothing AndAlso Not System.Runtime.InteropServices.Marshal.IsComObject(current) AndAlso current.Equals(wanted)) Then Return
            Throw ex.InnerException
        End Try
    End Sub
    Friend Function InvokeNamed(ByVal name As String, ByVal values As Object()) As Object
        Return CallEither(name, System.Reflection.BindingFlags.InvokeMethod, System.Reflection.BindingFlags.GetProperty, values)
    End Function
    Public Overrides Function TrySetMember(ByVal binder As System.Dynamic.SetMemberBinder, ByVal value As Object) As Boolean
        Dim raw As Object = Unwrap(value)
        Try
            Target.GetType().InvokeMember(binder.Name, System.Reflection.BindingFlags.SetProperty, Nothing, Target, New Object() {raw})
        Catch ex As System.Reflection.TargetInvocationException
            ' VB's late binder copies ByRef arguments back into the properties they were read from
            ' (obj.Call(x.ReadOnlyProp) writes x.ReadOnlyProp afterwards). Writing back the same value is a no-op.
            If SameAsCurrent(binder.Name, raw) Then Return True
            Throw ex.InnerException
        Catch ex As System.Runtime.InteropServices.COMException
            If SameAsCurrent(binder.Name, raw) Then Return True
            Throw
        End Try
        Return True
    End Function
    Private Function SameAsCurrent(ByVal name As String, ByVal raw As Object) As Boolean
        Try
            Dim current As Object = Target.GetType().InvokeMember(name, System.Reflection.BindingFlags.GetProperty, Nothing, Target, New Object() {})
            If current Is raw Then Return True
            If current IsNot Nothing AndAlso raw IsNot Nothing AndAlso Not System.Runtime.InteropServices.Marshal.IsComObject(current) Then Return current.Equals(raw)
        Catch
        End Try
        Return False
    End Function
    ' VB indexes a proxied collection (occurrences(1)) through a default member found by reflection.
    Default Public Property Item(ByVal index As Object) As Object
        Get
            Return CallEither("Item", System.Reflection.BindingFlags.GetProperty, System.Reflection.BindingFlags.InvokeMethod, New Object() {index})
        End Get
        Set(ByVal value As Object)
            SetNamed("Item", New Object() {index, value})
        End Set
    End Property
    Public Overrides Function TryGetIndex(ByVal binder As System.Dynamic.GetIndexBinder, ByVal indexes As Object(), ByRef result As Object) As Boolean
        result = CallEither("Item", System.Reflection.BindingFlags.GetProperty, System.Reflection.BindingFlags.InvokeMethod, indexes)
        Return True
    End Function
    Public Overrides Function TryInvoke(ByVal binder As System.Dynamic.InvokeBinder, ByVal values As Object(), ByRef result As Object) As Boolean
        result = CallEither("Item", System.Reflection.BindingFlags.GetProperty, System.Reflection.BindingFlags.InvokeMethod, values)
        Return True
    End Function
    Public Overrides Function TryConvert(ByVal binder As System.Dynamic.ConvertBinder, ByRef result As Object) As Boolean
        If binder.Type.IsInstanceOfType(Target) Then result = Target : Return True
        Return MyBase.TryConvert(binder, result)
    End Function
    Public Function GetEnumerator() As System.Collections.IEnumerator Implements System.Collections.IEnumerable.GetEnumerator
        Dim items As New System.Collections.Generic.List(Of Object)()
        For Each item As Object In CType(Target, System.Collections.IEnumerable)
            items.Add(Wrap(item))
        Next
        Return items.GetEnumerator()
    End Function
    Public Overrides Function ToString() As String
        Return Target.ToString()
    End Function
End Class

<System.Reflection.DefaultMember("Item")>
Public Class BoundMethod
    Inherits System.Dynamic.DynamicObject
    Private ReadOnly Owner As ComProxy
    Private ReadOnly Name As String
    Friend Sub New(ByVal owner As ComProxy, ByVal name As String)
        Me.Owner = owner : Me.Name = name
    End Sub
    ' VB applies a default member to obj.Method(args) by reflection: Item performs the call, and
    ' obj.Prop(key) = value (a parameterized COM property such as NameValueMap.Value) sets it.
    Default Public Property Item(ByVal a As Object) As Object
        Get
            Return Owner.InvokeNamed(Name, New Object() {a})
        End Get
        Set(ByVal value As Object)
            Owner.SetNamed(Name, New Object() {a, value})
        End Set
    End Property
    Default Public Property Item(ByVal a As Object, ByVal b As Object) As Object
        Get
            Return Owner.InvokeNamed(Name, New Object() {a, b})
        End Get
        Set(ByVal value As Object)
            Owner.SetNamed(Name, New Object() {a, b, value})
        End Set
    End Property
    Default Public ReadOnly Property Item(ByVal a As Object, ByVal b As Object, ByVal c As Object, ByVal ParamArray rest As Object()) As Object
        Get
            Dim values As New System.Collections.Generic.List(Of Object)({a, b, c})
            values.AddRange(rest)
            Return Owner.InvokeNamed(Name, values.ToArray())
        End Get
    End Property
    Public Overrides Function TryInvoke(ByVal binder As System.Dynamic.InvokeBinder, ByVal values As Object(), ByRef result As Object) As Boolean
        result = Owner.InvokeNamed(Name, values)
        Return True
    End Function
    Public Overrides Function TryGetIndex(ByVal binder As System.Dynamic.GetIndexBinder, ByVal indexes As Object(), ByRef result As Object) As Boolean
        result = Owner.InvokeNamed(Name, indexes)
        Return True
    End Function
End Class
