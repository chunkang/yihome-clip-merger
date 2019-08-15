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
