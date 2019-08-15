{*********************************************************************

  This software is to create consolidate file
  from the captured video on YI Smart Web Cam.

  Prorgammed by Chun Kang (ck@qsok.com / kurapa@kurapa.com)

*********************************************************************}

unit MainRtn;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.DateUtils, System.StrUtils,
  System.IOUtils, ShellAPI, rsFileVersion;

type

   TMyTime = record
     h, m, s: integer;
   end;

  TMainFrm = class(TForm)
    Label1: TLabel;
    eSourceDirectory: TEdit;
    Button1: TButton;
    Label2: TLabel;
    listSourceFiles: TListBox;
    Timez: TLabel;
    cbTimezone: TComboBox;
    Label3: TLabel;
    eTargetDirectory: TEdit;
    Button2: TButton;
    Button3: TButton;
    Label4: TLabel;
    Label5: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

    m_CurDir: string;

    procedure GetTimezone;
    procedure ValidateFileStructures;
    procedure DoConvert;
  end;

var
  MainFrm: TMainFrm;

implementation

{$R *.dfm}

function GetAppVersionStr: string;
var
  m_version: TrsFileVersion;
begin
  // Load Version Information
  m_version := TrsFileVersion.Create;
  m_version.GetFileVersion( ParamStr(0));
  Result := m_version.Version;
end;

procedure FindFiles(FilesList: TStringList; StartDir, FileMask: string);
var
  SR: TSearchRec;
  DirList: TStringList;
  IsFound: Boolean;
  i: integer;
begin
  if StartDir[length(StartDir)] <> '\' then
    StartDir := StartDir + '\';

  { Build a list of the files in directory StartDir
     (not the directories!)                         }

  IsFound :=
    FindFirst(StartDir+FileMask, faAnyFile-faDirectory, SR) = 0;
  while IsFound do begin
    FilesList.Add(StartDir + SR.Name);
    IsFound := FindNext(SR) = 0;
  end;
  FindClose(SR);

  // Build a list of subdirectories
  DirList := TStringList.Create;
  IsFound := FindFirst(StartDir+'*.*', faAnyFile, SR) = 0;
  while IsFound do begin
    if ((SR.Attr and faDirectory) <> 0) and
         (SR.Name[1] <> '.') then
      DirList.Add(StartDir + SR.Name);
    IsFound := FindNext(SR) = 0;
  end;
  FindClose(SR);

  // Scan the list of subdirectories
  for i := 0 to DirList.Count - 1 do
    FindFiles(FilesList, DirList[i], FileMask);

  DirList.Free;
end;

function IsNum(a:char):Boolean;
begin
  if (a>='0') and (a<='9') then
    Result := True
  else
    Result := False;
end;

procedure TMainFrm.ValidateFileStructures;
var
  i: integer;
  s: string;
