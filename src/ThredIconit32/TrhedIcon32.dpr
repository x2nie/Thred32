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
  Embroidery_rwSHP in '..\lib\Embroidery_rwSHP.pas',
  umDaisyDlg in 'umDaisyDlg.pas' {frmDaisyDlg},
  gmCore_UndoRedo in '..\..\..\..\..\..\..\UI\GR32\graphicsmagic_svn\branches\GraphicsMagic_2_0_1\Source\gmCore_UndoRedo.pas',
  Embroidery_Refill in '..\lib\Embroidery_Refill.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Iconit32';
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(TdmTool, dmTool);
  Application.CreateForm(TfrmDaisyDlg, frmDaisyDlg);
  Application.Run;
end.
