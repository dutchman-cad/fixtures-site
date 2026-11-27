Attribute VB_Name = "FixtureLauncher"
Option Explicit
' Dutchman Fixtures launcher for SolidWorks. Import this module once; it rarely changes.
' Run main to build and send a batch. Run settings to change your answers or to opt in to automatic upload (off unless you turn it on). Run upload to resend the last zip.
' Late binding only: no references are needed.
Private Const LAUNCHER_VERSION As String = "1"
Private Const MANIFEST_URL As String = "https://fixtures.dutchmancad.xyz/builders/solidworks/latest.json"
Private Const BAS_URL As String = "https://fixtures.dutchmancad.xyz/builders/solidworks/FixtureBuilder.bas"
Private Const SETTINGS_APP As String = "DutchmanFixtures"
Private Const SETTINGS_SECTION As String = "SolidWorksBuilder"
Private Const BUILDER_MODULE As String = "FixtureBuilder"
Private gLink As String
Private gDir As String

Public Sub main()
    Dim basPath As String, runPath As String, outcome As Long, savedRoot As String, refusal As String
    On Error GoTo Failed
    PrepareFolder
    LogLine "---- launcher " & LAUNCHER_VERSION & " started"
    LogLine "settings: RunMode=" & GetSetting(SETTINGS_APP, SETTINGS_SECTION, "RunMode", "left") & _
        " OutputRoot=" & GetSetting(SETTINGS_APP, SETTINGS_SECTION, "OutputRoot", "(default)") & _
        " UploadConsent=" & GetSetting(SETTINGS_APP, SETTINGS_SECTION, "UploadConsent", "no") & _
        " UploadLink=" & MaskToken(LoadLink())
    ' A saved output folder that carries a personal path (profile, user name, OneDrive) is refused before anything is downloaded or built.
    savedRoot = Trim$(GetSetting(SETTINGS_APP, SETTINGS_SECTION, "OutputRoot", ""))
    If Len(savedRoot) > 0 Then
        refusal = PersonalPathReason(savedRoot)
        If Len(refusal) > 0 Then
            LogLine "personal-path check: the saved OutputRoot is refused; nothing was built"
            MsgBox Scrub(refusal & vbLf & "Run settings and type a neutral folder, or leave it empty for " & DefaultOutputRoot() & "."), vbExclamation, "Dutchman Fixtures"
            Exit Sub
        End If
    End If
    ' The first prompt of a run: SolidWorks itself writes the Windows user name into each file it saves. Cancel builds nothing.
    If Not ConfirmNotice() Then Exit Sub
    basPath = FetchBuilder()
    If Len(basPath) = 0 Then Exit Sub
    runPath = PatchOutputRoot(basPath)
    SaveSetting SETTINGS_APP, SETTINGS_SECTION, "LastZip", ""
    SaveSetting SETTINGS_APP, SETTINGS_SECTION, "LastFinish", ""
    SaveSetting SETTINGS_APP, SETTINGS_SECTION, "LaunchedBy", "launcher"
    outcome = RunBuilder(runPath, basPath)
    ' The builder clears this itself; clear it here too in case it never ran (manual route, import refused).
    SaveSetting SETTINGS_APP, SETTINGS_SECTION, "LaunchedBy", ""
    SaveSetting SETTINGS_APP, SETTINGS_SECTION, "NoticeAnswer", ""
    If outcome <> 0 Then Exit Sub
    FinishRun
    Exit Sub
Failed:
    LogLine "launcher error " & CStr(Err.Number) & ": " & Err.Description
    MsgBox Scrub("The launcher stopped: " & Err.Description & vbCrLf & "Details: " & LogPath()), vbExclamation, "Dutchman Fixtures"
End Sub

Public Sub settings()
    On Error GoTo Failed
    PrepareFolder
    Dim answer As String, refusal As String
    SaveSetting SETTINGS_APP, SETTINGS_SECTION, "RunMode", "left"
    answer = InputBox("Run mode. Type left (the recipes still to do, the usual choice) or full (everything).", "Dutchman Fixtures", _
        GetSetting(SETTINGS_APP, SETTINGS_SECTION, "RunMode", "left"))
    answer = LCase$(Trim$(answer))
    If answer = "left" Or answer = "full" Then SaveSetting SETTINGS_APP, SETTINGS_SECTION, "RunMode", answer
    answer = InputBox("Folder for the builder's output. Leave empty for " & DefaultOutputRoot() & "." & vbLf & _
        "SolidWorks keeps the full path of the files it references inside every assembly and drawing it saves, so a folder in your user profile or OneDrive would put your user name in the files you send. Those folders are refused.", "Dutchman Fixtures", _
        GetSetting(SETTINGS_APP, SETTINGS_SECTION, "OutputRoot", ""))
    answer = Trim$(answer)
    refusal = ""
    If Len(answer) > 0 Then refusal = PersonalPathReason(answer)
    If Len(refusal) > 0 Then
        ' Refused: the answer is not saved. A saved folder that is itself personal is cleared, so the default root is used.
        If Len(PersonalPathReason(GetSetting(SETTINGS_APP, SETTINGS_SECTION, "OutputRoot", ""))) > 0 Then SaveSetting SETTINGS_APP, SETTINGS_SECTION, "OutputRoot", ""
        LogLine "settings: the output folder answer was refused by the personal-path check"
        MsgBox Scrub(refusal & vbLf & "The output folder was not changed. Run settings again to choose another."), vbExclamation, "Dutchman Fixtures"
    Else
        SaveSetting SETTINGS_APP, SETTINGS_SECTION, "OutputRoot", answer
    End If
    ChooseUpload
    LogLine "settings changed"
    Exit Sub
