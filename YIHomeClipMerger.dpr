{*********************************************************************

  This software is to create consolidate file
  from the captured video on YI Smart Web Cam.

  Prorgammed by Chun Kang (ck@qsok.com / kurapa@kurapa.com)

*********************************************************************}

program YIHomeClipMerger;

uses
  Vcl.Forms,
  MainRtn in 'MainRtn.pas' {MainFrm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainFrm, MainFrm);
  Application.Run;
end.
