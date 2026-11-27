Attribute VB_Name = "FixtureDrawings"
Option Explicit
' SolidWorks 2018+. Tools > Macro > New, import this .bas, run main. Optional second macro: it draws the parts an earlier Fixture Builder run left in a folder.
' Fixture Drawings version 2026.11.27.1 (the drawings package). It opens the parts read-only and never writes into that folder.
' Privacy: the drawings go into a new folder in the builder's neutral output root (Public, Documents, FixtureBuilder), never beside a run in a personal
' folder, and the run folder it reads must itself be neutral, because a part keeps its own save path and a drawing keeps the part's. Same checks,
' notice, neutral summary fields, scrub and sweep as the builder (one text: PersonalPathReason, NoticeStep, PrivacyScrub, PrivacySweep).
' Requires Windows PowerShell for zip.
Private Const swInputDimValOnCreate As Long = 10
Private Const swShowErrorsEveryRebuild As Long = 77
Private Const swWarnSaveUpdateErrors As Long = 329
Private Const swRebuildErrorAction As Long = 306
Private Const swContinueResponse_Stop As Long = 1
Private Const swDefaultTemplatePart As Long = 8
Private Const swDefaultTemplateAssembly As Long = 9
Private Const swDefaultTemplateDrawing As Long = 10
Private Const swFileLocationsDocumentTemplates As Long = 6
Private Const swDocASSEMBLY As Long = 2
Private Const swOpenDocOptions_Silent As Long = 1
Private Const swDocPART As Long = 1
Private Const swViewEntityType_Edge As Long = 1
Private Const swDxfVersion As Long = 0
Private Const swDxfFormat_R2000 As Long = 3
Private Const swDelete_Absorbed As Long = 2
Private Const swDetailingNoOptionSpecified As Long = 0
Private Const swOpenDocOptions_ReadOnly As Long = 2
Private Const swCustomInfoText As Long = 30
Private Const swCustomPropertyReplaceValue As Long = 2
Private Const swCustomInfoGetResult_NotPresent As Long = 1
Private Const swBomType_TopLevelOnly As Long = 2
Private Const swNumberingType_Detailed As Long = 1
Private Const swDetailingDimensionStandard As Long = 13
Private Const swUnitsLinear As Long = 47
' SolidWorks 2018+. Tools > Macro > New, import this .bas, run main.
' Fixture Builder version 2026.11.27.1 (sheet metal, expect.json checks, round 5).
Private Const BUILDER_VERSION As String = "2026.11.27.1"
' The neutral value written into the summary fields SolidWorks lets a macro set (author, saved-by) before each save.
Private Const NEUTRAL_VALUE As String = "Fixture Builder"
' Requires Windows PowerShell for zip.
' Full template paths; empty means automatic discovery.
Private Const TEMPLATE_PART As String = ""
Private Const TEMPLATE_ASSEMBLY As String = ""
Private Const TEMPLATE_DRAWING As String = ""
' Output parent folder; empty uses Public\Documents\FixtureBuilder (C:\Users\Public\Documents\FixtureBuilder), a folder without a user name in it
' (created if missing). A folder inside a user profile or a OneDrive folder is refused: see PersonalPathReason. No prompts during a run.
Private Const OUTPUT_FOLDER As String = ""
Private app As Object
Private doc As Object
Private rbStatus(2 To 5) As String
Private sweepEncoding As String
Private sweepListFailed As Boolean
Private sweepAnsiSkipped As Boolean
Private sweepEmptied As String
Private sweepEmptiedCount As Long
Private root As String
Private currentFolder As String
Private components As Object
Private loadedDocs As Collection
Private stepLabel As String
Private currentIdentity As String
Private resultRows As String
Private swMajor As Long
Private apiInputs As String
Private callInputs As String
Private mitigations As Object
Private primaryFailures As Object
Private fallbackSuccesses As Object
Private pickView As Object
' Round 22: the entities of the current selection (up to four), so a coincident mate refused with an alignment error can be made again with the same entities
' selected again (mate-align-retry). pickCount is -1 once the selection holds something that cannot be selected again (a reference by name).
Private pickEntities(3) As Object
Private pickAppends(3) As Boolean
Private pickMarks(3) As Long
Private pickCount As Long
Private replayingPicks As Boolean
Private drawingInterface As Object
Private dimensionValue As Object
Private attemptOldErrors As Boolean
Private attemptErrorsSaved As Boolean
Private Const PACKAGE_TEXT_STEP As Double = 0.012
Private Const SECTION_MARGIN As Double = 0.01
Private Const SECTION_TOLERANCE As Double = 0.005
Private Const BOM_TEMPLATE As String = "bom-standard.sldbomtbt"
Private packageFolder As String
Private packageComponents As Variant
Private packageModelDoc As Object
Private packagePart As String
Private packageLow As Variant
Private packageHigh As Variant
Private packageViews As Object
Private packageRecords As Object
Private packageDrops As Object
Private packageSpaces As Object
Private packageOrder As String
Private packageDimCount As Long
Private packageValues() As Double
Private packageRatioN As Double
Private packageRatioD As Double
Private packageSheetW As Double
Private packageSheetH As Double
Private packageScalePending As Boolean
Private packageTitle As Object
Private packageSheetObject As Object

Public Sub main()
    Dim revision As String, pieces As Variant, version As String, build As String
    Dim folder As String, target As String, outName As String, runFolder As String, i As Long, attempt As Long
    Dim fs As Object, oldInput As Boolean, inputSaved As Boolean, oldRebuild As Boolean, rebuildSaved As Boolean
    Dim oldWarn As Boolean, warnSaved As Boolean, oldAction As Long, actionSaved As Boolean
    Dim finalMessage As String, fatalDescription As String, fatalStep As String
    Dim fatalNumber As Long, fatalLine As Long
    Dim finishText As String, zipMade As Boolean
    Dim noticeNote As String, sweepNotes As String, zipError As String, swept As Boolean
114     On Error GoTo Fatal
115     currentIdentity = "setup"
    ' First of all, before SolidWorks is touched or a folder made: the output root (the builder's, in Public\Documents unless the settings say
    ' otherwise) must carry no personal path; the run folder is checked next, then the drawing template.
118     target = PackageOutputRoot()
119     finalMessage = PersonalPathReason(target)
120     If Len(finalMessage) > 0 Then GoTo Cleanup
    stepLabel = currentIdentity & ": main SldWorks"
122     Set app = Application.SldWorks
123     Set fs = CreateObject("Scripting.FileSystemObject")
124     runFolder = PackageNewestRun(target)
125     If Not IsUnattended() Then
126         runFolder = InputBox("Folder of an earlier Fixture Builder run (the one that holds the .sldprt files; it must be in a neutral folder, as the builder 2026.11.25.3 or later makes). The drawings go into a new folder in the builder's output folder; nothing in the run folder is changed.", "Dutchman Fixtures", runFolder)
    End If
128     runFolder = Trim$(runFolder)
129     Do While Len(runFolder) > 3 And Right$(runFolder, 1) = "\"
130         runFolder = Left$(runFolder, Len(runFolder) - 1)
    Loop
132     If Len(runFolder) = 0 Then
133         If Not IsUnattended() Then MsgBox "No folder was chosen, so nothing was drawn.", vbInformation, "SolidWorks fixtures"
134         Exit Sub
    End If
    ' A part keeps its own save path and a drawing keeps the part's: a run made in a personal folder would put that path into every drawing.
137     finalMessage = PackageRunFolderReason(runFolder)
138     If Len(finalMessage) > 0 Then GoTo Cleanup
    stepLabel = currentIdentity & ": main FolderExists"
140     If Not fs.FolderExists(runFolder) Then
141         finalMessage = "That folder was not found, so nothing was drawn: " & runFolder
142         GoTo Cleanup
    End If
144     finalMessage = PackageTemplateRefusal()
145     If Len(finalMessage) > 0 Then GoTo Cleanup
    ' The up-front notice, once per run: Cancel draws nothing.
147     noticeNote = NoticeStep(False)
148     If Len(noticeNote) = 0 Then
149         finalMessage = "Canceled at the user name notice. Nothing was drawn."
150         GoTo Cleanup
    End If
152     For i = 2 To 5
153         rbStatus(i) = ""
    Next i
155     sweepEmptied = ""
156     sweepEmptiedCount = 0
157     sweepListFailed = False
158     sweepAnsiSkipped = False
159     packageFolder = runFolder
    stepLabel = currentIdentity & ": main GetUserPreferenceToggle"
161     oldInput = app.GetUserPreferenceToggle(swInputDimValOnCreate)
162     inputSaved = True
    stepLabel = currentIdentity & ": main SetUserPreferenceToggle"
164     app.SetUserPreferenceToggle swInputDimValOnCreate, False
    stepLabel = currentIdentity & ": main GetUserPreferenceToggle"
166     oldRebuild = app.GetUserPreferenceToggle(swShowErrorsEveryRebuild)
167     rebuildSaved = True
    stepLabel = currentIdentity & ": main SetUserPreferenceToggle"
169     app.SetUserPreferenceToggle swShowErrorsEveryRebuild, False
    stepLabel = currentIdentity & ": main GetUserPreferenceToggle"
171     oldWarn = app.GetUserPreferenceToggle(swWarnSaveUpdateErrors)
172     warnSaved = True
    stepLabel = currentIdentity & ": main SetUserPreferenceToggle"
174     app.SetUserPreferenceToggle swWarnSaveUpdateErrors, False
    stepLabel = currentIdentity & ": main GetUserPreferenceIntegerValue"
176     oldAction = app.GetUserPreferenceIntegerValue(swRebuildErrorAction)
177     actionSaved = True
    stepLabel = currentIdentity & ": main SetUserPreferenceIntegerValue"
179     If Not app.SetUserPreferenceIntegerValue(swRebuildErrorAction, swContinueResponse_Stop) Then Err.Raise 5, , "Cannot disable rebuild prompt"
    stepLabel = currentIdentity & ": main RevisionNumber"
181     revision = app.RevisionNumber()
182     pieces = Split(revision, ".")
183     swMajor = CLng(pieces(0))
184     version = CStr(CLng(pieces(0)) + 1992)
185     build = "0"
186     If UBound(pieces) > 0 Then
187         build = pieces(1)
188         For i = 2 To UBound(pieces)
189             build = build & "-" & pieces(i)
        Next i
    End If
    ' Always a NEW folder in the output root: FixtureDrawings-SolidWorks-<version>, then -2, -3 ... Never deleted or reused.
193     EnsureFolder fs, target
194     outName = "FixtureDrawings-SolidWorks-" & BUILDER_VERSION
    stepLabel = currentIdentity & ": main BuildPath"
196     folder = fs.BuildPath(target, outName)
197     attempt = 1
    stepLabel = currentIdentity & ": main FolderExists"
199     Do While fs.FolderExists(folder) Or fs.FileExists(folder & ".zip")
200         attempt = attempt + 1
201         outName = "FixtureDrawings-SolidWorks-" & BUILDER_VERSION & "-" & CStr(attempt)
    stepLabel = currentIdentity & ": main BuildPath"
203         folder = fs.BuildPath(target, outName)
    Loop
    stepLabel = currentIdentity & ": main CreateFolder" & " " & apiInputs & " " & callInputs
206     fs.CreateFolder folder
207     resultRows = ""
    stepLabel = currentIdentity & ": main BuildPath"
209     WriteUtf8 fs.BuildPath(folder, "results.json"), "[]"
    stepLabel = currentIdentity & ": main GetFileName"
211     AppendLog folder, "setup", "Fixture Drawings " & BUILDER_VERSION, 0, 0, "SolidWorks revision " & revision & "; run folder " & fs.GetFileName(runFolder) & "; output folder " & outName & "; personal-path check: passed (output folder and run folder)"
212     AppendLog folder, "setup", "template path", 0, 0, "template path: neutral"
213     AppendLog folder, "setup", "user name notice", 0, 0, noticeNote
214     For i = 0 To PackageCount() - 1
215         RunPackage i, folder, version, build, CLng(pieces(0))
    Next i
217     AppendLog folder, "setup", "summary", 0, 0, "summary: ok=" & CStr(CountStatus("ok")) & " failed=" & CStr(CountStatus("failed")) & _
        " not_scripted=" & CStr(CountStatus("not_scripted")) & " skipped=" & CStr(CountStatus("skipped"))
219     AppendLog folder, "setup", "summary info", 0, 0, ReadbackText()
220     AppendLog folder, "setup", "summary info", 0, 0, "SolidWorks stamps the saving user in each file: not removable by the API"
221     AppendLog folder, "setup", "summary info", 0, 0, "SolidWorks also records its Windows temp folder (under your user profile) in each native file; we keep native files private and publish only STEP and files we've checked clean."
    ' Before the zip: every file in the output folder, listed or not, is scrubbed (see PrivacySweep).
223     swept = True
224     sweepNotes = PrivacySweep(folder)
225     If Len(sweepNotes) > 0 Then AppendLog folder, "setup", "privacy sweep", 0, 0, sweepNotes
226     zipMade = False
227     If Not sweepListFailed Then zipMade = MakeZip(folder)        ' a folder that could not be checked is never zipped
228     zipError = folder & "-zip-error.txt"
    stepLabel = currentIdentity & ": main FileExists"
230     If fs.FileExists(zipError) Then SweepFile fs, zipError, sweepNotes
231     If zipMade Then SaveSetting "DutchmanFixtures", "SolidWorksBuilder", "LastZip", folder & ".zip"
232     finishText = FinishMessage(CountStatus("ok") + CountStatus("failed") + CountStatus("not_scripted") + CountStatus("skipped"), _
        CountStatus("ok"), CountStatus("failed"), CountStatus("not_scripted"), CountStatus("skipped"), folder & ".zip", zipMade, folder)
234     AppendLog folder, "setup", "finish", 0, 0, finishText
235     GoTo Cleanup
Fatal:
    fatalLine = Erl: fatalNumber = Err.Number: fatalDescription = Err.Description: fatalStep = stepLabel
238     finalMessage = fatalStep & " (line " & CStr(fatalLine) & "): " & fatalDescription
239     On Error Resume Next
240     swept = False        ' an error after the sweep (in the zip step) is swept again on the way out
241     If Len(folder) > 0 Then AppendLog folder, currentIdentity, fatalStep, fatalLine, fatalNumber, fatalDescription
242     Resume Cleanup
Cleanup:
244     On Error Resume Next
245     Err.Clear
    ' Every way out of main passes here: the folder is swept once, so an error part way leaves no unswept text file.
247     If Len(folder) > 0 And Not swept Then
248         swept = True
249         sweepNotes = PrivacySweep(folder)
250         If Len(sweepNotes) > 0 Then AppendLog folder, "setup", "privacy sweep", 0, 0, sweepNotes
    End If
252     Err.Clear
    stepLabel = currentIdentity & ": main SetUserPreferenceIntegerValue"
254     If actionSaved Then app.SetUserPreferenceIntegerValue swRebuildErrorAction, oldAction
255     If Err.Number <> 0 Then ReportCleanupError folder, finalMessage
256     Err.Clear
    stepLabel = currentIdentity & ": main SetUserPreferenceToggle"
258     If warnSaved Then app.SetUserPreferenceToggle swWarnSaveUpdateErrors, oldWarn
259     If Err.Number <> 0 Then ReportCleanupError folder, finalMessage
260     Err.Clear
    stepLabel = currentIdentity & ": main SetUserPreferenceToggle"
262     If rebuildSaved Then app.SetUserPreferenceToggle swShowErrorsEveryRebuild, oldRebuild
263     If Err.Number <> 0 Then ReportCleanupError folder, finalMessage
264     Err.Clear
    stepLabel = currentIdentity & ": main SetUserPreferenceToggle"
266     If inputSaved Then app.SetUserPreferenceToggle swInputDimValOnCreate, oldInput
267     If Err.Number <> 0 Then ReportCleanupError folder, finalMessage
268     Err.Clear
    ' FIXTURE_UNATTENDED=1: no Explorer window and no message box, only the log line written above.
270     If Len(finalMessage) > 0 Then
271         If Not IsUnattended() Then MsgBox PrivacyScrub(finalMessage), vbExclamation, "SolidWorks fixtures"
    ElseIf Len(finishText) > 0 And Not IsUnattended() Then
273         If zipMade Then
    stepLabel = currentIdentity & ": main Run"
275             CreateObject("WScript.Shell").Run "explorer.exe /select,""" & folder & ".zip""", 1, False
        Else
    stepLabel = currentIdentity & ": main Run"