Failed:
    LogLine "settings error " & CStr(Err.Number) & ": " & Err.Description
    MsgBox Scrub("Settings stopped: " & Err.Description), vbExclamation, "Dutchman Fixtures"
End Sub

Public Sub upload()
    Dim zipPath As String, fs As Object
    On Error GoTo Failed
    PrepareFolder
    LogLine "---- manual upload"
    zipPath = GetSetting(SETTINGS_APP, SETTINGS_SECTION, "LastZip", "")
    Set fs = CreateObject("Scripting.FileSystemObject")
    If Len(zipPath) = 0 Or Not fs.FileExists(zipPath) Then
        MsgBox Scrub("There is no zip from a previous run to upload."), vbInformation, "Dutchman Fixtures"
        Exit Sub
    End If
    If Len(LoadLink()) = 0 Then
        MsgBox Scrub("Automatic upload is off, so no private link is saved. To turn it on, run settings and answer Yes to the upload question." & vbCrLf & _
            "Sending the zip to Dutchy in a Discord direct message is fine. Your zip: " & zipPath), vbInformation, "Dutchman Fixtures"
        Exit Sub
    End If
    UploadZip zipPath
    Exit Sub
Failed:
    LogLine "upload error " & CStr(Err.Number) & ": " & Err.Description
    MsgBox Scrub("Upload stopped: " & Err.Description), vbExclamation, "Dutchman Fixtures"
End Sub

' ---------------------------------------------------------------- settings

Private Sub ChooseUpload()
    Dim reply As VbMsgBoxResult, link As String, state As String
    state = "off"
    If GetSetting(SETTINGS_APP, SETTINGS_SECTION, "UploadConsent", "no") = "yes" Then state = "on"
    reply = MsgBox("Upload the finished zip automatically after each run? It is currently " & state & "." & vbCrLf & _
        "Yes: you paste your private portal link, which stays on this computer, and only the zip the builder made is sent." & vbCrLf & _
        "No: upload is turned off and any saved link is cleared. Sending the zip to Dutchy in a Discord direct message is the normal route.", _
        vbYesNo + vbQuestion, "Dutchman Fixtures")
    If reply <> vbYes Then
        SaveSetting SETTINGS_APP, SETTINGS_SECTION, "UploadConsent", "no"
        SaveSetting SETTINGS_APP, SETTINGS_SECTION, "UploadLink", ""
        gLink = ""
        LogLine "upload: off, link cleared"
        Exit Sub
    End If
    link = InputBox("Paste your private upload link (like https://fixtures.dutchmancad.xyz/v/...). Leave empty to keep upload off.", _
        "Dutchman Fixtures", GetSetting(SETTINGS_APP, SETTINGS_SECTION, "UploadLink", ""))
    link = CleanLink(link)
    If Len(link) = 0 Then
        SaveSetting SETTINGS_APP, SETTINGS_SECTION, "UploadConsent", "no"
        SaveSetting SETTINGS_APP, SETTINGS_SECTION, "UploadLink", ""
        gLink = ""
        LogLine "upload: off, no link given"
        Exit Sub
    End If
    SaveSetting SETTINGS_APP, SETTINGS_SECTION, "UploadConsent", "yes"
    SaveSetting SETTINGS_APP, SETTINGS_SECTION, "UploadLink", link
    gLink = link
    LogLine "upload: on, link " & MaskToken(link)
End Sub

Private Function CleanLink(ByVal text As String) As String
    text = Trim$(text)
    Do While Right$(text, 1) = "/"
        text = Left$(text, Len(text) - 1)
    Loop
    If Len(text) > 0 And LCase$(Left$(text, 8)) <> "https://" Then
        MsgBox Scrub("The link must start with https:// so it was not saved."), vbExclamation, "Dutchman Fixtures"
        text = ""
    End If
    CleanLink = text
End Function

Private Function LoadLink() As String
    gLink = GetSetting(SETTINGS_APP, SETTINGS_SECTION, "UploadLink", "")
    LoadLink = gLink
End Function

' ---------------------------------------------------------------- log (the upload token is never written whole)

Private Function MaskTail(ByVal text As String) As String
    If Len(text) <= 4 Then
        MaskTail = String$(Len(text), "*")
    Else
        MaskTail = String$(Len(text) - 4, "*") & Right$(text, 4)
    End If
End Function

Private Function MaskToken(ByVal link As String) As String
    Dim p As Long
    If Len(link) = 0 Then
        MaskToken = "(none)"
        Exit Function
    End If
    p = InStr(link, "/v/")
    If p > 0 Then
        MaskToken = Left$(link, p + 2) & MaskTail(Mid$(link, p + 3))
    Else
        MaskToken = MaskTail(link)
    End If
End Function

Private Function Scrub(ByVal text As String) As String
    Dim p As Long, token As String
    If Len(gLink) > 0 Then
        text = Replace(text, gLink, MaskToken(gLink))
        p = InStr(gLink, "/v/")
        If p > 0 Then
            token = Mid$(gLink, p + 3)
            If Len(token) >= 6 Then text = Replace(text, token, MaskTail(token))
        End If
    End If
    ' Nothing a volunteer might screenshot, and no log line, carries their user name or profile path.
    Scrub = PrivacyScrub(text)
End Function

Private Function LogPath() As String
    LogPath = gDir & "\launcher.log"
End Function

Private Sub LogLine(ByVal text As String)
    Dim fs As Object, ts As Object
    On Error Resume Next
    Set fs = CreateObject("Scripting.FileSystemObject")
    Set ts = fs.OpenTextFile(LogPath(), 8, True)
    ts.WriteLine Format$(Now, "yyyy-mm-dd hh:nn:ss") & "  " & Scrub(text)
    ts.Close
End Sub

