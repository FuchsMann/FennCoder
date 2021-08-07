program FennCode;

uses
  System.StartUpCopy,
  FMX.Forms,
  FoxCodeFormMain in 'FoxCodeFormMain.pas' {FoxCodeForm1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFoxCodeForm1, FoxCodeForm1);
  Application.Run;
end.
