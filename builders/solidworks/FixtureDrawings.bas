Attribute VB_Name = "FixtureDrawings"
Option Explicit
' SolidWorks 2018+. Tools > Macro > New, import this .bas, run main. Optional second macro: it draws the parts an earlier Fixture Builder run left in a folder.
' Fixture Drawings version 2026.11.27.3 (the drawings package). It opens the parts read-only and never writes into that folder.
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
' Fixture Builder version 2026.11.27.3 (sheet metal, expect.json checks, round 5).
Private Const BUILDER_VERSION As String = "2026.11.27.3"
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
Private privateRun As Boolean
Private privateKept As Boolean
Private privateCount As Long
Private privateIds As String
Private privateStuck As String
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
    Dim noticeNote As String, sweepNotes As String, zipError As String, swept As Boolean, descendNote As String, personalNote As String, chosenFolder As String, hideNames As Boolean
119     On Error GoTo Fatal
120     currentIdentity = "setup"
    ' First of all, before SolidWorks is touched or a folder made: the output root (the builder's, in Public\Documents unless the settings say
    ' otherwise) must carry no personal path; the run folder is checked next, then the drawing template.
123     target = PackageOutputRoot()
124     finalMessage = PersonalPathReason(target)
125     If Len(finalMessage) > 0 Then GoTo Cleanup
    stepLabel = currentIdentity & ": main SldWorks"
127     Set app = Application.SldWorks
128     Set fs = CreateObject("Scripting.FileSystemObject")
129     runFolder = PackageNewestRun(target)
130     If Not IsUnattended() Then
131         runFolder = InputBox("Folder of an earlier Fixture Builder run (the one that holds the .sldprt files; it must be in a neutral folder, as the builder 2026.11.25.3 or later makes). The drawings go into a new folder in the builder's output folder; nothing in the run folder is changed.", "Dutchman Fixtures", runFolder)
    End If
133     runFolder = Trim$(runFolder)
134     Do While Len(runFolder) > 3 And Right$(runFolder, 1) = "\"
135         runFolder = Left$(runFolder, Len(runFolder) - 1)
    Loop
137     If Len(runFolder) = 0 Then
138         If Not IsUnattended() Then MsgBox "No folder was chosen, so nothing was drawn.", vbInformation, "SolidWorks fixtures"
139         Exit Sub
    End If
    ' Only a folder that is not a full path with a drive letter is refused here; a personal one is asked about below, once the folder to draw from is known.
142     finalMessage = PackageRunFolderReason(runFolder)
143     If Len(finalMessage) > 0 Then GoTo Cleanup
    stepLabel = currentIdentity & ": main FolderExists"
145     If Not fs.FolderExists(runFolder) Then
146         finalMessage = "That folder was not found, so nothing was drawn: " & runFolder
147         GoTo Cleanup
    End If
    ' A zip extracted inside a folder of its own name leaves the parts one folder down: use that folder, and check it exactly as the chosen one.
150     chosenFolder = runFolder
151     hideNames = (Len(PersonalWhy(chosenFolder, True)) > 0)
152     runFolder = PackageDescend(chosenFolder, descendNote, hideNames)
153     If Len(descendNote) > 0 Then
154         finalMessage = PackageRunFolderReason(runFolder)
155         If Len(finalMessage) > 0 Then GoTo Cleanup
        ' A personal run: no folder name in the log.
157         If Not hideNames Then
158             If Len(PersonalWhy(runFolder, True)) > 0 Then runFolder = PackageDescend(chosenFolder, descendNote, True)
        End If
    End If
    ' A part keeps its own save path and a drawing keeps the part's: a run in a personal folder puts that path into every drawing. One OK/Cancel box
    ' says which rule fired; OK draws (the output stays in the neutral root and private), Cancel draws nothing.
163     finalMessage = PackageRunFolderNotice(runFolder, personalNote)
164     If Len(finalMessage) > 0 Then GoTo Cleanup
165     finalMessage = PackageTemplateRefusal()
166     If Len(finalMessage) > 0 Then GoTo Cleanup
    ' The up-front notice, once per run: Cancel draws nothing.
168     noticeNote = NoticeStep(False)
169     If Len(noticeNote) = 0 Then
170         finalMessage = "Canceled at the user name notice. Nothing was drawn."
171         GoTo Cleanup
    End If
173     For i = 2 To 5
174         rbStatus(i) = ""
    Next i
176     sweepEmptied = ""
177     privateRun = (InStr(personalNote, "drawing anyway on OK") > 0)
178     privateKept = False
179     privateCount = 0
180     privateIds = ""
181     privateStuck = ""
182     sweepEmptiedCount = 0
183     sweepListFailed = False
184     sweepAnsiSkipped = False
185     packageFolder = runFolder
    stepLabel = currentIdentity & ": main GetUserPreferenceToggle"
187     oldInput = app.GetUserPreferenceToggle(swInputDimValOnCreate)
188     inputSaved = True
    stepLabel = currentIdentity & ": main SetUserPreferenceToggle"
190     app.SetUserPreferenceToggle swInputDimValOnCreate, False
    stepLabel = currentIdentity & ": main GetUserPreferenceToggle"
192     oldRebuild = app.GetUserPreferenceToggle(swShowErrorsEveryRebuild)
193     rebuildSaved = True
    stepLabel = currentIdentity & ": main SetUserPreferenceToggle"
195     app.SetUserPreferenceToggle swShowErrorsEveryRebuild, False
    stepLabel = currentIdentity & ": main GetUserPreferenceToggle"
197     oldWarn = app.GetUserPreferenceToggle(swWarnSaveUpdateErrors)
198     warnSaved = True
    stepLabel = currentIdentity & ": main SetUserPreferenceToggle"
200     app.SetUserPreferenceToggle swWarnSaveUpdateErrors, False
    stepLabel = currentIdentity & ": main GetUserPreferenceIntegerValue"
202     oldAction = app.GetUserPreferenceIntegerValue(swRebuildErrorAction)
203     actionSaved = True
    stepLabel = currentIdentity & ": main SetUserPreferenceIntegerValue"
205     If Not app.SetUserPreferenceIntegerValue(swRebuildErrorAction, swContinueResponse_Stop) Then Err.Raise 5, , "Cannot disable rebuild prompt"
    stepLabel = currentIdentity & ": main RevisionNumber"
207     revision = app.RevisionNumber()
208     pieces = Split(revision, ".")
209     swMajor = CLng(pieces(0))
210     version = CStr(CLng(pieces(0)) + 1992)
211     build = "0"
212     If UBound(pieces) > 0 Then
213         build = pieces(1)
214         For i = 2 To UBound(pieces)
215             build = build & "-" & pieces(i)
        Next i
    End If
    ' Always a NEW folder in the output root: FixtureDrawings-SolidWorks-<version>, then -2, -3 ... Never deleted or reused.
219     EnsureFolder fs, target
220     outName = "FixtureDrawings-SolidWorks-" & BUILDER_VERSION
    stepLabel = currentIdentity & ": main BuildPath"
222     folder = fs.BuildPath(target, outName)
223     attempt = 1
    stepLabel = currentIdentity & ": main FolderExists"
225     Do While fs.FolderExists(folder) Or fs.FileExists(folder & ".zip")
226         attempt = attempt + 1
227         outName = "FixtureDrawings-SolidWorks-" & BUILDER_VERSION & "-" & CStr(attempt)
    stepLabel = currentIdentity & ": main BuildPath"
229         folder = fs.BuildPath(target, outName)
    Loop
    stepLabel = currentIdentity & ": main CreateFolder" & " " & apiInputs & " " & callInputs
232     fs.CreateFolder folder
233     resultRows = ""
    stepLabel = currentIdentity & ": main BuildPath"
235     WriteUtf8 fs.BuildPath(folder, "results.json"), "[]"
    stepLabel = currentIdentity & ": main GetFileName"
237     AppendLog folder, "setup", "Fixture Drawings " & BUILDER_VERSION, 0, 0, "SolidWorks revision " & revision & "; run folder " & IIf(Len(personalNote) > 0, "(personal, name not logged)", fs.GetFileName(runFolder)) & "; output folder " & outName & "; personal-path check: passed (" & PackageCheckScope(personalNote) & ")"
238     AppendLog folder, "setup", "template path", 0, 0, "template path: neutral"
239     If Len(descendNote) > 0 Then AppendLog folder, "setup", "option", 0, 0, descendNote
240     If Len(personalNote) > 0 Then AppendLog folder, "setup", "option", 0, 0, personalNote
241     AppendLog folder, "setup", "user name notice", 0, 0, noticeNote
242     For i = 0 To PackageCount() - 1
243         RunPackage i, folder, version, build, CLng(pieces(0))
    Next i
    ' Once per run: what the folder holds (counts and file names only), so a wrong folder shows.
246     If CountStatus("skipped") > 0 Then AppendLog folder, "setup", "option", 0, 0, PackageHoldsText(runFolder)
247     AppendLog folder, "setup", "summary", 0, 0, "summary: ok=" & CStr(CountStatus("ok")) & " failed=" & CStr(CountStatus("failed")) & _
        " not_scripted=" & CStr(CountStatus("not_scripted")) & " skipped=" & CStr(CountStatus("skipped"))
249     AppendLog folder, "setup", "summary info", 0, 0, ReadbackText()
250     AppendLog folder, "setup", "summary info", 0, 0, "SolidWorks stamps the saving user in each file: not removable by the API"
251     AppendLog folder, "setup", "summary info", 0, 0, "SolidWorks also records its Windows temp folder (under your user profile) in each native file; we keep native files private and publish only STEP and files we've checked clean."
    ' Before the zip: every file in the output folder, listed or not, is scrubbed (see PrivacySweep).
253     swept = True
254     sweepNotes = PrivacySweep(folder)
255     If Len(sweepNotes) > 0 Then AppendLog folder, "setup", "privacy sweep", 0, 0, sweepNotes
256     zipMade = False
257     If Not sweepListFailed And Len(privateStuck) = 0 Then zipMade = MakeZip(folder)        ' a folder that could not be checked, or that still holds a private file, is never zipped
258     zipError = folder & "-zip-error.txt"
    stepLabel = currentIdentity & ": main FileExists"
260     If fs.FileExists(zipError) Then SweepFile fs, zipError, sweepNotes
261     If zipMade Then SaveSetting "DutchmanFixtures", "SolidWorksBuilder", "LastZip", folder & ".zip"
262     finishText = FinishMessage(CountStatus("ok") + CountStatus("failed") + CountStatus("not_scripted") + CountStatus("skipped"), _
        CountStatus("ok"), CountStatus("failed"), CountStatus("not_scripted"), CountStatus("skipped"), folder & ".zip", zipMade, folder)
264     AppendLog folder, "setup", "finish", 0, 0, finishText
265     GoTo Cleanup
Fatal:
    fatalLine = Erl: fatalNumber = Err.Number: fatalDescription = Err.Description: fatalStep = stepLabel
268     finalMessage = fatalStep & " (line " & CStr(fatalLine) & "): " & fatalDescription
269     On Error Resume Next
270     swept = False        ' an error after the sweep (in the zip step) is swept again on the way out
271     If Len(folder) > 0 Then AppendLog folder, currentIdentity, fatalStep, fatalLine, fatalNumber, fatalDescription
272     Resume Cleanup
Cleanup:
274     On Error Resume Next
275     Err.Clear
    ' Every way out of main passes here: the folder is swept once, so an error part way leaves no unswept text file.
277     If Len(folder) > 0 And Not swept Then
278         swept = True
279         sweepNotes = PrivacySweep(folder)
280         If Len(sweepNotes) > 0 Then AppendLog folder, "setup", "privacy sweep", 0, 0, sweepNotes
    End If
282     Err.Clear
    stepLabel = currentIdentity & ": main SetUserPreferenceIntegerValue"
284     If actionSaved Then app.SetUserPreferenceIntegerValue swRebuildErrorAction, oldAction
285     If Err.Number <> 0 Then ReportCleanupError folder, finalMessage
286     Err.Clear
    stepLabel = currentIdentity & ": main SetUserPreferenceToggle"
288     If warnSaved Then app.SetUserPreferenceToggle swWarnSaveUpdateErrors, oldWarn
289     If Err.Number <> 0 Then ReportCleanupError folder, finalMessage
290     Err.Clear
    stepLabel = currentIdentity & ": main SetUserPreferenceToggle"
292     If rebuildSaved Then app.SetUserPreferenceToggle swShowErrorsEveryRebuild, oldRebuild
293     If Err.Number <> 0 Then ReportCleanupError folder, finalMessage
294     Err.Clear
    stepLabel = currentIdentity & ": main SetUserPreferenceToggle"
296     If inputSaved Then app.SetUserPreferenceToggle swInputDimValOnCreate, oldInput
297     If Err.Number <> 0 Then ReportCleanupError folder, finalMessage
298     Err.Clear
    ' FIXTURE_UNATTENDED=1: no Explorer window and no message box, only the log line written above.
300     If Len(finalMessage) > 0 Then
301         If Not IsUnattended() Then MsgBox PrivacyScrub(finalMessage), vbExclamation, "SolidWorks fixtures"
    ElseIf Len(finishText) > 0 And Not IsUnattended() Then
303         If zipMade Then
    stepLabel = currentIdentity & ": main Run"
305             CreateObject("WScript.Shell").Run "explorer.exe /select,""" & folder & ".zip""", 1, False
        Else
    stepLabel = currentIdentity & ": main Run"