Private Sub PrepareFolder()
    Dim fs As Object
    Set fs = CreateObject("Scripting.FileSystemObject")
    gDir = Environ$("LOCALAPPDATA") & "\DutchmanFixtures"
    If Not fs.FolderExists(gDir) Then fs.CreateFolder gDir
    LoadLink
End Sub

' ---------------------------------------------------------------- files and PowerShell

Private Function Q(ByVal text As String) As String
    Q = "'" & Replace(text, "'", "''") & "'"
End Function

Private Function RunPs(ByVal script As String) As Long
    Dim shellApp As Object
    Set shellApp = CreateObject("WScript.Shell")
    RunPs = shellApp.Run("powershell.exe -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command " & Chr$(34) & script & Chr$(34), 0, True)
End Function

Private Function ReadText(ByVal filePath As String) As String
    Dim fs As Object, ts As Object
    ReadText = ""
    Set fs = CreateObject("Scripting.FileSystemObject")
    If Not fs.FileExists(filePath) Then Exit Function
    Set ts = fs.OpenTextFile(filePath, 1, False)
    If Not ts.AtEndOfStream Then ReadText = ts.ReadAll
    ts.Close
End Function

Private Sub WriteText(ByVal filePath As String, ByVal text As String)
    Dim fs As Object, ts As Object
    Set fs = CreateObject("Scripting.FileSystemObject")
    Set ts = fs.CreateTextFile(filePath, True, False)
    ts.Write text
    ts.Close
End Sub

Private Function OneLine(ByVal text As String) As String
    OneLine = Trim$(Replace(Replace(text, vbCr, " "), vbLf, " "))
End Function

Private Sub DeleteIfThere(ByVal filePath As String)
    Dim fs As Object
    Set fs = CreateObject("Scripting.FileSystemObject")
    If fs.FileExists(filePath) Then fs.DeleteFile filePath, True
End Sub

' Downloads url to dest. Returns 0 ok, 44 not found (404), anything else = could not download (offline, blocked).
Private Function Fetch(ByVal url As String, ByVal dest As String) As Long
    Dim errFile As String, script As String, code As Long
    errFile = gDir & "\fetch.err"
    DeleteIfThere dest
    DeleteIfThere errFile
    script = "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $ProgressPreference = 'SilentlyContinue'; " & _
        "try { Invoke-WebRequest -UseBasicParsing -TimeoutSec 60 -Uri " & Q(url) & " -OutFile " & Q(dest) & "; exit 0 } " & _
        "catch { $c = 0; if ($_.Exception.Response) { $c = [int]$_.Exception.Response.StatusCode }; " & _
        "('HTTP ' + $c + ' ' + $_.Exception.Message) | Out-File -Encoding ascii " & Q(errFile) & "; " & _
        "if ($c -eq 404) { exit 44 } else { exit 1 } }"
    code = RunPs(script)
    If code <> 0 Then LogLine "download " & url & " failed (exit " & CStr(code) & "): " & OneLine(ReadText(errFile))
    Fetch = code
End Function

' SHA-256 (lower case hex) of a file, or "" when it cannot be computed.
Private Function FileSha256(ByVal filePath As String) As String
    Dim outFile As String, code As Long
    outFile = gDir & "\hash.txt"
    DeleteIfThere outFile
    FileSha256 = ""
    code = RunPs("(Get-FileHash -Algorithm SHA256 -LiteralPath " & Q(filePath) & ").Hash | Out-File -Encoding ascii " & Q(outFile))
    If code = 0 Then FileSha256 = LCase$(OneLine(ReadText(outFile)))
End Function

Private Function JsonString(ByVal doc As String, ByVal key As String) As String
    Dim p As Long, q2 As Long
    JsonString = ""
    p = InStr(doc, Chr$(34) & key & Chr$(34))
    If p = 0 Then Exit Function
    p = InStr(p + Len(key) + 2, doc, ":")
    If p = 0 Then Exit Function
    p = InStr(p, doc, Chr$(34))
    If p = 0 Then Exit Function
    q2 = InStr(p + 1, doc, Chr$(34))
    If q2 = 0 Then Exit Function
    JsonString = Mid$(doc, p + 1, q2 - p - 1)
End Function

' ---------------------------------------------------------------- step 2: download and verify

' Returns the path of the verified FixtureBuilder.bas, or "" after telling the user why not.
Private Function FetchBuilder() As String
    Dim fs As Object, good As String, fresh As String, manifestNew As String, manifestGood As String
    Dim code As Long, doc As String, wantHash As String, wantVersion As String, gotHash As String, goodHash As String
    Set fs = CreateObject("Scripting.FileSystemObject")
    good = gDir & "\FixtureBuilder.bas"
    fresh = gDir & "\FixtureBuilder.bas.new"
    manifestNew = gDir & "\latest.json.new"
    manifestGood = gDir & "\latest.json"
    FetchBuilder = ""
    code = Fetch(MANIFEST_URL, manifestNew)
    If code = 0 Then
        doc = ReadText(manifestNew)
        wantHash = LCase$(JsonString(doc, "sha256"))
        wantVersion = JsonString(doc, "version")
        LogLine "manifest: version " & wantVersion & " sha256 " & wantHash
        If Len(wantHash) <> 64 Then
            LogLine "manifest has no usable sha256; stopping"
            MsgBox Scrub("The version file on the server looks wrong (no checksum). Nothing was run. Tell Dutchy. Details: " & LogPath()), vbExclamation, "Dutchman Fixtures"
            Exit Function
        End If
        If fs.FileExists(good) Then goodHash = FileSha256(good)
        If goodHash = wantHash Then
            LogLine "builder " & wantVersion & " already downloaded and verified"
            FetchBuilder = good
            Exit Function
        End If
        code = Fetch(BAS_URL, fresh)
        If code <> 0 Then
            FetchBuilder = UseOldCopy(good, "The new builder could not be downloaded")
            Exit Function
        End If
        gotHash = FileSha256(fresh)
        If gotHash <> wantHash Then
            LogLine "CHECKSUM MISMATCH: wanted " & wantHash & " got " & gotHash & "; previous good copy kept"
            DeleteIfThere fresh
            MsgBox Scrub("The downloaded builder does not match its checksum, so it was NOT run. Your previous good copy (if any) is kept. " & _
                "Try again in a few minutes; if it repeats, tell Dutchy. Details: " & LogPath()), vbCritical, "Dutchman Fixtures"
            Exit Function
        End If
        If Not Promote(fresh, good, "verified, sha256 matches") Then Exit Function
        DeleteIfThere manifestGood
        fs.MoveFile manifestNew, manifestGood
        LogLine "builder " & wantVersion & " ready: " & good
        FetchBuilder = good
        Exit Function
    End If
    If code = 44 Then
        ' No manifest published yet: fetch the builder anyway, but say it was not verified.
        LogLine "no manifest, checksum not verified"
        code = Fetch(BAS_URL, fresh)
        If code <> 0 Then
            FetchBuilder = UseOldCopy(good, "The builder could not be downloaded")
            Exit Function
        End If
        If Not Promote(fresh, good, "no manifest, checksum not verified") Then Exit Function
        FetchBuilder = good
        Exit Function
    End If
    FetchBuilder = UseOldCopy(good, "You look to be offline (or the server cannot be reached)")