begin
  i := listSourceFiles.Items.Count-1;
  while i>=0 do
  begin
    s := RightStr( listSourceFiles.Items[i], 25);
    if ( IsNum(s[1])=True
        and IsNum(s[2])=True
        and IsNum(s[3])=True
        and IsNum(s[4])=True
        and (s[5]='Y')
        and IsNum(s[6])=True
        and IsNum(s[7])=True
        and (s[8]='M')
        and IsNum(s[9])=True
        and IsNum(s[10])=True
        and (s[11]='D')
        and IsNum(s[12])=True
        and IsNum(s[13])=True
        and (s[14]='H')
        and (s[15]='\')
        and IsNum(s[16])=True
        and IsNum(s[17])=True
        and (s[18]='M')
        and IsNum(s[19])=True
        and IsNum(s[20])=True
        and (s[21]='S')
        and (s[22]='.')) then
    begin
      // do nothing
    end else begin
      // wrong file collected - remove that file to avoid miss calculation
      listSourceFiles.Items.Delete(i);
    end;

    dec(i);
  end;
end;

procedure TMainFrm.GetTimezone;
var
  s: String;
  ZoneInfo: TTimeZoneInformation;
begin
  GetTimeZoneInformation(ZoneInfo);
  s := 'Bias: ' + IntToStr(ZoneInfo.Bias);
  s := s + #13 + #10 + 'StandardName: ' + ZoneInfo.StandardName;
  s := s + #13 + #10 + 'StandardBias: ' + IntToStr(ZoneInfo.StandardBias);
  s := s + #13 + #10 + 'DaylightName: ' + ZoneInfo.DaylightName;
  s := s + #13 + #10 + 'DaylightBias: ' + IntToStr(ZoneInfo.DaylightBias);
end;

procedure TMainFrm.Label5Click(Sender: TObject);
begin
  ShellExecute( Handle, PWideChar('open'), PWideChar('http://qsok.com/display/YIHCM/YI+Home+Clip+Merger'), nil, nil, SW_SHOWNORMAL);
end;

procedure TMainFrm.Button2Click(Sender: TObject);
begin
  with TFileOpenDialog.Create(nil) do
    try
      Options := [fdoPickFolders];
      if Execute then
      begin
        eTargetDirectory.Text := FileName;
      end;
    finally
      Free;
    end;
end;

procedure TMainFrm.Button3Click(Sender: TObject);
begin
  DoConvert;
end;

procedure TMainFrm.DoConvert;
var
  i, j: integer;
  t1, t2: TMyTime;
  myDate: TDateTime;
  myBatch, myList:TStringList;
  s, cam_name, tmp_dir, target_video_group, target_video_text: string;

  // save the previous list
  procedure save_the_previous_list;
  begin
    if myList.Count>0 then
      myList.SaveToFile(tmp_dir + '\ck_' + target_video_group + '.txt',TEncoding.ANSI);
    myBatch.Add( '"' + m_CurDir + '\ffmpeg.exe" -f concat -safe 0 -i "' + tmp_dir + '\ck_' + target_video_group + '.txt" -c copy "' + eTargetDirectory.Text + '\' + target_video_group + '.mp4"');

    // myBatch.Add( '"' + m_CurDir + '\ffmpeg.exe" -f concat -safe 0 -i "' + tmp_dir + '\ck_' + target_video_group + '.txt" -vf drawtext="fontfile=/Windows/Fonts/arial.ttf:fontsize=30:fontcolor=green:text=''' + target_video_text + ''':x=(w-text_w)/2:y=(h-text_h*2)" -c copy "' + eTargetDirectory.Text + '\' + target_video_group + '.mp4"');
  end;

  // create a new file name and group to save files
  procedure create_new_list(new_filename:string);
  begin
    myList.Clear;
    myList.Add('file ''' + new_filename + '''');

    if (Length(cam_name)>0) then
    begin
      target_video_group := cam_name + '_' + formatdatetime('yyyy_mm_dd_hhnnss', myDate);
      target_video_text := cam_name + ': ' + formatdatetime('yyyy/mm/dd hh:nn:ss', myDate);
    end else begin
      target_video_group := formatdatetime('yyyy_mm_dd_hhnnss', myDate);
      target_video_text := formatdatetime('yyyy/mm/dd hh:nn:ss', myDate);
    end;
  end;

  // just add new one onto the existing list
  procedure add_new_one(new_filename:string);
  begin
    myList.Add('file ''' + new_filename + '''');
  end;

begin
  // Init environment
  myBatch := TStringList.Create;
  myList := TStringList.Create;

  cam_name := '';
  tmp_dir := GetEnvironmentVariable('TEMP');

  for i := 0 to listSourceFiles.Items.Count-1 do
  begin
    s := RightStr( listSourceFiles.Items[i], 25);

    myDate := EncodeDateTime(
                StrToInt(MidStr(s, 1, 4)), // Y
                StrToInt(MidStr(s, 6, 2)), // M
                StrToInt(MidStr(s, 9, 2)), // D
                StrToInt(MidStr(s, 12, 2)), // H
                StrToInt(MidStr(s, 16, 2)), // M
                StrToInt(MidStr(s, 19, 2)), // S
                0);

    // set timezone based on the user's location
    myDate := IncHour( myDate, StrToInt(cbTimezone.Items[cbTimezone.ItemIndex])); // GMT+9

    t1.h := StrToInt(MidStr(s, 12, 2));
    t1.m := StrToInt(MidStr(s, 16, 2));
    t1.s := StrToInt(MidStr(s, 19, 2));

    // Set Prefix if index=0
    if i=0 then
    begin
      j := Length(listSourceFiles.Items[i])-26;
      while j>0 do
      begin
        if listSourceFiles.Items[i][j]='\' then break;
        dec(j);
      end;

      if listSourceFiles.Items[i][j]='\' then inc(j);

      while(j<=Length(listSourceFiles.Items[i])) do
      begin
        if listSourceFiles.Items[i][j]='\' then break;
        cam_name := cam_name + listSourceFiles.Items[i][j];
        inc(j);
      end;
    end;


    if i=0 then begin
      // need a new file name and group to save files
      create_new_list(listSourceFiles.Items[i]);

    end else if (t1.h=t2.h) then begin // video files in same hour
      if ((t1.m-t2.m)=1) or ((t2.m=59) and (t1.m=0)) and (t1.s=0) then begin
        // just add new one onto the existing list
        add_new_one(listSourceFiles.Items[i]);
      end else begin
        save_the_previous_list;

        // create a new file name and group to save files
        create_new_list(listSourceFiles.Items[i]);
      end;
    end else if ((t1.h-t2.h)=1) or ((t2.h=23) and (t1.h=0)) then begin
      if ((t1.m-t2.m)=1) or ((t2.m=59) and (t1.m=0)) and (t1.s=0) then begin
        // just add new one onto the existing list
        add_new_one(listSourceFiles.Items[i]);
      end else begin
        save_the_previous_list;

        // new a new file name and group to save files
        create_new_list(listSourceFiles.Items[i]);
      end;
    end else begin
        save_the_previous_list;

        // new a new file name and group to save files
        create_new_list(listSourceFiles.Items[i]);
    end;

    t2 := t1;
  end;
  save_the_previous_list;

  myBatch.Add('del "' + tmp_dir + '\ck_*.txt"');
  // myBatch.SaveToFile(tmp_dir + '\ck_yi_int.bat',TEncoding.UTF8);
  myBatch.SaveToFile(tmp_dir + '\ck_yi_int.bat',TEncoding.ANSI);
  myBatch.Destroy;
  myList.Destroy;

  ShellExecute(Handle, PWideChar('open'), PWideChar(tmp_dir + '\ck_yi_int.bat'), nil, nil, SW_SHOWNORMAL) ;
  Close;
end;

procedure TMainFrm.FormCreate(Sender: TObject);
begin
  m_CurDir := GetCurrentDir;
  eTargetDirectory.Text := TPath.GetMoviesPath;
  MainFrm.Caption := MainFrm.Caption + ' v' + GetAppVersionStr;
end;

procedure TMainFrm.Button1Click(Sender: TObject);
var
  myFiles: TStringList;
begin
  GetTimezone;
  with TFileOpenDialog.Create(nil) do
    try
      Options := [fdoPickFolders];
      if Execute then
      begin
        eSourceDirectory.Text := FileName;
        myFiles := TStringList.Create;
        FindFiles(myFiles, FileName, '*.mp4');
        listSourceFiles.Items.Assign( myFiles);
        myFiles.Destroy;
      end;
    finally
      Free;
    end;
    ValidateFileStructures;
end;

end.
