program TrhedIcon32;

uses
  Forms,
  umMain in 'umMain.pas' {MainForm},
  about in 'about.pas' {AboutBox},
  umDm in 'umDm.pas' {DM: TDataModule},
  umDmTool in 'umDmTool.pas' {dmTool: TDataModule},
  umChild in 'umChild.pas' {fcDesign},
  Embroidery_Items in '..\lib\Embroidery_Items.pas',
  Embroidery_Lines32 in '..\lib\Embroidery_Lines32.pas',
  Embroidery_Painter in '..\lib\Embroidery_Painter.pas',
  Embroidery_rwTHR in '..\lib\Embroidery_rwTHR.pas',
  Embroidery_Viewer in '..\lib\Embroidery_Viewer.pas',
  Embroidery_Fill in '..\lib\Embroidery_Fill.pas',
  Embroidery_Fill_LCON in '..\lib\Embroidery_Fill_LCON.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Iconit32';
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(TdmTool, dmTool);
  Application.Run;
end.