End Function

Private Function UseOldCopy(ByVal good As String, ByVal why As String) As String
    Dim fs As Object
    Set fs = CreateObject("Scripting.FileSystemObject")
    UseOldCopy = ""
    If fs.FileExists(good) Then
        LogLine why & "; using the last verified copy " & good
        MsgBox Scrub(why & ". Using the last verified copy of the builder."), vbInformation, "Dutchman Fixtures"
        UseOldCopy = good
    Else
        LogLine why & "; no earlier copy, stopping"
        MsgBox Scrub(why & ", and there is no earlier copy. Check your internet connection and run again."), vbExclamation, "Dutchman Fixtures"
    End If
End Function

' Sanity-check the module name, then replace the good copy with the new one.
Private Function Promote(ByVal fresh As String, ByVal good As String, ByVal how As String) As Boolean
    Dim fs As Object
    Set fs = CreateObject("Scripting.FileSystemObject")
    Promote = False
    If InStr(ReadText(fresh), "Attribute VB_Name = " & Chr$(34) & BUILDER_MODULE & Chr$(34)) = 0 Then
        LogLine "downloaded file is not the FixtureBuilder module; stopping"
        DeleteIfThere fresh
        MsgBox Scrub("The downloaded file is not the Fixture Builder, so it was not run. Tell Dutchy. Details: " & LogPath()), vbExclamation, "Dutchman Fixtures"
        Exit Function
    End If
    DeleteIfThere good
    fs.MoveFile fresh, good
    LogLine "builder saved (" & how & ")"
    Promote = True
End Function

' The builder has an empty OUTPUT_FOLDER constant. When OutputRoot is set, import a copy with it filled in.
Private Function ConfirmNotice() As Boolean
    ' Once per run, never in a loop. The builder reads NoticeAnswer for its own log line.
    Dim answer As Long
    answer = MsgBox(UserNameNotice(), vbOKCancel + vbInformation, "Dutchman Fixtures")
    If answer = vbOK Then
        SaveSetting SETTINGS_APP, SETTINGS_SECTION, "NoticeAnswer", "OK"
        LogLine "user name notice: shown, answer OK"
        ConfirmNotice = True
    Else
        SaveSetting SETTINGS_APP, SETTINGS_SECTION, "NoticeAnswer", "Cancel"
        LogLine "user name notice: shown, answer Cancel; nothing was built"
        ConfirmNotice = False
    End If
End Function

Private Function PatchOutputRoot(ByVal basPath As String) As String
    Dim root As String, text As String, marker As String, target As String
    PatchOutputRoot = basPath
    root = GetSetting(SETTINGS_APP, SETTINGS_SECTION, "OutputRoot", "")
    If Len(root) = 0 Then Exit Function
    marker = "Private Const OUTPUT_FOLDER As String = " & Chr$(34) & Chr$(34)
    text = ReadText(basPath)
    If InStr(text, marker) = 0 Then
        LogLine "OutputRoot set but the builder has no OUTPUT_FOLDER line; using the builder's default folder"
        Exit Function
    End If
    text = Replace(text, marker, "Private Const OUTPUT_FOLDER As String = " & Chr$(34) & Replace(root, Chr$(34), "") & Chr$(34), 1, 1)
    target = gDir & "\FixtureBuilder.run.bas"
    WriteText target, text
    LogLine "OutputRoot applied: " & root
    PatchOutputRoot = target
End Function

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
    On Error Resume Next
    If variable = "MYDOCUMENTS" Then
        value = CreateObject("WScript.Shell").SpecialFolders("MyDocuments")
    Else
        value = CreateObject("WScript.Shell").ExpandEnvironmentStrings("%" & variable & "%")
        If value = "%" & variable & "%" Then value = ""
    End If
    If Err.Number <> 0 Then value = ""
    Err.Clear
    EnvText = Trim$(value)
End Function

