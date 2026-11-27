Attribute VB_Name = "FixtureDrawings"
Option Explicit
' SolidWorks 2018+. Tools > Macro > New, import this .bas, run main. Optional second macro: it draws the parts an earlier Fixture Builder run left in a folder.
' Fixture Drawings version 2026.11.26.2 (the drawings package). It opens the parts read-only and never writes into that folder.
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
Private Const swOpenDocOptions_Silent As Long = 1
Private Const swDocPART As Long = 1
Private Const swViewEntityType_Edge As Long = 1
Private Const swDxfVersion As Long = 0
Private Const swDxfFormat_R2000 As Long = 3
Private Const swDetailingNoOptionSpecified As Long = 0
Private Const swOpenDocOptions_ReadOnly As Long = 2
Private Const swDelete_Absorbed As Long = 2
Private Const swCustomInfoText As Long = 30
Private Const swCustomPropertyReplaceValue As Long = 2
Private Const swCustomInfoGetResult_NotPresent As Long = 1
Private Const swDetailingDimensionStandard As Long = 13
Private Const swUnitsLinear As Long = 47
' SolidWorks 2018+. Tools > Macro > New, import this .bas, run main.
' Fixture Builder version 2026.11.26.2 (sheet metal, expect.json checks, round 5).
Private Const BUILDER_VERSION As String = "2026.11.26.2"
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
Private packageFolder As String
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
107     On Error GoTo Fatal
108     currentIdentity = "setup"
    ' First of all, before SolidWorks is touched or a folder made: the output root (the builder's, in Public\Documents unless the settings say
    ' otherwise) must carry no personal path; the run folder is checked next, then the drawing template.
111     target = PackageOutputRoot()
112     finalMessage = PersonalPathReason(target)
113     If Len(finalMessage) > 0 Then GoTo Cleanup
    stepLabel = currentIdentity & ": main SldWorks"
115     Set app = Application.SldWorks
116     Set fs = CreateObject("Scripting.FileSystemObject")
117     runFolder = PackageNewestRun(target)
118     If Not IsUnattended() Then
119         runFolder = InputBox("Folder of an earlier Fixture Builder run (the one that holds the .sldprt files; it must be in a neutral folder, as the builder 2026.11.25.3 or later makes). The drawings go into a new folder in the builder's output folder; nothing in the run folder is changed.", "Dutchman Fixtures", runFolder)
    End If
121     runFolder = Trim$(runFolder)
122     Do While Len(runFolder) > 3 And Right$(runFolder, 1) = "\"
123         runFolder = Left$(runFolder, Len(runFolder) - 1)
    Loop
125     If Len(runFolder) = 0 Then
126         If Not IsUnattended() Then MsgBox "No folder was chosen, so nothing was drawn.", vbInformation, "SolidWorks fixtures"
127         Exit Sub
    End If
    ' A part keeps its own save path and a drawing keeps the part's: a run made in a personal folder would put that path into every drawing.
130     finalMessage = PackageRunFolderReason(runFolder)
131     If Len(finalMessage) > 0 Then GoTo Cleanup
    stepLabel = currentIdentity & ": main FolderExists"
133     If Not fs.FolderExists(runFolder) Then
134         finalMessage = "That folder was not found, so nothing was drawn: " & runFolder
135         GoTo Cleanup
    End If
137     finalMessage = PackageTemplateRefusal()
138     If Len(finalMessage) > 0 Then GoTo Cleanup
    ' The up-front notice, once per run: Cancel draws nothing.
140     noticeNote = NoticeStep(False)
141     If Len(noticeNote) = 0 Then
142         finalMessage = "Canceled at the user name notice. Nothing was drawn."
143         GoTo Cleanup
    End If
145     For i = 2 To 5
146         rbStatus(i) = ""
    Next i
148     sweepEmptied = ""
149     sweepEmptiedCount = 0
150     sweepListFailed = False
151     sweepAnsiSkipped = False
152     packageFolder = runFolder
    stepLabel = currentIdentity & ": main GetUserPreferenceToggle"
154     oldInput = app.GetUserPreferenceToggle(swInputDimValOnCreate)
155     inputSaved = True
    stepLabel = currentIdentity & ": main SetUserPreferenceToggle"
157     app.SetUserPreferenceToggle swInputDimValOnCreate, False
    stepLabel = currentIdentity & ": main GetUserPreferenceToggle"
159     oldRebuild = app.GetUserPreferenceToggle(swShowErrorsEveryRebuild)
160     rebuildSaved = True
    stepLabel = currentIdentity & ": main SetUserPreferenceToggle"
162     app.SetUserPreferenceToggle swShowErrorsEveryRebuild, False
    stepLabel = currentIdentity & ": main GetUserPreferenceToggle"
164     oldWarn = app.GetUserPreferenceToggle(swWarnSaveUpdateErrors)
165     warnSaved = True
    stepLabel = currentIdentity & ": main SetUserPreferenceToggle"
167     app.SetUserPreferenceToggle swWarnSaveUpdateErrors, False
    stepLabel = currentIdentity & ": main GetUserPreferenceIntegerValue"
169     oldAction = app.GetUserPreferenceIntegerValue(swRebuildErrorAction)
170     actionSaved = True
    stepLabel = currentIdentity & ": main SetUserPreferenceIntegerValue"
172     If Not app.SetUserPreferenceIntegerValue(swRebuildErrorAction, swContinueResponse_Stop) Then Err.Raise 5, , "Cannot disable rebuild prompt"
    stepLabel = currentIdentity & ": main RevisionNumber"
174     revision = app.RevisionNumber()
175     pieces = Split(revision, ".")
176     swMajor = CLng(pieces(0))
177     version = CStr(CLng(pieces(0)) + 1992)
178     build = "0"
179     If UBound(pieces) > 0 Then
180         build = pieces(1)
181         For i = 2 To UBound(pieces)
182             build = build & "-" & pieces(i)
        Next i
    End If
    ' Always a NEW folder in the output root: FixtureDrawings-SolidWorks-<version>, then -2, -3 ... Never deleted or reused.
186     EnsureFolder fs, target
187     outName = "FixtureDrawings-SolidWorks-" & BUILDER_VERSION
    stepLabel = currentIdentity & ": main BuildPath"
189     folder = fs.BuildPath(target, outName)
190     attempt = 1
    stepLabel = currentIdentity & ": main FolderExists"
192     Do While fs.FolderExists(folder) Or fs.FileExists(folder & ".zip")
193         attempt = attempt + 1
194         outName = "FixtureDrawings-SolidWorks-" & BUILDER_VERSION & "-" & CStr(attempt)
    stepLabel = currentIdentity & ": main BuildPath"
196         folder = fs.BuildPath(target, outName)
    Loop
    stepLabel = currentIdentity & ": main CreateFolder" & " " & apiInputs & " " & callInputs
199     fs.CreateFolder folder
200     resultRows = ""
    stepLabel = currentIdentity & ": main BuildPath"
202     WriteUtf8 fs.BuildPath(folder, "results.json"), "[]"
    stepLabel = currentIdentity & ": main GetFileName"
204     AppendLog folder, "setup", "Fixture Drawings " & BUILDER_VERSION, 0, 0, "SolidWorks revision " & revision & "; run folder " & fs.GetFileName(runFolder) & "; output folder " & outName & "; personal-path check: passed (output folder and run folder)"
205     AppendLog folder, "setup", "template path", 0, 0, "template path: neutral"
206     AppendLog folder, "setup", "user name notice", 0, 0, noticeNote
207     For i = 0 To PackageCount() - 1
208         RunPackage i, folder, version, build, CLng(pieces(0))
    Next i
210     AppendLog folder, "setup", "summary", 0, 0, "summary: ok=" & CStr(CountStatus("ok")) & " failed=" & CStr(CountStatus("failed")) & _
        " not_scripted=" & CStr(CountStatus("not_scripted")) & " skipped=" & CStr(CountStatus("skipped"))
212     AppendLog folder, "setup", "summary info", 0, 0, ReadbackText()
213     AppendLog folder, "setup", "summary info", 0, 0, "SolidWorks stamps the saving user in each file: not removable by the API"
214     AppendLog folder, "setup", "summary info", 0, 0, "SolidWorks also records its Windows temp folder (under your user profile) in each native file; we keep native files private and publish only STEP and files we've checked clean."
    ' Before the zip: every file in the output folder, listed or not, is scrubbed (see PrivacySweep).
216     swept = True
217     sweepNotes = PrivacySweep(folder)
218     If Len(sweepNotes) > 0 Then AppendLog folder, "setup", "privacy sweep", 0, 0, sweepNotes
219     zipMade = False
220     If Not sweepListFailed Then zipMade = MakeZip(folder)        ' a folder that could not be checked is never zipped
221     zipError = folder & "-zip-error.txt"
    stepLabel = currentIdentity & ": main FileExists"
223     If fs.FileExists(zipError) Then SweepFile fs, zipError, sweepNotes
224     If zipMade Then SaveSetting "DutchmanFixtures", "SolidWorksBuilder", "LastZip", folder & ".zip"
225     finishText = FinishMessage(CountStatus("ok") + CountStatus("failed") + CountStatus("not_scripted") + CountStatus("skipped"), _
        CountStatus("ok"), CountStatus("failed"), CountStatus("not_scripted"), CountStatus("skipped"), folder & ".zip", zipMade, folder)
227     AppendLog folder, "setup", "finish", 0, 0, finishText
228     GoTo Cleanup
Fatal:
    fatalLine = Erl: fatalNumber = Err.Number: fatalDescription = Err.Description: fatalStep = stepLabel
231     finalMessage = fatalStep & " (line " & CStr(fatalLine) & "): " & fatalDescription
232     On Error Resume Next
233     swept = False        ' an error after the sweep (in the zip step) is swept again on the way out
234     If Len(folder) > 0 Then AppendLog folder, currentIdentity, fatalStep, fatalLine, fatalNumber, fatalDescription
235     Resume Cleanup
Cleanup:
237     On Error Resume Next
238     Err.Clear
    ' Every way out of main passes here: the folder is swept once, so an error part way leaves no unswept text file.
240     If Len(folder) > 0 And Not swept Then
241         swept = True
242         sweepNotes = PrivacySweep(folder)
243         If Len(sweepNotes) > 0 Then AppendLog folder, "setup", "privacy sweep", 0, 0, sweepNotes
    End If
245     Err.Clear
    stepLabel = currentIdentity & ": main SetUserPreferenceIntegerValue"
247     If actionSaved Then app.SetUserPreferenceIntegerValue swRebuildErrorAction, oldAction
248     If Err.Number <> 0 Then ReportCleanupError folder, finalMessage
249     Err.Clear
    stepLabel = currentIdentity & ": main SetUserPreferenceToggle"
251     If warnSaved Then app.SetUserPreferenceToggle swWarnSaveUpdateErrors, oldWarn
252     If Err.Number <> 0 Then ReportCleanupError folder, finalMessage
253     Err.Clear
    stepLabel = currentIdentity & ": main SetUserPreferenceToggle"
255     If rebuildSaved Then app.SetUserPreferenceToggle swShowErrorsEveryRebuild, oldRebuild
256     If Err.Number <> 0 Then ReportCleanupError folder, finalMessage
257     Err.Clear
    stepLabel = currentIdentity & ": main SetUserPreferenceToggle"
259     If inputSaved Then app.SetUserPreferenceToggle swInputDimValOnCreate, oldInput
260     If Err.Number <> 0 Then ReportCleanupError folder, finalMessage
261     Err.Clear
    ' FIXTURE_UNATTENDED=1: no Explorer window and no message box, only the log line written above.
263     If Len(finalMessage) > 0 Then
264         If Not IsUnattended() Then MsgBox PrivacyScrub(finalMessage), vbExclamation, "SolidWorks fixtures"
    ElseIf Len(finishText) > 0 And Not IsUnattended() Then
266         If zipMade Then
    stepLabel = currentIdentity & ": main Run"
268             CreateObject("WScript.Shell").Run "explorer.exe /select,""" & folder & ".zip""", 1, False
        Else
    stepLabel = currentIdentity & ": main Run"