308             CreateObject("WScript.Shell").Run "explorer.exe """ & folder & """", 1, False
        End If
310         Err.Clear
311         MsgBox PrivacyScrub(finishText), vbInformation, "SolidWorks fixtures"
    End If
End Sub

Private Function PackageOutputRoot() As String
    ' The builder's output root: OUTPUT_FOLDER when it is set, else the launcher's OutputRoot setting, else the neutral default
    ' (Public\Documents\FixtureBuilder). The old Documents\FixtureBuilder is never looked in: it is a personal folder.
    Dim rootFolder As String
319     rootFolder = OUTPUT_FOLDER
320     If Len(rootFolder) = 0 Then rootFolder = GetSetting("DutchmanFixtures", "SolidWorksBuilder", "OutputRoot", "")
321     If Len(rootFolder) = 0 Then rootFolder = DefaultOutputRoot()
322     PackageOutputRoot = rootFolder
End Function

Private Function PackageRunFolderReason(ByVal runFolder As String) As String
    ' "" unless the run folder is not a full path starting with a drive letter, which is refused. A personal run folder is asked about instead
    ' (PackageRunFolderNotice). The text never repeats the folder.
328     If Not DriveRooted(runFolder) Then
329         PackageRunFolderReason = "The run folder was refused because the folder must be a full path starting with a drive letter. Nothing was drawn."
    End If
End Function

Private Function PackageRunFolderNotice(ByVal runFolder As String, ByRef note As String) As String
    ' "" to go on, else the message that nothing was drawn. note is the option line for the log ("" when the run folder is not personal): the rule
    ' PersonalWhy gives, never the path. One OK/Cancel box; an unattended run is not asked and draws nothing.
    Dim why As String
337     note = ""
338     why = PersonalWhy(runFolder, True)
339     If Len(why) = 0 Then Exit Function
340     If IsUnattended() Then
341         note = "run folder: personal (" & why & "); cancelled (unattended run, not asked)"
    ElseIf MsgBox("The run folder looks personal: " & why & ". Drawings store their part's full path, so these drawings would carry it. If you press OK they are drawn and kept private (not published). Press Cancel to draw nothing.", vbOKCancel + vbInformation, "SolidWorks fixtures") = vbOK Then
343         note = "run folder: personal (" & why & "); drawing anyway on OK"
344         Exit Function
    Else
346         note = "run folder: personal (" & why & "); cancelled"
    End If
348     PackageRunFolderNotice = "Canceled at the run folder notice (" & note & "). Nothing was drawn."
End Function

Private Function PackageCheckScope(ByVal personalNote As String) As String
    ' What the setup line says was checked and passed.
353     PackageCheckScope = "output folder and run folder"
354     If Len(personalNote) > 0 Then PackageCheckScope = "output folder; the run folder is personal, see its option line"
End Function

Private Function PackageModelName() As String
    ' The assembly's own name (its file name without the extension): the one prefix a component name may carry and still be top-level.
    Dim fs As Object
360     Set fs = CreateObject("Scripting.FileSystemObject")
    stepLabel = currentIdentity & ": PackageModelName GetBaseName"
362     PackageModelName = fs.GetBaseName(packagePart)
End Function

Private Function PackageModelFiles() As Variant
    ' The model file names the drawings need, one each (a model two drawings share counts once).
    Dim names() As String, total As Long, i As Long, k As Long, fileName As String, seen As Boolean
368     ReDim names(0 To PackageCount() - 1)
369     For i = 0 To PackageCount() - 1
370         fileName = PackageModel(i) & PackageExtension(i)
371         seen = False
372         For k = 0 To total - 1
373             If names(k) = fileName Then seen = True
        Next k
375         If Not seen Then
376             names(total) = fileName
377             total = total + 1
        End If
    Next i
380     ReDim Preserve names(0 To total - 1)
381     PackageModelFiles = names
End Function

Private Function PackageHeldCount(ByVal folderPath As String) As Long
    ' How many of the model files the drawings need are in the folder (FileExists ignores case).
    Dim fs As Object, names As Variant, i As Long
387     Set fs = CreateObject("Scripting.FileSystemObject")
388     names = PackageModelFiles()
389     For i = 0 To UBound(names)
    stepLabel = currentIdentity & ": PackageHeldCount FileExists"
391         If fs.FileExists(folderPath & "\" & CStr(names(i))) Then PackageHeldCount = PackageHeldCount + 1
    Next i
End Function

Private Function PackageDescend(ByVal runFolder As String, ByRef note As String, ByVal hide As Boolean) As String
    ' A zip extracted inside a folder of its own name leaves the parts one folder down. When the chosen folder holds none of the model files and exactly
    ' one folder named like it (or FixtureBuilder-SolidWorks-*) that holds some, that folder is used. One level only; a folder that holds parts is never
    ' descended from. The note names folders by name only.
    Dim fs As Object, child As Object, found As Object, matches As Long, ownName As String, shownOwn As String, shownInner As String
400     note = ""
401     PackageDescend = runFolder
402     If PackageHeldCount(runFolder) > 0 Then Exit Function
403     Set fs = CreateObject("Scripting.FileSystemObject")
    stepLabel = currentIdentity & ": PackageDescend GetFileName"
405     ownName = fs.GetFileName(runFolder)
    stepLabel = currentIdentity & ": PackageDescend GetFolder"
407     For Each child In fs.GetFolder(runFolder).SubFolders
        ' A junction or symbolic link (a reparse point) is never descended into.
    stepLabel = currentIdentity & ": PackageDescend Attributes"
410         If (child.Attributes And 1024) = 0 And (StrComp(child.Name, ownName, vbTextCompare) = 0 Or InStr(1, child.Name, "FixtureBuilder-SolidWorks-", vbTextCompare) = 1) Then
411             matches = matches + 1
412             Set found = child
        End If
    Next child
415     If matches <> 1 Then Exit Function
    stepLabel = currentIdentity & ": PackageDescend Path"
417     If PackageHeldCount(found.Path) = 0 Then Exit Function
418     shownOwn = ownName
    stepLabel = currentIdentity & ": PackageDescend Name"
420     shownInner = found.Name
421     If hide Then
422         shownOwn = "(personal, name not logged)"
423         shownInner = "(personal, name not logged)"
    End If
    stepLabel = currentIdentity & ": PackageDescend Name"
426     If StrComp(found.Name, ownName, vbTextCompare) = 0 Then
427         note = "run folder: " & shownOwn & " holds no part files but one folder of the same name that does (a zip extracted inside a folder of its own name); drawing from that folder"
    Else
429         note = "run folder: " & shownOwn & " holds no part files but one folder, " & shownInner & ", that does (a zip extracted inside another folder); drawing from that folder"
    End If
    stepLabel = currentIdentity & ": PackageDescend Path"
432     PackageDescend = found.Path
End Function

Private Function PackageHoldsText(ByVal folderPath As String) As String
    ' What the run folder holds, in counts and model file names only (never a path), for a run with a skipped drawing.
    Dim fs As Object, held As String, wanted As String, heldCount As Long, i As Long, fileName As String, names As Variant
    Dim folderCount As Long, otherCount As Long, shown As String, folderNoun As String, fileNoun As String
439     Set fs = CreateObject("Scripting.FileSystemObject")
440     names = PackageModelFiles()
441     For i = 0 To UBound(names)
442         fileName = CStr(names(i))
    stepLabel = currentIdentity & ": PackageHoldsText FileExists"
444         If fs.FileExists(folderPath & "\" & fileName) Then
445             heldCount = heldCount + 1
446             If Len(held) > 0 Then held = held & ", "
447             held = held & fileName
        End If
449         If i < 2 Then wanted = wanted & fileName & ", "
    Next i
451     shown = held
452     If heldCount = 0 Then shown = wanted & "..."
    stepLabel = currentIdentity & ": PackageHoldsText GetFolder"
454     folderCount = fs.GetFolder(folderPath).SubFolders.Count
    stepLabel = currentIdentity & ": PackageHoldsText GetFolder"
456     otherCount = fs.GetFolder(folderPath).Files.Count - heldCount
457     folderNoun = " folders"
458     If folderCount = 1 Then folderNoun = " folder"
459     fileNoun = " other files"
460     If otherCount = 1 Then fileNoun = " other file"
461     PackageHoldsText = "run folder holds " & CStr(heldCount) & " of the " & CStr(UBound(names) + 1) & " model files (" & shown & "); it holds " & CStr(folderCount) & folderNoun & " and " & CStr(otherCount) & fileNoun
End Function

Private Function PackageTemplateRefusal() As String
    ' The drawing template is the only one the package uses (a drawing keeps the path of its template and sheet format).
    Dim path As String
467     On Error Resume Next
468     path = ResolveTemplate("drawing")
469     Err.Clear
470     On Error GoTo 0
471     If Len(path) > 0 Then PackageTemplateRefusal = PersonalTemplateReason("drawing", path)
End Function

Private Function PackageNewestRun(ByVal rootFolder As String) As String
    ' The newest FixtureBuilder-SolidWorks-* folder under the (neutral) output root ("" when there is none).
    Dim fs As Object, candidate As Object, best As Object
477     Set fs = CreateObject("Scripting.FileSystemObject")
    stepLabel = currentIdentity & ": PackageNewestRun FolderExists"
479     If Not fs.FolderExists(rootFolder) Then Exit Function
    stepLabel = currentIdentity & ": PackageNewestRun GetFolder"
481     For Each candidate In fs.GetFolder(rootFolder).SubFolders
    stepLabel = currentIdentity & ": PackageNewestRun Name"
483         If InStr(1, candidate.Name, "FixtureBuilder-SolidWorks-", vbTextCompare) = 1 Then
484             If best Is Nothing Then
485                 Set best = candidate
            ElseIf candidate.DateLastModified > best.DateLastModified Then
487                 Set best = candidate
            End If
        End If
    Next candidate
    stepLabel = currentIdentity & ": PackageNewestRun Path"
492     If Not best Is Nothing Then PackageNewestRun = best.Path
End Function

Private Function FinishMessage(ByVal total As Long, ByVal made As Long, ByVal failed As Long, ByVal notScripted As Long, ByVal skipped As Long, ByVal zipPath As String, ByVal zipMade As Boolean, ByVal folder As String) As String
    Dim noun As String, counts As String, fs As Object
497     Set fs = CreateObject("Scripting.FileSystemObject")
498     noun = "drawings"
499     If total = 1 Then noun = "drawing"
500     counts = CStr(total) & " " & noun & ": " & CStr(made) & " made, " & CStr(failed) & " failed, " & CStr(notScripted) & _
        " not scripted, " & CStr(skipped) & " skipped (details in FixtureDrawings.log)." & EmptiedLine()
502     If privateCount > 0 Then
    stepLabel = currentIdentity & ": FinishMessage GetBaseName"
504         counts = counts & vbLf & CStr(privateCount) & IIf(privateCount = 1, " drawing", " drawings") & " (" & privateIds & ") " & IIf(privateCount = 1, "is", "are") & " in the folder " & fs.GetBaseName(zipPath) & "-private, in the shared Public Documents folder, which other users of this computer can read; " & _
            IIf(privateCount = 1, "it is", "they are") & " not in the zip and not published. " & IIf(privateCount = 1, "It carries", "They carry") & " a personal name or path (the run folder is personal, as you agreed)."
    End If
507     counts = counts & vbLf & "The drawings package reads the builder run folder, so keep that folder."
508     If Len(privateStuck) > 0 Then
509         FinishMessage = counts & vbLf & "The zip was not made because these private files could not be moved out of the output folder or removed: " & privateStuck & "; nothing was sent."
    ElseIf sweepListFailed Then
511         FinishMessage = counts & vbLf & "The zip was not made because the output folder could not be checked; nothing was sent."
    ElseIf zipMade And privateCount > 0 And made = privateCount Then
513         FinishMessage = counts & vbLf & "Nothing else needs posting: the zip holds only results.json and the log, which hold no path, and it is the only file to send:" & vbLf & zipPath
    ElseIf zipMade Then
515         FinishMessage = counts & vbLf & "Next: post this zip in your builder thread, or send it to Dutchy in a Discord direct message:" & vbLf & zipPath
    Else
517         FinishMessage = counts & vbLf & "The zip could not be made (the reason is in FixtureDrawings.log and " & folder & "-zip-error.txt)." & vbLf & _
            "Next: right-click this folder, choose Send to > Compressed (zipped) folder, and post that zip in your builder thread or send it to Dutchy in a Discord direct message:" & vbLf & folder
    End If
End Function

Private Sub AppendLog(ByVal folder As String, ByVal identity As String, ByVal failedStep As String, ByVal lineNumber As Long, ByVal errorNumber As Long, ByVal description As String)
    Dim channel As Integer
524     channel = FreeFile
525     Open folder & "\FixtureDrawings.log" For Append As #channel
526     Print #channel, Format$(Now, "yyyy-mm-dd hh:nn:ss") & " builder=" & BUILDER_VERSION & " recipe=" & identity & _
        " step=" & failedStep & " Erl=" & CStr(lineNumber) & " Err.Number=" & CStr(errorNumber) & _
        " Err.Description=" & Replace(Replace(CleanError(description), vbCr, "\r"), vbLf, "\n")
529     Close #channel
End Sub

Private Sub RunPackage(ByVal index As Long, ByVal folder As String, ByVal version As String, ByVal build As String, ByVal major As Long)
    ' One companion drawing entry: skipped (not made by the builder, or its part file is not in the folder), not scripted, drawn, or failed with
    ' the step and the call inputs. A failure never stops the next entry.
    Dim identity As String, status As String, message As String, files As String, started As Double, elapsed As Double
    Dim fs As Object, title As Variant, removeFailed As String
    Dim failureLine As Long, failureNumber As Long, failureDescription As String, failureStep As String
538     On Error GoTo Failed
539     Set doc = Nothing
540     Set loadedDocs = Nothing
541     privateKept = False
542     attemptErrorsSaved = False
543     started = Timer
544     identity = PackageId(index)
545     currentIdentity = identity
546     currentFolder = folder
547     Set mitigations = CreateObject("Scripting.Dictionary")
548     Set primaryFailures = CreateObject("Scripting.Dictionary")
549     Set fallbackSuccesses = CreateObject("Scripting.Dictionary")
550     apiInputs = "": callInputs = ""
551     stepLabel = identity & ": preflight"
552     status = "failed"
553     files = "[]"
554     Set fs = CreateObject("Scripting.FileSystemObject")
555     Select Case PackageState(index)
        Case 1
557             status = "not_scripted"
558             message = PackageReason(index)
        Case Else
560             If major < 26 Then
561                 status = "not_scripted"
562                 message = "needs SolidWorks 2018+"
            ElseIf Not fs.FileExists(packageFolder & "\" & PackageModel(index) & PackageExtension(index)) Then
564                 status = "skipped"
565                 message = "the part file is not in this folder"
            Else
567                 AttemptPackage index, folder
568                 status = "ok"
569                 files = "[" & Quote(identity & ".slddrw") & "," & Quote(identity & ".pdf") & "," & Quote(identity & ".dxf") & "]"
570                 If privateRun Then
                    ' A personal run, OK pressed: EVERY drawing is private, whatever the PDF scan says (the part's path is inside the compressed .slddrw, which is never
                    ' scanned). The files go to a sibling folder, never into the zip (a failure here fails the row, which removes them).
573                     files = PackageMovePrivate(folder, identity)
574                     privateCount = privateCount + 1
575                     privateIds = privateIds & IIf(Len(privateIds) > 0, ", ", "") & identity
    stepLabel = currentIdentity & ": RunPackage GetFileName"
577                     AppendLog folder, identity, "option", 0, 0, "kept private: the run folder is personal, as agreed; moved to " & fs.GetFileName(folder) & "-private, in the shared Public Documents folder, which other users of this computer can read; not in the zip and not published"
                End If
            End If
    End Select
581     GoTo Finished
Failed:
    failureLine = Erl: failureNumber = Err.Number: failureDescription = Err.Description: failureStep = stepLabel
584     AppendLog folder, currentIdentity, failureStep, failureLine, failureNumber, failureDescription
585     message = failureStep & " (line " & CStr(failureLine) & "): " & failureDescription
586     status = "failed"
587     files = "[]"
588     Resume Finished
Finished:
590     On Error GoTo CleanupFailed
591     If Not doc Is Nothing Then
    stepLabel = currentIdentity & ": RunPackage ShowFeatureErrorDialog"
593         If attemptErrorsSaved Then doc.ShowFeatureErrorDialog = attemptOldErrors
    stepLabel = currentIdentity & ": RunPackage CloseDoc"
595         app.CloseDoc doc.GetTitle()
    End If
597     Set doc = Nothing
598     If Not loadedDocs Is Nothing Then
599         For Each title In loadedDocs
    stepLabel = currentIdentity & ": RunPackage CloseDoc"
601             app.CloseDoc CStr(title)
        Next title
    End If
604     Set loadedDocs = Nothing
    ' The drawing is closed first, so its files are not locked; a removal that fails is added after the error that led here, never in its place.
606     If status <> "ok" Then
607         removeFailed = PackageRemoveFiles(folder, identity)
608         If Len(removeFailed) > 0 Then
609             AppendLog folder, currentIdentity, "removing the files", 0, 0, removeFailed
610             If privateRun Then privateStuck = privateStuck & IIf(Len(privateStuck) > 0, ", ", "") & removeFailed         ' still in the zipped folder: no zip
611             If Len(message) > 0 Then message = message & "; then "
612             message = message & "removing the files failed: " & removeFailed
613             files = "[]"
        End If
    End If
616     On Error GoTo ReportFailed
617     elapsed = Timer - started
618     If elapsed < 0 Then elapsed = elapsed + 86400#
619     PackageRow identity, status, message, files, version, build, elapsed
620     AppendLog folder, currentIdentity, "recipe complete: " & status, 0, 0, MitigationText()
621     Exit Sub
CleanupFailed:
    failureLine = Erl: failureNumber = Err.Number: failureDescription = Err.Description: failureStep = stepLabel
624     AppendLog folder, currentIdentity, failureStep, failureLine, failureNumber, failureDescription
    ' A row that already has an error keeps it; the close failure is added after it, never in its place.
626     If Len(message) > 0 Then
627         message = message & "; then closing failed: " & failureStep & " (line " & CStr(failureLine) & "): " & failureDescription
    Else
629         message = failureStep & " (line " & CStr(failureLine) & "): " & failureDescription
    End If
631     status = "failed"
632     files = "[]"
633     Resume Next
ReportFailed:
    ' Propagate reporting failures to main's final visible error, never swallow them.
636     Err.Raise Err.Number, "RunPackage reporting", Err.Description
End Sub

Private Sub PackageRow(ByVal identity As String, ByVal status As String, ByVal message As String, ByVal files As String, ByVal version As String, ByVal build As String, ByVal elapsed As Double)
    Dim resultRow As String, priorRows As String
641     priorRows = resultRows
642     If Len(priorRows) > 0 Then priorRows = priorRows & ","
643     resultRow = "{""id"":" & Quote(identity) & ",""status"":" & Quote(status) & _
        ",""error"":" & Quote(CleanError(message)) & ",""files"":" & files & _
        ",""app"":""SolidWorks"",""version"":" & Quote(version) & _
        ",""build"":" & Quote(build) & ",""mitigations"":" & MitigationJson() & ",""seconds"":" & Replace(Format$(elapsed, "0.0000"), ",", ".") & IIf(privateKept And status = "ok", ",""private"":true", "") & "}"
647     resultRows = priorRows & resultRow
648     WriteUtf8 currentFolder & "\results.json", "[" & resultRows & "]"
End Sub

Private Function PackageMovePrivate(ByVal folder As String, ByVal identity As String) As String
    ' A private drawing's files leave the zipped output folder for the sibling folder <output folder name>-private (same neutral output root). The row's
    ' files list names them with the note that they are on this computer, not in the zip.
    Dim fs As Object, target As String, extension As Variant, listing As String
655     Set fs = CreateObject("Scripting.FileSystemObject")
656     target = folder & "-private"
    stepLabel = currentIdentity & ": PackageMovePrivate FolderExists"
658     If Not fs.FolderExists(target) Then fs.CreateFolder target
659     For Each extension In Array(".slddrw", ".pdf", ".dxf")
    stepLabel = currentIdentity & ": PackageMovePrivate FileExists"
661         If fs.FileExists(fs.BuildPath(target, identity & CStr(extension))) Then fs.DeleteFile fs.BuildPath(target, identity & CStr(extension))
    stepLabel = currentIdentity & ": PackageMovePrivate MoveFile"
663         fs.MoveFile fs.BuildPath(folder, identity & CStr(extension)), fs.BuildPath(target, identity & CStr(extension))
664         If Len(listing) > 0 Then listing = listing & ","
    stepLabel = currentIdentity & ": PackageMovePrivate GetFileName"
666         listing = listing & Quote(identity & CStr(extension) & " (kept in " & fs.GetFileName(target) & ", in the shared Public Documents folder, which other users of this computer can read; not in the zip and not published)")
    Next extension
668     PackageMovePrivate = "[" & listing & "]"
End Function

Private Function PackageRemoveFiles(ByVal folder As String, ByVal identity As String) As String
    ' A drawing that did not finish leaves no half-made file behind. "" when all are gone, else what failed: the reason and the file name (never a path).
    Dim fs As Object, extension As Variant, path As String
674     Set fs = CreateObject("Scripting.FileSystemObject")
675     For Each extension In Array(".slddrw", ".pdf", ".dxf")
    stepLabel = currentIdentity & ": PackageRemoveFiles BuildPath"
677         path = fs.BuildPath(folder, identity & CStr(extension))
    stepLabel = currentIdentity & ": PackageRemoveFiles FileExists"
679         If fs.FileExists(path) Then
680             On Error Resume Next
681             Err.Clear
    stepLabel = currentIdentity & ": PackageRemoveFiles DeleteFile"
683             fs.DeleteFile path
684             If Err.Number <> 0 Then
685                 If Len(PackageRemoveFiles) > 0 Then PackageRemoveFiles = PackageRemoveFiles & ", "
686                 PackageRemoveFiles = PackageRemoveFiles & Err.Description & " (" & identity & CStr(extension) & ")"
687                 Err.Clear
            End If
689             On Error GoTo 0
        End If
    Next extension
End Function

Private Sub AttemptPackage(ByVal index As Long, ByVal folder As String)
    ' One drawing in its own new document: the part opened read-only and silent first (so the new drawing is the active document afterwards, and the
    ' part is closed unsaved), the plan, the read-backs, the privacy blanking, the title block text, then the three files.
    Dim identity As String, fs As Object, template As String, model As Object, modelErrors As Long, modelWarnings As Long
    Dim native As String, pdfFile As String, dxfFile As String
699     identity = currentIdentity
700     Set loadedDocs = New Collection
701     Set fs = CreateObject("Scripting.FileSystemObject")
702     template = ResolveTemplate("drawing")
703     stepLabel = identity & ": model open"
    stepLabel = currentIdentity & ": AttemptPackage OpenDoc6"
705     Set model = app.OpenDoc6(packageFolder & "\" & PackageModel(index) & PackageExtension(index), PackageDocType(index), swOpenDocOptions_Silent + swOpenDocOptions_ReadOnly, "", modelErrors, modelWarnings)
706     If modelErrors <> 0 Then Err.Raise 5, , "SolidWorks OpenDoc6 error " & CStr(modelErrors) & " opening the drawing model"
707     Require model, "The drawing model could not be opened"
708     Set packageModelDoc = model
    stepLabel = currentIdentity & ": AttemptPackage Add"
710     loadedDocs.Add model.GetTitle()
    stepLabel = currentIdentity & ": AttemptPackage NewDocument"
712     Set doc = app.NewDocument(template, 0, 0#, 0#)
713     If doc Is Nothing Then Err.Raise 5, , "Template could not be opened. Paths tried: " & template
    stepLabel = currentIdentity & ": AttemptPackage GetFileName"
715     AppendLog folder, currentIdentity, "option", 0, 0, "drawing template: " & fs.GetFileName(template)
    stepLabel = currentIdentity & ": AttemptPackage ShowFeatureErrorDialog"
717     attemptOldErrors = doc.ShowFeatureErrorDialog
718     attemptErrorsSaved = True
    stepLabel = currentIdentity & ": AttemptPackage ShowFeatureErrorDialog"
720     doc.ShowFeatureErrorDialog = False
721     BuildPackage index
722     PackageFinish
723     BlankProperties
724     BuildPackageTitle index
725     native = identity & ".slddrw"
726     pdfFile = identity & ".pdf"
727     dxfFile = identity & ".dxf"
    stepLabel = currentIdentity & ": AttemptPackage BuildPath"
729     SaveFile fs.BuildPath(folder, native)
730     stepLabel = identity & ": pdf export"
    stepLabel = currentIdentity & ": AttemptPackage BuildPath"
732     SaveFile fs.BuildPath(folder, pdfFile)
    stepLabel = currentIdentity & ": AttemptPackage BuildPath"
734     PackageFileCheck fs.BuildPath(folder, pdfFile), "PDF"
735     stepLabel = identity & ": dxf export"
    stepLabel = currentIdentity & ": AttemptPackage BuildPath"
737     ExportDrawing fs.BuildPath(folder, dxfFile)
End Sub

Private Sub PackageFileCheck(ByVal path As String, ByVal kind As String)
    Dim fs As Object
742     stepLabel = currentIdentity & ": " & kind & " file check"
743     Set fs = CreateObject("Scripting.FileSystemObject")
    stepLabel = currentIdentity & ": PackageFileCheck FileExists"
745     If Not fs.FileExists(path) Then Err.Raise 5, , "The " & kind & " export wrote no file"
    stepLabel = currentIdentity & ": PackageFileCheck GetFile"
747     If fs.GetFile(path).Size = 0 Then Err.Raise 5, , "The " & kind & " export wrote an empty file"
    stepLabel = currentIdentity & ": PackageFileCheck GetFileName"
749     AppendLog currentFolder, currentIdentity, "option", 0, 0, "drawing " & kind & ": " & fs.GetFileName(path) & ", " & CStr(fs.GetFile(path).Size) & " bytes"
End Sub

Private Sub PackageStart(ByVal partFile As String, ByVal lowMm As Variant, ByVal highMm As Variant)
753     packagePart = packageFolder & "\" & partFile
754     packageComponents = Empty
755     packageLow = Array(CDbl(lowMm(0)) * 0.001, CDbl(lowMm(1)) * 0.001, CDbl(lowMm(2)) * 0.001)
756     packageHigh = Array(CDbl(highMm(0)) * 0.001, CDbl(highMm(1)) * 0.001, CDbl(highMm(2)) * 0.001)
757     Set packageViews = CreateObject("Scripting.Dictionary")
758     Set packageRecords = CreateObject("Scripting.Dictionary")
759     Set packageDrops = CreateObject("Scripting.Dictionary")
760     Set packageSpaces = CreateObject("Scripting.Dictionary")
761     Set packageTitle = CreateObject("Scripting.Dictionary")
762     packageOrder = ""
763     packageDimCount = 0
764     packageRatioN = 1#
765     packageRatioD = 1#
766     packageSheetW = 0.297
767     packageSheetH = 0.21
768     packageScalePending = False
End Sub

Private Sub PackageAssembly(ByVal components As Variant)
    ' An assembly's components: Array(name, low, high, shift) in meters (their boxes in the assembly and where each one's origin stands), for the edges.
773     packageComponents = components
End Sub

Private Function PackageBomTemplate() As String
    ' The BOM table template: bom-standard.sldbomtbt, exactly, from the install's template folder (lang\<language>\). No other file is taken instead and the empty
    ' path (SolidWorks's own default) is not asked for: a template in a personal folder could put a path in the file, so one that is absent or personal fails
    ' the drawing precisely. Only the file name is ever logged.
    Dim fs As Object, install As String, candidate As String, found As Boolean
781     Set fs = CreateObject("Scripting.FileSystemObject")
782     On Error Resume Next
    stepLabel = currentIdentity & ": PackageBomTemplate GetExecutablePath"
784     install = app.GetExecutablePath()
    stepLabel = currentIdentity & ": PackageBomTemplate GetExtensionName"
786     If LCase$(fs.GetExtensionName(install)) = "exe" Then install = fs.GetParentFolderName(install)
    stepLabel = currentIdentity & ": PackageBomTemplate BuildPath"
788     candidate = fs.BuildPath(fs.BuildPath(fs.BuildPath(install, "lang"), app.GetCurrentLanguage()), BOM_TEMPLATE)
    stepLabel = currentIdentity & ": PackageBomTemplate FileExists"
790     found = fs.FileExists(candidate)
791     If Err.Number <> 0 Then
792         found = False
793         Err.Clear
    End If
795     On Error GoTo 0
796     If found Then
797         If Len(PersonalTemplateReason("BOM table", candidate)) > 0 Then
798             AppendLog currentFolder, currentIdentity, "option", 0, 0, "parts list: the install's BOM template " & BOM_TEMPLATE & " is in a personal folder and is not used"
799             found = False
        End If
    End If
802     If Not found Then Err.Raise 5, , "no usable BOM template (" & BOM_TEMPLATE & ") outside personal folders"
803     PackageBomTemplate = candidate
End Function

Private Sub PackagePartsList(ByVal anchor As Long, ByVal fractionX As Double, ByVal fractionY As Double, ByVal rows As Variant)
    ' The parts list: the base view is selected and IView.InsertBomTable4 inserts a top-level BOM table hanging from the recipe's corner of the sheet
    ' (UseAnchorPoint False, so X and Y are the corner); the table is then read back and must be the assembly's components. InsertBomTable4 answers a
    ' BomTableAnnotation; RowCount, ColumnCount and Text belong to ITableAnnotation, so the answer is assigned to a variable of that type (the query).
    Dim fs As Object, baseView As Object, x As Double, y As Double, configuration As String, template As String
    Dim bomResult As Object, tableAnnotation As SldWorks.TableAnnotation
812     Set fs = CreateObject("Scripting.FileSystemObject")
813     Set baseView = packageViews("base")
814     x = fractionX * packageSheetW
815     y = fractionY * packageSheetH
    stepLabel = currentIdentity & ": PackagePartsList Name"
817     configuration = CStr(packageModelDoc.ConfigurationManager.ActiveConfiguration.Name)
818     template = PackageBomTemplate()
    stepLabel = currentIdentity & ": PackagePartsList ClearSelection2"
820     doc.ClearSelection2 True
    stepLabel = currentIdentity & ": PackagePartsList GetName2"
822     callInputs = "parts list in " & baseView.GetName2() & " at(m)=" & NumberList(Array(x, y)) & " anchor " & CStr(anchor) & " top level only, configuration " & configuration & ", template " & fs.GetFileName(template)
    stepLabel = currentIdentity & ": PackagePartsList SelectByID2" & " " & apiInputs & " " & callInputs
824     If Not doc.Extension.SelectByID2(baseView.GetName2(), "DRAWINGVIEW", 0#, 0#, 0#, False, 0, Nothing, 0) Then Err.Raise 5, , "The base view could not be selected for the parts list: " & callInputs
    stepLabel = currentIdentity & ": PackagePartsList InsertBomTable4"
826     Set bomResult = baseView.InsertBomTable4(False, x, y, anchor, swBomType_TopLevelOnly, configuration, template, False, swNumberingType_Detailed, False)
    stepLabel = currentIdentity & ": PackagePartsList ClearSelection2"
828     doc.ClearSelection2 True
829     Require bomResult, "IView.InsertBomTable4 returned no table: " & callInputs
830     Set tableAnnotation = bomResult
831     Require tableAnnotation, "The parts list table does not answer ITableAnnotation: " & callInputs
832     PackagePartsListCheck tableAnnotation, rows
End Sub

Private Function PackageWholeNumber(ByVal text As String) As Boolean
    ' Only digits: "1" is a quantity, "1.5", "1,0", "-1" and "" are not.
    Dim i As Long
838     If Len(text) = 0 Or Len(text) > 9 Then Exit Function
839     For i = 1 To Len(text)
840         If Not Mid$(text, i, 1) Like "#" Then Exit Function
    Next i
842     PackageWholeNumber = True
End Function

Private Function PackagePartName(ByVal text As String) As String
    ' A parts list's part number cell as a part name: without any <...> part, lower case, without .sldprt or .sldasm.
    Dim opens As Long, closes As Long
848     text = Trim$(text)
849     opens = InStr(text, "<")
850     Do While opens > 0
851         closes = InStr(opens, text, ">")
852         If closes = 0 Then Exit Do
853         text = Left$(text, opens - 1) & Mid$(text, closes + 1)
854         opens = InStr(text, "<")
    Loop
856     text = LCase$(Trim$(text))
857     If Right$(text, 7) = ".sldprt" Or Right$(text, 7) = ".sldasm" Then text = Left$(text, Len(text) - 7)
858     PackagePartName = text
End Function

Private Sub PackagePartsListCheck(ByVal tableAnnotation As SldWorks.TableAnnotation, ByVal rows As Variant)
    ' The table's rows (ITableAnnotation RowCount, ColumnCount, Text) against the assembly: its header row has PART NUMBER and QTY. columns, and each
    ' other row is one component and its quantity: every (part name, quantity) of the recipe's assembly, and nothing else.
    Dim rowCount As Long, columnCount As Long, r As Long, c As Long, header As Long, nameColumn As Long, quantityColumn As Long, cell As String
    Dim count As Long, i As Long, k As Long, names() As String, quantities() As Long, used() As Boolean, matched As Boolean, quantityText As String
    Dim got As String, headerText As String
    stepLabel = currentIdentity & ": PackagePartsListCheck RowCount"
868     rowCount = CLng(tableAnnotation.RowCount)
    stepLabel = currentIdentity & ": PackagePartsListCheck ColumnCount"
870     columnCount = CLng(tableAnnotation.ColumnCount)
871     header = -1
872     nameColumn = -1
873     quantityColumn = -1
874     For r = 0 To rowCount - 1
875         For c = 0 To columnCount - 1
    stepLabel = currentIdentity & ": PackagePartsListCheck Text"
877             cell = UCase$(Trim$(CStr(tableAnnotation.Text(r, c))))
878             If header < 0 And (cell = "QTY" Or cell = "QTY.") Then
879                 header = r
880                 quantityColumn = c
            End If
        Next c
    Next r
884     If header < 0 Then Err.Raise 5, , "The parts list has no header row with a QTY. column in its " & CStr(rowCount) & " rows and " & CStr(columnCount) & " columns"
885     For c = 0 To columnCount - 1
    stepLabel = currentIdentity & ": PackagePartsListCheck Text"
887         cell = UCase$(Trim$(CStr(tableAnnotation.Text(header, c))))
888         If Len(headerText) > 0 Then headerText = headerText & " | "
889         headerText = headerText & cell
890         If nameColumn < 0 And Replace(cell, " ", "") = "PARTNUMBER" Then nameColumn = c
    Next c
892     If nameColumn < 0 Then Err.Raise 5, , "The parts list has no PART NUMBER column (its header reads " & headerText & ")"
893     count = rowCount - 1
894     If count <> UBound(rows) + 1 Then Err.Raise 5, , "The parts list has " & CStr(count) & " rows, the assembly has " & CStr(UBound(rows) + 1) & " components"
895     ReDim names(count - 1)
896     ReDim quantities(count - 1)
897     ReDim used(count - 1)
898     i = 0
899     For r = 0 To rowCount - 1
900         If r <> header Then
    stepLabel = currentIdentity & ": PackagePartsListCheck Text"
902             names(i) = PackagePartName(CStr(tableAnnotation.Text(r, nameColumn)))
    stepLabel = currentIdentity & ": PackagePartsListCheck Text"
904             quantityText = Trim$(CStr(tableAnnotation.Text(r, quantityColumn)))
905             If Not PackageWholeNumber(quantityText) Then Err.Raise 5, , "The parts list quantity " & quantityText & " of " & names(i) & " is not a whole number"
906             quantities(i) = CLng(quantityText)
907             If Len(got) > 0 Then got = got & ", "
908             got = got & names(i) & " " & CStr(quantities(i))
909             i = i + 1
        End If
    Next r
912     For k = 0 To UBound(rows)
913         matched = False
914         For i = 0 To count - 1
915             If Not used(i) And names(i) = LCase$(CStr(rows(k)(0))) And quantities(i) = CLng(rows(k)(1)) Then
916                 used(i) = True
917                 matched = True
918                 Exit For
            End If
        Next i
921         If Not matched Then Err.Raise 5, , "The parts list has no row for " & CStr(rows(k)(0)) & " with the quantity " & CStr(rows(k)(1)) & " (it reads: " & got & ")"
    Next k
923     AppendLog currentFolder, currentIdentity, "option", 0, 0, "drawing parts list: " & CStr(count) & " rows read back, " & got
End Sub

Private Function PackageSheetProperties(ByVal sheetObject As Object) As Variant
    ' ISheet.GetProperties2 as exactly eight values (paper size, template, scale numerator and denominator, first angle, width, height,
    ' same custom property), or Empty when SolidWorks does not give them.
    Dim values As Variant, first As Long, same As Variant
930     On Error Resume Next
    stepLabel = currentIdentity & ": PackageSheetProperties GetProperties2"
932     values = sheetObject.GetProperties2()
933     If Err.Number <> 0 Then
934         Err.Clear
935         Exit Function
    End If
937     On Error GoTo 0
938     If Not IsArray(values) Then Exit Function
939     first = LBound(values)
940     If UBound(values) - first < 6 Then Exit Function
941     same = False
942     If UBound(values) - first >= 7 Then same = values(first + 7)
943     PackageSheetProperties = Array(values(first), values(first + 1), values(first + 2), values(first + 3), values(first + 4), values(first + 5), values(first + 6), same)
End Function

Private Sub PackageSetting(ByVal what As String, ByVal preference As Long, ByVal wanted As Long)
    ' A document preference the drawing must have (the standard, the units): read from the template's drawing, set when it differs, read again.
    Dim found As Long, again As Long, mitigation As String
949     callInputs = "preference=" & CStr(preference) & " wanted=" & CStr(wanted)
    stepLabel = currentIdentity & ": PackageSetting GetUserPreferenceInteger"
951     found = doc.Extension.GetUserPreferenceInteger(preference, swDetailingNoOptionSpecified)
952     If found = wanted Then Exit Sub
953     mitigation = "drawing-" & what & "-set"
954     RecordMitigation mitigation, True, True
    stepLabel = currentIdentity & ": PackageSetting SetUserPreferenceInteger"
956     If Not doc.Extension.SetUserPreferenceInteger(preference, swDetailingNoOptionSpecified, wanted) Then Err.Raise 5, , "The drawing " & what & " could not be set: " & callInputs
    stepLabel = currentIdentity & ": PackageSetting GetUserPreferenceInteger"
958     again = doc.Extension.GetUserPreferenceInteger(preference, swDetailingNoOptionSpecified)
959     If again <> wanted Then Err.Raise 5, , "The drawing " & what & " stays " & CStr(again) & ", not " & CStr(wanted) & ", after setting it: " & callInputs
960     fallbackSuccesses(mitigation) = fallbackSuccesses(mitigation) + 1
961     AppendLog currentFolder, currentIdentity, "option", 0, 0, "drawing " & what & ": the template had " & CStr(found) & ", set to " & CStr(wanted)
End Sub

Private Sub PackageSheet(ByVal standard As Long, ByVal units As Long, ByVal paper As Long, ByVal paperWidth As Double, ByVal paperHeight As Double, ByVal numerator As Double, ByVal denominator As Double)
    Dim sheetObject As Object, properties As Variant, text As String
966     Set drawingInterface = DrawingDocument(doc)
    stepLabel = currentIdentity & ": PackageSheet GetCurrentSheet"
968     Set sheetObject = drawingInterface.GetCurrentSheet()
969     Require sheetObject, "The new drawing has no current sheet"
970     Set packageSheetObject = sheetObject
971     If standard >= 0 Then PackageSetting "standard", swDetailingDimensionStandard, standard
972     If units >= 0 Then PackageSetting "units", swUnitsLinear, units
973     properties = PackageSheetProperties(sheetObject)
974     If paper >= 0 Then
975         callInputs = "PaperSz=" & CStr(paper) & " Width=" & NumberList(Array(paperWidth)) & " Height=" & NumberList(Array(paperHeight))
976         If IsEmpty(properties) Then Err.Raise 5, , "ISheet.GetProperties2 returned no sheet properties: " & callInputs
977         If CLng(properties(0)) <> paper Then
978             RecordMitigation "drawing-sheet-size-set", True, True
            ' ISheet.SetProperties2 returns nothing (interop 32.1.0, void): it is read back, not checked for a result.
    stepLabel = currentIdentity & ": PackageSheet SetProperties2"
981             sheetObject.SetProperties2 paper, CLng(properties(1)), CDbl(properties(2)), CDbl(properties(3)), CBool(properties(4)), paperWidth, paperHeight, CBool(properties(7))
982             properties = PackageSheetProperties(sheetObject)
983             If IsEmpty(properties) Then Err.Raise 5, , "ISheet.GetProperties2 returned no sheet properties after setting the size: " & callInputs
984             If CLng(properties(0)) <> paper Then Err.Raise 5, , "The sheet size stays " & CStr(CLng(properties(0))) & ", not " & CStr(paper) & ", after setting it: " & callInputs
985             fallbackSuccesses("drawing-sheet-size-set") = fallbackSuccesses("drawing-sheet-size-set") + 1
        End If
    End If
988     If Not IsEmpty(properties) Then
989         packageSheetW = CDbl(properties(5))
990         packageSheetH = CDbl(properties(6))
    End If
992     callInputs = "Numerator=" & NumberList(Array(numerator)) & " Denominator=" & NumberList(Array(denominator))
    stepLabel = currentIdentity & ": PackageSheet SetScale"
994     If Not sheetObject.SetScale(numerator, denominator, False, False) Then Err.Raise 5, , "ISheet.SetScale failed: " & callInputs
995     packageRatioN = numerator
996     packageRatioD = denominator
997     properties = PackageSheetProperties(sheetObject)
998     If IsEmpty(properties) Then
        ' The scale cannot be read from the sheet: every view's own scale is checked instead (and counted once the first one is right).
1000         RecordMitigation "drawing-sheet-scale-from-views", True, True
1001         packageScalePending = True
1002         text = "unknown"
    Else
1004         If Abs(CDbl(properties(2)) * denominator - CDbl(properties(3)) * numerator) > 0.000000001 Then Err.Raise 5, , "The sheet scale reads back " & NumberList(Array(properties(2), properties(3))) & ", not " & NumberList(Array(numerator, denominator)) & ": " & callInputs
1005         text = CStr(CBool(properties(4)))
    End If
1007     AppendLog currentFolder, currentIdentity, "option", 0, 0, "drawing: sheet " & NumberList(Array(packageSheetW, packageSheetH)) & " m, scale " & NumberList(Array(numerator, denominator)) & ", first angle " & text
End Sub

Private Sub PackageCheckScale(ByVal view As Object, ByVal what As String, ByVal ownN As Double, ByVal ownD As Double)
    ' The view is at the sheet's scale, or at (ownN : ownD), a scale the recipe gives that view alone (ownD = 0 means none): set on the view and read back.
    Dim wanted As Double
1013     wanted = packageRatioN / packageRatioD
1014     If ownD > 0 Then wanted = ownN / ownD
    stepLabel = currentIdentity & ": PackageCheckScale ScaleDecimal"
1016     If Abs(view.ScaleDecimal - wanted) > 0.000000001 Then
        ' The sheet scale was set first; a view that still is not at it is given the scale itself.
1018         If ownD = 0 Then RecordMitigation "drawing-view-scale-explicit", True, True
    stepLabel = currentIdentity & ": PackageCheckScale UseSheetScale"
1020         view.UseSheetScale = 0
    stepLabel = currentIdentity & ": PackageCheckScale ScaleDecimal"
1022         view.ScaleDecimal = wanted
    stepLabel = currentIdentity & ": PackageCheckScale ScaleDecimal"
1024         If Abs(view.ScaleDecimal - wanted) > 0.000000001 Then Err.Raise 5, , "The " & what & " view scale is " & NumberList(Array(view.ScaleDecimal)) & ", not " & NumberList(Array(wanted)) & ", after setting it: " & callInputs
1025         If ownD = 0 Then
1026             fallbackSuccesses("drawing-view-scale-explicit") = fallbackSuccesses("drawing-view-scale-explicit") + 1
        Else
1028             AppendLog currentFolder, currentIdentity, "option", 0, 0, "drawing: the " & what & " view has its own scale " & NumberList(Array(ownN, ownD)) & ", set on the view and read back"
        End If
    End If
1031     If packageScalePending Then
1032         packageScalePending = False
1033         fallbackSuccesses("drawing-sheet-scale-from-views") = fallbackSuccesses("drawing-sheet-scale-from-views") + 1
    End If
End Sub

Private Function PackageModelView(ByVal orientation As String, ByVal what As String, ByVal x As Double, ByVal y As Double, ByVal ownN As Double, ByVal ownD As Double) As Object
    Dim created As Object
    stepLabel = currentIdentity & ": PackageModelView ClearSelection2"
1040     doc.ClearSelection2 True
1041     callInputs = "model=" & Mid$(packagePart, InStrRev(packagePart, "\") + 1) & " view=" & orientation & " at(m)=" & NumberList(Array(x, y)) & ",0"
    stepLabel = currentIdentity & ": PackageModelView CreateDrawViewFromModelView3" & " " & apiInputs & " " & callInputs
1043     Set created = drawingInterface.CreateDrawViewFromModelView3(packagePart, orientation, x, y, 0#)
1044     Require created, "The " & what & " view was not created: " & callInputs
    stepLabel = currentIdentity & ": PackageModelView ClearSelection2"
1046     doc.ClearSelection2 True
1047     PackageCheckScale created, what, ownN, ownD
1048     Set PackageModelView = created
End Function

Private Function PackageProjectedView(ByVal what As String, ByVal x As Double, ByVal y As Double) As Object
    Dim created As Object, source As Object
1053     Set source = packageViews("base")
    stepLabel = currentIdentity & ": PackageProjectedView ClearSelection2"
1055     doc.ClearSelection2 True
    stepLabel = currentIdentity & ": PackageProjectedView GetName2"
1057     callInputs = "projected from " & source.GetName2() & " at(m)=" & NumberList(Array(x, y)) & ",0"
    stepLabel = currentIdentity & ": PackageProjectedView SelectByID2" & " " & apiInputs & " " & callInputs
1059     If Not doc.Extension.SelectByID2(source.GetName2(), "DRAWINGVIEW", 0#, 0#, 0#, False, 0, Nothing, 0) Then Err.Raise 5, , "The base view could not be selected to project from: " & callInputs
    stepLabel = currentIdentity & ": PackageProjectedView CreateUnfoldedViewAt3" & " " & apiInputs & " " & callInputs
1061     Set created = drawingInterface.CreateUnfoldedViewAt3(x, y, 0#, False)
1062     Require created, "The " & what & " view was not created: " & callInputs
    stepLabel = currentIdentity & ": PackageProjectedView ClearSelection2"
1064     doc.ClearSelection2 True
1065     PackageCheckScale created, what, 0#, 0#
1066     Set PackageProjectedView = created
End Function

Private Function PackageViewAxis(ByVal view As Object) As Long
    ' The model axis a view looks along, or -1 when it looks along none (a tilted view).
1071     On Error Resume Next
1072     PackageViewAxis = ViewDrop(view)
1073     If Err.Number <> 0 Then
1074         PackageViewAxis = -1
1075         Err.Clear
    End If
End Function

Private Function PackageAxisText(ByVal axisIndex As Long) As String
1080     If axisIndex >= 0 And axisIndex < 3 Then PackageAxisText = Mid$("XYZ", axisIndex + 1, 1) Else PackageAxisText = "no model axis"
End Function

Private Sub PackageDeleteView(ByVal view As Object)
    stepLabel = currentIdentity & ": PackageDeleteView GetName2"
1085     callInputs = "delete " & view.GetName2()
    stepLabel = currentIdentity & ": PackageDeleteView ClearSelection2"
1087     doc.ClearSelection2 True
    stepLabel = currentIdentity & ": PackageDeleteView SelectByID2" & " " & apiInputs & " " & callInputs
1089     If Not doc.Extension.SelectByID2(view.GetName2(), "DRAWINGVIEW", 0#, 0#, 0#, False, 0, Nothing, 0) Then Err.Raise 5, , "The view could not be selected to delete it: " & callInputs
    stepLabel = currentIdentity & ": PackageDeleteView DeleteSelection2"
1091     If Not doc.Extension.DeleteSelection2(swDelete_Absorbed) Then Err.Raise 5, , "The view could not be deleted: " & callInputs
    stepLabel = currentIdentity & ": PackageDeleteView ClearSelection2"
1093     doc.ClearSelection2 True
End Sub

Private Function PackageViewSign(ByVal view As Object, ByVal axisIndex As Long) As Long
    ' Which side of the model the viewer is on along the axis (+1 or -1): the view's own z axis (toward the viewer) is column 2 of the rotation.
    Dim matrix As Variant
    stepLabel = currentIdentity & ": PackageViewSign ArrayData"
1100     matrix = view.ModelToViewTransform.ArrayData
1101     If CDbl(matrix(LBound(matrix) + 3 * axisIndex + 2)) > 0 Then PackageViewSign = 1 Else PackageViewSign = -1
End Function

Private Function PackageViewOk(ByVal view As Object, ByVal axisIndex As Long, ByVal signValue As Long) As Boolean
1105     If PackageViewAxis(view) <> axisIndex Then Exit Function
1106     If signValue <> 0 Then
1107         If PackageViewSign(view, axisIndex) <> signValue Then Exit Function
    End If
1109     PackageViewOk = True
End Function

Private Sub PackageBase(ByVal orientation As String, ByVal axisIndex As Long, ByVal acrossIndex As Long, ByVal upIndex As Long, ByVal fractionX As Double, ByVal fractionY As Double)
    Dim created As Object, found As Long, matrix As Variant, rightPart As Double, upPart As Double
1114     Set created = PackageModelView(orientation, "base", fractionX * packageSheetW, fractionY * packageSheetH, 0#, 0#)
1115     found = PackageViewAxis(created)
1116     If found <> axisIndex Then Err.Raise 5, , "The base view " & orientation & " looks along " & PackageAxisText(found) & ", not " & PackageAxisText(axisIndex) & ": " & callInputs
    ' The sign, not only the axis: model +across must point to the right on the sheet and model +up must point up (the recipe's Z-up world).
    stepLabel = currentIdentity & ": PackageBase ArrayData"
1119     matrix = created.ModelToViewTransform.ArrayData
1120     rightPart = CDbl(matrix(LBound(matrix) + 3 * acrossIndex))
1121     upPart = CDbl(matrix(LBound(matrix) + 3 * upIndex + 1))
1122     If rightPart <= 0.5 Or upPart <= 0.5 Then Err.Raise 5, , "The base view " & orientation & " does not show the recipe's orientation: model +" & PackageAxisText(acrossIndex) & " has the x component " & NumberList(Array(rightPart)) & " and model +" & PackageAxisText(upIndex) & " the y component " & NumberList(Array(upPart)) & " on the sheet; they must be right and up: " & callInputs
1123     Set packageViews("base") = created
1124     packageOrder = "base"
    stepLabel = currentIdentity & ": PackageBase GetName2"
1126     AppendLog currentFolder, currentIdentity, "option", 0, 0, "drawing: base view " & created.GetName2() & " " & orientation & " looks along " & PackageAxisText(found)
End Sub

Private Sub PackageProjected(ByVal direction As String, ByVal axisIndex As Long, ByVal signValue As Long, ByVal fractionX As Double, ByVal fractionY As Double, ByVal oppositeX As Double, ByVal oppositeY As Double)
    Dim created As Object, found As Long
1131     Set created = PackageProjectedView(direction, fractionX * packageSheetW, fractionY * packageSheetH)
1132     found = PackageViewAxis(created)
1133     If Not PackageViewOk(created, axisIndex, signValue) Then
        ' A first-angle template puts the projected view on the other side: delete it and place it on the opposite side of the base view.
1135         RecordMitigation "drawing-projection-opposite-side", True, True
    stepLabel = currentIdentity & ": PackageProjected GetName2"
1137         AppendLog currentFolder, currentIdentity, "option", 0, 0, "drawing: the " & direction & " view " & created.GetName2() & " looks along " & PackageAxisText(found) & " with the viewer on another side than wanted (" & CStr(signValue) & " along " & PackageAxisText(axisIndex) & "); deleting it and projecting on the opposite side"
1138         PackageDeleteView created
1139         Set created = PackageProjectedView(direction, oppositeX * packageSheetW, oppositeY * packageSheetH)
1140         found = PackageViewAxis(created)
1141         If Not PackageViewOk(created, axisIndex, signValue) Then Err.Raise 5, , "The " & direction & " view looks along " & PackageAxisText(found) & ", not " & PackageAxisText(axisIndex) & " (viewer side " & CStr(signValue) & "), on either side of the base view: " & callInputs
1142         fallbackSuccesses("drawing-projection-opposite-side") = fallbackSuccesses("drawing-projection-opposite-side") + 1
    End If
1144     Set packageViews(direction) = created
1145     packageOrder = packageOrder & "," & direction
    stepLabel = currentIdentity & ": PackageProjected GetName2"
1147     AppendLog currentFolder, currentIdentity, "option", 0, 0, "drawing: " & direction & " view " & created.GetName2() & " looks along " & PackageAxisText(found)
End Sub

Private Sub PackageIso(ByVal numerator As Double, ByVal denominator As Double, ByVal fractionX As Double, ByVal fractionY As Double)
    Dim created As Object, ownN As Double, ownD As Double
1152     If numerator * packageRatioD <> denominator * packageRatioN Then
1153         ownN = numerator
1154         ownD = denominator
    End If
1156     Set created = PackageModelView("*Isometric", "iso", fractionX * packageSheetW, fractionY * packageSheetH, ownN, ownD)
    stepLabel = currentIdentity & ": PackageIso ArrayData"
1158     If Not MatrixUsable(created.ModelToViewTransform.ArrayData) Then Err.Raise 5, , "The isometric view transform is not a rotation: " & callInputs
1159     If PackageViewAxis(created) >= 0 Then Err.Raise 5, , "The isometric view is an axis-aligned view (it looks along " & PackageAxisText(PackageViewAxis(created)) & "): " & callInputs
1160     Set packageViews("iso") = created
    stepLabel = currentIdentity & ": PackageIso GetName2"
1162     AppendLog currentFolder, currentIdentity, "option", 0, 0, "drawing: isometric view " & created.GetName2() & " is not axis-aligned"
End Sub

Private Function PackageTryPlan(ByVal records As Collection, ByVal first As Variant, ByVal second As Variant) As Collection
    ' The dimension plan of a view, or Nothing when the two points coincide in that view (a view that looks along the line between them cannot show it).
    Dim failure As String, failureNumber As Long
1168     On Error Resume Next
1169     Set PackageTryPlan = DimensionPlan(records, first, second)
1170     failureNumber = Err.Number
1171     failure = Err.Description
1172     Err.Clear
1173     On Error GoTo 0
1174     If failureNumber <> 0 Then
1175         If InStr(1, failure, "coincide", vbTextCompare) = 0 Then Err.Raise failureNumber, , failure
1176         Set PackageTryPlan = Nothing
    End If
End Function

Private Function PackageRung(ByVal plan As Collection) As String
    ' The mitigation name of a dimension made by a plan form D05a's plan does not make: the plan's records carry it (see dimension_rung in the Python twin).
    Dim k As Long
    stepLabel = currentIdentity & ": PackageRung Count"
1184     For k = 1 To plan.Count
    stepLabel = currentIdentity & ": PackageRung Exists"
1186         If plan(k).Exists("rung") Then
1187             PackageRung = plan(k)("rung")
1188             Exit Function
        End If
    Next k
End Function

Private Function PackageLastDimensionType(ByVal view As Object) As String
    ' swDimensionType_e of the view's last display dimension (IDisplayDimension.GetType), for the log; never a failure on its own.
    Dim display As Object, last As Object, failure As Long
1196     On Error Resume Next
    stepLabel = currentIdentity & ": PackageLastDimensionType GetFirstDisplayDimension5"
1198     Set display = view.GetFirstDisplayDimension5()
1199     Do While Not display Is Nothing
1200         Set last = display
    stepLabel = currentIdentity & ": PackageLastDimensionType GetNext3"
1202         Set display = display.GetNext3()
    Loop
    stepLabel = currentIdentity & ": PackageLastDimensionType GetType"
1205     If Not last Is Nothing Then PackageLastDimensionType = CStr(last.GetType())
1206     failure = Err.Number
1207     Err.Clear
1208     On Error GoTo 0
1209     If failure <> 0 Or last Is Nothing Then PackageLastDimensionType = "unreadable"
End Function

Private Sub PackageDimension(ByVal valueMm As Double, ByVal firstMm As Variant, ByVal secondMm As Variant)
    Dim first As Variant, second As Variant, labels As Variant, k As Long, key As String, plan As Collection, chosen As String
    Dim activeView As Object, outline As Variant, measured As Double, text As String, drop As Long, spaceName As String, index As Long, rung As String, failure As String, failureNumber As Long, found As Long, stopAt As Long
1215     index = packageDimCount
1216     packageDimCount = packageDimCount + 1
1217     If index = 0 Then
1218         ReDim packageValues(0)
    Else
1220         ReDim Preserve packageValues(index)
    End If
1222     packageValues(index) = valueMm
1223     first = Array(CDbl(firstMm(0)) * 0.001, CDbl(firstMm(1)) * 0.001, CDbl(firstMm(2)) * 0.001)
1224     second = Array(CDbl(secondMm(0)) * 0.001, CDbl(secondMm(1)) * 0.001, CDbl(secondMm(2)) * 0.001)
1225     labels = Split(packageOrder, ",")
1226     For k = 0 To UBound(labels)
1227         key = CStr(labels(k))
    stepLabel = currentIdentity & ": PackageDimension Exists"
1229         If Not packageRecords.Exists(key) Then
1230             Set activeView = packageViews(key)
1231             Set packageRecords(key) = DrawingEdges(activeView, packageLow, packageHigh, drop, spaceName, packageComponents, PackageModelName())
1232             packageDrops(key) = drop
1233             packageSpaces(key) = spaceName
        End If
1235         Set plan = PackageTryPlan(packageRecords(key), FlatPoint(first, packageDrops(key)), FlatPoint(second, packageDrops(key)))
1236         If Not plan Is Nothing Then
1237             chosen = key
1238             Exit For
        End If
    Next k
1241     If Len(chosen) = 0 Then Err.Raise 5, , "No view shows the edges for the " & NumberList(Array(valueMm)) & " dimension between " & NumberList(firstMm) & " and " & NumberList(secondMm) & " (mm)"
1242     Set activeView = packageViews(chosen)
    stepLabel = currentIdentity & ": PackageDimension GetOutline"
1244     outline = activeView.GetOutline()
1245     rung = PackageRung(plan)
1246     If Len(rung) > 0 Then RecordMitigation rung, True, True
1247     On Error Resume Next
1248     measured = AddDrawingDimension(activeView, plan, IIf(outline(0) > outline(2), outline(0), outline(2)) + PACKAGE_TEXT_STEP * (index + 1), IIf(outline(1) > outline(3), outline(1), outline(3)) + PACKAGE_TEXT_STEP * (index + 1), valueMm, "dimension " & CStr(index + 1))
1249     failureNumber = Err.Number
1250     failure = Err.Description
1251     Err.Clear
1252     On Error GoTo 0
1253     If failureNumber <> 0 Then
1254         found = InStr(1, failure, "measured ", vbTextCompare)
1255         stopAt = 0
1256         If found > 0 Then stopAt = InStr(found, failure, " mm, not", vbTextCompare)
        ' " mm, not" absent (or before the number): a negative length would raise Err 5 here, so the failure goes out as it is.
1258         If rung = "drawing-dimension-edge-on-circles" And found > 0 And stopAt > found + 9 Then
1259             Err.Raise failureNumber, , "edge-on circles: SolidWorks measured " & Mid$(failure, found + 9, stopAt - found - 9) & " mm, not center to center (" & NumberList(Array(valueMm)) & " mm): " & failure
        End If
1261         Err.Raise failureNumber, , failure
    End If
1263     If Len(rung) > 0 Then fallbackSuccesses(rung) = fallbackSuccesses(rung) + 1
1264     If rung = "drawing-dimension-edge-on-circles" Then
        ' What SolidWorks reported, raw, so a first real run shows what happened: each circle's CircleParams (center, axis, radius), how many edges were
        ' selected and the type of the dimension SolidWorks made.
    stepLabel = currentIdentity & ": PackageDimension Count"
1268         For k = 1 To plan.Count
1269             If plan(k)("kind") = "circle" Then text = text & "; circle " & CStr(k) & " CircleParams " & NumberList(plan(k)("raw"))
        Next k
    stepLabel = currentIdentity & ": PackageDimension Count"
1272         AppendLog currentFolder, currentIdentity, "option", 0, 0, "edge-on circles: " & Mid$(text, 3) & "; " & CStr(plan.Count) & " edges selected; dimension type (swDimensionType_e) " & PackageLastDimensionType(activeView)
1273         text = ""
    End If
    stepLabel = currentIdentity & ": PackageDimension Count"
1276     For k = 0 To plan.Count - 1
1277         If k > 0 Then text = text & " + "
1278         text = text & plan(k + 1)("kind")
    Next k
    stepLabel = currentIdentity & ": PackageDimension GetName2"
1281     AppendLog currentFolder, currentIdentity, "option", 0, 0, "drawing dimension " & NumberList(Array(valueMm)) & ": " & chosen & " view " & activeView.GetName2() & ", " & text & ", entity coordinates were " & packageSpaces(chosen) & " coordinates, measured " & Replace(Format$(measured, "0.000000"), ",", ".") & " mm"
End Sub

Private Function PackageBoxFits(ByVal matrix As Variant, ByVal outline As Variant) As Boolean
    ' Every corner of the model box, mapped through the matrix, lies inside the view's outline (within SECTION_TOLERANCE).
    Dim a As Long, b As Long, c As Long, p As Variant
    Dim leftEdge As Double, rightEdge As Double, bottomEdge As Double, topEdge As Double
1288     leftEdge = IIf(outline(0) < outline(2), outline(0), outline(2))
1289     rightEdge = IIf(outline(0) > outline(2), outline(0), outline(2))
1290     bottomEdge = IIf(outline(1) < outline(3), outline(1), outline(3))
1291     topEdge = IIf(outline(1) > outline(3), outline(1), outline(3))
1292     For a = 0 To 1
1293         For b = 0 To 1
1294             For c = 0 To 1
1295                 p = MatrixPoint(matrix, CDbl(IIf(a = 0, packageLow(0), packageHigh(0))), CDbl(IIf(b = 0, packageLow(1), packageHigh(1))), CDbl(IIf(c = 0, packageLow(2), packageHigh(2))))
1296                 If p(0) < leftEdge - SECTION_TOLERANCE Or p(0) > rightEdge + SECTION_TOLERANCE Or p(1) < bottomEdge - SECTION_TOLERANCE Or p(1) > topEdge + SECTION_TOLERANCE Then Exit Function
            Next c
        Next b
    Next a
1300     PackageBoxFits = True
End Function

Private Function PackageFitMatrix(ByVal matrix As Variant, ByVal outline As Variant, ByVal scaleFactor As Double) As Variant
    ' The view's rotation, the given scale, and the translation that puts the model box center at the center of the view's outline.
    Dim first As Long, rotation As Variant, rotated As Variant
1306     first = LBound(matrix)
1307     rotation = Array(matrix(first), matrix(first + 1), matrix(first + 2), matrix(first + 3), matrix(first + 4), matrix(first + 5), matrix(first + 6), matrix(first + 7), matrix(first + 8), 0#, 0#, 0#, scaleFactor)
1308     rotated = MatrixPoint(rotation, (CDbl(packageLow(0)) + CDbl(packageHigh(0))) / 2, (CDbl(packageLow(1)) + CDbl(packageHigh(1))) / 2, (CDbl(packageLow(2)) + CDbl(packageHigh(2))) / 2)
1309     PackageFitMatrix = Array(matrix(first), matrix(first + 1), matrix(first + 2), matrix(first + 3), matrix(first + 4), matrix(first + 5), matrix(first + 6), matrix(first + 7), matrix(first + 8), (outline(0) + outline(2)) / 2 - rotated(0), (outline(1) + outline(3)) / 2 - rotated(1), 0#, scaleFactor)
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
1321     Set source = packageViews("base")
    stepLabel = currentIdentity & ": PackageSection ArrayData"
1323     matrix = source.ModelToViewTransform.ArrayData
1324     For i = 0 To 2
1325         middle(i) = (CDbl(packageLow(i)) + CDbl(packageHigh(i))) / 2
    Next i
    stepLabel = currentIdentity & ": PackageSection GetOutline"
1328     outline = source.GetOutline()
1329     leftEdge = IIf(outline(0) < outline(2), outline(0), outline(2))
1330     rightEdge = IIf(outline(0) > outline(2), outline(0), outline(2))
1331     bottomEdge = IIf(outline(1) < outline(3), outline(1), outline(3))
1332     topEdge = IIf(outline(1) > outline(3), outline(1), outline(3))
1333     If PackageBoxFits(matrix, outline) Then
1334         AppendLog currentFolder, currentIdentity, "option", 0, 0, "drawing: section line mapped through the base view transform (the model box lands inside the outline " & NumberList(outline) & ")"
    Else
        ' The transform does not map model meters to sheet meters (it may be view-local): the mapping is derived from the outline instead. Its rotation
        ' is the transform's, its scale the view's own, and its translation puts the model box center at the center of the outline.
1338         RecordMitigation "drawing-section-outline-fit", True, True
    stepLabel = currentIdentity & ": PackageSection ScaleDecimal"
1340         fitted = PackageFitMatrix(matrix, outline, CDbl(source.ScaleDecimal))
1341         AppendLog currentFolder, currentIdentity, "option", 0, 0, "drawing: the base view transform puts the model box outside the outline " & NumberList(outline) & "; mapping from the outline instead: rotation of the transform, scale " & NumberList(Array(fitted(12))) & " (the view's), translation " & NumberList(Array(fitted(9), fitted(10))) & " m"
1342         If Not PackageBoxFits(fitted, outline) Then Err.Raise 5, , "The model box does not land inside the view outline " & NumberList(outline) & " even when mapped from it: the section line cannot be placed"
1343         matrix = fitted
1344         fallbackSuccesses("drawing-section-outline-fit") = fallbackSuccesses("drawing-section-outline-fit") + 1
    End If
1346     For side = 0 To 1
1347         For i = 0 To 2
1348             point(i) = middle(i)
        Next i
1350         point(cutAxis) = coordinate * 0.001
1351         point(lineAxis) = IIf(side = 0, packageLow(lineAxis), packageHigh(lineAxis))
1352         endPoint(side) = MatrixPoint(matrix, point(0), point(1), point(2))
    Next side
1354     If vertical Then
1355         If Abs(endPoint(0)(0) - endPoint(1)(0)) > 0.000000001 Then Err.Raise 5, , "The " & letter & " section line is not vertical in the base view (its ends are at x = " & NumberList(Array(endPoint(0)(0), endPoint(1)(0))) & " m)"
1356         firstX = endPoint(0)(0)
1357         secondX = endPoint(0)(0)
1358         firstY = bottomEdge - SECTION_MARGIN
1359         secondY = topEdge + SECTION_MARGIN
    Else
1361         If Abs(endPoint(0)(1) - endPoint(1)(1)) > 0.000000001 Then Err.Raise 5, , "The " & letter & " section line is not horizontal in the base view (its ends are at y = " & NumberList(Array(endPoint(0)(1), endPoint(1)(1))) & " m)"
1362         firstX = leftEdge - SECTION_MARGIN
1363         secondX = rightEdge + SECTION_MARGIN
1364         firstY = endPoint(0)(1)
1365         secondY = endPoint(0)(1)
    End If
1367     placeX = fractionX * packageSheetW
1368     placeY = fractionY * packageSheetH
    stepLabel = currentIdentity & ": PackageSection GetName2"
1370     callInputs = "section " & letter & " line(m)=" & NumberList(Array(firstX, firstY, secondX, secondY)) & " in " & source.GetName2() & ", cut normal " & PackageAxisText(cutAxis) & ", view at(m)=" & NumberList(Array(placeX, placeY))
    stepLabel = currentIdentity & ": PackageSection ActivateView"
1372     If Not drawingInterface.ActivateView(source.GetName2()) Then Err.Raise 5, , "ActivateView failed: " & callInputs
    stepLabel = currentIdentity & ": PackageSection ClearSelection2"
1374     doc.ClearSelection2 True
    stepLabel = currentIdentity & ": PackageSection CreateLine" & " " & apiInputs & " " & callInputs
1376     Set segment = doc.SketchManager.CreateLine(firstX, firstY, 0#, secondX, secondY, 0#)
1377     Require segment, "The section line was not created: " & callInputs
    ' The end points as SolidWorks reports them, logged beside the ones asked for (never a failure on its own: it tells whether a view's sketch takes sheet coordinates).
1379     readText = ""
1380     On Error Resume Next
1381     Set sketchLine = segment
    stepLabel = currentIdentity & ": PackageSection GetStartPoint2"
1383     Set lineStart = sketchLine.GetStartPoint2()
    stepLabel = currentIdentity & ": PackageSection GetEndPoint2"
1385     Set lineEnd = sketchLine.GetEndPoint2()
    stepLabel = currentIdentity & ": PackageSection X"
1387     readText = NumberList(Array(lineStart.X, lineStart.Y, lineEnd.X, lineEnd.Y))
1388     If Err.Number <> 0 Then
1389         readText = ""
1390         Err.Clear
    End If
1392     On Error GoTo 0
1393     If Len(readText) = 0 Then
1394         AppendLog currentFolder, currentIdentity, "option", 0, 0, "drawing: section line end points could not be read back"
    Else
1396         AppendLog currentFolder, currentIdentity, "option", 0, 0, "drawing: section line asked at(m)=" & NumberList(Array(firstX, firstY, secondX, secondY)) & ", SolidWorks reports " & readText
    End If
    stepLabel = currentIdentity & ": PackageSection GetSelectedObjectCount2"
1399     If doc.SelectionManager.GetSelectedObjectCount2(-1) <> 1 Then
        ' The new line is normally still selected; when it is not, select it.
1401         RecordMitigation "drawing-section-line-reselect", True, True
    stepLabel = currentIdentity & ": PackageSection ClearSelection2"
1403         doc.ClearSelection2 True
    stepLabel = currentIdentity & ": PackageSection Select4" & " " & apiInputs & " " & callInputs
1405         If Not segment.Select4(False, doc.SelectionManager.CreateSelectData()) Then Err.Raise 5, , "The section line could not be selected: " & callInputs
    stepLabel = currentIdentity & ": PackageSection GetSelectedObjectCount2"
1407         If doc.SelectionManager.GetSelectedObjectCount2(-1) <> 1 Then Err.Raise 5, , CStr(doc.SelectionManager.GetSelectedObjectCount2(-1)) & " objects are selected, not the one section line: " & callInputs
1408         fallbackSuccesses("drawing-section-line-reselect") = fallbackSuccesses("drawing-section-line-reselect") + 1
    End If
    stepLabel = currentIdentity & ": PackageSection CreateSectionViewAt5" & " " & apiInputs & " " & callInputs
1411     Set created = drawingInterface.CreateSectionViewAt5(placeX, placeY, 0#, letter, 0, Nothing, 0#)
1412     Require created, "CreateSectionViewAt5 returned no view: " & callInputs
    stepLabel = currentIdentity & ": PackageSection ClearSelection2"
1414     doc.ClearSelection2 True
1415     PackageCheckScale created, "section", 0#, 0#
1416     found = PackageViewAxis(created)
    stepLabel = currentIdentity & ": PackageSection GetName2"
1418     If found <> cutAxis Then Err.Raise 5, , "The section view " & created.GetName2() & " looks along " & PackageAxisText(found) & ", not along the cut normal " & PackageAxisText(cutAxis) & ": " & callInputs
    stepLabel = currentIdentity & ": PackageSection GetSection"
1420     Set sectionData = created.GetSection()
1421     Require sectionData, "IView.GetSection returned no section data for the new view: " & callInputs
    stepLabel = currentIdentity & ": PackageSection GetLabel"
1423     labelText = CStr(sectionData.GetLabel())
1424     If UCase$(Trim$(labelText)) <> letter Then Err.Raise 5, , "The section view reads back the label " & labelText & ", not " & letter & ": " & callInputs
1425     Set packageViews("section") = created
    stepLabel = currentIdentity & ": PackageSection GetName2"
1427     AppendLog currentFolder, currentIdentity, "option", 0, 0, "drawing: section view " & created.GetName2() & ", label " & labelText & ", looks along " & PackageAxisText(found)
End Sub

Private Sub PackageFinish()
    ' Every display dimension in the drawing, read from the drawing, must be exactly the recipe's.
    Dim listing As String
1433     If packageDimCount = 0 Then listing = DrawingReadBack(Array()) Else listing = DrawingReadBack(packageValues)
1434     If Len(listing) = 0 Then listing = "no dimensions"
1435     AppendLog currentFolder, currentIdentity, "option", 0, 0, "drawing read-back: " & listing
End Sub

Private Sub PackageProperty(ByVal propertyName As String, ByVal propertyText As String)
    ' One title block field as a drawing custom property, set after the privacy blanking and read back.
    Dim manager As Object, valueText As String, resolvedText As String, wasResolved As Boolean
1441     callInputs = "property=" & propertyName
    stepLabel = currentIdentity & ": PackageProperty CustomPropertyManager"
1443     Set manager = doc.Extension.CustomPropertyManager("")
    stepLabel = currentIdentity & ": PackageProperty Add3"
1445     If manager.Add3(propertyName, swCustomInfoText, propertyText, swCustomPropertyReplaceValue) <> 0 Then Err.Raise 5, , "The title block property could not be set: " & callInputs
    stepLabel = currentIdentity & ": PackageProperty Get5"
1447     If manager.Get5(propertyName, False, valueText, resolvedText, wasResolved) = swCustomInfoGetResult_NotPresent Or (valueText <> propertyText And resolvedText <> propertyText) Then
1448         Err.Raise 5, , "The title block property reads back " & valueText & ", not " & propertyText & ": " & callInputs
    End If
1450     packageTitle(propertyName) = propertyText
End Sub

Private Sub PackageTitleCheck()
    ' A look at the title block's own notes: never claims the text is shown on the sheet when the notes do not show it.
    Dim titleBlock As Object, notes As Variant, noteItem As Variant, key As Variant, shown As Boolean, found As Boolean, names As String
1456     shown = False
1457     On Error Resume Next
    stepLabel = currentIdentity & ": PackageTitleCheck TitleBlock"
1459     Set titleBlock = packageSheetObject.TitleBlock
1460     If Err.Number <> 0 Then
1461         Err.Clear
1462         Set titleBlock = Nothing
    End If
1464     If Not titleBlock Is Nothing Then
    stepLabel = currentIdentity & ": PackageTitleCheck GetNotes"
1466         notes = titleBlock.GetNotes()
1467         If Err.Number <> 0 Then
1468             Err.Clear
1469             notes = Empty
        End If
    End If
1472     On Error GoTo 0
1473     If Not titleBlock Is Nothing Then
1474         shown = True
    stepLabel = currentIdentity & ": PackageTitleCheck Keys"
1476         For Each key In packageTitle.Keys
1477             found = False
1478             If IsArray(notes) Then
1479                 For Each noteItem In notes
    stepLabel = currentIdentity & ": PackageTitleCheck GetText"
1481                     If InStr(1, CStr(noteItem.GetText()), CStr(packageTitle(key)), vbBinaryCompare) > 0 Then found = True
                Next noteItem
            End If
1484             If Not found Then shown = False
        Next key
    End If
    stepLabel = currentIdentity & ": PackageTitleCheck Keys"
1488     For Each key In packageTitle.Keys
1489         If Len(names) > 0 Then names = names & ", "
1490         names = names & CStr(key)
    Next key
1492     If Not shown Then
        ' The properties are set and read back; the sheet's title block does not show their text (no title block, or one that does not link them).
1494         RecordMitigation "title-block-property-only", True, True
1495         fallbackSuccesses("title-block-property-only") = fallbackSuccesses("title-block-property-only") + 1
1496         AppendLog currentFolder, currentIdentity, "option", 0, 0, "title block: the properties " & names & " are set and read back; the sheet's title block notes do not show their text, so it is not claimed as shown"
    Else
1498         AppendLog currentFolder, currentIdentity, "option", 0, 0, "title block: the properties " & names & " are set, read back, and shown in the title block notes"
    End If
End Sub

Private Function PackageCount() As Long
1503     PackageCount = 10
End Function

Private Function PackageId(ByVal index As Long) As String
1507     Select Case index
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
1522     Select Case index
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
1538     PackageExtension = ".sldprt"
1539     Select Case index
        Case 9: PackageExtension = ".sldasm"
    End Select
End Function

Private Function PackageDocType(ByVal index As Long) As Long
1545     PackageDocType = swDocPART
1546     If PackageExtension(index) = ".sldasm" Then PackageDocType = swDocASSEMBLY
End Function

Private Function PackageState(ByVal index As Long) As Long
    ' 0 drawn, 1 not scripted (PackageReason says why)
1551     Select Case index
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
1566     Select Case index
    End Select
End Function

Private Sub BuildPackage(ByVal index As Long)
1571     Select Case index
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
1586     Select Case index
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
1601     PackageStart "F04a.sldprt", Array(-10.0#, -15.0#, 0.0#), Array(10.0#, 15.0#, 10.0#)
1602     PackageSheet 2, 0, 6, 0.297#, 0.21#, 1.0#, 1.0#
1603     PackageBase "*Bottom", 1, 0, 2, 0.34#, 0.45#
1604     PackageProjected "beside", 0, 1, 0.57#, 0.45#, 0.1#, 0.45#
1605     PackageProjected "vertical", 2, 1, 0.34#, 0.8#, 0.34#, 0.12#
1606     PackageIso 1.0#, 2.0#, 0.83#, 0.2#
1607     PackageDimension 20.0#, Array(-10.0#, -15.0#, 10.0#), Array(10.0#, -15.0#, 10.0#)
1608     PackageDimension 30.0#, Array(-10.0#, -15.0#, 10.0#), Array(-10.0#, 15.0#, 10.0#)
1609     PackageDimension 10.0#, Array(10.0#, -15.0#, 0.0#), Array(10.0#, -15.0#, 10.0#)
1610     PackageDimension 10.0#, Array(-10.0#, 0.0#, 10.0#), Array(0.0#, 0.0#, 10.0#)
1611     PackageDimension 15.0#, Array(0.0#, -15.0#, 10.0#), Array(0.0#, 0.0#, 10.0#)
1612     PackageSection "A", 0, 2, True, 0.0#, 0.83#, 0.65#
End Sub

Private Sub BuildPackageTitle0()
1616     PackageProperty "Title", "F04a drawing"
1617     PackageProperty "DrawnBy", "Fixture Builder"
1618     PackageTitleCheck
End Sub

Private Sub BuildPackage1()
1622     PackageStart "D04a.sldprt", Array(0.0#, 0.0#, 0.0#), Array(40.0#, 30.0#, 30.0#)
1623     PackageSheet 2, 0, 6, 0.297#, 0.21#, 1.0#, 1.0#
1624     PackageBase "*Bottom", 1, 0, 2, 0.34#, 0.45#
1625     PackageProjected "beside", 0, 1, 0.57#, 0.45#, 0.1#, 0.45#
1626     PackageProjected "vertical", 2, 1, 0.34#, 0.8#, 0.34#, 0.12#
1627     PackageIso 1.0#, 2.0#, 0.83#, 0.2#
1628     PackageDimension 40.0#, Array(0.0#, 0.0#, 0.0#), Array(40.0#, 0.0#, 0.0#)
1629     PackageDimension 30.0#, Array(0.0#, 0.0#, 0.0#), Array(0.0#, 0.0#, 30.0#)
1630     PackageDimension 5.0#, Array(40.0#, 0.0#, 0.0#), Array(40.0#, 0.0#, 5.0#)
1631     PackageDimension 25.0#, Array(0.0#, 15.0#, 5.0#), Array(25.0#, 15.0#, 5.0#)
1632     PackageSection "A", 0, 2, True, 25.0#, 0.83#, 0.65#
End Sub

Private Sub BuildPackageTitle1()
1636     PackageProperty "Title", "D04a drawing"
1637     PackageProperty "DrawnBy", "Fixture Builder"
1638     PackageTitleCheck
End Sub

Private Sub BuildPackage2()
1642     PackageStart "D06a.sldprt", Array(0.0#, 0.0#, 0.0#), Array(60.0#, 40.0#, 10.0#)
1643     PackageSheet 2, 0, 6, 0.297#, 0.21#, 1.0#, 1.0#
1644     PackageBase "*Bottom", 1, 0, 2, 0.34#, 0.45#
1645     PackageProjected "beside", 0, 1, 0.57#, 0.45#, 0.1#, 0.45#
1646     PackageProjected "vertical", 2, 1, 0.34#, 0.8#, 0.34#, 0.12#
1647     PackageIso 1.0#, 2.0#, 0.83#, 0.2#
1648     PackageDimension 60.0#, Array(0.0#, 0.0#, 0.0#), Array(60.0#, 0.0#, 0.0#)
1649     PackageDimension 40.0#, Array(0.0#, 0.0#, 10.0#), Array(0.0#, 40.0#, 10.0#)
1650     PackageDimension 10.0#, Array(60.0#, 0.0#, 0.0#), Array(60.0#, 0.0#, 10.0#)
1651     PackageDimension 20.0#, Array(0.0#, 20.0#, 10.0#), Array(20.0#, 20.0#, 10.0#)
1652     PackageDimension 20.0#, Array(60.0#, 0.0#, 10.0#), Array(60.0#, 20.0#, 10.0#)
1653     PackageSection "A", 0, 2, True, 20.0#, 0.83#, 0.65#
End Sub

Private Sub BuildPackageTitle2()
1657     PackageProperty "Title", "D06a drawing"
1658     PackageProperty "DrawnBy", "Fixture Builder"
1659     PackageTitleCheck
End Sub

Private Sub BuildPackage3()
1663     PackageStart "P03a.sldprt", Array(-10.0#, -15.0#, 0.0#), Array(10.0#, 15.0#, 10.0#)
1664     PackageSheet 2, 0, 6, 0.297#, 0.21#, 1.0#, 1.0#
1665     PackageBase "*Bottom", 1, 0, 2, 0.34#, 0.45#
1666     PackageProjected "beside", 0, 1, 0.57#, 0.45#, 0.1#, 0.45#
1667     PackageProjected "vertical", 2, 1, 0.34#, 0.8#, 0.34#, 0.12#
1668     PackageIso 1.0#, 2.0#, 0.83#, 0.2#
1669     PackageDimension 20.0#, Array(-10.0#, -15.0#, 10.0#), Array(10.0#, -15.0#, 10.0#)
1670     PackageDimension 30.0#, Array(-10.0#, -15.0#, 10.0#), Array(-10.0#, 15.0#, 10.0#)
1671     PackageDimension 10.0#, Array(10.0#, -15.0#, 0.0#), Array(10.0#, -15.0#, 10.0#)
1672     PackageDimension 10.0#, Array(-10.0#, 0.0#, 10.0#), Array(0.0#, 0.0#, 10.0#)
1673     PackageDimension 15.0#, Array(0.0#, -15.0#, 10.0#), Array(0.0#, 0.0#, 10.0#)
1674     PackageSection "A", 0, 2, True, 0.0#, 0.83#, 0.65#
End Sub

Private Sub BuildPackageTitle3()
1678     PackageProperty "Title", "P03a drawing"
1679     PackageProperty "DrawnBy", "Fixture Builder"
1680     PackageTitleCheck
End Sub

Private Sub BuildPackage4()
1684     PackageStart "P03b.sldprt", Array(-10.0#, -15.0#, 0.0#), Array(10.0#, 15.0#, 10.0#)
1685     PackageSheet 2, 0, 6, 0.297#, 0.21#, 1.0#, 1.0#
1686     PackageBase "*Bottom", 1, 0, 2, 0.34#, 0.45#
1687     PackageProjected "beside", 0, 1, 0.57#, 0.45#, 0.1#, 0.45#
1688     PackageProjected "vertical", 2, 1, 0.34#, 0.8#, 0.34#, 0.12#
1689     PackageIso 1.0#, 2.0#, 0.83#, 0.2#
1690     PackageDimension 20.0#, Array(-10.0#, -15.0#, 10.0#), Array(10.0#, -15.0#, 10.0#)
1691     PackageDimension 30.0#, Array(-10.0#, -15.0#, 10.0#), Array(-10.0#, 15.0#, 10.0#)
1692     PackageDimension 10.0#, Array(10.0#, -15.0#, 0.0#), Array(10.0#, -15.0#, 10.0#)
1693     PackageDimension 10.0#, Array(-10.0#, 0.0#, 10.0#), Array(0.0#, 0.0#, 10.0#)
1694     PackageDimension 15.0#, Array(0.0#, -15.0#, 10.0#), Array(0.0#, 0.0#, 10.0#)
1695     PackageSection "A", 0, 2, True, 0.0#, 0.83#, 0.65#
End Sub

Private Sub BuildPackageTitle4()
1699     PackageProperty "Title", "P03b drawing"
1700     PackageProperty "DrawnBy", "Fixture Builder"
1701     PackageTitleCheck
End Sub

Private Sub BuildPackage5()
1705     PackageStart "P07a.sldprt", Array(0.0#, 0.0#, 0.0#), Array(60.0#, 40.0#, 5.0#)
1706     PackageSheet 2, 0, 6, 0.297#, 0.21#, 1.0#, 1.0#
1707     PackageBase "*Bottom", 1, 0, 2, 0.34#, 0.45#
1708     PackageProjected "beside", 0, 1, 0.57#, 0.45#, 0.1#, 0.45#
1709     PackageProjected "vertical", 2, 1, 0.34#, 0.8#, 0.34#, 0.12#
1710     PackageIso 1.0#, 2.0#, 0.83#, 0.2#
1711     PackageDimension 60.0#, Array(0.0#, 0.0#, 5.0#), Array(60.0#, 0.0#, 5.0#)
1712     PackageDimension 40.0#, Array(0.0#, 0.0#, 5.0#), Array(0.0#, 40.0#, 5.0#)
1713     PackageDimension 5.0#, Array(60.0#, 0.0#, 0.0#), Array(60.0#, 0.0#, 5.0#)
1714     PackageDimension 5.0#, Array(0.0#, 5.0#, 5.0#), Array(5.0#, 5.0#, 5.0#)
1715     PackageDimension 10.0#, Array(5.0#, 5.0#, 5.0#), Array(15.0#, 5.0#, 5.0#)
1716     PackageDimension 10.0#, Array(5.0#, 5.0#, 5.0#), Array(5.0#, 15.0#, 5.0#)
1717     PackageSection "A", 0, 2, True, 5.0#, 0.83#, 0.65#
End Sub

Private Sub BuildPackageTitle5()
1721     PackageProperty "Title", "P07a drawing"
1722     PackageProperty "DrawnBy", "Fixture Builder"
1723     PackageTitleCheck
End Sub

Private Sub BuildPackage6()
1727     PackageStart "P08a.sldprt", Array(-30.0#, -30.0#, 0.0#), Array(30.0#, 30.0#, 5.0#)
1728     PackageSheet 2, 0, 6, 0.297#, 0.21#, 1.0#, 1.0#
1729     PackageBase "*Bottom", 1, 0, 2, 0.34#, 0.45#
1730     PackageProjected "beside", 0, 1, 0.57#, 0.45#, 0.1#, 0.45#
1731     PackageProjected "vertical", 2, 1, 0.34#, 0.8#, 0.34#, 0.12#
1732     PackageIso 1.0#, 2.0#, 0.83#, 0.2#
1733     PackageDimension 60.0#, Array(-30.0#, 0.0#, 5.0#), Array(30.0#, 0.0#, 5.0#)
1734     PackageDimension 5.0#, Array(30.0#, 0.0#, 0.0#), Array(30.0#, 0.0#, 5.0#)
1735     PackageDimension 20.0#, Array(0.0#, 0.0#, 5.0#), Array(20.0#, 0.0#, 5.0#)
1736     PackageDimension 40.0#, Array(-20.0#, 0.0#, 5.0#), Array(20.0#, 0.0#, 5.0#)
1737     PackageSection "A", 0, 2, True, 20.0#, 0.83#, 0.65#
End Sub

Private Sub BuildPackageTitle6()
1741     PackageProperty "Title", "P08a drawing"
1742     PackageProperty "DrawnBy", "Fixture Builder"
1743     PackageTitleCheck
End Sub

Private Sub BuildPackage7()
1747     PackageStart "P06a.sldprt", Array(-10.0#, -15.0#, 0.0#), Array(10.0#, 15.0#, 10.0#)
1748     PackageSheet 2, 0, 6, 0.297#, 0.21#, 1.0#, 1.0#
1749     PackageBase "*Bottom", 1, 0, 2, 0.34#, 0.45#
1750     PackageProjected "beside", 0, 1, 0.57#, 0.45#, 0.1#, 0.45#
1751     PackageProjected "vertical", 2, 1, 0.34#, 0.8#, 0.34#, 0.12#
1752     PackageIso 1.0#, 2.0#, 0.83#, 0.2#
1753     PackageDimension 20.0#, Array(-10.0#, -15.0#, 10.0#), Array(10.0#, -15.0#, 10.0#)
1754     PackageDimension 30.0#, Array(-10.0#, -15.0#, 10.0#), Array(-10.0#, 15.0#, 10.0#)
1755     PackageDimension 10.0#, Array(10.0#, -15.0#, 0.0#), Array(10.0#, -15.0#, 10.0#)
1756     PackageDimension 1.5#, Array(-10.0#, 0.0#, 10.0#), Array(-8.5#, 0.0#, 10.0#)
1757     PackageDimension 1.5#, Array(0.0#, -15.0#, 10.0#), Array(0.0#, -13.5#, 10.0#)
1758     PackageSection "A", 0, 2, True, 0.0#, 0.83#, 0.65#
End Sub

Private Sub BuildPackageTitle7()
1762     PackageProperty "Title", "P06a drawing"
1763     PackageProperty "DrawnBy", "Fixture Builder"
1764     PackageTitleCheck
End Sub

Private Sub BuildPackage8()
1768     PackageStart "P06b.sldprt", Array(-10.0#, -15.0#, 0.0#), Array(10.0#, 15.0#, 10.0#)
1769     PackageSheet 2, 0, 6, 0.297#, 0.21#, 1.0#, 1.0#
1770     PackageBase "*Bottom", 1, 0, 2, 0.34#, 0.45#
1771     PackageProjected "beside", 0, 1, 0.57#, 0.45#, 0.1#, 0.45#
1772     PackageProjected "vertical", 2, 1, 0.34#, 0.8#, 0.34#, 0.12#
1773     PackageIso 1.0#, 2.0#, 0.83#, 0.2#
1774     PackageDimension 20.0#, Array(-10.0#, -15.0#, 10.0#), Array(10.0#, -15.0#, 10.0#)
1775     PackageDimension 30.0#, Array(-10.0#, -15.0#, 10.0#), Array(-10.0#, 15.0#, 10.0#)
1776     PackageDimension 10.0#, Array(10.0#, -15.0#, 0.0#), Array(10.0#, -15.0#, 10.0#)
1777     PackageDimension 2.0#, Array(-10.0#, 0.0#, 10.0#), Array(-8.0#, 0.0#, 10.0#)
1778     PackageDimension 2.0#, Array(0.0#, -15.0#, 10.0#), Array(0.0#, -13.0#, 10.0#)
1779     PackageSection "A", 0, 2, True, 0.0#, 0.83#, 0.65#
End Sub

Private Sub BuildPackageTitle8()
1783     PackageProperty "Title", "P06b drawing"
1784     PackageProperty "DrawnBy", "Fixture Builder"
1785     PackageTitleCheck
End Sub

Private Sub BuildPackage9()
1789     PackageStart "F10a.sldasm", Array(-10.0#, -15.0#, 0.0#), Array(10.0#, 15.0#, 30.0#)
1790     PackageAssembly Array(Array("block", Array(-0.01#, -0.015#, 0.0#), Array(0.01#, 0.015#, 0.01#), Array(0.0#, 0.0#, 0.0#)), Array("pin", Array(-0.0025#, -0.0025#, 0.01#), Array(0.0025#, 0.0025#, 0.03#), Array(0.0#, 0.0#, 0.01#)))
1791     PackageSheet 2, 0, 6, 0.297#, 0.21#, 1.0#, 1.0#
1792     PackageBase "*Bottom", 1, 0, 2, 0.34#, 0.45#
1793     PackageProjected "beside", 0, 1, 0.57#, 0.45#, 0.1#, 0.45#
1794     PackageProjected "vertical", 2, 1, 0.34#, 0.8#, 0.34#, 0.12#
1795     PackageIso 1.0#, 2.0#, 0.83#, 0.2#
1796     PackageDimension 20.0#, Array(-10.0#, -15.0#, 0.0#), Array(10.0#, -15.0#, 0.0#)
1797     PackageDimension 30.0#, Array(-10.0#, -15.0#, 0.0#), Array(-10.0#, 15.0#, 0.0#)
1798     PackageDimension 10.0#, Array(10.0#, -15.0#, 0.0#), Array(10.0#, -15.0#, 10.0#)
1799     PackageDimension 20.0#, Array(2.5#, 0.0#, 10.0#), Array(2.5#, 0.0#, 30.0#)
1800     PackageDimension 5.0#, Array(-2.5#, 0.0#, 30.0#), Array(2.5#, 0.0#, 30.0#)
1801     PackagePartsList 2, 0.97#, 0.95#, Array(Array("block", 1), Array("pin", 1))
End Sub

Private Sub BuildPackageTitle9()
1805     PackageProperty "Title", "F10a drawing"
1806     PackageProperty "DrawnBy", "Fixture Builder"
1807     PackageTitleCheck
End Sub

Private Function IsUnattended() As Boolean
1811     IsUnattended = (Trim$(Environ$("FIXTURE_UNATTENDED")) = "1")
End Function

Private Sub EnsureFolder(ByVal fs As Object, ByVal path As String)
    Dim parent As String
    stepLabel = currentIdentity & ": EnsureFolder FolderExists"
1817     If fs.FolderExists(path) Then Exit Sub
    stepLabel = currentIdentity & ": EnsureFolder GetParentFolderName"
1819     parent = fs.GetParentFolderName(path)
1820     If Len(parent) > 0 Then EnsureFolder fs, parent
    stepLabel = currentIdentity & ": EnsureFolder CreateFolder" & " " & apiInputs & " " & callInputs
1822     fs.CreateFolder path
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
1836     On Error Resume Next
1837     If variable = "MYDOCUMENTS" Then
1838         value = CreateObject("WScript.Shell").SpecialFolders("MyDocuments")
    Else
1840         value = CreateObject("WScript.Shell").ExpandEnvironmentStrings("%" & variable & "%")
1841         If value = "%" & variable & "%" Then value = ""
    End If
1843     If Err.Number <> 0 Then value = ""
1844     Err.Clear
1845     EnvText = Trim$(value)
End Function

Private Function DefaultOutputRoot() As String
    Dim pub As String, result As String
1850     pub = Replace(EnvText("PUBLIC"), "/", "\")
1851     Do While Len(pub) > 0 And Right$(pub, 1) = "\"
1852         pub = Left$(pub, Len(pub) - 1)
    Loop
1854     If Len(pub) = 0 Then
1855         result = "C:\FixtureBuilder"
    Else
1857         result = pub & "\Documents\FixtureBuilder"
    End If
1859     DefaultOutputRoot = result
End Function

Private Function UserNameNotice() As String
1863     UserNameNotice = "SolidWorks writes your Windows user name into each file it saves. We keep these native files private and publish only STEP and files we've checked clean; to keep your name out of the files entirely, run SolidWorks under a neutral Windows account."
End Function

Private Function NameInsideComponents(ByVal user As String) As Boolean
    ' A word-matched name: 3 or more characters and not a common word. It is matched wherever the characters on both sides are not ASCII
    ' letters or digits (the start of the text, a tab, a quote, a length byte, "-", "_" ...); any other name (and a shorter one) only as a
    ' whole path segment. The same for the user name, the profile folder's own name and the computer, domain and logon-server names.
    Dim inside As Boolean
1871     inside = (Len(user) >= 3)
1872     If InStr("|admin|user|users|owner|public|default|test|cad|work|data|home|the|and|pro|dev|lab|app|sys|doc|docs|temp|office|pc|laptop|desktop|", "|" & user & "|") > 0 Then inside = False
1873     NameInsideComponents = inside
End Function

Private Function IsAsciiAlnum(ByVal ch As String) As Boolean
1877     IsAsciiAlnum = (ch Like "[A-Za-z0-9]")
End Function

Private Function WordIn(ByVal text As String, ByVal needle As String) As Boolean
    ' The needle in the text with no ASCII letter or digit next to it (or the edge of the text): both already lower-cased.
    Dim pos As Long, before As String, after As String, found As Boolean
1883     If Len(needle) > 0 Then
1884         pos = InStr(1, text, needle, vbBinaryCompare)
1885         Do While pos > 0 And Not found
1886             before = ""
1887             after = ""
1888             If pos > 1 Then before = Mid$(text, pos - 1, 1)
1889             If pos + Len(needle) <= Len(text) Then after = Mid$(text, pos + Len(needle), 1)
1890             If (Len(before) = 0 Or Not IsAsciiAlnum(before)) And (Len(after) = 0 Or Not IsAsciiAlnum(after)) Then found = True
1891             pos = InStr(pos + 1, text, needle, vbBinaryCompare)
        Loop
    End If
1894     WordIn = found
End Function

Private Function SegmentMatches(ByVal part As String, ByVal needle As String) As Boolean
    Dim hit As Boolean
1899     If Len(needle) > 0 Then hit = (part = needle)
1900     If Len(needle) > 0 And Not hit Then
1901         If NameInsideComponents(needle) Then hit = WordIn(part, needle)
    End If
1903     SegmentMatches = hit
End Function

Private Function NormalPath(ByVal path As String) As String
    Dim p As String
1908     p = LCase$(Replace(Trim$(path), "/", "\"))
1909     Do While Len(p) > 0 And Right$(p, 1) = "\"
1910         p = Left$(p, Len(p) - 1)
    Loop
1912     NormalPath = p
End Function

Private Function LeafOf(ByVal normal As String) As String
1916     LeafOf = Mid$(normal, InStrRev(normal, "\") + 1)
End Function

Private Function UnderRoot(ByVal p As String, ByVal root As String) As Boolean
    Dim under As Boolean
1921     If Len(root) > 0 Then under = (p = root Or Left$(p, Len(root) + 1) = root & "\")
1922     UnderRoot = under
End Function

Private Function PersonalPathRefusal(ByVal what As String, ByVal why As String) As String
1926     PersonalPathRefusal = "The " & what & " was refused because " & why & ". " & _
        "SolidWorks stores this path inside every assembly and drawing it saves, so the files you send would show it. " & _
        "Choose a neutral one instead, for example " & DefaultOutputRoot() & " for the output folder. Nothing was built."
End Function

Private Function DriveRooted(ByVal path As String) As Boolean
    Dim t As String
1933     t = Trim$(path)
1934     DriveRooted = (Len(t) >= 3 And Mid$(t, 1, 1) Like "[A-Za-z]" And Mid$(t, 2, 1) = ":" And (Mid$(t, 3, 1) = "\" Or Mid$(t, 3, 1) = "/"))
End Function

Private Function PersonalWhy(ByVal path As String, ByVal identity As Boolean) As String
    ' With identity False (the default output root, the one folder the builder names itself) only the last two rules apply, so a user called
    ' Documents, Public or FixtureBuilder is not locked out of it. The first of these that applies, on the lower-cased path: inside %USERPROFILE%; inside a OneDrive folder or the redirected Documents
    ' folder; a folder that is, or (guarded names) contains, %USERNAME% or the profile folder's own name; a folder named after the computer,
    ' domain or logon server; a folder whose name contains "onedrive"; a UNC share; a Users\<name> folder that is not Public.
    Dim p As String, profile As String, parts As Variant, i As Long, k As Long, why As String
    Dim names(0 To 1) As String, machines(0 To 2) As String, roots(0 To 3) As String
1944     p = NormalPath(path)
1945     profile = NormalPath(EnvText("USERPROFILE"))
1946     names(0) = LCase$(EnvText("USERNAME"))
1947     names(1) = LeafOf(profile)
1948     machines(0) = LCase$(EnvText("COMPUTERNAME"))
1949     machines(1) = LCase$(EnvText("USERDOMAIN"))
1950     machines(2) = LCase$(Replace(EnvText("LOGONSERVER"), "\", ""))
1951     roots(0) = NormalPath(EnvText("OneDrive"))
1952     roots(1) = NormalPath(EnvText("OneDriveCommercial"))
1953     roots(2) = NormalPath(EnvText("OneDriveConsumer"))
1954     roots(3) = NormalPath(EnvText("MYDOCUMENTS"))
1955     parts = Split(p, "\")
1956     If identity Then
1957         If UnderRoot(p, profile) Then why = "it is inside your user profile folder"
    End If
1959     If Len(why) = 0 And identity Then
1960         For k = 0 To 3
1961             If UnderRoot(p, roots(k)) Then why = "it is inside your OneDrive or redirected Documents folder"
        Next k
    End If
1964     If Len(why) = 0 And identity Then
1965         For k = 0 To 1
1966             If Len(names(k)) > 0 Then
1967                 For i = 0 To UBound(parts)
1968                     If SegmentMatches(CStr(parts(i)), names(k)) Then why = "a folder in its path contains your Windows user name"
                Next i
            End If
        Next k
    End If
1973     If Len(why) = 0 And identity Then
1974         For k = 0 To 2
1975             For i = 0 To UBound(parts)
1976                 If SegmentMatches(CStr(parts(i)), machines(k)) Then why = "a folder in its path is named after this computer, its domain or its logon server"
            Next i
        Next k
    End If
1980     If Len(why) = 0 And identity Then
1981         For i = 0 To UBound(parts)
1982             If InStr(parts(i), "onedrive") > 0 Then why = "a folder in its path is a OneDrive folder"
        Next i
    End If
1985     If Len(why) = 0 And Left$(p, 2) = "\\" Then why = "it is on a network share (a \\server\share path)"
1986     If Len(why) = 0 Then
1987         For i = 0 To UBound(parts) - 1
1988             If parts(i) = "users" And Len(parts(i + 1)) > 0 And parts(i + 1) <> "public" And parts(i + 1) <> "default" And parts(i + 1) <> "all users" And parts(i + 1) <> "shared" Then why = "it is inside the personal folder of a Windows user (a Users\<name> folder)"
        Next i
    End If
    ' Last, and for every folder (the default root too): a folder that is not a full path with a drive letter ("FixtureOut", "..\x",
    ' "%USERPROFILE%\x", which FileSystemObject does not expand) would resolve against SolidWorks' own current folder, which may be under the profile.
1993     If Len(why) = 0 Then
1994         If Not DriveRooted(path) Then why = "the folder must be a full path starting with a drive letter"
    End If
1996     PersonalWhy = why
End Function

Private Function PersonalPathReason(ByVal path As String) As String
    Dim why As String
2001     why = PersonalWhy(path, NormalPath(path) <> NormalPath(DefaultOutputRoot()))
2002     If Len(why) = 0 Then
2003         PersonalPathReason = ""
    Else
2005         PersonalPathReason = PersonalPathRefusal("output folder", why)
    End If
End Function

Private Function PersonalTemplateReason(ByVal kind As String, ByVal path As String) As String
    Dim why As String
2011     why = PersonalWhy(path, True)
2012     If Len(why) = 0 Then
2013         PersonalTemplateReason = ""
    Else
2015         PersonalTemplateReason = "The " & kind & " template SolidWorks would use was refused because " & why & ". " & _
            "A SolidWorks drawing stores the path of its sheet format and template, so the files you send would show it. " & _
            "In SolidWorks, under Tools > Options > Default Templates, choose a " & kind & " template in a neutral folder (for example the SolidWorks install folder or C:\ProgramData). Nothing was built."
    End If
End Function

Private Function EscapeRegex(ByVal text As String) As String
    Dim i As Long, ch As String, result As String
2023     For i = 1 To Len(text)
2024         ch = Mid$(text, i, 1)
2025         If InStr("\.+*?^$()[]{}|-", ch) > 0 Then result = result & "\"
2026         result = result & ch
    Next i
2028     EscapeRegex = result
End Function

Private Function RootPattern(ByVal root As String) As String
    ' A folder path as a pattern that also matches its doubled-backslash (JSON) and forward-slash forms.
2033     RootPattern = Replace(EscapeRegex(root), "\\", "[\\/]+")
End Function

Private Function CaseForms(ByVal word As String) As String
    ' The word as written, lower-cased and upper-cased, as one escaped alternation: VBScript's RegExp folds the case of ASCII letters only, so a
    ' Cyrillic or Greek name written in another case would be missed. LCase$ and UCase$ are Unicode-aware.
2039     CaseForms = "(?:" & EscapeRegex(word) & "|" & EscapeRegex(LCase$(word)) & "|" & EscapeRegex(UCase$(word)) & ")"
End Function

Private Function ScrubNeedle(ByVal regex As Object, ByVal text As String, ByVal needle As String, ByVal marker As String) As String
    ' A word-matched needle wherever no ASCII letter or digit is next to it (start of text, tab, quote ...); any other only as a whole folder name.
    Dim result As String
2045     result = text
2046     If Len(needle) > 0 Then
2047         If NameInsideComponents(LCase$(needle)) Then
2048             regex.Pattern = "(^|[^A-Za-z0-9])" & CaseForms(needle) & "(?=[^A-Za-z0-9]|$)"
2049             result = regex.Replace(result, "$1" & marker)
        Else
2051             regex.Pattern = "([\\/])" & CaseForms(needle) & "(?=[.,;)]*(?:[\\/\s""'<>|:*?]|$))"
2052             result = regex.Replace(result, "$1" & marker)
        End If
    End If
2055     ScrubNeedle = result
End Function

Private Function PrivacyScrub(ByVal text As String) As String
    ' Every message a volunteer might screenshot, every log line and every text file in the output goes through this. In order: the tail
    ' of any path under \Users\<x> (x is not Public; a name with a space, an 8.3 name, a Dropbox (Company) folder: all of it, up to a
    ' quote, a line end, a tab or the sentence end) becomes <user>\<path>; the profile, OneDrive and Documents folders likewise; the
    ' Windows user name and the profile folder's own name (anywhere when guarded, else only as a whole folder name) become <user>; the
    ' computer, domain and logon server names (whole tokens, guarded) become <host>; a \\server\share prefix becomes <share>.
    Dim regex As Object, result As String, roots(0 To 4) As String, names(0 To 1) As String, machines(0 To 2) As String
    Dim k As Long, tailEnd As String, swap As String, exempt As String
2066     tailEnd = "(?=[.,;)]*(?:[""'\r\n<>|]|$))"
2067     exempt = "(?!(?:public|default|all users|shared)(?:[\\/""'\r\n<>|]|$))"
2068     result = text
2069     Set regex = CreateObject("VBScript.RegExp")
2070     regex.Global = True
2071     regex.IgnoreCase = True
2072     regex.Pattern = "([\\/]Users[\\/]+)" & exempt & "[^\\/""'\r\n<>|:*?]+?((?:\\\\|[\\/](?![""']))+)(?:[^""'\r\n<>|\\]|\\\\|\\(?![""']))*"
2073     result = regex.Replace(result, "$1<user>$2<path>")
2074     regex.Pattern = "([\\/]Users[\\/]+)" & exempt & "[^\\/""'\r\n<>|:*?]+?" & tailEnd
2075     result = regex.Replace(result, "$1<user>")
2076     roots(0) = EnvText("USERPROFILE")
2077     roots(1) = EnvText("OneDrive")
2078     roots(2) = EnvText("OneDriveCommercial")
2079     roots(3) = EnvText("MYDOCUMENTS")
2080     roots(4) = EnvText("OneDriveConsumer")
2081     For k = 0 To 4
2082         If Len(roots(k)) > 0 Then
2083             regex.Pattern = RootPattern(roots(k)) & "((?:\\\\|[\\/](?![""']))+)(?:[^""'\r\n<>|\\]|\\\\|\\(?![""']))*"
2084             result = regex.Replace(result, "<user>$1<path>")
2085             regex.Pattern = RootPattern(roots(k))
2086             result = regex.Replace(result, "<user>")
        End If
    Next k
2089     names(0) = EnvText("USERNAME")
2090     names(1) = LeafOf(Replace(EnvText("USERPROFILE"), "/", "\"))
    ' The longer of the two first (jsmith.ACME before jsmith), so no part of the profile folder's name is left behind.
2092     If Len(names(1)) > Len(names(0)) Then
2093         swap = names(0)
2094         names(0) = names(1)
2095         names(1) = swap
    End If
2097     machines(0) = EnvText("COMPUTERNAME")
2098     machines(1) = EnvText("USERDOMAIN")
2099     machines(2) = Replace(EnvText("LOGONSERVER"), "\", "")
2100     For k = 0 To 1
2101         result = ScrubNeedle(regex, result, names(k), "<user>")
    Next k
2103     For k = 0 To 2
2104         result = ScrubNeedle(regex, result, machines(k), "<host>")
    Next k
2106     regex.Pattern = "(^|[^\\/\w:])(?:\\\\|//){1,2}[^\\/\s""'<>|:*?]+(?:\\\\|[\\/](?![""']))+(?:[^""'\r\n<>|\\]|\\\\|\\(?![""']))*"
2107     result = regex.Replace(result, "$1<share>")
2108     PrivacyScrub = result
End Function

Private Function EmptiedLine() As String
    ' "" unless the sweep had to empty or delete a text file it could not clean: then the volunteer is told the zip is incomplete.
2113     If sweepEmptiedCount > 0 Then EmptiedLine = vbLf & CStr(sweepEmptiedCount) & " file(s) could not be cleaned and were emptied: " & sweepEmptied
End Function

Private Function ZipReady(ByVal zipPath As String) As Boolean
    ' The zip exists and holds something (an empty zip is 22 bytes).
    Dim fs As Object
2119     On Error Resume Next
2120     Set fs = CreateObject("Scripting.FileSystemObject")
    stepLabel = currentIdentity & ": ZipReady FileExists"
2122     ZipReady = fs.FileExists(zipPath)
    stepLabel = currentIdentity & ": ZipReady GetFile"
2124     If ZipReady Then ZipReady = (fs.GetFile(zipPath).Size > 22)
2125     If Err.Number <> 0 Then ZipReady = False
2126     Err.Clear
End Function

Private Function ZipErrorHead(ByVal errorFile As String) As String
    ' The first 300 characters of the PowerShell error file, one line, or "no error text".
    Dim fs As Object, stream As Object, text As String
2132     On Error Resume Next
2133     Set fs = CreateObject("Scripting.FileSystemObject")
2134     If fs.FileExists(errorFile) Then
2135         Set stream = fs.OpenTextFile(errorFile, 1)
2136         text = stream.ReadAll
2137         stream.Close
    End If
2139     text = Trim$(Replace(Replace(text, vbCr, " "), vbLf, " "))
2140     If Len(text) > 300 Then text = Left$(text, 300)
2141     If Len(text) = 0 Then text = "no error text"
2142     ZipErrorHead = PrivacyScrub(text)
2143     Err.Clear
End Function

Private Sub ZipRemoveOld(ByVal folder As String)
    ' An old zip or error file of the same name (a manual Send to, an earlier run) never counts and is never shown.
    Dim fs As Object
2149     On Error Resume Next
2150     Set fs = CreateObject("Scripting.FileSystemObject")
    stepLabel = currentIdentity & ": ZipRemoveOld FileExists"
2152     If fs.FileExists(folder & ".zip") Then fs.DeleteFile folder & ".zip", True
    stepLabel = currentIdentity & ": ZipRemoveOld FileExists"
2154     If fs.FileExists(folder & "-zip-error.txt") Then fs.DeleteFile folder & "-zip-error.txt", True
2155     Err.Clear
End Sub

Private Function ZipPowerShell(ByVal folder As String, ByVal errorFile As String) As Boolean
    ' Compress-Archive; a failure is written to errorFile (ASCII) and exits 1. True only if the exit code is 0, the zip exists and holds something,
    ' and no error file was written. The old zip and error file are deleted first.
    Dim command As String, quotedFolder As String, quotedZip As String, quotedError As String, code As Long, fs As Object
2162     ZipRemoveOld folder
2163     quotedFolder = Replace(folder, "'", "''")
2164     quotedZip = Replace(folder & ".zip", "'", "''")
2165     quotedError = Replace(errorFile, "'", "''")
2166     command = "powershell.exe -NoProfile -NonInteractive -Command " & Chr$(34) & _
        "try { Compress-Archive -LiteralPath '" & quotedFolder & "' -DestinationPath '" & quotedZip & "' -Force -ErrorAction Stop } " & _
        "catch { $_ | Out-File -LiteralPath '" & quotedError & "' -Encoding ASCII; exit 1 }" & Chr$(34)
    stepLabel = currentIdentity & ": ZipPowerShell Run"
2170     code = CreateObject("WScript.Shell").Run(command, 0, True)
2171     Set fs = CreateObject("Scripting.FileSystemObject")
    stepLabel = currentIdentity & ": ZipPowerShell FileExists"
2173     ZipPowerShell = (code = 0) And ZipReady(folder & ".zip") And Not fs.FileExists(errorFile)
End Function

Private Function ZipWithShell(ByVal folder As String) As Boolean
    ' In-process zip: an empty zip file, then Shell.Application copies the folder into it. The copy is asynchronous: wait until the
    ' folder's items are all inside, the zip stops growing, or about 120 seconds pass.
    Dim fs As Object, stream As Object, shellObject As Object, zipSpace As Object, parentSpace As Object, innerSpace As Object
    Dim zipPath As String, wanted As Long, started As Date, size As Double, lastSize As Double, steady As Long, pause As Double, complete As Boolean
2181     On Error GoTo Failed
2182     zipPath = folder & ".zip"
2183     Set fs = CreateObject("Scripting.FileSystemObject")
2184     ZipRemoveOld folder
    stepLabel = currentIdentity & ": ZipWithShell CreateTextFile" & " " & apiInputs & " " & callInputs
2186     Set stream = fs.CreateTextFile(zipPath, True)
    stepLabel = currentIdentity & ": ZipWithShell Write"
2188     stream.Write "PK" & Chr(5) & Chr(6) & String(18, 0)
    stepLabel = currentIdentity & ": ZipWithShell Close"
2190     stream.Close
2191     Set shellObject = CreateObject("Shell.Application")
    stepLabel = currentIdentity & ": ZipWithShell Namespace"
2193     Set parentSpace = shellObject.Namespace(CVar(fs.GetParentFolderName(folder)))
    stepLabel = currentIdentity & ": ZipWithShell Namespace"
2195     wanted = shellObject.Namespace(CVar(folder)).Items.Count
    stepLabel = currentIdentity & ": ZipWithShell Namespace"
2197     Set zipSpace = shellObject.Namespace(CVar(zipPath))
    stepLabel = currentIdentity & ": ZipWithShell CopyHere"
2199     zipSpace.CopyHere parentSpace.ParseName(fs.GetFileName(folder))
2200     started = Now
2201     lastSize = -1
2202     Do While DateDiff("s", started, Now) < 120
2203         pause = Timer + 0.25
2204         Do While Timer >= pause - 0.25 And Timer < pause
2205             DoEvents
        Loop
2207         size = 0
    stepLabel = currentIdentity & ": ZipWithShell FileExists"
2209         If fs.FileExists(zipPath) Then size = fs.GetFile(zipPath).Size
    stepLabel = currentIdentity & ": ZipWithShell Count"
2211         If zipSpace.Items.Count >= 1 Then
    stepLabel = currentIdentity & ": ZipWithShell Item"
2213             Set innerSpace = zipSpace.Items.Item(0).GetFolder
2214             If Not innerSpace Is Nothing Then
    stepLabel = currentIdentity & ": ZipWithShell Count"
2216                 If innerSpace.Items.Count >= wanted And size > 22 Then
2217                     If size = lastSize Then steady = steady + 1 Else steady = 0
2218                     If steady >= 8 Then
2219                         complete = True
2220                         Exit Do
                    End If
                End If
            End If
        End If
2225         lastSize = size
    Loop
    ' Only if every item arrived and the zip stopped growing; a timeout part way is not a zip.
2228     ZipWithShell = complete And ZipReady(zipPath)
2229     Exit Function
Failed:
2231     ZipWithShell = False
End Function

Private Function ZipMitigationLine() As String
    ' A `mitigations:` line of the zip step alone (the recipes' lines are written before the zip).
    Dim itemName As Variant, text As String
2237     For Each itemName In Array("zip-verify-retry", "zip-shell-application")
    stepLabel = currentIdentity & ": ZipMitigationLine Exists"
2239         If mitigations.Exists(CStr(itemName)) Then
2240             If Len(text) > 0 Then text = text & " "
2241             text = text & CStr(itemName) & "=" & CStr(mitigations(itemName)) & ",primary-failed=" & CStr(primaryFailures(itemName)) & ",fallback-ok=" & CStr(fallbackSuccesses(itemName))
        End If
    Next itemName
2244     ZipMitigationLine = "mitigations: " & text
End Function

Private Function PrivateRunExtra(ByVal folder As String) As String
    ' "" when the folder holds exactly the files a personal run may zip (results.json, FixtureDrawings.log) and no subfolder; else the other names
    ' (names only), or "a folder that could not be listed".
    Dim fs As Object, item As Object, names As String, leaf As String
2251     On Error GoTo unreadable
2252     Set fs = CreateObject("Scripting.FileSystemObject")
    stepLabel = currentIdentity & ": PrivateRunExtra GetFolder"
2254     For Each item In fs.GetFolder(folder).Files
    stepLabel = currentIdentity & ": PrivateRunExtra Name"
2256         leaf = LCase$(CStr(item.Name))
    stepLabel = currentIdentity & ": PrivateRunExtra Name"
2258         If leaf <> "results.json" And leaf <> "fixturedrawings.log" Then names = names & IIf(Len(names) > 0, ", ", "") & CStr(item.Name)
    Next item
    stepLabel = currentIdentity & ": PrivateRunExtra GetFolder"
2261     For Each item In fs.GetFolder(folder).SubFolders
    stepLabel = currentIdentity & ": PrivateRunExtra Name"
2263         names = names & IIf(Len(names) > 0, ", ", "") & CStr(item.Name) & " (a folder)"
    Next item
2265     PrivateRunExtra = names
2266     Exit Function
unreadable:
2268     PrivateRunExtra = "a folder that could not be listed"
End Function

Private Function MakeZip(ByVal folder As String) As Boolean
    ' folder & ".zip" for the run. Compress-Archive is checked by looking for the file and the error file, not by its exit code alone (field
    ' 2026.11.24.3: exit code 0 and no zip). An old zip or error file is deleted first and before every attempt. Then: all documents closed and a
    ' second Compress-Archive with its error text kept (zip-verify-retry), then a zip written in-process (zip-shell-application). Never raises: the
    ' finish message tells the person what to do by hand. The mitigations are logged in a line of their own.
    Dim zipPath As String, errorFile As String, extra As String
2277     zipPath = folder & ".zip"
2278     errorFile = folder & "-zip-error.txt"
2279     On Error Resume Next
2280     ZipRemoveOld folder
    ' A personal run (the drawings package, after OK): every drawing is private and was moved out, so the folder must hold exactly results.json and
    ' FixtureDrawings.log. Checked before every zip route (both Compress-Archive tries and the Shell.Application fallback zip the whole folder):
    ' anything else there, or a folder that cannot be listed, means no zip.
2284     If privateRun Then
2285         extra = PrivateRunExtra(folder)
2286         If Len(extra) > 0 Then
2287             AppendLog folder, "setup", "zip", 0, 0, "zip: not made: on a personal run the folder may hold only results.json and FixtureDrawings.log; it also holds " & extra
2288             privateStuck = privateStuck & IIf(Len(privateStuck) > 0, ", ", "") & extra
2289             MakeZip = False
2290             Exit Function
        End If
    End If
2293     If ZipPowerShell(folder, errorFile) Then MakeZip = True: Exit Function
2294     Err.Clear
2295     AppendLog folder, "setup", "zip", 0, 0, "zip: no zip was written; " & ZipErrorHead(errorFile)
2296     RecordMitigation "zip-verify-retry", True, True
    stepLabel = currentIdentity & ": MakeZip CloseAllDocuments"
2298     app.CloseAllDocuments True
2299     Err.Clear
2300     If ZipPowerShell(folder, errorFile) Then
2301         fallbackSuccesses("zip-verify-retry") = fallbackSuccesses("zip-verify-retry") + 1
2302         AppendLog folder, "setup", "zip", 0, 0, "zip-verify-retry: the second Compress-Archive wrote the zip"
2303         AppendLog folder, "setup", "zip", 0, 0, ZipMitigationLine()
2304         MakeZip = True: Exit Function
    End If
2306     Err.Clear
2307     AppendLog folder, "setup", "zip", 0, 0, "zip-verify-retry: still no zip; " & ZipErrorHead(errorFile)
2308     RecordMitigation "zip-shell-application", True, True
2309     If ZipWithShell(folder) Then
2310         fallbackSuccesses("zip-shell-application") = fallbackSuccesses("zip-shell-application") + 1
2311         AppendLog folder, "setup", "zip", 0, 0, "zip-shell-application: Shell.Application wrote the zip"
2312         MakeZip = True
    Else
2314         Err.Clear
2315         AppendLog folder, "setup", "zip", 0, 0, "zip-shell-application: no zip either; the folder is complete, the person zips it by hand"
    End If
2317     AppendLog folder, "setup", "zip", 0, 0, ZipMitigationLine()
End Function

Private Function CountStatus(ByVal status As String) As Long
    Dim needle As String
2322     needle = """status"":" & Quote(status) & ",""error"""
2323     CountStatus = (Len(resultRows) - Len(Replace(resultRows, needle, ""))) \ Len(needle)
End Function

Private Sub ReportCleanupError(ByVal folder As String, ByRef finalMessage As String)
    Dim number As Long, lineNumber As Long, description As String, failedStep As String
    lineNumber = Erl: number = Err.Number: description = Err.Description: failedStep = stepLabel
2329     finalMessage = failedStep & " (line " & CStr(lineNumber) & "): " & description
2330     If Len(folder) > 0 Then AppendLog folder, currentIdentity, failedStep, lineNumber, number, description
End Sub

Private Function TryTopologySelect(ByVal topology As SldWorks.Entity, ByVal appendSelection As Boolean, ByVal data As Object) As Boolean
    ' Only the original call is trapped; fallback errors retain their own diagnostics.
2335     On Error GoTo Failed
    stepLabel = currentIdentity & ": TryTopologySelect Select4" & " " & apiInputs & " " & callInputs
2337     TryTopologySelect = topology.Select4(appendSelection, data)
2338     Exit Function
Failed:
2340     TryTopologySelect = False
End Function

Private Sub RecordMitigation(ByVal itemName As String, Optional ByVal primaryFailed As Boolean = False, Optional ByVal always As Boolean = False)
    ' Mitigations log on every revision (SolidWorks 2023 hit the 2026 failures too).
2345     If Not mitigations.Exists(itemName) Then mitigations.Add itemName, 0
2346     mitigations(itemName) = mitigations(itemName) + 1
2347     If primaryFailed Then
2348         If Not primaryFailures.Exists(itemName) Then primaryFailures.Add itemName, 0
2349         If Not fallbackSuccesses.Exists(itemName) Then fallbackSuccesses.Add itemName, 0
2350         primaryFailures(itemName) = primaryFailures(itemName) + 1
    End If
End Sub

Private Function MitigationText() As String
    Dim itemName As Variant, entries As String
2356     For Each itemName In mitigations.Keys
2357         If Len(entries) > 0 Then entries = entries & " "
2358         entries = entries & CStr(itemName) & "=" & CStr(mitigations(itemName))
2359         If primaryFailures.Exists(itemName) Then
2360             entries = entries & ",primary-failed=" & CStr(primaryFailures(itemName)) & ",fallback-ok=" & CStr(fallbackSuccesses(itemName))
        End If
    Next itemName
2363     If Len(entries) = 0 Then entries = "none"
2364     MitigationText = "mitigations: " & entries
End Function

Private Function MitigationJson() As String
    Dim itemName As Variant, entries As String, counts As String
2369     For Each itemName In mitigations.Keys
2370         If Len(entries) > 0 Then entries = entries & ","
2371         counts = "{""count"":" & CStr(mitigations(itemName))
2372         If primaryFailures.Exists(itemName) Then
2373             counts = counts & ",""primary_failed"":" & CStr(primaryFailures(itemName)) & ",""fallback_ok"":" & CStr(fallbackSuccesses(itemName))
        End If
2375         entries = entries & Quote(CStr(itemName)) & ":" & counts & "}"
    Next itemName
2377     MitigationJson = "{" & entries & "}"
End Function

Private Function TryTemplate(ByVal path As String, ByRef tried As String) As String
    Dim fs As Object
2382     Set fs = CreateObject("Scripting.FileSystemObject")
2383     If Len(tried) > 0 Then tried = tried & "; "
2384     tried = tried & path
    stepLabel = currentIdentity & ": TryTemplate FileExists"
2386     If fs.FileExists(path) Then TryTemplate = path
End Function

Private Function ResolveTemplate(ByVal kind As String) As String
    Dim override As String, preference As Long, filename As String, extension As String
    Dim tried As String, candidate As String, defaultTemplate As String, folders As String
    Dim fs As Object, install As String, language As String, folder As Variant, match As String
2393     Set fs = CreateObject("Scripting.FileSystemObject")
2394     Select Case kind
        Case "part"
2396             override = TEMPLATE_PART: preference = swDefaultTemplatePart: filename = "part.prtdot"
        Case "assembly"
2398             override = TEMPLATE_ASSEMBLY: preference = swDefaultTemplateAssembly: filename = "assem.asmdot"
        Case "drawing"
2400             override = TEMPLATE_DRAWING: preference = swDefaultTemplateDrawing: filename = "drawing.drwdot"
    End Select
2402     If Len(override) > 0 Then
2403         candidate = TryTemplate(override, tried)
2404         If Len(candidate) > 0 Then ResolveTemplate = candidate: Exit Function
    End If
    stepLabel = currentIdentity & ": ResolveTemplate GetUserPreferenceStringValue"
2407     defaultTemplate = app.GetUserPreferenceStringValue(preference)
2408     If Len(defaultTemplate) > 0 Then
2409         candidate = TryTemplate(defaultTemplate, tried)
2410         If Len(candidate) > 0 Then ResolveTemplate = candidate: Exit Function
    End If
    stepLabel = currentIdentity & ": ResolveTemplate GetUserPreferenceStringValue"
2413     folders = app.GetUserPreferenceStringValue(swFileLocationsDocumentTemplates)
    stepLabel = currentIdentity & ": ResolveTemplate GetExecutablePath"
2415     install = app.GetExecutablePath()
    stepLabel = currentIdentity & ": ResolveTemplate GetExtensionName"
2417     If LCase$(fs.GetExtensionName(install)) = "exe" Then install = fs.GetParentFolderName(install)
    stepLabel = currentIdentity & ": ResolveTemplate BuildPath"
2419     language = fs.BuildPath(fs.BuildPath(install, "lang"), app.GetCurrentLanguage())
    stepLabel = currentIdentity & ": ResolveTemplate BuildPath"
2421     folders = folders & ";" & language & ";" & fs.BuildPath(language, "Tutorial")
    stepLabel = currentIdentity & ": ResolveTemplate GetExtensionName"
2423     extension = fs.GetExtensionName(filename)
2424     For Each folder In Split(folders, ";")
2425         folder = Trim$(CStr(folder))
2426         If Len(folder) > 0 Then
    stepLabel = currentIdentity & ": ResolveTemplate BuildPath"
2428             candidate = TryTemplate(fs.BuildPath(folder, filename), tried)
2429             If Len(candidate) > 0 Then ResolveTemplate = candidate: Exit Function
    stepLabel = currentIdentity & ": ResolveTemplate BuildPath"
2431             match = fs.BuildPath(folder, "*." & extension)
2432             If Len(tried) > 0 Then tried = tried & "; "
2433             tried = tried & match
    stepLabel = currentIdentity & ": ResolveTemplate FolderExists"
2435             If fs.FolderExists(folder) Then
2436                 match = Dir$(match)
2437                 Do While Len(match) > 0
    stepLabel = currentIdentity & ": ResolveTemplate BuildPath"
2439                     candidate = TryTemplate(fs.BuildPath(folder, match), tried)
2440                     If Len(candidate) > 0 Then ResolveTemplate = candidate: Exit Function
2441                     match = Dir$()
                Loop
            End If
        End If
    Next folder
2446     Err.Raise 5, , kind & " template unavailable. Paths tried: " & tried
End Function

Private Sub Require(ByVal value As Object, ByVal message As String)
2450     If value Is Nothing Then Err.Raise 5, , message
End Sub

Private Sub SaveFile(ByVal path As String)
    Dim errors As Long, warnings As Long, success As Boolean
    stepLabel = currentIdentity & ": SaveFile SaveAs"
2456     success = doc.Extension.SaveAs(path, 0, 1, Nothing, errors, warnings)
2457     If Not success Or errors <> 0 Then Err.Raise 5, , "SolidWorks SaveAs error " & CStr(errors)
2458     ExportGuard path
2459     RecordReadback
End Sub

Private Sub ExportGuard(ByVal path As String)
    ' Right after SolidWorks writes a DXF or a PDF the builder made: a DXF is text and is scrubbed like one; a PDF is scanned for the names (not
    ' rewritten). A PDF with a name in it, a file over 4 MB (too large to check) or one that cannot be read is deleted and the row fails. The
    ' .sld* files are compressed and are not scanned (the stamp in them is documented); a STEP file has its own guard.
    Dim fs As Object, ext As String, text As String, cleaned As String, problem As String
2467     Set fs = CreateObject("Scripting.FileSystemObject")
    stepLabel = currentIdentity & ": ExportGuard GetExtensionName"
2469     ext = LCase$(fs.GetExtensionName(path))
2470     If ext <> "dxf" And ext <> "pdf" Then Exit Sub
    stepLabel = currentIdentity & ": ExportGuard FileExists"
2472     If Not fs.FileExists(path) Then Exit Sub
2473     On Error Resume Next
2474     If ext = "dxf" Then
2475         text = SweepRead(path)
2476         If Err.Number = 0 Then
2477             cleaned = PrivacyScrub(text)
2478             If cleaned <> text Then SweepWrite path, cleaned
        End If
    ElseIf StrayHasNeedle(path) Then
2481         problem = "carried a personal name"
    End If
2483     If Err.Number <> 0 Then
2484         problem = "could not be checked"
2485         If InStr(Err.Description, "size cap") > 0 Then problem = "too large to check (over 4 MB)"
    End If
2487     Err.Clear
2488     On Error GoTo 0
2489     If Len(problem) > 0 Then
2490         If privateRun And ext = "pdf" And problem = "carried a personal name" Then
            ' Agreed at the run folder box (drawings package): the drawing stays, private.
2492             privateKept = True
2493             Exit Sub
        End If
2495         If Not SweepDelete(fs, path) Then SweepTruncate fs, path
2496         Err.Raise 5, , "privacy: " & ext & " " & problem
    End If
End Sub

Private Function SummaryStatus(ByVal field As Long) As String
    ' Ours (Fixture Builder), blank, or written by SolidWorks. Never a value that is not ours.
    Dim value As String, result As String
2503     On Error Resume Next
    stepLabel = currentIdentity & ": SummaryStatus SummaryInfo"
2505     value = CStr(doc.SummaryInfo(field))
2506     If Err.Number <> 0 Then
2507         Err.Clear
2508         result = "not read"
    ElseIf Len(Trim$(value)) = 0 Then
2510         result = "blank"
    ElseIf value = NEUTRAL_VALUE Then
2512         result = NEUTRAL_VALUE
    Else
2514         result = "set by SolidWorks (redacted)"
    End If
2516     SummaryStatus = result
End Function

Private Function StatusRank(ByVal status As String) As Long
    Dim rank As Long
2521     Select Case status
        Case "blank": rank = 1
        Case NEUTRAL_VALUE: rank = 2
        Case "set by SolidWorks (redacted)": rank = 3
        Case Else: rank = 0
    End Select
2527     StatusRank = rank
End Function

Private Sub RecordReadback()
    Dim field As Long, status As String
2532     For field = 2 To 5
2533         status = SummaryStatus(field)
2534         If StatusRank(status) > StatusRank(rbStatus(field)) Then rbStatus(field) = status
    Next field
End Sub

Private Function ReadbackText() As String
    Dim field As Long, labels As Variant, text As String, status As String
2540     labels = Array("author", "keywords", "comment", "savedby")
2541     For field = 2 To 5
2542         status = rbStatus(field)
2543         If Len(status) = 0 Then status = "not read"
2544         text = text & " " & CStr(labels(field - 2)) & "=" & status
    Next field
2546     ReadbackText = "summary info read-back after save:" & text
End Function

Private Function NoticeStep(ByVal launched As Boolean) As String
    ' "" means Cancel: nothing is built. Otherwise the line for the log: whether the notice was shown, and the answer.
    Dim note As String
2552     If launched Then
2553         note = "user name notice: shown by the launcher, answer " & GetSetting("DutchmanFixtures", "SolidWorksBuilder", "NoticeAnswer", "OK")
    ElseIf IsUnattended() Then
2555         note = "user name notice: not shown (unattended run)"
    ElseIf MsgBox(UserNameNotice(), vbOKCancel + vbInformation, "SolidWorks fixtures") = vbOK Then
2557         note = "user name notice: shown, answer OK"
    End If
2559     NoticeStep = note
End Function

Private Function SweepText(ByVal path As String, ByVal charset As String) As String
    Dim stream As Object, text As String
2564     Set stream = CreateObject("ADODB.Stream")
2565     stream.Type = 2
2566     stream.Charset = charset
2567     stream.Open
2568     stream.LoadFromFile path
2569     text = stream.ReadText
2570     stream.Close
2571     SweepText = text
End Function

Private Function SweepReencodes(ByVal text As String, ByRef bytes As Variant) As Boolean
    ' True when the text, encoded as UTF-8, is byte for byte the file: the file really was UTF-8.
    Dim stream As Object, again As Variant, i As Long, same As Boolean
2577     Set stream = CreateObject("ADODB.Stream")
2578     stream.Type = 2
2579     stream.Charset = "utf-8"
2580     stream.Open
2581     stream.WriteText text
2582     stream.Position = 0
2583     stream.Type = 1
2584     stream.Position = 3
2585     again = stream.Read
2586     stream.Close
2587     same = (UBound(again) = UBound(bytes))
2588     If same Then
2589         For i = 0 To UBound(bytes)
2590             If again(i) <> bytes(i) Then same = False: Exit For
        Next i
    End If
2593     SweepReencodes = same
End Function

Private Function SweepRead(ByVal path As String) As String
    ' The file as text, in the encoding it was written in (left in sweepEncoding): UTF-16 or UTF-8 with a byte-order mark, UTF-8 without
    ' one, else the ANSI codepage the builder's own log is written in. A file over 4 MB, NUL bytes without a UTF-16 mark, or any decode
    ' error raises: the caller counts that as a hit (truncate or delete), never as clean.
    Dim stream As Object, bytes As Variant, size As Long, text As String, i As Long, channel As Integer
2601     Set stream = CreateObject("ADODB.Stream")
2602     stream.Type = 1
2603     stream.Open
2604     stream.LoadFromFile path
2605     size = stream.Size
2606     If size > 4194304 Then Err.Raise 5, , "over the sweep size cap"
2607     If size = 0 Then
2608         stream.Close
2609         sweepEncoding = "utf-8"
2610         SweepRead = ""
2611         Exit Function
    End If
2613     bytes = stream.Read
2614     stream.Close
2615     If size >= 2 And bytes(0) = 255 And bytes(1) = 254 Then
2616         sweepEncoding = "utf-16-le-bom"
2617         SweepRead = SweepText(path, "unicode")
2618         Exit Function
    End If
2620     If size >= 2 And bytes(0) = 254 And bytes(1) = 255 Then
2621         sweepEncoding = "utf-16-be-bom"
2622         SweepRead = SweepText(path, "unicodeFFFE")
2623         Exit Function
    End If
2625     If size >= 3 Then
2626         If bytes(0) = 239 And bytes(1) = 187 And bytes(2) = 191 Then
2627             sweepEncoding = "utf-8-bom"
2628             SweepRead = SweepText(path, "utf-8")
2629             Exit Function
        End If
    End If
2632     For i = 0 To UBound(bytes)
2633         If bytes(i) = 0 Then Err.Raise 5, , "NUL bytes without a UTF-16 byte-order mark"
    Next i
2635     text = SweepText(path, "utf-8")
2636     If SweepReencodes(text, bytes) Then
2637         sweepEncoding = "utf-8"
2638         SweepRead = text
2639         Exit Function
    End If
2641     sweepEncoding = "ansi"
2642     channel = FreeFile
2643     Open path For Binary Access Read As #channel
2644     text = Space$(LOF(channel))
2645     Get #channel, , text
2646     Close #channel
2647     SweepRead = text
End Function

Private Sub SweepWrite(ByVal path As String, ByVal text As String)
    ' Back in the encoding SweepRead found (never a different one).
    Dim stream As Object, channel As Integer, fs As Object
2653     Select Case sweepEncoding
        Case "utf-8"
2655             WriteUtf8 path, text
        Case "utf-8-bom", "utf-16-le-bom", "utf-16-be-bom"
2657             Set stream = CreateObject("ADODB.Stream")
2658             stream.Type = 2
2659             If sweepEncoding = "utf-16-le-bom" Then
2660                 stream.Charset = "unicode"
            ElseIf sweepEncoding = "utf-16-be-bom" Then
2662                 stream.Charset = "unicodeFFFE"
            Else
2664                 stream.Charset = "utf-8"
            End If
2666             stream.Open
2667             stream.WriteText text
2668             stream.SaveToFile path, 2
2669             stream.Close
        Case Else
2671             Set fs = CreateObject("Scripting.FileSystemObject")
2672             If fs.FileExists(path) Then fs.DeleteFile path, True
2673             channel = FreeFile
2674             Open path For Binary Access Write As #channel
2675             Put #channel, , text
2676             Close #channel
    End Select
End Sub

Private Function ReadLatin1(ByVal path As String, ByVal cap As Long) As String
    ' Latin-1 maps one byte to one character: the text is the file's bytes (searched, or rewritten byte for byte). Over the cap raises.
    Dim stream As Object, text As String
2683     Set stream = CreateObject("ADODB.Stream")
    stepLabel = currentIdentity & ": ReadLatin1 Type"
2685     stream.Type = 2
    stepLabel = currentIdentity & ": ReadLatin1 Charset"
2687     stream.Charset = "iso-8859-1"
    stepLabel = currentIdentity & ": ReadLatin1 Open"
2689     stream.Open
    stepLabel = currentIdentity & ": ReadLatin1 LoadFromFile"
2691     stream.LoadFromFile path
    stepLabel = currentIdentity & ": ReadLatin1 Size"
2693     If stream.Size > cap Then Err.Raise 5, , "over the size cap"
    stepLabel = currentIdentity & ": ReadLatin1 ReadText"
2695     text = stream.ReadText
    stepLabel = currentIdentity & ": ReadLatin1 Close"
2697     stream.Close
2698     ReadLatin1 = text
End Function

Private Function BytesAsLatin1(ByVal text As String, ByVal charset As String) As String
    ' The text encoded in the charset (utf-8 or unicode = UTF-16-LE), one character per byte; any byte-order mark dropped.
    Dim stream As Object, bytes As Variant, i As Long, skip As Long, result As String
2704     Set stream = CreateObject("ADODB.Stream")
    stepLabel = currentIdentity & ": BytesAsLatin1 Type"
2706     stream.Type = 2
    stepLabel = currentIdentity & ": BytesAsLatin1 Charset"
2708     stream.Charset = charset
    stepLabel = currentIdentity & ": BytesAsLatin1 Open"
2710     stream.Open
    stepLabel = currentIdentity & ": BytesAsLatin1 WriteText"
2712     stream.WriteText text
    stepLabel = currentIdentity & ": BytesAsLatin1 Position"
2714     stream.Position = 0
    stepLabel = currentIdentity & ": BytesAsLatin1 Type"
2716     stream.Type = 1
2717     If charset = "utf-8" Then skip = 3
2718     If charset = "unicode" Then skip = 2
    stepLabel = currentIdentity & ": BytesAsLatin1 Position"
2720     stream.Position = skip
    stepLabel = currentIdentity & ": BytesAsLatin1 Size"
2722     If stream.Size > skip Then
    stepLabel = currentIdentity & ": BytesAsLatin1 Read"
2724         bytes = stream.Read
2725         For i = 0 To UBound(bytes)
2726             result = result & ChrW(bytes(i))
        Next i
    End If
    stepLabel = currentIdentity & ": BytesAsLatin1 Close"
2730     stream.Close
2731     BytesAsLatin1 = result
End Function

Private Function AnsiAsLatin1(ByVal text As String) As String
    ' The single-byte ANSI form (empty when a character does not fit in one byte).
    Dim i As Long, result As String, ok As Boolean
2737     ok = True
2738     For i = 1 To Len(text)
2739         If AscW(Mid$(text, i, 1)) < 0 Or AscW(Mid$(text, i, 1)) > 255 Then ok = False
    Next i
2741     If ok Then
2742         For i = 1 To Len(text)
2743             result = result & ChrW(Asc(Mid$(text, i, 1)) And 255)
        Next i
    End If
2746     AnsiAsLatin1 = result
End Function

Private Function AsciiLower(ByVal text As String) As String
    ' Only A-Z become a-z (LCase$ on the bytes of a file would also change the bytes C0 to DE, which are parts of other characters).
    Dim code As Long
2752     For code = 65 To 90
2753         text = Replace(text, Chr$(code), Chr$(code + 32), 1, -1, vbBinaryCompare)
    Next code
2755     AsciiLower = text
End Function

Private Function NeedleInBytes(ByVal data As String, ByVal needle As String, ByVal wide As Boolean, ByVal word As Boolean) As Boolean
    ' The needle's bytes (one character each) in the file's bytes (the data and the needle with A-Z folded): a word-matched needle (word, decided
    ' on the DECODED name, never on its encoded bytes) with no ASCII letter or digit next to it, any other with a path separator on both sides.
    ' A UTF-16 character is two bytes, so "next to" is two bytes there.
    Dim pos As Long, unit As Long, before As String, after As String, found As Boolean
2763     unit = 1
2764     If wide Then unit = 2
2765     If Len(needle) > 0 Then
2766         pos = InStr(1, data, needle, vbBinaryCompare)
2767         Do While pos > 0 And Not found
2768             before = ""
2769             after = ""
2770             If pos > unit Then before = Mid$(data, pos - unit, 1)
2771             If pos + Len(needle) <= Len(data) Then after = Mid$(data, pos + Len(needle), 1)
2772             If word Then
2773                 If (Len(before) = 0 Or Not IsAsciiAlnum(before)) And (Len(after) = 0 Or Not IsAsciiAlnum(after)) Then found = True
            Else
2775                 If (before = "\" Or before = "/") And (after = "\" Or after = "/") Then found = True
            End If
2777             pos = InStr(pos + 1, data, needle, vbBinaryCompare)
        Loop
    End If
2780     NeedleInBytes = found
End Function

Private Function StrayHasNeedle(ByVal path As String) As Boolean
    ' True when a needle (the user name, the profile folder's name, the computer, domain or logon-server name) is in the file's bytes as
    ' UTF-8, UTF-16-LE or ANSI. A file over 4 MB or one that cannot be read raises.
    ' Each name is tried as written, lower-cased and upper-cased (Unicode-aware), so a Cyrillic name in another case is found too.
    Dim data As String, words(0 To 4) As String, k As Long, hit As Boolean, word As String, forms(0 To 2) As String, f As Long, isWord As Boolean
2788     data = AsciiLower(ReadLatin1(path, 4194304))
2789     words(0) = EnvText("USERNAME")
2790     words(1) = LeafOf(Replace(EnvText("USERPROFILE"), "/", "\"))
2791     words(2) = EnvText("COMPUTERNAME")
2792     words(3) = EnvText("USERDOMAIN")
2793     words(4) = Replace(EnvText("LOGONSERVER"), "\", "")
2794     For k = 0 To 4
2795         word = words(k)
2796         If Len(word) > 0 Then
2797             isWord = NameInsideComponents(LCase$(word))
2798             forms(0) = word
2799             forms(1) = LCase$(word)
2800             forms(2) = UCase$(word)
2801             For f = 0 To 2
2802                 If NeedleInBytes(data, AsciiLower(BytesAsLatin1(forms(f), "utf-8")), False, isWord) Then hit = True
2803                 If NeedleInBytes(data, AsciiLower(BytesAsLatin1(forms(f), "unicode")), True, isWord) Then hit = True
2804                 If Len(AnsiAsLatin1(forms(f))) > 0 Then
2805                     If NeedleInBytes(data, AsciiLower(AnsiAsLatin1(forms(f))), False, isWord) Then hit = True
                Else
2807                     sweepAnsiSkipped = True        ' the codepage cannot hold it: never read as "matches nothing" in silence (PrivacySweep notes it)
                End If
            Next f
        End If
    Next k
2812     StrayHasNeedle = hit
End Function

Private Function SweepDelete(ByVal fs As Object, ByVal path As String) As Boolean
    Dim attempt As Long, done As Boolean
2817     For attempt = 1 To 3
2818         If Not done Then
2819             On Error Resume Next
2820             Err.Clear
2821             If fs.FileExists(path) Then fs.DeleteFile path, True
2822             done = (Err.Number = 0 And Not fs.FileExists(path))
2823             Err.Clear
2824             On Error GoTo 0
        End If
    Next attempt
2827     SweepDelete = done
End Function

Private Function SweepTruncate(ByVal fs As Object, ByVal path As String) As Boolean
    Dim attempt As Long, done As Boolean
2832     For attempt = 1 To 3
2833         If Not done Then
2834             On Error Resume Next
2835             Err.Clear
2836             fs.CreateTextFile(path, True).Close
2837             done = (Err.Number = 0)
2838             Err.Clear
2839             On Error GoTo 0
        End If
    Next attempt
2842     SweepTruncate = done
End Function

Private Sub SweepNote(ByRef notes As String, ByVal note As String)
2846     If Len(notes) > 0 Then notes = notes & " | "
2847     notes = notes & note
End Sub

Private Sub SweepStray(ByVal fs As Object, ByVal path As String, ByVal fileName As String, ByVal ext As String, ByRef notes As String)
    ' A file that is not text and not one the builder made (named in results.json, or the log): its bytes are searched for the needles and
    ' it is deleted on a hit, a cap or an error.
    Dim hit As Boolean, why As String
    ' Case-insensitive: SolidWorks writes .SLDPRT where the row says .sldprt, and that is still the builder's own file. Its own PDF is still
    ' scanned (never rewritten); the .sld* files are compressed and are not.
2856     If InStr(1, resultRows, Chr$(34) & fileName & Chr$(34), vbTextCompare) > 0 And ext <> "pdf" Then Exit Sub
2857     If InStr("|sldprt|sldasm|slddrw|step|dxf|zip|", "|" & ext & "|") > 0 And Len(resultRows) = 0 Then Exit Sub
2858     why = "stray file, name found"
2859     On Error Resume Next
2860     hit = StrayHasNeedle(path)
2861     If Err.Number <> 0 Then
2862         hit = True
2863         why = "stray file, unreadable"
2864         If InStr(Err.Description, "size cap") > 0 Then why = "stray file, too large to check (over 4 MB)"
    End If
2866     Err.Clear
2867     On Error GoTo 0
2868     If Not hit Then Exit Sub
2869     If SweepDelete(fs, path) Then
2870         SweepNote notes, "privacy sweep: " & fileName & " removed (" & why & ")"
    ElseIf SweepTruncate(fs, path) Then
2872         SweepNote notes, "privacy sweep: " & fileName & " truncated (" & why & ")"
    Else
2874         sweepListFailed = True        ' neither clean nor gone: no zip (fail closed)
2875         SweepNote notes, "privacy sweep: " & fileName & " could not be cleaned or removed"
    End If
End Sub

Private Sub SweepFile(ByVal fs As Object, ByVal path As String, ByRef notes As String)
    ' Scrub one file. A text file that cannot be read or written (a lock, no permission) is retried, then truncated to zero bytes, then
    ' deleted; the note says which. Lock files (~$*) and temporary files are deleted. Never raises, so the whole list is always finished.
    Dim fileName As String, ext As String, text As String, cleaned As String, attempt As Long, done As Boolean, reason As String, capped As Boolean
2883     fileName = fs.GetFileName(path)
2884     ext = LCase$(fs.GetExtensionName(path))
2885     If Left$(fileName, 2) = "~$" Or ext = "tmp" Or ext = "temp" Or ext = "partial" Then
2886         If Not SweepDelete(fs, path) Then
2887             If SweepTruncate(fs, path) Then
2888                 SweepNote notes, "privacy sweep: " & fileName & " truncated (could not be removed)"
            Else
2890                 SweepNote notes, "privacy sweep: " & fileName & " could not be removed"
            End If
        End If
2893         Exit Sub
    End If
2895     If InStr("|log|json|txt|csv|tsv|xml|html|htm|md|ini|cfg|yaml|yml|dxf|", "|" & ext & "|") = 0 Then
2896         SweepStray fs, path, fileName, ext, notes
2897         Exit Sub
    End If
2899     For attempt = 1 To 3
2900         If Not done Then
2901             On Error Resume Next
2902             Err.Clear
2903             text = SweepRead(path)
2904             If Err.Number = 0 Then
2905                 cleaned = PrivacyScrub(text)
2906                 If cleaned <> text Then SweepWrite path, cleaned
            End If
2908             done = (Err.Number = 0)
2909             If InStr(Err.Description, "over the sweep size cap") > 0 Then capped = True
2910             Err.Clear
2911             On Error GoTo 0
        End If
    Next attempt
2914     If done Then Exit Sub
2915     reason = "unreadable"
2916     If capped Then reason = "too large to check (over 4 MB)"
2917     sweepEmptiedCount = sweepEmptiedCount + 1
2918     If Len(sweepEmptied) > 0 Then sweepEmptied = sweepEmptied & ", "
2919     sweepEmptied = sweepEmptied & fileName
2920     If SweepTruncate(fs, path) Then
2921         SweepNote notes, "privacy sweep: " & fileName & " truncated (" & reason & ")"
    ElseIf SweepDelete(fs, path) Then
2923         SweepNote notes, "privacy sweep: " & fileName & " removed (" & reason & ")"
    Else
2925         sweepListFailed = True        ' neither clean nor gone: no zip (fail closed)
2926         SweepNote notes, "privacy sweep: " & fileName & " could not be cleaned or removed"
    End If
End Sub

Private Sub SweepListFailure(ByVal dirPath As String, ByRef notes As String)
    ' Any error listing a folder (access denied, a path too long): noted with the scrubbed folder name, and no zip is made (fail closed).
2932     sweepListFailed = True
2933     SweepNote notes, "privacy sweep: could not list " & PrivacyScrub(Mid$(dirPath, InStrRev(dirPath, "\") + 1))
2934     Err.Clear
End Sub

Private Sub SweepFolder(ByVal fs As Object, ByVal dirPath As String, ByRef notes As String)
    Dim item As Object, list As String, entries As Variant, i As Long, here As Object, children As Object
2939     On Error Resume Next
2940     Err.Clear
2941     Set here = fs.GetFolder(dirPath)
2942     If Err.Number = 0 Then Set children = here.Files
2943     If Err.Number = 0 Then
2944         For Each item In children
2945             list = list & item.Path & vbLf
        Next item
    End If
2948     If Err.Number <> 0 Then SweepListFailure dirPath, notes
2949     entries = Split(list, vbLf)
2950     For i = 0 To UBound(entries)
2951         If Len(entries(i)) > 0 Then SweepFile fs, CStr(entries(i)), notes
    Next i
2953     list = ""
2954     If Not here Is Nothing Then Set children = here.SubFolders
2955     If Err.Number = 0 And Not here Is Nothing Then
2956         For Each item In children
2957             list = list & item.Path & vbLf
        Next item
    End If
2960     If Err.Number <> 0 Then SweepListFailure dirPath, notes
2961     entries = Split(list, vbLf)
2962     For i = 0 To UBound(entries)
2963         If Len(entries(i)) > 0 Then SweepFolder fs, CStr(entries(i)), notes
    Next i
End Sub

Private Function PrivacySweep(ByVal folder As String) As String
    ' Before the zip: EVERY file in the output folder, listed in results.json or not. Returns the notes (files truncated or removed).
    Dim fs As Object, notes As String
2970     Set fs = CreateObject("Scripting.FileSystemObject")
2971     SweepFolder fs, folder, notes
2972     If Not fs.FolderExists(folder) Then SweepListFailure folder, notes
2973     If sweepAnsiSkipped Then
2974         SweepNote notes, "privacy sweep: ansi form not applicable (a name has characters the ANSI codepage cannot hold); UTF-8 and UTF-16 searched"
2975         sweepAnsiSkipped = False
    End If
2977     PrivacySweep = notes
End Function

Private Sub BlankProperties()
    Dim configs As Variant, config As Variant, manager As Object, itemName As Variant
    ' swSummInfoField_e: author 2, keywords 3, comment 4, saved-by 5. The neutral name goes into author and (if SolidWorks lets a macro
    ' write it) saved-by; keywords and comment are blank. SolidWorks stamps the saving user again at SaveAs: see RecordReadback.
    stepLabel = currentIdentity & ": BlankProperties SummaryInfo"
2985     doc.SummaryInfo(2) = NEUTRAL_VALUE
    stepLabel = currentIdentity & ": BlankProperties SummaryInfo"
2987     doc.SummaryInfo(3) = ""
    stepLabel = currentIdentity & ": BlankProperties SummaryInfo"
2989     doc.SummaryInfo(4) = ""
2990     On Error Resume Next
    stepLabel = currentIdentity & ": BlankProperties SummaryInfo"
2992     doc.SummaryInfo(5) = NEUTRAL_VALUE
2993     Err.Clear
2994     On Error GoTo 0
    stepLabel = currentIdentity & ": BlankProperties CustomPropertyManager"
2996     Set manager = doc.Extension.CustomPropertyManager("")
2997     For Each itemName In Array("Author", "Company", "DrawnBy", "CheckedBy")
    stepLabel = currentIdentity & ": BlankProperties Delete2"
2999         manager.Delete2 CStr(itemName)
    stepLabel = currentIdentity & ": BlankProperties Add3"
3001         If manager.Add3(CStr(itemName), 30, "", 2) <> 0 Then Err.Raise 5, , "Custom property blanking failed"
    Next itemName
    stepLabel = currentIdentity & ": BlankProperties GetConfigurationNames"
3004     configs = doc.GetConfigurationNames()
3005     If Not IsEmpty(configs) Then
3006         For Each config In configs
    stepLabel = currentIdentity & ": BlankProperties CustomPropertyManager"
3008             Set manager = doc.Extension.CustomPropertyManager(CStr(config))
3009             For Each itemName In Array("Author", "Company", "DrawnBy", "CheckedBy")
    stepLabel = currentIdentity & ": BlankProperties Delete2"
3011                 manager.Delete2 CStr(itemName)
    stepLabel = currentIdentity & ": BlankProperties Add3"
3013                 If manager.Add3(CStr(itemName), 30, "", 2) <> 0 Then Err.Raise 5, , "Custom property blanking failed"
            Next itemName
        Next config
    End If
End Sub

Private Function Quote(ByVal text As String) As String
    Dim code As Long
3021     text = Replace(text, "\", "\\")
3022     text = Replace(text, Chr$(34), "\" & Chr$(34))
3023     text = Replace(text, vbCr, "\r")
3024     text = Replace(text, vbLf, "\n")
3025     text = Replace(text, vbTab, "\t")
3026     For code = 0 To 31
3027         text = Replace(text, Chr$(code), "\u" & Right$("0000" & Hex$(code), 4))
    Next code
3029     Quote = Chr$(34) & text & Chr$(34)
End Function

Private Function CleanError(ByVal text As String) As String
    Dim regex As Object
3034     If InStr(text, "Paths tried: ") > 0 Then CleanError = PrivacyScrub(text): Exit Function
3035     Set regex = CreateObject("VBScript.RegExp")
3036     regex.Global = True
    ' A drive path, a UNC path, or a "/" that begins a word ("mid/pair/block", an instance path in a placement report, is not one).
    ' The privacy scrub runs FIRST (it knows where a personal path ends, spaces and all); the generic strip then takes a drive path to the end of
    ' the line or a quote, like the privacy tail.
3040     text = PrivacyScrub(text)
3041     regex.Pattern = "[A-Za-z]:[\\/][^""'\r\n]*"
3042     text = regex.Replace(text, "<path>")
3043     regex.Pattern = "\\\\[^\s""']+"
3044     text = regex.Replace(text, "<path>")
3045     regex.Pattern = "(^|[\s""'(\[=,;:])/[^\s""']+"
3046     CleanError = PrivacyScrub(regex.Replace(text, "$1<path>"))
End Function

Private Sub WriteUtf8(ByVal path As String, ByVal text As String)
    Dim stream As Object, binaryStream As Object
3051     Set stream = CreateObject("ADODB.Stream")
3052     stream.Type = 2
3053     stream.Charset = "utf-8"
3054     stream.Open
3055     stream.WriteText text
3056     stream.Position = 0
3057     stream.Type = 1
3058     stream.Position = 3
3059     Set binaryStream = CreateObject("ADODB.Stream")
3060     binaryStream.Type = 1
3061     binaryStream.Open
3062     stream.CopyTo binaryStream
3063     binaryStream.SaveToFile path, 2
3064     binaryStream.Close
3065     stream.Close
End Sub

Private Sub Pick(ByVal entity As Object, ByVal appendSelection As Boolean, ByVal mark As Long)
    Dim data As Object, topology As SldWorks.Entity, sketchSegment As SldWorks.SketchSegment
    Dim selected As Boolean, before As Long, afterSelect As Long
3071     If Not replayingPicks Then RememberPick entity, appendSelection, mark
3072     callInputs = callInputs & " append=" & CStr(appendSelection) & " mark=" & CStr(mark)
    stepLabel = currentIdentity & ": Pick CreateSelectData" & " " & apiInputs & " " & callInputs
3074     Set data = doc.SelectionManager.CreateSelectData()
    stepLabel = currentIdentity & ": Pick Mark"
3076     data.Mark = mark
    ' An edge of a drawing view is selected in that view (ISelectData.View).
    stepLabel = currentIdentity & ": Pick View"
3079     If Not pickView Is Nothing Then Set data.View = pickView
    stepLabel = currentIdentity & ": Pick SketchSegment"
3081     If TypeOf entity Is SldWorks.SketchSegment Then
3082         Set sketchSegment = entity
    stepLabel = currentIdentity & ": Pick Select4" & " " & apiInputs & " " & callInputs
3084         If Not sketchSegment.Select4(appendSelection, data) Then Err.Raise 5, , "Sketch segment selection failed"
    Else
3086         Set topology = entity
        ' Baseline BEFORE Select4: round 3 measured it after a Select4 that
        ' returned False yet selected, and the fallback then selected twice.
    stepLabel = currentIdentity & ": Pick GetSelectedObjectCount2"
3090         before = doc.SelectionManager.GetSelectedObjectCount2(-1)
3091         selected = TryTopologySelect(topology, appendSelection, data)
3092         afterSelect = before
3093         If Not selected Then
    stepLabel = currentIdentity & ": Pick GetSelectedObjectCount2"
3095             afterSelect = doc.SelectionManager.GetSelectedObjectCount2(-1)
3096             callInputs = callInputs & " select4=False selected-before=" & CStr(before) & " after-select4=" & CStr(afterSelect)
3097             If Select4Grew(appendSelection, before, afterSelect) Then
3098                 RecordMitigation "select4-false-but-selected", True
3099                 fallbackSuccesses("select4-false-but-selected") = fallbackSuccesses("select4-false-but-selected") + 1
3100                 selected = True
            End If
        End If
3103         If Not selected Then
3104             RecordMitigation "select4->multiselect2", True
    stepLabel = currentIdentity & ": Pick MultiSelect2" & " " & apiInputs & " " & callInputs
3106             If doc.Extension.MultiSelect2(Array(entity), appendSelection, data) <> 1 Then
3107                 If Not AppendCountConfirms(appendSelection, before, afterSelect) Then Err.Raise 5, , "Entity selection failed (Select4 and MultiSelect2)"
            End If
3109             fallbackSuccesses("select4->multiselect2") = fallbackSuccesses("select4->multiselect2") + 1
        End If
    End If
End Sub

Private Sub RememberPick(ByVal entity As Object, ByVal appendSelection As Boolean, ByVal mark As Long)
    ' Keep what Pick selected, for ReplayPicks. A selection that is not appended to starts a new list; more than four entities cannot be kept.
3116     If Not appendSelection Then pickCount = 0
3117     If pickCount < 0 Then Exit Sub
3118     If pickCount > 3 Then
3119         pickCount = -1
3120         Exit Sub
    End If
3122     Set pickEntities(pickCount) = entity
3123     pickAppends(pickCount) = appendSelection
3124     pickMarks(pickCount) = mark
3125     pickCount = pickCount + 1
End Sub

Private Function Select4Grew(ByVal appendSelection As Boolean, ByVal before As Long, ByVal after As Long) As Boolean
    ' Did a Select4 that returned False select anyway? Appending: grew by one.
    ' Replacing: only from an empty selection to one; otherwise fall back.
3131     If appendSelection Then
3132         Select4Grew = (after = before + 1)
    Else
3134         Select4Grew = (before = 0 And after = 1)
    End If
End Function

Private Function AppendCountConfirms(ByVal appendSelection As Boolean, ByVal before As Long, ByVal afterSelect As Long) As Boolean
    ' Revision 34.4.0: an appended MultiSelect2 never returned 1 while the
    ' first, non-appended entity did. Accept it if the selection grew by one
    ' since before Select4.
    Dim after As Long
3143     If Not appendSelection Then Exit Function
3144     RecordMitigation "multiselect2-append-count", True
3145     after = doc.SelectionManager.GetSelectedObjectCount2(-1)
3146     callInputs = callInputs & " selected-before=" & CStr(before) & " after-select4=" & CStr(afterSelect) & " after=" & CStr(after)
3147     stepLabel = stepLabel & " selected-before=" & CStr(before) & " after-select4=" & CStr(afterSelect) & " after=" & CStr(after)
3148     If after <> before + 1 Then Exit Function
3149     fallbackSuccesses("multiselect2-append-count") = fallbackSuccesses("multiselect2-append-count") + 1
3150     AppendCountConfirms = True
End Function

Private Function MatrixUsable(ByVal matrix As Variant) As Boolean
    ' IMathTransform.ArrayData: rotation 0-8, translation 9-11, scale 12.
    Dim i As Long, j As Long, k As Long, first As Long, dot As Double, expected As Double
3156     If Not IsArray(matrix) Then Exit Function
3157     first = LBound(matrix)
3158     If UBound(matrix) - first < 12 Then Exit Function
3159     For i = 0 To 12
3160         If Not IsNumeric(matrix(first + i)) Then Exit Function
    Next i
3162     For i = 0 To 2
3163         For j = 0 To 2
3164             dot = 0#
3165             For k = 0 To 2
3166                 dot = dot + CDbl(matrix(first + 3 * i + k)) * CDbl(matrix(first + 3 * j + k))
            Next k
3168             expected = 0#
3169             If i = j Then expected = 1#
3170             If Abs(dot - expected) > 0.000001 Then Exit Function
        Next j
    Next i
3173     MatrixUsable = Abs(CDbl(matrix(first + 12))) > 0.000000001
End Function

Private Function MatrixPoint(ByVal matrix As Variant, ByVal x As Double, ByVal y As Double, ByVal z As Double) As Variant
    ' Row-vector convention: local = (p x R) * scale + translation.
    Dim first As Long, scaleFactor As Double, result(2) As Double, j As Long
3179     first = LBound(matrix)
3180     scaleFactor = CDbl(matrix(first + 12))
3181     For j = 0 To 2
3182         result(j) = (x * CDbl(matrix(first + j)) + y * CDbl(matrix(first + 3 + j)) + z * CDbl(matrix(first + 6 + j))) * scaleFactor + CDbl(matrix(first + 9 + j))
    Next j
3184     MatrixPoint = Array(result(0), result(1), result(2))
End Function

Private Function NumberList(ByVal values As Variant) As String
    Dim i As Long, text As String
3189     For i = LBound(values) To UBound(values)
3190         If i > LBound(values) Then text = text & ","
3191         text = text & Replace(CStr(values(i)), ",", ".")
    Next i
3193     NumberList = text
End Function

Private Function DrawingDocument(ByVal model As Object) As SldWorks.DrawingDoc
3197     Set DrawingDocument = model
End Function

Private Function ViewDrop(ByVal view As Object) As Long
    ' The model axis a drawing view looks along: the z column of its model-to-view rotation (row-vector
    ' convention). Round 8 (field, 34.4.0): the view beside the Top view has the rows (0,0,1), (-1,0,0),
    ' (0,-1,0), so its z column names X and its z row Y; the rotation only has to be a signed axis
    ' permutation (one +-1 and two zeros in every row and column, within 1e-9). A tilted view fails.
    Dim matrix As Variant, i As Long, j As Long, first As Long, ones As Long, zeros As Long, value As Double
    stepLabel = currentIdentity & ": ViewDrop ArrayData"
3207     matrix = view.ModelToViewTransform.ArrayData
3208     If Not MatrixUsable(matrix) Then Err.Raise 5, , "The drawing view transform is not a rotation"
3209     first = LBound(matrix)
3210     For i = 0 To 5
3211         ones = 0
3212         zeros = 0
3213         For j = 0 To 2
3214             If i < 3 Then
3215                 value = CDbl(matrix(first + 3 * i + j))
            Else
3217                 value = CDbl(matrix(first + 3 * j + (i - 3)))
            End If
3219             If Abs(Abs(value) - 1#) <= 0.000000001 Then ones = ones + 1
3220             If Abs(value) <= 0.000000001 Then zeros = zeros + 1
        Next j
3222         If ones <> 1 Or zeros <> 2 Then Err.Raise 5, , "The drawing view is not an axis-aligned view: its rotation is not a signed axis permutation: " & NumberList(matrix)
    Next i
3224     For i = 0 To 2
3225         If Abs(CDbl(matrix(first + 3 * i + 2))) > 0.5 Then ViewDrop = i
    Next i
End Function

Private Function ViewToModel(ByVal matrix As Variant, ByVal point As Variant) As Variant
    ' Undo IView.ModelToViewTransform: view = (model x R) * scale + t, R orthonormal.
    Dim first As Long, i As Long, j As Long, v(2) As Double, result(2) As Double
3232     first = LBound(matrix)
3233     For j = 0 To 2
3234         v(j) = (CDbl(point(j)) - CDbl(matrix(first + 9 + j))) / CDbl(matrix(first + 12))
    Next j
3236     For i = 0 To 2
3237         For j = 0 To 2
3238             result(i) = result(i) + v(j) * CDbl(matrix(first + 3 * i + j))
        Next j
    Next i
3241     ViewToModel = Array(result(0), result(1), result(2))
End Function

Private Function RotateToModel(ByVal matrix As Variant, ByVal axis As Variant) As Variant
    ' A direction from view space to model space: the rotation of ViewToModel only, no scale and no translation.
    Dim first As Long, i As Long, j As Long, result(2) As Double
3247     first = LBound(matrix)
3248     For i = 0 To 2
3249         For j = 0 To 2
3250             result(i) = result(i) + CDbl(axis(j)) * CDbl(matrix(first + 3 * i + j))
        Next j
    Next i
3253     RotateToModel = Array(result(0), result(1), result(2))
End Function

Private Function FlatPoint(ByVal point As Variant, ByVal drop As Long) As Variant
3257     Select Case drop
        Case 0: FlatPoint = Array(CDbl(point(1)), CDbl(point(2)))
        Case 1: FlatPoint = Array(CDbl(point(0)), CDbl(point(2)))
        Case Else: FlatPoint = Array(CDbl(point(0)), CDbl(point(1)))
    End Select
End Function

Private Function NearFlat(ByVal a As Variant, ByVal b As Variant) As Boolean
3265     NearFlat = Abs(CDbl(a(0)) - CDbl(b(0))) <= 0.000001 And Abs(CDbl(a(1)) - CDbl(b(1))) <= 0.000001
End Function

Private Function InsideBox(ByVal point As Variant, ByVal low As Variant, ByVal high As Variant) As Boolean
    Dim i As Long
3270     For i = 0 To 2
3271         If CDbl(point(i)) < CDbl(low(i)) - 0.000001 Or CDbl(point(i)) > CDbl(high(i)) + 0.000001 Then Exit Function
    Next i
3273     InsideBox = True
End Function

Private Function RecordPoint(ByVal record As Object, ByVal key As String, ByVal convert As Long, ByVal matrix As Variant) As Variant
    ' A record's stored point as model meters: as reported (convert = 0) or with the view transform undone (1).
    Dim stored As Variant
3279     stored = record(key)
3280     If convert = 0 Then
3281         RecordPoint = Array(CDbl(stored(0)), CDbl(stored(1)), CDbl(stored(2)))
    Else
3283         RecordPoint = ViewToModel(matrix, stored)
    End If
End Function

Private Sub AddEdgeRecords(ByVal found As Collection, ByVal raw As Variant)
    ' The line and circle records (entity and the points SolidWorks reports) of an array of IEdge.
    Dim entity As Variant, curve As Object, record As Object, parameters As Variant
3290     For Each entity In raw
    stepLabel = currentIdentity & ": AddEdgeRecords GetCurve"
3292         Set curve = entity.GetCurve()
3293         If Not curve Is Nothing Then
    stepLabel = currentIdentity & ": AddEdgeRecords IsLine"
3295             If curve.IsLine() Then
3296                 Set record = CreateObject("Scripting.Dictionary")
3297                 record("kind") = "line"
3298                 Set record("entity") = entity
    stepLabel = currentIdentity & ": AddEdgeRecords GetPoint"
3300                 record("p0") = entity.GetStartVertex().GetPoint()
    stepLabel = currentIdentity & ": AddEdgeRecords GetPoint"
3302                 record("p1") = entity.GetEndVertex().GetPoint()
    stepLabel = currentIdentity & ": AddEdgeRecords Add"
3304                 found.Add record
            ElseIf curve.IsCircle() Then
    stepLabel = currentIdentity & ": AddEdgeRecords CircleParams"
3307                 parameters = curve.CircleParams
3308                 Set record = CreateObject("Scripting.Dictionary")
3309                 record("kind") = "circle"
3310                 Set record("entity") = entity
3311                 record("p0") = Array(CDbl(parameters(0)), CDbl(parameters(1)), CDbl(parameters(2)))
                ' ICurve.CircleParams: center x, y, z, axis x, y, z, radius.
3313                 record("axis") = Array(CDbl(parameters(3)), CDbl(parameters(4)), CDbl(parameters(5)))
3314                 record("radius") = CDbl(parameters(6))
3315                 record("raw") = Array(CDbl(parameters(0)), CDbl(parameters(1)), CDbl(parameters(2)), CDbl(parameters(3)), CDbl(parameters(4)), CDbl(parameters(5)), CDbl(parameters(6)))
    stepLabel = currentIdentity & ": AddEdgeRecords Add"
3317                 found.Add record
            End If
        End If
    Next entity
End Sub

Private Function ShiftPoint(ByVal point As Variant, ByVal shift As Variant) As Variant
3324     ShiftPoint = Array(CDbl(point(0)) + CDbl(shift(0)), CDbl(point(1)) + CDbl(shift(1)), CDbl(point(2)) + CDbl(shift(2)))
End Function

Private Function ComponentFits(ByVal mine As Collection, ByVal box As Variant, ByVal shift As Variant) As Boolean
    ' Do all the points of one component's edges lie in its box (meters, box(1) low, box(2) high) once moved by `shift`?
    Dim record As Object
3330     For Each record In mine
3331         If Not InsideBox(ShiftPoint(record("p0"), shift), box(1), box(2)) Then Exit Function
3332         If record("kind") = "line" Then
3333             If Not InsideBox(ShiftPoint(record("p1"), shift), box(1), box(2)) Then Exit Function
        End If
    Next record
3336     ComponentFits = True
End Function

Private Sub AddAssemblyEdges(ByVal view As Object, ByVal components As Variant, ByVal found As Collection, ByVal assemblyName As String)
    ' The drawing view of an assembly (D19a): IView.GetVisibleEntities2 takes the component whose edges are wanted (Nothing gives a part's), so each component
    ' the view shows is asked in turn (IView.GetVisibleComponents). components(k) = Array(name, low, high, shift) in meters: the component's box in the assembly
    ' and where its own origin stands there. The reported points are taken as assembly coordinates when they all lie in that box, else as the part's own
    ' coordinates moved by the shift (mitigation drawing-assembly-edges-part-space); when neither fits, the recipe fails naming the component.
    Dim shown As Variant, component As Variant, label As String, k As Long, which As Long, raw As Variant, mine As Collection, record As Object
    Dim shift As Variant, seen As String, viewName As String, moved As Boolean, box As Variant, size As Long, shownNames As String, shownCount As Long
    stepLabel = currentIdentity & ": AddAssemblyEdges GetName2"
3347     viewName = view.GetName2()
    stepLabel = currentIdentity & ": AddAssemblyEdges GetVisibleComponents"
3349     shown = view.GetVisibleComponents()
3350     If Not IsArray(shown) Then Err.Raise 5, , viewName & ": GetVisibleComponents returned no components"
    ' Once per view (the caller keeps the view's edges): what SolidWorks called the components, names only.
3352     For Each component In shown
3353         If shownCount > 0 Then shownNames = shownNames & ", "
    stepLabel = currentIdentity & ": AddAssemblyEdges Name2"
3355         shownNames = shownNames & CStr(component.Name2)
3356         shownCount = shownCount + 1
    Next component
3358     AppendLog currentFolder, currentIdentity, "option", 0, 0, "drawing: view " & viewName & " shows " & CStr(shownCount) & " component" & IIf(shownCount = 1, "", "s") & ": " & shownNames
3359     seen = ","
3360     For Each component In shown
    stepLabel = currentIdentity & ": AddAssemblyEdges Name2"
3362         label = CStr(component.Name2)
3363         If InStr(label, "@") > 0 Then label = Left$(label, InStr(label, "@") - 1)
        ' Only a prefix that is exactly the assembly's own name is removed: a component under any other prefix (sub-1/pin-1) is not top-level and never matches.
3365         If InStr(label, "/") > 0 Then
3366             If StrComp(Left$(label, InStr(label, "/") - 1), assemblyName, vbTextCompare) = 0 And InStr(InStr(label, "/") + 1, label, "/") = 0 Then label = Mid$(label, InStr(label, "/") + 1)
        End If
3368         size = Len(label)
3369         Do While size > 0
3370             If Mid$(label, size, 1) Like "#" Then
3371                 size = size - 1
            Else
3373                 Exit Do
            End If
        Loop
3376         If size > 0 And size < Len(label) Then
3377             If Mid$(label, size, 1) = "-" Then label = Left$(label, size - 1)
        End If
3379         which = -1
3380         For k = 0 To UBound(components)
3381             If StrComp(CStr(components(k)(0)), label, vbTextCompare) = 0 Then which = k
        Next k
3383         If which >= 0 Then
3384             box = components(which)
3385             label = CStr(components(which)(0))
3386             seen = seen & label & ","
    stepLabel = currentIdentity & ": AddAssemblyEdges GetVisibleEntities2"
3388             raw = view.GetVisibleEntities2(component, swViewEntityType_Edge)
3389             If Not IsArray(raw) Then Err.Raise 5, , viewName & ": GetVisibleEntities2 returned no edges for the component " & label
3390             Set mine = New Collection
3391             AddEdgeRecords mine, raw
    stepLabel = currentIdentity & ": AddAssemblyEdges Count"
3393             If mine.Count = 0 Then Err.Raise 5, , viewName & ": GetVisibleEntities2 returned no edges for the component " & label
3394             shift = Array(0#, 0#, 0#)
3395             moved = False
3396             If Not ComponentFits(mine, box, shift) Then
3397                 shift = box(3)
3398                 moved = True
3399                 If Not ComponentFits(mine, box, shift) Then Err.Raise 5, , viewName & ": the edge points of the component " & label & " lie outside its box in assembly coordinates and in part coordinates moved to its place"
            End If
3401             If moved Then
3402                 RecordMitigation "drawing-assembly-edges-part-space", True, True
3403                 fallbackSuccesses("drawing-assembly-edges-part-space") = fallbackSuccesses("drawing-assembly-edges-part-space") + 1
            End If
3405             For Each record In mine
3406                 record("p0") = ShiftPoint(record("p0"), shift)
3407                 If record("kind") = "line" Then record("p1") = ShiftPoint(record("p1"), shift)
3408                 If record("kind") = "circle" Then record("raw") = Array(CDbl(record("p0")(0)), CDbl(record("p0")(1)), CDbl(record("p0")(2)), CDbl(record("raw")(3)), CDbl(record("raw")(4)), CDbl(record("raw")(5)), CDbl(record("raw")(6)))
    stepLabel = currentIdentity & ": AddAssemblyEdges Add"
3410                 found.Add record
            Next record
        End If
    Next component
3414     For k = 0 To UBound(components)
3415         If InStr(seen, "," & CStr(components(k)(0)) & ",") = 0 Then Err.Raise 5, , viewName & ": the view shows no edges of the component " & CStr(components(k)(0)) & "; the view showed: " & shownNames
    Next k
End Sub

Private Function DrawingEdges(ByVal view As Object, ByVal low As Variant, ByVal high As Variant, ByRef drop As Long, ByRef spaceName As String, Optional ByVal components As Variant, Optional ByVal assemblyName As String) As Collection
    ' The view's visible line and circle edges, flattened along its axis, in model meters. Entity
    ' coordinates are taken as model coordinates; if they do not all lie inside the model's box they
    ' are tried as view coordinates, and if that fails too the recipe fails. An assembly's view is read component by component (AddAssemblyEdges).
    Dim matrix As Variant, raw As Variant, found As Collection, record As Object
    Dim convert As Long, ok As Boolean, chosen As Long, viewName As String, axis As Variant, size As Double
    stepLabel = currentIdentity & ": DrawingEdges GetName2"
3426     viewName = view.GetName2()
    stepLabel = currentIdentity & ": DrawingEdges ArrayData"
3428     matrix = view.ModelToViewTransform.ArrayData
3429     drop = ViewDrop(view)
3430     Set found = New Collection
3431     If IsArray(components) Then
3432         AddAssemblyEdges view, components, found, assemblyName
    Else
    stepLabel = currentIdentity & ": DrawingEdges GetVisibleEntities2"
3435         raw = view.GetVisibleEntities2(Nothing, swViewEntityType_Edge)
3436         If Not IsArray(raw) Then Err.Raise 5, , viewName & ": GetVisibleEntities2 returned no edges"
3437         AddEdgeRecords found, raw
    End If
    stepLabel = currentIdentity & ": DrawingEdges Count"
3440     If found.Count = 0 Then Err.Raise 5, , viewName & ": none of its visible edges is a line or a circle"
3441     chosen = -1
3442     For convert = 0 To 1
3443         ok = True
3444         For Each record In found
3445             If Not InsideBox(RecordPoint(record, "p0", convert, matrix), low, high) Then ok = False
3446             If record("kind") = "line" Then
3447                 If Not InsideBox(RecordPoint(record, "p1", convert, matrix), low, high) Then ok = False
            End If
        Next record
3450         If ok Then
3451             chosen = convert
3452             Exit For
        End If
    Next convert
3455     If chosen < 0 Then Err.Raise 5, , viewName & ": the visible edge points lie outside the model box as model coordinates and as view coordinates (transform " & NumberList(matrix) & ")"
3456     spaceName = IIf(chosen = 0, "model", "view")
3457     For Each record In found
3458         record("a") = FlatPoint(RecordPoint(record, "p0", chosen, matrix), drop)
3459         If record("kind") = "line" Then record("b") = FlatPoint(RecordPoint(record, "p1", chosen, matrix), drop)
3460         If record("kind") = "circle" Then
            ' The circle's axis in model space (a view-space axis is only rotated), and whether the view looks straight down it: then it shows as a
            ' circle; otherwise (edge-on) as a straight line through its center, 2 x radius long.
3463             axis = record("axis")
3464             If chosen = 1 Then axis = RotateToModel(matrix, axis)
            ' faceOn: 1 the view looks down the axis, 0 the axis lies across the view, -1 unknown (a zero or non-unit axis, or one at an angle).
3466             size = Sqr(CDbl(axis(0)) * CDbl(axis(0)) + CDbl(axis(1)) * CDbl(axis(1)) + CDbl(axis(2)) * CDbl(axis(2)))
3467             If Abs(size - 1#) > 0.000001 Then
3468                 record("faceOn") = -1
            ElseIf Abs(Abs(CDbl(axis(drop))) - 1#) <= 0.000001 Then
3470                 record("faceOn") = 1
            ElseIf Abs(CDbl(axis(drop))) <= 0.000001 Then
3472                 record("faceOn") = 0
            Else
3474                 record("faceOn") = -1
            End If
3476             record("flatAxis") = FlatPoint(axis, drop)
        End If
    Next record
3479     Set DrawingEdges = found
End Function

Private Function PlanSingle(ByVal records As Collection, ByVal first As Variant, ByVal second As Variant) As Object
    ' A line whose two ends are the two points: selecting it alone dimensions its length.
    Dim record As Object
3485     For Each record In records
3486         If record("kind") = "line" Then
3487             If (NearFlat(record("a"), first) And NearFlat(record("b"), second)) Or (NearFlat(record("a"), second) And NearFlat(record("b"), first)) Then
3488                 Set PlanSingle = record
3489                 Exit Function
            End If
        End If
    Next record
End Function

Private Function CloneRecord(ByVal record As Object, ByVal rung As String) As Object
    ' A copy of an edge record marked with the mitigation name of the plan form that uses it (the cached record itself stays unmarked).
    Dim copy As Object, key As Variant
3498     Set copy = CreateObject("Scripting.Dictionary")
    stepLabel = currentIdentity & ": CloneRecord Keys"
3500     For Each key In record.Keys
3501         If IsObject(record(key)) Then
3502             Set copy(key) = record(key)
        Else
3504             copy(key) = record(key)
        End If
    Next key
3507     copy("rung") = rung
3508     Set CloneRecord = copy
End Function

Private Function PlanDiameter(ByVal records As Collection, ByVal first As Variant, ByVal second As Variant, ByVal length As Double) As Object
    ' A circle seen face-on whose diameter the two points are the ends of: selecting it alone makes IModelDoc2.AddDimension2 add a diameter dimension.
    Dim record As Object, centre As Variant
3514     For Each record In records
3515         If record("kind") = "circle" Then
3516             If record("faceOn") = 1 Then
3517                 centre = record("a")
3518                 If Abs(2# * CDbl(record("radius")) - length) <= 0.000001 And Abs(CDbl(centre(0)) - (first(0) + second(0)) / 2#) <= 0.000001 _
                   And Abs(CDbl(centre(1)) - (first(1) + second(1)) / 2#) <= 0.000001 Then
3520                     Set PlanDiameter = CloneRecord(record, "drawing-dimension-circle-diameter")
3521                     Exit Function
                End If
            End If
        End If
    Next record
End Function

Private Function PlanLine(ByVal records As Collection, ByVal point As Variant, ByVal ux As Double, ByVal uy As Double) As Object
    ' A line through the point that is perpendicular to the measuring direction.
    Dim record As Object, a As Variant, b As Variant, runX As Double, runY As Double, size As Double, along As Double, off As Double
3531     For Each record In records
3532         If record("kind") = "line" Then
3533             a = record("a")
3534             b = record("b")
3535             runX = b(0) - a(0)
3536             runY = b(1) - a(1)
3537             size = Sqr(runX * runX + runY * runY)
3538             If size > 0.000000001 Then
3539                 If Abs(runX * ux + runY * uy) <= 0.000001 * size Then
3540                     along = ((point(0) - a(0)) * runX + (point(1) - a(1)) * runY) / (size * size)
3541                     off = Abs((point(0) - a(0)) * runY - (point(1) - a(1)) * runX) / size
3542                     If along >= -0.000000001 And along <= 1.000000001 And off <= 0.000001 Then
3543                         Set PlanLine = record
3544                         Exit Function
                    End If
                End If
            End If
        End If
    Next record
End Function

Private Function PlanReference(ByVal records As Collection, ByVal point As Variant, ByVal ux As Double, ByVal uy As Double) As Object
    ' A circle centered on the point, else a line through it that is perpendicular to the measuring direction (D05a's own choice, tried first).
    Dim record As Object
3555     For Each record In records
3556         If record("kind") = "circle" Then
3557             If NearFlat(record("a"), point) Then
3558                 Set PlanReference = record
3559                 Exit Function
            End If
        End If
    Next record
3563     Set PlanReference = PlanLine(records, point, ux, uy)
End Function

Private Function PlanRim(ByVal records As Collection, ByVal point As Variant, ByVal ux As Double, ByVal uy As Double) As Object
    ' A circle seen edge-on (its axis known to lie across the view) is the straight line through its center, 2 x radius long, perpendicular to its axis: it
    ' is a reference when the point is on that line and the measuring direction is the axis's own.
    Dim record As Object, axisFlat As Variant, centre As Variant, runX As Double, runY As Double
3570     For Each record In records
3571         If record("kind") = "circle" Then
3572             If record("faceOn") = 0 Then
3573                 centre = record("a")
3574                 axisFlat = record("flatAxis")
3575                 runX = point(0) - centre(0)
3576                 runY = point(1) - centre(1)
3577                 If Abs(-axisFlat(1) * ux + axisFlat(0) * uy) <= 0.000001 And Abs(runX * axisFlat(0) + runY * axisFlat(1)) <= 0.000001 _
                   And Abs(-runX * axisFlat(1) + runY * axisFlat(0)) <= CDbl(record("radius")) + 0.000000001 Then
3579                     Set PlanRim = CloneRecord(record, "drawing-dimension-edge-on-circles")
3580                     Exit Function
                End If
            End If
        End If
    Next record
End Function

Private Function DimensionPlan(ByVal records As Collection, ByVal first As Variant, ByVal second As Variant) As Collection
    ' The one or two edges whose selection makes SolidWorks measure the distance between two flattened points, or Nothing when the view cannot show
    ' it. D05a's own plan (a line, or two references) is tried first; the diameter and edge-on forms only when it finds nothing.
    Dim lineRecord As Object, one As Object, two As Object, dx As Double, dy As Double, length As Double
3591     dx = second(0) - first(0)
3592     dy = second(1) - first(1)
3593     length = Sqr(dx * dx + dy * dy)
3594     If length < 0.000000001 Then Err.Raise 5, , "The two dimension points coincide in the view"
3595     Set lineRecord = PlanSingle(records, first, second)
3596     If Not lineRecord Is Nothing Then
3597         Set DimensionPlan = New Collection
    stepLabel = currentIdentity & ": DimensionPlan Add"
3599         DimensionPlan.Add lineRecord
3600         Exit Function
    End If
3602     Set one = PlanReference(records, first, dx / length, dy / length)
3603     Set two = PlanReference(records, second, dx / length, dy / length)
3604     If Not one Is Nothing And Not two Is Nothing Then
3605         If Not one Is two Then
3606             Set DimensionPlan = New Collection
    stepLabel = currentIdentity & ": DimensionPlan Add"
3608             DimensionPlan.Add one
    stepLabel = currentIdentity & ": DimensionPlan Add"
3610             DimensionPlan.Add two
3611             Exit Function
        End If
    End If
3614     Set lineRecord = PlanDiameter(records, first, second, length)
3615     If Not lineRecord Is Nothing Then
3616         Set DimensionPlan = New Collection
    stepLabel = currentIdentity & ": DimensionPlan Add"
3618         DimensionPlan.Add lineRecord
3619         Exit Function
    End If
3621     Set one = PlanRim(records, first, dx / length, dy / length)
3622     Set two = PlanRim(records, second, dx / length, dy / length)
3623     If one Is Nothing And two Is Nothing Then Exit Function
3624     If one Is Nothing Then Set one = PlanReference(records, first, dx / length, dy / length)
3625     If two Is Nothing Then Set two = PlanReference(records, second, dx / length, dy / length)
3626     If one Is Nothing Or two Is Nothing Then Exit Function
3627     If one("entity") Is two("entity") Then Exit Function
3628     Set DimensionPlan = New Collection
    stepLabel = currentIdentity & ": DimensionPlan Add"
3630     DimensionPlan.Add one
    stepLabel = currentIdentity & ": DimensionPlan Add"
3632     DimensionPlan.Add two
End Function

Private Function TryPick(ByVal entity As Object, ByVal appendSelection As Boolean) As Boolean
3636     On Error GoTo Failed
3637     Pick entity, appendSelection, 0
3638     TryPick = True
3639     Exit Function
Failed:
3641     TryPick = False
End Function

Private Function AddDrawingDimension(ByVal view As Object, ByVal plan As Collection, ByVal textX As Double, ByVal textY As Double, ByVal expectedMm As Double, ByVal label As String) As Double
    ' Select the planned edges in the view, add the dimension, and read its value back.
    Dim record As Object, i As Long, selected As Long, display As Object, measured As Double, kinds As String
3647     For Each record In plan
3648         If Len(kinds) > 0 Then kinds = kinds & "+"
3649         kinds = kinds & CStr(record("kind"))
    Next record
    stepLabel = currentIdentity & ": AddDrawingDimension GetName2"
3652     callInputs = label & " view=" & view.GetName2() & " edges=" & kinds & " text(m)=" & NumberList(Array(textX, textY)) & " expected(mm)=" & NumberList(Array(expectedMm))
    stepLabel = currentIdentity & ": AddDrawingDimension ActivateView"
3654     If Not drawingInterface.ActivateView(view.GetName2()) Then Err.Raise 5, , "ActivateView failed: " & callInputs
    stepLabel = currentIdentity & ": AddDrawingDimension ClearSelection2"
3656     doc.ClearSelection2 True
3657     Set pickView = view
3658     i = 0
3659     For Each record In plan
3660         If Not TryPick(record("entity"), i > 0) Then
3661             RecordMitigation "drawing-select-entity-via-view", True, True
    stepLabel = currentIdentity & ": AddDrawingDimension SelectEntity" & " " & apiInputs & " " & callInputs
3663             If Not view.SelectEntity(record("entity"), i > 0) Then Err.Raise 5, , "IView.SelectEntity failed after the Select4 selection failed: " & callInputs
3664             fallbackSuccesses("drawing-select-entity-via-view") = fallbackSuccesses("drawing-select-entity-via-view") + 1
        End If
3666         i = i + 1
    Next record
3668     Set pickView = Nothing
    stepLabel = currentIdentity & ": AddDrawingDimension GetSelectedObjectCount2"
3670     selected = doc.SelectionManager.GetSelectedObjectCount2(-1)
    stepLabel = currentIdentity & ": AddDrawingDimension Count"
3672     If selected <> plan.Count Then Err.Raise 5, , CStr(selected) & " edges are selected, not " & CStr(plan.Count) & ": " & callInputs
    stepLabel = currentIdentity & ": AddDrawingDimension AddDimension2"
3674     Set display = doc.AddDimension2(textX, textY, 0#)
3675     Require display, "AddDimension2 returned no dimension: " & callInputs
    stepLabel = currentIdentity & ": AddDrawingDimension GetDimension2"
3677     Set dimensionValue = display.GetDimension2(0)
3678     Require dimensionValue, "The new dimension has no value object: " & callInputs
    stepLabel = currentIdentity & ": AddDrawingDimension SystemValue"
3680     measured = dimensionValue.SystemValue / 0.001
3681     If Abs(measured - expectedMm) > 0.000001 Then Err.Raise 5, , "The drawing dimension measured " & NumberList(Array(measured)) & " mm, not " & NumberList(Array(expectedMm)) & " mm: " & callInputs
    stepLabel = currentIdentity & ": AddDrawingDimension ClearSelection2"
3683     doc.ClearSelection2 True
3684     AddDrawingDimension = measured
End Function

Private Function DrawingReadBack(ByVal expected As Variant) As String
    ' Every display dimension in the drawing, read from the drawing, must be exactly the recipe's values.
    Dim seen As Object, view As Object, display As Object, key As String, listing As String, i As Long
3690     Set seen = CreateObject("Scripting.Dictionary")
    stepLabel = currentIdentity & ": DrawingReadBack GetFirstView"
3692     Set view = drawingInterface.GetFirstView()
3693     Do While Not view Is Nothing
    stepLabel = currentIdentity & ": DrawingReadBack GetFirstDisplayDimension5"
3695         Set display = view.GetFirstDisplayDimension5()
3696         Do While Not display Is Nothing
    stepLabel = currentIdentity & ": DrawingReadBack GetDimension2"
3698             key = CStr(Round(display.GetDimension2(0).SystemValue * 1000#, 4))
3699             If Len(listing) > 0 Then listing = listing & ", "
    stepLabel = currentIdentity & ": DrawingReadBack GetName2"
3701             listing = listing & view.GetName2() & " " & key & " mm"
    stepLabel = currentIdentity & ": DrawingReadBack Exists"
3703             If seen.Exists(key) Then
3704                 seen(key) = seen(key) + 1
            Else
    stepLabel = currentIdentity & ": DrawingReadBack Add"
3707                 seen.Add key, 1
            End If
    stepLabel = currentIdentity & ": DrawingReadBack GetNext3"
3710             Set display = display.GetNext3()
        Loop
    stepLabel = currentIdentity & ": DrawingReadBack GetNextView"
3713         Set view = view.GetNextView()
    Loop
3715     For i = LBound(expected) To UBound(expected)
3716         key = CStr(Round(CDbl(expected(i)), 4))
    stepLabel = currentIdentity & ": DrawingReadBack Exists"
3718         If Not seen.Exists(key) Then Err.Raise 5, , "The drawing is missing the dimension " & key & " mm; it holds: " & listing
3719         If seen(key) = 1 Then
    stepLabel = currentIdentity & ": DrawingReadBack Remove"
3721             seen.Remove key
        Else
3723             seen(key) = seen(key) - 1
        End If
    Next i
    stepLabel = currentIdentity & ": DrawingReadBack Count"
3727     If seen.Count > 0 Then Err.Raise 5, , "The drawing holds more dimensions than the recipe's: " & listing
3728     DrawingReadBack = listing
End Function

Private Sub ExportDrawing(ByVal path As String)
    ' A copy of the sheet as DXF (R2000, which the recipe allows); the file must exist and hold data.
    Dim previous As Long, fs As Object, failureNumber As Long, failure As String, failingStep As String
    stepLabel = currentIdentity & ": ExportDrawing GetUserPreferenceIntegerValue"
3735     previous = app.GetUserPreferenceIntegerValue(swDxfVersion)
    stepLabel = currentIdentity & ": ExportDrawing SetUserPreferenceIntegerValue"
3737     If Not app.SetUserPreferenceIntegerValue(swDxfVersion, swDxfFormat_R2000) Then Err.Raise 5, , "Cannot set the DXF version"
3738     On Error Resume Next
    stepLabel = currentIdentity & ": ExportDrawing GetUserPreferenceIntegerValue"
3740     If app.GetUserPreferenceIntegerValue(swDxfVersion) <> swDxfFormat_R2000 Then Err.Raise 5, , "The DXF version did not stay at R2000"
3741     If Err.Number = 0 Then SaveFile path
3742     failureNumber = Err.Number
3743     failure = Err.Description
3744     failingStep = stepLabel
3745     Err.Clear
    stepLabel = currentIdentity & ": ExportDrawing SetUserPreferenceIntegerValue"
3747     app.SetUserPreferenceIntegerValue swDxfVersion, previous
3748     stepLabel = failingStep
3749     On Error GoTo 0
3750     If failureNumber <> 0 Then Err.Raise failureNumber, , failure
3751     stepLabel = currentIdentity & ": DXF file check"
3752     Set fs = CreateObject("Scripting.FileSystemObject")
    stepLabel = currentIdentity & ": ExportDrawing FileExists"
3754     If Not fs.FileExists(path) Then Err.Raise 5, , "The DXF export wrote no file"
    stepLabel = currentIdentity & ": ExportDrawing GetFile"
3756     If fs.GetFile(path).Size = 0 Then Err.Raise 5, , "The DXF export wrote an empty file"
    stepLabel = currentIdentity & ": ExportDrawing GetFileName"
3758     AppendLog currentFolder, currentIdentity, "option", 0, 0, "drawing DXF: " & fs.GetFileName(path) & ", " & CStr(fs.GetFile(path).Size) & " bytes, DXF version R2000 (3), previous setting " & CStr(previous) & " restored; scale and text options left at the user defaults (the interop does not say what their values mean)"
End Sub