Private Function DefaultOutputRoot() As String
    Dim pub As String, result As String
    pub = Replace(EnvText("PUBLIC"), "/", "\")
    Do While Len(pub) > 0 And Right$(pub, 1) = "\"
        pub = Left$(pub, Len(pub) - 1)
    Loop
    If Len(pub) = 0 Then
        result = "C:\FixtureBuilder"
    Else
        result = pub & "\Documents\FixtureBuilder"
    End If
    DefaultOutputRoot = result
End Function

Private Function UserNameNotice() As String
    UserNameNotice = "SolidWorks writes your Windows user name into each file it saves. We keep these native files private and publish only STEP and files we've checked clean; to keep your name out of the files entirely, run SolidWorks under a neutral Windows account."
End Function

Private Function NameInsideComponents(ByVal user As String) As Boolean
    ' A word-matched name: 3 or more characters and not a common word. It is matched wherever the characters on both sides are not ASCII
    ' letters or digits (the start of the text, a tab, a quote, a length byte, "-", "_" ...); any other name (and a shorter one) only as a
    ' whole path segment. The same for the user name, the profile folder's own name and the computer, domain and logon-server names.
    Dim inside As Boolean
    inside = (Len(user) >= 3)
    If InStr("|admin|user|users|owner|public|default|test|cad|work|data|home|the|and|pro|dev|lab|app|sys|doc|docs|temp|office|pc|laptop|desktop|", "|" & user & "|") > 0 Then inside = False
    NameInsideComponents = inside
End Function

Private Function IsAsciiAlnum(ByVal ch As String) As Boolean
    IsAsciiAlnum = (ch Like "[A-Za-z0-9]")
End Function

Private Function WordIn(ByVal text As String, ByVal needle As String) As Boolean
    ' The needle in the text with no ASCII letter or digit next to it (or the edge of the text): both already lower-cased.
    Dim pos As Long, before As String, after As String, found As Boolean
    If Len(needle) > 0 Then
        pos = InStr(1, text, needle, vbBinaryCompare)
        Do While pos > 0 And Not found
            before = ""
            after = ""
            If pos > 1 Then before = Mid$(text, pos - 1, 1)
            If pos + Len(needle) <= Len(text) Then after = Mid$(text, pos + Len(needle), 1)
            If (Len(before) = 0 Or Not IsAsciiAlnum(before)) And (Len(after) = 0 Or Not IsAsciiAlnum(after)) Then found = True
            pos = InStr(pos + 1, text, needle, vbBinaryCompare)
        Loop
    End If
    WordIn = found
End Function

Private Function SegmentMatches(ByVal part As String, ByVal needle As String) As Boolean
    Dim hit As Boolean
    If Len(needle) > 0 Then hit = (part = needle)
    If Len(needle) > 0 And Not hit Then
        If NameInsideComponents(needle) Then hit = WordIn(part, needle)
    End If
    SegmentMatches = hit
End Function

Private Function NormalPath(ByVal path As String) As String
    Dim p As String
    p = LCase$(Replace(Trim$(path), "/", "\"))
    Do While Len(p) > 0 And Right$(p, 1) = "\"
        p = Left$(p, Len(p) - 1)
    Loop
    NormalPath = p
End Function

Private Function LeafOf(ByVal normal As String) As String
    LeafOf = Mid$(normal, InStrRev(normal, "\") + 1)
End Function

Private Function UnderRoot(ByVal p As String, ByVal root As String) As Boolean
    Dim under As Boolean
    If Len(root) > 0 Then under = (p = root Or Left$(p, Len(root) + 1) = root & "\")
    UnderRoot = under
End Function

Private Function PersonalPathRefusal(ByVal what As String, ByVal why As String) As String
    PersonalPathRefusal = "The " & what & " was refused because " & why & ". " & _
        "SolidWorks stores this path inside every assembly and drawing it saves, so the files you send would show it. " & _
        "Choose a neutral one instead, for example " & DefaultOutputRoot() & " for the output folder. Nothing was built."
End Function

Private Function DriveRooted(ByVal path As String) As Boolean
    Dim t As String
    t = Trim$(path)
    DriveRooted = (Len(t) >= 3 And Mid$(t, 1, 1) Like "[A-Za-z]" And Mid$(t, 2, 1) = ":" And (Mid$(t, 3, 1) = "\" Or Mid$(t, 3, 1) = "/"))
End Function

Private Function PersonalWhy(ByVal path As String, ByVal identity As Boolean) As String
    ' With identity False (the default output root, the one folder the builder names itself) only the last two rules apply, so a user called
    ' Documents, Public or FixtureBuilder is not locked out of it. The first of these that applies, on the lower-cased path: inside %USERPROFILE%; inside a OneDrive folder or the redirected Documents
    ' folder; a folder that is, or (guarded names) contains, %USERNAME% or the profile folder's own name; a folder named after the computer,
    ' domain or logon server; a folder whose name contains "onedrive"; a UNC share; a Users\<name> folder that is not Public.
    Dim p As String, profile As String, parts As Variant, i As Long, k As Long, why As String
    Dim names(0 To 1) As String, machines(0 To 2) As String, roots(0 To 3) As String
    p = NormalPath(path)
    profile = NormalPath(EnvText("USERPROFILE"))
    names(0) = LCase$(EnvText("USERNAME"))
    names(1) = LeafOf(profile)
    machines(0) = LCase$(EnvText("COMPUTERNAME"))
    machines(1) = LCase$(EnvText("USERDOMAIN"))
    machines(2) = LCase$(Replace(EnvText("LOGONSERVER"), "\", ""))
    roots(0) = NormalPath(EnvText("OneDrive"))
    roots(1) = NormalPath(EnvText("OneDriveCommercial"))
    roots(2) = NormalPath(EnvText("OneDriveConsumer"))
    roots(3) = NormalPath(EnvText("MYDOCUMENTS"))
    parts = Split(p, "\")
    If identity Then
        If UnderRoot(p, profile) Then why = "it is inside your user profile folder"
    End If
    If Len(why) = 0 And identity Then
        For k = 0 To 3
            If UnderRoot(p, roots(k)) Then why = "it is inside your OneDrive or redirected Documents folder"
        Next k
    End If
    If Len(why) = 0 And identity Then
        For k = 0 To 1
            If Len(names(k)) > 0 Then
                For i = 0 To UBound(parts)
                    If SegmentMatches(CStr(parts(i)), names(k)) Then why = "a folder in its path contains your Windows user name"
                Next i
            End If
        Next k
    End If
    If Len(why) = 0 And identity Then
        For k = 0 To 2
            For i = 0 To UBound(parts)
                If SegmentMatches(CStr(parts(i)), machines(k)) Then why = "a folder in its path is named after this computer, its domain or its logon server"
            Next i
        Next k
    End If
    If Len(why) = 0 And identity Then
        For i = 0 To UBound(parts)
            If InStr(parts(i), "onedrive") > 0 Then why = "a folder in its path is a OneDrive folder"
        Next i
    End If
    If Len(why) = 0 And Left$(p, 2) = "\\" Then why = "it is on a network share (a \\server\share path)"
    If Len(why) = 0 Then
        For i = 0 To UBound(parts) - 1
            If parts(i) = "users" And Len(parts(i + 1)) > 0 And parts(i + 1) <> "public" And parts(i + 1) <> "default" And parts(i + 1) <> "all users" And parts(i + 1) <> "shared" Then why = "it is inside the personal folder of a Windows user (a Users\<name> folder)"
        Next i
    End If
    ' Last, and for every folder (the default root too): a folder that is not a full path with a drive letter ("FixtureOut", "..\x",
    ' "%USERPROFILE%\x", which FileSystemObject does not expand) would resolve against SolidWorks' own current folder, which may be under the profile.
    If Len(why) = 0 Then
        If Not DriveRooted(path) Then why = "the folder must be a full path starting with a drive letter"
    End If
    PersonalWhy = why
End Function

Private Function PersonalPathReason(ByVal path As String) As String
    Dim why As String
    why = PersonalWhy(path, NormalPath(path) <> NormalPath(DefaultOutputRoot()))
    If Len(why) = 0 Then
        PersonalPathReason = ""
    Else
        PersonalPathReason = PersonalPathRefusal("output folder", why)
    End If
End Function

Private Function PersonalTemplateReason(ByVal kind As String, ByVal path As String) As String
    Dim why As String
    why = PersonalWhy(path, True)
    If Len(why) = 0 Then
        PersonalTemplateReason = ""
    Else
        PersonalTemplateReason = "The " & kind & " template SolidWorks would use was refused because " & why & ". " & _
            "A SolidWorks drawing stores the path of its sheet format and template, so the files you send would show it. " & _
            "In SolidWorks, under Tools > Options > Default Templates, choose a " & kind & " template in a neutral folder (for example the SolidWorks install folder or C:\ProgramData). Nothing was built."
    End If
End Function

Private Function EscapeRegex(ByVal text As String) As String
    Dim i As Long, ch As String, result As String
    For i = 1 To Len(text)
        ch = Mid$(text, i, 1)
        If InStr("\.+*?^$()[]{}|-", ch) > 0 Then result = result & "\"
        result = result & ch
    Next i
    EscapeRegex = result
End Function

Private Function RootPattern(ByVal root As String) As String
    ' A folder path as a pattern that also matches its doubled-backslash (JSON) and forward-slash forms.
    RootPattern = Replace(EscapeRegex(root), "\\", "[\\/]+")
End Function

Private Function CaseForms(ByVal word As String) As String
    ' The word as written, lower-cased and upper-cased, as one escaped alternation: VBScript's RegExp folds the case of ASCII letters only, so a
    ' Cyrillic or Greek name written in another case would be missed. LCase$ and UCase$ are Unicode-aware.
    CaseForms = "(?:" & EscapeRegex(word) & "|" & EscapeRegex(LCase$(word)) & "|" & EscapeRegex(UCase$(word)) & ")"
End Function

Private Function ScrubNeedle(ByVal regex As Object, ByVal text As String, ByVal needle As String, ByVal marker As String) As String
    ' A word-matched needle wherever no ASCII letter or digit is next to it (start of text, tab, quote ...); any other only as a whole folder name.
    Dim result As String
    result = text
    If Len(needle) > 0 Then
        If NameInsideComponents(LCase$(needle)) Then
            regex.Pattern = "(^|[^A-Za-z0-9])" & CaseForms(needle) & "(?=[^A-Za-z0-9]|$)"
            result = regex.Replace(result, "$1" & marker)
        Else
            regex.Pattern = "([\\/])" & CaseForms(needle) & "(?=[.,;)]*(?:[\\/\s""'<>|:*?]|$))"
            result = regex.Replace(result, "$1" & marker)
        End If
    End If
    ScrubNeedle = result
End Function

Private Function PrivacyScrub(ByVal text As String) As String
    ' Every message a volunteer might screenshot, every log line and every text file in the output goes through this. In order: the tail
    ' of any path under \Users\<x> (x is not Public; a name with a space, an 8.3 name, a Dropbox (Company) folder: all of it, up to a
    ' quote, a line end, a tab or the sentence end) becomes <user>\<path>; the profile, OneDrive and Documents folders likewise; the
    ' Windows user name and the profile folder's own name (anywhere when guarded, else only as a whole folder name) become <user>; the
    ' computer, domain and logon server names (whole tokens, guarded) become <host>; a \\server\share prefix becomes <share>.
    Dim regex As Object, result As String, roots(0 To 4) As String, names(0 To 1) As String, machines(0 To 2) As String
    Dim k As Long, tailEnd As String, swap As String, exempt As String
    tailEnd = "(?=[.,;)]*(?:[""'\r\n<>|]|$))"
    exempt = "(?!(?:public|default|all users|shared)(?:[\\/""'\r\n<>|]|$))"
    result = text
    Set regex = CreateObject("VBScript.RegExp")
    regex.Global = True
    regex.IgnoreCase = True
    regex.Pattern = "([\\/]Users[\\/]+)" & exempt & "[^\\/""'\r\n<>|:*?]+?((?:\\\\|[\\/](?![""']))+)(?:[^""'\r\n<>|\\]|\\\\|\\(?![""']))*"
    result = regex.Replace(result, "$1<user>$2<path>")
    regex.Pattern = "([\\/]Users[\\/]+)" & exempt & "[^\\/""'\r\n<>|:*?]+?" & tailEnd
    result = regex.Replace(result, "$1<user>")
    roots(0) = EnvText("USERPROFILE")
    roots(1) = EnvText("OneDrive")
    roots(2) = EnvText("OneDriveCommercial")
    roots(3) = EnvText("MYDOCUMENTS")
    roots(4) = EnvText("OneDriveConsumer")
    For k = 0 To 4
        If Len(roots(k)) > 0 Then
            regex.Pattern = RootPattern(roots(k)) & "((?:\\\\|[\\/](?![""']))+)(?:[^""'\r\n<>|\\]|\\\\|\\(?![""']))*"
            result = regex.Replace(result, "<user>$1<path>")
            regex.Pattern = RootPattern(roots(k))
            result = regex.Replace(result, "<user>")
        End If
    Next k
    names(0) = EnvText("USERNAME")
    names(1) = LeafOf(Replace(EnvText("USERPROFILE"), "/", "\"))
    ' The longer of the two first (jsmith.ACME before jsmith), so no part of the profile folder's name is left behind.
    If Len(names(1)) > Len(names(0)) Then
        swap = names(0)
        names(0) = names(1)
        names(1) = swap
    End If
    machines(0) = EnvText("COMPUTERNAME")
    machines(1) = EnvText("USERDOMAIN")
    machines(2) = Replace(EnvText("LOGONSERVER"), "\", "")
    For k = 0 To 1
        result = ScrubNeedle(regex, result, names(k), "<user>")
    Next k
    For k = 0 To 2
        result = ScrubNeedle(regex, result, machines(k), "<host>")
    Next k
    regex.Pattern = "(^|[^\\/\w:])(?:\\\\|//){1,2}[^\\/\s""'<>|:*?]+(?:\\\\|[\\/](?![""']))+(?:[^""'\r\n<>|\\]|\\\\|\\(?![""']))*"
    result = regex.Replace(result, "$1<share>")
    PrivacyScrub = result
End Function


' ---------------------------------------------------------------- step 3: load and run

' 0 = the builder ran (look for the zip); 1 = it did not run (the user was told what to do).
Private Function RunBuilder(ByVal runPath As String, ByVal basPath As String) As Long
    Dim host As Object, project As Object, comp As Object, victim As Object, started As Boolean
    Dim swApp As Object, errCode As Long, ok As Boolean, how As String
    RunBuilder = 1
    started = False
    ' Route a: import into the open VBA project through the VBE.
    On Error Resume Next
    Set host = Application
    Set project = host.VBE.ActiveVBProject
    If Err.Number <> 0 Then
        LogLine "route a (VBE import) unavailable: " & CStr(Err.Number) & " " & Err.Description
        Err.Clear
        On Error GoTo 0
        ManualFallback basPath, "SolidWorks did not give the launcher access to the VBA editor."
        Exit Function
    End If
    Set victim = Nothing
    Set victim = project.VBComponents(BUILDER_MODULE)
    Err.Clear
    If Not victim Is Nothing Then
        project.VBComponents.Remove victim
        If Err.Number <> 0 Then
            LogLine "route a: could not remove the old " & BUILDER_MODULE & " module: " & CStr(Err.Number) & " " & Err.Description
            Err.Clear
        End If
    End If
    project.VBComponents.Import runPath
    If Err.Number <> 0 Then
        LogLine "route a: import failed: " & CStr(Err.Number) & " " & Err.Description
        ok = (Err.Number = 1004 Or InStr(LCase$(Err.Description), "trust") > 0 Or InStr(LCase$(Err.Description), "programmatic") > 0)
        Err.Clear
        On Error GoTo 0
        If ok Then
            ManualFallback basPath, "The VBA editor refused the import. Enable " & Chr$(34) & "Trust access to the VBA project object model" & Chr$(34) & _
                " (the macro security / Trust Center setting of your SolidWorks VBA host), restart SolidWorks, and run the launcher again."
        Else
            ManualFallback basPath, "The import into the VBA project did not work."
        End If
        Exit Function
    End If
    Set comp = Nothing
    Set comp = project.VBComponents(BUILDER_MODULE)
    If comp Is Nothing Then
        LogLine "route a: import returned but no " & BUILDER_MODULE & " module is present"
        Err.Clear
        On Error GoTo 0
        ManualFallback basPath, "The import did not produce the builder module."
        Exit Function
    End If
    Err.Clear
    LogLine "route a: imported " & BUILDER_MODULE & " into the VBA project"
    ' Run it. First Application.Run, then SldWorks.RunMacro2 only when Run is not available at all.
    host.Run BUILDER_MODULE & ".main"
    If Err.Number = 0 Then
        LogLine "route a: ran " & BUILDER_MODULE & ".main with Application.Run"
        On Error GoTo 0
        RunBuilder = 0
        Exit Function
    End If
    how = CStr(Err.Number) & " " & Err.Description
    If Err.Number <> 438 And Err.Number <> 430 And Err.Number <> 429 And Err.Number <> 449 Then
        ' The builder started and raised an error out of main: do not run it a second time.
        LogLine "route a: Application.Run stopped with " & how
        Err.Clear
        On Error GoTo 0
        RunBuilder = 0
        Exit Function
    End If
    LogLine "route a: Application.Run not available (" & how & "); trying RunMacro2"
    Err.Clear
    Set swApp = host.SldWorks
    errCode = 0
    ok = swApp.RunMacro2(swApp.GetCurrentMacroPathName, BUILDER_MODULE, "main", 0, errCode)
    If Err.Number = 0 And ok Then
        LogLine "route a: ran " & BUILDER_MODULE & ".main with RunMacro2"
        On Error GoTo 0
        RunBuilder = 0
        Exit Function
    End If
    LogLine "route a: RunMacro2 failed: " & CStr(Err.Number) & " " & Err.Description & " error code " & CStr(errCode)
    Err.Clear
    On Error GoTo 0
    MsgBox Scrub("The builder is imported into the VBA project but the launcher cannot start it by itself." & vbCrLf & _
        "Open the VBA editor, click inside main in the FixtureBuilder module, and press Run (F5)." & vbCrLf & _
        "When it finishes, send the zip to Dutchy in a Discord direct message (or run upload if you turned automatic upload on in settings)."), vbInformation, "Dutchman Fixtures"
End Function

' Route b: the user imports and runs the builder by hand.
Private Sub ManualFallback(ByVal basPath As String, ByVal why As String)
    LogLine "route b (manual): " & why & " file " & basPath
    MsgBox Scrub(why & vbCrLf & vbCrLf & "Do this by hand:" & vbCrLf & _
        "1. In the VBA editor choose File > Import File and pick:" & vbCrLf & basPath & vbCrLf & _
        "2. Run FixtureBuilder.main." & vbCrLf & _
        "3. When it finishes, send the zip to Dutchy in a Discord direct message (or run upload in the launcher if you turned automatic upload on in settings)."), vbInformation, "Dutchman Fixtures"
End Sub

' ---------------------------------------------------------------- step 4: zip and upload

Private Sub FinishRun()
    Dim zipPath As String, fs As Object, finishText As String
    Set fs = CreateObject("Scripting.FileSystemObject")
    zipPath = GetSetting(SETTINGS_APP, SETTINGS_SECTION, "LastZip", "")
    If Len(zipPath) = 0 Or Not fs.FileExists(zipPath) Then
        LogLine "builder finished but wrote no LastZip"
        ' The builder's own finish text says how to zip the folder by hand when it could not make the zip.
        finishText = GetSetting(SETTINGS_APP, SETTINGS_SECTION, "LastFinish", "")
        If Len(finishText) = 0 Then finishText = "The builder finished but no zip was recorded. Look in the output folder it names, and send the zip to Dutchy in a Discord direct message."
        MsgBox Scrub(finishText), vbExclamation, "Dutchman Fixtures"
        Exit Sub
    End If
    LogLine "zip: " & zipPath
    If GetSetting(SETTINGS_APP, SETTINGS_SECTION, "UploadConsent", "no") = "yes" And Len(LoadLink()) > 0 Then
        UploadZip zipPath
    Else
        LogLine "upload is off: zip left for sending by hand"
        finishText = GetSetting(SETTINGS_APP, SETTINGS_SECTION, "LastFinish", "")
        If Len(finishText) = 0 Then finishText = "Next: send this zip to Dutchy in a Discord direct message:" & vbLf & zipPath
        ' A person is at the screen: show the zip in Explorer, then the same text the builder logged.
        RevealZip zipPath
        MsgBox Scrub(finishText), vbInformation, "Dutchman Fixtures"
    End If
End Sub

Private Sub RevealZip(ByVal zipPath As String)
    ' Never waits; if Explorer will not start, carry on.
    On Error Resume Next
    CreateObject("WScript.Shell").Run "explorer.exe /select,""" & zipPath & """", 1, False
End Sub

Private Sub UploadZip(ByVal zipPath As String)
    Dim fs As Object, folder As String, fileName As String, outFile As String, code As Long, receipt As String, url As String
    Set fs = CreateObject("Scripting.FileSystemObject")
    folder = fs.GetParentFolderName(zipPath)
    fileName = fs.GetFileName(zipPath)
    outFile = gDir & "\upload.out"
    DeleteIfThere outFile
    url = LoadLink() & "/builder"
    LogLine "uploading " & zipPath & " to " & MaskToken(gLink) & "/builder"
    ' curl.exe ships with Windows 10+. Run from the zip's folder so -F needs no path quoting.
    ' No -f: the portal always answers JSON, also on refusal ({status, error, message, fix_url}), so keep the
    ' body and judge success by the HTTP status (201 new batch, 200 already recorded).
    code = RunPs("Set-Location -LiteralPath " & Q(folder) & "; " & _
        "$http = & curl.exe -sS --max-time 900 -H 'Accept: application/json' -F " & Q("bundle=@" & fileName) & _
        " -o " & Q(outFile) & " -w '%{http_code}' " & Q(url) & " 2>&1; " & _
        "if ($http -match '^20[01]$') { exit 0 } else { Add-Content -LiteralPath " & Q(outFile) & " (' (HTTP ' + $http + ')'); exit 1 }")
    receipt = OneLine(ReadText(outFile))
    LogLine "upload exit " & CStr(code) & " receipt: " & receipt
    If code = 0 Then
        MsgBox Scrub("Uploaded. Receipt:" & vbCrLf & Left$(Scrub(receipt), 600) & vbCrLf & vbCrLf & "Zip kept at: " & zipPath), vbInformation, "Dutchman Fixtures"
    Else
        MsgBox Scrub("The upload did not work (" & Left$(Scrub(receipt), 300) & ")." & vbCrLf & _
            "Send this zip to Dutchy in a Discord direct message:" & vbCrLf & zipPath & vbCrLf & "You can also run upload to try again."), vbExclamation, "Dutchman Fixtures"
    End If
End Sub