271             CreateObject("WScript.Shell").Run "explorer.exe """ & folder & """", 1, False
        End If
273         Err.Clear
274         MsgBox PrivacyScrub(finishText), vbInformation, "SolidWorks fixtures"
    End If
End Sub

Private Function PackageOutputRoot() As String
    ' The builder's output root: OUTPUT_FOLDER when it is set, else the launcher's OutputRoot setting, else the neutral default
    ' (Public\Documents\FixtureBuilder). The old Documents\FixtureBuilder is never looked in: it is a personal folder.
    Dim rootFolder As String
282     rootFolder = OUTPUT_FOLDER
283     If Len(rootFolder) = 0 Then rootFolder = GetSetting("DutchmanFixtures", "SolidWorksBuilder", "OutputRoot", "")
284     If Len(rootFolder) = 0 Then rootFolder = DefaultOutputRoot()
285     PackageOutputRoot = rootFolder
End Function

Private Function PackageRunFolderReason(ByVal runFolder As String) As String
    ' "" when the run folder is neutral, else the refusal. A part keeps its own save path inside the file and a drawing references the part's path,
    ' so drawings made from a run in a personal folder would carry that path. The text never repeats the folder.
291     If Not DriveRooted(runFolder) Then
292         PackageRunFolderReason = "The run folder was refused because the folder must be a full path starting with a drive letter. Nothing was drawn."
    ElseIf Len(PersonalWhy(runFolder, True)) > 0 Then
294         PackageRunFolderReason = "This run was made in a personal folder, so its parts carry that folder's path. Run the Fixture Builder " & BUILDER_VERSION & " or later first; it saves to " & DefaultOutputRoot() & "."
    End If
End Function

Private Function PackageTemplateRefusal() As String
    ' The drawing template is the only one the package uses (a drawing keeps the path of its template and sheet format).
    Dim path As String
301     On Error Resume Next
302     path = ResolveTemplate("drawing")
303     Err.Clear
304     On Error GoTo 0
305     If Len(path) > 0 Then PackageTemplateRefusal = PersonalTemplateReason("drawing", path)
End Function

Private Function PackageNewestRun(ByVal rootFolder As String) As String
    ' The newest FixtureBuilder-SolidWorks-* folder under the (neutral) output root ("" when there is none).
    Dim fs As Object, candidate As Object, best As Object
311     Set fs = CreateObject("Scripting.FileSystemObject")
    stepLabel = currentIdentity & ": PackageNewestRun FolderExists"
313     If Not fs.FolderExists(rootFolder) Then Exit Function
    stepLabel = currentIdentity & ": PackageNewestRun GetFolder"
315     For Each candidate In fs.GetFolder(rootFolder).SubFolders
    stepLabel = currentIdentity & ": PackageNewestRun Name"
317         If InStr(1, candidate.Name, "FixtureBuilder-SolidWorks-", vbTextCompare) = 1 Then
318             If best Is Nothing Then
319                 Set best = candidate
            ElseIf candidate.DateLastModified > best.DateLastModified Then
321                 Set best = candidate
            End If
        End If
    Next candidate
    stepLabel = currentIdentity & ": PackageNewestRun Path"
326     If Not best Is Nothing Then PackageNewestRun = best.Path
End Function

Private Function FinishMessage(ByVal total As Long, ByVal made As Long, ByVal failed As Long, ByVal notScripted As Long, ByVal skipped As Long, ByVal zipPath As String, ByVal zipMade As Boolean, ByVal folder As String) As String
    Dim noun As String, counts As String
331     noun = "drawings"
332     If total = 1 Then noun = "drawing"
333     counts = CStr(total) & " " & noun & ": " & CStr(made) & " made, " & CStr(failed) & " failed, " & CStr(notScripted) & _
        " not scripted, " & CStr(skipped) & " skipped (details in FixtureDrawings.log)." & EmptiedLine()
335     If sweepListFailed Then
336         FinishMessage = counts & vbLf & "The zip was not made because the output folder could not be checked; nothing was sent."
    ElseIf zipMade Then
338         FinishMessage = counts & vbLf & "Next: post this zip in your builder thread, or send it to Dutchy in a Discord direct message:" & vbLf & zipPath
    Else
340         FinishMessage = counts & vbLf & "The zip could not be made (the reason is in FixtureDrawings.log and " & folder & "-zip-error.txt)." & vbLf & _
            "Next: right-click this folder, choose Send to > Compressed (zipped) folder, and post that zip in your builder thread or send it to Dutchy in a Discord direct message:" & vbLf & folder
    End If
End Function

Private Sub AppendLog(ByVal folder As String, ByVal identity As String, ByVal failedStep As String, ByVal lineNumber As Long, ByVal errorNumber As Long, ByVal description As String)
    Dim channel As Integer
347     channel = FreeFile
348     Open folder & "\FixtureDrawings.log" For Append As #channel
349     Print #channel, Format$(Now, "yyyy-mm-dd hh:nn:ss") & " builder=" & BUILDER_VERSION & " recipe=" & identity & _
        " step=" & failedStep & " Erl=" & CStr(lineNumber) & " Err.Number=" & CStr(errorNumber) & _
        " Err.Description=" & Replace(Replace(CleanError(description), vbCr, "\r"), vbLf, "\n")
352     Close #channel
End Sub

Private Sub RunPackage(ByVal index As Long, ByVal folder As String, ByVal version As String, ByVal build As String, ByVal major As Long)
    ' One companion drawing entry: skipped (not made by the builder, or its part file is not in the folder), not scripted, drawn, or failed with
    ' the step and the call inputs. A failure never stops the next entry.
    Dim identity As String, status As String, message As String, files As String, started As Double, elapsed As Double
    Dim fs As Object, title As Variant
    Dim failureLine As Long, failureNumber As Long, failureDescription As String, failureStep As String
361     On Error GoTo Failed
362     Set doc = Nothing
363     Set loadedDocs = Nothing
364     attemptErrorsSaved = False
365     started = Timer
366     identity = PackageId(index)
367     currentIdentity = identity
368     currentFolder = folder
369     Set mitigations = CreateObject("Scripting.Dictionary")
370     Set primaryFailures = CreateObject("Scripting.Dictionary")
371     Set fallbackSuccesses = CreateObject("Scripting.Dictionary")
372     apiInputs = "": callInputs = ""
373     stepLabel = identity & ": preflight"
374     status = "failed"
375     files = "[]"
376     Set fs = CreateObject("Scripting.FileSystemObject")
377     Select Case PackageState(index)
        Case 1
379             status = "not_scripted"
380             message = PackageReason(index)
        Case Else
382             If major < 26 Then
383                 status = "not_scripted"
384                 message = "needs SolidWorks 2018+"
            ElseIf Not fs.FileExists(packageFolder & "\" & PackageModel(index) & ".sldprt") Then
386                 status = "skipped"
387                 message = "the part file is not in this folder"
            Else
389                 AttemptPackage index, folder
390                 status = "ok"
391                 files = "[" & Quote(identity & ".slddrw") & "," & Quote(identity & ".pdf") & "," & Quote(identity & ".dxf") & "]"
            End If
    End Select
394     GoTo Finished
Failed:
    failureLine = Erl: failureNumber = Err.Number: failureDescription = Err.Description: failureStep = stepLabel
397     AppendLog folder, currentIdentity, failureStep, failureLine, failureNumber, failureDescription
398     message = failureStep & " (line " & CStr(failureLine) & "): " & failureDescription
399     status = "failed"
400     files = "[]"
401     Resume Finished
Finished:
403     On Error GoTo CleanupFailed
404     If status <> "ok" Then PackageRemoveFiles folder, identity
405     If Not doc Is Nothing Then
    stepLabel = currentIdentity & ": RunPackage ShowFeatureErrorDialog"
407         If attemptErrorsSaved Then doc.ShowFeatureErrorDialog = attemptOldErrors
    stepLabel = currentIdentity & ": RunPackage CloseDoc"
409         app.CloseDoc doc.GetTitle()
    End If
411     Set doc = Nothing
412     If Not loadedDocs Is Nothing Then
413         For Each title In loadedDocs
    stepLabel = currentIdentity & ": RunPackage CloseDoc"
415             app.CloseDoc CStr(title)
        Next title
    End If
418     Set loadedDocs = Nothing
419     On Error GoTo ReportFailed
420     elapsed = Timer - started
421     If elapsed < 0 Then elapsed = elapsed + 86400#
422     PackageRow identity, status, message, files, version, build, elapsed
423     AppendLog folder, currentIdentity, "recipe complete: " & status, 0, 0, MitigationText()
424     Exit Sub
CleanupFailed:
    failureLine = Erl: failureNumber = Err.Number: failureDescription = Err.Description: failureStep = stepLabel
427     AppendLog folder, currentIdentity, failureStep, failureLine, failureNumber, failureDescription
428     message = failureStep & " (line " & CStr(failureLine) & "): " & failureDescription
429     status = "failed"
430     files = "[]"
431     Resume Next
ReportFailed:
    ' Propagate reporting failures to main's final visible error, never swallow them.
434     Err.Raise Err.Number, "RunPackage reporting", Err.Description
End Sub

Private Sub PackageRow(ByVal identity As String, ByVal status As String, ByVal message As String, ByVal files As String, ByVal version As String, ByVal build As String, ByVal elapsed As Double)
    Dim resultRow As String, priorRows As String
439     priorRows = resultRows
440     If Len(priorRows) > 0 Then priorRows = priorRows & ","
441     resultRow = "{""id"":" & Quote(identity) & ",""status"":" & Quote(status) & _
        ",""error"":" & Quote(CleanError(message)) & ",""files"":" & files & _
        ",""app"":""SolidWorks"",""version"":" & Quote(version) & _
        ",""build"":" & Quote(build) & ",""mitigations"":" & MitigationJson() & ",""seconds"":" & Replace(Format$(elapsed, "0.0000"), ",", ".") & "}"
445     resultRows = priorRows & resultRow
446     WriteUtf8 currentFolder & "\results.json", "[" & resultRows & "]"
End Sub

Private Sub PackageRemoveFiles(ByVal folder As String, ByVal identity As String)
    ' A drawing that did not finish leaves no half-made file behind.
    Dim fs As Object, extension As Variant, path As String
452     Set fs = CreateObject("Scripting.FileSystemObject")
453     For Each extension In Array(".slddrw", ".pdf", ".dxf")
    stepLabel = currentIdentity & ": PackageRemoveFiles BuildPath"
455         path = fs.BuildPath(folder, identity & CStr(extension))
    stepLabel = currentIdentity & ": PackageRemoveFiles FileExists"
457         If fs.FileExists(path) Then fs.DeleteFile path
    Next extension
End Sub

Private Sub AttemptPackage(ByVal index As Long, ByVal folder As String)
    ' One drawing in its own new document: the part opened read-only and silent first (so the new drawing is the active document afterwards, and the
    ' part is closed unsaved), the plan, the read-backs, the privacy blanking, the title block text, then the three files.
    Dim identity As String, fs As Object, template As String, model As Object, modelErrors As Long, modelWarnings As Long
    Dim native As String, pdfFile As String, dxfFile As String
466     identity = currentIdentity
467     Set loadedDocs = New Collection
468     Set fs = CreateObject("Scripting.FileSystemObject")
469     template = ResolveTemplate("drawing")
470     stepLabel = identity & ": model open"
    stepLabel = currentIdentity & ": AttemptPackage OpenDoc6"
472     Set model = app.OpenDoc6(packageFolder & "\" & PackageModel(index) & ".sldprt", swDocPART, swOpenDocOptions_Silent + swOpenDocOptions_ReadOnly, "", modelErrors, modelWarnings)
473     If modelErrors <> 0 Then Err.Raise 5, , "SolidWorks OpenDoc6 error " & CStr(modelErrors) & " opening the drawing model"
474     Require model, "The drawing model could not be opened"
    stepLabel = currentIdentity & ": AttemptPackage Add"
476     loadedDocs.Add model.GetTitle()
    stepLabel = currentIdentity & ": AttemptPackage NewDocument"
478     Set doc = app.NewDocument(template, 0, 0#, 0#)
479     If doc Is Nothing Then Err.Raise 5, , "Template could not be opened. Paths tried: " & template
    stepLabel = currentIdentity & ": AttemptPackage GetFileName"
481     AppendLog folder, currentIdentity, "option", 0, 0, "drawing template: " & fs.GetFileName(template)
    stepLabel = currentIdentity & ": AttemptPackage ShowFeatureErrorDialog"
483     attemptOldErrors = doc.ShowFeatureErrorDialog
484     attemptErrorsSaved = True
    stepLabel = currentIdentity & ": AttemptPackage ShowFeatureErrorDialog"
486     doc.ShowFeatureErrorDialog = False
487     BuildPackage index
488     PackageFinish
489     BlankProperties
490     BuildPackageTitle index
491     native = identity & ".slddrw"
492     pdfFile = identity & ".pdf"
493     dxfFile = identity & ".dxf"
    stepLabel = currentIdentity & ": AttemptPackage BuildPath"
495     SaveFile fs.BuildPath(folder, native)
496     stepLabel = identity & ": pdf export"
    stepLabel = currentIdentity & ": AttemptPackage BuildPath"
498     SaveFile fs.BuildPath(folder, pdfFile)
    stepLabel = currentIdentity & ": AttemptPackage BuildPath"
500     PackageFileCheck fs.BuildPath(folder, pdfFile), "PDF"
501     stepLabel = identity & ": dxf export"
    stepLabel = currentIdentity & ": AttemptPackage BuildPath"
503     ExportDrawing fs.BuildPath(folder, dxfFile)
End Sub

Private Sub PackageFileCheck(ByVal path As String, ByVal kind As String)
    Dim fs As Object
508     stepLabel = currentIdentity & ": " & kind & " file check"
509     Set fs = CreateObject("Scripting.FileSystemObject")
    stepLabel = currentIdentity & ": PackageFileCheck FileExists"
511     If Not fs.FileExists(path) Then Err.Raise 5, , "The " & kind & " export wrote no file"
    stepLabel = currentIdentity & ": PackageFileCheck GetFile"
513     If fs.GetFile(path).Size = 0 Then Err.Raise 5, , "The " & kind & " export wrote an empty file"
    stepLabel = currentIdentity & ": PackageFileCheck GetFileName"
515     AppendLog currentFolder, currentIdentity, "option", 0, 0, "drawing " & kind & ": " & fs.GetFileName(path) & ", " & CStr(fs.GetFile(path).Size) & " bytes"
End Sub

Private Sub PackageStart(ByVal partId As String, ByVal lowMm As Variant, ByVal highMm As Variant)
519     packagePart = packageFolder & "\" & partId & ".sldprt"
520     packageLow = Array(CDbl(lowMm(0)) * 0.001, CDbl(lowMm(1)) * 0.001, CDbl(lowMm(2)) * 0.001)
521     packageHigh = Array(CDbl(highMm(0)) * 0.001, CDbl(highMm(1)) * 0.001, CDbl(highMm(2)) * 0.001)
522     Set packageViews = CreateObject("Scripting.Dictionary")
523     Set packageRecords = CreateObject("Scripting.Dictionary")
524     Set packageDrops = CreateObject("Scripting.Dictionary")
525     Set packageSpaces = CreateObject("Scripting.Dictionary")
526     Set packageTitle = CreateObject("Scripting.Dictionary")
527     packageOrder = ""
528     packageDimCount = 0
529     packageRatioN = 1#
530     packageRatioD = 1#
531     packageSheetW = 0.297
532     packageSheetH = 0.21
533     packageScalePending = False
End Sub

Private Function PackageSheetProperties(ByVal sheetObject As Object) As Variant
    ' ISheet.GetProperties2 as exactly eight values (paper size, template, scale numerator and denominator, first angle, width, height,
    ' same custom property), or Empty when SolidWorks does not give them.
    Dim values As Variant, first As Long, same As Variant
540     On Error Resume Next
    stepLabel = currentIdentity & ": PackageSheetProperties GetProperties2"
542     values = sheetObject.GetProperties2()
543     If Err.Number <> 0 Then
544         Err.Clear
545         Exit Function
    End If
547     On Error GoTo 0
548     If Not IsArray(values) Then Exit Function
549     first = LBound(values)
550     If UBound(values) - first < 6 Then Exit Function
551     same = False
552     If UBound(values) - first >= 7 Then same = values(first + 7)
553     PackageSheetProperties = Array(values(first), values(first + 1), values(first + 2), values(first + 3), values(first + 4), values(first + 5), values(first + 6), same)
End Function

Private Sub PackageSetting(ByVal what As String, ByVal preference As Long, ByVal wanted As Long)
    ' A document preference the drawing must have (the standard, the units): read from the template's drawing, set when it differs, read again.
    Dim found As Long, again As Long, mitigation As String
559     callInputs = "preference=" & CStr(preference) & " wanted=" & CStr(wanted)
    stepLabel = currentIdentity & ": PackageSetting GetUserPreferenceInteger"
561     found = doc.Extension.GetUserPreferenceInteger(preference, swDetailingNoOptionSpecified)
562     If found = wanted Then Exit Sub
563     mitigation = "drawing-" & what & "-set"
564     RecordMitigation mitigation, True, True
    stepLabel = currentIdentity & ": PackageSetting SetUserPreferenceInteger"
566     If Not doc.Extension.SetUserPreferenceInteger(preference, swDetailingNoOptionSpecified, wanted) Then Err.Raise 5, , "The drawing " & what & " could not be set: " & callInputs
    stepLabel = currentIdentity & ": PackageSetting GetUserPreferenceInteger"
568     again = doc.Extension.GetUserPreferenceInteger(preference, swDetailingNoOptionSpecified)
569     If again <> wanted Then Err.Raise 5, , "The drawing " & what & " stays " & CStr(again) & ", not " & CStr(wanted) & ", after setting it: " & callInputs
570     fallbackSuccesses(mitigation) = fallbackSuccesses(mitigation) + 1
571     AppendLog currentFolder, currentIdentity, "option", 0, 0, "drawing " & what & ": the template had " & CStr(found) & ", set to " & CStr(wanted)
End Sub

Private Sub PackageSheet(ByVal standard As Long, ByVal units As Long, ByVal paper As Long, ByVal paperWidth As Double, ByVal paperHeight As Double, ByVal numerator As Double, ByVal denominator As Double)
    Dim sheetObject As Object, properties As Variant, text As String
576     Set drawingInterface = DrawingDocument(doc)
    stepLabel = currentIdentity & ": PackageSheet GetCurrentSheet"
578     Set sheetObject = drawingInterface.GetCurrentSheet()
579     Require sheetObject, "The new drawing has no current sheet"
580     Set packageSheetObject = sheetObject
581     If standard >= 0 Then PackageSetting "standard", swDetailingDimensionStandard, standard
582     If units >= 0 Then PackageSetting "units", swUnitsLinear, units
583     properties = PackageSheetProperties(sheetObject)
584     If paper >= 0 Then
585         callInputs = "PaperSz=" & CStr(paper) & " Width=" & NumberList(Array(paperWidth)) & " Height=" & NumberList(Array(paperHeight))
586         If IsEmpty(properties) Then Err.Raise 5, , "ISheet.GetProperties2 returned no sheet properties: " & callInputs
587         If CLng(properties(0)) <> paper Then
588             RecordMitigation "drawing-sheet-size-set", True, True
            ' ISheet.SetProperties2 returns nothing (interop 32.1.0, void): it is read back, not checked for a result.
    stepLabel = currentIdentity & ": PackageSheet SetProperties2"
591             sheetObject.SetProperties2 paper, CLng(properties(1)), CDbl(properties(2)), CDbl(properties(3)), CBool(properties(4)), paperWidth, paperHeight, CBool(properties(7))
592             properties = PackageSheetProperties(sheetObject)
593             If IsEmpty(properties) Then Err.Raise 5, , "ISheet.GetProperties2 returned no sheet properties after setting the size: " & callInputs
594             If CLng(properties(0)) <> paper Then Err.Raise 5, , "The sheet size stays " & CStr(CLng(properties(0))) & ", not " & CStr(paper) & ", after setting it: " & callInputs
595             fallbackSuccesses("drawing-sheet-size-set") = fallbackSuccesses("drawing-sheet-size-set") + 1
        End If
    End If
598     If Not IsEmpty(properties) Then
599         packageSheetW = CDbl(properties(5))
600         packageSheetH = CDbl(properties(6))
    End If
602     callInputs = "Numerator=" & NumberList(Array(numerator)) & " Denominator=" & NumberList(Array(denominator))
    stepLabel = currentIdentity & ": PackageSheet SetScale"
604     If Not sheetObject.SetScale(numerator, denominator, False, False) Then Err.Raise 5, , "ISheet.SetScale failed: " & callInputs
605     packageRatioN = numerator
606     packageRatioD = denominator
607     properties = PackageSheetProperties(sheetObject)
608     If IsEmpty(properties) Then
        ' The scale cannot be read from the sheet: every view's own scale is checked instead (and counted once the first one is right).
610         RecordMitigation "drawing-sheet-scale-from-views", True, True
611         packageScalePending = True
612         text = "unknown"
    Else
614         If Abs(CDbl(properties(2)) * denominator - CDbl(properties(3)) * numerator) > 0.000000001 Then Err.Raise 5, , "The sheet scale reads back " & NumberList(Array(properties(2), properties(3))) & ", not " & NumberList(Array(numerator, denominator)) & ": " & callInputs
615         text = CStr(CBool(properties(4)))
    End If
617     AppendLog currentFolder, currentIdentity, "option", 0, 0, "drawing: sheet " & NumberList(Array(packageSheetW, packageSheetH)) & " m, scale " & NumberList(Array(numerator, denominator)) & ", first angle " & text
End Sub

Private Sub PackageCheckScale(ByVal view As Object, ByVal what As String, ByVal ownN As Double, ByVal ownD As Double)
    ' The view is at the sheet's scale, or at (ownN : ownD), a scale the recipe gives that view alone (ownD = 0 means none): set on the view and read back.
    Dim wanted As Double
623     wanted = packageRatioN / packageRatioD
624     If ownD > 0 Then wanted = ownN / ownD
    stepLabel = currentIdentity & ": PackageCheckScale ScaleDecimal"
626     If Abs(view.ScaleDecimal - wanted) > 0.000000001 Then
        ' The sheet scale was set first; a view that still is not at it is given the scale itself.
628         If ownD = 0 Then RecordMitigation "drawing-view-scale-explicit", True, True
    stepLabel = currentIdentity & ": PackageCheckScale UseSheetScale"
630         view.UseSheetScale = 0
    stepLabel = currentIdentity & ": PackageCheckScale ScaleDecimal"
632         view.ScaleDecimal = wanted
    stepLabel = currentIdentity & ": PackageCheckScale ScaleDecimal"
634         If Abs(view.ScaleDecimal - wanted) > 0.000000001 Then Err.Raise 5, , "The " & what & " view scale is " & NumberList(Array(view.ScaleDecimal)) & ", not " & NumberList(Array(wanted)) & ", after setting it: " & callInputs
635         If ownD = 0 Then
636             fallbackSuccesses("drawing-view-scale-explicit") = fallbackSuccesses("drawing-view-scale-explicit") + 1
        Else
638             AppendLog currentFolder, currentIdentity, "option", 0, 0, "drawing: the " & what & " view has its own scale " & NumberList(Array(ownN, ownD)) & ", set on the view and read back"
        End If
    End If
641     If packageScalePending Then
642         packageScalePending = False
643         fallbackSuccesses("drawing-sheet-scale-from-views") = fallbackSuccesses("drawing-sheet-scale-from-views") + 1
    End If
End Sub

Private Function PackageModelView(ByVal orientation As String, ByVal what As String, ByVal x As Double, ByVal y As Double, ByVal ownN As Double, ByVal ownD As Double) As Object
    Dim created As Object
    stepLabel = currentIdentity & ": PackageModelView ClearSelection2"
650     doc.ClearSelection2 True
651     callInputs = "model=" & Mid$(packagePart, InStrRev(packagePart, "\") + 1) & " view=" & orientation & " at(m)=" & NumberList(Array(x, y)) & ",0"
    stepLabel = currentIdentity & ": PackageModelView CreateDrawViewFromModelView3" & " " & apiInputs & " " & callInputs
653     Set created = drawingInterface.CreateDrawViewFromModelView3(packagePart, orientation, x, y, 0#)
654     Require created, "The " & what & " view was not created: " & callInputs
    stepLabel = currentIdentity & ": PackageModelView ClearSelection2"
656     doc.ClearSelection2 True
657     PackageCheckScale created, what, ownN, ownD
658     Set PackageModelView = created
End Function

Private Function PackageProjectedView(ByVal what As String, ByVal x As Double, ByVal y As Double) As Object
    Dim created As Object, source As Object
663     Set source = packageViews("base")
    stepLabel = currentIdentity & ": PackageProjectedView ClearSelection2"
665     doc.ClearSelection2 True
    stepLabel = currentIdentity & ": PackageProjectedView GetName2"
667     callInputs = "projected from " & source.GetName2() & " at(m)=" & NumberList(Array(x, y)) & ",0"
    stepLabel = currentIdentity & ": PackageProjectedView SelectByID2" & " " & apiInputs & " " & callInputs
669     If Not doc.Extension.SelectByID2(source.GetName2(), "DRAWINGVIEW", 0#, 0#, 0#, False, 0, Nothing, 0) Then Err.Raise 5, , "The base view could not be selected to project from: " & callInputs
    stepLabel = currentIdentity & ": PackageProjectedView CreateUnfoldedViewAt3" & " " & apiInputs & " " & callInputs
671     Set created = drawingInterface.CreateUnfoldedViewAt3(x, y, 0#, False)
672     Require created, "The " & what & " view was not created: " & callInputs
    stepLabel = currentIdentity & ": PackageProjectedView ClearSelection2"
674     doc.ClearSelection2 True
675     PackageCheckScale created, what, 0#, 0#
676     Set PackageProjectedView = created
End Function

Private Function PackageViewAxis(ByVal view As Object) As Long
    ' The model axis a view looks along, or -1 when it looks along none (a tilted view).
681     On Error Resume Next
682     PackageViewAxis = ViewDrop(view)
683     If Err.Number <> 0 Then
684         PackageViewAxis = -1
685         Err.Clear
    End If
End Function

Private Function PackageAxisText(ByVal axisIndex As Long) As String
690     If axisIndex >= 0 And axisIndex < 3 Then PackageAxisText = Mid$("XYZ", axisIndex + 1, 1) Else PackageAxisText = "no model axis"
End Function

Private Sub PackageDeleteView(ByVal view As Object)
    stepLabel = currentIdentity & ": PackageDeleteView GetName2"
695     callInputs = "delete " & view.GetName2()
    stepLabel = currentIdentity & ": PackageDeleteView ClearSelection2"
697     doc.ClearSelection2 True
    stepLabel = currentIdentity & ": PackageDeleteView SelectByID2" & " " & apiInputs & " " & callInputs
699     If Not doc.Extension.SelectByID2(view.GetName2(), "DRAWINGVIEW", 0#, 0#, 0#, False, 0, Nothing, 0) Then Err.Raise 5, , "The view could not be selected to delete it: " & callInputs
    stepLabel = currentIdentity & ": PackageDeleteView DeleteSelection2"
701     If Not doc.Extension.DeleteSelection2(swDelete_Absorbed) Then Err.Raise 5, , "The view could not be deleted: " & callInputs
    stepLabel = currentIdentity & ": PackageDeleteView ClearSelection2"
703     doc.ClearSelection2 True
End Sub

Private Function PackageViewSign(ByVal view As Object, ByVal axisIndex As Long) As Long
    ' Which side of the model the viewer is on along the axis (+1 or -1): the view's own z axis (toward the viewer) is column 2 of the rotation.
    Dim matrix As Variant
    stepLabel = currentIdentity & ": PackageViewSign ArrayData"
710     matrix = view.ModelToViewTransform.ArrayData
711     If CDbl(matrix(LBound(matrix) + 3 * axisIndex + 2)) > 0 Then PackageViewSign = 1 Else PackageViewSign = -1
End Function

Private Function PackageViewOk(ByVal view As Object, ByVal axisIndex As Long, ByVal signValue As Long) As Boolean
715     If PackageViewAxis(view) <> axisIndex Then Exit Function
716     If signValue <> 0 Then
717         If PackageViewSign(view, axisIndex) <> signValue Then Exit Function
    End If
719     PackageViewOk = True
End Function

Private Sub PackageBase(ByVal orientation As String, ByVal axisIndex As Long, ByVal acrossIndex As Long, ByVal upIndex As Long, ByVal fractionX As Double, ByVal fractionY As Double)
    Dim created As Object, found As Long, matrix As Variant, rightPart As Double, upPart As Double
724     Set created = PackageModelView(orientation, "base", fractionX * packageSheetW, fractionY * packageSheetH, 0#, 0#)
725     found = PackageViewAxis(created)
726     If found <> axisIndex Then Err.Raise 5, , "The base view " & orientation & " looks along " & PackageAxisText(found) & ", not " & PackageAxisText(axisIndex) & ": " & callInputs
    ' The sign, not only the axis: model +across must point to the right on the sheet and model +up must point up (the recipe's Z-up world).
    stepLabel = currentIdentity & ": PackageBase ArrayData"
729     matrix = created.ModelToViewTransform.ArrayData
730     rightPart = CDbl(matrix(LBound(matrix) + 3 * acrossIndex))
731     upPart = CDbl(matrix(LBound(matrix) + 3 * upIndex + 1))
732     If rightPart <= 0.5 Or upPart <= 0.5 Then Err.Raise 5, , "The base view " & orientation & " does not show the recipe's orientation: model +" & PackageAxisText(acrossIndex) & " has the x component " & NumberList(Array(rightPart)) & " and model +" & PackageAxisText(upIndex) & " the y component " & NumberList(Array(upPart)) & " on the sheet; they must be right and up: " & callInputs
733     Set packageViews("base") = created
734     packageOrder = "base"
    stepLabel = currentIdentity & ": PackageBase GetName2"
736     AppendLog currentFolder, currentIdentity, "option", 0, 0, "drawing: base view " & created.GetName2() & " " & orientation & " looks along " & PackageAxisText(found)
End Sub

Private Sub PackageProjected(ByVal direction As String, ByVal axisIndex As Long, ByVal signValue As Long, ByVal fractionX As Double, ByVal fractionY As Double, ByVal oppositeX As Double, ByVal oppositeY As Double)
    Dim created As Object, found As Long
741     Set created = PackageProjectedView(direction, fractionX * packageSheetW, fractionY * packageSheetH)
742     found = PackageViewAxis(created)
743     If Not PackageViewOk(created, axisIndex, signValue) Then
        ' A first-angle template puts the projected view on the other side: delete it and place it on the opposite side of the base view.
745         RecordMitigation "drawing-projection-opposite-side", True, True
    stepLabel = currentIdentity & ": PackageProjected GetName2"
747         AppendLog currentFolder, currentIdentity, "option", 0, 0, "drawing: the " & direction & " view " & created.GetName2() & " looks along " & PackageAxisText(found) & " with the viewer on another side than wanted (" & CStr(signValue) & " along " & PackageAxisText(axisIndex) & "); deleting it and projecting on the opposite side"
748         PackageDeleteView created
749         Set created = PackageProjectedView(direction, oppositeX * packageSheetW, oppositeY * packageSheetH)
750         found = PackageViewAxis(created)
751         If Not PackageViewOk(created, axisIndex, signValue) Then Err.Raise 5, , "The " & direction & " view looks along " & PackageAxisText(found) & ", not " & PackageAxisText(axisIndex) & " (viewer side " & CStr(signValue) & "), on either side of the base view: " & callInputs
752         fallbackSuccesses("drawing-projection-opposite-side") = fallbackSuccesses("drawing-projection-opposite-side") + 1
    End If
754     Set packageViews(direction) = created
755     packageOrder = packageOrder & "," & direction
    stepLabel = currentIdentity & ": PackageProjected GetName2"
757     AppendLog currentFolder, currentIdentity, "option", 0, 0, "drawing: " & direction & " view " & created.GetName2() & " looks along " & PackageAxisText(found)
End Sub

Private Sub PackageIso(ByVal numerator As Double, ByVal denominator As Double, ByVal fractionX As Double, ByVal fractionY As Double)
    Dim created As Object, ownN As Double, ownD As Double
762     If numerator * packageRatioD <> denominator * packageRatioN Then
763         ownN = numerator
764         ownD = denominator
    End If
766     Set created = PackageModelView("*Isometric", "iso", fractionX * packageSheetW, fractionY * packageSheetH, ownN, ownD)
    stepLabel = currentIdentity & ": PackageIso ArrayData"
768     If Not MatrixUsable(created.ModelToViewTransform.ArrayData) Then Err.Raise 5, , "The isometric view transform is not a rotation: " & callInputs
769     If PackageViewAxis(created) >= 0 Then Err.Raise 5, , "The isometric view is an axis-aligned view (it looks along " & PackageAxisText(PackageViewAxis(created)) & "): " & callInputs
770     Set packageViews("iso") = created
    stepLabel = currentIdentity & ": PackageIso GetName2"
772     AppendLog currentFolder, currentIdentity, "option", 0, 0, "drawing: isometric view " & created.GetName2() & " is not axis-aligned"
End Sub

Private Function PackageTryPlan(ByVal records As Collection, ByVal first As Variant, ByVal second As Variant) As Collection
    ' The dimension plan of a view, or Nothing when the two points coincide in that view (a view that looks along the line between them cannot show it).
    Dim failure As String, failureNumber As Long
778     On Error Resume Next
779     Set PackageTryPlan = DimensionPlan(records, first, second)
780     failureNumber = Err.Number
781     failure = Err.Description
782     Err.Clear
783     On Error GoTo 0
784     If failureNumber <> 0 Then
785         If InStr(1, failure, "coincide", vbTextCompare) = 0 Then Err.Raise failureNumber, , failure
786         Set PackageTryPlan = Nothing
    End If
End Function

Private Function PackageRung(ByVal plan As Collection) As String
    ' The mitigation name of a dimension made by a plan form D05a's plan does not make: the plan's records carry it (see dimension_rung in the Python twin).
    Dim k As Long
    stepLabel = currentIdentity & ": PackageRung Count"
794     For k = 1 To plan.Count
    stepLabel = currentIdentity & ": PackageRung Exists"
796         If plan(k).Exists("rung") Then
797             PackageRung = plan(k)("rung")
798             Exit Function
        End If
    Next k
End Function

Private Function PackageLastDimensionType(ByVal view As Object) As String
    ' swDimensionType_e of the view's last display dimension (IDisplayDimension.GetType), for the log; never a failure on its own.
    Dim display As Object, last As Object, failure As Long
806     On Error Resume Next
    stepLabel = currentIdentity & ": PackageLastDimensionType GetFirstDisplayDimension5"
808     Set display = view.GetFirstDisplayDimension5()
809     Do While Not display Is Nothing
810         Set last = display
    stepLabel = currentIdentity & ": PackageLastDimensionType GetNext3"
812         Set display = display.GetNext3()
    Loop
    stepLabel = currentIdentity & ": PackageLastDimensionType GetType"
815     If Not last Is Nothing Then PackageLastDimensionType = CStr(last.GetType())
816     failure = Err.Number
817     Err.Clear
818     On Error GoTo 0
819     If failure <> 0 Or last Is Nothing Then PackageLastDimensionType = "unreadable"
End Function

Private Sub PackageDimension(ByVal valueMm As Double, ByVal firstMm As Variant, ByVal secondMm As Variant)
    Dim first As Variant, second As Variant, labels As Variant, k As Long, key As String, plan As Collection, chosen As String
    Dim activeView As Object, outline As Variant, measured As Double, text As String, drop As Long, spaceName As String, index As Long, rung As String, failure As String, failureNumber As Long, found As Long, stopAt As Long
825     index = packageDimCount
826     packageDimCount = packageDimCount + 1
827     If index = 0 Then
828         ReDim packageValues(0)
    Else
830         ReDim Preserve packageValues(index)
    End If
832     packageValues(index) = valueMm
833     first = Array(CDbl(firstMm(0)) * 0.001, CDbl(firstMm(1)) * 0.001, CDbl(firstMm(2)) * 0.001)
834     second = Array(CDbl(secondMm(0)) * 0.001, CDbl(secondMm(1)) * 0.001, CDbl(secondMm(2)) * 0.001)
835     labels = Split(packageOrder, ",")
836     For k = 0 To UBound(labels)
837         key = CStr(labels(k))
    stepLabel = currentIdentity & ": PackageDimension Exists"
839         If Not packageRecords.Exists(key) Then
840             Set activeView = packageViews(key)
841             Set packageRecords(key) = DrawingEdges(activeView, packageLow, packageHigh, drop, spaceName)
842             packageDrops(key) = drop
843             packageSpaces(key) = spaceName
        End If
845         Set plan = PackageTryPlan(packageRecords(key), FlatPoint(first, packageDrops(key)), FlatPoint(second, packageDrops(key)))
846         If Not plan Is Nothing Then
847             chosen = key
848             Exit For
        End If
    Next k
851     If Len(chosen) = 0 Then Err.Raise 5, , "No view shows the edges for the " & NumberList(Array(valueMm)) & " dimension between " & NumberList(firstMm) & " and " & NumberList(secondMm) & " (mm)"
852     Set activeView = packageViews(chosen)
    stepLabel = currentIdentity & ": PackageDimension GetOutline"
854     outline = activeView.GetOutline()
855     rung = PackageRung(plan)
856     If Len(rung) > 0 Then RecordMitigation rung, True, True
857     On Error Resume Next
858     measured = AddDrawingDimension(activeView, plan, IIf(outline(0) > outline(2), outline(0), outline(2)) + PACKAGE_TEXT_STEP * (index + 1), IIf(outline(1) > outline(3), outline(1), outline(3)) + PACKAGE_TEXT_STEP * (index + 1), valueMm, "dimension " & CStr(index + 1))
859     failureNumber = Err.Number
860     failure = Err.Description
861     Err.Clear
862     On Error GoTo 0
863     If failureNumber <> 0 Then
864         found = InStr(1, failure, "measured ", vbTextCompare)
865         stopAt = 0
866         If found > 0 Then stopAt = InStr(found, failure, " mm, not", vbTextCompare)
        ' " mm, not" absent (or before the number): a negative length would raise Err 5 here, so the failure goes out as it is.
868         If rung = "drawing-dimension-edge-on-circles" And found > 0 And stopAt > found + 9 Then
869             Err.Raise failureNumber, , "edge-on circles: SolidWorks measured " & Mid$(failure, found + 9, stopAt - found - 9) & " mm, not center to center (" & NumberList(Array(valueMm)) & " mm): " & failure
        End If
871         Err.Raise failureNumber, , failure
    End If
873     If Len(rung) > 0 Then fallbackSuccesses(rung) = fallbackSuccesses(rung) + 1
874     If rung = "drawing-dimension-edge-on-circles" Then
        ' What SolidWorks reported, raw, so a first real run shows what happened: each circle's CircleParams (center, axis, radius), how many edges were
        ' selected and the type of the dimension SolidWorks made.
    stepLabel = currentIdentity & ": PackageDimension Count"
878         For k = 1 To plan.Count
879             If plan(k)("kind") = "circle" Then text = text & "; circle " & CStr(k) & " CircleParams " & NumberList(plan(k)("raw"))
        Next k
    stepLabel = currentIdentity & ": PackageDimension Count"
882         AppendLog currentFolder, currentIdentity, "option", 0, 0, "edge-on circles: " & Mid$(text, 3) & "; " & CStr(plan.Count) & " edges selected; dimension type (swDimensionType_e) " & PackageLastDimensionType(activeView)
883         text = ""
    End If
    stepLabel = currentIdentity & ": PackageDimension Count"
886     For k = 0 To plan.Count - 1
887         If k > 0 Then text = text & " + "
888         text = text & plan(k + 1)("kind")
    Next k
    stepLabel = currentIdentity & ": PackageDimension GetName2"
891     AppendLog currentFolder, currentIdentity, "option", 0, 0, "drawing dimension " & NumberList(Array(valueMm)) & ": " & chosen & " view " & activeView.GetName2() & ", " & text & ", entity coordinates were " & packageSpaces(chosen) & " coordinates, measured " & Replace(Format$(measured, "0.000000"), ",", ".") & " mm"
End Sub

Private Function PackageBoxFits(ByVal matrix As Variant, ByVal outline As Variant) As Boolean
    ' Every corner of the model box, mapped through the matrix, lies inside the view's outline (within SECTION_TOLERANCE).
    Dim a As Long, b As Long, c As Long, p As Variant
    Dim leftEdge As Double, rightEdge As Double, bottomEdge As Double, topEdge As Double
898     leftEdge = IIf(outline(0) < outline(2), outline(0), outline(2))
899     rightEdge = IIf(outline(0) > outline(2), outline(0), outline(2))
900     bottomEdge = IIf(outline(1) < outline(3), outline(1), outline(3))
901     topEdge = IIf(outline(1) > outline(3), outline(1), outline(3))
902     For a = 0 To 1
903         For b = 0 To 1
904             For c = 0 To 1
905                 p = MatrixPoint(matrix, CDbl(IIf(a = 0, packageLow(0), packageHigh(0))), CDbl(IIf(b = 0, packageLow(1), packageHigh(1))), CDbl(IIf(c = 0, packageLow(2), packageHigh(2))))
906                 If p(0) < leftEdge - SECTION_TOLERANCE Or p(0) > rightEdge + SECTION_TOLERANCE Or p(1) < bottomEdge - SECTION_TOLERANCE Or p(1) > topEdge + SECTION_TOLERANCE Then Exit Function
            Next c
        Next b
    Next a
910     PackageBoxFits = True
End Function

Private Function PackageFitMatrix(ByVal matrix As Variant, ByVal outline As Variant, ByVal scaleFactor As Double) As Variant
    ' The view's rotation, the given scale, and the translation that puts the model box center at the center of the view's outline.
    Dim first As Long, rotation As Variant, rotated As Variant
916     first = LBound(matrix)
917     rotation = Array(matrix(first), matrix(first + 1), matrix(first + 2), matrix(first + 3), matrix(first + 4), matrix(first + 5), matrix(first + 6), matrix(first + 7), matrix(first + 8), 0#, 0#, 0#, scaleFactor)
918     rotated = MatrixPoint(rotation, (CDbl(packageLow(0)) + CDbl(packageHigh(0))) / 2, (CDbl(packageLow(1)) + CDbl(packageHigh(1))) / 2, (CDbl(packageLow(2)) + CDbl(packageHigh(2))) / 2)
919     PackageFitMatrix = Array(matrix(first), matrix(first + 1), matrix(first + 2), matrix(first + 3), matrix(first + 4), matrix(first + 5), matrix(first + 6), matrix(first + 7), matrix(first + 8), (outline(0) + outline(2)) / 2 - rotated(0), (outline(1) + outline(3)) / 2 - rotated(1), 0#, scaleFactor)
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
931     Set source = packageViews("base")
    stepLabel = currentIdentity & ": PackageSection ArrayData"
933     matrix = source.ModelToViewTransform.ArrayData
934     For i = 0 To 2
935         middle(i) = (CDbl(packageLow(i)) + CDbl(packageHigh(i))) / 2
    Next i
    stepLabel = currentIdentity & ": PackageSection GetOutline"
938     outline = source.GetOutline()
939     leftEdge = IIf(outline(0) < outline(2), outline(0), outline(2))
940     rightEdge = IIf(outline(0) > outline(2), outline(0), outline(2))
941     bottomEdge = IIf(outline(1) < outline(3), outline(1), outline(3))
942     topEdge = IIf(outline(1) > outline(3), outline(1), outline(3))
943     If PackageBoxFits(matrix, outline) Then
944         AppendLog currentFolder, currentIdentity, "option", 0, 0, "drawing: section line mapped through the base view transform (the model box lands inside the outline " & NumberList(outline) & ")"
    Else
        ' The transform does not map model meters to sheet meters (it may be view-local): the mapping is derived from the outline instead. Its rotation
        ' is the transform's, its scale the view's own, and its translation puts the model box center at the center of the outline.
948         RecordMitigation "drawing-section-outline-fit", True, True
    stepLabel = currentIdentity & ": PackageSection ScaleDecimal"
950         fitted = PackageFitMatrix(matrix, outline, CDbl(source.ScaleDecimal))
951         AppendLog currentFolder, currentIdentity, "option", 0, 0, "drawing: the base view transform puts the model box outside the outline " & NumberList(outline) & "; mapping from the outline instead: rotation of the transform, scale " & NumberList(Array(fitted(12))) & " (the view's), translation " & NumberList(Array(fitted(9), fitted(10))) & " m"
952         If Not PackageBoxFits(fitted, outline) Then Err.Raise 5, , "The model box does not land inside the view outline " & NumberList(outline) & " even when mapped from it: the section line cannot be placed"
953         matrix = fitted
954         fallbackSuccesses("drawing-section-outline-fit") = fallbackSuccesses("drawing-section-outline-fit") + 1
    End If
956     For side = 0 To 1
957         For i = 0 To 2
958             point(i) = middle(i)
        Next i
960         point(cutAxis) = coordinate * 0.001
961         point(lineAxis) = IIf(side = 0, packageLow(lineAxis), packageHigh(lineAxis))
962         endPoint(side) = MatrixPoint(matrix, point(0), point(1), point(2))
    Next side
964     If vertical Then
965         If Abs(endPoint(0)(0) - endPoint(1)(0)) > 0.000000001 Then Err.Raise 5, , "The " & letter & " section line is not vertical in the base view (its ends are at x = " & NumberList(Array(endPoint(0)(0), endPoint(1)(0))) & " m)"
966         firstX = endPoint(0)(0)
967         secondX = endPoint(0)(0)
968         firstY = bottomEdge - SECTION_MARGIN
969         secondY = topEdge + SECTION_MARGIN
    Else
971         If Abs(endPoint(0)(1) - endPoint(1)(1)) > 0.000000001 Then Err.Raise 5, , "The " & letter & " section line is not horizontal in the base view (its ends are at y = " & NumberList(Array(endPoint(0)(1), endPoint(1)(1))) & " m)"
972         firstX = leftEdge - SECTION_MARGIN
973         secondX = rightEdge + SECTION_MARGIN
974         firstY = endPoint(0)(1)
975         secondY = endPoint(0)(1)
    End If
977     placeX = fractionX * packageSheetW
978     placeY = fractionY * packageSheetH
    stepLabel = currentIdentity & ": PackageSection GetName2"
980     callInputs = "section " & letter & " line(m)=" & NumberList(Array(firstX, firstY, secondX, secondY)) & " in " & source.GetName2() & ", cut normal " & PackageAxisText(cutAxis) & ", view at(m)=" & NumberList(Array(placeX, placeY))
    stepLabel = currentIdentity & ": PackageSection ActivateView"
982     If Not drawingInterface.ActivateView(source.GetName2()) Then Err.Raise 5, , "ActivateView failed: " & callInputs
    stepLabel = currentIdentity & ": PackageSection ClearSelection2"
984     doc.ClearSelection2 True
    stepLabel = currentIdentity & ": PackageSection CreateLine" & " " & apiInputs & " " & callInputs
986     Set segment = doc.SketchManager.CreateLine(firstX, firstY, 0#, secondX, secondY, 0#)
987     Require segment, "The section line was not created: " & callInputs
    ' The end points as SolidWorks reports them, logged beside the ones asked for (never a failure on its own: it tells whether a view's sketch takes sheet coordinates).
989     readText = ""
990     On Error Resume Next
991     Set sketchLine = segment
    stepLabel = currentIdentity & ": PackageSection GetStartPoint2"
993     Set lineStart = sketchLine.GetStartPoint2()
    stepLabel = currentIdentity & ": PackageSection GetEndPoint2"
995     Set lineEnd = sketchLine.GetEndPoint2()
    stepLabel = currentIdentity & ": PackageSection X"
997     readText = NumberList(Array(lineStart.X, lineStart.Y, lineEnd.X, lineEnd.Y))
998     If Err.Number <> 0 Then
999         readText = ""
1000         Err.Clear
    End If
1002     On Error GoTo 0
1003     If Len(readText) = 0 Then
1004         AppendLog currentFolder, currentIdentity, "option", 0, 0, "drawing: section line end points could not be read back"
    Else
1006         AppendLog currentFolder, currentIdentity, "option", 0, 0, "drawing: section line asked at(m)=" & NumberList(Array(firstX, firstY, secondX, secondY)) & ", SolidWorks reports " & readText
    End If
    stepLabel = currentIdentity & ": PackageSection GetSelectedObjectCount2"
1009     If doc.SelectionManager.GetSelectedObjectCount2(-1) <> 1 Then
        ' The new line is normally still selected; when it is not, select it.
1011         RecordMitigation "drawing-section-line-reselect", True, True
    stepLabel = currentIdentity & ": PackageSection ClearSelection2"
1013         doc.ClearSelection2 True
    stepLabel = currentIdentity & ": PackageSection Select4" & " " & apiInputs & " " & callInputs
1015         If Not segment.Select4(False, doc.SelectionManager.CreateSelectData()) Then Err.Raise 5, , "The section line could not be selected: " & callInputs
    stepLabel = currentIdentity & ": PackageSection GetSelectedObjectCount2"
1017         If doc.SelectionManager.GetSelectedObjectCount2(-1) <> 1 Then Err.Raise 5, , CStr(doc.SelectionManager.GetSelectedObjectCount2(-1)) & " objects are selected, not the one section line: " & callInputs
1018         fallbackSuccesses("drawing-section-line-reselect") = fallbackSuccesses("drawing-section-line-reselect") + 1
    End If
    stepLabel = currentIdentity & ": PackageSection CreateSectionViewAt5" & " " & apiInputs & " " & callInputs
1021     Set created = drawingInterface.CreateSectionViewAt5(placeX, placeY, 0#, letter, 0, Nothing, 0#)
1022     Require created, "CreateSectionViewAt5 returned no view: " & callInputs
    stepLabel = currentIdentity & ": PackageSection ClearSelection2"
1024     doc.ClearSelection2 True
1025     PackageCheckScale created, "section", 0#, 0#
1026     found = PackageViewAxis(created)
    stepLabel = currentIdentity & ": PackageSection GetName2"
1028     If found <> cutAxis Then Err.Raise 5, , "The section view " & created.GetName2() & " looks along " & PackageAxisText(found) & ", not along the cut normal " & PackageAxisText(cutAxis) & ": " & callInputs
    stepLabel = currentIdentity & ": PackageSection GetSection"
1030     Set sectionData = created.GetSection()
1031     Require sectionData, "IView.GetSection returned no section data for the new view: " & callInputs
    stepLabel = currentIdentity & ": PackageSection GetLabel"
1033     labelText = CStr(sectionData.GetLabel())
1034     If UCase$(Trim$(labelText)) <> letter Then Err.Raise 5, , "The section view reads back the label " & labelText & ", not " & letter & ": " & callInputs
1035     Set packageViews("section") = created
    stepLabel = currentIdentity & ": PackageSection GetName2"
1037     AppendLog currentFolder, currentIdentity, "option", 0, 0, "drawing: section view " & created.GetName2() & ", label " & labelText & ", looks along " & PackageAxisText(found)
End Sub

Private Sub PackageFinish()
    ' Every display dimension in the drawing, read from the drawing, must be exactly the recipe's.
    Dim listing As String
1043     If packageDimCount = 0 Then listing = DrawingReadBack(Array()) Else listing = DrawingReadBack(packageValues)
1044     If Len(listing) = 0 Then listing = "no dimensions"
1045     AppendLog currentFolder, currentIdentity, "option", 0, 0, "drawing read-back: " & listing
End Sub

Private Sub PackageProperty(ByVal propertyName As String, ByVal propertyText As String)
    ' One title block field as a drawing custom property, set after the privacy blanking and read back.
    Dim manager As Object, valueText As String, resolvedText As String, wasResolved As Boolean
1051     callInputs = "property=" & propertyName
    stepLabel = currentIdentity & ": PackageProperty CustomPropertyManager"
1053     Set manager = doc.Extension.CustomPropertyManager("")
    stepLabel = currentIdentity & ": PackageProperty Add3"
1055     If manager.Add3(propertyName, swCustomInfoText, propertyText, swCustomPropertyReplaceValue) <> 0 Then Err.Raise 5, , "The title block property could not be set: " & callInputs
    stepLabel = currentIdentity & ": PackageProperty Get5"
1057     If manager.Get5(propertyName, False, valueText, resolvedText, wasResolved) = swCustomInfoGetResult_NotPresent Or (valueText <> propertyText And resolvedText <> propertyText) Then
1058         Err.Raise 5, , "The title block property reads back " & valueText & ", not " & propertyText & ": " & callInputs
    End If
1060     packageTitle(propertyName) = propertyText
End Sub

Private Sub PackageTitleCheck()
    ' A look at the title block's own notes: never claims the text is shown on the sheet when the notes do not show it.
    Dim titleBlock As Object, notes As Variant, noteItem As Variant, key As Variant, shown As Boolean, found As Boolean, names As String
1066     shown = False
1067     On Error Resume Next
    stepLabel = currentIdentity & ": PackageTitleCheck TitleBlock"
1069     Set titleBlock = packageSheetObject.TitleBlock
1070     If Err.Number <> 0 Then
1071         Err.Clear
1072         Set titleBlock = Nothing
    End If
1074     If Not titleBlock Is Nothing Then
    stepLabel = currentIdentity & ": PackageTitleCheck GetNotes"
1076         notes = titleBlock.GetNotes()
1077         If Err.Number <> 0 Then
1078             Err.Clear
1079             notes = Empty
        End If
    End If
1082     On Error GoTo 0
1083     If Not titleBlock Is Nothing Then
1084         shown = True
    stepLabel = currentIdentity & ": PackageTitleCheck Keys"
1086         For Each key In packageTitle.Keys
1087             found = False
1088             If IsArray(notes) Then
1089                 For Each noteItem In notes
    stepLabel = currentIdentity & ": PackageTitleCheck GetText"
1091                     If InStr(1, CStr(noteItem.GetText()), CStr(packageTitle(key)), vbBinaryCompare) > 0 Then found = True
                Next noteItem
            End If
1094             If Not found Then shown = False
        Next key
    End If
    stepLabel = currentIdentity & ": PackageTitleCheck Keys"
1098     For Each key In packageTitle.Keys
1099         If Len(names) > 0 Then names = names & ", "
1100         names = names & CStr(key)
    Next key
1102     If Not shown Then
        ' The properties are set and read back; the sheet's title block does not show their text (no title block, or one that does not link them).
1104         RecordMitigation "title-block-property-only", True, True
1105         fallbackSuccesses("title-block-property-only") = fallbackSuccesses("title-block-property-only") + 1
1106         AppendLog currentFolder, currentIdentity, "option", 0, 0, "title block: the properties " & names & " are set and read back; the sheet's title block notes do not show their text, so it is not claimed as shown"
    Else
1108         AppendLog currentFolder, currentIdentity, "option", 0, 0, "title block: the properties " & names & " are set, read back, and shown in the title block notes"
    End If
End Sub

Private Function PackageCount() As Long
1113     PackageCount = 9
End Function

Private Function PackageId(ByVal index As Long) As String
1117     Select Case index
        Case 0: PackageId = "D10a"
        Case 1: PackageId = "D11a"
        Case 2: PackageId = "D12a"
        Case 3: PackageId = "D13a"
        Case 4: PackageId = "D14a"
        Case 5: PackageId = "D15a"
        Case 6: PackageId = "D16a"
        Case 7: PackageId = "D17a"
        Case 8: PackageId = "D18a"
    End Select
End Function

Private Function PackageModel(ByVal index As Long) As String
1131     Select Case index
        Case 0: PackageModel = "F04a"
        Case 1: PackageModel = "D04a"
        Case 2: PackageModel = "D06a"
        Case 3: PackageModel = "P03a"
        Case 4: PackageModel = "P03b"
        Case 5: PackageModel = "P07a"
        Case 6: PackageModel = "P08a"
        Case 7: PackageModel = "P06a"
        Case 8: PackageModel = "P06b"
    End Select
End Function

Private Function PackageState(ByVal index As Long) As Long
    ' 0 drawn, 1 not scripted (PackageReason says why)
1146     Select Case index
        Case 0: PackageState = 0
        Case 1: PackageState = 0
        Case 2: PackageState = 0
        Case 3: PackageState = 0
        Case 4: PackageState = 0
        Case 5: PackageState = 0
        Case 6: PackageState = 0
        Case 7: PackageState = 0
        Case 8: PackageState = 0
    End Select
End Function

Private Function PackageReason(ByVal index As Long) As String
1160     Select Case index
    End Select
End Function

Private Sub BuildPackage(ByVal index As Long)
1165     Select Case index
        Case 0: BuildPackage0
        Case 1: BuildPackage1
        Case 2: BuildPackage2
        Case 3: BuildPackage3
        Case 4: BuildPackage4
        Case 5: BuildPackage5
        Case 6: BuildPackage6
        Case 7: BuildPackage7
        Case 8: BuildPackage8
    End Select
End Sub

Private Sub BuildPackageTitle(ByVal index As Long)
1179     Select Case index
        Case 0: BuildPackageTitle0
        Case 1: BuildPackageTitle1
        Case 2: BuildPackageTitle2
        Case 3: BuildPackageTitle3
        Case 4: BuildPackageTitle4
        Case 5: BuildPackageTitle5
        Case 6: BuildPackageTitle6
        Case 7: BuildPackageTitle7
        Case 8: BuildPackageTitle8
    End Select
End Sub

Private Sub BuildPackage0()
1193     PackageStart "F04a", Array(-10.0#, -15.0#, 0.0#), Array(10.0#, 15.0#, 10.0#)
1194     PackageSheet 2, 0, 6, 0.297#, 0.21#, 1.0#, 1.0#
1195     PackageBase "*Bottom", 1, 0, 2, 0.34#, 0.45#
1196     PackageProjected "beside", 0, 1, 0.57#, 0.45#, 0.1#, 0.45#
1197     PackageProjected "vertical", 2, 1, 0.34#, 0.8#, 0.34#, 0.12#
1198     PackageIso 1.0#, 2.0#, 0.83#, 0.2#
1199     PackageDimension 20.0#, Array(-10.0#, -15.0#, 10.0#), Array(10.0#, -15.0#, 10.0#)
1200     PackageDimension 30.0#, Array(-10.0#, -15.0#, 10.0#), Array(-10.0#, 15.0#, 10.0#)
1201     PackageDimension 10.0#, Array(10.0#, -15.0#, 0.0#), Array(10.0#, -15.0#, 10.0#)
1202     PackageDimension 10.0#, Array(-10.0#, 0.0#, 10.0#), Array(0.0#, 0.0#, 10.0#)
1203     PackageDimension 15.0#, Array(0.0#, -15.0#, 10.0#), Array(0.0#, 0.0#, 10.0#)
1204     PackageSection "A", 0, 2, True, 0.0#, 0.83#, 0.65#
End Sub

Private Sub BuildPackageTitle0()
1208     PackageProperty "Title", "F04a drawing"
1209     PackageProperty "DrawnBy", "Fixture Builder"
1210     PackageTitleCheck
End Sub

Private Sub BuildPackage1()
1214     PackageStart "D04a", Array(0.0#, 0.0#, 0.0#), Array(40.0#, 30.0#, 30.0#)
1215     PackageSheet 2, 0, 6, 0.297#, 0.21#, 1.0#, 1.0#
1216     PackageBase "*Bottom", 1, 0, 2, 0.34#, 0.45#
1217     PackageProjected "beside", 0, 1, 0.57#, 0.45#, 0.1#, 0.45#
1218     PackageProjected "vertical", 2, 1, 0.34#, 0.8#, 0.34#, 0.12#
1219     PackageIso 1.0#, 2.0#, 0.83#, 0.2#
1220     PackageDimension 40.0#, Array(0.0#, 0.0#, 0.0#), Array(40.0#, 0.0#, 0.0#)
1221     PackageDimension 30.0#, Array(0.0#, 0.0#, 0.0#), Array(0.0#, 0.0#, 30.0#)
1222     PackageDimension 5.0#, Array(40.0#, 0.0#, 0.0#), Array(40.0#, 0.0#, 5.0#)
1223     PackageDimension 25.0#, Array(0.0#, 15.0#, 5.0#), Array(25.0#, 15.0#, 5.0#)
1224     PackageSection "A", 0, 2, True, 25.0#, 0.83#, 0.65#
End Sub

Private Sub BuildPackageTitle1()
1228     PackageProperty "Title", "D04a drawing"
1229     PackageProperty "DrawnBy", "Fixture Builder"
1230     PackageTitleCheck
End Sub

Private Sub BuildPackage2()
1234     PackageStart "D06a", Array(0.0#, 0.0#, 0.0#), Array(60.0#, 40.0#, 10.0#)
1235     PackageSheet 2, 0, 6, 0.297#, 0.21#, 1.0#, 1.0#
1236     PackageBase "*Bottom", 1, 0, 2, 0.34#, 0.45#
1237     PackageProjected "beside", 0, 1, 0.57#, 0.45#, 0.1#, 0.45#
1238     PackageProjected "vertical", 2, 1, 0.34#, 0.8#, 0.34#, 0.12#
1239     PackageIso 1.0#, 2.0#, 0.83#, 0.2#
1240     PackageDimension 60.0#, Array(0.0#, 0.0#, 0.0#), Array(60.0#, 0.0#, 0.0#)
1241     PackageDimension 40.0#, Array(0.0#, 0.0#, 10.0#), Array(0.0#, 40.0#, 10.0#)
1242     PackageDimension 10.0#, Array(60.0#, 0.0#, 0.0#), Array(60.0#, 0.0#, 10.0#)
1243     PackageDimension 20.0#, Array(0.0#, 20.0#, 10.0#), Array(20.0#, 20.0#, 10.0#)
1244     PackageDimension 20.0#, Array(60.0#, 0.0#, 10.0#), Array(60.0#, 20.0#, 10.0#)
1245     PackageSection "A", 0, 2, True, 20.0#, 0.83#, 0.65#
End Sub

Private Sub BuildPackageTitle2()
1249     PackageProperty "Title", "D06a drawing"
1250     PackageProperty "DrawnBy", "Fixture Builder"
1251     PackageTitleCheck
End Sub

Private Sub BuildPackage3()
1255     PackageStart "P03a", Array(-10.0#, -15.0#, 0.0#), Array(10.0#, 15.0#, 10.0#)
1256     PackageSheet 2, 0, 6, 0.297#, 0.21#, 1.0#, 1.0#
1257     PackageBase "*Bottom", 1, 0, 2, 0.34#, 0.45#
1258     PackageProjected "beside", 0, 1, 0.57#, 0.45#, 0.1#, 0.45#
1259     PackageProjected "vertical", 2, 1, 0.34#, 0.8#, 0.34#, 0.12#
1260     PackageIso 1.0#, 2.0#, 0.83#, 0.2#
1261     PackageDimension 20.0#, Array(-10.0#, -15.0#, 10.0#), Array(10.0#, -15.0#, 10.0#)
1262     PackageDimension 30.0#, Array(-10.0#, -15.0#, 10.0#), Array(-10.0#, 15.0#, 10.0#)
1263     PackageDimension 10.0#, Array(10.0#, -15.0#, 0.0#), Array(10.0#, -15.0#, 10.0#)
1264     PackageDimension 10.0#, Array(-10.0#, 0.0#, 10.0#), Array(0.0#, 0.0#, 10.0#)
1265     PackageDimension 15.0#, Array(0.0#, -15.0#, 10.0#), Array(0.0#, 0.0#, 10.0#)
1266     PackageSection "A", 0, 2, True, 0.0#, 0.83#, 0.65#
End Sub

Private Sub BuildPackageTitle3()
1270     PackageProperty "Title", "P03a drawing"
1271     PackageProperty "DrawnBy", "Fixture Builder"
1272     PackageTitleCheck
End Sub

Private Sub BuildPackage4()
1276     PackageStart "P03b", Array(-10.0#, -15.0#, 0.0#), Array(10.0#, 15.0#, 10.0#)
1277     PackageSheet 2, 0, 6, 0.297#, 0.21#, 1.0#, 1.0#
1278     PackageBase "*Bottom", 1, 0, 2, 0.34#, 0.45#
1279     PackageProjected "beside", 0, 1, 0.57#, 0.45#, 0.1#, 0.45#
1280     PackageProjected "vertical", 2, 1, 0.34#, 0.8#, 0.34#, 0.12#
1281     PackageIso 1.0#, 2.0#, 0.83#, 0.2#
1282     PackageDimension 20.0#, Array(-10.0#, -15.0#, 10.0#), Array(10.0#, -15.0#, 10.0#)
1283     PackageDimension 30.0#, Array(-10.0#, -15.0#, 10.0#), Array(-10.0#, 15.0#, 10.0#)
1284     PackageDimension 10.0#, Array(10.0#, -15.0#, 0.0#), Array(10.0#, -15.0#, 10.0#)
1285     PackageDimension 10.0#, Array(-10.0#, 0.0#, 10.0#), Array(0.0#, 0.0#, 10.0#)
1286     PackageDimension 15.0#, Array(0.0#, -15.0#, 10.0#), Array(0.0#, 0.0#, 10.0#)
1287     PackageSection "A", 0, 2, True, 0.0#, 0.83#, 0.65#
End Sub

Private Sub BuildPackageTitle4()
1291     PackageProperty "Title", "P03b drawing"
1292     PackageProperty "DrawnBy", "Fixture Builder"
1293     PackageTitleCheck
End Sub

Private Sub BuildPackage5()
1297     PackageStart "P07a", Array(0.0#, 0.0#, 0.0#), Array(60.0#, 40.0#, 5.0#)
1298     PackageSheet 2, 0, 6, 0.297#, 0.21#, 1.0#, 1.0#
1299     PackageBase "*Bottom", 1, 0, 2, 0.34#, 0.45#
1300     PackageProjected "beside", 0, 1, 0.57#, 0.45#, 0.1#, 0.45#
1301     PackageProjected "vertical", 2, 1, 0.34#, 0.8#, 0.34#, 0.12#
1302     PackageIso 1.0#, 2.0#, 0.83#, 0.2#
1303     PackageDimension 60.0#, Array(0.0#, 0.0#, 5.0#), Array(60.0#, 0.0#, 5.0#)
1304     PackageDimension 40.0#, Array(0.0#, 0.0#, 5.0#), Array(0.0#, 40.0#, 5.0#)
1305     PackageDimension 5.0#, Array(60.0#, 0.0#, 0.0#), Array(60.0#, 0.0#, 5.0#)
1306     PackageDimension 5.0#, Array(0.0#, 5.0#, 5.0#), Array(5.0#, 5.0#, 5.0#)
1307     PackageDimension 10.0#, Array(5.0#, 5.0#, 5.0#), Array(15.0#, 5.0#, 5.0#)
1308     PackageDimension 10.0#, Array(5.0#, 5.0#, 5.0#), Array(5.0#, 15.0#, 5.0#)
1309     PackageSection "A", 0, 2, True, 5.0#, 0.83#, 0.65#
End Sub

Private Sub BuildPackageTitle5()
1313     PackageProperty "Title", "P07a drawing"
1314     PackageProperty "DrawnBy", "Fixture Builder"
1315     PackageTitleCheck
End Sub

Private Sub BuildPackage6()
1319     PackageStart "P08a", Array(-30.0#, -30.0#, 0.0#), Array(30.0#, 30.0#, 5.0#)
1320     PackageSheet 2, 0, 6, 0.297#, 0.21#, 1.0#, 1.0#
1321     PackageBase "*Bottom", 1, 0, 2, 0.34#, 0.45#
1322     PackageProjected "beside", 0, 1, 0.57#, 0.45#, 0.1#, 0.45#
1323     PackageProjected "vertical", 2, 1, 0.34#, 0.8#, 0.34#, 0.12#
1324     PackageIso 1.0#, 2.0#, 0.83#, 0.2#
1325     PackageDimension 60.0#, Array(-30.0#, 0.0#, 5.0#), Array(30.0#, 0.0#, 5.0#)
1326     PackageDimension 5.0#, Array(30.0#, 0.0#, 0.0#), Array(30.0#, 0.0#, 5.0#)
1327     PackageDimension 20.0#, Array(0.0#, 0.0#, 5.0#), Array(20.0#, 0.0#, 5.0#)
1328     PackageDimension 40.0#, Array(-20.0#, 0.0#, 5.0#), Array(20.0#, 0.0#, 5.0#)
1329     PackageSection "A", 0, 2, True, 20.0#, 0.83#, 0.65#
End Sub

Private Sub BuildPackageTitle6()
1333     PackageProperty "Title", "P08a drawing"
1334     PackageProperty "DrawnBy", "Fixture Builder"
1335     PackageTitleCheck
End Sub

Private Sub BuildPackage7()
1339     PackageStart "P06a", Array(-10.0#, -15.0#, 0.0#), Array(10.0#, 15.0#, 10.0#)
1340     PackageSheet 2, 0, 6, 0.297#, 0.21#, 1.0#, 1.0#
1341     PackageBase "*Bottom", 1, 0, 2, 0.34#, 0.45#
1342     PackageProjected "beside", 0, 1, 0.57#, 0.45#, 0.1#, 0.45#
1343     PackageProjected "vertical", 2, 1, 0.34#, 0.8#, 0.34#, 0.12#
1344     PackageIso 1.0#, 2.0#, 0.83#, 0.2#
1345     PackageDimension 20.0#, Array(-10.0#, -15.0#, 10.0#), Array(10.0#, -15.0#, 10.0#)
1346     PackageDimension 30.0#, Array(-10.0#, -15.0#, 10.0#), Array(-10.0#, 15.0#, 10.0#)
1347     PackageDimension 10.0#, Array(10.0#, -15.0#, 0.0#), Array(10.0#, -15.0#, 10.0#)
1348     PackageDimension 1.5#, Array(-10.0#, 0.0#, 10.0#), Array(-8.5#, 0.0#, 10.0#)
1349     PackageDimension 1.5#, Array(0.0#, -15.0#, 10.0#), Array(0.0#, -13.5#, 10.0#)
1350     PackageSection "A", 0, 2, True, 0.0#, 0.83#, 0.65#
End Sub

Private Sub BuildPackageTitle7()
1354     PackageProperty "Title", "P06a drawing"
1355     PackageProperty "DrawnBy", "Fixture Builder"
1356     PackageTitleCheck
End Sub

Private Sub BuildPackage8()
1360     PackageStart "P06b", Array(-10.0#, -15.0#, 0.0#), Array(10.0#, 15.0#, 10.0#)
1361     PackageSheet 2, 0, 6, 0.297#, 0.21#, 1.0#, 1.0#
1362     PackageBase "*Bottom", 1, 0, 2, 0.34#, 0.45#
1363     PackageProjected "beside", 0, 1, 0.57#, 0.45#, 0.1#, 0.45#
1364     PackageProjected "vertical", 2, 1, 0.34#, 0.8#, 0.34#, 0.12#
1365     PackageIso 1.0#, 2.0#, 0.83#, 0.2#
1366     PackageDimension 20.0#, Array(-10.0#, -15.0#, 10.0#), Array(10.0#, -15.0#, 10.0#)
1367     PackageDimension 30.0#, Array(-10.0#, -15.0#, 10.0#), Array(-10.0#, 15.0#, 10.0#)
1368     PackageDimension 10.0#, Array(10.0#, -15.0#, 0.0#), Array(10.0#, -15.0#, 10.0#)
1369     PackageDimension 2.0#, Array(-10.0#, 0.0#, 10.0#), Array(-8.0#, 0.0#, 10.0#)
1370     PackageDimension 2.0#, Array(0.0#, -15.0#, 10.0#), Array(0.0#, -13.0#, 10.0#)
1371     PackageSection "A", 0, 2, True, 0.0#, 0.83#, 0.65#
End Sub

Private Sub BuildPackageTitle8()
1375     PackageProperty "Title", "P06b drawing"
1376     PackageProperty "DrawnBy", "Fixture Builder"
1377     PackageTitleCheck
End Sub

Private Function IsUnattended() As Boolean
1381     IsUnattended = (Trim$(Environ$("FIXTURE_UNATTENDED")) = "1")
End Function

Private Sub EnsureFolder(ByVal fs As Object, ByVal path As String)
    Dim parent As String
    stepLabel = currentIdentity & ": EnsureFolder FolderExists"
1387     If fs.FolderExists(path) Then Exit Sub
    stepLabel = currentIdentity & ": EnsureFolder GetParentFolderName"
1389     parent = fs.GetParentFolderName(path)
1390     If Len(parent) > 0 Then EnsureFolder fs, parent
    stepLabel = currentIdentity & ": EnsureFolder CreateFolder" & " " & apiInputs & " " & callInputs
1392     fs.CreateFolder path
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
1406     On Error Resume Next
1407     If variable = "MYDOCUMENTS" Then
1408         value = CreateObject("WScript.Shell").SpecialFolders("MyDocuments")
    Else
1410         value = CreateObject("WScript.Shell").ExpandEnvironmentStrings("%" & variable & "%")
1411         If value = "%" & variable & "%" Then value = ""
    End If
1413     If Err.Number <> 0 Then value = ""
1414     Err.Clear
1415     EnvText = Trim$(value)
End Function

Private Function DefaultOutputRoot() As String
    Dim pub As String, result As String
1420     pub = Replace(EnvText("PUBLIC"), "/", "\")
1421     Do While Len(pub) > 0 And Right$(pub, 1) = "\"
1422         pub = Left$(pub, Len(pub) - 1)
    Loop
1424     If Len(pub) = 0 Then
1425         result = "C:\FixtureBuilder"
    Else
1427         result = pub & "\Documents\FixtureBuilder"
    End If
1429     DefaultOutputRoot = result
End Function

Private Function UserNameNotice() As String
1433     UserNameNotice = "SolidWorks writes your Windows user name into each file it saves. We keep these native files private and publish only STEP and files we've checked clean; to keep your name out of the files entirely, run SolidWorks under a neutral Windows account."
End Function

Private Function NameInsideComponents(ByVal user As String) As Boolean
    ' A word-matched name: 3 or more characters and not a common word. It is matched wherever the characters on both sides are not ASCII
    ' letters or digits (the start of the text, a tab, a quote, a length byte, "-", "_" ...); any other name (and a shorter one) only as a
    ' whole path segment. The same for the user name, the profile folder's own name and the computer, domain and logon-server names.
    Dim inside As Boolean
1441     inside = (Len(user) >= 3)
1442     If InStr("|admin|user|users|owner|public|default|test|cad|work|data|home|the|and|pro|dev|lab|app|sys|doc|docs|temp|office|pc|laptop|desktop|", "|" & user & "|") > 0 Then inside = False
1443     NameInsideComponents = inside
End Function

Private Function IsAsciiAlnum(ByVal ch As String) As Boolean
1447     IsAsciiAlnum = (ch Like "[A-Za-z0-9]")
End Function

Private Function WordIn(ByVal text As String, ByVal needle As String) As Boolean
    ' The needle in the text with no ASCII letter or digit next to it (or the edge of the text): both already lower-cased.
    Dim pos As Long, before As String, after As String, found As Boolean
1453     If Len(needle) > 0 Then
1454         pos = InStr(1, text, needle, vbBinaryCompare)
1455         Do While pos > 0 And Not found
1456             before = ""
1457             after = ""
1458             If pos > 1 Then before = Mid$(text, pos - 1, 1)
1459             If pos + Len(needle) <= Len(text) Then after = Mid$(text, pos + Len(needle), 1)
1460             If (Len(before) = 0 Or Not IsAsciiAlnum(before)) And (Len(after) = 0 Or Not IsAsciiAlnum(after)) Then found = True
1461             pos = InStr(pos + 1, text, needle, vbBinaryCompare)
        Loop
    End If
1464     WordIn = found
End Function

Private Function SegmentMatches(ByVal part As String, ByVal needle As String) As Boolean
    Dim hit As Boolean
1469     If Len(needle) > 0 Then hit = (part = needle)
1470     If Len(needle) > 0 And Not hit Then
1471         If NameInsideComponents(needle) Then hit = WordIn(part, needle)
    End If
1473     SegmentMatches = hit
End Function

Private Function NormalPath(ByVal path As String) As String
    Dim p As String
1478     p = LCase$(Replace(Trim$(path), "/", "\"))
1479     Do While Len(p) > 0 And Right$(p, 1) = "\"
1480         p = Left$(p, Len(p) - 1)
    Loop
1482     NormalPath = p
End Function

Private Function LeafOf(ByVal normal As String) As String
1486     LeafOf = Mid$(normal, InStrRev(normal, "\") + 1)
End Function

Private Function UnderRoot(ByVal p As String, ByVal root As String) As Boolean
    Dim under As Boolean
1491     If Len(root) > 0 Then under = (p = root Or Left$(p, Len(root) + 1) = root & "\")
1492     UnderRoot = under
End Function

Private Function PersonalPathRefusal(ByVal what As String, ByVal why As String) As String
1496     PersonalPathRefusal = "The " & what & " was refused because " & why & ". " & _
        "SolidWorks stores this path inside every assembly and drawing it saves, so the files you send would show it. " & _
        "Choose a neutral one instead, for example " & DefaultOutputRoot() & " for the output folder. Nothing was built."
End Function

Private Function DriveRooted(ByVal path As String) As Boolean
    Dim t As String
1503     t = Trim$(path)
1504     DriveRooted = (Len(t) >= 3 And Mid$(t, 1, 1) Like "[A-Za-z]" And Mid$(t, 2, 1) = ":" And (Mid$(t, 3, 1) = "\" Or Mid$(t, 3, 1) = "/"))
End Function

Private Function PersonalWhy(ByVal path As String, ByVal identity As Boolean) As String
    ' With identity False (the default output root, the one folder the builder names itself) only the last two rules apply, so a user called
    ' Documents, Public or FixtureBuilder is not locked out of it. The first of these that applies, on the lower-cased path: inside %USERPROFILE%; inside a OneDrive folder or the redirected Documents
    ' folder; a folder that is, or (guarded names) contains, %USERNAME% or the profile folder's own name; a folder named after the computer,
    ' domain or logon server; a folder whose name contains "onedrive"; a UNC share; a Users\<name> folder that is not Public.
    Dim p As String, profile As String, parts As Variant, i As Long, k As Long, why As String
    Dim names(0 To 1) As String, machines(0 To 2) As String, roots(0 To 3) As String
1514     p = NormalPath(path)
1515     profile = NormalPath(EnvText("USERPROFILE"))
1516     names(0) = LCase$(EnvText("USERNAME"))
1517     names(1) = LeafOf(profile)
1518     machines(0) = LCase$(EnvText("COMPUTERNAME"))
1519     machines(1) = LCase$(EnvText("USERDOMAIN"))
1520     machines(2) = LCase$(Replace(EnvText("LOGONSERVER"), "\", ""))
1521     roots(0) = NormalPath(EnvText("OneDrive"))
1522     roots(1) = NormalPath(EnvText("OneDriveCommercial"))
1523     roots(2) = NormalPath(EnvText("OneDriveConsumer"))
1524     roots(3) = NormalPath(EnvText("MYDOCUMENTS"))
1525     parts = Split(p, "\")
1526     If identity Then
1527         If UnderRoot(p, profile) Then why = "it is inside your user profile folder"
    End If
1529     If Len(why) = 0 And identity Then
1530         For k = 0 To 3
1531             If UnderRoot(p, roots(k)) Then why = "it is inside your OneDrive or redirected Documents folder"
        Next k
    End If
1534     If Len(why) = 0 And identity Then
1535         For k = 0 To 1
1536             If Len(names(k)) > 0 Then
1537                 For i = 0 To UBound(parts)
1538                     If SegmentMatches(CStr(parts(i)), names(k)) Then why = "a folder in its path contains your Windows user name"
                Next i
            End If
        Next k
    End If
1543     If Len(why) = 0 And identity Then
1544         For k = 0 To 2
1545             For i = 0 To UBound(parts)
1546                 If SegmentMatches(CStr(parts(i)), machines(k)) Then why = "a folder in its path is named after this computer, its domain or its logon server"
            Next i
        Next k
    End If
1550     If Len(why) = 0 And identity Then
1551         For i = 0 To UBound(parts)
1552             If InStr(parts(i), "onedrive") > 0 Then why = "a folder in its path is a OneDrive folder"
        Next i
    End If
1555     If Len(why) = 0 And Left$(p, 2) = "\\" Then why = "it is on a network share (a \\server\share path)"
1556     If Len(why) = 0 Then
1557         For i = 0 To UBound(parts) - 1
1558             If parts(i) = "users" And Len(parts(i + 1)) > 0 And parts(i + 1) <> "public" And parts(i + 1) <> "default" And parts(i + 1) <> "all users" And parts(i + 1) <> "shared" Then why = "it is inside the personal folder of a Windows user (a Users\<name> folder)"
        Next i
    End If
    ' Last, and for every folder (the default root too): a folder that is not a full path with a drive letter ("FixtureOut", "..\x",
    ' "%USERPROFILE%\x", which FileSystemObject does not expand) would resolve against SolidWorks' own current folder, which may be under the profile.
1563     If Len(why) = 0 Then
1564         If Not DriveRooted(path) Then why = "the folder must be a full path starting with a drive letter"
    End If
1566     PersonalWhy = why
End Function

Private Function PersonalPathReason(ByVal path As String) As String
    Dim why As String
1571     why = PersonalWhy(path, NormalPath(path) <> NormalPath(DefaultOutputRoot()))
1572     If Len(why) = 0 Then
1573         PersonalPathReason = ""
    Else
1575         PersonalPathReason = PersonalPathRefusal("output folder", why)
    End If
End Function

Private Function PersonalTemplateReason(ByVal kind As String, ByVal path As String) As String
    Dim why As String
1581     why = PersonalWhy(path, True)
1582     If Len(why) = 0 Then
1583         PersonalTemplateReason = ""
    Else
1585         PersonalTemplateReason = "The " & kind & " template SolidWorks would use was refused because " & why & ". " & _
            "A SolidWorks drawing stores the path of its sheet format and template, so the files you send would show it. " & _
            "In SolidWorks, under Tools > Options > Default Templates, choose a " & kind & " template in a neutral folder (for example the SolidWorks install folder or C:\ProgramData). Nothing was built."
    End If
End Function

Private Function EscapeRegex(ByVal text As String) As String
    Dim i As Long, ch As String, result As String
1593     For i = 1 To Len(text)
1594         ch = Mid$(text, i, 1)
1595         If InStr("\.+*?^$()[]{}|-", ch) > 0 Then result = result & "\"
1596         result = result & ch
    Next i
1598     EscapeRegex = result
End Function

Private Function RootPattern(ByVal root As String) As String
    ' A folder path as a pattern that also matches its doubled-backslash (JSON) and forward-slash forms.
1603     RootPattern = Replace(EscapeRegex(root), "\\", "[\\/]+")
End Function

Private Function CaseForms(ByVal word As String) As String
    ' The word as written, lower-cased and upper-cased, as one escaped alternation: VBScript's RegExp folds the case of ASCII letters only, so a
    ' Cyrillic or Greek name written in another case would be missed. LCase$ and UCase$ are Unicode-aware.
1609     CaseForms = "(?:" & EscapeRegex(word) & "|" & EscapeRegex(LCase$(word)) & "|" & EscapeRegex(UCase$(word)) & ")"
End Function

Private Function ScrubNeedle(ByVal regex As Object, ByVal text As String, ByVal needle As String, ByVal marker As String) As String
    ' A word-matched needle wherever no ASCII letter or digit is next to it (start of text, tab, quote ...); any other only as a whole folder name.
    Dim result As String
1615     result = text
1616     If Len(needle) > 0 Then
1617         If NameInsideComponents(LCase$(needle)) Then
1618             regex.Pattern = "(^|[^A-Za-z0-9])" & CaseForms(needle) & "(?=[^A-Za-z0-9]|$)"
1619             result = regex.Replace(result, "$1" & marker)
        Else
1621             regex.Pattern = "([\\/])" & CaseForms(needle) & "(?=[.,;)]*(?:[\\/\s""'<>|:*?]|$))"
1622             result = regex.Replace(result, "$1" & marker)
        End If
    End If
1625     ScrubNeedle = result
End Function

Private Function PrivacyScrub(ByVal text As String) As String
    ' Every message a volunteer might screenshot, every log line and every text file in the output goes through this. In order: the tail
    ' of any path under \Users\<x> (x is not Public; a name with a space, an 8.3 name, a Dropbox (Company) folder: all of it, up to a
    ' quote, a line end, a tab or the sentence end) becomes <user>\<path>; the profile, OneDrive and Documents folders likewise; the
    ' Windows user name and the profile folder's own name (anywhere when guarded, else only as a whole folder name) become <user>; the
    ' computer, domain and logon server names (whole tokens, guarded) become <host>; a \\server\share prefix becomes <share>.
    Dim regex As Object, result As String, roots(0 To 4) As String, names(0 To 1) As String, machines(0 To 2) As String
    Dim k As Long, tailEnd As String, swap As String, exempt As String
1636     tailEnd = "(?=[.,;)]*(?:[""'\r\n<>|]|$))"
1637     exempt = "(?!(?:public|default|all users|shared)(?:[\\/""'\r\n<>|]|$))"
1638     result = text
1639     Set regex = CreateObject("VBScript.RegExp")
1640     regex.Global = True
1641     regex.IgnoreCase = True
1642     regex.Pattern = "([\\/]Users[\\/]+)" & exempt & "[^\\/""'\r\n<>|:*?]+?((?:\\\\|[\\/](?![""']))+)(?:[^""'\r\n<>|\\]|\\\\|\\(?![""']))*"
1643     result = regex.Replace(result, "$1<user>$2<path>")
1644     regex.Pattern = "([\\/]Users[\\/]+)" & exempt & "[^\\/""'\r\n<>|:*?]+?" & tailEnd
1645     result = regex.Replace(result, "$1<user>")
1646     roots(0) = EnvText("USERPROFILE")
1647     roots(1) = EnvText("OneDrive")
1648     roots(2) = EnvText("OneDriveCommercial")
1649     roots(3) = EnvText("MYDOCUMENTS")
1650     roots(4) = EnvText("OneDriveConsumer")
1651     For k = 0 To 4
1652         If Len(roots(k)) > 0 Then
1653             regex.Pattern = RootPattern(roots(k)) & "((?:\\\\|[\\/](?![""']))+)(?:[^""'\r\n<>|\\]|\\\\|\\(?![""']))*"
1654             result = regex.Replace(result, "<user>$1<path>")
1655             regex.Pattern = RootPattern(roots(k))
1656             result = regex.Replace(result, "<user>")
        End If
    Next k
1659     names(0) = EnvText("USERNAME")
1660     names(1) = LeafOf(Replace(EnvText("USERPROFILE"), "/", "\"))
    ' The longer of the two first (jsmith.ACME before jsmith), so no part of the profile folder's name is left behind.
1662     If Len(names(1)) > Len(names(0)) Then
1663         swap = names(0)
1664         names(0) = names(1)
1665         names(1) = swap
    End If
1667     machines(0) = EnvText("COMPUTERNAME")
1668     machines(1) = EnvText("USERDOMAIN")
1669     machines(2) = Replace(EnvText("LOGONSERVER"), "\", "")
1670     For k = 0 To 1
1671         result = ScrubNeedle(regex, result, names(k), "<user>")
    Next k
1673     For k = 0 To 2
1674         result = ScrubNeedle(regex, result, machines(k), "<host>")
    Next k
1676     regex.Pattern = "(^|[^\\/\w:])(?:\\\\|//){1,2}[^\\/\s""'<>|:*?]+(?:\\\\|[\\/](?![""']))+(?:[^""'\r\n<>|\\]|\\\\|\\(?![""']))*"
1677     result = regex.Replace(result, "$1<share>")
1678     PrivacyScrub = result
End Function

Private Function EmptiedLine() As String
    ' "" unless the sweep had to empty or delete a text file it could not clean: then the volunteer is told the zip is incomplete.
1683     If sweepEmptiedCount > 0 Then EmptiedLine = vbLf & CStr(sweepEmptiedCount) & " file(s) could not be cleaned and were emptied: " & sweepEmptied
End Function

Private Function ZipReady(ByVal zipPath As String) As Boolean
    ' The zip exists and holds something (an empty zip is 22 bytes).
    Dim fs As Object
1689     On Error Resume Next
1690     Set fs = CreateObject("Scripting.FileSystemObject")
    stepLabel = currentIdentity & ": ZipReady FileExists"
1692     ZipReady = fs.FileExists(zipPath)
    stepLabel = currentIdentity & ": ZipReady GetFile"
1694     If ZipReady Then ZipReady = (fs.GetFile(zipPath).Size > 22)
1695     If Err.Number <> 0 Then ZipReady = False
1696     Err.Clear
End Function

Private Function ZipErrorHead(ByVal errorFile As String) As String
    ' The first 300 characters of the PowerShell error file, one line, or "no error text".
    Dim fs As Object, stream As Object, text As String
1702     On Error Resume Next
1703     Set fs = CreateObject("Scripting.FileSystemObject")
1704     If fs.FileExists(errorFile) Then
1705         Set stream = fs.OpenTextFile(errorFile, 1)
1706         text = stream.ReadAll
1707         stream.Close
    End If
1709     text = Trim$(Replace(Replace(text, vbCr, " "), vbLf, " "))
1710     If Len(text) > 300 Then text = Left$(text, 300)
1711     If Len(text) = 0 Then text = "no error text"
1712     ZipErrorHead = PrivacyScrub(text)
1713     Err.Clear
End Function

Private Sub ZipRemoveOld(ByVal folder As String)
    ' An old zip or error file of the same name (a manual Send to, an earlier run) never counts and is never shown.
    Dim fs As Object
1719     On Error Resume Next
1720     Set fs = CreateObject("Scripting.FileSystemObject")
    stepLabel = currentIdentity & ": ZipRemoveOld FileExists"
1722     If fs.FileExists(folder & ".zip") Then fs.DeleteFile folder & ".zip", True
    stepLabel = currentIdentity & ": ZipRemoveOld FileExists"
1724     If fs.FileExists(folder & "-zip-error.txt") Then fs.DeleteFile folder & "-zip-error.txt", True
1725     Err.Clear
End Sub

Private Function ZipPowerShell(ByVal folder As String, ByVal errorFile As String) As Boolean
    ' Compress-Archive; a failure is written to errorFile (ASCII) and exits 1. True only if the exit code is 0, the zip exists and holds something,
    ' and no error file was written. The old zip and error file are deleted first.
    Dim command As String, quotedFolder As String, quotedZip As String, quotedError As String, code As Long, fs As Object
1732     ZipRemoveOld folder
1733     quotedFolder = Replace(folder, "'", "''")
1734     quotedZip = Replace(folder & ".zip", "'", "''")
1735     quotedError = Replace(errorFile, "'", "''")
1736     command = "powershell.exe -NoProfile -NonInteractive -Command " & Chr$(34) & _
        "try { Compress-Archive -LiteralPath '" & quotedFolder & "' -DestinationPath '" & quotedZip & "' -Force -ErrorAction Stop } " & _
        "catch { $_ | Out-File -LiteralPath '" & quotedError & "' -Encoding ASCII; exit 1 }" & Chr$(34)
    stepLabel = currentIdentity & ": ZipPowerShell Run"
1740     code = CreateObject("WScript.Shell").Run(command, 0, True)
1741     Set fs = CreateObject("Scripting.FileSystemObject")
    stepLabel = currentIdentity & ": ZipPowerShell FileExists"
1743     ZipPowerShell = (code = 0) And ZipReady(folder & ".zip") And Not fs.FileExists(errorFile)
End Function

Private Function ZipWithShell(ByVal folder As String) As Boolean
    ' In-process zip: an empty zip file, then Shell.Application copies the folder into it. The copy is asynchronous: wait until the
    ' folder's items are all inside, the zip stops growing, or about 120 seconds pass.
    Dim fs As Object, stream As Object, shellObject As Object, zipSpace As Object, parentSpace As Object, innerSpace As Object
    Dim zipPath As String, wanted As Long, started As Date, size As Double, lastSize As Double, steady As Long, pause As Double, complete As Boolean
1751     On Error GoTo Failed
1752     zipPath = folder & ".zip"
1753     Set fs = CreateObject("Scripting.FileSystemObject")
1754     ZipRemoveOld folder
    stepLabel = currentIdentity & ": ZipWithShell CreateTextFile" & " " & apiInputs & " " & callInputs
1756     Set stream = fs.CreateTextFile(zipPath, True)
    stepLabel = currentIdentity & ": ZipWithShell Write"
1758     stream.Write "PK" & Chr(5) & Chr(6) & String(18, 0)
    stepLabel = currentIdentity & ": ZipWithShell Close"
1760     stream.Close
1761     Set shellObject = CreateObject("Shell.Application")
    stepLabel = currentIdentity & ": ZipWithShell Namespace"
1763     Set parentSpace = shellObject.Namespace(CVar(fs.GetParentFolderName(folder)))
    stepLabel = currentIdentity & ": ZipWithShell Namespace"
1765     wanted = shellObject.Namespace(CVar(folder)).Items.Count
    stepLabel = currentIdentity & ": ZipWithShell Namespace"
1767     Set zipSpace = shellObject.Namespace(CVar(zipPath))
    stepLabel = currentIdentity & ": ZipWithShell CopyHere"
1769     zipSpace.CopyHere parentSpace.ParseName(fs.GetFileName(folder))
1770     started = Now
1771     lastSize = -1
1772     Do While DateDiff("s", started, Now) < 120
1773         pause = Timer + 0.25
1774         Do While Timer >= pause - 0.25 And Timer < pause
1775             DoEvents
        Loop
1777         size = 0
    stepLabel = currentIdentity & ": ZipWithShell FileExists"
1779         If fs.FileExists(zipPath) Then size = fs.GetFile(zipPath).Size
    stepLabel = currentIdentity & ": ZipWithShell Count"
1781         If zipSpace.Items.Count >= 1 Then
    stepLabel = currentIdentity & ": ZipWithShell Item"
1783             Set innerSpace = zipSpace.Items.Item(0).GetFolder
1784             If Not innerSpace Is Nothing Then
    stepLabel = currentIdentity & ": ZipWithShell Count"
1786                 If innerSpace.Items.Count >= wanted And size > 22 Then
1787                     If size = lastSize Then steady = steady + 1 Else steady = 0
1788                     If steady >= 8 Then
1789                         complete = True
1790                         Exit Do
                    End If
                End If
            End If
        End If
1795         lastSize = size
    Loop
    ' Only if every item arrived and the zip stopped growing; a timeout part way is not a zip.
1798     ZipWithShell = complete And ZipReady(zipPath)
1799     Exit Function
Failed:
1801     ZipWithShell = False
End Function

Private Function ZipMitigationLine() As String
    ' A `mitigations:` line of the zip step alone (the recipes' lines are written before the zip).
    Dim itemName As Variant, text As String
1807     For Each itemName In Array("zip-verify-retry", "zip-shell-application")
    stepLabel = currentIdentity & ": ZipMitigationLine Exists"
1809         If mitigations.Exists(CStr(itemName)) Then
1810             If Len(text) > 0 Then text = text & " "
1811             text = text & CStr(itemName) & "=" & CStr(mitigations(itemName)) & ",primary-failed=" & CStr(primaryFailures(itemName)) & ",fallback-ok=" & CStr(fallbackSuccesses(itemName))
        End If
    Next itemName
1814     ZipMitigationLine = "mitigations: " & text
End Function

Private Function MakeZip(ByVal folder As String) As Boolean
    ' folder & ".zip" for the run. Compress-Archive is checked by looking for the file and the error file, not by its exit code alone (field
    ' 2026.11.24.3: exit code 0 and no zip). An old zip or error file is deleted first and before every attempt. Then: all documents closed and a
    ' second Compress-Archive with its error text kept (zip-verify-retry), then a zip written in-process (zip-shell-application). Never raises: the
    ' finish message tells the person what to do by hand. The mitigations are logged in a line of their own.
    Dim zipPath As String, errorFile As String
1823     zipPath = folder & ".zip"
1824     errorFile = folder & "-zip-error.txt"
1825     On Error Resume Next
1826     ZipRemoveOld folder
1827     If ZipPowerShell(folder, errorFile) Then MakeZip = True: Exit Function
1828     Err.Clear
1829     AppendLog folder, "setup", "zip", 0, 0, "zip: no zip was written; " & ZipErrorHead(errorFile)
1830     RecordMitigation "zip-verify-retry", True, True
    stepLabel = currentIdentity & ": MakeZip CloseAllDocuments"
1832     app.CloseAllDocuments True
1833     Err.Clear
1834     If ZipPowerShell(folder, errorFile) Then
1835         fallbackSuccesses("zip-verify-retry") = fallbackSuccesses("zip-verify-retry") + 1
1836         AppendLog folder, "setup", "zip", 0, 0, "zip-verify-retry: the second Compress-Archive wrote the zip"
1837         AppendLog folder, "setup", "zip", 0, 0, ZipMitigationLine()
1838         MakeZip = True: Exit Function
    End If
1840     Err.Clear
1841     AppendLog folder, "setup", "zip", 0, 0, "zip-verify-retry: still no zip; " & ZipErrorHead(errorFile)
1842     RecordMitigation "zip-shell-application", True, True
1843     If ZipWithShell(folder) Then
1844         fallbackSuccesses("zip-shell-application") = fallbackSuccesses("zip-shell-application") + 1
1845         AppendLog folder, "setup", "zip", 0, 0, "zip-shell-application: Shell.Application wrote the zip"
1846         MakeZip = True
    Else
1848         Err.Clear
1849         AppendLog folder, "setup", "zip", 0, 0, "zip-shell-application: no zip either; the folder is complete, the person zips it by hand"
    End If
1851     AppendLog folder, "setup", "zip", 0, 0, ZipMitigationLine()
End Function

Private Function CountStatus(ByVal status As String) As Long
    Dim needle As String
1856     needle = """status"":" & Quote(status) & ",""error"""
1857     CountStatus = (Len(resultRows) - Len(Replace(resultRows, needle, ""))) \ Len(needle)
End Function

Private Sub ReportCleanupError(ByVal folder As String, ByRef finalMessage As String)
    Dim number As Long, lineNumber As Long, description As String, failedStep As String
    lineNumber = Erl: number = Err.Number: description = Err.Description: failedStep = stepLabel
1863     finalMessage = failedStep & " (line " & CStr(lineNumber) & "): " & description
1864     If Len(folder) > 0 Then AppendLog folder, currentIdentity, failedStep, lineNumber, number, description
End Sub

Private Function TryTopologySelect(ByVal topology As SldWorks.Entity, ByVal appendSelection As Boolean, ByVal data As Object) As Boolean
    ' Only the original call is trapped; fallback errors retain their own diagnostics.
1869     On Error GoTo Failed
    stepLabel = currentIdentity & ": TryTopologySelect Select4" & " " & apiInputs & " " & callInputs
1871     TryTopologySelect = topology.Select4(appendSelection, data)
1872     Exit Function
Failed:
1874     TryTopologySelect = False
End Function

Private Sub RecordMitigation(ByVal itemName As String, Optional ByVal primaryFailed As Boolean = False, Optional ByVal always As Boolean = False)
    ' Mitigations log on every revision (SolidWorks 2023 hit the 2026 failures too).
1879     If Not mitigations.Exists(itemName) Then mitigations.Add itemName, 0
1880     mitigations(itemName) = mitigations(itemName) + 1
1881     If primaryFailed Then
1882         If Not primaryFailures.Exists(itemName) Then primaryFailures.Add itemName, 0
1883         If Not fallbackSuccesses.Exists(itemName) Then fallbackSuccesses.Add itemName, 0
1884         primaryFailures(itemName) = primaryFailures(itemName) + 1
    End If
End Sub

Private Function MitigationText() As String
    Dim itemName As Variant, entries As String
1890     For Each itemName In mitigations.Keys
1891         If Len(entries) > 0 Then entries = entries & " "
1892         entries = entries & CStr(itemName) & "=" & CStr(mitigations(itemName))
1893         If primaryFailures.Exists(itemName) Then
1894             entries = entries & ",primary-failed=" & CStr(primaryFailures(itemName)) & ",fallback-ok=" & CStr(fallbackSuccesses(itemName))
        End If
    Next itemName
1897     If Len(entries) = 0 Then entries = "none"
1898     MitigationText = "mitigations: " & entries
End Function

Private Function MitigationJson() As String
    Dim itemName As Variant, entries As String, counts As String
1903     For Each itemName In mitigations.Keys
1904         If Len(entries) > 0 Then entries = entries & ","
1905         counts = "{""count"":" & CStr(mitigations(itemName))
1906         If primaryFailures.Exists(itemName) Then
1907             counts = counts & ",""primary_failed"":" & CStr(primaryFailures(itemName)) & ",""fallback_ok"":" & CStr(fallbackSuccesses(itemName))
        End If
1909         entries = entries & Quote(CStr(itemName)) & ":" & counts & "}"
    Next itemName
1911     MitigationJson = "{" & entries & "}"
End Function

Private Function TryTemplate(ByVal path As String, ByRef tried As String) As String
    Dim fs As Object
1916     Set fs = CreateObject("Scripting.FileSystemObject")
1917     If Len(tried) > 0 Then tried = tried & "; "
1918     tried = tried & path
    stepLabel = currentIdentity & ": TryTemplate FileExists"
1920     If fs.FileExists(path) Then TryTemplate = path
End Function

Private Function ResolveTemplate(ByVal kind As String) As String
    Dim override As String, preference As Long, filename As String, extension As String
    Dim tried As String, candidate As String, defaultTemplate As String, folders As String
    Dim fs As Object, install As String, language As String, folder As Variant, match As String
1927     Set fs = CreateObject("Scripting.FileSystemObject")
1928     Select Case kind
        Case "part"
1930             override = TEMPLATE_PART: preference = swDefaultTemplatePart: filename = "part.prtdot"
        Case "assembly"
1932             override = TEMPLATE_ASSEMBLY: preference = swDefaultTemplateAssembly: filename = "assem.asmdot"
        Case "drawing"
1934             override = TEMPLATE_DRAWING: preference = swDefaultTemplateDrawing: filename = "drawing.drwdot"
    End Select
1936     If Len(override) > 0 Then
1937         candidate = TryTemplate(override, tried)
1938         If Len(candidate) > 0 Then ResolveTemplate = candidate: Exit Function
    End If
    stepLabel = currentIdentity & ": ResolveTemplate GetUserPreferenceStringValue"
1941     defaultTemplate = app.GetUserPreferenceStringValue(preference)
1942     If Len(defaultTemplate) > 0 Then
1943         candidate = TryTemplate(defaultTemplate, tried)
1944         If Len(candidate) > 0 Then ResolveTemplate = candidate: Exit Function
    End If
    stepLabel = currentIdentity & ": ResolveTemplate GetUserPreferenceStringValue"
1947     folders = app.GetUserPreferenceStringValue(swFileLocationsDocumentTemplates)
    stepLabel = currentIdentity & ": ResolveTemplate GetExecutablePath"
1949     install = app.GetExecutablePath()
    stepLabel = currentIdentity & ": ResolveTemplate GetExtensionName"
1951     If LCase$(fs.GetExtensionName(install)) = "exe" Then install = fs.GetParentFolderName(install)
    stepLabel = currentIdentity & ": ResolveTemplate BuildPath"
1953     language = fs.BuildPath(fs.BuildPath(install, "lang"), app.GetCurrentLanguage())
    stepLabel = currentIdentity & ": ResolveTemplate BuildPath"
1955     folders = folders & ";" & language & ";" & fs.BuildPath(language, "Tutorial")
    stepLabel = currentIdentity & ": ResolveTemplate GetExtensionName"
1957     extension = fs.GetExtensionName(filename)
1958     For Each folder In Split(folders, ";")
1959         folder = Trim$(CStr(folder))
1960         If Len(folder) > 0 Then
    stepLabel = currentIdentity & ": ResolveTemplate BuildPath"
1962             candidate = TryTemplate(fs.BuildPath(folder, filename), tried)
1963             If Len(candidate) > 0 Then ResolveTemplate = candidate: Exit Function
    stepLabel = currentIdentity & ": ResolveTemplate BuildPath"
1965             match = fs.BuildPath(folder, "*." & extension)
1966             If Len(tried) > 0 Then tried = tried & "; "
1967             tried = tried & match
    stepLabel = currentIdentity & ": ResolveTemplate FolderExists"
1969             If fs.FolderExists(folder) Then
1970                 match = Dir$(match)
1971                 Do While Len(match) > 0
    stepLabel = currentIdentity & ": ResolveTemplate BuildPath"
1973                     candidate = TryTemplate(fs.BuildPath(folder, match), tried)
1974                     If Len(candidate) > 0 Then ResolveTemplate = candidate: Exit Function
1975                     match = Dir$()
                Loop
            End If
        End If
    Next folder
1980     Err.Raise 5, , kind & " template unavailable. Paths tried: " & tried
End Function

Private Sub Require(ByVal value As Object, ByVal message As String)
1984     If value Is Nothing Then Err.Raise 5, , message
End Sub

Private Sub SaveFile(ByVal path As String)
    Dim errors As Long, warnings As Long, success As Boolean
    stepLabel = currentIdentity & ": SaveFile SaveAs"
1990     success = doc.Extension.SaveAs(path, 0, 1, Nothing, errors, warnings)
1991     If Not success Or errors <> 0 Then Err.Raise 5, , "SolidWorks SaveAs error " & CStr(errors)
1992     ExportGuard path
1993     RecordReadback
End Sub

Private Sub ExportGuard(ByVal path As String)
    ' Right after SolidWorks writes a DXF or a PDF the builder made: a DXF is text and is scrubbed like one; a PDF is scanned for the names (not
    ' rewritten). A PDF with a name in it, a file over 4 MB (too large to check) or one that cannot be read is deleted and the row fails. The
    ' .sld* files are compressed and are not scanned (the stamp in them is documented); a STEP file has its own guard.
    Dim fs As Object, ext As String, text As String, cleaned As String, problem As String
2001     Set fs = CreateObject("Scripting.FileSystemObject")
    stepLabel = currentIdentity & ": ExportGuard GetExtensionName"
2003     ext = LCase$(fs.GetExtensionName(path))
2004     If ext <> "dxf" And ext <> "pdf" Then Exit Sub
    stepLabel = currentIdentity & ": ExportGuard FileExists"
2006     If Not fs.FileExists(path) Then Exit Sub
2007     On Error Resume Next
2008     If ext = "dxf" Then
2009         text = SweepRead(path)
2010         If Err.Number = 0 Then
2011             cleaned = PrivacyScrub(text)
2012             If cleaned <> text Then SweepWrite path, cleaned
        End If
    ElseIf StrayHasNeedle(path) Then
2015         problem = "carried a personal name"
    End If
2017     If Err.Number <> 0 Then
2018         problem = "could not be checked"
2019         If InStr(Err.Description, "size cap") > 0 Then problem = "too large to check (over 4 MB)"
    End If
2021     Err.Clear
2022     On Error GoTo 0
2023     If Len(problem) > 0 Then
2024         If Not SweepDelete(fs, path) Then SweepTruncate fs, path
2025         Err.Raise 5, , "privacy: " & ext & " " & problem
    End If
End Sub

Private Function SummaryStatus(ByVal field As Long) As String
    ' Ours (Fixture Builder), blank, or written by SolidWorks. Never a value that is not ours.
    Dim value As String, result As String
2032     On Error Resume Next
    stepLabel = currentIdentity & ": SummaryStatus SummaryInfo"
2034     value = CStr(doc.SummaryInfo(field))
2035     If Err.Number <> 0 Then
2036         Err.Clear
2037         result = "not read"
    ElseIf Len(Trim$(value)) = 0 Then
2039         result = "blank"
    ElseIf value = NEUTRAL_VALUE Then
2041         result = NEUTRAL_VALUE
    Else
2043         result = "set by SolidWorks (redacted)"
    End If
2045     SummaryStatus = result
End Function

Private Function StatusRank(ByVal status As String) As Long
    Dim rank As Long
2050     Select Case status
        Case "blank": rank = 1
        Case NEUTRAL_VALUE: rank = 2
        Case "set by SolidWorks (redacted)": rank = 3
        Case Else: rank = 0
    End Select
2056     StatusRank = rank
End Function

Private Sub RecordReadback()
    Dim field As Long, status As String
2061     For field = 2 To 5
2062         status = SummaryStatus(field)
2063         If StatusRank(status) > StatusRank(rbStatus(field)) Then rbStatus(field) = status
    Next field
End Sub

Private Function ReadbackText() As String
    Dim field As Long, labels As Variant, text As String, status As String
2069     labels = Array("author", "keywords", "comment", "savedby")
2070     For field = 2 To 5
2071         status = rbStatus(field)
2072         If Len(status) = 0 Then status = "not read"
2073         text = text & " " & CStr(labels(field - 2)) & "=" & status
    Next field
2075     ReadbackText = "summary info read-back after save:" & text
End Function

Private Function NoticeStep(ByVal launched As Boolean) As String
    ' "" means Cancel: nothing is built. Otherwise the line for the log: whether the notice was shown, and the answer.
    Dim note As String
2081     If launched Then
2082         note = "user name notice: shown by the launcher, answer " & GetSetting("DutchmanFixtures", "SolidWorksBuilder", "NoticeAnswer", "OK")
    ElseIf IsUnattended() Then
2084         note = "user name notice: not shown (unattended run)"
    ElseIf MsgBox(UserNameNotice(), vbOKCancel + vbInformation, "SolidWorks fixtures") = vbOK Then
2086         note = "user name notice: shown, answer OK"
    End If
2088     NoticeStep = note
End Function

Private Function SweepText(ByVal path As String, ByVal charset As String) As String
    Dim stream As Object, text As String
2093     Set stream = CreateObject("ADODB.Stream")
2094     stream.Type = 2
2095     stream.Charset = charset
2096     stream.Open
2097     stream.LoadFromFile path
2098     text = stream.ReadText
2099     stream.Close
2100     SweepText = text
End Function

Private Function SweepReencodes(ByVal text As String, ByRef bytes As Variant) As Boolean
    ' True when the text, encoded as UTF-8, is byte for byte the file: the file really was UTF-8.
    Dim stream As Object, again As Variant, i As Long, same As Boolean
2106     Set stream = CreateObject("ADODB.Stream")
2107     stream.Type = 2
2108     stream.Charset = "utf-8"
2109     stream.Open
2110     stream.WriteText text
2111     stream.Position = 0
2112     stream.Type = 1
2113     stream.Position = 3
2114     again = stream.Read
2115     stream.Close
2116     same = (UBound(again) = UBound(bytes))
2117     If same Then
2118         For i = 0 To UBound(bytes)
2119             If again(i) <> bytes(i) Then same = False: Exit For
        Next i
    End If
2122     SweepReencodes = same
End Function

Private Function SweepRead(ByVal path As String) As String
    ' The file as text, in the encoding it was written in (left in sweepEncoding): UTF-16 or UTF-8 with a byte-order mark, UTF-8 without
    ' one, else the ANSI codepage the builder's own log is written in. A file over 4 MB, NUL bytes without a UTF-16 mark, or any decode
    ' error raises: the caller counts that as a hit (truncate or delete), never as clean.
    Dim stream As Object, bytes As Variant, size As Long, text As String, i As Long, channel As Integer
2130     Set stream = CreateObject("ADODB.Stream")
2131     stream.Type = 1
2132     stream.Open
2133     stream.LoadFromFile path
2134     size = stream.Size
2135     If size > 4194304 Then Err.Raise 5, , "over the sweep size cap"
2136     If size = 0 Then
2137         stream.Close
2138         sweepEncoding = "utf-8"
2139         SweepRead = ""
2140         Exit Function
    End If
2142     bytes = stream.Read
2143     stream.Close
2144     If size >= 2 And bytes(0) = 255 And bytes(1) = 254 Then
2145         sweepEncoding = "utf-16-le-bom"
2146         SweepRead = SweepText(path, "unicode")
2147         Exit Function
    End If
2149     If size >= 2 And bytes(0) = 254 And bytes(1) = 255 Then
2150         sweepEncoding = "utf-16-be-bom"
2151         SweepRead = SweepText(path, "unicodeFFFE")
2152         Exit Function
    End If
2154     If size >= 3 Then
2155         If bytes(0) = 239 And bytes(1) = 187 And bytes(2) = 191 Then
2156             sweepEncoding = "utf-8-bom"
2157             SweepRead = SweepText(path, "utf-8")
2158             Exit Function
        End If
    End If
2161     For i = 0 To UBound(bytes)
2162         If bytes(i) = 0 Then Err.Raise 5, , "NUL bytes without a UTF-16 byte-order mark"
    Next i
2164     text = SweepText(path, "utf-8")
2165     If SweepReencodes(text, bytes) Then
2166         sweepEncoding = "utf-8"
2167         SweepRead = text
2168         Exit Function
    End If
2170     sweepEncoding = "ansi"
2171     channel = FreeFile
2172     Open path For Binary Access Read As #channel
2173     text = Space$(LOF(channel))
2174     Get #channel, , text
2175     Close #channel
2176     SweepRead = text
End Function

Private Sub SweepWrite(ByVal path As String, ByVal text As String)
    ' Back in the encoding SweepRead found (never a different one).
    Dim stream As Object, channel As Integer, fs As Object
2182     Select Case sweepEncoding
        Case "utf-8"
2184             WriteUtf8 path, text
        Case "utf-8-bom", "utf-16-le-bom", "utf-16-be-bom"
2186             Set stream = CreateObject("ADODB.Stream")
2187             stream.Type = 2
2188             If sweepEncoding = "utf-16-le-bom" Then
2189                 stream.Charset = "unicode"
            ElseIf sweepEncoding = "utf-16-be-bom" Then
2191                 stream.Charset = "unicodeFFFE"
            Else
2193                 stream.Charset = "utf-8"
            End If
2195             stream.Open
2196             stream.WriteText text
2197             stream.SaveToFile path, 2
2198             stream.Close
        Case Else
2200             Set fs = CreateObject("Scripting.FileSystemObject")
2201             If fs.FileExists(path) Then fs.DeleteFile path, True
2202             channel = FreeFile
2203             Open path For Binary Access Write As #channel
2204             Put #channel, , text
2205             Close #channel
    End Select
End Sub

Private Function ReadLatin1(ByVal path As String, ByVal cap As Long) As String
    ' Latin-1 maps one byte to one character: the text is the file's bytes (searched, or rewritten byte for byte). Over the cap raises.
    Dim stream As Object, text As String
2212     Set stream = CreateObject("ADODB.Stream")
    stepLabel = currentIdentity & ": ReadLatin1 Type"
2214     stream.Type = 2
    stepLabel = currentIdentity & ": ReadLatin1 Charset"
2216     stream.Charset = "iso-8859-1"
    stepLabel = currentIdentity & ": ReadLatin1 Open"
2218     stream.Open
    stepLabel = currentIdentity & ": ReadLatin1 LoadFromFile"
2220     stream.LoadFromFile path
    stepLabel = currentIdentity & ": ReadLatin1 Size"
2222     If stream.Size > cap Then Err.Raise 5, , "over the size cap"
    stepLabel = currentIdentity & ": ReadLatin1 ReadText"
2224     text = stream.ReadText
    stepLabel = currentIdentity & ": ReadLatin1 Close"
2226     stream.Close
2227     ReadLatin1 = text
End Function

Private Function BytesAsLatin1(ByVal text As String, ByVal charset As String) As String
    ' The text encoded in the charset (utf-8 or unicode = UTF-16-LE), one character per byte; any byte-order mark dropped.
    Dim stream As Object, bytes As Variant, i As Long, skip As Long, result As String
2233     Set stream = CreateObject("ADODB.Stream")
    stepLabel = currentIdentity & ": BytesAsLatin1 Type"
2235     stream.Type = 2
    stepLabel = currentIdentity & ": BytesAsLatin1 Charset"
2237     stream.Charset = charset
    stepLabel = currentIdentity & ": BytesAsLatin1 Open"
2239     stream.Open
    stepLabel = currentIdentity & ": BytesAsLatin1 WriteText"
2241     stream.WriteText text
    stepLabel = currentIdentity & ": BytesAsLatin1 Position"
2243     stream.Position = 0
    stepLabel = currentIdentity & ": BytesAsLatin1 Type"
2245     stream.Type = 1
2246     If charset = "utf-8" Then skip = 3
2247     If charset = "unicode" Then skip = 2
    stepLabel = currentIdentity & ": BytesAsLatin1 Position"
2249     stream.Position = skip
    stepLabel = currentIdentity & ": BytesAsLatin1 Size"
2251     If stream.Size > skip Then
    stepLabel = currentIdentity & ": BytesAsLatin1 Read"
2253         bytes = stream.Read
2254         For i = 0 To UBound(bytes)
2255             result = result & ChrW(bytes(i))
        Next i
    End If
    stepLabel = currentIdentity & ": BytesAsLatin1 Close"
2259     stream.Close
2260     BytesAsLatin1 = result
End Function

Private Function AnsiAsLatin1(ByVal text As String) As String
    ' The single-byte ANSI form (empty when a character does not fit in one byte).
    Dim i As Long, result As String, ok As Boolean
2266     ok = True
2267     For i = 1 To Len(text)
2268         If AscW(Mid$(text, i, 1)) < 0 Or AscW(Mid$(text, i, 1)) > 255 Then ok = False
    Next i
2270     If ok Then
2271         For i = 1 To Len(text)
2272             result = result & ChrW(Asc(Mid$(text, i, 1)) And 255)
        Next i
    End If
2275     AnsiAsLatin1 = result
End Function

Private Function AsciiLower(ByVal text As String) As String
    ' Only A-Z become a-z (LCase$ on the bytes of a file would also change the bytes C0 to DE, which are parts of other characters).
    Dim code As Long
2281     For code = 65 To 90
2282         text = Replace(text, Chr$(code), Chr$(code + 32), 1, -1, vbBinaryCompare)
    Next code
2284     AsciiLower = text
End Function

Private Function NeedleInBytes(ByVal data As String, ByVal needle As String, ByVal wide As Boolean, ByVal word As Boolean) As Boolean
    ' The needle's bytes (one character each) in the file's bytes (the data and the needle with A-Z folded): a word-matched needle (word, decided
    ' on the DECODED name, never on its encoded bytes) with no ASCII letter or digit next to it, any other with a path separator on both sides.
    ' A UTF-16 character is two bytes, so "next to" is two bytes there.
    Dim pos As Long, unit As Long, before As String, after As String, found As Boolean
2292     unit = 1
2293     If wide Then unit = 2
2294     If Len(needle) > 0 Then
2295         pos = InStr(1, data, needle, vbBinaryCompare)
2296         Do While pos > 0 And Not found
2297             before = ""
2298             after = ""
2299             If pos > unit Then before = Mid$(data, pos - unit, 1)
2300             If pos + Len(needle) <= Len(data) Then after = Mid$(data, pos + Len(needle), 1)
2301             If word Then
2302                 If (Len(before) = 0 Or Not IsAsciiAlnum(before)) And (Len(after) = 0 Or Not IsAsciiAlnum(after)) Then found = True
            Else
2304                 If (before = "\" Or before = "/") And (after = "\" Or after = "/") Then found = True
            End If
2306             pos = InStr(pos + 1, data, needle, vbBinaryCompare)
        Loop
    End If
2309     NeedleInBytes = found
End Function

Private Function StrayHasNeedle(ByVal path As String) As Boolean
    ' True when a needle (the user name, the profile folder's name, the computer, domain or logon-server name) is in the file's bytes as
    ' UTF-8, UTF-16-LE or ANSI. A file over 4 MB or one that cannot be read raises.
    ' Each name is tried as written, lower-cased and upper-cased (Unicode-aware), so a Cyrillic name in another case is found too.
    Dim data As String, words(0 To 4) As String, k As Long, hit As Boolean, word As String, forms(0 To 2) As String, f As Long, isWord As Boolean
2317     data = AsciiLower(ReadLatin1(path, 4194304))
2318     words(0) = EnvText("USERNAME")
2319     words(1) = LeafOf(Replace(EnvText("USERPROFILE"), "/", "\"))
2320     words(2) = EnvText("COMPUTERNAME")
2321     words(3) = EnvText("USERDOMAIN")
2322     words(4) = Replace(EnvText("LOGONSERVER"), "\", "")
2323     For k = 0 To 4
2324         word = words(k)
2325         If Len(word) > 0 Then
2326             isWord = NameInsideComponents(LCase$(word))
2327             forms(0) = word
2328             forms(1) = LCase$(word)
2329             forms(2) = UCase$(word)
2330             For f = 0 To 2
2331                 If NeedleInBytes(data, AsciiLower(BytesAsLatin1(forms(f), "utf-8")), False, isWord) Then hit = True
2332                 If NeedleInBytes(data, AsciiLower(BytesAsLatin1(forms(f), "unicode")), True, isWord) Then hit = True
2333                 If Len(AnsiAsLatin1(forms(f))) > 0 Then
2334                     If NeedleInBytes(data, AsciiLower(AnsiAsLatin1(forms(f))), False, isWord) Then hit = True
                Else
2336                     sweepAnsiSkipped = True        ' the codepage cannot hold it: never read as "matches nothing" in silence (PrivacySweep notes it)
                End If
            Next f
        End If
    Next k
2341     StrayHasNeedle = hit
End Function

Private Function SweepDelete(ByVal fs As Object, ByVal path As String) As Boolean
    Dim attempt As Long, done As Boolean
2346     For attempt = 1 To 3
2347         If Not done Then
2348             On Error Resume Next
2349             Err.Clear
2350             If fs.FileExists(path) Then fs.DeleteFile path, True
2351             done = (Err.Number = 0 And Not fs.FileExists(path))
2352             Err.Clear
2353             On Error GoTo 0
        End If
    Next attempt
2356     SweepDelete = done
End Function

Private Function SweepTruncate(ByVal fs As Object, ByVal path As String) As Boolean
    Dim attempt As Long, done As Boolean
2361     For attempt = 1 To 3
2362         If Not done Then
2363             On Error Resume Next
2364             Err.Clear
2365             fs.CreateTextFile(path, True).Close
2366             done = (Err.Number = 0)
2367             Err.Clear
2368             On Error GoTo 0
        End If
    Next attempt
2371     SweepTruncate = done
End Function

Private Sub SweepNote(ByRef notes As String, ByVal note As String)
2375     If Len(notes) > 0 Then notes = notes & " | "
2376     notes = notes & note
End Sub

Private Sub SweepStray(ByVal fs As Object, ByVal path As String, ByVal fileName As String, ByVal ext As String, ByRef notes As String)
    ' A file that is not text and not one the builder made (named in results.json, or the log): its bytes are searched for the needles and
    ' it is deleted on a hit, a cap or an error.
    Dim hit As Boolean, why As String
    ' Case-insensitive: SolidWorks writes .SLDPRT where the row says .sldprt, and that is still the builder's own file. Its own PDF is still
    ' scanned (never rewritten); the .sld* files are compressed and are not.
2385     If InStr(1, resultRows, Chr$(34) & fileName & Chr$(34), vbTextCompare) > 0 And ext <> "pdf" Then Exit Sub
2386     If InStr("|sldprt|sldasm|slddrw|step|dxf|zip|", "|" & ext & "|") > 0 And Len(resultRows) = 0 Then Exit Sub
2387     why = "stray file, name found"
2388     On Error Resume Next
2389     hit = StrayHasNeedle(path)
2390     If Err.Number <> 0 Then
2391         hit = True
2392         why = "stray file, unreadable"
2393         If InStr(Err.Description, "size cap") > 0 Then why = "stray file, too large to check (over 4 MB)"
    End If
2395     Err.Clear
2396     On Error GoTo 0
2397     If Not hit Then Exit Sub
2398     If SweepDelete(fs, path) Then
2399         SweepNote notes, "privacy sweep: " & fileName & " removed (" & why & ")"
    ElseIf SweepTruncate(fs, path) Then
2401         SweepNote notes, "privacy sweep: " & fileName & " truncated (" & why & ")"
    Else
2403         SweepNote notes, "privacy sweep: " & fileName & " could not be cleaned or removed"
    End If
End Sub

Private Sub SweepFile(ByVal fs As Object, ByVal path As String, ByRef notes As String)
    ' Scrub one file. A text file that cannot be read or written (a lock, no permission) is retried, then truncated to zero bytes, then
    ' deleted; the note says which. Lock files (~$*) and temporary files are deleted. Never raises, so the whole list is always finished.
    Dim fileName As String, ext As String, text As String, cleaned As String, attempt As Long, done As Boolean, reason As String, capped As Boolean
2411     fileName = fs.GetFileName(path)
2412     ext = LCase$(fs.GetExtensionName(path))
2413     If Left$(fileName, 2) = "~$" Or ext = "tmp" Or ext = "temp" Or ext = "partial" Then
2414         If Not SweepDelete(fs, path) Then
2415             If SweepTruncate(fs, path) Then
2416                 SweepNote notes, "privacy sweep: " & fileName & " truncated (could not be removed)"
            Else
2418                 SweepNote notes, "privacy sweep: " & fileName & " could not be removed"
            End If
        End If
2421         Exit Sub
    End If
2423     If InStr("|log|json|txt|csv|tsv|xml|html|htm|md|ini|cfg|yaml|yml|dxf|", "|" & ext & "|") = 0 Then
2424         SweepStray fs, path, fileName, ext, notes
2425         Exit Sub
    End If
2427     For attempt = 1 To 3
2428         If Not done Then
2429             On Error Resume Next
2430             Err.Clear
2431             text = SweepRead(path)
2432             If Err.Number = 0 Then
2433                 cleaned = PrivacyScrub(text)
2434                 If cleaned <> text Then SweepWrite path, cleaned
            End If
2436             done = (Err.Number = 0)
2437             If InStr(Err.Description, "over the sweep size cap") > 0 Then capped = True
2438             Err.Clear
2439             On Error GoTo 0
        End If
    Next attempt
2442     If done Then Exit Sub
2443     reason = "unreadable"
2444     If capped Then reason = "too large to check (over 4 MB)"
2445     sweepEmptiedCount = sweepEmptiedCount + 1
2446     If Len(sweepEmptied) > 0 Then sweepEmptied = sweepEmptied & ", "
2447     sweepEmptied = sweepEmptied & fileName
2448     If SweepTruncate(fs, path) Then
2449         SweepNote notes, "privacy sweep: " & fileName & " truncated (" & reason & ")"
    ElseIf SweepDelete(fs, path) Then
2451         SweepNote notes, "privacy sweep: " & fileName & " removed (" & reason & ")"
    Else
2453         SweepNote notes, "privacy sweep: " & fileName & " could not be cleaned or removed"
    End If
End Sub

Private Sub SweepListFailure(ByVal dirPath As String, ByRef notes As String)
    ' Any error listing a folder (access denied, a path too long): noted with the scrubbed folder name, and no zip is made (fail closed).
2459     sweepListFailed = True
2460     SweepNote notes, "privacy sweep: could not list " & PrivacyScrub(Mid$(dirPath, InStrRev(dirPath, "\") + 1))
2461     Err.Clear
End Sub

Private Sub SweepFolder(ByVal fs As Object, ByVal dirPath As String, ByRef notes As String)
    Dim item As Object, list As String, entries As Variant, i As Long, here As Object, children As Object
2466     On Error Resume Next
2467     Err.Clear
2468     Set here = fs.GetFolder(dirPath)
2469     If Err.Number = 0 Then Set children = here.Files
2470     If Err.Number = 0 Then
2471         For Each item In children
2472             list = list & item.Path & vbLf
        Next item
    End If
2475     If Err.Number <> 0 Then SweepListFailure dirPath, notes
2476     entries = Split(list, vbLf)
2477     For i = 0 To UBound(entries)
2478         If Len(entries(i)) > 0 Then SweepFile fs, CStr(entries(i)), notes
    Next i
2480     list = ""
2481     If Not here Is Nothing Then Set children = here.SubFolders
2482     If Err.Number = 0 And Not here Is Nothing Then
2483         For Each item In children
2484             list = list & item.Path & vbLf
        Next item
    End If
2487     If Err.Number <> 0 Then SweepListFailure dirPath, notes
2488     entries = Split(list, vbLf)
2489     For i = 0 To UBound(entries)
2490         If Len(entries(i)) > 0 Then SweepFolder fs, CStr(entries(i)), notes
    Next i
End Sub

Private Function PrivacySweep(ByVal folder As String) As String
    ' Before the zip: EVERY file in the output folder, listed in results.json or not. Returns the notes (files truncated or removed).
    Dim fs As Object, notes As String
2497     Set fs = CreateObject("Scripting.FileSystemObject")
2498     SweepFolder fs, folder, notes
2499     If Not fs.FolderExists(folder) Then SweepListFailure folder, notes
2500     If sweepAnsiSkipped Then
2501         SweepNote notes, "privacy sweep: ansi form not applicable (a name has characters the ANSI codepage cannot hold); UTF-8 and UTF-16 searched"
2502         sweepAnsiSkipped = False
    End If
2504     PrivacySweep = notes
End Function

Private Sub BlankProperties()
    Dim configs As Variant, config As Variant, manager As Object, itemName As Variant
    ' swSummInfoField_e: author 2, keywords 3, comment 4, saved-by 5. The neutral name goes into author and (if SolidWorks lets a macro
    ' write it) saved-by; keywords and comment are blank. SolidWorks stamps the saving user again at SaveAs: see RecordReadback.
    stepLabel = currentIdentity & ": BlankProperties SummaryInfo"
2512     doc.SummaryInfo(2) = NEUTRAL_VALUE
    stepLabel = currentIdentity & ": BlankProperties SummaryInfo"
2514     doc.SummaryInfo(3) = ""
    stepLabel = currentIdentity & ": BlankProperties SummaryInfo"
2516     doc.SummaryInfo(4) = ""
2517     On Error Resume Next
    stepLabel = currentIdentity & ": BlankProperties SummaryInfo"
2519     doc.SummaryInfo(5) = NEUTRAL_VALUE
2520     Err.Clear
2521     On Error GoTo 0
    stepLabel = currentIdentity & ": BlankProperties CustomPropertyManager"
2523     Set manager = doc.Extension.CustomPropertyManager("")
2524     For Each itemName In Array("Author", "Company", "DrawnBy", "CheckedBy")
    stepLabel = currentIdentity & ": BlankProperties Delete2"
2526         manager.Delete2 CStr(itemName)
    stepLabel = currentIdentity & ": BlankProperties Add3"
2528         If manager.Add3(CStr(itemName), 30, "", 2) <> 0 Then Err.Raise 5, , "Custom property blanking failed"
    Next itemName
    stepLabel = currentIdentity & ": BlankProperties GetConfigurationNames"
2531     configs = doc.GetConfigurationNames()
2532     If Not IsEmpty(configs) Then
2533         For Each config In configs
    stepLabel = currentIdentity & ": BlankProperties CustomPropertyManager"
2535             Set manager = doc.Extension.CustomPropertyManager(CStr(config))
2536             For Each itemName In Array("Author", "Company", "DrawnBy", "CheckedBy")
    stepLabel = currentIdentity & ": BlankProperties Delete2"
2538                 manager.Delete2 CStr(itemName)
    stepLabel = currentIdentity & ": BlankProperties Add3"
2540                 If manager.Add3(CStr(itemName), 30, "", 2) <> 0 Then Err.Raise 5, , "Custom property blanking failed"
            Next itemName
        Next config
    End If
End Sub

Private Function Quote(ByVal text As String) As String
    Dim code As Long
2548     text = Replace(text, "\", "\\")
2549     text = Replace(text, Chr$(34), "\" & Chr$(34))
2550     text = Replace(text, vbCr, "\r")
2551     text = Replace(text, vbLf, "\n")
2552     text = Replace(text, vbTab, "\t")
2553     For code = 0 To 31
2554         text = Replace(text, Chr$(code), "\u" & Right$("0000" & Hex$(code), 4))
    Next code
2556     Quote = Chr$(34) & text & Chr$(34)
End Function

Private Function CleanError(ByVal text As String) As String
    Dim regex As Object
2561     If InStr(text, "Paths tried: ") > 0 Then CleanError = PrivacyScrub(text): Exit Function
2562     Set regex = CreateObject("VBScript.RegExp")
2563     regex.Global = True
    ' A drive path, a UNC path, or a "/" that begins a word ("mid/pair/block", an instance path in a placement report, is not one).
    ' The privacy scrub runs FIRST (it knows where a personal path ends, spaces and all); the generic strip then takes a drive path to the end of
    ' the line or a quote, like the privacy tail.
2567     text = PrivacyScrub(text)
2568     regex.Pattern = "[A-Za-z]:[\\/][^""'\r\n]*"
2569     text = regex.Replace(text, "<path>")
2570     regex.Pattern = "\\\\[^\s""']+"
2571     text = regex.Replace(text, "<path>")
2572     regex.Pattern = "(^|[\s""'(\[=,;:])/[^\s""']+"
2573     CleanError = PrivacyScrub(regex.Replace(text, "$1<path>"))
End Function

Private Sub WriteUtf8(ByVal path As String, ByVal text As String)
    Dim stream As Object, binaryStream As Object
2578     Set stream = CreateObject("ADODB.Stream")
2579     stream.Type = 2
2580     stream.Charset = "utf-8"
2581     stream.Open
2582     stream.WriteText text
2583     stream.Position = 0
2584     stream.Type = 1
2585     stream.Position = 3
2586     Set binaryStream = CreateObject("ADODB.Stream")
2587     binaryStream.Type = 1
2588     binaryStream.Open
2589     stream.CopyTo binaryStream
2590     binaryStream.SaveToFile path, 2
2591     binaryStream.Close
2592     stream.Close
End Sub

Private Sub Pick(ByVal entity As Object, ByVal appendSelection As Boolean, ByVal mark As Long)
    Dim data As Object, topology As SldWorks.Entity, sketchSegment As SldWorks.SketchSegment
    Dim selected As Boolean, before As Long, afterSelect As Long
2598     If Not replayingPicks Then RememberPick entity, appendSelection, mark
2599     callInputs = callInputs & " append=" & CStr(appendSelection) & " mark=" & CStr(mark)
    stepLabel = currentIdentity & ": Pick CreateSelectData" & " " & apiInputs & " " & callInputs
2601     Set data = doc.SelectionManager.CreateSelectData()
    stepLabel = currentIdentity & ": Pick Mark"
2603     data.Mark = mark
    ' An edge of a drawing view is selected in that view (ISelectData.View).
    stepLabel = currentIdentity & ": Pick View"
2606     If Not pickView Is Nothing Then Set data.View = pickView
    stepLabel = currentIdentity & ": Pick SketchSegment"
2608     If TypeOf entity Is SldWorks.SketchSegment Then
2609         Set sketchSegment = entity
    stepLabel = currentIdentity & ": Pick Select4" & " " & apiInputs & " " & callInputs
2611         If Not sketchSegment.Select4(appendSelection, data) Then Err.Raise 5, , "Sketch segment selection failed"
    Else
2613         Set topology = entity
        ' Baseline BEFORE Select4: round 3 measured it after a Select4 that
        ' returned False yet selected, and the fallback then selected twice.
    stepLabel = currentIdentity & ": Pick GetSelectedObjectCount2"
2617         before = doc.SelectionManager.GetSelectedObjectCount2(-1)
2618         selected = TryTopologySelect(topology, appendSelection, data)
2619         afterSelect = before
2620         If Not selected Then
    stepLabel = currentIdentity & ": Pick GetSelectedObjectCount2"
2622             afterSelect = doc.SelectionManager.GetSelectedObjectCount2(-1)
2623             callInputs = callInputs & " select4=False selected-before=" & CStr(before) & " after-select4=" & CStr(afterSelect)
2624             If Select4Grew(appendSelection, before, afterSelect) Then
2625                 RecordMitigation "select4-false-but-selected", True
2626                 fallbackSuccesses("select4-false-but-selected") = fallbackSuccesses("select4-false-but-selected") + 1
2627                 selected = True
            End If
        End If
2630         If Not selected Then
2631             RecordMitigation "select4->multiselect2", True
    stepLabel = currentIdentity & ": Pick MultiSelect2" & " " & apiInputs & " " & callInputs
2633             If doc.Extension.MultiSelect2(Array(entity), appendSelection, data) <> 1 Then
2634                 If Not AppendCountConfirms(appendSelection, before, afterSelect) Then Err.Raise 5, , "Entity selection failed (Select4 and MultiSelect2)"
            End If
2636             fallbackSuccesses("select4->multiselect2") = fallbackSuccesses("select4->multiselect2") + 1
        End If
    End If
End Sub

Private Sub RememberPick(ByVal entity As Object, ByVal appendSelection As Boolean, ByVal mark As Long)
    ' Keep what Pick selected, for ReplayPicks. A selection that is not appended to starts a new list; more than four entities cannot be kept.
2643     If Not appendSelection Then pickCount = 0
2644     If pickCount < 0 Then Exit Sub
2645     If pickCount > 3 Then
2646         pickCount = -1
2647         Exit Sub
    End If
2649     Set pickEntities(pickCount) = entity
2650     pickAppends(pickCount) = appendSelection
2651     pickMarks(pickCount) = mark
2652     pickCount = pickCount + 1
End Sub

Private Function Select4Grew(ByVal appendSelection As Boolean, ByVal before As Long, ByVal after As Long) As Boolean
    ' Did a Select4 that returned False select anyway? Appending: grew by one.
    ' Replacing: only from an empty selection to one; otherwise fall back.
2658     If appendSelection Then
2659         Select4Grew = (after = before + 1)
    Else
2661         Select4Grew = (before = 0 And after = 1)
    End If
End Function

Private Function AppendCountConfirms(ByVal appendSelection As Boolean, ByVal before As Long, ByVal afterSelect As Long) As Boolean
    ' Revision 34.4.0: an appended MultiSelect2 never returned 1 while the
    ' first, non-appended entity did. Accept it if the selection grew by one
    ' since before Select4.
    Dim after As Long
2670     If Not appendSelection Then Exit Function
2671     RecordMitigation "multiselect2-append-count", True
2672     after = doc.SelectionManager.GetSelectedObjectCount2(-1)
2673     callInputs = callInputs & " selected-before=" & CStr(before) & " after-select4=" & CStr(afterSelect) & " after=" & CStr(after)
2674     stepLabel = stepLabel & " selected-before=" & CStr(before) & " after-select4=" & CStr(afterSelect) & " after=" & CStr(after)
2675     If after <> before + 1 Then Exit Function
2676     fallbackSuccesses("multiselect2-append-count") = fallbackSuccesses("multiselect2-append-count") + 1
2677     AppendCountConfirms = True
End Function

Private Function MatrixUsable(ByVal matrix As Variant) As Boolean
    ' IMathTransform.ArrayData: rotation 0-8, translation 9-11, scale 12.
    Dim i As Long, j As Long, k As Long, first As Long, dot As Double, expected As Double
2683     If Not IsArray(matrix) Then Exit Function
2684     first = LBound(matrix)
2685     If UBound(matrix) - first < 12 Then Exit Function
2686     For i = 0 To 12
2687         If Not IsNumeric(matrix(first + i)) Then Exit Function
    Next i
2689     For i = 0 To 2
2690         For j = 0 To 2
2691             dot = 0#
2692             For k = 0 To 2
2693                 dot = dot + CDbl(matrix(first + 3 * i + k)) * CDbl(matrix(first + 3 * j + k))
            Next k
2695             expected = 0#
2696             If i = j Then expected = 1#
2697             If Abs(dot - expected) > 0.000001 Then Exit Function
        Next j
    Next i
2700     MatrixUsable = Abs(CDbl(matrix(first + 12))) > 0.000000001
End Function

Private Function MatrixPoint(ByVal matrix As Variant, ByVal x As Double, ByVal y As Double, ByVal z As Double) As Variant
    ' Row-vector convention: local = (p x R) * scale + translation.
    Dim first As Long, scaleFactor As Double, result(2) As Double, j As Long
2706     first = LBound(matrix)
2707     scaleFactor = CDbl(matrix(first + 12))
2708     For j = 0 To 2
2709         result(j) = (x * CDbl(matrix(first + j)) + y * CDbl(matrix(first + 3 + j)) + z * CDbl(matrix(first + 6 + j))) * scaleFactor + CDbl(matrix(first + 9 + j))
    Next j
2711     MatrixPoint = Array(result(0), result(1), result(2))
End Function

Private Function NumberList(ByVal values As Variant) As String
    Dim i As Long, text As String
2716     For i = LBound(values) To UBound(values)
2717         If i > LBound(values) Then text = text & ","
2718         text = text & Replace(CStr(values(i)), ",", ".")
    Next i
2720     NumberList = text
End Function

Private Function DrawingDocument(ByVal model As Object) As SldWorks.DrawingDoc
2724     Set DrawingDocument = model
End Function

Private Function ViewDrop(ByVal view As Object) As Long
    ' The model axis a drawing view looks along: the z column of its model-to-view rotation (row-vector
    ' convention). Round 8 (field, 34.4.0): the view beside the Top view has the rows (0,0,1), (-1,0,0),
    ' (0,-1,0), so its z column names X and its z row Y; the rotation only has to be a signed axis
    ' permutation (one +-1 and two zeros in every row and column, within 1e-9). A tilted view fails.
    Dim matrix As Variant, i As Long, j As Long, first As Long, ones As Long, zeros As Long, value As Double
    stepLabel = currentIdentity & ": ViewDrop ArrayData"
2734     matrix = view.ModelToViewTransform.ArrayData
2735     If Not MatrixUsable(matrix) Then Err.Raise 5, , "The drawing view transform is not a rotation"
2736     first = LBound(matrix)
2737     For i = 0 To 5
2738         ones = 0
2739         zeros = 0
2740         For j = 0 To 2
2741             If i < 3 Then
2742                 value = CDbl(matrix(first + 3 * i + j))
            Else
2744                 value = CDbl(matrix(first + 3 * j + (i - 3)))
            End If
2746             If Abs(Abs(value) - 1#) <= 0.000000001 Then ones = ones + 1
2747             If Abs(value) <= 0.000000001 Then zeros = zeros + 1
        Next j
2749         If ones <> 1 Or zeros <> 2 Then Err.Raise 5, , "The drawing view is not an axis-aligned view: its rotation is not a signed axis permutation: " & NumberList(matrix)
    Next i
2751     For i = 0 To 2
2752         If Abs(CDbl(matrix(first + 3 * i + 2))) > 0.5 Then ViewDrop = i
    Next i
End Function

Private Function ViewToModel(ByVal matrix As Variant, ByVal point As Variant) As Variant
    ' Undo IView.ModelToViewTransform: view = (model x R) * scale + t, R orthonormal.
    Dim first As Long, i As Long, j As Long, v(2) As Double, result(2) As Double
2759     first = LBound(matrix)
2760     For j = 0 To 2
2761         v(j) = (CDbl(point(j)) - CDbl(matrix(first + 9 + j))) / CDbl(matrix(first + 12))
    Next j
2763     For i = 0 To 2
2764         For j = 0 To 2
2765             result(i) = result(i) + v(j) * CDbl(matrix(first + 3 * i + j))
        Next j
    Next i
2768     ViewToModel = Array(result(0), result(1), result(2))
End Function

Private Function RotateToModel(ByVal matrix As Variant, ByVal axis As Variant) As Variant
    ' A direction from view space to model space: the rotation of ViewToModel only, no scale and no translation.
    Dim first As Long, i As Long, j As Long, result(2) As Double
2774     first = LBound(matrix)
2775     For i = 0 To 2
2776         For j = 0 To 2
2777             result(i) = result(i) + CDbl(axis(j)) * CDbl(matrix(first + 3 * i + j))
        Next j
    Next i
2780     RotateToModel = Array(result(0), result(1), result(2))
End Function

Private Function FlatPoint(ByVal point As Variant, ByVal drop As Long) As Variant
2784     Select Case drop
        Case 0: FlatPoint = Array(CDbl(point(1)), CDbl(point(2)))
        Case 1: FlatPoint = Array(CDbl(point(0)), CDbl(point(2)))
        Case Else: FlatPoint = Array(CDbl(point(0)), CDbl(point(1)))
    End Select
End Function

Private Function NearFlat(ByVal a As Variant, ByVal b As Variant) As Boolean
2792     NearFlat = Abs(CDbl(a(0)) - CDbl(b(0))) <= 0.000001 And Abs(CDbl(a(1)) - CDbl(b(1))) <= 0.000001
End Function

Private Function InsideBox(ByVal point As Variant, ByVal low As Variant, ByVal high As Variant) As Boolean
    Dim i As Long
2797     For i = 0 To 2
2798         If CDbl(point(i)) < CDbl(low(i)) - 0.000001 Or CDbl(point(i)) > CDbl(high(i)) + 0.000001 Then Exit Function
    Next i
2800     InsideBox = True
End Function

Private Function RecordPoint(ByVal record As Object, ByVal key As String, ByVal convert As Long, ByVal matrix As Variant) As Variant
    ' A record's stored point as model meters: as reported (convert = 0) or with the view transform undone (1).
    Dim stored As Variant
2806     stored = record(key)
2807     If convert = 0 Then
2808         RecordPoint = Array(CDbl(stored(0)), CDbl(stored(1)), CDbl(stored(2)))
    Else
2810         RecordPoint = ViewToModel(matrix, stored)
    End If
End Function

Private Function DrawingEdges(ByVal view As Object, ByVal low As Variant, ByVal high As Variant, ByRef drop As Long, ByRef spaceName As String) As Collection
    ' The view's visible line and circle edges, flattened along its axis, in model meters. Entity
    ' coordinates are taken as model coordinates; if they do not all lie inside the model's box they
    ' are tried as view coordinates, and if that fails too the recipe fails.
    Dim matrix As Variant, raw As Variant, entity As Variant, curve As Object, found As Collection, record As Object
    Dim parameters As Variant, convert As Long, ok As Boolean, chosen As Long, viewName As String, axis As Variant, size As Double
    stepLabel = currentIdentity & ": DrawingEdges GetName2"
2821     viewName = view.GetName2()
    stepLabel = currentIdentity & ": DrawingEdges ArrayData"
2823     matrix = view.ModelToViewTransform.ArrayData
2824     drop = ViewDrop(view)
    stepLabel = currentIdentity & ": DrawingEdges GetVisibleEntities2"
2826     raw = view.GetVisibleEntities2(Nothing, swViewEntityType_Edge)
2827     If Not IsArray(raw) Then Err.Raise 5, , viewName & ": GetVisibleEntities2 returned no edges"
2828     Set found = New Collection
2829     For Each entity In raw
    stepLabel = currentIdentity & ": DrawingEdges GetCurve"
2831         Set curve = entity.GetCurve()
2832         If Not curve Is Nothing Then
    stepLabel = currentIdentity & ": DrawingEdges IsLine"
2834             If curve.IsLine() Then
2835                 Set record = CreateObject("Scripting.Dictionary")
2836                 record("kind") = "line"
2837                 Set record("entity") = entity
    stepLabel = currentIdentity & ": DrawingEdges GetPoint"
2839                 record("p0") = entity.GetStartVertex().GetPoint()
    stepLabel = currentIdentity & ": DrawingEdges GetPoint"
2841                 record("p1") = entity.GetEndVertex().GetPoint()
    stepLabel = currentIdentity & ": DrawingEdges Add"
2843                 found.Add record
            ElseIf curve.IsCircle() Then
    stepLabel = currentIdentity & ": DrawingEdges CircleParams"
2846                 parameters = curve.CircleParams
2847                 Set record = CreateObject("Scripting.Dictionary")
2848                 record("kind") = "circle"
2849                 Set record("entity") = entity
2850                 record("p0") = Array(CDbl(parameters(0)), CDbl(parameters(1)), CDbl(parameters(2)))
                ' ICurve.CircleParams: center x, y, z, axis x, y, z, radius.
2852                 record("axis") = Array(CDbl(parameters(3)), CDbl(parameters(4)), CDbl(parameters(5)))
2853                 record("radius") = CDbl(parameters(6))
2854                 record("raw") = Array(CDbl(parameters(0)), CDbl(parameters(1)), CDbl(parameters(2)), CDbl(parameters(3)), CDbl(parameters(4)), CDbl(parameters(5)), CDbl(parameters(6)))
    stepLabel = currentIdentity & ": DrawingEdges Add"
2856                 found.Add record
            End If
        End If
    Next entity
    stepLabel = currentIdentity & ": DrawingEdges Count"
2861     If found.Count = 0 Then Err.Raise 5, , viewName & ": none of its visible edges is a line or a circle"
2862     chosen = -1
2863     For convert = 0 To 1
2864         ok = True
2865         For Each record In found
2866             If Not InsideBox(RecordPoint(record, "p0", convert, matrix), low, high) Then ok = False
2867             If record("kind") = "line" Then
2868                 If Not InsideBox(RecordPoint(record, "p1", convert, matrix), low, high) Then ok = False
            End If
        Next record
2871         If ok Then
2872             chosen = convert
2873             Exit For
        End If
    Next convert
2876     If chosen < 0 Then Err.Raise 5, , viewName & ": the visible edge points lie outside the model box as model coordinates and as view coordinates (transform " & NumberList(matrix) & ")"
2877     spaceName = IIf(chosen = 0, "model", "view")
2878     For Each record In found
2879         record("a") = FlatPoint(RecordPoint(record, "p0", chosen, matrix), drop)
2880         If record("kind") = "line" Then record("b") = FlatPoint(RecordPoint(record, "p1", chosen, matrix), drop)
2881         If record("kind") = "circle" Then
            ' The circle's axis in model space (a view-space axis is only rotated), and whether the view looks straight down it: then it shows as a
            ' circle; otherwise (edge-on) as a straight line through its center, 2 x radius long.
2884             axis = record("axis")
2885             If chosen = 1 Then axis = RotateToModel(matrix, axis)
            ' faceOn: 1 the view looks down the axis, 0 the axis lies across the view, -1 unknown (a zero or non-unit axis, or one at an angle).
2887             size = Sqr(CDbl(axis(0)) * CDbl(axis(0)) + CDbl(axis(1)) * CDbl(axis(1)) + CDbl(axis(2)) * CDbl(axis(2)))
2888             If Abs(size - 1#) > 0.000001 Then
2889                 record("faceOn") = -1
            ElseIf Abs(Abs(CDbl(axis(drop))) - 1#) <= 0.000001 Then
2891                 record("faceOn") = 1
            ElseIf Abs(CDbl(axis(drop))) <= 0.000001 Then
2893                 record("faceOn") = 0
            Else
2895                 record("faceOn") = -1
            End If
2897             record("flatAxis") = FlatPoint(axis, drop)
        End If
    Next record
2900     Set DrawingEdges = found
End Function

Private Function PlanSingle(ByVal records As Collection, ByVal first As Variant, ByVal second As Variant) As Object
    ' A line whose two ends are the two points: selecting it alone dimensions its length.
    Dim record As Object
2906     For Each record In records
2907         If record("kind") = "line" Then
2908             If (NearFlat(record("a"), first) And NearFlat(record("b"), second)) Or (NearFlat(record("a"), second) And NearFlat(record("b"), first)) Then
2909                 Set PlanSingle = record
2910                 Exit Function
            End If
        End If
    Next record
End Function

Private Function CloneRecord(ByVal record As Object, ByVal rung As String) As Object
    ' A copy of an edge record marked with the mitigation name of the plan form that uses it (the cached record itself stays unmarked).
    Dim copy As Object, key As Variant
2919     Set copy = CreateObject("Scripting.Dictionary")
    stepLabel = currentIdentity & ": CloneRecord Keys"
2921     For Each key In record.Keys
2922         If IsObject(record(key)) Then
2923             Set copy(key) = record(key)
        Else
2925             copy(key) = record(key)
        End If
    Next key
2928     copy("rung") = rung
2929     Set CloneRecord = copy
End Function

Private Function PlanDiameter(ByVal records As Collection, ByVal first As Variant, ByVal second As Variant, ByVal length As Double) As Object
    ' A circle seen face-on whose diameter the two points are the ends of: selecting it alone makes IModelDoc2.AddDimension2 add a diameter dimension.
    Dim record As Object, centre As Variant
2935     For Each record In records
2936         If record("kind") = "circle" Then
2937             If record("faceOn") = 1 Then
2938                 centre = record("a")
2939                 If Abs(2# * CDbl(record("radius")) - length) <= 0.000001 And Abs(CDbl(centre(0)) - (first(0) + second(0)) / 2#) <= 0.000001 _
                   And Abs(CDbl(centre(1)) - (first(1) + second(1)) / 2#) <= 0.000001 Then
2941                     Set PlanDiameter = CloneRecord(record, "drawing-dimension-circle-diameter")
2942                     Exit Function
                End If
            End If
        End If
    Next record
End Function

Private Function PlanLine(ByVal records As Collection, ByVal point As Variant, ByVal ux As Double, ByVal uy As Double) As Object
    ' A line through the point that is perpendicular to the measuring direction.
    Dim record As Object, a As Variant, b As Variant, runX As Double, runY As Double, size As Double, along As Double, off As Double
2952     For Each record In records
2953         If record("kind") = "line" Then
2954             a = record("a")
2955             b = record("b")
2956             runX = b(0) - a(0)
2957             runY = b(1) - a(1)
2958             size = Sqr(runX * runX + runY * runY)
2959             If size > 0.000000001 Then
2960                 If Abs(runX * ux + runY * uy) <= 0.000001 * size Then
2961                     along = ((point(0) - a(0)) * runX + (point(1) - a(1)) * runY) / (size * size)
2962                     off = Abs((point(0) - a(0)) * runY - (point(1) - a(1)) * runX) / size
2963                     If along >= -0.000000001 And along <= 1.000000001 And off <= 0.000001 Then
2964                         Set PlanLine = record
2965                         Exit Function
                    End If
                End If
            End If
        End If
    Next record
End Function

Private Function PlanReference(ByVal records As Collection, ByVal point As Variant, ByVal ux As Double, ByVal uy As Double) As Object
    ' A circle centered on the point, else a line through it that is perpendicular to the measuring direction (D05a's own choice, tried first).
    Dim record As Object
2976     For Each record In records
2977         If record("kind") = "circle" Then
2978             If NearFlat(record("a"), point) Then
2979                 Set PlanReference = record
2980                 Exit Function
            End If
        End If
    Next record
2984     Set PlanReference = PlanLine(records, point, ux, uy)
End Function

Private Function PlanRim(ByVal records As Collection, ByVal point As Variant, ByVal ux As Double, ByVal uy As Double) As Object
    ' A circle seen edge-on (its axis known to lie across the view) is the straight line through its center, 2 x radius long, perpendicular to its axis: it
    ' is a reference when the point is on that line and the measuring direction is the axis's own.
    Dim record As Object, axisFlat As Variant, centre As Variant, runX As Double, runY As Double
2991     For Each record In records
2992         If record("kind") = "circle" Then
2993             If record("faceOn") = 0 Then
2994                 centre = record("a")
2995                 axisFlat = record("flatAxis")
2996                 runX = point(0) - centre(0)
2997                 runY = point(1) - centre(1)
2998                 If Abs(-axisFlat(1) * ux + axisFlat(0) * uy) <= 0.000001 And Abs(runX * axisFlat(0) + runY * axisFlat(1)) <= 0.000001 _
                   And Abs(-runX * axisFlat(1) + runY * axisFlat(0)) <= CDbl(record("radius")) + 0.000000001 Then
3000                     Set PlanRim = CloneRecord(record, "drawing-dimension-edge-on-circles")
3001                     Exit Function
                End If
            End If
        End If
    Next record
End Function

Private Function DimensionPlan(ByVal records As Collection, ByVal first As Variant, ByVal second As Variant) As Collection
    ' The one or two edges whose selection makes SolidWorks measure the distance between two flattened points, or Nothing when the view cannot show
    ' it. D05a's own plan (a line, or two references) is tried first; the diameter and edge-on forms only when it finds nothing.
    Dim lineRecord As Object, one As Object, two As Object, dx As Double, dy As Double, length As Double
3012     dx = second(0) - first(0)
3013     dy = second(1) - first(1)
3014     length = Sqr(dx * dx + dy * dy)
3015     If length < 0.000000001 Then Err.Raise 5, , "The two dimension points coincide in the view"
3016     Set lineRecord = PlanSingle(records, first, second)
3017     If Not lineRecord Is Nothing Then
3018         Set DimensionPlan = New Collection
    stepLabel = currentIdentity & ": DimensionPlan Add"
3020         DimensionPlan.Add lineRecord
3021         Exit Function
    End If
3023     Set one = PlanReference(records, first, dx / length, dy / length)
3024     Set two = PlanReference(records, second, dx / length, dy / length)
3025     If Not one Is Nothing And Not two Is Nothing Then
3026         If Not one Is two Then
3027             Set DimensionPlan = New Collection
    stepLabel = currentIdentity & ": DimensionPlan Add"
3029             DimensionPlan.Add one
    stepLabel = currentIdentity & ": DimensionPlan Add"
3031             DimensionPlan.Add two
3032             Exit Function
        End If
    End If
3035     Set lineRecord = PlanDiameter(records, first, second, length)
3036     If Not lineRecord Is Nothing Then
3037         Set DimensionPlan = New Collection
    stepLabel = currentIdentity & ": DimensionPlan Add"
3039         DimensionPlan.Add lineRecord
3040         Exit Function
    End If
3042     Set one = PlanRim(records, first, dx / length, dy / length)
3043     Set two = PlanRim(records, second, dx / length, dy / length)
3044     If one Is Nothing And two Is Nothing Then Exit Function
3045     If one Is Nothing Then Set one = PlanReference(records, first, dx / length, dy / length)
3046     If two Is Nothing Then Set two = PlanReference(records, second, dx / length, dy / length)
3047     If one Is Nothing Or two Is Nothing Then Exit Function
3048     If one("entity") Is two("entity") Then Exit Function
3049     Set DimensionPlan = New Collection
    stepLabel = currentIdentity & ": DimensionPlan Add"
3051     DimensionPlan.Add one
    stepLabel = currentIdentity & ": DimensionPlan Add"
3053     DimensionPlan.Add two
End Function

Private Function TryPick(ByVal entity As Object, ByVal appendSelection As Boolean) As Boolean
3057     On Error GoTo Failed
3058     Pick entity, appendSelection, 0
3059     TryPick = True
3060     Exit Function
Failed:
3062     TryPick = False
End Function

Private Function AddDrawingDimension(ByVal view As Object, ByVal plan As Collection, ByVal textX As Double, ByVal textY As Double, ByVal expectedMm As Double, ByVal label As String) As Double
    ' Select the planned edges in the view, add the dimension, and read its value back.
    Dim record As Object, i As Long, selected As Long, display As Object, measured As Double, kinds As String
3068     For Each record In plan
3069         If Len(kinds) > 0 Then kinds = kinds & "+"
3070         kinds = kinds & CStr(record("kind"))
    Next record
    stepLabel = currentIdentity & ": AddDrawingDimension GetName2"
3073     callInputs = label & " view=" & view.GetName2() & " edges=" & kinds & " text(m)=" & NumberList(Array(textX, textY)) & " expected(mm)=" & NumberList(Array(expectedMm))
    stepLabel = currentIdentity & ": AddDrawingDimension ActivateView"
3075     If Not drawingInterface.ActivateView(view.GetName2()) Then Err.Raise 5, , "ActivateView failed: " & callInputs
    stepLabel = currentIdentity & ": AddDrawingDimension ClearSelection2"
3077     doc.ClearSelection2 True
3078     Set pickView = view
3079     i = 0
3080     For Each record In plan
3081         If Not TryPick(record("entity"), i > 0) Then
3082             RecordMitigation "drawing-select-entity-via-view", True, True
    stepLabel = currentIdentity & ": AddDrawingDimension SelectEntity" & " " & apiInputs & " " & callInputs
3084             If Not view.SelectEntity(record("entity"), i > 0) Then Err.Raise 5, , "IView.SelectEntity failed after the Select4 selection failed: " & callInputs
3085             fallbackSuccesses("drawing-select-entity-via-view") = fallbackSuccesses("drawing-select-entity-via-view") + 1
        End If
3087         i = i + 1
    Next record
3089     Set pickView = Nothing
    stepLabel = currentIdentity & ": AddDrawingDimension GetSelectedObjectCount2"
3091     selected = doc.SelectionManager.GetSelectedObjectCount2(-1)
    stepLabel = currentIdentity & ": AddDrawingDimension Count"
3093     If selected <> plan.Count Then Err.Raise 5, , CStr(selected) & " edges are selected, not " & CStr(plan.Count) & ": " & callInputs
    stepLabel = currentIdentity & ": AddDrawingDimension AddDimension2"
3095     Set display = doc.AddDimension2(textX, textY, 0#)
3096     Require display, "AddDimension2 returned no dimension: " & callInputs
    stepLabel = currentIdentity & ": AddDrawingDimension GetDimension2"
3098     Set dimensionValue = display.GetDimension2(0)
3099     Require dimensionValue, "The new dimension has no value object: " & callInputs
    stepLabel = currentIdentity & ": AddDrawingDimension SystemValue"
3101     measured = dimensionValue.SystemValue / 0.001
3102     If Abs(measured - expectedMm) > 0.000001 Then Err.Raise 5, , "The drawing dimension measured " & NumberList(Array(measured)) & " mm, not " & NumberList(Array(expectedMm)) & " mm: " & callInputs
    stepLabel = currentIdentity & ": AddDrawingDimension ClearSelection2"
3104     doc.ClearSelection2 True
3105     AddDrawingDimension = measured
End Function

Private Function DrawingReadBack(ByVal expected As Variant) As String
    ' Every display dimension in the drawing, read from the drawing, must be exactly the recipe's values.
    Dim seen As Object, view As Object, display As Object, key As String, listing As String, i As Long
3111     Set seen = CreateObject("Scripting.Dictionary")
    stepLabel = currentIdentity & ": DrawingReadBack GetFirstView"
3113     Set view = drawingInterface.GetFirstView()
3114     Do While Not view Is Nothing
    stepLabel = currentIdentity & ": DrawingReadBack GetFirstDisplayDimension5"
3116         Set display = view.GetFirstDisplayDimension5()
3117         Do While Not display Is Nothing
    stepLabel = currentIdentity & ": DrawingReadBack GetDimension2"
3119             key = CStr(Round(display.GetDimension2(0).SystemValue * 1000#, 4))
3120             If Len(listing) > 0 Then listing = listing & ", "
    stepLabel = currentIdentity & ": DrawingReadBack GetName2"
3122             listing = listing & view.GetName2() & " " & key & " mm"
    stepLabel = currentIdentity & ": DrawingReadBack Exists"
3124             If seen.Exists(key) Then
3125                 seen(key) = seen(key) + 1
            Else
    stepLabel = currentIdentity & ": DrawingReadBack Add"
3128                 seen.Add key, 1
            End If
    stepLabel = currentIdentity & ": DrawingReadBack GetNext3"
3131             Set display = display.GetNext3()
        Loop
    stepLabel = currentIdentity & ": DrawingReadBack GetNextView"
3134         Set view = view.GetNextView()
    Loop
3136     For i = LBound(expected) To UBound(expected)
3137         key = CStr(Round(CDbl(expected(i)), 4))
    stepLabel = currentIdentity & ": DrawingReadBack Exists"
3139         If Not seen.Exists(key) Then Err.Raise 5, , "The drawing is missing the dimension " & key & " mm; it holds: " & listing
3140         If seen(key) = 1 Then
    stepLabel = currentIdentity & ": DrawingReadBack Remove"
3142             seen.Remove key
        Else
3144             seen(key) = seen(key) - 1
        End If
    Next i
    stepLabel = currentIdentity & ": DrawingReadBack Count"
3148     If seen.Count > 0 Then Err.Raise 5, , "The drawing holds more dimensions than the recipe's: " & listing
3149     DrawingReadBack = listing
End Function

Private Sub ExportDrawing(ByVal path As String)
    ' A copy of the sheet as DXF (R2000, which the recipe allows); the file must exist and hold data.
    Dim previous As Long, fs As Object, failureNumber As Long, failure As String, failingStep As String
    stepLabel = currentIdentity & ": ExportDrawing GetUserPreferenceIntegerValue"
3156     previous = app.GetUserPreferenceIntegerValue(swDxfVersion)
    stepLabel = currentIdentity & ": ExportDrawing SetUserPreferenceIntegerValue"
3158     If Not app.SetUserPreferenceIntegerValue(swDxfVersion, swDxfFormat_R2000) Then Err.Raise 5, , "Cannot set the DXF version"
3159     On Error Resume Next
    stepLabel = currentIdentity & ": ExportDrawing GetUserPreferenceIntegerValue"
3161     If app.GetUserPreferenceIntegerValue(swDxfVersion) <> swDxfFormat_R2000 Then Err.Raise 5, , "The DXF version did not stay at R2000"
3162     If Err.Number = 0 Then SaveFile path
3163     failureNumber = Err.Number
3164     failure = Err.Description
3165     failingStep = stepLabel
3166     Err.Clear
    stepLabel = currentIdentity & ": ExportDrawing SetUserPreferenceIntegerValue"
3168     app.SetUserPreferenceIntegerValue swDxfVersion, previous
3169     stepLabel = failingStep
3170     On Error GoTo 0
3171     If failureNumber <> 0 Then Err.Raise failureNumber, , failure
3172     stepLabel = currentIdentity & ": DXF file check"
3173     Set fs = CreateObject("Scripting.FileSystemObject")
    stepLabel = currentIdentity & ": ExportDrawing FileExists"
3175     If Not fs.FileExists(path) Then Err.Raise 5, , "The DXF export wrote no file"
    stepLabel = currentIdentity & ": ExportDrawing GetFile"
3177     If fs.GetFile(path).Size = 0 Then Err.Raise 5, , "The DXF export wrote an empty file"
    stepLabel = currentIdentity & ": ExportDrawing GetFileName"
3179     AppendLog currentFolder, currentIdentity, "option", 0, 0, "drawing DXF: " & fs.GetFileName(path) & ", " & CStr(fs.GetFile(path).Size) & " bytes, DXF version R2000 (3), previous setting " & CStr(previous) & " restored; scale and text options left at the user defaults (the interop does not say what their values mean)"
End Sub