278             CreateObject("WScript.Shell").Run "explorer.exe """ & folder & """", 1, False
        End If
280         Err.Clear
281         MsgBox PrivacyScrub(finishText), vbInformation, "SolidWorks fixtures"
    End If
End Sub

Private Function PackageOutputRoot() As String
    ' The builder's output root: OUTPUT_FOLDER when it is set, else the launcher's OutputRoot setting, else the neutral default
    ' (Public\Documents\FixtureBuilder). The old Documents\FixtureBuilder is never looked in: it is a personal folder.
    Dim rootFolder As String
289     rootFolder = OUTPUT_FOLDER
290     If Len(rootFolder) = 0 Then rootFolder = GetSetting("DutchmanFixtures", "SolidWorksBuilder", "OutputRoot", "")
291     If Len(rootFolder) = 0 Then rootFolder = DefaultOutputRoot()
292     PackageOutputRoot = rootFolder
End Function

Private Function PackageRunFolderReason(ByVal runFolder As String) As String
    ' "" when the run folder is neutral, else the refusal. A part keeps its own save path inside the file and a drawing references the part's path,
    ' so drawings made from a run in a personal folder would carry that path. The text never repeats the folder.
298     If Not DriveRooted(runFolder) Then
299         PackageRunFolderReason = "The run folder was refused because the folder must be a full path starting with a drive letter. Nothing was drawn."
    ElseIf Len(PersonalWhy(runFolder, True)) > 0 Then
301         PackageRunFolderReason = "This run was made in a personal folder, so its parts carry that folder's path. Run the Fixture Builder " & BUILDER_VERSION & " or later first; it saves to " & DefaultOutputRoot() & "."
    End If
End Function

Private Function PackageTemplateRefusal() As String
    ' The drawing template is the only one the package uses (a drawing keeps the path of its template and sheet format).
    Dim path As String
308     On Error Resume Next
309     path = ResolveTemplate("drawing")
310     Err.Clear
311     On Error GoTo 0
312     If Len(path) > 0 Then PackageTemplateRefusal = PersonalTemplateReason("drawing", path)
End Function

Private Function PackageNewestRun(ByVal rootFolder As String) As String
    ' The newest FixtureBuilder-SolidWorks-* folder under the (neutral) output root ("" when there is none).
    Dim fs As Object, candidate As Object, best As Object
318     Set fs = CreateObject("Scripting.FileSystemObject")
    stepLabel = currentIdentity & ": PackageNewestRun FolderExists"
320     If Not fs.FolderExists(rootFolder) Then Exit Function
    stepLabel = currentIdentity & ": PackageNewestRun GetFolder"
322     For Each candidate In fs.GetFolder(rootFolder).SubFolders
    stepLabel = currentIdentity & ": PackageNewestRun Name"
324         If InStr(1, candidate.Name, "FixtureBuilder-SolidWorks-", vbTextCompare) = 1 Then
325             If best Is Nothing Then
326                 Set best = candidate
            ElseIf candidate.DateLastModified > best.DateLastModified Then
328                 Set best = candidate
            End If
        End If
    Next candidate
    stepLabel = currentIdentity & ": PackageNewestRun Path"
333     If Not best Is Nothing Then PackageNewestRun = best.Path
End Function

Private Function FinishMessage(ByVal total As Long, ByVal made As Long, ByVal failed As Long, ByVal notScripted As Long, ByVal skipped As Long, ByVal zipPath As String, ByVal zipMade As Boolean, ByVal folder As String) As String
    Dim noun As String, counts As String
338     noun = "drawings"
339     If total = 1 Then noun = "drawing"
340     counts = CStr(total) & " " & noun & ": " & CStr(made) & " made, " & CStr(failed) & " failed, " & CStr(notScripted) & _
        " not scripted, " & CStr(skipped) & " skipped (details in FixtureDrawings.log)." & EmptiedLine()
342     If sweepListFailed Then
343         FinishMessage = counts & vbLf & "The zip was not made because the output folder could not be checked; nothing was sent."
    ElseIf zipMade Then
345         FinishMessage = counts & vbLf & "Next: post this zip in your builder thread, or send it to Dutchy in a Discord direct message:" & vbLf & zipPath
    Else
347         FinishMessage = counts & vbLf & "The zip could not be made (the reason is in FixtureDrawings.log and " & folder & "-zip-error.txt)." & vbLf & _
            "Next: right-click this folder, choose Send to > Compressed (zipped) folder, and post that zip in your builder thread or send it to Dutchy in a Discord direct message:" & vbLf & folder
    End If
End Function

Private Sub AppendLog(ByVal folder As String, ByVal identity As String, ByVal failedStep As String, ByVal lineNumber As Long, ByVal errorNumber As Long, ByVal description As String)
    Dim channel As Integer
354     channel = FreeFile
355     Open folder & "\FixtureDrawings.log" For Append As #channel
356     Print #channel, Format$(Now, "yyyy-mm-dd hh:nn:ss") & " builder=" & BUILDER_VERSION & " recipe=" & identity & _
        " step=" & failedStep & " Erl=" & CStr(lineNumber) & " Err.Number=" & CStr(errorNumber) & _
        " Err.Description=" & Replace(Replace(CleanError(description), vbCr, "\r"), vbLf, "\n")
359     Close #channel
End Sub

Private Sub RunPackage(ByVal index As Long, ByVal folder As String, ByVal version As String, ByVal build As String, ByVal major As Long)
    ' One companion drawing entry: skipped (not made by the builder, or its part file is not in the folder), not scripted, drawn, or failed with
    ' the step and the call inputs. A failure never stops the next entry.
    Dim identity As String, status As String, message As String, files As String, started As Double, elapsed As Double
    Dim fs As Object, title As Variant
    Dim failureLine As Long, failureNumber As Long, failureDescription As String, failureStep As String
368     On Error GoTo Failed
369     Set doc = Nothing
370     Set loadedDocs = Nothing
371     attemptErrorsSaved = False
372     started = Timer
373     identity = PackageId(index)
374     currentIdentity = identity
375     currentFolder = folder
376     Set mitigations = CreateObject("Scripting.Dictionary")
377     Set primaryFailures = CreateObject("Scripting.Dictionary")
378     Set fallbackSuccesses = CreateObject("Scripting.Dictionary")
379     apiInputs = "": callInputs = ""
380     stepLabel = identity & ": preflight"
381     status = "failed"
382     files = "[]"
383     Set fs = CreateObject("Scripting.FileSystemObject")
384     Select Case PackageState(index)
        Case 1
386             status = "not_scripted"
387             message = PackageReason(index)
        Case Else
389             If major < 26 Then
390                 status = "not_scripted"
391                 message = "needs SolidWorks 2018+"
            ElseIf Not fs.FileExists(packageFolder & "\" & PackageModel(index) & PackageExtension(index)) Then
393                 status = "skipped"
394                 message = "the part file is not in this folder"
            Else
396                 AttemptPackage index, folder
397                 status = "ok"
398                 files = "[" & Quote(identity & ".slddrw") & "," & Quote(identity & ".pdf") & "," & Quote(identity & ".dxf") & "]"
            End If
    End Select
401     GoTo Finished
Failed:
    failureLine = Erl: failureNumber = Err.Number: failureDescription = Err.Description: failureStep = stepLabel
404     AppendLog folder, currentIdentity, failureStep, failureLine, failureNumber, failureDescription
405     message = failureStep & " (line " & CStr(failureLine) & "): " & failureDescription
406     status = "failed"
407     files = "[]"
408     Resume Finished
Finished:
410     On Error GoTo CleanupFailed
411     If status <> "ok" Then PackageRemoveFiles folder, identity
412     If Not doc Is Nothing Then
    stepLabel = currentIdentity & ": RunPackage ShowFeatureErrorDialog"
414         If attemptErrorsSaved Then doc.ShowFeatureErrorDialog = attemptOldErrors
    stepLabel = currentIdentity & ": RunPackage CloseDoc"
416         app.CloseDoc doc.GetTitle()
    End If
418     Set doc = Nothing
419     If Not loadedDocs Is Nothing Then
420         For Each title In loadedDocs
    stepLabel = currentIdentity & ": RunPackage CloseDoc"
422             app.CloseDoc CStr(title)
        Next title
    End If
425     Set loadedDocs = Nothing
426     On Error GoTo ReportFailed
427     elapsed = Timer - started
428     If elapsed < 0 Then elapsed = elapsed + 86400#
429     PackageRow identity, status, message, files, version, build, elapsed
430     AppendLog folder, currentIdentity, "recipe complete: " & status, 0, 0, MitigationText()
431     Exit Sub
CleanupFailed:
    failureLine = Erl: failureNumber = Err.Number: failureDescription = Err.Description: failureStep = stepLabel
434     AppendLog folder, currentIdentity, failureStep, failureLine, failureNumber, failureDescription
435     message = failureStep & " (line " & CStr(failureLine) & "): " & failureDescription
436     status = "failed"
437     files = "[]"
438     Resume Next
ReportFailed:
    ' Propagate reporting failures to main's final visible error, never swallow them.
441     Err.Raise Err.Number, "RunPackage reporting", Err.Description
End Sub

Private Sub PackageRow(ByVal identity As String, ByVal status As String, ByVal message As String, ByVal files As String, ByVal version As String, ByVal build As String, ByVal elapsed As Double)
    Dim resultRow As String, priorRows As String
446     priorRows = resultRows
447     If Len(priorRows) > 0 Then priorRows = priorRows & ","
448     resultRow = "{""id"":" & Quote(identity) & ",""status"":" & Quote(status) & _
        ",""error"":" & Quote(CleanError(message)) & ",""files"":" & files & _
        ",""app"":""SolidWorks"",""version"":" & Quote(version) & _
        ",""build"":" & Quote(build) & ",""mitigations"":" & MitigationJson() & ",""seconds"":" & Replace(Format$(elapsed, "0.0000"), ",", ".") & "}"
452     resultRows = priorRows & resultRow
453     WriteUtf8 currentFolder & "\results.json", "[" & resultRows & "]"
End Sub

Private Sub PackageRemoveFiles(ByVal folder As String, ByVal identity As String)
    ' A drawing that did not finish leaves no half-made file behind.
    Dim fs As Object, extension As Variant, path As String
459     Set fs = CreateObject("Scripting.FileSystemObject")
460     For Each extension In Array(".slddrw", ".pdf", ".dxf")
    stepLabel = currentIdentity & ": PackageRemoveFiles BuildPath"
462         path = fs.BuildPath(folder, identity & CStr(extension))
    stepLabel = currentIdentity & ": PackageRemoveFiles FileExists"
464         If fs.FileExists(path) Then fs.DeleteFile path
    Next extension
End Sub

Private Sub AttemptPackage(ByVal index As Long, ByVal folder As String)
    ' One drawing in its own new document: the part opened read-only and silent first (so the new drawing is the active document afterwards, and the
    ' part is closed unsaved), the plan, the read-backs, the privacy blanking, the title block text, then the three files.
    Dim identity As String, fs As Object, template As String, model As Object, modelErrors As Long, modelWarnings As Long
    Dim native As String, pdfFile As String, dxfFile As String
473     identity = currentIdentity
474     Set loadedDocs = New Collection
475     Set fs = CreateObject("Scripting.FileSystemObject")
476     template = ResolveTemplate("drawing")
477     stepLabel = identity & ": model open"
    stepLabel = currentIdentity & ": AttemptPackage OpenDoc6"
479     Set model = app.OpenDoc6(packageFolder & "\" & PackageModel(index) & PackageExtension(index), PackageDocType(index), swOpenDocOptions_Silent + swOpenDocOptions_ReadOnly, "", modelErrors, modelWarnings)
480     If modelErrors <> 0 Then Err.Raise 5, , "SolidWorks OpenDoc6 error " & CStr(modelErrors) & " opening the drawing model"
481     Require model, "The drawing model could not be opened"
482     Set packageModelDoc = model
    stepLabel = currentIdentity & ": AttemptPackage Add"
484     loadedDocs.Add model.GetTitle()
    stepLabel = currentIdentity & ": AttemptPackage NewDocument"
486     Set doc = app.NewDocument(template, 0, 0#, 0#)
487     If doc Is Nothing Then Err.Raise 5, , "Template could not be opened. Paths tried: " & template
    stepLabel = currentIdentity & ": AttemptPackage GetFileName"
489     AppendLog folder, currentIdentity, "option", 0, 0, "drawing template: " & fs.GetFileName(template)
    stepLabel = currentIdentity & ": AttemptPackage ShowFeatureErrorDialog"
491     attemptOldErrors = doc.ShowFeatureErrorDialog
492     attemptErrorsSaved = True
    stepLabel = currentIdentity & ": AttemptPackage ShowFeatureErrorDialog"
494     doc.ShowFeatureErrorDialog = False
495     BuildPackage index
496     PackageFinish
497     BlankProperties
498     BuildPackageTitle index
499     native = identity & ".slddrw"
500     pdfFile = identity & ".pdf"
501     dxfFile = identity & ".dxf"
    stepLabel = currentIdentity & ": AttemptPackage BuildPath"
503     SaveFile fs.BuildPath(folder, native)
504     stepLabel = identity & ": pdf export"
    stepLabel = currentIdentity & ": AttemptPackage BuildPath"
506     SaveFile fs.BuildPath(folder, pdfFile)
    stepLabel = currentIdentity & ": AttemptPackage BuildPath"
508     PackageFileCheck fs.BuildPath(folder, pdfFile), "PDF"
509     stepLabel = identity & ": dxf export"
    stepLabel = currentIdentity & ": AttemptPackage BuildPath"
511     ExportDrawing fs.BuildPath(folder, dxfFile)
End Sub

Private Sub PackageFileCheck(ByVal path As String, ByVal kind As String)
    Dim fs As Object
516     stepLabel = currentIdentity & ": " & kind & " file check"
517     Set fs = CreateObject("Scripting.FileSystemObject")
    stepLabel = currentIdentity & ": PackageFileCheck FileExists"
519     If Not fs.FileExists(path) Then Err.Raise 5, , "The " & kind & " export wrote no file"
    stepLabel = currentIdentity & ": PackageFileCheck GetFile"
521     If fs.GetFile(path).Size = 0 Then Err.Raise 5, , "The " & kind & " export wrote an empty file"
    stepLabel = currentIdentity & ": PackageFileCheck GetFileName"
523     AppendLog currentFolder, currentIdentity, "option", 0, 0, "drawing " & kind & ": " & fs.GetFileName(path) & ", " & CStr(fs.GetFile(path).Size) & " bytes"
End Sub

Private Sub PackageStart(ByVal partFile As String, ByVal lowMm As Variant, ByVal highMm As Variant)
527     packagePart = packageFolder & "\" & partFile
528     packageComponents = Empty
529     packageLow = Array(CDbl(lowMm(0)) * 0.001, CDbl(lowMm(1)) * 0.001, CDbl(lowMm(2)) * 0.001)
530     packageHigh = Array(CDbl(highMm(0)) * 0.001, CDbl(highMm(1)) * 0.001, CDbl(highMm(2)) * 0.001)
531     Set packageViews = CreateObject("Scripting.Dictionary")
532     Set packageRecords = CreateObject("Scripting.Dictionary")
533     Set packageDrops = CreateObject("Scripting.Dictionary")
534     Set packageSpaces = CreateObject("Scripting.Dictionary")
535     Set packageTitle = CreateObject("Scripting.Dictionary")
536     packageOrder = ""
537     packageDimCount = 0
538     packageRatioN = 1#
539     packageRatioD = 1#
540     packageSheetW = 0.297
541     packageSheetH = 0.21
542     packageScalePending = False
End Sub

Private Sub PackageAssembly(ByVal components As Variant)
    ' An assembly's components: Array(name, low, high, shift) in meters (their boxes in the assembly and where each one's origin stands), for the edges.
547     packageComponents = components
End Sub

Private Function PackageBomTemplate() As String
    ' The BOM table template: bom-standard.sldbomtbt, exactly, from the install's template folder (lang\<language>\). No other file is taken instead and the empty
    ' path (SolidWorks's own default) is not asked for: a template in a personal folder could put a path in the file, so one that is absent or personal fails
    ' the drawing precisely. Only the file name is ever logged.
    Dim fs As Object, install As String, candidate As String, found As Boolean
555     Set fs = CreateObject("Scripting.FileSystemObject")
556     On Error Resume Next
    stepLabel = currentIdentity & ": PackageBomTemplate GetExecutablePath"
558     install = app.GetExecutablePath()
    stepLabel = currentIdentity & ": PackageBomTemplate GetExtensionName"
560     If LCase$(fs.GetExtensionName(install)) = "exe" Then install = fs.GetParentFolderName(install)
    stepLabel = currentIdentity & ": PackageBomTemplate BuildPath"
562     candidate = fs.BuildPath(fs.BuildPath(fs.BuildPath(install, "lang"), app.GetCurrentLanguage()), BOM_TEMPLATE)
    stepLabel = currentIdentity & ": PackageBomTemplate FileExists"
564     found = fs.FileExists(candidate)
565     If Err.Number <> 0 Then
566         found = False
567         Err.Clear
    End If
569     On Error GoTo 0
570     If found Then
571         If Len(PersonalTemplateReason("BOM table", candidate)) > 0 Then
572             AppendLog currentFolder, currentIdentity, "option", 0, 0, "parts list: the install's BOM template " & BOM_TEMPLATE & " is in a personal folder and is not used"
573             found = False
        End If
    End If
576     If Not found Then Err.Raise 5, , "no usable BOM template (" & BOM_TEMPLATE & ") outside personal folders"
577     PackageBomTemplate = candidate
End Function

Private Sub PackagePartsList(ByVal anchor As Long, ByVal fractionX As Double, ByVal fractionY As Double, ByVal rows As Variant)
    ' The parts list: the base view is selected and IView.InsertBomTable4 inserts a top-level BOM table hanging from the recipe's corner of the sheet
    ' (UseAnchorPoint False, so X and Y are the corner); the table is then read back and must be the assembly's components. InsertBomTable4 answers a
    ' BomTableAnnotation; RowCount, ColumnCount and Text belong to ITableAnnotation, so the answer is assigned to a variable of that type (the query).
    Dim fs As Object, baseView As Object, x As Double, y As Double, configuration As String, template As String
    Dim bomResult As Object, tableAnnotation As SldWorks.TableAnnotation
586     Set fs = CreateObject("Scripting.FileSystemObject")
587     Set baseView = packageViews("base")
588     x = fractionX * packageSheetW
589     y = fractionY * packageSheetH
    stepLabel = currentIdentity & ": PackagePartsList Name"
591     configuration = CStr(packageModelDoc.ConfigurationManager.ActiveConfiguration.Name)
592     template = PackageBomTemplate()
    stepLabel = currentIdentity & ": PackagePartsList ClearSelection2"
594     doc.ClearSelection2 True
    stepLabel = currentIdentity & ": PackagePartsList GetName2"
596     callInputs = "parts list in " & baseView.GetName2() & " at(m)=" & NumberList(Array(x, y)) & " anchor " & CStr(anchor) & " top level only, configuration " & configuration & ", template " & fs.GetFileName(template)
    stepLabel = currentIdentity & ": PackagePartsList SelectByID2" & " " & apiInputs & " " & callInputs
598     If Not doc.Extension.SelectByID2(baseView.GetName2(), "DRAWINGVIEW", 0#, 0#, 0#, False, 0, Nothing, 0) Then Err.Raise 5, , "The base view could not be selected for the parts list: " & callInputs
    stepLabel = currentIdentity & ": PackagePartsList InsertBomTable4"
600     Set bomResult = baseView.InsertBomTable4(False, x, y, anchor, swBomType_TopLevelOnly, configuration, template, False, swNumberingType_Detailed, False)
    stepLabel = currentIdentity & ": PackagePartsList ClearSelection2"
602     doc.ClearSelection2 True
603     Require bomResult, "IView.InsertBomTable4 returned no table: " & callInputs
604     Set tableAnnotation = bomResult
605     Require tableAnnotation, "The parts list table does not answer ITableAnnotation: " & callInputs
606     PackagePartsListCheck tableAnnotation, rows
End Sub

Private Function PackageWholeNumber(ByVal text As String) As Boolean
    ' Only digits: "1" is a quantity, "1.5", "1,0", "-1" and "" are not.
    Dim i As Long
612     If Len(text) = 0 Or Len(text) > 9 Then Exit Function
613     For i = 1 To Len(text)
614         If Not Mid$(text, i, 1) Like "#" Then Exit Function
    Next i
616     PackageWholeNumber = True
End Function

Private Function PackagePartName(ByVal text As String) As String
    ' A parts list's part number cell as a part name: without any <...> part, lower case, without .sldprt or .sldasm.
    Dim opens As Long, closes As Long
622     text = Trim$(text)
623     opens = InStr(text, "<")
624     Do While opens > 0
625         closes = InStr(opens, text, ">")
626         If closes = 0 Then Exit Do
627         text = Left$(text, opens - 1) & Mid$(text, closes + 1)
628         opens = InStr(text, "<")
    Loop
630     text = LCase$(Trim$(text))
631     If Right$(text, 7) = ".sldprt" Or Right$(text, 7) = ".sldasm" Then text = Left$(text, Len(text) - 7)
632     PackagePartName = text
End Function

Private Sub PackagePartsListCheck(ByVal tableAnnotation As SldWorks.TableAnnotation, ByVal rows As Variant)
    ' The table's rows (ITableAnnotation RowCount, ColumnCount, Text) against the assembly: its header row has PART NUMBER and QTY. columns, and each
    ' other row is one component and its quantity: every (part name, quantity) of the recipe's assembly, and nothing else.
    Dim rowCount As Long, columnCount As Long, r As Long, c As Long, header As Long, nameColumn As Long, quantityColumn As Long, cell As String
    Dim count As Long, i As Long, k As Long, names() As String, quantities() As Long, used() As Boolean, matched As Boolean, quantityText As String
    Dim got As String, headerText As String
    stepLabel = currentIdentity & ": PackagePartsListCheck RowCount"
642     rowCount = CLng(tableAnnotation.RowCount)
    stepLabel = currentIdentity & ": PackagePartsListCheck ColumnCount"
644     columnCount = CLng(tableAnnotation.ColumnCount)
645     header = -1
646     nameColumn = -1
647     quantityColumn = -1
648     For r = 0 To rowCount - 1
649         For c = 0 To columnCount - 1
    stepLabel = currentIdentity & ": PackagePartsListCheck Text"
651             cell = UCase$(Trim$(CStr(tableAnnotation.Text(r, c))))
652             If header < 0 And (cell = "QTY" Or cell = "QTY.") Then
653                 header = r
654                 quantityColumn = c
            End If
        Next c
    Next r
658     If header < 0 Then Err.Raise 5, , "The parts list has no header row with a QTY. column in its " & CStr(rowCount) & " rows and " & CStr(columnCount) & " columns"
659     For c = 0 To columnCount - 1
    stepLabel = currentIdentity & ": PackagePartsListCheck Text"
661         cell = UCase$(Trim$(CStr(tableAnnotation.Text(header, c))))
662         If Len(headerText) > 0 Then headerText = headerText & " | "
663         headerText = headerText & cell
664         If nameColumn < 0 And Replace(cell, " ", "") = "PARTNUMBER" Then nameColumn = c
    Next c
666     If nameColumn < 0 Then Err.Raise 5, , "The parts list has no PART NUMBER column (its header reads " & headerText & ")"
667     count = rowCount - 1
668     If count <> UBound(rows) + 1 Then Err.Raise 5, , "The parts list has " & CStr(count) & " rows, the assembly has " & CStr(UBound(rows) + 1) & " components"
669     ReDim names(count - 1)
670     ReDim quantities(count - 1)
671     ReDim used(count - 1)
672     i = 0
673     For r = 0 To rowCount - 1
674         If r <> header Then
    stepLabel = currentIdentity & ": PackagePartsListCheck Text"
676             names(i) = PackagePartName(CStr(tableAnnotation.Text(r, nameColumn)))
    stepLabel = currentIdentity & ": PackagePartsListCheck Text"
678             quantityText = Trim$(CStr(tableAnnotation.Text(r, quantityColumn)))
679             If Not PackageWholeNumber(quantityText) Then Err.Raise 5, , "The parts list quantity " & quantityText & " of " & names(i) & " is not a whole number"
680             quantities(i) = CLng(quantityText)
681             If Len(got) > 0 Then got = got & ", "
682             got = got & names(i) & " " & CStr(quantities(i))
683             i = i + 1
        End If
    Next r
686     For k = 0 To UBound(rows)
687         matched = False
688         For i = 0 To count - 1
689             If Not used(i) And names(i) = LCase$(CStr(rows(k)(0))) And quantities(i) = CLng(rows(k)(1)) Then
690                 used(i) = True
691                 matched = True
692                 Exit For
            End If
        Next i
695         If Not matched Then Err.Raise 5, , "The parts list has no row for " & CStr(rows(k)(0)) & " with the quantity " & CStr(rows(k)(1)) & " (it reads: " & got & ")"
    Next k
697     AppendLog currentFolder, currentIdentity, "option", 0, 0, "drawing parts list: " & CStr(count) & " rows read back, " & got
End Sub

Private Function PackageSheetProperties(ByVal sheetObject As Object) As Variant
    ' ISheet.GetProperties2 as exactly eight values (paper size, template, scale numerator and denominator, first angle, width, height,
    ' same custom property), or Empty when SolidWorks does not give them.
    Dim values As Variant, first As Long, same As Variant
704     On Error Resume Next
    stepLabel = currentIdentity & ": PackageSheetProperties GetProperties2"
706     values = sheetObject.GetProperties2()
707     If Err.Number <> 0 Then
708         Err.Clear
709         Exit Function
    End If
711     On Error GoTo 0
712     If Not IsArray(values) Then Exit Function
713     first = LBound(values)
714     If UBound(values) - first < 6 Then Exit Function
715     same = False
716     If UBound(values) - first >= 7 Then same = values(first + 7)
717     PackageSheetProperties = Array(values(first), values(first + 1), values(first + 2), values(first + 3), values(first + 4), values(first + 5), values(first + 6), same)
End Function

Private Sub PackageSetting(ByVal what As String, ByVal preference As Long, ByVal wanted As Long)
    ' A document preference the drawing must have (the standard, the units): read from the template's drawing, set when it differs, read again.
    Dim found As Long, again As Long, mitigation As String
723     callInputs = "preference=" & CStr(preference) & " wanted=" & CStr(wanted)
    stepLabel = currentIdentity & ": PackageSetting GetUserPreferenceInteger"
725     found = doc.Extension.GetUserPreferenceInteger(preference, swDetailingNoOptionSpecified)
726     If found = wanted Then Exit Sub
727     mitigation = "drawing-" & what & "-set"
728     RecordMitigation mitigation, True, True
    stepLabel = currentIdentity & ": PackageSetting SetUserPreferenceInteger"
730     If Not doc.Extension.SetUserPreferenceInteger(preference, swDetailingNoOptionSpecified, wanted) Then Err.Raise 5, , "The drawing " & what & " could not be set: " & callInputs
    stepLabel = currentIdentity & ": PackageSetting GetUserPreferenceInteger"
732     again = doc.Extension.GetUserPreferenceInteger(preference, swDetailingNoOptionSpecified)
733     If again <> wanted Then Err.Raise 5, , "The drawing " & what & " stays " & CStr(again) & ", not " & CStr(wanted) & ", after setting it: " & callInputs
734     fallbackSuccesses(mitigation) = fallbackSuccesses(mitigation) + 1
735     AppendLog currentFolder, currentIdentity, "option", 0, 0, "drawing " & what & ": the template had " & CStr(found) & ", set to " & CStr(wanted)
End Sub

Private Sub PackageSheet(ByVal standard As Long, ByVal units As Long, ByVal paper As Long, ByVal paperWidth As Double, ByVal paperHeight As Double, ByVal numerator As Double, ByVal denominator As Double)
    Dim sheetObject As Object, properties As Variant, text As String
740     Set drawingInterface = DrawingDocument(doc)
    stepLabel = currentIdentity & ": PackageSheet GetCurrentSheet"
742     Set sheetObject = drawingInterface.GetCurrentSheet()
743     Require sheetObject, "The new drawing has no current sheet"
744     Set packageSheetObject = sheetObject
745     If standard >= 0 Then PackageSetting "standard", swDetailingDimensionStandard, standard
746     If units >= 0 Then PackageSetting "units", swUnitsLinear, units
747     properties = PackageSheetProperties(sheetObject)
748     If paper >= 0 Then
749         callInputs = "PaperSz=" & CStr(paper) & " Width=" & NumberList(Array(paperWidth)) & " Height=" & NumberList(Array(paperHeight))
750         If IsEmpty(properties) Then Err.Raise 5, , "ISheet.GetProperties2 returned no sheet properties: " & callInputs
751         If CLng(properties(0)) <> paper Then
752             RecordMitigation "drawing-sheet-size-set", True, True
            ' ISheet.SetProperties2 returns nothing (interop 32.1.0, void): it is read back, not checked for a result.
    stepLabel = currentIdentity & ": PackageSheet SetProperties2"
755             sheetObject.SetProperties2 paper, CLng(properties(1)), CDbl(properties(2)), CDbl(properties(3)), CBool(properties(4)), paperWidth, paperHeight, CBool(properties(7))
756             properties = PackageSheetProperties(sheetObject)
757             If IsEmpty(properties) Then Err.Raise 5, , "ISheet.GetProperties2 returned no sheet properties after setting the size: " & callInputs
758             If CLng(properties(0)) <> paper Then Err.Raise 5, , "The sheet size stays " & CStr(CLng(properties(0))) & ", not " & CStr(paper) & ", after setting it: " & callInputs
759             fallbackSuccesses("drawing-sheet-size-set") = fallbackSuccesses("drawing-sheet-size-set") + 1
        End If
    End If
762     If Not IsEmpty(properties) Then
763         packageSheetW = CDbl(properties(5))
764         packageSheetH = CDbl(properties(6))
    End If
766     callInputs = "Numerator=" & NumberList(Array(numerator)) & " Denominator=" & NumberList(Array(denominator))
    stepLabel = currentIdentity & ": PackageSheet SetScale"
768     If Not sheetObject.SetScale(numerator, denominator, False, False) Then Err.Raise 5, , "ISheet.SetScale failed: " & callInputs
769     packageRatioN = numerator
770     packageRatioD = denominator
771     properties = PackageSheetProperties(sheetObject)
772     If IsEmpty(properties) Then
        ' The scale cannot be read from the sheet: every view's own scale is checked instead (and counted once the first one is right).
774         RecordMitigation "drawing-sheet-scale-from-views", True, True
775         packageScalePending = True
776         text = "unknown"
    Else
778         If Abs(CDbl(properties(2)) * denominator - CDbl(properties(3)) * numerator) > 0.000000001 Then Err.Raise 5, , "The sheet scale reads back " & NumberList(Array(properties(2), properties(3))) & ", not " & NumberList(Array(numerator, denominator)) & ": " & callInputs
779         text = CStr(CBool(properties(4)))
    End If
781     AppendLog currentFolder, currentIdentity, "option", 0, 0, "drawing: sheet " & NumberList(Array(packageSheetW, packageSheetH)) & " m, scale " & NumberList(Array(numerator, denominator)) & ", first angle " & text
End Sub

Private Sub PackageCheckScale(ByVal view As Object, ByVal what As String, ByVal ownN As Double, ByVal ownD As Double)
    ' The view is at the sheet's scale, or at (ownN : ownD), a scale the recipe gives that view alone (ownD = 0 means none): set on the view and read back.
    Dim wanted As Double
787     wanted = packageRatioN / packageRatioD
788     If ownD > 0 Then wanted = ownN / ownD
    stepLabel = currentIdentity & ": PackageCheckScale ScaleDecimal"
790     If Abs(view.ScaleDecimal - wanted) > 0.000000001 Then
        ' The sheet scale was set first; a view that still is not at it is given the scale itself.
792         If ownD = 0 Then RecordMitigation "drawing-view-scale-explicit", True, True
    stepLabel = currentIdentity & ": PackageCheckScale UseSheetScale"
794         view.UseSheetScale = 0
    stepLabel = currentIdentity & ": PackageCheckScale ScaleDecimal"
796         view.ScaleDecimal = wanted
    stepLabel = currentIdentity & ": PackageCheckScale ScaleDecimal"
798         If Abs(view.ScaleDecimal - wanted) > 0.000000001 Then Err.Raise 5, , "The " & what & " view scale is " & NumberList(Array(view.ScaleDecimal)) & ", not " & NumberList(Array(wanted)) & ", after setting it: " & callInputs
799         If ownD = 0 Then
800             fallbackSuccesses("drawing-view-scale-explicit") = fallbackSuccesses("drawing-view-scale-explicit") + 1
        Else
802             AppendLog currentFolder, currentIdentity, "option", 0, 0, "drawing: the " & what & " view has its own scale " & NumberList(Array(ownN, ownD)) & ", set on the view and read back"
        End If
    End If
805     If packageScalePending Then
806         packageScalePending = False
807         fallbackSuccesses("drawing-sheet-scale-from-views") = fallbackSuccesses("drawing-sheet-scale-from-views") + 1
    End If
End Sub

Private Function PackageModelView(ByVal orientation As String, ByVal what As String, ByVal x As Double, ByVal y As Double, ByVal ownN As Double, ByVal ownD As Double) As Object
    Dim created As Object
    stepLabel = currentIdentity & ": PackageModelView ClearSelection2"
814     doc.ClearSelection2 True
815     callInputs = "model=" & Mid$(packagePart, InStrRev(packagePart, "\") + 1) & " view=" & orientation & " at(m)=" & NumberList(Array(x, y)) & ",0"
    stepLabel = currentIdentity & ": PackageModelView CreateDrawViewFromModelView3" & " " & apiInputs & " " & callInputs
817     Set created = drawingInterface.CreateDrawViewFromModelView3(packagePart, orientation, x, y, 0#)
818     Require created, "The " & what & " view was not created: " & callInputs
    stepLabel = currentIdentity & ": PackageModelView ClearSelection2"
820     doc.ClearSelection2 True
821     PackageCheckScale created, what, ownN, ownD
822     Set PackageModelView = created
End Function

Private Function PackageProjectedView(ByVal what As String, ByVal x As Double, ByVal y As Double) As Object
    Dim created As Object, source As Object
827     Set source = packageViews("base")
    stepLabel = currentIdentity & ": PackageProjectedView ClearSelection2"
829     doc.ClearSelection2 True
    stepLabel = currentIdentity & ": PackageProjectedView GetName2"
831     callInputs = "projected from " & source.GetName2() & " at(m)=" & NumberList(Array(x, y)) & ",0"
    stepLabel = currentIdentity & ": PackageProjectedView SelectByID2" & " " & apiInputs & " " & callInputs
833     If Not doc.Extension.SelectByID2(source.GetName2(), "DRAWINGVIEW", 0#, 0#, 0#, False, 0, Nothing, 0) Then Err.Raise 5, , "The base view could not be selected to project from: " & callInputs
    stepLabel = currentIdentity & ": PackageProjectedView CreateUnfoldedViewAt3" & " " & apiInputs & " " & callInputs
835     Set created = drawingInterface.CreateUnfoldedViewAt3(x, y, 0#, False)
836     Require created, "The " & what & " view was not created: " & callInputs
    stepLabel = currentIdentity & ": PackageProjectedView ClearSelection2"
838     doc.ClearSelection2 True
839     PackageCheckScale created, what, 0#, 0#
840     Set PackageProjectedView = created
End Function

Private Function PackageViewAxis(ByVal view As Object) As Long
    ' The model axis a view looks along, or -1 when it looks along none (a tilted view).
845     On Error Resume Next
846     PackageViewAxis = ViewDrop(view)
847     If Err.Number <> 0 Then
848         PackageViewAxis = -1
849         Err.Clear
    End If
End Function

Private Function PackageAxisText(ByVal axisIndex As Long) As String
854     If axisIndex >= 0 And axisIndex < 3 Then PackageAxisText = Mid$("XYZ", axisIndex + 1, 1) Else PackageAxisText = "no model axis"
End Function

Private Sub PackageDeleteView(ByVal view As Object)
    stepLabel = currentIdentity & ": PackageDeleteView GetName2"
859     callInputs = "delete " & view.GetName2()
    stepLabel = currentIdentity & ": PackageDeleteView ClearSelection2"
861     doc.ClearSelection2 True
    stepLabel = currentIdentity & ": PackageDeleteView SelectByID2" & " " & apiInputs & " " & callInputs
863     If Not doc.Extension.SelectByID2(view.GetName2(), "DRAWINGVIEW", 0#, 0#, 0#, False, 0, Nothing, 0) Then Err.Raise 5, , "The view could not be selected to delete it: " & callInputs
    stepLabel = currentIdentity & ": PackageDeleteView DeleteSelection2"
865     If Not doc.Extension.DeleteSelection2(swDelete_Absorbed) Then Err.Raise 5, , "The view could not be deleted: " & callInputs
    stepLabel = currentIdentity & ": PackageDeleteView ClearSelection2"
867     doc.ClearSelection2 True
End Sub

Private Function PackageViewSign(ByVal view As Object, ByVal axisIndex As Long) As Long
    ' Which side of the model the viewer is on along the axis (+1 or -1): the view's own z axis (toward the viewer) is column 2 of the rotation.
    Dim matrix As Variant
    stepLabel = currentIdentity & ": PackageViewSign ArrayData"
874     matrix = view.ModelToViewTransform.ArrayData
875     If CDbl(matrix(LBound(matrix) + 3 * axisIndex + 2)) > 0 Then PackageViewSign = 1 Else PackageViewSign = -1
End Function

Private Function PackageViewOk(ByVal view As Object, ByVal axisIndex As Long, ByVal signValue As Long) As Boolean
879     If PackageViewAxis(view) <> axisIndex Then Exit Function
880     If signValue <> 0 Then
881         If PackageViewSign(view, axisIndex) <> signValue Then Exit Function
    End If
883     PackageViewOk = True
End Function

Private Sub PackageBase(ByVal orientation As String, ByVal axisIndex As Long, ByVal acrossIndex As Long, ByVal upIndex As Long, ByVal fractionX As Double, ByVal fractionY As Double)
    Dim created As Object, found As Long, matrix As Variant, rightPart As Double, upPart As Double
888     Set created = PackageModelView(orientation, "base", fractionX * packageSheetW, fractionY * packageSheetH, 0#, 0#)
889     found = PackageViewAxis(created)
890     If found <> axisIndex Then Err.Raise 5, , "The base view " & orientation & " looks along " & PackageAxisText(found) & ", not " & PackageAxisText(axisIndex) & ": " & callInputs
    ' The sign, not only the axis: model +across must point to the right on the sheet and model +up must point up (the recipe's Z-up world).
    stepLabel = currentIdentity & ": PackageBase ArrayData"
893     matrix = created.ModelToViewTransform.ArrayData
894     rightPart = CDbl(matrix(LBound(matrix) + 3 * acrossIndex))
895     upPart = CDbl(matrix(LBound(matrix) + 3 * upIndex + 1))
896     If rightPart <= 0.5 Or upPart <= 0.5 Then Err.Raise 5, , "The base view " & orientation & " does not show the recipe's orientation: model +" & PackageAxisText(acrossIndex) & " has the x component " & NumberList(Array(rightPart)) & " and model +" & PackageAxisText(upIndex) & " the y component " & NumberList(Array(upPart)) & " on the sheet; they must be right and up: " & callInputs
897     Set packageViews("base") = created
898     packageOrder = "base"
    stepLabel = currentIdentity & ": PackageBase GetName2"
900     AppendLog currentFolder, currentIdentity, "option", 0, 0, "drawing: base view " & created.GetName2() & " " & orientation & " looks along " & PackageAxisText(found)
End Sub

Private Sub PackageProjected(ByVal direction As String, ByVal axisIndex As Long, ByVal signValue As Long, ByVal fractionX As Double, ByVal fractionY As Double, ByVal oppositeX As Double, ByVal oppositeY As Double)
    Dim created As Object, found As Long
905     Set created = PackageProjectedView(direction, fractionX * packageSheetW, fractionY * packageSheetH)
906     found = PackageViewAxis(created)
907     If Not PackageViewOk(created, axisIndex, signValue) Then
        ' A first-angle template puts the projected view on the other side: delete it and place it on the opposite side of the base view.
909         RecordMitigation "drawing-projection-opposite-side", True, True
    stepLabel = currentIdentity & ": PackageProjected GetName2"
911         AppendLog currentFolder, currentIdentity, "option", 0, 0, "drawing: the " & direction & " view " & created.GetName2() & " looks along " & PackageAxisText(found) & " with the viewer on another side than wanted (" & CStr(signValue) & " along " & PackageAxisText(axisIndex) & "); deleting it and projecting on the opposite side"
912         PackageDeleteView created
913         Set created = PackageProjectedView(direction, oppositeX * packageSheetW, oppositeY * packageSheetH)
914         found = PackageViewAxis(created)
915         If Not PackageViewOk(created, axisIndex, signValue) Then Err.Raise 5, , "The " & direction & " view looks along " & PackageAxisText(found) & ", not " & PackageAxisText(axisIndex) & " (viewer side " & CStr(signValue) & "), on either side of the base view: " & callInputs
916         fallbackSuccesses("drawing-projection-opposite-side") = fallbackSuccesses("drawing-projection-opposite-side") + 1
    End If
918     Set packageViews(direction) = created
919     packageOrder = packageOrder & "," & direction
    stepLabel = currentIdentity & ": PackageProjected GetName2"
921     AppendLog currentFolder, currentIdentity, "option", 0, 0, "drawing: " & direction & " view " & created.GetName2() & " looks along " & PackageAxisText(found)
End Sub

Private Sub PackageIso(ByVal numerator As Double, ByVal denominator As Double, ByVal fractionX As Double, ByVal fractionY As Double)
    Dim created As Object, ownN As Double, ownD As Double
926     If numerator * packageRatioD <> denominator * packageRatioN Then
927         ownN = numerator
928         ownD = denominator
    End If
930     Set created = PackageModelView("*Isometric", "iso", fractionX * packageSheetW, fractionY * packageSheetH, ownN, ownD)
    stepLabel = currentIdentity & ": PackageIso ArrayData"
932     If Not MatrixUsable(created.ModelToViewTransform.ArrayData) Then Err.Raise 5, , "The isometric view transform is not a rotation: " & callInputs
933     If PackageViewAxis(created) >= 0 Then Err.Raise 5, , "The isometric view is an axis-aligned view (it looks along " & PackageAxisText(PackageViewAxis(created)) & "): " & callInputs
934     Set packageViews("iso") = created
    stepLabel = currentIdentity & ": PackageIso GetName2"
936     AppendLog currentFolder, currentIdentity, "option", 0, 0, "drawing: isometric view " & created.GetName2() & " is not axis-aligned"
End Sub

Private Function PackageTryPlan(ByVal records As Collection, ByVal first As Variant, ByVal second As Variant) As Collection
    ' The dimension plan of a view, or Nothing when the two points coincide in that view (a view that looks along the line between them cannot show it).
    Dim failure As String, failureNumber As Long
942     On Error Resume Next
943     Set PackageTryPlan = DimensionPlan(records, first, second)
944     failureNumber = Err.Number
945     failure = Err.Description
946     Err.Clear
947     On Error GoTo 0
948     If failureNumber <> 0 Then
949         If InStr(1, failure, "coincide", vbTextCompare) = 0 Then Err.Raise failureNumber, , failure
950         Set PackageTryPlan = Nothing
    End If
End Function

Private Function PackageRung(ByVal plan As Collection) As String
    ' The mitigation name of a dimension made by a plan form D05a's plan does not make: the plan's records carry it (see dimension_rung in the Python twin).
    Dim k As Long
    stepLabel = currentIdentity & ": PackageRung Count"
958     For k = 1 To plan.Count
    stepLabel = currentIdentity & ": PackageRung Exists"
960         If plan(k).Exists("rung") Then
961             PackageRung = plan(k)("rung")
962             Exit Function
        End If
    Next k
End Function

Private Function PackageLastDimensionType(ByVal view As Object) As String
    ' swDimensionType_e of the view's last display dimension (IDisplayDimension.GetType), for the log; never a failure on its own.
    Dim display As Object, last As Object, failure As Long
970     On Error Resume Next
    stepLabel = currentIdentity & ": PackageLastDimensionType GetFirstDisplayDimension5"
972     Set display = view.GetFirstDisplayDimension5()
973     Do While Not display Is Nothing
974         Set last = display
    stepLabel = currentIdentity & ": PackageLastDimensionType GetNext3"
976         Set display = display.GetNext3()
    Loop
    stepLabel = currentIdentity & ": PackageLastDimensionType GetType"
979     If Not last Is Nothing Then PackageLastDimensionType = CStr(last.GetType())
980     failure = Err.Number
981     Err.Clear
982     On Error GoTo 0
983     If failure <> 0 Or last Is Nothing Then PackageLastDimensionType = "unreadable"
End Function

Private Sub PackageDimension(ByVal valueMm As Double, ByVal firstMm As Variant, ByVal secondMm As Variant)
    Dim first As Variant, second As Variant, labels As Variant, k As Long, key As String, plan As Collection, chosen As String
    Dim activeView As Object, outline As Variant, measured As Double, text As String, drop As Long, spaceName As String, index As Long, rung As String, failure As String, failureNumber As Long, found As Long, stopAt As Long
989     index = packageDimCount
990     packageDimCount = packageDimCount + 1
991     If index = 0 Then
992         ReDim packageValues(0)
    Else
994         ReDim Preserve packageValues(index)
    End If
996     packageValues(index) = valueMm
997     first = Array(CDbl(firstMm(0)) * 0.001, CDbl(firstMm(1)) * 0.001, CDbl(firstMm(2)) * 0.001)
998     second = Array(CDbl(secondMm(0)) * 0.001, CDbl(secondMm(1)) * 0.001, CDbl(secondMm(2)) * 0.001)
999     labels = Split(packageOrder, ",")
1000     For k = 0 To UBound(labels)
1001         key = CStr(labels(k))
    stepLabel = currentIdentity & ": PackageDimension Exists"
1003         If Not packageRecords.Exists(key) Then
1004             Set activeView = packageViews(key)
1005             Set packageRecords(key) = DrawingEdges(activeView, packageLow, packageHigh, drop, spaceName, packageComponents)
1006             packageDrops(key) = drop
1007             packageSpaces(key) = spaceName
        End If
1009         Set plan = PackageTryPlan(packageRecords(key), FlatPoint(first, packageDrops(key)), FlatPoint(second, packageDrops(key)))
1010         If Not plan Is Nothing Then
1011             chosen = key
1012             Exit For
        End If
    Next k
1015     If Len(chosen) = 0 Then Err.Raise 5, , "No view shows the edges for the " & NumberList(Array(valueMm)) & " dimension between " & NumberList(firstMm) & " and " & NumberList(secondMm) & " (mm)"
1016     Set activeView = packageViews(chosen)
    stepLabel = currentIdentity & ": PackageDimension GetOutline"
1018     outline = activeView.GetOutline()
1019     rung = PackageRung(plan)
1020     If Len(rung) > 0 Then RecordMitigation rung, True, True
1021     On Error Resume Next
1022     measured = AddDrawingDimension(activeView, plan, IIf(outline(0) > outline(2), outline(0), outline(2)) + PACKAGE_TEXT_STEP * (index + 1), IIf(outline(1) > outline(3), outline(1), outline(3)) + PACKAGE_TEXT_STEP * (index + 1), valueMm, "dimension " & CStr(index + 1))
1023     failureNumber = Err.Number
1024     failure = Err.Description
1025     Err.Clear
1026     On Error GoTo 0
1027     If failureNumber <> 0 Then
1028         found = InStr(1, failure, "measured ", vbTextCompare)
1029         stopAt = 0
1030         If found > 0 Then stopAt = InStr(found, failure, " mm, not", vbTextCompare)
        ' " mm, not" absent (or before the number): a negative length would raise Err 5 here, so the failure goes out as it is.
1032         If rung = "drawing-dimension-edge-on-circles" And found > 0 And stopAt > found + 9 Then
1033             Err.Raise failureNumber, , "edge-on circles: SolidWorks measured " & Mid$(failure, found + 9, stopAt - found - 9) & " mm, not center to center (" & NumberList(Array(valueMm)) & " mm): " & failure
        End If
1035         Err.Raise failureNumber, , failure
    End If
1037     If Len(rung) > 0 Then fallbackSuccesses(rung) = fallbackSuccesses(rung) + 1
1038     If rung = "drawing-dimension-edge-on-circles" Then
        ' What SolidWorks reported, raw, so a first real run shows what happened: each circle's CircleParams (center, axis, radius), how many edges were
        ' selected and the type of the dimension SolidWorks made.
    stepLabel = currentIdentity & ": PackageDimension Count"
1042         For k = 1 To plan.Count
1043             If plan(k)("kind") = "circle" Then text = text & "; circle " & CStr(k) & " CircleParams " & NumberList(plan(k)("raw"))
        Next k
    stepLabel = currentIdentity & ": PackageDimension Count"
1046         AppendLog currentFolder, currentIdentity, "option", 0, 0, "edge-on circles: " & Mid$(text, 3) & "; " & CStr(plan.Count) & " edges selected; dimension type (swDimensionType_e) " & PackageLastDimensionType(activeView)
1047         text = ""
    End If
    stepLabel = currentIdentity & ": PackageDimension Count"
1050     For k = 0 To plan.Count - 1
1051         If k > 0 Then text = text & " + "
1052         text = text & plan(k + 1)("kind")
    Next k
    stepLabel = currentIdentity & ": PackageDimension GetName2"
1055     AppendLog currentFolder, currentIdentity, "option", 0, 0, "drawing dimension " & NumberList(Array(valueMm)) & ": " & chosen & " view " & activeView.GetName2() & ", " & text & ", entity coordinates were " & packageSpaces(chosen) & " coordinates, measured " & Replace(Format$(measured, "0.000000"), ",", ".") & " mm"
End Sub

Private Function PackageBoxFits(ByVal matrix As Variant, ByVal outline As Variant) As Boolean
    ' Every corner of the model box, mapped through the matrix, lies inside the view's outline (within SECTION_TOLERANCE).
    Dim a As Long, b As Long, c As Long, p As Variant
    Dim leftEdge As Double, rightEdge As Double, bottomEdge As Double, topEdge As Double
1062     leftEdge = IIf(outline(0) < outline(2), outline(0), outline(2))
1063     rightEdge = IIf(outline(0) > outline(2), outline(0), outline(2))
1064     bottomEdge = IIf(outline(1) < outline(3), outline(1), outline(3))
1065     topEdge = IIf(outline(1) > outline(3), outline(1), outline(3))
1066     For a = 0 To 1
1067         For b = 0 To 1
1068             For c = 0 To 1
1069                 p = MatrixPoint(matrix, CDbl(IIf(a = 0, packageLow(0), packageHigh(0))), CDbl(IIf(b = 0, packageLow(1), packageHigh(1))), CDbl(IIf(c = 0, packageLow(2), packageHigh(2))))
1070                 If p(0) < leftEdge - SECTION_TOLERANCE Or p(0) > rightEdge + SECTION_TOLERANCE Or p(1) < bottomEdge - SECTION_TOLERANCE Or p(1) > topEdge + SECTION_TOLERANCE Then Exit Function
            Next c
        Next b
    Next a
1074     PackageBoxFits = True
End Function

Private Function PackageFitMatrix(ByVal matrix As Variant, ByVal outline As Variant, ByVal scaleFactor As Double) As Variant
    ' The view's rotation, the given scale, and the translation that puts the model box center at the center of the view's outline.
    Dim first As Long, rotation As Variant, rotated As Variant
1080     first = LBound(matrix)
1081     rotation = Array(matrix(first), matrix(first + 1), matrix(first + 2), matrix(first + 3), matrix(first + 4), matrix(first + 5), matrix(first + 6), matrix(first + 7), matrix(first + 8), 0#, 0#, 0#, scaleFactor)
1082     rotated = MatrixPoint(rotation, (CDbl(packageLow(0)) + CDbl(packageHigh(0))) / 2, (CDbl(packageLow(1)) + CDbl(packageHigh(1))) / 2, (CDbl(packageLow(2)) + CDbl(packageHigh(2))) / 2)
1083     PackageFitMatrix = Array(matrix(first), matrix(first + 1), matrix(first + 2), matrix(first + 3), matrix(first + 4), matrix(first + 5), matrix(first + 6), matrix(first + 7), matrix(first + 8), (outline(0) + outline(2)) / 2 - rotated(0), (outline(1) + outline(3)) / 2 - rotated(1), 0#, scaleFactor)
End Function

Private Sub PackageSection(ByVal letter As String, ByVal cutAxis As Long, ByVal lineAxis As Long, ByVal vertical As Boolean, ByVal coordinate As Double, ByVal fractionX As Double, ByVal fractionY As Double)
    ' A section view from a line drawn in the base view, in sheet coordinates: the model points of the line go through the base view's
    ' ModelToViewTransform (model meters to sheet meters, scale and position included) and the line is extended past the view's outline.
    Dim source As Object, created As Object, segment As Object, sectionData As Object, matrix As Variant, outline As Variant
    Dim middle(2) As Double, endPoint(1) As Variant, point(2) As Double
    Dim leftEdge As Double, rightEdge As Double, bottomEdge As Double, topEdge As Double
    Dim firstX As Double, firstY As Double, secondX As Double, secondY As Double, placeX As Double, placeY As Double
    Dim i As Long, found As Long, side As Long, labelText As String, fitted As Variant, readText As String
    Dim sketchLine As Object, lineStart As Object, lineEnd As Object
1095     Set source = packageViews("base")
    stepLabel = currentIdentity & ": PackageSection ArrayData"
1097     matrix = source.ModelToViewTransform.ArrayData
1098     For i = 0 To 2
1099         middle(i) = (CDbl(packageLow(i)) + CDbl(packageHigh(i))) / 2
    Next i
    stepLabel = currentIdentity & ": PackageSection GetOutline"
1102     outline = source.GetOutline()
1103     leftEdge = IIf(outline(0) < outline(2), outline(0), outline(2))
1104     rightEdge = IIf(outline(0) > outline(2), outline(0), outline(2))
1105     bottomEdge = IIf(outline(1) < outline(3), outline(1), outline(3))
1106     topEdge = IIf(outline(1) > outline(3), outline(1), outline(3))
1107     If PackageBoxFits(matrix, outline) Then
1108         AppendLog currentFolder, currentIdentity, "option", 0, 0, "drawing: section line mapped through the base view transform (the model box lands inside the outline " & NumberList(outline) & ")"
    Else
        ' The transform does not map model meters to sheet meters (it may be view-local): the mapping is derived from the outline instead. Its rotation
        ' is the transform's, its scale the view's own, and its translation puts the model box center at the center of the outline.
1112         RecordMitigation "drawing-section-outline-fit", True, True
    stepLabel = currentIdentity & ": PackageSection ScaleDecimal"
1114         fitted = PackageFitMatrix(matrix, outline, CDbl(source.ScaleDecimal))
1115         AppendLog currentFolder, currentIdentity, "option", 0, 0, "drawing: the base view transform puts the model box outside the outline " & NumberList(outline) & "; mapping from the outline instead: rotation of the transform, scale " & NumberList(Array(fitted(12))) & " (the view's), translation " & NumberList(Array(fitted(9), fitted(10))) & " m"
1116         If Not PackageBoxFits(fitted, outline) Then Err.Raise 5, , "The model box does not land inside the view outline " & NumberList(outline) & " even when mapped from it: the section line cannot be placed"
1117         matrix = fitted
1118         fallbackSuccesses("drawing-section-outline-fit") = fallbackSuccesses("drawing-section-outline-fit") + 1
    End If
1120     For side = 0 To 1
1121         For i = 0 To 2
1122             point(i) = middle(i)
        Next i
1124         point(cutAxis) = coordinate * 0.001
1125         point(lineAxis) = IIf(side = 0, packageLow(lineAxis), packageHigh(lineAxis))
1126         endPoint(side) = MatrixPoint(matrix, point(0), point(1), point(2))
    Next side
1128     If vertical Then
1129         If Abs(endPoint(0)(0) - endPoint(1)(0)) > 0.000000001 Then Err.Raise 5, , "The " & letter & " section line is not vertical in the base view (its ends are at x = " & NumberList(Array(endPoint(0)(0), endPoint(1)(0))) & " m)"
1130         firstX = endPoint(0)(0)
1131         secondX = endPoint(0)(0)
1132         firstY = bottomEdge - SECTION_MARGIN
1133         secondY = topEdge + SECTION_MARGIN
    Else
1135         If Abs(endPoint(0)(1) - endPoint(1)(1)) > 0.000000001 Then Err.Raise 5, , "The " & letter & " section line is not horizontal in the base view (its ends are at y = " & NumberList(Array(endPoint(0)(1), endPoint(1)(1))) & " m)"
1136         firstX = leftEdge - SECTION_MARGIN
1137         secondX = rightEdge + SECTION_MARGIN
1138         firstY = endPoint(0)(1)
1139         secondY = endPoint(0)(1)
    End If
1141     placeX = fractionX * packageSheetW
1142     placeY = fractionY * packageSheetH
    stepLabel = currentIdentity & ": PackageSection GetName2"
1144     callInputs = "section " & letter & " line(m)=" & NumberList(Array(firstX, firstY, secondX, secondY)) & " in " & source.GetName2() & ", cut normal " & PackageAxisText(cutAxis) & ", view at(m)=" & NumberList(Array(placeX, placeY))
    stepLabel = currentIdentity & ": PackageSection ActivateView"
1146     If Not drawingInterface.ActivateView(source.GetName2()) Then Err.Raise 5, , "ActivateView failed: " & callInputs
    stepLabel = currentIdentity & ": PackageSection ClearSelection2"
1148     doc.ClearSelection2 True
    stepLabel = currentIdentity & ": PackageSection CreateLine" & " " & apiInputs & " " & callInputs
1150     Set segment = doc.SketchManager.CreateLine(firstX, firstY, 0#, secondX, secondY, 0#)
1151     Require segment, "The section line was not created: " & callInputs
    ' The end points as SolidWorks reports them, logged beside the ones asked for (never a failure on its own: it tells whether a view's sketch takes sheet coordinates).
1153     readText = ""
1154     On Error Resume Next
1155     Set sketchLine = segment
    stepLabel = currentIdentity & ": PackageSection GetStartPoint2"
1157     Set lineStart = sketchLine.GetStartPoint2()
    stepLabel = currentIdentity & ": PackageSection GetEndPoint2"
1159     Set lineEnd = sketchLine.GetEndPoint2()
    stepLabel = currentIdentity & ": PackageSection X"
1161     readText = NumberList(Array(lineStart.X, lineStart.Y, lineEnd.X, lineEnd.Y))
1162     If Err.Number <> 0 Then
1163         readText = ""
1164         Err.Clear
    End If
1166     On Error GoTo 0
1167     If Len(readText) = 0 Then
1168         AppendLog currentFolder, currentIdentity, "option", 0, 0, "drawing: section line end points could not be read back"
    Else
1170         AppendLog currentFolder, currentIdentity, "option", 0, 0, "drawing: section line asked at(m)=" & NumberList(Array(firstX, firstY, secondX, secondY)) & ", SolidWorks reports " & readText
    End If
    stepLabel = currentIdentity & ": PackageSection GetSelectedObjectCount2"
1173     If doc.SelectionManager.GetSelectedObjectCount2(-1) <> 1 Then
        ' The new line is normally still selected; when it is not, select it.
1175         RecordMitigation "drawing-section-line-reselect", True, True
    stepLabel = currentIdentity & ": PackageSection ClearSelection2"
1177         doc.ClearSelection2 True
    stepLabel = currentIdentity & ": PackageSection Select4" & " " & apiInputs & " " & callInputs
1179         If Not segment.Select4(False, doc.SelectionManager.CreateSelectData()) Then Err.Raise 5, , "The section line could not be selected: " & callInputs
    stepLabel = currentIdentity & ": PackageSection GetSelectedObjectCount2"
1181         If doc.SelectionManager.GetSelectedObjectCount2(-1) <> 1 Then Err.Raise 5, , CStr(doc.SelectionManager.GetSelectedObjectCount2(-1)) & " objects are selected, not the one section line: " & callInputs
1182         fallbackSuccesses("drawing-section-line-reselect") = fallbackSuccesses("drawing-section-line-reselect") + 1
    End If
    stepLabel = currentIdentity & ": PackageSection CreateSectionViewAt5" & " " & apiInputs & " " & callInputs
1185     Set created = drawingInterface.CreateSectionViewAt5(placeX, placeY, 0#, letter, 0, Nothing, 0#)
1186     Require created, "CreateSectionViewAt5 returned no view: " & callInputs
    stepLabel = currentIdentity & ": PackageSection ClearSelection2"
1188     doc.ClearSelection2 True
1189     PackageCheckScale created, "section", 0#, 0#
1190     found = PackageViewAxis(created)
    stepLabel = currentIdentity & ": PackageSection GetName2"
1192     If found <> cutAxis Then Err.Raise 5, , "The section view " & created.GetName2() & " looks along " & PackageAxisText(found) & ", not along the cut normal " & PackageAxisText(cutAxis) & ": " & callInputs
    stepLabel = currentIdentity & ": PackageSection GetSection"
1194     Set sectionData = created.GetSection()
1195     Require sectionData, "IView.GetSection returned no section data for the new view: " & callInputs
    stepLabel = currentIdentity & ": PackageSection GetLabel"
1197     labelText = CStr(sectionData.GetLabel())
1198     If UCase$(Trim$(labelText)) <> letter Then Err.Raise 5, , "The section view reads back the label " & labelText & ", not " & letter & ": " & callInputs
1199     Set packageViews("section") = created
    stepLabel = currentIdentity & ": PackageSection GetName2"
1201     AppendLog currentFolder, currentIdentity, "option", 0, 0, "drawing: section view " & created.GetName2() & ", label " & labelText & ", looks along " & PackageAxisText(found)
End Sub

Private Sub PackageFinish()
    ' Every display dimension in the drawing, read from the drawing, must be exactly the recipe's.
    Dim listing As String
1207     If packageDimCount = 0 Then listing = DrawingReadBack(Array()) Else listing = DrawingReadBack(packageValues)
1208     If Len(listing) = 0 Then listing = "no dimensions"
1209     AppendLog currentFolder, currentIdentity, "option", 0, 0, "drawing read-back: " & listing
End Sub

Private Sub PackageProperty(ByVal propertyName As String, ByVal propertyText As String)
    ' One title block field as a drawing custom property, set after the privacy blanking and read back.
    Dim manager As Object, valueText As String, resolvedText As String, wasResolved As Boolean
1215     callInputs = "property=" & propertyName
    stepLabel = currentIdentity & ": PackageProperty CustomPropertyManager"
1217     Set manager = doc.Extension.CustomPropertyManager("")
    stepLabel = currentIdentity & ": PackageProperty Add3"
1219     If manager.Add3(propertyName, swCustomInfoText, propertyText, swCustomPropertyReplaceValue) <> 0 Then Err.Raise 5, , "The title block property could not be set: " & callInputs
    stepLabel = currentIdentity & ": PackageProperty Get5"
1221     If manager.Get5(propertyName, False, valueText, resolvedText, wasResolved) = swCustomInfoGetResult_NotPresent Or (valueText <> propertyText And resolvedText <> propertyText) Then
1222         Err.Raise 5, , "The title block property reads back " & valueText & ", not " & propertyText & ": " & callInputs
    End If
1224     packageTitle(propertyName) = propertyText
End Sub

Private Sub PackageTitleCheck()
    ' A look at the title block's own notes: never claims the text is shown on the sheet when the notes do not show it.
    Dim titleBlock As Object, notes As Variant, noteItem As Variant, key As Variant, shown As Boolean, found As Boolean, names As String
1230     shown = False
1231     On Error Resume Next
    stepLabel = currentIdentity & ": PackageTitleCheck TitleBlock"
1233     Set titleBlock = packageSheetObject.TitleBlock
1234     If Err.Number <> 0 Then
1235         Err.Clear
1236         Set titleBlock = Nothing
    End If
1238     If Not titleBlock Is Nothing Then
    stepLabel = currentIdentity & ": PackageTitleCheck GetNotes"
1240         notes = titleBlock.GetNotes()
1241         If Err.Number <> 0 Then
1242             Err.Clear
1243             notes = Empty
        End If
    End If
1246     On Error GoTo 0
1247     If Not titleBlock Is Nothing Then
1248         shown = True
    stepLabel = currentIdentity & ": PackageTitleCheck Keys"
1250         For Each key In packageTitle.Keys
1251             found = False
1252             If IsArray(notes) Then
1253                 For Each noteItem In notes
    stepLabel = currentIdentity & ": PackageTitleCheck GetText"
1255                     If InStr(1, CStr(noteItem.GetText()), CStr(packageTitle(key)), vbBinaryCompare) > 0 Then found = True
                Next noteItem
            End If
1258             If Not found Then shown = False
        Next key
    End If
    stepLabel = currentIdentity & ": PackageTitleCheck Keys"
1262     For Each key In packageTitle.Keys
1263         If Len(names) > 0 Then names = names & ", "
1264         names = names & CStr(key)
    Next key
1266     If Not shown Then
        ' The properties are set and read back; the sheet's title block does not show their text (no title block, or one that does not link them).
1268         RecordMitigation "title-block-property-only", True, True
1269         fallbackSuccesses("title-block-property-only") = fallbackSuccesses("title-block-property-only") + 1
1270         AppendLog currentFolder, currentIdentity, "option", 0, 0, "title block: the properties " & names & " are set and read back; the sheet's title block notes do not show their text, so it is not claimed as shown"
    Else
1272         AppendLog currentFolder, currentIdentity, "option", 0, 0, "title block: the properties " & names & " are set, read back, and shown in the title block notes"
    End If
End Sub

Private Function PackageCount() As Long
1277     PackageCount = 10
End Function

Private Function PackageId(ByVal index As Long) As String
1281     Select Case index
        Case 0: PackageId = "D10a"
        Case 1: PackageId = "D11a"
        Case 2: PackageId = "D12a"
        Case 3: PackageId = "D13a"
        Case 4: PackageId = "D14a"
        Case 5: PackageId = "D15a"
        Case 6: PackageId = "D16a"
        Case 7: PackageId = "D17a"
        Case 8: PackageId = "D18a"
        Case 9: PackageId = "D19a"
    End Select
End Function

Private Function PackageModel(ByVal index As Long) As String
1296     Select Case index
        Case 0: PackageModel = "F04a"
        Case 1: PackageModel = "D04a"
        Case 2: PackageModel = "D06a"
        Case 3: PackageModel = "P03a"
        Case 4: PackageModel = "P03b"
        Case 5: PackageModel = "P07a"
        Case 6: PackageModel = "P08a"
        Case 7: PackageModel = "P06a"
        Case 8: PackageModel = "P06b"
        Case 9: PackageModel = "F10a"
    End Select
End Function

Private Function PackageExtension(ByVal index As Long) As String
    ' the model's file extension: .sldasm for an assembly (a parts list is read back from its components), else .sldprt
1312     PackageExtension = ".sldprt"
1313     Select Case index
        Case 9: PackageExtension = ".sldasm"
    End Select
End Function

Private Function PackageDocType(ByVal index As Long) As Long
1319     PackageDocType = swDocPART
1320     If PackageExtension(index) = ".sldasm" Then PackageDocType = swDocASSEMBLY
End Function

Private Function PackageState(ByVal index As Long) As Long
    ' 0 drawn, 1 not scripted (PackageReason says why)
1325     Select Case index
        Case 0: PackageState = 0
        Case 1: PackageState = 0
        Case 2: PackageState = 0
        Case 3: PackageState = 0
        Case 4: PackageState = 0
        Case 5: PackageState = 0
        Case 6: PackageState = 0
        Case 7: PackageState = 0
        Case 8: PackageState = 0
        Case 9: PackageState = 0
    End Select
End Function

Private Function PackageReason(ByVal index As Long) As String
1340     Select Case index
    End Select
End Function

Private Sub BuildPackage(ByVal index As Long)
1345     Select Case index
        Case 0: BuildPackage0
        Case 1: BuildPackage1
        Case 2: BuildPackage2
        Case 3: BuildPackage3
        Case 4: BuildPackage4
        Case 5: BuildPackage5
        Case 6: BuildPackage6
        Case 7: BuildPackage7
        Case 8: BuildPackage8
        Case 9: BuildPackage9
    End Select
End Sub

Private Sub BuildPackageTitle(ByVal index As Long)
1360     Select Case index
        Case 0: BuildPackageTitle0
        Case 1: BuildPackageTitle1
        Case 2: BuildPackageTitle2
        Case 3: BuildPackageTitle3
        Case 4: BuildPackageTitle4
        Case 5: BuildPackageTitle5
        Case 6: BuildPackageTitle6
        Case 7: BuildPackageTitle7
        Case 8: BuildPackageTitle8
        Case 9: BuildPackageTitle9
    End Select
End Sub

Private Sub BuildPackage0()
1375     PackageStart "F04a.sldprt", Array(-10.0#, -15.0#, 0.0#), Array(10.0#, 15.0#, 10.0#)
1376     PackageSheet 2, 0, 6, 0.297#, 0.21#, 1.0#, 1.0#
1377     PackageBase "*Bottom", 1, 0, 2, 0.34#, 0.45#
1378     PackageProjected "beside", 0, 1, 0.57#, 0.45#, 0.1#, 0.45#
1379     PackageProjected "vertical", 2, 1, 0.34#, 0.8#, 0.34#, 0.12#
1380     PackageIso 1.0#, 2.0#, 0.83#, 0.2#
1381     PackageDimension 20.0#, Array(-10.0#, -15.0#, 10.0#), Array(10.0#, -15.0#, 10.0#)
1382     PackageDimension 30.0#, Array(-10.0#, -15.0#, 10.0#), Array(-10.0#, 15.0#, 10.0#)
1383     PackageDimension 10.0#, Array(10.0#, -15.0#, 0.0#), Array(10.0#, -15.0#, 10.0#)
1384     PackageDimension 10.0#, Array(-10.0#, 0.0#, 10.0#), Array(0.0#, 0.0#, 10.0#)
1385     PackageDimension 15.0#, Array(0.0#, -15.0#, 10.0#), Array(0.0#, 0.0#, 10.0#)
1386     PackageSection "A", 0, 2, True, 0.0#, 0.83#, 0.65#
End Sub

Private Sub BuildPackageTitle0()
1390     PackageProperty "Title", "F04a drawing"
1391     PackageProperty "DrawnBy", "Fixture Builder"
1392     PackageTitleCheck
End Sub

Private Sub BuildPackage1()
1396     PackageStart "D04a.sldprt", Array(0.0#, 0.0#, 0.0#), Array(40.0#, 30.0#, 30.0#)
1397     PackageSheet 2, 0, 6, 0.297#, 0.21#, 1.0#, 1.0#
1398     PackageBase "*Bottom", 1, 0, 2, 0.34#, 0.45#
1399     PackageProjected "beside", 0, 1, 0.57#, 0.45#, 0.1#, 0.45#
1400     PackageProjected "vertical", 2, 1, 0.34#, 0.8#, 0.34#, 0.12#
1401     PackageIso 1.0#, 2.0#, 0.83#, 0.2#
1402     PackageDimension 40.0#, Array(0.0#, 0.0#, 0.0#), Array(40.0#, 0.0#, 0.0#)
1403     PackageDimension 30.0#, Array(0.0#, 0.0#, 0.0#), Array(0.0#, 0.0#, 30.0#)
1404     PackageDimension 5.0#, Array(40.0#, 0.0#, 0.0#), Array(40.0#, 0.0#, 5.0#)
1405     PackageDimension 25.0#, Array(0.0#, 15.0#, 5.0#), Array(25.0#, 15.0#, 5.0#)
1406     PackageSection "A", 0, 2, True, 25.0#, 0.83#, 0.65#
End Sub

Private Sub BuildPackageTitle1()
1410     PackageProperty "Title", "D04a drawing"
1411     PackageProperty "DrawnBy", "Fixture Builder"
1412     PackageTitleCheck
End Sub

Private Sub BuildPackage2()
1416     PackageStart "D06a.sldprt", Array(0.0#, 0.0#, 0.0#), Array(60.0#, 40.0#, 10.0#)
1417     PackageSheet 2, 0, 6, 0.297#, 0.21#, 1.0#, 1.0#
1418     PackageBase "*Bottom", 1, 0, 2, 0.34#, 0.45#
1419     PackageProjected "beside", 0, 1, 0.57#, 0.45#, 0.1#, 0.45#
1420     PackageProjected "vertical", 2, 1, 0.34#, 0.8#, 0.34#, 0.12#
1421     PackageIso 1.0#, 2.0#, 0.83#, 0.2#
1422     PackageDimension 60.0#, Array(0.0#, 0.0#, 0.0#), Array(60.0#, 0.0#, 0.0#)
1423     PackageDimension 40.0#, Array(0.0#, 0.0#, 10.0#), Array(0.0#, 40.0#, 10.0#)
1424     PackageDimension 10.0#, Array(60.0#, 0.0#, 0.0#), Array(60.0#, 0.0#, 10.0#)
1425     PackageDimension 20.0#, Array(0.0#, 20.0#, 10.0#), Array(20.0#, 20.0#, 10.0#)
1426     PackageDimension 20.0#, Array(60.0#, 0.0#, 10.0#), Array(60.0#, 20.0#, 10.0#)
1427     PackageSection "A", 0, 2, True, 20.0#, 0.83#, 0.65#
End Sub

Private Sub BuildPackageTitle2()
1431     PackageProperty "Title", "D06a drawing"
1432     PackageProperty "DrawnBy", "Fixture Builder"
1433     PackageTitleCheck
End Sub

Private Sub BuildPackage3()
1437     PackageStart "P03a.sldprt", Array(-10.0#, -15.0#, 0.0#), Array(10.0#, 15.0#, 10.0#)
1438     PackageSheet 2, 0, 6, 0.297#, 0.21#, 1.0#, 1.0#
1439     PackageBase "*Bottom", 1, 0, 2, 0.34#, 0.45#
1440     PackageProjected "beside", 0, 1, 0.57#, 0.45#, 0.1#, 0.45#
1441     PackageProjected "vertical", 2, 1, 0.34#, 0.8#, 0.34#, 0.12#
1442     PackageIso 1.0#, 2.0#, 0.83#, 0.2#
1443     PackageDimension 20.0#, Array(-10.0#, -15.0#, 10.0#), Array(10.0#, -15.0#, 10.0#)
1444     PackageDimension 30.0#, Array(-10.0#, -15.0#, 10.0#), Array(-10.0#, 15.0#, 10.0#)
1445     PackageDimension 10.0#, Array(10.0#, -15.0#, 0.0#), Array(10.0#, -15.0#, 10.0#)
1446     PackageDimension 10.0#, Array(-10.0#, 0.0#, 10.0#), Array(0.0#, 0.0#, 10.0#)
1447     PackageDimension 15.0#, Array(0.0#, -15.0#, 10.0#), Array(0.0#, 0.0#, 10.0#)
1448     PackageSection "A", 0, 2, True, 0.0#, 0.83#, 0.65#
End Sub

Private Sub BuildPackageTitle3()
1452     PackageProperty "Title", "P03a drawing"
1453     PackageProperty "DrawnBy", "Fixture Builder"
1454     PackageTitleCheck
End Sub

Private Sub BuildPackage4()
1458     PackageStart "P03b.sldprt", Array(-10.0#, -15.0#, 0.0#), Array(10.0#, 15.0#, 10.0#)
1459     PackageSheet 2, 0, 6, 0.297#, 0.21#, 1.0#, 1.0#
1460     PackageBase "*Bottom", 1, 0, 2, 0.34#, 0.45#
1461     PackageProjected "beside", 0, 1, 0.57#, 0.45#, 0.1#, 0.45#
1462     PackageProjected "vertical", 2, 1, 0.34#, 0.8#, 0.34#, 0.12#
1463     PackageIso 1.0#, 2.0#, 0.83#, 0.2#
1464     PackageDimension 20.0#, Array(-10.0#, -15.0#, 10.0#), Array(10.0#, -15.0#, 10.0#)
1465     PackageDimension 30.0#, Array(-10.0#, -15.0#, 10.0#), Array(-10.0#, 15.0#, 10.0#)
1466     PackageDimension 10.0#, Array(10.0#, -15.0#, 0.0#), Array(10.0#, -15.0#, 10.0#)
1467     PackageDimension 10.0#, Array(-10.0#, 0.0#, 10.0#), Array(0.0#, 0.0#, 10.0#)
1468     PackageDimension 15.0#, Array(0.0#, -15.0#, 10.0#), Array(0.0#, 0.0#, 10.0#)
1469     PackageSection "A", 0, 2, True, 0.0#, 0.83#, 0.65#
End Sub

Private Sub BuildPackageTitle4()
1473     PackageProperty "Title", "P03b drawing"
1474     PackageProperty "DrawnBy", "Fixture Builder"
1475     PackageTitleCheck
End Sub

Private Sub BuildPackage5()
1479     PackageStart "P07a.sldprt", Array(0.0#, 0.0#, 0.0#), Array(60.0#, 40.0#, 5.0#)
1480     PackageSheet 2, 0, 6, 0.297#, 0.21#, 1.0#, 1.0#
1481     PackageBase "*Bottom", 1, 0, 2, 0.34#, 0.45#
1482     PackageProjected "beside", 0, 1, 0.57#, 0.45#, 0.1#, 0.45#
1483     PackageProjected "vertical", 2, 1, 0.34#, 0.8#, 0.34#, 0.12#
1484     PackageIso 1.0#, 2.0#, 0.83#, 0.2#
1485     PackageDimension 60.0#, Array(0.0#, 0.0#, 5.0#), Array(60.0#, 0.0#, 5.0#)
1486     PackageDimension 40.0#, Array(0.0#, 0.0#, 5.0#), Array(0.0#, 40.0#, 5.0#)
1487     PackageDimension 5.0#, Array(60.0#, 0.0#, 0.0#), Array(60.0#, 0.0#, 5.0#)
1488     PackageDimension 5.0#, Array(0.0#, 5.0#, 5.0#), Array(5.0#, 5.0#, 5.0#)
1489     PackageDimension 10.0#, Array(5.0#, 5.0#, 5.0#), Array(15.0#, 5.0#, 5.0#)
1490     PackageDimension 10.0#, Array(5.0#, 5.0#, 5.0#), Array(5.0#, 15.0#, 5.0#)
1491     PackageSection "A", 0, 2, True, 5.0#, 0.83#, 0.65#
End Sub

Private Sub BuildPackageTitle5()
1495     PackageProperty "Title", "P07a drawing"
1496     PackageProperty "DrawnBy", "Fixture Builder"
1497     PackageTitleCheck
End Sub

Private Sub BuildPackage6()
1501     PackageStart "P08a.sldprt", Array(-30.0#, -30.0#, 0.0#), Array(30.0#, 30.0#, 5.0#)
1502     PackageSheet 2, 0, 6, 0.297#, 0.21#, 1.0#, 1.0#
1503     PackageBase "*Bottom", 1, 0, 2, 0.34#, 0.45#
1504     PackageProjected "beside", 0, 1, 0.57#, 0.45#, 0.1#, 0.45#
1505     PackageProjected "vertical", 2, 1, 0.34#, 0.8#, 0.34#, 0.12#
1506     PackageIso 1.0#, 2.0#, 0.83#, 0.2#
1507     PackageDimension 60.0#, Array(-30.0#, 0.0#, 5.0#), Array(30.0#, 0.0#, 5.0#)
1508     PackageDimension 5.0#, Array(30.0#, 0.0#, 0.0#), Array(30.0#, 0.0#, 5.0#)
1509     PackageDimension 20.0#, Array(0.0#, 0.0#, 5.0#), Array(20.0#, 0.0#, 5.0#)
1510     PackageDimension 40.0#, Array(-20.0#, 0.0#, 5.0#), Array(20.0#, 0.0#, 5.0#)
1511     PackageSection "A", 0, 2, True, 20.0#, 0.83#, 0.65#
End Sub

Private Sub BuildPackageTitle6()
1515     PackageProperty "Title", "P08a drawing"
1516     PackageProperty "DrawnBy", "Fixture Builder"
1517     PackageTitleCheck
End Sub

Private Sub BuildPackage7()
1521     PackageStart "P06a.sldprt", Array(-10.0#, -15.0#, 0.0#), Array(10.0#, 15.0#, 10.0#)
1522     PackageSheet 2, 0, 6, 0.297#, 0.21#, 1.0#, 1.0#
1523     PackageBase "*Bottom", 1, 0, 2, 0.34#, 0.45#
1524     PackageProjected "beside", 0, 1, 0.57#, 0.45#, 0.1#, 0.45#
1525     PackageProjected "vertical", 2, 1, 0.34#, 0.8#, 0.34#, 0.12#
1526     PackageIso 1.0#, 2.0#, 0.83#, 0.2#
1527     PackageDimension 20.0#, Array(-10.0#, -15.0#, 10.0#), Array(10.0#, -15.0#, 10.0#)
1528     PackageDimension 30.0#, Array(-10.0#, -15.0#, 10.0#), Array(-10.0#, 15.0#, 10.0#)
1529     PackageDimension 10.0#, Array(10.0#, -15.0#, 0.0#), Array(10.0#, -15.0#, 10.0#)
1530     PackageDimension 1.5#, Array(-10.0#, 0.0#, 10.0#), Array(-8.5#, 0.0#, 10.0#)
1531     PackageDimension 1.5#, Array(0.0#, -15.0#, 10.0#), Array(0.0#, -13.5#, 10.0#)
1532     PackageSection "A", 0, 2, True, 0.0#, 0.83#, 0.65#
End Sub

Private Sub BuildPackageTitle7()
1536     PackageProperty "Title", "P06a drawing"
1537     PackageProperty "DrawnBy", "Fixture Builder"
1538     PackageTitleCheck
End Sub

Private Sub BuildPackage8()
1542     PackageStart "P06b.sldprt", Array(-10.0#, -15.0#, 0.0#), Array(10.0#, 15.0#, 10.0#)
1543     PackageSheet 2, 0, 6, 0.297#, 0.21#, 1.0#, 1.0#
1544     PackageBase "*Bottom", 1, 0, 2, 0.34#, 0.45#
1545     PackageProjected "beside", 0, 1, 0.57#, 0.45#, 0.1#, 0.45#
1546     PackageProjected "vertical", 2, 1, 0.34#, 0.8#, 0.34#, 0.12#
1547     PackageIso 1.0#, 2.0#, 0.83#, 0.2#
1548     PackageDimension 20.0#, Array(-10.0#, -15.0#, 10.0#), Array(10.0#, -15.0#, 10.0#)
1549     PackageDimension 30.0#, Array(-10.0#, -15.0#, 10.0#), Array(-10.0#, 15.0#, 10.0#)
1550     PackageDimension 10.0#, Array(10.0#, -15.0#, 0.0#), Array(10.0#, -15.0#, 10.0#)
1551     PackageDimension 2.0#, Array(-10.0#, 0.0#, 10.0#), Array(-8.0#, 0.0#, 10.0#)
1552     PackageDimension 2.0#, Array(0.0#, -15.0#, 10.0#), Array(0.0#, -13.0#, 10.0#)
1553     PackageSection "A", 0, 2, True, 0.0#, 0.83#, 0.65#
End Sub

Private Sub BuildPackageTitle8()
1557     PackageProperty "Title", "P06b drawing"
1558     PackageProperty "DrawnBy", "Fixture Builder"
1559     PackageTitleCheck
End Sub

Private Sub BuildPackage9()
1563     PackageStart "F10a.sldasm", Array(-10.0#, -15.0#, 0.0#), Array(10.0#, 15.0#, 30.0#)
1564     PackageAssembly Array(Array("block", Array(-0.01#, -0.015#, 0.0#), Array(0.01#, 0.015#, 0.01#), Array(0.0#, 0.0#, 0.0#)), Array("pin", Array(-0.0025#, -0.0025#, 0.01#), Array(0.0025#, 0.0025#, 0.03#), Array(0.0#, 0.0#, 0.01#)))
1565     PackageSheet 2, 0, 6, 0.297#, 0.21#, 1.0#, 1.0#
1566     PackageBase "*Bottom", 1, 0, 2, 0.34#, 0.45#
1567     PackageProjected "beside", 0, 1, 0.57#, 0.45#, 0.1#, 0.45#
1568     PackageProjected "vertical", 2, 1, 0.34#, 0.8#, 0.34#, 0.12#
1569     PackageIso 1.0#, 2.0#, 0.83#, 0.2#
1570     PackageDimension 20.0#, Array(-10.0#, -15.0#, 0.0#), Array(10.0#, -15.0#, 0.0#)
1571     PackageDimension 30.0#, Array(-10.0#, -15.0#, 0.0#), Array(-10.0#, 15.0#, 0.0#)
1572     PackageDimension 10.0#, Array(10.0#, -15.0#, 0.0#), Array(10.0#, -15.0#, 10.0#)
1573     PackageDimension 20.0#, Array(2.5#, 0.0#, 10.0#), Array(2.5#, 0.0#, 30.0#)
1574     PackageDimension 5.0#, Array(-2.5#, 0.0#, 30.0#), Array(2.5#, 0.0#, 30.0#)
1575     PackagePartsList 2, 0.97#, 0.95#, Array(Array("block", 1), Array("pin", 1))
End Sub

Private Sub BuildPackageTitle9()
1579     PackageProperty "Title", "F10a drawing"
1580     PackageProperty "DrawnBy", "Fixture Builder"
1581     PackageTitleCheck
End Sub

Private Function IsUnattended() As Boolean
1585     IsUnattended = (Trim$(Environ$("FIXTURE_UNATTENDED")) = "1")
End Function

Private Sub EnsureFolder(ByVal fs As Object, ByVal path As String)
    Dim parent As String
    stepLabel = currentIdentity & ": EnsureFolder FolderExists"
1591     If fs.FolderExists(path) Then Exit Sub
    stepLabel = currentIdentity & ": EnsureFolder GetParentFolderName"
1593     parent = fs.GetParentFolderName(path)
1594     If Len(parent) > 0 Then EnsureFolder fs, parent
    stepLabel = currentIdentity & ": EnsureFolder CreateFolder" & " " & apiInputs & " " & callInputs
1596     fs.CreateFolder path
End Sub

' ---------------------------------------------------------------- personal-path check
' SolidWorks stores the full path of every file an assembly or a drawing references inside that file (a drawing also keeps its sheet
' format and template path), so an output folder or a template under the person's profile, a OneDrive folder or a folder named after
' them would put their user name into every file in the zip. Rules, in order, on the lower-cased path: inside %USERPROFILE%; a folder
' whose name is, or (for a user name of 3 or more characters that is not a common word) contains, %USERNAME%; a folder whose name
' contains "onedrive"; a folder under \Users\<name> (any drive, 8.3 short names included) where <name> is not Public.
' PersonalPathReason returns "" when the folder is neutral, else the refusal text, which never repeats the folder.
Private Function EnvText(ByVal variable As String) As String
    ' WScript.Shell reads the variable as UTF-16: Environ$ would turn a Cyrillic or CJK user name into "?" before any rule saw it.
    ' MYDOCUMENTS is the (possibly redirected) Documents folder, which has no environment variable.
    Dim value As String
1610     On Error Resume Next
1611     If variable = "MYDOCUMENTS" Then
1612         value = CreateObject("WScript.Shell").SpecialFolders("MyDocuments")
    Else
1614         value = CreateObject("WScript.Shell").ExpandEnvironmentStrings("%" & variable & "%")
1615         If value = "%" & variable & "%" Then value = ""
    End If
1617     If Err.Number <> 0 Then value = ""
1618     Err.Clear
1619     EnvText = Trim$(value)
End Function

Private Function DefaultOutputRoot() As String
    Dim pub As String, result As String
1624     pub = Replace(EnvText("PUBLIC"), "/", "\")
1625     Do While Len(pub) > 0 And Right$(pub, 1) = "\"
1626         pub = Left$(pub, Len(pub) - 1)
    Loop
1628     If Len(pub) = 0 Then
1629         result = "C:\FixtureBuilder"
    Else
1631         result = pub & "\Documents\FixtureBuilder"
    End If
1633     DefaultOutputRoot = result
End Function

Private Function UserNameNotice() As String
1637     UserNameNotice = "SolidWorks writes your Windows user name into each file it saves. We keep these native files private and publish only STEP and files we've checked clean; to keep your name out of the files entirely, run SolidWorks under a neutral Windows account."
End Function

Private Function NameInsideComponents(ByVal user As String) As Boolean
    ' A word-matched name: 3 or more characters and not a common word. It is matched wherever the characters on both sides are not ASCII
    ' letters or digits (the start of the text, a tab, a quote, a length byte, "-", "_" ...); any other name (and a shorter one) only as a
    ' whole path segment. The same for the user name, the profile folder's own name and the computer, domain and logon-server names.
    Dim inside As Boolean
1645     inside = (Len(user) >= 3)
1646     If InStr("|admin|user|users|owner|public|default|test|cad|work|data|home|the|and|pro|dev|lab|app|sys|doc|docs|temp|office|pc|laptop|desktop|", "|" & user & "|") > 0 Then inside = False
1647     NameInsideComponents = inside
End Function

Private Function IsAsciiAlnum(ByVal ch As String) As Boolean
1651     IsAsciiAlnum = (ch Like "[A-Za-z0-9]")
End Function

Private Function WordIn(ByVal text As String, ByVal needle As String) As Boolean
    ' The needle in the text with no ASCII letter or digit next to it (or the edge of the text): both already lower-cased.
    Dim pos As Long, before As String, after As String, found As Boolean
1657     If Len(needle) > 0 Then
1658         pos = InStr(1, text, needle, vbBinaryCompare)
1659         Do While pos > 0 And Not found
1660             before = ""
1661             after = ""
1662             If pos > 1 Then before = Mid$(text, pos - 1, 1)
1663             If pos + Len(needle) <= Len(text) Then after = Mid$(text, pos + Len(needle), 1)
1664             If (Len(before) = 0 Or Not IsAsciiAlnum(before)) And (Len(after) = 0 Or Not IsAsciiAlnum(after)) Then found = True
1665             pos = InStr(pos + 1, text, needle, vbBinaryCompare)
        Loop
    End If
1668     WordIn = found
End Function

Private Function SegmentMatches(ByVal part As String, ByVal needle As String) As Boolean
    Dim hit As Boolean
1673     If Len(needle) > 0 Then hit = (part = needle)
1674     If Len(needle) > 0 And Not hit Then
1675         If NameInsideComponents(needle) Then hit = WordIn(part, needle)
    End If
1677     SegmentMatches = hit
End Function

Private Function NormalPath(ByVal path As String) As String
    Dim p As String
1682     p = LCase$(Replace(Trim$(path), "/", "\"))
1683     Do While Len(p) > 0 And Right$(p, 1) = "\"
1684         p = Left$(p, Len(p) - 1)
    Loop
1686     NormalPath = p
End Function

Private Function LeafOf(ByVal normal As String) As String
1690     LeafOf = Mid$(normal, InStrRev(normal, "\") + 1)
End Function

Private Function UnderRoot(ByVal p As String, ByVal root As String) As Boolean
    Dim under As Boolean
1695     If Len(root) > 0 Then under = (p = root Or Left$(p, Len(root) + 1) = root & "\")
1696     UnderRoot = under
End Function

Private Function PersonalPathRefusal(ByVal what As String, ByVal why As String) As String
1700     PersonalPathRefusal = "The " & what & " was refused because " & why & ". " & _
        "SolidWorks stores this path inside every assembly and drawing it saves, so the files you send would show it. " & _
        "Choose a neutral one instead, for example " & DefaultOutputRoot() & " for the output folder. Nothing was built."
End Function

Private Function DriveRooted(ByVal path As String) As Boolean
    Dim t As String
1707     t = Trim$(path)
1708     DriveRooted = (Len(t) >= 3 And Mid$(t, 1, 1) Like "[A-Za-z]" And Mid$(t, 2, 1) = ":" And (Mid$(t, 3, 1) = "\" Or Mid$(t, 3, 1) = "/"))
End Function

Private Function PersonalWhy(ByVal path As String, ByVal identity As Boolean) As String
    ' With identity False (the default output root, the one folder the builder names itself) only the last two rules apply, so a user called
    ' Documents, Public or FixtureBuilder is not locked out of it. The first of these that applies, on the lower-cased path: inside %USERPROFILE%; inside a OneDrive folder or the redirected Documents
    ' folder; a folder that is, or (guarded names) contains, %USERNAME% or the profile folder's own name; a folder named after the computer,
    ' domain or logon server; a folder whose name contains "onedrive"; a UNC share; a Users\<name> folder that is not Public.
    Dim p As String, profile As String, parts As Variant, i As Long, k As Long, why As String
    Dim names(0 To 1) As String, machines(0 To 2) As String, roots(0 To 3) As String
1718     p = NormalPath(path)
1719     profile = NormalPath(EnvText("USERPROFILE"))
1720     names(0) = LCase$(EnvText("USERNAME"))
1721     names(1) = LeafOf(profile)
1722     machines(0) = LCase$(EnvText("COMPUTERNAME"))
1723     machines(1) = LCase$(EnvText("USERDOMAIN"))
1724     machines(2) = LCase$(Replace(EnvText("LOGONSERVER"), "\", ""))
1725     roots(0) = NormalPath(EnvText("OneDrive"))
1726     roots(1) = NormalPath(EnvText("OneDriveCommercial"))
1727     roots(2) = NormalPath(EnvText("OneDriveConsumer"))
1728     roots(3) = NormalPath(EnvText("MYDOCUMENTS"))
1729     parts = Split(p, "\")
1730     If identity Then
1731         If UnderRoot(p, profile) Then why = "it is inside your user profile folder"
    End If
1733     If Len(why) = 0 And identity Then
1734         For k = 0 To 3
1735             If UnderRoot(p, roots(k)) Then why = "it is inside your OneDrive or redirected Documents folder"
        Next k
    End If
1738     If Len(why) = 0 And identity Then
1739         For k = 0 To 1
1740             If Len(names(k)) > 0 Then
1741                 For i = 0 To UBound(parts)
1742                     If SegmentMatches(CStr(parts(i)), names(k)) Then why = "a folder in its path contains your Windows user name"
                Next i
            End If
        Next k
    End If
1747     If Len(why) = 0 And identity Then
1748         For k = 0 To 2
1749             For i = 0 To UBound(parts)
1750                 If SegmentMatches(CStr(parts(i)), machines(k)) Then why = "a folder in its path is named after this computer, its domain or its logon server"
            Next i
        Next k
    End If
1754     If Len(why) = 0 And identity Then
1755         For i = 0 To UBound(parts)
1756             If InStr(parts(i), "onedrive") > 0 Then why = "a folder in its path is a OneDrive folder"
        Next i
    End If
1759     If Len(why) = 0 And Left$(p, 2) = "\\" Then why = "it is on a network share (a \\server\share path)"
1760     If Len(why) = 0 Then
1761         For i = 0 To UBound(parts) - 1
1762             If parts(i) = "users" And Len(parts(i + 1)) > 0 And parts(i + 1) <> "public" And parts(i + 1) <> "default" And parts(i + 1) <> "all users" And parts(i + 1) <> "shared" Then why = "it is inside the personal folder of a Windows user (a Users\<name> folder)"
        Next i
    End If
    ' Last, and for every folder (the default root too): a folder that is not a full path with a drive letter ("FixtureOut", "..\x",
    ' "%USERPROFILE%\x", which FileSystemObject does not expand) would resolve against SolidWorks' own current folder, which may be under the profile.
1767     If Len(why) = 0 Then
1768         If Not DriveRooted(path) Then why = "the folder must be a full path starting with a drive letter"
    End If
1770     PersonalWhy = why
End Function

Private Function PersonalPathReason(ByVal path As String) As String
    Dim why As String
1775     why = PersonalWhy(path, NormalPath(path) <> NormalPath(DefaultOutputRoot()))
1776     If Len(why) = 0 Then
1777         PersonalPathReason = ""
    Else
1779         PersonalPathReason = PersonalPathRefusal("output folder", why)
    End If
End Function

Private Function PersonalTemplateReason(ByVal kind As String, ByVal path As String) As String
    Dim why As String
1785     why = PersonalWhy(path, True)
1786     If Len(why) = 0 Then
1787         PersonalTemplateReason = ""
    Else
1789         PersonalTemplateReason = "The " & kind & " template SolidWorks would use was refused because " & why & ". " & _
            "A SolidWorks drawing stores the path of its sheet format and template, so the files you send would show it. " & _
            "In SolidWorks, under Tools > Options > Default Templates, choose a " & kind & " template in a neutral folder (for example the SolidWorks install folder or C:\ProgramData). Nothing was built."
    End If
End Function

Private Function EscapeRegex(ByVal text As String) As String
    Dim i As Long, ch As String, result As String
1797     For i = 1 To Len(text)
1798         ch = Mid$(text, i, 1)
1799         If InStr("\.+*?^$()[]{}|-", ch) > 0 Then result = result & "\"
1800         result = result & ch
    Next i
1802     EscapeRegex = result
End Function

Private Function RootPattern(ByVal root As String) As String
    ' A folder path as a pattern that also matches its doubled-backslash (JSON) and forward-slash forms.
1807     RootPattern = Replace(EscapeRegex(root), "\\", "[\\/]+")
End Function

Private Function CaseForms(ByVal word As String) As String
    ' The word as written, lower-cased and upper-cased, as one escaped alternation: VBScript's RegExp folds the case of ASCII letters only, so a
    ' Cyrillic or Greek name written in another case would be missed. LCase$ and UCase$ are Unicode-aware.
1813     CaseForms = "(?:" & EscapeRegex(word) & "|" & EscapeRegex(LCase$(word)) & "|" & EscapeRegex(UCase$(word)) & ")"
End Function

Private Function ScrubNeedle(ByVal regex As Object, ByVal text As String, ByVal needle As String, ByVal marker As String) As String
    ' A word-matched needle wherever no ASCII letter or digit is next to it (start of text, tab, quote ...); any other only as a whole folder name.
    Dim result As String
1819     result = text
1820     If Len(needle) > 0 Then
1821         If NameInsideComponents(LCase$(needle)) Then
1822             regex.Pattern = "(^|[^A-Za-z0-9])" & CaseForms(needle) & "(?=[^A-Za-z0-9]|$)"
1823             result = regex.Replace(result, "$1" & marker)
        Else
1825             regex.Pattern = "([\\/])" & CaseForms(needle) & "(?=[.,;)]*(?:[\\/\s""'<>|:*?]|$))"
1826             result = regex.Replace(result, "$1" & marker)
        End If
    End If
1829     ScrubNeedle = result
End Function

Private Function PrivacyScrub(ByVal text As String) As String
    ' Every message a volunteer might screenshot, every log line and every text file in the output goes through this. In order: the tail
    ' of any path under \Users\<x> (x is not Public; a name with a space, an 8.3 name, a Dropbox (Company) folder: all of it, up to a
    ' quote, a line end, a tab or the sentence end) becomes <user>\<path>; the profile, OneDrive and Documents folders likewise; the
    ' Windows user name and the profile folder's own name (anywhere when guarded, else only as a whole folder name) become <user>; the
    ' computer, domain and logon server names (whole tokens, guarded) become <host>; a \\server\share prefix becomes <share>.
    Dim regex As Object, result As String, roots(0 To 4) As String, names(0 To 1) As String, machines(0 To 2) As String
    Dim k As Long, tailEnd As String, swap As String, exempt As String
1840     tailEnd = "(?=[.,;)]*(?:[""'\r\n<>|]|$))"
1841     exempt = "(?!(?:public|default|all users|shared)(?:[\\/""'\r\n<>|]|$))"
1842     result = text
1843     Set regex = CreateObject("VBScript.RegExp")
1844     regex.Global = True
1845     regex.IgnoreCase = True
1846     regex.Pattern = "([\\/]Users[\\/]+)" & exempt & "[^\\/""'\r\n<>|:*?]+?((?:\\\\|[\\/](?![""']))+)(?:[^""'\r\n<>|\\]|\\\\|\\(?![""']))*"
1847     result = regex.Replace(result, "$1<user>$2<path>")
1848     regex.Pattern = "([\\/]Users[\\/]+)" & exempt & "[^\\/""'\r\n<>|:*?]+?" & tailEnd
1849     result = regex.Replace(result, "$1<user>")
1850     roots(0) = EnvText("USERPROFILE")
1851     roots(1) = EnvText("OneDrive")
1852     roots(2) = EnvText("OneDriveCommercial")
1853     roots(3) = EnvText("MYDOCUMENTS")
1854     roots(4) = EnvText("OneDriveConsumer")
1855     For k = 0 To 4
1856         If Len(roots(k)) > 0 Then
1857             regex.Pattern = RootPattern(roots(k)) & "((?:\\\\|[\\/](?![""']))+)(?:[^""'\r\n<>|\\]|\\\\|\\(?![""']))*"
1858             result = regex.Replace(result, "<user>$1<path>")
1859             regex.Pattern = RootPattern(roots(k))
1860             result = regex.Replace(result, "<user>")
        End If
    Next k
1863     names(0) = EnvText("USERNAME")
1864     names(1) = LeafOf(Replace(EnvText("USERPROFILE"), "/", "\"))
    ' The longer of the two first (jsmith.ACME before jsmith), so no part of the profile folder's name is left behind.
1866     If Len(names(1)) > Len(names(0)) Then
1867         swap = names(0)
1868         names(0) = names(1)
1869         names(1) = swap
    End If
1871     machines(0) = EnvText("COMPUTERNAME")
1872     machines(1) = EnvText("USERDOMAIN")
1873     machines(2) = Replace(EnvText("LOGONSERVER"), "\", "")
1874     For k = 0 To 1
1875         result = ScrubNeedle(regex, result, names(k), "<user>")
    Next k
1877     For k = 0 To 2
1878         result = ScrubNeedle(regex, result, machines(k), "<host>")
    Next k
1880     regex.Pattern = "(^|[^\\/\w:])(?:\\\\|//){1,2}[^\\/\s""'<>|:*?]+(?:\\\\|[\\/](?![""']))+(?:[^""'\r\n<>|\\]|\\\\|\\(?![""']))*"
1881     result = regex.Replace(result, "$1<share>")
1882     PrivacyScrub = result
End Function

Private Function EmptiedLine() As String
    ' "" unless the sweep had to empty or delete a text file it could not clean: then the volunteer is told the zip is incomplete.
1887     If sweepEmptiedCount > 0 Then EmptiedLine = vbLf & CStr(sweepEmptiedCount) & " file(s) could not be cleaned and were emptied: " & sweepEmptied
End Function

Private Function ZipReady(ByVal zipPath As String) As Boolean
    ' The zip exists and holds something (an empty zip is 22 bytes).
    Dim fs As Object
1893     On Error Resume Next
1894     Set fs = CreateObject("Scripting.FileSystemObject")
    stepLabel = currentIdentity & ": ZipReady FileExists"
1896     ZipReady = fs.FileExists(zipPath)
    stepLabel = currentIdentity & ": ZipReady GetFile"
1898     If ZipReady Then ZipReady = (fs.GetFile(zipPath).Size > 22)
1899     If Err.Number <> 0 Then ZipReady = False
1900     Err.Clear
End Function

Private Function ZipErrorHead(ByVal errorFile As String) As String
    ' The first 300 characters of the PowerShell error file, one line, or "no error text".
    Dim fs As Object, stream As Object, text As String
1906     On Error Resume Next
1907     Set fs = CreateObject("Scripting.FileSystemObject")
1908     If fs.FileExists(errorFile) Then
1909         Set stream = fs.OpenTextFile(errorFile, 1)
1910         text = stream.ReadAll
1911         stream.Close
    End If
1913     text = Trim$(Replace(Replace(text, vbCr, " "), vbLf, " "))
1914     If Len(text) > 300 Then text = Left$(text, 300)
1915     If Len(text) = 0 Then text = "no error text"
1916     ZipErrorHead = PrivacyScrub(text)
1917     Err.Clear
End Function

Private Sub ZipRemoveOld(ByVal folder As String)
    ' An old zip or error file of the same name (a manual Send to, an earlier run) never counts and is never shown.
    Dim fs As Object
1923     On Error Resume Next
1924     Set fs = CreateObject("Scripting.FileSystemObject")
    stepLabel = currentIdentity & ": ZipRemoveOld FileExists"
1926     If fs.FileExists(folder & ".zip") Then fs.DeleteFile folder & ".zip", True
    stepLabel = currentIdentity & ": ZipRemoveOld FileExists"
1928     If fs.FileExists(folder & "-zip-error.txt") Then fs.DeleteFile folder & "-zip-error.txt", True
1929     Err.Clear
End Sub

Private Function ZipPowerShell(ByVal folder As String, ByVal errorFile As String) As Boolean
    ' Compress-Archive; a failure is written to errorFile (ASCII) and exits 1. True only if the exit code is 0, the zip exists and holds something,
    ' and no error file was written. The old zip and error file are deleted first.
    Dim command As String, quotedFolder As String, quotedZip As String, quotedError As String, code As Long, fs As Object
1936     ZipRemoveOld folder
1937     quotedFolder = Replace(folder, "'", "''")
1938     quotedZip = Replace(folder & ".zip", "'", "''")
1939     quotedError = Replace(errorFile, "'", "''")
1940     command = "powershell.exe -NoProfile -NonInteractive -Command " & Chr$(34) & _
        "try { Compress-Archive -LiteralPath '" & quotedFolder & "' -DestinationPath '" & quotedZip & "' -Force -ErrorAction Stop } " & _
        "catch { $_ | Out-File -LiteralPath '" & quotedError & "' -Encoding ASCII; exit 1 }" & Chr$(34)
    stepLabel = currentIdentity & ": ZipPowerShell Run"
1944     code = CreateObject("WScript.Shell").Run(command, 0, True)
1945     Set fs = CreateObject("Scripting.FileSystemObject")
    stepLabel = currentIdentity & ": ZipPowerShell FileExists"
1947     ZipPowerShell = (code = 0) And ZipReady(folder & ".zip") And Not fs.FileExists(errorFile)
End Function

Private Function ZipWithShell(ByVal folder As String) As Boolean
    ' In-process zip: an empty zip file, then Shell.Application copies the folder into it. The copy is asynchronous: wait until the
    ' folder's items are all inside, the zip stops growing, or about 120 seconds pass.
    Dim fs As Object, stream As Object, shellObject As Object, zipSpace As Object, parentSpace As Object, innerSpace As Object
    Dim zipPath As String, wanted As Long, started As Date, size As Double, lastSize As Double, steady As Long, pause As Double, complete As Boolean
1955     On Error GoTo Failed
1956     zipPath = folder & ".zip"
1957     Set fs = CreateObject("Scripting.FileSystemObject")
1958     ZipRemoveOld folder
    stepLabel = currentIdentity & ": ZipWithShell CreateTextFile" & " " & apiInputs & " " & callInputs
1960     Set stream = fs.CreateTextFile(zipPath, True)
    stepLabel = currentIdentity & ": ZipWithShell Write"
1962     stream.Write "PK" & Chr(5) & Chr(6) & String(18, 0)
    stepLabel = currentIdentity & ": ZipWithShell Close"
1964     stream.Close
1965     Set shellObject = CreateObject("Shell.Application")
    stepLabel = currentIdentity & ": ZipWithShell Namespace"
1967     Set parentSpace = shellObject.Namespace(CVar(fs.GetParentFolderName(folder)))
    stepLabel = currentIdentity & ": ZipWithShell Namespace"
1969     wanted = shellObject.Namespace(CVar(folder)).Items.Count
    stepLabel = currentIdentity & ": ZipWithShell Namespace"
1971     Set zipSpace = shellObject.Namespace(CVar(zipPath))
    stepLabel = currentIdentity & ": ZipWithShell CopyHere"
1973     zipSpace.CopyHere parentSpace.ParseName(fs.GetFileName(folder))
1974     started = Now
1975     lastSize = -1
1976     Do While DateDiff("s", started, Now) < 120
1977         pause = Timer + 0.25
1978         Do While Timer >= pause - 0.25 And Timer < pause
1979             DoEvents
        Loop
1981         size = 0
    stepLabel = currentIdentity & ": ZipWithShell FileExists"
1983         If fs.FileExists(zipPath) Then size = fs.GetFile(zipPath).Size
    stepLabel = currentIdentity & ": ZipWithShell Count"
1985         If zipSpace.Items.Count >= 1 Then
    stepLabel = currentIdentity & ": ZipWithShell Item"
1987             Set innerSpace = zipSpace.Items.Item(0).GetFolder
1988             If Not innerSpace Is Nothing Then
    stepLabel = currentIdentity & ": ZipWithShell Count"
1990                 If innerSpace.Items.Count >= wanted And size > 22 Then
1991                     If size = lastSize Then steady = steady + 1 Else steady = 0
1992                     If steady >= 8 Then
1993                         complete = True
1994                         Exit Do
                    End If
                End If
            End If
        End If
1999         lastSize = size
    Loop
    ' Only if every item arrived and the zip stopped growing; a timeout part way is not a zip.
2002     ZipWithShell = complete And ZipReady(zipPath)
2003     Exit Function
Failed:
2005     ZipWithShell = False
End Function

Private Function ZipMitigationLine() As String
    ' A `mitigations:` line of the zip step alone (the recipes' lines are written before the zip).
    Dim itemName As Variant, text As String
2011     For Each itemName In Array("zip-verify-retry", "zip-shell-application")
    stepLabel = currentIdentity & ": ZipMitigationLine Exists"
2013         If mitigations.Exists(CStr(itemName)) Then
2014             If Len(text) > 0 Then text = text & " "
2015             text = text & CStr(itemName) & "=" & CStr(mitigations(itemName)) & ",primary-failed=" & CStr(primaryFailures(itemName)) & ",fallback-ok=" & CStr(fallbackSuccesses(itemName))
        End If
    Next itemName
2018     ZipMitigationLine = "mitigations: " & text
End Function

Private Function MakeZip(ByVal folder As String) As Boolean
    ' folder & ".zip" for the run. Compress-Archive is checked by looking for the file and the error file, not by its exit code alone (field
    ' 2026.11.24.3: exit code 0 and no zip). An old zip or error file is deleted first and before every attempt. Then: all documents closed and a
    ' second Compress-Archive with its error text kept (zip-verify-retry), then a zip written in-process (zip-shell-application). Never raises: the
    ' finish message tells the person what to do by hand. The mitigations are logged in a line of their own.
    Dim zipPath As String, errorFile As String
2027     zipPath = folder & ".zip"
2028     errorFile = folder & "-zip-error.txt"
2029     On Error Resume Next
2030     ZipRemoveOld folder
2031     If ZipPowerShell(folder, errorFile) Then MakeZip = True: Exit Function
2032     Err.Clear
2033     AppendLog folder, "setup", "zip", 0, 0, "zip: no zip was written; " & ZipErrorHead(errorFile)
2034     RecordMitigation "zip-verify-retry", True, True
    stepLabel = currentIdentity & ": MakeZip CloseAllDocuments"
2036     app.CloseAllDocuments True
2037     Err.Clear
2038     If ZipPowerShell(folder, errorFile) Then
2039         fallbackSuccesses("zip-verify-retry") = fallbackSuccesses("zip-verify-retry") + 1
2040         AppendLog folder, "setup", "zip", 0, 0, "zip-verify-retry: the second Compress-Archive wrote the zip"
2041         AppendLog folder, "setup", "zip", 0, 0, ZipMitigationLine()
2042         MakeZip = True: Exit Function
    End If
2044     Err.Clear
2045     AppendLog folder, "setup", "zip", 0, 0, "zip-verify-retry: still no zip; " & ZipErrorHead(errorFile)
2046     RecordMitigation "zip-shell-application", True, True
2047     If ZipWithShell(folder) Then
2048         fallbackSuccesses("zip-shell-application") = fallbackSuccesses("zip-shell-application") + 1
2049         AppendLog folder, "setup", "zip", 0, 0, "zip-shell-application: Shell.Application wrote the zip"
2050         MakeZip = True
    Else
2052         Err.Clear
2053         AppendLog folder, "setup", "zip", 0, 0, "zip-shell-application: no zip either; the folder is complete, the person zips it by hand"
    End If
2055     AppendLog folder, "setup", "zip", 0, 0, ZipMitigationLine()
End Function

Private Function CountStatus(ByVal status As String) As Long
    Dim needle As String
2060     needle = """status"":" & Quote(status) & ",""error"""
2061     CountStatus = (Len(resultRows) - Len(Replace(resultRows, needle, ""))) \ Len(needle)
End Function

Private Sub ReportCleanupError(ByVal folder As String, ByRef finalMessage As String)
    Dim number As Long, lineNumber As Long, description As String, failedStep As String
    lineNumber = Erl: number = Err.Number: description = Err.Description: failedStep = stepLabel
2067     finalMessage = failedStep & " (line " & CStr(lineNumber) & "): " & description
2068     If Len(folder) > 0 Then AppendLog folder, currentIdentity, failedStep, lineNumber, number, description
End Sub

Private Function TryTopologySelect(ByVal topology As SldWorks.Entity, ByVal appendSelection As Boolean, ByVal data As Object) As Boolean
    ' Only the original call is trapped; fallback errors retain their own diagnostics.
2073     On Error GoTo Failed
    stepLabel = currentIdentity & ": TryTopologySelect Select4" & " " & apiInputs & " " & callInputs
2075     TryTopologySelect = topology.Select4(appendSelection, data)
2076     Exit Function
Failed:
2078     TryTopologySelect = False
End Function

Private Sub RecordMitigation(ByVal itemName As String, Optional ByVal primaryFailed As Boolean = False, Optional ByVal always As Boolean = False)
    ' Mitigations log on every revision (SolidWorks 2023 hit the 2026 failures too).
2083     If Not mitigations.Exists(itemName) Then mitigations.Add itemName, 0
2084     mitigations(itemName) = mitigations(itemName) + 1
2085     If primaryFailed Then
2086         If Not primaryFailures.Exists(itemName) Then primaryFailures.Add itemName, 0
2087         If Not fallbackSuccesses.Exists(itemName) Then fallbackSuccesses.Add itemName, 0
2088         primaryFailures(itemName) = primaryFailures(itemName) + 1
    End If
End Sub

Private Function MitigationText() As String
    Dim itemName As Variant, entries As String
2094     For Each itemName In mitigations.Keys
2095         If Len(entries) > 0 Then entries = entries & " "
2096         entries = entries & CStr(itemName) & "=" & CStr(mitigations(itemName))
2097         If primaryFailures.Exists(itemName) Then
2098             entries = entries & ",primary-failed=" & CStr(primaryFailures(itemName)) & ",fallback-ok=" & CStr(fallbackSuccesses(itemName))
        End If
    Next itemName
2101     If Len(entries) = 0 Then entries = "none"
2102     MitigationText = "mitigations: " & entries
End Function

Private Function MitigationJson() As String
    Dim itemName As Variant, entries As String, counts As String
2107     For Each itemName In mitigations.Keys
2108         If Len(entries) > 0 Then entries = entries & ","
2109         counts = "{""count"":" & CStr(mitigations(itemName))
2110         If primaryFailures.Exists(itemName) Then
2111             counts = counts & ",""primary_failed"":" & CStr(primaryFailures(itemName)) & ",""fallback_ok"":" & CStr(fallbackSuccesses(itemName))
        End If
2113         entries = entries & Quote(CStr(itemName)) & ":" & counts & "}"
    Next itemName
2115     MitigationJson = "{" & entries & "}"
End Function

Private Function TryTemplate(ByVal path As String, ByRef tried As String) As String
    Dim fs As Object
2120     Set fs = CreateObject("Scripting.FileSystemObject")
2121     If Len(tried) > 0 Then tried = tried & "; "
2122     tried = tried & path
    stepLabel = currentIdentity & ": TryTemplate FileExists"
2124     If fs.FileExists(path) Then TryTemplate = path
End Function

Private Function ResolveTemplate(ByVal kind As String) As String
    Dim override As String, preference As Long, filename As String, extension As String
    Dim tried As String, candidate As String, defaultTemplate As String, folders As String
    Dim fs As Object, install As String, language As String, folder As Variant, match As String
2131     Set fs = CreateObject("Scripting.FileSystemObject")
2132     Select Case kind
        Case "part"
2134             override = TEMPLATE_PART: preference = swDefaultTemplatePart: filename = "part.prtdot"
        Case "assembly"
2136             override = TEMPLATE_ASSEMBLY: preference = swDefaultTemplateAssembly: filename = "assem.asmdot"
        Case "drawing"
2138             override = TEMPLATE_DRAWING: preference = swDefaultTemplateDrawing: filename = "drawing.drwdot"
    End Select
2140     If Len(override) > 0 Then
2141         candidate = TryTemplate(override, tried)
2142         If Len(candidate) > 0 Then ResolveTemplate = candidate: Exit Function
    End If
    stepLabel = currentIdentity & ": ResolveTemplate GetUserPreferenceStringValue"
2145     defaultTemplate = app.GetUserPreferenceStringValue(preference)
2146     If Len(defaultTemplate) > 0 Then
2147         candidate = TryTemplate(defaultTemplate, tried)
2148         If Len(candidate) > 0 Then ResolveTemplate = candidate: Exit Function
    End If
    stepLabel = currentIdentity & ": ResolveTemplate GetUserPreferenceStringValue"
2151     folders = app.GetUserPreferenceStringValue(swFileLocationsDocumentTemplates)
    stepLabel = currentIdentity & ": ResolveTemplate GetExecutablePath"
2153     install = app.GetExecutablePath()
    stepLabel = currentIdentity & ": ResolveTemplate GetExtensionName"
2155     If LCase$(fs.GetExtensionName(install)) = "exe" Then install = fs.GetParentFolderName(install)
    stepLabel = currentIdentity & ": ResolveTemplate BuildPath"
2157     language = fs.BuildPath(fs.BuildPath(install, "lang"), app.GetCurrentLanguage())
    stepLabel = currentIdentity & ": ResolveTemplate BuildPath"
2159     folders = folders & ";" & language & ";" & fs.BuildPath(language, "Tutorial")
    stepLabel = currentIdentity & ": ResolveTemplate GetExtensionName"
2161     extension = fs.GetExtensionName(filename)
2162     For Each folder In Split(folders, ";")
2163         folder = Trim$(CStr(folder))
2164         If Len(folder) > 0 Then
    stepLabel = currentIdentity & ": ResolveTemplate BuildPath"
2166             candidate = TryTemplate(fs.BuildPath(folder, filename), tried)
2167             If Len(candidate) > 0 Then ResolveTemplate = candidate: Exit Function
    stepLabel = currentIdentity & ": ResolveTemplate BuildPath"
2169             match = fs.BuildPath(folder, "*." & extension)
2170             If Len(tried) > 0 Then tried = tried & "; "
2171             tried = tried & match
    stepLabel = currentIdentity & ": ResolveTemplate FolderExists"
2173             If fs.FolderExists(folder) Then
2174                 match = Dir$(match)
2175                 Do While Len(match) > 0
    stepLabel = currentIdentity & ": ResolveTemplate BuildPath"
2177                     candidate = TryTemplate(fs.BuildPath(folder, match), tried)
2178                     If Len(candidate) > 0 Then ResolveTemplate = candidate: Exit Function
2179                     match = Dir$()
                Loop
            End If
        End If
    Next folder
2184     Err.Raise 5, , kind & " template unavailable. Paths tried: " & tried
End Function

Private Sub Require(ByVal value As Object, ByVal message As String)
2188     If value Is Nothing Then Err.Raise 5, , message
End Sub

Private Sub SaveFile(ByVal path As String)
    Dim errors As Long, warnings As Long, success As Boolean
    stepLabel = currentIdentity & ": SaveFile SaveAs"
2194     success = doc.Extension.SaveAs(path, 0, 1, Nothing, errors, warnings)
2195     If Not success Or errors <> 0 Then Err.Raise 5, , "SolidWorks SaveAs error " & CStr(errors)
2196     ExportGuard path
2197     RecordReadback
End Sub

Private Sub ExportGuard(ByVal path As String)
    ' Right after SolidWorks writes a DXF or a PDF the builder made: a DXF is text and is scrubbed like one; a PDF is scanned for the names (not
    ' rewritten). A PDF with a name in it, a file over 4 MB (too large to check) or one that cannot be read is deleted and the row fails. The
    ' .sld* files are compressed and are not scanned (the stamp in them is documented); a STEP file has its own guard.
    Dim fs As Object, ext As String, text As String, cleaned As String, problem As String
2205     Set fs = CreateObject("Scripting.FileSystemObject")
    stepLabel = currentIdentity & ": ExportGuard GetExtensionName"
2207     ext = LCase$(fs.GetExtensionName(path))
2208     If ext <> "dxf" And ext <> "pdf" Then Exit Sub
    stepLabel = currentIdentity & ": ExportGuard FileExists"
2210     If Not fs.FileExists(path) Then Exit Sub
2211     On Error Resume Next
2212     If ext = "dxf" Then
2213         text = SweepRead(path)
2214         If Err.Number = 0 Then
2215             cleaned = PrivacyScrub(text)
2216             If cleaned <> text Then SweepWrite path, cleaned
        End If
    ElseIf StrayHasNeedle(path) Then
2219         problem = "carried a personal name"
    End If
2221     If Err.Number <> 0 Then
2222         problem = "could not be checked"
2223         If InStr(Err.Description, "size cap") > 0 Then problem = "too large to check (over 4 MB)"
    End If
2225     Err.Clear
2226     On Error GoTo 0
2227     If Len(problem) > 0 Then
2228         If Not SweepDelete(fs, path) Then SweepTruncate fs, path
2229         Err.Raise 5, , "privacy: " & ext & " " & problem
    End If
End Sub

Private Function SummaryStatus(ByVal field As Long) As String
    ' Ours (Fixture Builder), blank, or written by SolidWorks. Never a value that is not ours.
    Dim value As String, result As String
2236     On Error Resume Next
    stepLabel = currentIdentity & ": SummaryStatus SummaryInfo"
2238     value = CStr(doc.SummaryInfo(field))
2239     If Err.Number <> 0 Then
2240         Err.Clear
2241         result = "not read"
    ElseIf Len(Trim$(value)) = 0 Then
2243         result = "blank"
    ElseIf value = NEUTRAL_VALUE Then
2245         result = NEUTRAL_VALUE
    Else
2247         result = "set by SolidWorks (redacted)"
    End If
2249     SummaryStatus = result
End Function

Private Function StatusRank(ByVal status As String) As Long
    Dim rank As Long
2254     Select Case status
        Case "blank": rank = 1
        Case NEUTRAL_VALUE: rank = 2
        Case "set by SolidWorks (redacted)": rank = 3
        Case Else: rank = 0
    End Select
2260     StatusRank = rank
End Function

Private Sub RecordReadback()
    Dim field As Long, status As String
2265     For field = 2 To 5
2266         status = SummaryStatus(field)
2267         If StatusRank(status) > StatusRank(rbStatus(field)) Then rbStatus(field) = status
    Next field
End Sub

Private Function ReadbackText() As String
    Dim field As Long, labels As Variant, text As String, status As String
2273     labels = Array("author", "keywords", "comment", "savedby")
2274     For field = 2 To 5
2275         status = rbStatus(field)
2276         If Len(status) = 0 Then status = "not read"
2277         text = text & " " & CStr(labels(field - 2)) & "=" & status
    Next field
2279     ReadbackText = "summary info read-back after save:" & text
End Function

Private Function NoticeStep(ByVal launched As Boolean) As String
    ' "" means Cancel: nothing is built. Otherwise the line for the log: whether the notice was shown, and the answer.
    Dim note As String
2285     If launched Then
2286         note = "user name notice: shown by the launcher, answer " & GetSetting("DutchmanFixtures", "SolidWorksBuilder", "NoticeAnswer", "OK")
    ElseIf IsUnattended() Then
2288         note = "user name notice: not shown (unattended run)"
    ElseIf MsgBox(UserNameNotice(), vbOKCancel + vbInformation, "SolidWorks fixtures") = vbOK Then
2290         note = "user name notice: shown, answer OK"
    End If
2292     NoticeStep = note
End Function

Private Function SweepText(ByVal path As String, ByVal charset As String) As String
    Dim stream As Object, text As String
2297     Set stream = CreateObject("ADODB.Stream")
2298     stream.Type = 2
2299     stream.Charset = charset
2300     stream.Open
2301     stream.LoadFromFile path
2302     text = stream.ReadText
2303     stream.Close
2304     SweepText = text
End Function

Private Function SweepReencodes(ByVal text As String, ByRef bytes As Variant) As Boolean
    ' True when the text, encoded as UTF-8, is byte for byte the file: the file really was UTF-8.
    Dim stream As Object, again As Variant, i As Long, same As Boolean
2310     Set stream = CreateObject("ADODB.Stream")
2311     stream.Type = 2
2312     stream.Charset = "utf-8"
2313     stream.Open
2314     stream.WriteText text
2315     stream.Position = 0
2316     stream.Type = 1
2317     stream.Position = 3
2318     again = stream.Read
2319     stream.Close
2320     same = (UBound(again) = UBound(bytes))
2321     If same Then
2322         For i = 0 To UBound(bytes)
2323             If again(i) <> bytes(i) Then same = False: Exit For
        Next i
    End If
2326     SweepReencodes = same
End Function

Private Function SweepRead(ByVal path As String) As String
    ' The file as text, in the encoding it was written in (left in sweepEncoding): UTF-16 or UTF-8 with a byte-order mark, UTF-8 without
    ' one, else the ANSI codepage the builder's own log is written in. A file over 4 MB, NUL bytes without a UTF-16 mark, or any decode
    ' error raises: the caller counts that as a hit (truncate or delete), never as clean.
    Dim stream As Object, bytes As Variant, size As Long, text As String, i As Long, channel As Integer
2334     Set stream = CreateObject("ADODB.Stream")
2335     stream.Type = 1
2336     stream.Open
2337     stream.LoadFromFile path
2338     size = stream.Size
2339     If size > 4194304 Then Err.Raise 5, , "over the sweep size cap"
2340     If size = 0 Then
2341         stream.Close
2342         sweepEncoding = "utf-8"
2343         SweepRead = ""
2344         Exit Function
    End If
2346     bytes = stream.Read
2347     stream.Close
2348     If size >= 2 And bytes(0) = 255 And bytes(1) = 254 Then
2349         sweepEncoding = "utf-16-le-bom"
2350         SweepRead = SweepText(path, "unicode")
2351         Exit Function
    End If
2353     If size >= 2 And bytes(0) = 254 And bytes(1) = 255 Then
2354         sweepEncoding = "utf-16-be-bom"
2355         SweepRead = SweepText(path, "unicodeFFFE")
2356         Exit Function
    End If
2358     If size >= 3 Then
2359         If bytes(0) = 239 And bytes(1) = 187 And bytes(2) = 191 Then
2360             sweepEncoding = "utf-8-bom"
2361             SweepRead = SweepText(path, "utf-8")
2362             Exit Function
        End If
    End If
2365     For i = 0 To UBound(bytes)
2366         If bytes(i) = 0 Then Err.Raise 5, , "NUL bytes without a UTF-16 byte-order mark"
    Next i
2368     text = SweepText(path, "utf-8")
2369     If SweepReencodes(text, bytes) Then
2370         sweepEncoding = "utf-8"
2371         SweepRead = text
2372         Exit Function
    End If
2374     sweepEncoding = "ansi"
2375     channel = FreeFile
2376     Open path For Binary Access Read As #channel
2377     text = Space$(LOF(channel))
2378     Get #channel, , text
2379     Close #channel
2380     SweepRead = text
End Function

Private Sub SweepWrite(ByVal path As String, ByVal text As String)
    ' Back in the encoding SweepRead found (never a different one).
    Dim stream As Object, channel As Integer, fs As Object
2386     Select Case sweepEncoding
        Case "utf-8"
2388             WriteUtf8 path, text
        Case "utf-8-bom", "utf-16-le-bom", "utf-16-be-bom"
2390             Set stream = CreateObject("ADODB.Stream")
2391             stream.Type = 2
2392             If sweepEncoding = "utf-16-le-bom" Then
2393                 stream.Charset = "unicode"
            ElseIf sweepEncoding = "utf-16-be-bom" Then
2395                 stream.Charset = "unicodeFFFE"
            Else
2397                 stream.Charset = "utf-8"
            End If
2399             stream.Open
2400             stream.WriteText text
2401             stream.SaveToFile path, 2
2402             stream.Close
        Case Else
2404             Set fs = CreateObject("Scripting.FileSystemObject")
2405             If fs.FileExists(path) Then fs.DeleteFile path, True
2406             channel = FreeFile
2407             Open path For Binary Access Write As #channel
2408             Put #channel, , text
2409             Close #channel
    End Select
End Sub

Private Function ReadLatin1(ByVal path As String, ByVal cap As Long) As String
    ' Latin-1 maps one byte to one character: the text is the file's bytes (searched, or rewritten byte for byte). Over the cap raises.
    Dim stream As Object, text As String
2416     Set stream = CreateObject("ADODB.Stream")
    stepLabel = currentIdentity & ": ReadLatin1 Type"
2418     stream.Type = 2
    stepLabel = currentIdentity & ": ReadLatin1 Charset"
2420     stream.Charset = "iso-8859-1"
    stepLabel = currentIdentity & ": ReadLatin1 Open"
2422     stream.Open
    stepLabel = currentIdentity & ": ReadLatin1 LoadFromFile"
2424     stream.LoadFromFile path
    stepLabel = currentIdentity & ": ReadLatin1 Size"
2426     If stream.Size > cap Then Err.Raise 5, , "over the size cap"
    stepLabel = currentIdentity & ": ReadLatin1 ReadText"
2428     text = stream.ReadText
    stepLabel = currentIdentity & ": ReadLatin1 Close"
2430     stream.Close
2431     ReadLatin1 = text
End Function

Private Function BytesAsLatin1(ByVal text As String, ByVal charset As String) As String
    ' The text encoded in the charset (utf-8 or unicode = UTF-16-LE), one character per byte; any byte-order mark dropped.
    Dim stream As Object, bytes As Variant, i As Long, skip As Long, result As String
2437     Set stream = CreateObject("ADODB.Stream")
    stepLabel = currentIdentity & ": BytesAsLatin1 Type"
2439     stream.Type = 2
    stepLabel = currentIdentity & ": BytesAsLatin1 Charset"
2441     stream.Charset = charset
    stepLabel = currentIdentity & ": BytesAsLatin1 Open"
2443     stream.Open
    stepLabel = currentIdentity & ": BytesAsLatin1 WriteText"
2445     stream.WriteText text
    stepLabel = currentIdentity & ": BytesAsLatin1 Position"
2447     stream.Position = 0
    stepLabel = currentIdentity & ": BytesAsLatin1 Type"
2449     stream.Type = 1
2450     If charset = "utf-8" Then skip = 3
2451     If charset = "unicode" Then skip = 2
    stepLabel = currentIdentity & ": BytesAsLatin1 Position"
2453     stream.Position = skip
    stepLabel = currentIdentity & ": BytesAsLatin1 Size"
2455     If stream.Size > skip Then
    stepLabel = currentIdentity & ": BytesAsLatin1 Read"
2457         bytes = stream.Read
2458         For i = 0 To UBound(bytes)
2459             result = result & ChrW(bytes(i))
        Next i
    End If
    stepLabel = currentIdentity & ": BytesAsLatin1 Close"
2463     stream.Close
2464     BytesAsLatin1 = result
End Function

Private Function AnsiAsLatin1(ByVal text As String) As String
    ' The single-byte ANSI form (empty when a character does not fit in one byte).
    Dim i As Long, result As String, ok As Boolean
2470     ok = True
2471     For i = 1 To Len(text)
2472         If AscW(Mid$(text, i, 1)) < 0 Or AscW(Mid$(text, i, 1)) > 255 Then ok = False
    Next i
2474     If ok Then
2475         For i = 1 To Len(text)
2476             result = result & ChrW(Asc(Mid$(text, i, 1)) And 255)
        Next i
    End If
2479     AnsiAsLatin1 = result
End Function

Private Function AsciiLower(ByVal text As String) As String
    ' Only A-Z become a-z (LCase$ on the bytes of a file would also change the bytes C0 to DE, which are parts of other characters).
    Dim code As Long
2485     For code = 65 To 90
2486         text = Replace(text, Chr$(code), Chr$(code + 32), 1, -1, vbBinaryCompare)
    Next code
2488     AsciiLower = text
End Function

Private Function NeedleInBytes(ByVal data As String, ByVal needle As String, ByVal wide As Boolean, ByVal word As Boolean) As Boolean
    ' The needle's bytes (one character each) in the file's bytes (the data and the needle with A-Z folded): a word-matched needle (word, decided
    ' on the DECODED name, never on its encoded bytes) with no ASCII letter or digit next to it, any other with a path separator on both sides.
    ' A UTF-16 character is two bytes, so "next to" is two bytes there.
    Dim pos As Long, unit As Long, before As String, after As String, found As Boolean
2496     unit = 1
2497     If wide Then unit = 2
2498     If Len(needle) > 0 Then
2499         pos = InStr(1, data, needle, vbBinaryCompare)
2500         Do While pos > 0 And Not found
2501             before = ""
2502             after = ""
2503             If pos > unit Then before = Mid$(data, pos - unit, 1)
2504             If pos + Len(needle) <= Len(data) Then after = Mid$(data, pos + Len(needle), 1)
2505             If word Then
2506                 If (Len(before) = 0 Or Not IsAsciiAlnum(before)) And (Len(after) = 0 Or Not IsAsciiAlnum(after)) Then found = True
            Else
2508                 If (before = "\" Or before = "/") And (after = "\" Or after = "/") Then found = True
            End If
2510             pos = InStr(pos + 1, data, needle, vbBinaryCompare)
        Loop
    End If
2513     NeedleInBytes = found
End Function

Private Function StrayHasNeedle(ByVal path As String) As Boolean
    ' True when a needle (the user name, the profile folder's name, the computer, domain or logon-server name) is in the file's bytes as
    ' UTF-8, UTF-16-LE or ANSI. A file over 4 MB or one that cannot be read raises.
    ' Each name is tried as written, lower-cased and upper-cased (Unicode-aware), so a Cyrillic name in another case is found too.
    Dim data As String, words(0 To 4) As String, k As Long, hit As Boolean, word As String, forms(0 To 2) As String, f As Long, isWord As Boolean
2521     data = AsciiLower(ReadLatin1(path, 4194304))
2522     words(0) = EnvText("USERNAME")
2523     words(1) = LeafOf(Replace(EnvText("USERPROFILE"), "/", "\"))
2524     words(2) = EnvText("COMPUTERNAME")
2525     words(3) = EnvText("USERDOMAIN")
2526     words(4) = Replace(EnvText("LOGONSERVER"), "\", "")
2527     For k = 0 To 4
2528         word = words(k)
2529         If Len(word) > 0 Then
2530             isWord = NameInsideComponents(LCase$(word))
2531             forms(0) = word
2532             forms(1) = LCase$(word)
2533             forms(2) = UCase$(word)
2534             For f = 0 To 2
2535                 If NeedleInBytes(data, AsciiLower(BytesAsLatin1(forms(f), "utf-8")), False, isWord) Then hit = True
2536                 If NeedleInBytes(data, AsciiLower(BytesAsLatin1(forms(f), "unicode")), True, isWord) Then hit = True
2537                 If Len(AnsiAsLatin1(forms(f))) > 0 Then
2538                     If NeedleInBytes(data, AsciiLower(AnsiAsLatin1(forms(f))), False, isWord) Then hit = True
                Else
2540                     sweepAnsiSkipped = True        ' the codepage cannot hold it: never read as "matches nothing" in silence (PrivacySweep notes it)
                End If
            Next f
        End If
    Next k
2545     StrayHasNeedle = hit
End Function

Private Function SweepDelete(ByVal fs As Object, ByVal path As String) As Boolean
    Dim attempt As Long, done As Boolean
2550     For attempt = 1 To 3
2551         If Not done Then
2552             On Error Resume Next
2553             Err.Clear
2554             If fs.FileExists(path) Then fs.DeleteFile path, True
2555             done = (Err.Number = 0 And Not fs.FileExists(path))
2556             Err.Clear
2557             On Error GoTo 0
        End If
    Next attempt
2560     SweepDelete = done
End Function

Private Function SweepTruncate(ByVal fs As Object, ByVal path As String) As Boolean
    Dim attempt As Long, done As Boolean
2565     For attempt = 1 To 3
2566         If Not done Then
2567             On Error Resume Next
2568             Err.Clear
2569             fs.CreateTextFile(path, True).Close
2570             done = (Err.Number = 0)
2571             Err.Clear
2572             On Error GoTo 0
        End If
    Next attempt
2575     SweepTruncate = done
End Function

Private Sub SweepNote(ByRef notes As String, ByVal note As String)
2579     If Len(notes) > 0 Then notes = notes & " | "
2580     notes = notes & note
End Sub

Private Sub SweepStray(ByVal fs As Object, ByVal path As String, ByVal fileName As String, ByVal ext As String, ByRef notes As String)
    ' A file that is not text and not one the builder made (named in results.json, or the log): its bytes are searched for the needles and
    ' it is deleted on a hit, a cap or an error.
    Dim hit As Boolean, why As String
    ' Case-insensitive: SolidWorks writes .SLDPRT where the row says .sldprt, and that is still the builder's own file. Its own PDF is still
    ' scanned (never rewritten); the .sld* files are compressed and are not.
2589     If InStr(1, resultRows, Chr$(34) & fileName & Chr$(34), vbTextCompare) > 0 And ext <> "pdf" Then Exit Sub
2590     If InStr("|sldprt|sldasm|slddrw|step|dxf|zip|", "|" & ext & "|") > 0 And Len(resultRows) = 0 Then Exit Sub
2591     why = "stray file, name found"
2592     On Error Resume Next
2593     hit = StrayHasNeedle(path)
2594     If Err.Number <> 0 Then
2595         hit = True
2596         why = "stray file, unreadable"
2597         If InStr(Err.Description, "size cap") > 0 Then why = "stray file, too large to check (over 4 MB)"
    End If
2599     Err.Clear
2600     On Error GoTo 0
2601     If Not hit Then Exit Sub
2602     If SweepDelete(fs, path) Then
2603         SweepNote notes, "privacy sweep: " & fileName & " removed (" & why & ")"
    ElseIf SweepTruncate(fs, path) Then
2605         SweepNote notes, "privacy sweep: " & fileName & " truncated (" & why & ")"
    Else
2607         SweepNote notes, "privacy sweep: " & fileName & " could not be cleaned or removed"
    End If
End Sub

Private Sub SweepFile(ByVal fs As Object, ByVal path As String, ByRef notes As String)
    ' Scrub one file. A text file that cannot be read or written (a lock, no permission) is retried, then truncated to zero bytes, then
    ' deleted; the note says which. Lock files (~$*) and temporary files are deleted. Never raises, so the whole list is always finished.
    Dim fileName As String, ext As String, text As String, cleaned As String, attempt As Long, done As Boolean, reason As String, capped As Boolean
2615     fileName = fs.GetFileName(path)
2616     ext = LCase$(fs.GetExtensionName(path))
2617     If Left$(fileName, 2) = "~$" Or ext = "tmp" Or ext = "temp" Or ext = "partial" Then
2618         If Not SweepDelete(fs, path) Then
2619             If SweepTruncate(fs, path) Then
2620                 SweepNote notes, "privacy sweep: " & fileName & " truncated (could not be removed)"
            Else
2622                 SweepNote notes, "privacy sweep: " & fileName & " could not be removed"
            End If
        End If
2625         Exit Sub
    End If
2627     If InStr("|log|json|txt|csv|tsv|xml|html|htm|md|ini|cfg|yaml|yml|dxf|", "|" & ext & "|") = 0 Then
2628         SweepStray fs, path, fileName, ext, notes
2629         Exit Sub
    End If
2631     For attempt = 1 To 3
2632         If Not done Then
2633             On Error Resume Next
2634             Err.Clear
2635             text = SweepRead(path)
2636             If Err.Number = 0 Then
2637                 cleaned = PrivacyScrub(text)
2638                 If cleaned <> text Then SweepWrite path, cleaned
            End If
2640             done = (Err.Number = 0)
2641             If InStr(Err.Description, "over the sweep size cap") > 0 Then capped = True
2642             Err.Clear
2643             On Error GoTo 0
        End If
    Next attempt
2646     If done Then Exit Sub
2647     reason = "unreadable"
2648     If capped Then reason = "too large to check (over 4 MB)"
2649     sweepEmptiedCount = sweepEmptiedCount + 1
2650     If Len(sweepEmptied) > 0 Then sweepEmptied = sweepEmptied & ", "
2651     sweepEmptied = sweepEmptied & fileName
2652     If SweepTruncate(fs, path) Then
2653         SweepNote notes, "privacy sweep: " & fileName & " truncated (" & reason & ")"
    ElseIf SweepDelete(fs, path) Then
2655         SweepNote notes, "privacy sweep: " & fileName & " removed (" & reason & ")"
    Else
2657         SweepNote notes, "privacy sweep: " & fileName & " could not be cleaned or removed"
    End If
End Sub

Private Sub SweepListFailure(ByVal dirPath As String, ByRef notes As String)
    ' Any error listing a folder (access denied, a path too long): noted with the scrubbed folder name, and no zip is made (fail closed).
2663     sweepListFailed = True
2664     SweepNote notes, "privacy sweep: could not list " & PrivacyScrub(Mid$(dirPath, InStrRev(dirPath, "\") + 1))
2665     Err.Clear
End Sub

Private Sub SweepFolder(ByVal fs As Object, ByVal dirPath As String, ByRef notes As String)
    Dim item As Object, list As String, entries As Variant, i As Long, here As Object, children As Object
2670     On Error Resume Next
2671     Err.Clear
2672     Set here = fs.GetFolder(dirPath)
2673     If Err.Number = 0 Then Set children = here.Files
2674     If Err.Number = 0 Then
2675         For Each item In children
2676             list = list & item.Path & vbLf
        Next item
    End If
2679     If Err.Number <> 0 Then SweepListFailure dirPath, notes
2680     entries = Split(list, vbLf)
2681     For i = 0 To UBound(entries)
2682         If Len(entries(i)) > 0 Then SweepFile fs, CStr(entries(i)), notes
    Next i
2684     list = ""
2685     If Not here Is Nothing Then Set children = here.SubFolders
2686     If Err.Number = 0 And Not here Is Nothing Then
2687         For Each item In children
2688             list = list & item.Path & vbLf
        Next item
    End If
2691     If Err.Number <> 0 Then SweepListFailure dirPath, notes
2692     entries = Split(list, vbLf)
2693     For i = 0 To UBound(entries)
2694         If Len(entries(i)) > 0 Then SweepFolder fs, CStr(entries(i)), notes
    Next i
End Sub

Private Function PrivacySweep(ByVal folder As String) As String
    ' Before the zip: EVERY file in the output folder, listed in results.json or not. Returns the notes (files truncated or removed).
    Dim fs As Object, notes As String
2701     Set fs = CreateObject("Scripting.FileSystemObject")
2702     SweepFolder fs, folder, notes
2703     If Not fs.FolderExists(folder) Then SweepListFailure folder, notes
2704     If sweepAnsiSkipped Then
2705         SweepNote notes, "privacy sweep: ansi form not applicable (a name has characters the ANSI codepage cannot hold); UTF-8 and UTF-16 searched"
2706         sweepAnsiSkipped = False
    End If
2708     PrivacySweep = notes
End Function

Private Sub BlankProperties()
    Dim configs As Variant, config As Variant, manager As Object, itemName As Variant
    ' swSummInfoField_e: author 2, keywords 3, comment 4, saved-by 5. The neutral name goes into author and (if SolidWorks lets a macro
    ' write it) saved-by; keywords and comment are blank. SolidWorks stamps the saving user again at SaveAs: see RecordReadback.
    stepLabel = currentIdentity & ": BlankProperties SummaryInfo"
2716     doc.SummaryInfo(2) = NEUTRAL_VALUE
    stepLabel = currentIdentity & ": BlankProperties SummaryInfo"
2718     doc.SummaryInfo(3) = ""
    stepLabel = currentIdentity & ": BlankProperties SummaryInfo"
2720     doc.SummaryInfo(4) = ""
2721     On Error Resume Next
    stepLabel = currentIdentity & ": BlankProperties SummaryInfo"
2723     doc.SummaryInfo(5) = NEUTRAL_VALUE
2724     Err.Clear
2725     On Error GoTo 0
    stepLabel = currentIdentity & ": BlankProperties CustomPropertyManager"
2727     Set manager = doc.Extension.CustomPropertyManager("")
2728     For Each itemName In Array("Author", "Company", "DrawnBy", "CheckedBy")
    stepLabel = currentIdentity & ": BlankProperties Delete2"
2730         manager.Delete2 CStr(itemName)
    stepLabel = currentIdentity & ": BlankProperties Add3"
2732         If manager.Add3(CStr(itemName), 30, "", 2) <> 0 Then Err.Raise 5, , "Custom property blanking failed"
    Next itemName
    stepLabel = currentIdentity & ": BlankProperties GetConfigurationNames"
2735     configs = doc.GetConfigurationNames()
2736     If Not IsEmpty(configs) Then
2737         For Each config In configs
    stepLabel = currentIdentity & ": BlankProperties CustomPropertyManager"
2739             Set manager = doc.Extension.CustomPropertyManager(CStr(config))
2740             For Each itemName In Array("Author", "Company", "DrawnBy", "CheckedBy")
    stepLabel = currentIdentity & ": BlankProperties Delete2"
2742                 manager.Delete2 CStr(itemName)
    stepLabel = currentIdentity & ": BlankProperties Add3"
2744                 If manager.Add3(CStr(itemName), 30, "", 2) <> 0 Then Err.Raise 5, , "Custom property blanking failed"
            Next itemName
        Next config
    End If
End Sub

Private Function Quote(ByVal text As String) As String
    Dim code As Long
2752     text = Replace(text, "\", "\\")
2753     text = Replace(text, Chr$(34), "\" & Chr$(34))
2754     text = Replace(text, vbCr, "\r")
2755     text = Replace(text, vbLf, "\n")
2756     text = Replace(text, vbTab, "\t")
2757     For code = 0 To 31
2758         text = Replace(text, Chr$(code), "\u" & Right$("0000" & Hex$(code), 4))
    Next code
2760     Quote = Chr$(34) & text & Chr$(34)
End Function

Private Function CleanError(ByVal text As String) As String
    Dim regex As Object
2765     If InStr(text, "Paths tried: ") > 0 Then CleanError = PrivacyScrub(text): Exit Function
2766     Set regex = CreateObject("VBScript.RegExp")
2767     regex.Global = True
    ' A drive path, a UNC path, or a "/" that begins a word ("mid/pair/block", an instance path in a placement report, is not one).
    ' The privacy scrub runs FIRST (it knows where a personal path ends, spaces and all); the generic strip then takes a drive path to the end of
    ' the line or a quote, like the privacy tail.
2771     text = PrivacyScrub(text)
2772     regex.Pattern = "[A-Za-z]:[\\/][^""'\r\n]*"
2773     text = regex.Replace(text, "<path>")
2774     regex.Pattern = "\\\\[^\s""']+"
2775     text = regex.Replace(text, "<path>")
2776     regex.Pattern = "(^|[\s""'(\[=,;:])/[^\s""']+"
2777     CleanError = PrivacyScrub(regex.Replace(text, "$1<path>"))
End Function

Private Sub WriteUtf8(ByVal path As String, ByVal text As String)
    Dim stream As Object, binaryStream As Object
2782     Set stream = CreateObject("ADODB.Stream")
2783     stream.Type = 2
2784     stream.Charset = "utf-8"
2785     stream.Open
2786     stream.WriteText text
2787     stream.Position = 0
2788     stream.Type = 1
2789     stream.Position = 3
2790     Set binaryStream = CreateObject("ADODB.Stream")
2791     binaryStream.Type = 1
2792     binaryStream.Open
2793     stream.CopyTo binaryStream
2794     binaryStream.SaveToFile path, 2
2795     binaryStream.Close
2796     stream.Close
End Sub

Private Sub Pick(ByVal entity As Object, ByVal appendSelection As Boolean, ByVal mark As Long)
    Dim data As Object, topology As SldWorks.Entity, sketchSegment As SldWorks.SketchSegment
    Dim selected As Boolean, before As Long, afterSelect As Long
2802     If Not replayingPicks Then RememberPick entity, appendSelection, mark
2803     callInputs = callInputs & " append=" & CStr(appendSelection) & " mark=" & CStr(mark)
    stepLabel = currentIdentity & ": Pick CreateSelectData" & " " & apiInputs & " " & callInputs
2805     Set data = doc.SelectionManager.CreateSelectData()
    stepLabel = currentIdentity & ": Pick Mark"
2807     data.Mark = mark
    ' An edge of a drawing view is selected in that view (ISelectData.View).
    stepLabel = currentIdentity & ": Pick View"
2810     If Not pickView Is Nothing Then Set data.View = pickView
    stepLabel = currentIdentity & ": Pick SketchSegment"
2812     If TypeOf entity Is SldWorks.SketchSegment Then
2813         Set sketchSegment = entity
    stepLabel = currentIdentity & ": Pick Select4" & " " & apiInputs & " " & callInputs
2815         If Not sketchSegment.Select4(appendSelection, data) Then Err.Raise 5, , "Sketch segment selection failed"
    Else
2817         Set topology = entity
        ' Baseline BEFORE Select4: round 3 measured it after a Select4 that
        ' returned False yet selected, and the fallback then selected twice.
    stepLabel = currentIdentity & ": Pick GetSelectedObjectCount2"
2821         before = doc.SelectionManager.GetSelectedObjectCount2(-1)
2822         selected = TryTopologySelect(topology, appendSelection, data)
2823         afterSelect = before
2824         If Not selected Then
    stepLabel = currentIdentity & ": Pick GetSelectedObjectCount2"
2826             afterSelect = doc.SelectionManager.GetSelectedObjectCount2(-1)
2827             callInputs = callInputs & " select4=False selected-before=" & CStr(before) & " after-select4=" & CStr(afterSelect)
2828             If Select4Grew(appendSelection, before, afterSelect) Then
2829                 RecordMitigation "select4-false-but-selected", True
2830                 fallbackSuccesses("select4-false-but-selected") = fallbackSuccesses("select4-false-but-selected") + 1
2831                 selected = True
            End If
        End If
2834         If Not selected Then
2835             RecordMitigation "select4->multiselect2", True
    stepLabel = currentIdentity & ": Pick MultiSelect2" & " " & apiInputs & " " & callInputs
2837             If doc.Extension.MultiSelect2(Array(entity), appendSelection, data) <> 1 Then
2838                 If Not AppendCountConfirms(appendSelection, before, afterSelect) Then Err.Raise 5, , "Entity selection failed (Select4 and MultiSelect2)"
            End If
2840             fallbackSuccesses("select4->multiselect2") = fallbackSuccesses("select4->multiselect2") + 1
        End If
    End If
End Sub

Private Sub RememberPick(ByVal entity As Object, ByVal appendSelection As Boolean, ByVal mark As Long)
    ' Keep what Pick selected, for ReplayPicks. A selection that is not appended to starts a new list; more than four entities cannot be kept.
2847     If Not appendSelection Then pickCount = 0
2848     If pickCount < 0 Then Exit Sub
2849     If pickCount > 3 Then
2850         pickCount = -1
2851         Exit Sub
    End If
2853     Set pickEntities(pickCount) = entity
2854     pickAppends(pickCount) = appendSelection
2855     pickMarks(pickCount) = mark
2856     pickCount = pickCount + 1
End Sub

Private Function Select4Grew(ByVal appendSelection As Boolean, ByVal before As Long, ByVal after As Long) As Boolean
    ' Did a Select4 that returned False select anyway? Appending: grew by one.
    ' Replacing: only from an empty selection to one; otherwise fall back.
2862     If appendSelection Then
2863         Select4Grew = (after = before + 1)
    Else
2865         Select4Grew = (before = 0 And after = 1)
    End If
End Function

Private Function AppendCountConfirms(ByVal appendSelection As Boolean, ByVal before As Long, ByVal afterSelect As Long) As Boolean
    ' Revision 34.4.0: an appended MultiSelect2 never returned 1 while the
    ' first, non-appended entity did. Accept it if the selection grew by one
    ' since before Select4.
    Dim after As Long
2874     If Not appendSelection Then Exit Function
2875     RecordMitigation "multiselect2-append-count", True
2876     after = doc.SelectionManager.GetSelectedObjectCount2(-1)
2877     callInputs = callInputs & " selected-before=" & CStr(before) & " after-select4=" & CStr(afterSelect) & " after=" & CStr(after)
2878     stepLabel = stepLabel & " selected-before=" & CStr(before) & " after-select4=" & CStr(afterSelect) & " after=" & CStr(after)
2879     If after <> before + 1 Then Exit Function
2880     fallbackSuccesses("multiselect2-append-count") = fallbackSuccesses("multiselect2-append-count") + 1
2881     AppendCountConfirms = True
End Function

Private Function MatrixUsable(ByVal matrix As Variant) As Boolean
    ' IMathTransform.ArrayData: rotation 0-8, translation 9-11, scale 12.
    Dim i As Long, j As Long, k As Long, first As Long, dot As Double, expected As Double
2887     If Not IsArray(matrix) Then Exit Function
2888     first = LBound(matrix)
2889     If UBound(matrix) - first < 12 Then Exit Function
2890     For i = 0 To 12
2891         If Not IsNumeric(matrix(first + i)) Then Exit Function
    Next i
2893     For i = 0 To 2
2894         For j = 0 To 2
2895             dot = 0#
2896             For k = 0 To 2
2897                 dot = dot + CDbl(matrix(first + 3 * i + k)) * CDbl(matrix(first + 3 * j + k))
            Next k
2899             expected = 0#
2900             If i = j Then expected = 1#
2901             If Abs(dot - expected) > 0.000001 Then Exit Function
        Next j
    Next i
2904     MatrixUsable = Abs(CDbl(matrix(first + 12))) > 0.000000001
End Function

Private Function MatrixPoint(ByVal matrix As Variant, ByVal x As Double, ByVal y As Double, ByVal z As Double) As Variant
    ' Row-vector convention: local = (p x R) * scale + translation.
    Dim first As Long, scaleFactor As Double, result(2) As Double, j As Long
2910     first = LBound(matrix)
2911     scaleFactor = CDbl(matrix(first + 12))
2912     For j = 0 To 2
2913         result(j) = (x * CDbl(matrix(first + j)) + y * CDbl(matrix(first + 3 + j)) + z * CDbl(matrix(first + 6 + j))) * scaleFactor + CDbl(matrix(first + 9 + j))
    Next j
2915     MatrixPoint = Array(result(0), result(1), result(2))
End Function

Private Function NumberList(ByVal values As Variant) As String
    Dim i As Long, text As String
2920     For i = LBound(values) To UBound(values)
2921         If i > LBound(values) Then text = text & ","
2922         text = text & Replace(CStr(values(i)), ",", ".")
    Next i
2924     NumberList = text
End Function

Private Function DrawingDocument(ByVal model As Object) As SldWorks.DrawingDoc
2928     Set DrawingDocument = model
End Function

Private Function ViewDrop(ByVal view As Object) As Long
    ' The model axis a drawing view looks along: the z column of its model-to-view rotation (row-vector
    ' convention). Round 8 (field, 34.4.0): the view beside the Top view has the rows (0,0,1), (-1,0,0),
    ' (0,-1,0), so its z column names X and its z row Y; the rotation only has to be a signed axis
    ' permutation (one +-1 and two zeros in every row and column, within 1e-9). A tilted view fails.
    Dim matrix As Variant, i As Long, j As Long, first As Long, ones As Long, zeros As Long, value As Double
    stepLabel = currentIdentity & ": ViewDrop ArrayData"
2938     matrix = view.ModelToViewTransform.ArrayData
2939     If Not MatrixUsable(matrix) Then Err.Raise 5, , "The drawing view transform is not a rotation"
2940     first = LBound(matrix)
2941     For i = 0 To 5
2942         ones = 0
2943         zeros = 0
2944         For j = 0 To 2
2945             If i < 3 Then
2946                 value = CDbl(matrix(first + 3 * i + j))
            Else
2948                 value = CDbl(matrix(first + 3 * j + (i - 3)))
            End If
2950             If Abs(Abs(value) - 1#) <= 0.000000001 Then ones = ones + 1
2951             If Abs(value) <= 0.000000001 Then zeros = zeros + 1
        Next j
2953         If ones <> 1 Or zeros <> 2 Then Err.Raise 5, , "The drawing view is not an axis-aligned view: its rotation is not a signed axis permutation: " & NumberList(matrix)
    Next i
2955     For i = 0 To 2
2956         If Abs(CDbl(matrix(first + 3 * i + 2))) > 0.5 Then ViewDrop = i
    Next i
End Function

Private Function ViewToModel(ByVal matrix As Variant, ByVal point As Variant) As Variant
    ' Undo IView.ModelToViewTransform: view = (model x R) * scale + t, R orthonormal.
    Dim first As Long, i As Long, j As Long, v(2) As Double, result(2) As Double
2963     first = LBound(matrix)
2964     For j = 0 To 2
2965         v(j) = (CDbl(point(j)) - CDbl(matrix(first + 9 + j))) / CDbl(matrix(first + 12))
    Next j
2967     For i = 0 To 2
2968         For j = 0 To 2
2969             result(i) = result(i) + v(j) * CDbl(matrix(first + 3 * i + j))
        Next j
    Next i
2972     ViewToModel = Array(result(0), result(1), result(2))
End Function

Private Function RotateToModel(ByVal matrix As Variant, ByVal axis As Variant) As Variant
    ' A direction from view space to model space: the rotation of ViewToModel only, no scale and no translation.
    Dim first As Long, i As Long, j As Long, result(2) As Double
2978     first = LBound(matrix)
2979     For i = 0 To 2
2980         For j = 0 To 2
2981             result(i) = result(i) + CDbl(axis(j)) * CDbl(matrix(first + 3 * i + j))
        Next j
    Next i
2984     RotateToModel = Array(result(0), result(1), result(2))
End Function

Private Function FlatPoint(ByVal point As Variant, ByVal drop As Long) As Variant
2988     Select Case drop
        Case 0: FlatPoint = Array(CDbl(point(1)), CDbl(point(2)))
        Case 1: FlatPoint = Array(CDbl(point(0)), CDbl(point(2)))
        Case Else: FlatPoint = Array(CDbl(point(0)), CDbl(point(1)))
    End Select
End Function

Private Function NearFlat(ByVal a As Variant, ByVal b As Variant) As Boolean
2996     NearFlat = Abs(CDbl(a(0)) - CDbl(b(0))) <= 0.000001 And Abs(CDbl(a(1)) - CDbl(b(1))) <= 0.000001
End Function

Private Function InsideBox(ByVal point As Variant, ByVal low As Variant, ByVal high As Variant) As Boolean
    Dim i As Long
3001     For i = 0 To 2
3002         If CDbl(point(i)) < CDbl(low(i)) - 0.000001 Or CDbl(point(i)) > CDbl(high(i)) + 0.000001 Then Exit Function
    Next i
3004     InsideBox = True
End Function

Private Function RecordPoint(ByVal record As Object, ByVal key As String, ByVal convert As Long, ByVal matrix As Variant) As Variant
    ' A record's stored point as model meters: as reported (convert = 0) or with the view transform undone (1).
    Dim stored As Variant
3010     stored = record(key)
3011     If convert = 0 Then
3012         RecordPoint = Array(CDbl(stored(0)), CDbl(stored(1)), CDbl(stored(2)))
    Else
3014         RecordPoint = ViewToModel(matrix, stored)
    End If
End Function

Private Sub AddEdgeRecords(ByVal found As Collection, ByVal raw As Variant)
    ' The line and circle records (entity and the points SolidWorks reports) of an array of IEdge.
    Dim entity As Variant, curve As Object, record As Object, parameters As Variant
3021     For Each entity In raw
    stepLabel = currentIdentity & ": AddEdgeRecords GetCurve"
3023         Set curve = entity.GetCurve()
3024         If Not curve Is Nothing Then
    stepLabel = currentIdentity & ": AddEdgeRecords IsLine"
3026             If curve.IsLine() Then
3027                 Set record = CreateObject("Scripting.Dictionary")
3028                 record("kind") = "line"
3029                 Set record("entity") = entity
    stepLabel = currentIdentity & ": AddEdgeRecords GetPoint"
3031                 record("p0") = entity.GetStartVertex().GetPoint()
    stepLabel = currentIdentity & ": AddEdgeRecords GetPoint"
3033                 record("p1") = entity.GetEndVertex().GetPoint()
    stepLabel = currentIdentity & ": AddEdgeRecords Add"
3035                 found.Add record
            ElseIf curve.IsCircle() Then
    stepLabel = currentIdentity & ": AddEdgeRecords CircleParams"
3038                 parameters = curve.CircleParams
3039                 Set record = CreateObject("Scripting.Dictionary")
3040                 record("kind") = "circle"
3041                 Set record("entity") = entity
3042                 record("p0") = Array(CDbl(parameters(0)), CDbl(parameters(1)), CDbl(parameters(2)))
                ' ICurve.CircleParams: center x, y, z, axis x, y, z, radius.
3044                 record("axis") = Array(CDbl(parameters(3)), CDbl(parameters(4)), CDbl(parameters(5)))
3045                 record("radius") = CDbl(parameters(6))
3046                 record("raw") = Array(CDbl(parameters(0)), CDbl(parameters(1)), CDbl(parameters(2)), CDbl(parameters(3)), CDbl(parameters(4)), CDbl(parameters(5)), CDbl(parameters(6)))
    stepLabel = currentIdentity & ": AddEdgeRecords Add"
3048                 found.Add record
            End If
        End If
    Next entity
End Sub

Private Function ShiftPoint(ByVal point As Variant, ByVal shift As Variant) As Variant
3055     ShiftPoint = Array(CDbl(point(0)) + CDbl(shift(0)), CDbl(point(1)) + CDbl(shift(1)), CDbl(point(2)) + CDbl(shift(2)))
End Function

Private Function ComponentFits(ByVal mine As Collection, ByVal box As Variant, ByVal shift As Variant) As Boolean
    ' Do all the points of one component's edges lie in its box (meters, box(1) low, box(2) high) once moved by `shift`?
    Dim record As Object
3061     For Each record In mine
3062         If Not InsideBox(ShiftPoint(record("p0"), shift), box(1), box(2)) Then Exit Function
3063         If record("kind") = "line" Then
3064             If Not InsideBox(ShiftPoint(record("p1"), shift), box(1), box(2)) Then Exit Function
        End If
    Next record
3067     ComponentFits = True
End Function

Private Sub AddAssemblyEdges(ByVal view As Object, ByVal components As Variant, ByVal found As Collection)
    ' The drawing view of an assembly (D19a): IView.GetVisibleEntities2 takes the component whose edges are wanted (Nothing gives a part's), so each component
    ' the view shows is asked in turn (IView.GetVisibleComponents). components(k) = Array(name, low, high, shift) in meters: the component's box in the assembly
    ' and where its own origin stands there. The reported points are taken as assembly coordinates when they all lie in that box, else as the part's own
    ' coordinates moved by the shift (mitigation drawing-assembly-edges-part-space); when neither fits, the recipe fails naming the component.
    Dim shown As Variant, component As Variant, label As String, k As Long, which As Long, raw As Variant, mine As Collection, record As Object
    Dim shift As Variant, seen As String, viewName As String, moved As Boolean, box As Variant, size As Long
    stepLabel = currentIdentity & ": AddAssemblyEdges GetName2"
3078     viewName = view.GetName2()
    stepLabel = currentIdentity & ": AddAssemblyEdges GetVisibleComponents"
3080     shown = view.GetVisibleComponents()
3081     If Not IsArray(shown) Then Err.Raise 5, , viewName & ": GetVisibleComponents returned no components"
3082     seen = ","
3083     For Each component In shown
    stepLabel = currentIdentity & ": AddAssemblyEdges Name2"
3085         label = CStr(component.Name2)
3086         size = Len(label)
3087         Do While size > 0
3088             If Mid$(label, size, 1) Like "#" Then
3089                 size = size - 1
            Else
3091                 Exit Do
            End If
        Loop
3094         If size > 0 And size < Len(label) Then
3095             If Mid$(label, size, 1) = "-" Then label = Left$(label, size - 1)
        End If
3097         which = -1
3098         For k = 0 To UBound(components)
3099             If CStr(components(k)(0)) = label Then which = k
        Next k
3101         If which >= 0 Then
3102             box = components(which)
3103             seen = seen & label & ","
    stepLabel = currentIdentity & ": AddAssemblyEdges GetVisibleEntities2"
3105             raw = view.GetVisibleEntities2(component, swViewEntityType_Edge)
3106             If Not IsArray(raw) Then Err.Raise 5, , viewName & ": GetVisibleEntities2 returned no edges for the component " & label
3107             Set mine = New Collection
3108             AddEdgeRecords mine, raw
    stepLabel = currentIdentity & ": AddAssemblyEdges Count"
3110             If mine.Count = 0 Then Err.Raise 5, , viewName & ": GetVisibleEntities2 returned no edges for the component " & label
3111             shift = Array(0#, 0#, 0#)
3112             moved = False
3113             If Not ComponentFits(mine, box, shift) Then
3114                 shift = box(3)
3115                 moved = True
3116                 If Not ComponentFits(mine, box, shift) Then Err.Raise 5, , viewName & ": the edge points of the component " & label & " lie outside its box in assembly coordinates and in part coordinates moved to its place"
            End If
3118             If moved Then
3119                 RecordMitigation "drawing-assembly-edges-part-space", True, True
3120                 fallbackSuccesses("drawing-assembly-edges-part-space") = fallbackSuccesses("drawing-assembly-edges-part-space") + 1
            End If
3122             For Each record In mine
3123                 record("p0") = ShiftPoint(record("p0"), shift)
3124                 If record("kind") = "line" Then record("p1") = ShiftPoint(record("p1"), shift)
3125                 If record("kind") = "circle" Then record("raw") = Array(CDbl(record("p0")(0)), CDbl(record("p0")(1)), CDbl(record("p0")(2)), CDbl(record("raw")(3)), CDbl(record("raw")(4)), CDbl(record("raw")(5)), CDbl(record("raw")(6)))
    stepLabel = currentIdentity & ": AddAssemblyEdges Add"
3127                 found.Add record
            Next record
        End If
    Next component
3131     For k = 0 To UBound(components)
3132         If InStr(seen, "," & CStr(components(k)(0)) & ",") = 0 Then Err.Raise 5, , viewName & ": the view shows no edges of the component " & CStr(components(k)(0))
    Next k
End Sub

Private Function DrawingEdges(ByVal view As Object, ByVal low As Variant, ByVal high As Variant, ByRef drop As Long, ByRef spaceName As String, Optional ByVal components As Variant) As Collection
    ' The view's visible line and circle edges, flattened along its axis, in model meters. Entity
    ' coordinates are taken as model coordinates; if they do not all lie inside the model's box they
    ' are tried as view coordinates, and if that fails too the recipe fails. An assembly's view is read component by component (AddAssemblyEdges).
    Dim matrix As Variant, raw As Variant, found As Collection, record As Object
    Dim convert As Long, ok As Boolean, chosen As Long, viewName As String, axis As Variant, size As Double
    stepLabel = currentIdentity & ": DrawingEdges GetName2"
3143     viewName = view.GetName2()
    stepLabel = currentIdentity & ": DrawingEdges ArrayData"
3145     matrix = view.ModelToViewTransform.ArrayData
3146     drop = ViewDrop(view)
3147     Set found = New Collection
3148     If IsArray(components) Then
3149         AddAssemblyEdges view, components, found
    Else
    stepLabel = currentIdentity & ": DrawingEdges GetVisibleEntities2"
3152         raw = view.GetVisibleEntities2(Nothing, swViewEntityType_Edge)
3153         If Not IsArray(raw) Then Err.Raise 5, , viewName & ": GetVisibleEntities2 returned no edges"
3154         AddEdgeRecords found, raw
    End If
    stepLabel = currentIdentity & ": DrawingEdges Count"
3157     If found.Count = 0 Then Err.Raise 5, , viewName & ": none of its visible edges is a line or a circle"
3158     chosen = -1
3159     For convert = 0 To 1
3160         ok = True
3161         For Each record In found
3162             If Not InsideBox(RecordPoint(record, "p0", convert, matrix), low, high) Then ok = False
3163             If record("kind") = "line" Then
3164                 If Not InsideBox(RecordPoint(record, "p1", convert, matrix), low, high) Then ok = False
            End If
        Next record
3167         If ok Then
3168             chosen = convert
3169             Exit For
        End If
    Next convert
3172     If chosen < 0 Then Err.Raise 5, , viewName & ": the visible edge points lie outside the model box as model coordinates and as view coordinates (transform " & NumberList(matrix) & ")"
3173     spaceName = IIf(chosen = 0, "model", "view")
3174     For Each record In found
3175         record("a") = FlatPoint(RecordPoint(record, "p0", chosen, matrix), drop)
3176         If record("kind") = "line" Then record("b") = FlatPoint(RecordPoint(record, "p1", chosen, matrix), drop)
3177         If record("kind") = "circle" Then
            ' The circle's axis in model space (a view-space axis is only rotated), and whether the view looks straight down it: then it shows as a
            ' circle; otherwise (edge-on) as a straight line through its center, 2 x radius long.
3180             axis = record("axis")
3181             If chosen = 1 Then axis = RotateToModel(matrix, axis)
            ' faceOn: 1 the view looks down the axis, 0 the axis lies across the view, -1 unknown (a zero or non-unit axis, or one at an angle).
3183             size = Sqr(CDbl(axis(0)) * CDbl(axis(0)) + CDbl(axis(1)) * CDbl(axis(1)) + CDbl(axis(2)) * CDbl(axis(2)))
3184             If Abs(size - 1#) > 0.000001 Then
3185                 record("faceOn") = -1
            ElseIf Abs(Abs(CDbl(axis(drop))) - 1#) <= 0.000001 Then
3187                 record("faceOn") = 1
            ElseIf Abs(CDbl(axis(drop))) <= 0.000001 Then
3189                 record("faceOn") = 0
            Else
3191                 record("faceOn") = -1
            End If
3193             record("flatAxis") = FlatPoint(axis, drop)
        End If
    Next record
3196     Set DrawingEdges = found
End Function

Private Function PlanSingle(ByVal records As Collection, ByVal first As Variant, ByVal second As Variant) As Object
    ' A line whose two ends are the two points: selecting it alone dimensions its length.
    Dim record As Object
3202     For Each record In records
3203         If record("kind") = "line" Then
3204             If (NearFlat(record("a"), first) And NearFlat(record("b"), second)) Or (NearFlat(record("a"), second) And NearFlat(record("b"), first)) Then
3205                 Set PlanSingle = record
3206                 Exit Function
            End If
        End If
    Next record
End Function

Private Function CloneRecord(ByVal record As Object, ByVal rung As String) As Object
    ' A copy of an edge record marked with the mitigation name of the plan form that uses it (the cached record itself stays unmarked).
    Dim copy As Object, key As Variant
3215     Set copy = CreateObject("Scripting.Dictionary")
    stepLabel = currentIdentity & ": CloneRecord Keys"
3217     For Each key In record.Keys
3218         If IsObject(record(key)) Then
3219             Set copy(key) = record(key)
        Else
3221             copy(key) = record(key)
        End If
    Next key
3224     copy("rung") = rung
3225     Set CloneRecord = copy
End Function

Private Function PlanDiameter(ByVal records As Collection, ByVal first As Variant, ByVal second As Variant, ByVal length As Double) As Object
    ' A circle seen face-on whose diameter the two points are the ends of: selecting it alone makes IModelDoc2.AddDimension2 add a diameter dimension.
    Dim record As Object, centre As Variant
3231     For Each record In records
3232         If record("kind") = "circle" Then
3233             If record("faceOn") = 1 Then
3234                 centre = record("a")
3235                 If Abs(2# * CDbl(record("radius")) - length) <= 0.000001 And Abs(CDbl(centre(0)) - (first(0) + second(0)) / 2#) <= 0.000001 _
                   And Abs(CDbl(centre(1)) - (first(1) + second(1)) / 2#) <= 0.000001 Then
3237                     Set PlanDiameter = CloneRecord(record, "drawing-dimension-circle-diameter")
3238                     Exit Function
                End If
            End If
        End If
    Next record
End Function

Private Function PlanLine(ByVal records As Collection, ByVal point As Variant, ByVal ux As Double, ByVal uy As Double) As Object
    ' A line through the point that is perpendicular to the measuring direction.
    Dim record As Object, a As Variant, b As Variant, runX As Double, runY As Double, size As Double, along As Double, off As Double
3248     For Each record In records
3249         If record("kind") = "line" Then
3250             a = record("a")
3251             b = record("b")
3252             runX = b(0) - a(0)
3253             runY = b(1) - a(1)
3254             size = Sqr(runX * runX + runY * runY)
3255             If size > 0.000000001 Then
3256                 If Abs(runX * ux + runY * uy) <= 0.000001 * size Then
3257                     along = ((point(0) - a(0)) * runX + (point(1) - a(1)) * runY) / (size * size)
3258                     off = Abs((point(0) - a(0)) * runY - (point(1) - a(1)) * runX) / size
3259                     If along >= -0.000000001 And along <= 1.000000001 And off <= 0.000001 Then
3260                         Set PlanLine = record
3261                         Exit Function
                    End If
                End If
            End If
        End If
    Next record
End Function

Private Function PlanReference(ByVal records As Collection, ByVal point As Variant, ByVal ux As Double, ByVal uy As Double) As Object
    ' A circle centered on the point, else a line through it that is perpendicular to the measuring direction (D05a's own choice, tried first).
    Dim record As Object
3272     For Each record In records
3273         If record("kind") = "circle" Then
3274             If NearFlat(record("a"), point) Then
3275                 Set PlanReference = record
3276                 Exit Function
            End If
        End If
    Next record
3280     Set PlanReference = PlanLine(records, point, ux, uy)
End Function

Private Function PlanRim(ByVal records As Collection, ByVal point As Variant, ByVal ux As Double, ByVal uy As Double) As Object
    ' A circle seen edge-on (its axis known to lie across the view) is the straight line through its center, 2 x radius long, perpendicular to its axis: it
    ' is a reference when the point is on that line and the measuring direction is the axis's own.
    Dim record As Object, axisFlat As Variant, centre As Variant, runX As Double, runY As Double
3287     For Each record In records
3288         If record("kind") = "circle" Then
3289             If record("faceOn") = 0 Then
3290                 centre = record("a")
3291                 axisFlat = record("flatAxis")
3292                 runX = point(0) - centre(0)
3293                 runY = point(1) - centre(1)
3294                 If Abs(-axisFlat(1) * ux + axisFlat(0) * uy) <= 0.000001 And Abs(runX * axisFlat(0) + runY * axisFlat(1)) <= 0.000001 _
                   And Abs(-runX * axisFlat(1) + runY * axisFlat(0)) <= CDbl(record("radius")) + 0.000000001 Then
3296                     Set PlanRim = CloneRecord(record, "drawing-dimension-edge-on-circles")
3297                     Exit Function
                End If
            End If
        End If
    Next record
End Function

Private Function DimensionPlan(ByVal records As Collection, ByVal first As Variant, ByVal second As Variant) As Collection
    ' The one or two edges whose selection makes SolidWorks measure the distance between two flattened points, or Nothing when the view cannot show
    ' it. D05a's own plan (a line, or two references) is tried first; the diameter and edge-on forms only when it finds nothing.
    Dim lineRecord As Object, one As Object, two As Object, dx As Double, dy As Double, length As Double
3308     dx = second(0) - first(0)
3309     dy = second(1) - first(1)
3310     length = Sqr(dx * dx + dy * dy)
3311     If length < 0.000000001 Then Err.Raise 5, , "The two dimension points coincide in the view"
3312     Set lineRecord = PlanSingle(records, first, second)
3313     If Not lineRecord Is Nothing Then
3314         Set DimensionPlan = New Collection
    stepLabel = currentIdentity & ": DimensionPlan Add"
3316         DimensionPlan.Add lineRecord
3317         Exit Function
    End If
3319     Set one = PlanReference(records, first, dx / length, dy / length)
3320     Set two = PlanReference(records, second, dx / length, dy / length)
3321     If Not one Is Nothing And Not two Is Nothing Then
3322         If Not one Is two Then
3323             Set DimensionPlan = New Collection
    stepLabel = currentIdentity & ": DimensionPlan Add"
3325             DimensionPlan.Add one
    stepLabel = currentIdentity & ": DimensionPlan Add"
3327             DimensionPlan.Add two
3328             Exit Function
        End If
    End If
3331     Set lineRecord = PlanDiameter(records, first, second, length)
3332     If Not lineRecord Is Nothing Then
3333         Set DimensionPlan = New Collection
    stepLabel = currentIdentity & ": DimensionPlan Add"
3335         DimensionPlan.Add lineRecord
3336         Exit Function
    End If
3338     Set one = PlanRim(records, first, dx / length, dy / length)
3339     Set two = PlanRim(records, second, dx / length, dy / length)
3340     If one Is Nothing And two Is Nothing Then Exit Function
3341     If one Is Nothing Then Set one = PlanReference(records, first, dx / length, dy / length)
3342     If two Is Nothing Then Set two = PlanReference(records, second, dx / length, dy / length)
3343     If one Is Nothing Or two Is Nothing Then Exit Function
3344     If one("entity") Is two("entity") Then Exit Function
3345     Set DimensionPlan = New Collection
    stepLabel = currentIdentity & ": DimensionPlan Add"
3347     DimensionPlan.Add one
    stepLabel = currentIdentity & ": DimensionPlan Add"
3349     DimensionPlan.Add two
End Function

Private Function TryPick(ByVal entity As Object, ByVal appendSelection As Boolean) As Boolean
3353     On Error GoTo Failed
3354     Pick entity, appendSelection, 0
3355     TryPick = True
3356     Exit Function
Failed:
3358     TryPick = False
End Function

Private Function AddDrawingDimension(ByVal view As Object, ByVal plan As Collection, ByVal textX As Double, ByVal textY As Double, ByVal expectedMm As Double, ByVal label As String) As Double
    ' Select the planned edges in the view, add the dimension, and read its value back.
    Dim record As Object, i As Long, selected As Long, display As Object, measured As Double, kinds As String
3364     For Each record In plan
3365         If Len(kinds) > 0 Then kinds = kinds & "+"
3366         kinds = kinds & CStr(record("kind"))
    Next record
    stepLabel = currentIdentity & ": AddDrawingDimension GetName2"
3369     callInputs = label & " view=" & view.GetName2() & " edges=" & kinds & " text(m)=" & NumberList(Array(textX, textY)) & " expected(mm)=" & NumberList(Array(expectedMm))
    stepLabel = currentIdentity & ": AddDrawingDimension ActivateView"
3371     If Not drawingInterface.ActivateView(view.GetName2()) Then Err.Raise 5, , "ActivateView failed: " & callInputs
    stepLabel = currentIdentity & ": AddDrawingDimension ClearSelection2"
3373     doc.ClearSelection2 True
3374     Set pickView = view
3375     i = 0
3376     For Each record In plan
3377         If Not TryPick(record("entity"), i > 0) Then
3378             RecordMitigation "drawing-select-entity-via-view", True, True
    stepLabel = currentIdentity & ": AddDrawingDimension SelectEntity" & " " & apiInputs & " " & callInputs
3380             If Not view.SelectEntity(record("entity"), i > 0) Then Err.Raise 5, , "IView.SelectEntity failed after the Select4 selection failed: " & callInputs
3381             fallbackSuccesses("drawing-select-entity-via-view") = fallbackSuccesses("drawing-select-entity-via-view") + 1
        End If
3383         i = i + 1
    Next record
3385     Set pickView = Nothing
    stepLabel = currentIdentity & ": AddDrawingDimension GetSelectedObjectCount2"
3387     selected = doc.SelectionManager.GetSelectedObjectCount2(-1)
    stepLabel = currentIdentity & ": AddDrawingDimension Count"
3389     If selected <> plan.Count Then Err.Raise 5, , CStr(selected) & " edges are selected, not " & CStr(plan.Count) & ": " & callInputs
    stepLabel = currentIdentity & ": AddDrawingDimension AddDimension2"
3391     Set display = doc.AddDimension2(textX, textY, 0#)
3392     Require display, "AddDimension2 returned no dimension: " & callInputs
    stepLabel = currentIdentity & ": AddDrawingDimension GetDimension2"
3394     Set dimensionValue = display.GetDimension2(0)
3395     Require dimensionValue, "The new dimension has no value object: " & callInputs
    stepLabel = currentIdentity & ": AddDrawingDimension SystemValue"
3397     measured = dimensionValue.SystemValue / 0.001
3398     If Abs(measured - expectedMm) > 0.000001 Then Err.Raise 5, , "The drawing dimension measured " & NumberList(Array(measured)) & " mm, not " & NumberList(Array(expectedMm)) & " mm: " & callInputs
    stepLabel = currentIdentity & ": AddDrawingDimension ClearSelection2"
3400     doc.ClearSelection2 True
3401     AddDrawingDimension = measured
End Function

Private Function DrawingReadBack(ByVal expected As Variant) As String
    ' Every display dimension in the drawing, read from the drawing, must be exactly the recipe's values.
    Dim seen As Object, view As Object, display As Object, key As String, listing As String, i As Long
3407     Set seen = CreateObject("Scripting.Dictionary")
    stepLabel = currentIdentity & ": DrawingReadBack GetFirstView"
3409     Set view = drawingInterface.GetFirstView()
3410     Do While Not view Is Nothing
    stepLabel = currentIdentity & ": DrawingReadBack GetFirstDisplayDimension5"
3412         Set display = view.GetFirstDisplayDimension5()
3413         Do While Not display Is Nothing
    stepLabel = currentIdentity & ": DrawingReadBack GetDimension2"
3415             key = CStr(Round(display.GetDimension2(0).SystemValue * 1000#, 4))
3416             If Len(listing) > 0 Then listing = listing & ", "
    stepLabel = currentIdentity & ": DrawingReadBack GetName2"
3418             listing = listing & view.GetName2() & " " & key & " mm"
    stepLabel = currentIdentity & ": DrawingReadBack Exists"
3420             If seen.Exists(key) Then
3421                 seen(key) = seen(key) + 1
            Else
    stepLabel = currentIdentity & ": DrawingReadBack Add"
3424                 seen.Add key, 1
            End If
    stepLabel = currentIdentity & ": DrawingReadBack GetNext3"
3427             Set display = display.GetNext3()
        Loop
    stepLabel = currentIdentity & ": DrawingReadBack GetNextView"
3430         Set view = view.GetNextView()
    Loop
3432     For i = LBound(expected) To UBound(expected)
3433         key = CStr(Round(CDbl(expected(i)), 4))
    stepLabel = currentIdentity & ": DrawingReadBack Exists"
3435         If Not seen.Exists(key) Then Err.Raise 5, , "The drawing is missing the dimension " & key & " mm; it holds: " & listing
3436         If seen(key) = 1 Then
    stepLabel = currentIdentity & ": DrawingReadBack Remove"
3438             seen.Remove key
        Else
3440             seen(key) = seen(key) - 1
        End If
    Next i
    stepLabel = currentIdentity & ": DrawingReadBack Count"
3444     If seen.Count > 0 Then Err.Raise 5, , "The drawing holds more dimensions than the recipe's: " & listing
3445     DrawingReadBack = listing
End Function

Private Sub ExportDrawing(ByVal path As String)
    ' A copy of the sheet as DXF (R2000, which the recipe allows); the file must exist and hold data.
    Dim previous As Long, fs As Object, failureNumber As Long, failure As String, failingStep As String
    stepLabel = currentIdentity & ": ExportDrawing GetUserPreferenceIntegerValue"
3452     previous = app.GetUserPreferenceIntegerValue(swDxfVersion)
    stepLabel = currentIdentity & ": ExportDrawing SetUserPreferenceIntegerValue"
3454     If Not app.SetUserPreferenceIntegerValue(swDxfVersion, swDxfFormat_R2000) Then Err.Raise 5, , "Cannot set the DXF version"
3455     On Error Resume Next
    stepLabel = currentIdentity & ": ExportDrawing GetUserPreferenceIntegerValue"
3457     If app.GetUserPreferenceIntegerValue(swDxfVersion) <> swDxfFormat_R2000 Then Err.Raise 5, , "The DXF version did not stay at R2000"
3458     If Err.Number = 0 Then SaveFile path
3459     failureNumber = Err.Number
3460     failure = Err.Description
3461     failingStep = stepLabel
3462     Err.Clear
    stepLabel = currentIdentity & ": ExportDrawing SetUserPreferenceIntegerValue"
3464     app.SetUserPreferenceIntegerValue swDxfVersion, previous
3465     stepLabel = failingStep
3466     On Error GoTo 0
3467     If failureNumber <> 0 Then Err.Raise failureNumber, , failure
3468     stepLabel = currentIdentity & ": DXF file check"
3469     Set fs = CreateObject("Scripting.FileSystemObject")
    stepLabel = currentIdentity & ": ExportDrawing FileExists"
3471     If Not fs.FileExists(path) Then Err.Raise 5, , "The DXF export wrote no file"
    stepLabel = currentIdentity & ": ExportDrawing GetFile"
3473     If fs.GetFile(path).Size = 0 Then Err.Raise 5, , "The DXF export wrote an empty file"
    stepLabel = currentIdentity & ": ExportDrawing GetFileName"
3475     AppendLog currentFolder, currentIdentity, "option", 0, 0, "drawing DXF: " & fs.GetFileName(path) & ", " & CStr(fs.GetFile(path).Size) & " bytes, DXF version R2000 (3), previous setting " & CStr(previous) & " restored; scale and text options left at the user defaults (the interop does not say what their values mean)"
End Sub
