unit FoxCodeFormMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit, FMX.Objects, FMX.Memo.Types,
  FMX.ScrollBox, FMX.Memo, DECUtil;

type
  TFoxCodeForm1 = class(TForm)
    pnlControl: TPanel;
    Splitter1: TSplitter;
    pnlMain: TPanel;
    btnEncode: TButton;
    btnDecode: TButton;
    edtPass: TEdit;
    lblPass: TLabel;
    btnFileSelect: TButton;
    StyleBook1: TStyleBook;
    objOpenDialog: TOpenDialog;
    objMemo: TMemo;
    pnlProgress: TPanel;
    prbProgress: TProgressBar;
    SizeGrip1: TSizeGrip;
    procedure btnFileSelectClick(Sender: TObject);
    procedure prcEncode(var _sFilePath: String);
    procedure prcDecode(var _sFilePath: String);
    procedure OnProgressProc(Size: Int64; Pos: Int64; State: TDECProgressState);
    procedure btnEncodeClick(Sender: TObject);
    procedure btnDecodeClick(Sender: TObject);
  strict private
    sFilename: String;
  end;

var
  FoxCodeForm1: TFoxCodeForm1;

implementation

uses
  DECCiphers, DECCipherBase;

{$R *.fmx}
{$R *.Windows.fmx MSWINDOWS}

procedure TFoxCodeForm1.OnProgressProc(Size: Int64; Pos: Int64;
  State: TDECProgressState);
begin
  prbProgress.Min := 0;
  prbProgress.Max := Size;
  if (State = Finished) then
  begin
    prbProgress.Value := prbProgress.Max;
  end
  else
  begin
    prbProgress.Value := Pos;
  end;
end;

procedure TFoxCodeForm1.btnDecodeClick(Sender: TObject);
begin
  if (edtPass.Text.Length > 6) and (edtPass.Text.Length < 24) then
  begin
    prcDecode(sFilename);
  end
  else
  begin
    objMemo.Lines.Add('Password/Hash needs to be between 6 and 24 Characters');
  end;
end;

procedure TFoxCodeForm1.btnEncodeClick(Sender: TObject);
begin
  if (edtPass.Text.Length > 6) and (edtPass.Text.Length < 24) then
  begin
    prcEncode(sFilename);
  end
  else
  begin
    objMemo.Lines.Add('Password/Hash needs to be between 6 and 24 Characters');
  end;
end;

procedure TFoxCodeForm1.btnFileSelectClick(Sender: TObject);
begin
  objOpenDialog := TOpenDialog.Create(Self);
  if objOpenDialog.Execute then
  begin
    objMemo.Lines.Clear;
    if FileExists(objOpenDialog.FileName) then
    begin
      sFilename := objOpenDialog.FileName;
      objMemo.Lines.Add(sFilename);
    end
    else
    begin
      objMemo.Lines.Add('File does not exist.');
    end;
  end;
end;

procedure TFoxCodeForm1.prcEncode(var _sFilePath: String);
var
  Cipher: TCipher_AES;
  sFilenameOld: String;
begin
  objMemo.Lines.Add('Encoding');
  prbProgress.Value := 0;

  Cipher := TCipher_AES.Create;

  try
    try
      Cipher.Init(RawByteString(edtPass.Text),
        RawByteString(#1#2#3#4#5#6#7#99), 0);
      Cipher.Mode := cmCBCx;
      sFilenameOld := _sFilePath;

      _sFilePath := _sFilePath + '.vix';

      Cipher.EncodeFile(sFilenameOld, _sFilePath, OnProgressProc);
      objMemo.Lines.Add('Done');
    except
      on E: Exception do
      begin
        objMemo.Lines.Clear;
        objMemo.Lines.Add(E.Message);
      end;
    end;
  finally
    Cipher.Free;
  end;
end;

procedure TFoxCodeForm1.prcDecode(var _sFilePath: String);
var
  Cipher: TCipher_AES;
  sFilenameOld: String;
begin
  objMemo.Lines.Add('Encoding');
  prbProgress.Value := 0;

  Cipher := TCipher_AES.Create;

  try
    try
      Cipher.Init(RawByteString(edtPass.Text),
        RawByteString(#1#2#3#4#5#6#7#99), 0);
      Cipher.Mode := cmCBCx;
      sFilenameOld := _sFilePath;

      Delete(_sFilePath, Length(_sFilePath) - 3, Length(_sFilePath));

      Cipher.DecodeFile(sFilenameOld, _sFilePath, OnProgressProc);
      objMemo.Lines.Add('Done');
    except
      on E: Exception do
      begin
        objMemo.Lines.Clear;
        objMemo.Lines.Add(E.Message);
      end;
    end;
  finally
    Cipher.Free;
  end;
end;

end.
