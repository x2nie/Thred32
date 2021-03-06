unit umChild;

interface

uses
  Windows, Classes, Graphics, Forms, Controls, Messages, StdCtrls, SysUtils,
{GR32}
  GR32, GR32_Image, GR32_Layers,
{GraphicsMagic}
  gmIntegrator, //gmGridBased_List,
  gmCore_UndoRedo,
  //gmSwatch_List,
  gmIntercept_GR32_Image,
{Thred32}
  Embroidery_Items, Embroidery_Painter,
  //Stitch_items, //Stitch_rwTHR, Stitch_rwPCS, Stitch_rwPES,
  Embroidery_rwTHR,
  Embroidery_Refill,

  Menus, ActnList, ComCtrls, ToolWin, ExtCtrls, gmCore_Items,
  gmGridBased, gmSwatch, gmShape, GR32_RangeBars ;

type
{$DEFINE MODERNITEM}

  TfcDesign = class(TForm)
    swlCustom: TgmSwatchList;
    imgStitchs: TImgView32;
    timerLazyLoad: TTimer;
    lblLoading: TLabel;
    pnl1: TPanel;
    pbPreview: TPaintBox32;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Button1: TButton;
    Button2: TButton;
    chkDrawgrid: TCheckBox;
    chkVideo: TCheckBox;
    gbrSpace1: TGaugeBar;
    btnNewStar: TButton;
    rg1: TRadioGroup;
    Memo1: TMemo;
    btnDump: TButton;
    ToolBar1: TToolBar;
    Splitter1: TSplitter;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure actUseOrdinalColorExecute(Sender: TObject);
    procedure imgStitchsScroll(Sender: TObject);
    procedure timerLazyLoadTimer(Sender: TObject);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure imgStitchsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
    procedure FormDestroy(Sender: TObject);
    procedure btnNewStarClick(Sender: TObject);
    procedure btnDumpClick(Sender: TObject);
  private
    { Private declarations }
    FModified: boolean;
    FStitchLoaded : boolean;
    gmSource : TgmIntegratorSource;
    FUseOrdinalColor: boolean;
    //FDrawLine : TEmbroidery_LineProc;
    FPainter  : TEmbroideryPainter;
    FThred : TThred;
    
    //FSelections : TArrayOfArrayOfInteger;// TArrayOfPArrayOfgmShapeInfo;
    //FShapes : TArrayOfTgmShapeInfo;
    //FPolyPolygons : TArrayOfArrayOfgmShapeInfo;
    FShapeList: TEmbroideryList;
    FDrawQuality: Integer;
    FUndoRedo: TgmUndoRedo;
    procedure SetDrawQuality(const Value: Integer);
    procedure SetUseOrdinalColor(const Value: boolean);
    function GetPolyPolygons: PArrayOfArrayOfgmShapeInfo;
    function GetSelections: PArrayOfArrayOfInteger;
    procedure SetPainter(const Value: TEmbroideryPainter);
    procedure RefreshScreenEvent(Sender:TObject);
    procedure Verbose(const VerboseMsg: string);

//    function GetPolyPolygons: PArrayOfArrayOfgmShapeInfo;
//    procedure SetSelectedIndex(const Value: Integer);
//    function GetSelections: PArrayOfArrayOfInteger;
  protected
//    FSelectedIndex {PolyPolygon}: Integer;

    //fired when starting/during/ending a "move" or "size" window
    procedure WMEnterSizeMove(var Msg: TMessage) ; message WM_ENTERSIZEMOVE;
    procedure WMExitSizeMove(var Msg: TMessage) ; message WM_EXITSIZEMOVE;
    procedure WMPosChanging(var Msg : TMessage); message WM_WINDOWPOSCHANGING;

    //property PainterClass : TEmbroideryPainter read FPainter write SetPainter;
    property Painter : TEmbroideryPainter read FPainter write SetPainter;
  public
    { Public declarations }
    procedure DrawStitchs;
//    function AddShape(AddMode: TgmEditMode; Index : Integer = -1) : PgmShapeInfo;
    procedure LoadFromFile(const AFileName: string);
    property DrawQuality : Integer read FDrawQuality write SetDrawQuality;// render func index
    property UseOrdinalColor : boolean read FUseOrdinalColor write SetUseOrdinalColor;
    property UndoRedo : TgmUndoRedo read FUndoRedo;

    property Modified : boolean read FModified;
    {$IFDEF MODERNITEM}
    //new mode
    property ShapeList : TEmbroideryList read FShapeList;

    {$ELSE}
    //old mode
    property PolyPolygons : PArrayOfArrayOfgmShapeInfo read GetPolyPolygons;
//    property SelectedIndex {PolyPolygon}: Integer read FSelectedIndex write SetSelectedIndex;
    property Selections : PArrayOfArrayOfInteger {PArrayOfPArrayOfgmShapeInfo} read GetSelections;
    {$ENDIF}
  end;


//Global proc
procedure CreateMDIChild(const AFileName: string); //called by MainForm.


implementation
{.$DEFINE GR32_200UP}

uses
  {$IFDEF GR32_200UP}
  //GR32_PolygonsEx,
  GR32_Polygons,
  GR32_VectorUtils,
  GR32_PolygonsOld,
  {$ELSE}
  GR32_PolygonsEx, //VPR
  GR32_VectorUtils, //VPR
  {$ENDIF}

  Thred_Constants,
  Embroidery_Lines32, Embroidery_Defaults {Thred_Defaults} ,
  //Embroidery_Fill, Embroidery_Fill_LCON,
  umMain, umDm, Math;

{$R *.dfm}
{$R VirtualTrees.res}

  function Polygon32Arc(CenterX,CenterY, DistanceX,DistanceY:TFloat; Vertices:integer):TArrayOfFloatPoint;
  var i : integer;
    fp : TFloatPoint;
    aPie : Double;
  begin
    aPie := 360 / Vertices;
    SetLength(Result, Vertices +1);
    for i := 0 to Vertices -1 do
    begin
      fp.X := round(centerX + cos(degtoRad(i * aPie))*DistanceX);
      fp.Y := round(centerY + sin(degToRad(i * aPie))*DistanceY);
      Result[i] := fp;
    end;
    Result[Vertices] := result[0];
  end;

type
  TImgView32Access = class(TImgVIew32);

  
procedure CreateMDIChild(const AFileName: string);
var
  Child: TfcDesign;
  x : PByteArray;
begin
  { create a new MDI child window }
  Child := TfcDesign.Create(Application);
  Child.Caption := AFileName;
  //if FileExists(AFileName) then Child.LoadFromFile(AFileName);
  if FileExists(AFileName) then
    Child.ShapeList.FileName := AFileName; // Lazy Loading. for avoid flicker / hang while first time visibled.
end;

procedure TfcDesign.FormCreate(Sender: TObject);
begin
  self.imgStitchs.Align := alClient;
  FThred := TThred.Create;
  FThred.VerboseProc := Verbose;
  FThred.Ini := DM.ThredIni; //set it to pointer type?

  imgStitchs.Bitmap.SetSize(400,400);// hup size
  imgStitchs.Bitmap.Clear(clWhite32);

  gmSource := TgmIntegratorSource.Create(self);
  gmSource.Img32 := imgStitchs;

  FShapeList := TEmbroideryList.Create(self);
  FUndoRedo := TgmUndoRedo.Create(self);
  FUndoRedo.Target := FShapeList;
  FUndoRedo.OnUndoRedo := RefreshScreenEvent;
  //FDrawLine := Draw3DLine;//DrawLineStippled;//DrawLineFS;
  //FPainter  := TEmbroideryPainter;
  DrawQuality := DQBASICSOLID;//DQINDOORPHOTO;//DQDEBUG;//
  FUseOrdinalColor := True;

//  FSelectedIndex := -1;
//  SetLength(FSelections,0);
//DEBUG
  btnNewStar.Click;
  //btnDump.Click;
end;

procedure TfcDesign.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  {$IFDEF DEBUGLOG} ActiveIntegrator.DoDebugLog(Self, 'FormClose', 0); {$ENDIF}

  Action := caFree;
  TMainForm(Application.MainForm).ActiveChild := nil; //send signal to MDI form for ready reflect changes. such color swatch
end;

procedure TfcDesign.LoadFromFile(const AFileName: string);
var
  i : integer;
begin
///
//  FStitchs.LoadFromFile(AFileName);
  FShapeList.LoadFromFile(AFileName);
{  for i := 0 to High(FStitchs.Colors) do
  begin
    if swlCustom.Count < i +1 then
      swlCustom.Add;
    swlCustom[i].Color := FStitchs.Colors[i];
  end;}
  DrawStitchs();
  {imgStitchs.Show;
  lblLoading.Hide;

  if Application.MainForm.ActiveMDIChild = Self then
    FormActivate(self); // send signal to MDI MainForm
  }
end;


procedure TfcDesign.FormActivate(Sender: TObject);
begin
  {$IFDEF DEBUGLOG} ActiveIntegrator.DoDebugLog(Self, 'FormActivate', 0); {$ENDIF}

  //send signal to MDI MainForm to reflect my (childform) properties; such colors swatch

  self.gmSource.Activate; //set ready to TgmTool
  if imgStitchs.Visible then
    imgStitchs.SetFocus; //allow mouse wheel

///  if Length(FStitchs.Stitchs) > 0 then
    TMainForm(Application.MainForm).ActiveChild := self;

end;

procedure TfcDesign.actUseOrdinalColorExecute(Sender: TObject);
begin
  self.DrawStitchs;
end;

procedure TfcDesign.DrawStitchs;
var
  LXorPoints: TArrayOfArrayOfFloatPoint;

  (*procedure LDrawSelectionXor();
  var i,j : Integer;
    LPoints : TArrayOfPoint;
    LCanvas : TCanvas;
  begin
    LCanvas := imgStitchs.Bitmap.Canvas;
    LCanvas.Pen.Mode := pmNotXor;

    for i := 0 to Length(LXorPoints) -1 do
    begin
      SetLength(LPoints, Length(LXorPoints[i]) );
      for j := 0 to Length(LXorPoints[i])-1 do
      begin
        LPoints[j] := Point( LXorPoints[i,j] );
      end;

      LCanvas.Polyline( LPoints );
    end;
  end;

  procedure LDrawSelection1();
  var i,j : Integer;
    LPoints : TArrayOfFloatPoint;
  begin


    for i := 0 to Length(LXorPoints) -1 do
    begin

      for j := 0 to Length(LXorPoints[i])-1 do
      begin
        //LPoints[j] := Point( LXorPoints[i,j] );
        with LXorPoints[i,j] do
          LPoints := Ellipse(x,y, 3,3, 12);

//        PolygonFS(imgStitchs.Bitmap, LPoints, clTrRed32);

      end;

    end;
  end;

  (*procedure LDrawSelection2();
  var i,j,k : Integer;
    LDotPoints : TArrayOfFloatPoint;
    LShapes : PArrayOfgmShapeInfo;
  begin
    for i := 0 to Length(FSelections) -1 do
    begin
      LShapes := FSelections[i];
      if LShapes <> nil then
      for j := 0 to Length(LShapes^)-1 do
      begin

        for k := 0 to Length(LShapes^[j].Points)-1 do
        begin
          with LShapes^[j].Points[k] do
            LDotPoints := Ellipse(x,y, 3,3, 12);
          PolygonFS(imgStitchs.Bitmap, LDotPoints, clTrRed32);
        end;
      end;

      {if FSelections[i]^ <> nil then
      for j := 0 to Length(FSelections[i]^)-1 do
      begin

        for k := 0 to Length(FSelections[i]^[j].Points)-1 do
        begin
          with FSelections[i]^[j].Points[k] do
            LDotPoints := Ellipse(x,y, 3,3, 12);
          PolygonFS(imgStitchs.Bitmap, LDotPoints, clTrRed32);
        end;
      end;}
    end;
  end;*)

  procedure LDrawSelection();
  var i,j,k : Integer;
    LDotPoints : TArrayOfFloatPoint;
    LShapes : PArrayOfgmShapeInfo;
    //LShapes : TgmShapeItem;
  begin
    for i := 0 to FShapeList.SelectionItems.count -1 do
    begin

      LShapes :=  TgmShapeItem(FShapeList.SelectionItems[i]).PolyPolygon;

      if LShapes <> nil then
      for j := 0 to Length(LShapes^)-1 do
      begin

        for k := 0 to Length(LShapes^[j].Points)-1 do
        begin
          with LShapes^[j].Points[k] do
            LDotPoints := Polygon32Arc(x,y, 3,3, 36);
          PolygonFS(imgStitchs.Bitmap, LDotPoints, clTrRed32);
        end;
      end;

      {if FSelections[i]^ <> nil then
      for j := 0 to Length(FSelections[i]^)-1 do
      begin

        for k := 0 to Length(FSelections[i]^[j].Points)-1 do
        begin
          with FSelections[i]^[j].Points[k] do
            LDotPoints := Ellipse(x,y, 3,3, 12);
          PolygonFS(imgStitchs.Bitmap, LDotPoints, clTrRed32);
        end;
      end;}
    end;
    SetLength(LDotPoints,0);
  end;

var i,j : Integer;
  zRat : TFloatPoint;
  ColorAt :Cardinal;
  LastColor,CurrentColor : TColor32;
  R : TFloatRect;
  LPoints : TArrayOfArrayOfFloatPoint;
  
  first : boolean;
  b : byte;
  C : TColor32;
  LShapeItem : TEmbroideryItem;
  LPolyPolyGon : TArrayOfgmShapeInfo;
  LStitchs : TArrayOfStitchPoint;
  M : TBitmap32;
  BackgroundFileName : string;
begin
  {$IFDEF DEBUGLOG} ActiveIntegrator.DoDebugLog(Self, 'DrawStitchs', 0); {$ENDIF}


  //We will do painting while there is something to draw.
  //if Length(FStitchs.Stitchs) = 0 then exit;   But, we might have a new form.

  LastColor := clNone;

  imgStitchs.Bitmap.SetSize(Ceil(ShapeList.HupWidth), Ceil(ShapeList.HupHeight));

  zRat.X := ( imgStitchs.Width / ShapeList.HupWidth );
  zRat.Y := ( imgStitchs.Height / ShapeList.HupHeight );

  if zRat.X < zRat.Y then
    zRat.Y := zRat.X
  else
    zRat.X := zRat.Y;

  zRat.x := 1; //debug
  zRat.Y := 1; //debug

  with imgStitchs do
  begin
    BeginUpdate;
    try

      //if not FPainter.WantToClear then      begin
        BackgroundFileName := ExtractFilePath(Application.ExeName)+'\Assets\bg.bmp';
        if FileExists(BackgroundFileName) then
        begin
          M:= TBitmap32.Create;
          try
            M.LoadFromFile(BackgroundFileName);
            for i := 0 to Bitmap.Height div M.Height do
            for j := 0 to Bitmap.Width div M.Width do
            begin
              M.DrawTo(Bitmap, j * M.Width, i* M.Height);
            end;
          finally
            M.Free;
          end;
          FPainter.WantToClear := False;
        end
        else
          //Bitmap.Clear(clWhite32);
          FPainter.WantToClear := True;
      //end;

      //

      //R := FloatRect(Bitmap.BoundsRect);
      //FDrawLine(Bitmap, R, clWhite32, sdlStart);
//      FPainter.BeginPaint(Bitmap);

      if FShapeList.Count > 0 then

      for j := 0 to FShapeList.Count -1 do
      begin
        LShapeItem := FShapeList[j];

        // DO FILLING ALGORITHM HERE, IF NECESSARY
        if Length(LShapeItem.Stitchs^) <= 0 then
        begin
          //fnhrz(LShapeItem, nil);
          //LCON(LShapeItem);
          try
            FThred.ResetVars(self);
            //fnhrz(LShapeItem, nil);
            self.FThred.fnvrt(LShapeItem);  LShapeItem.Stitchs^ := @self.FThred.publins^[0]; //FThred.lins := nil; 
            //rulV.ZeroPixel := Round(LShapeItem.Stitchs^[0].Y);
            self.FThred.LCON(LShapeItem);   LShapeItem.Stitchs^ := @self.FThred.pubbseq^[0]; 
            Self.FThred.bakseq;             LShapeItem.Stitchs^ := @self.FThred.pubOseq^[0];
          except
            Verbose('ERROR ON bakseq');
          end;
        end;
      end;

      FPainter.Paint(FShapeList);

        //STITCH
        //PArrayOfStitchPoint(LStitchs) := LShapeItem.Stitchs;
        {LStitchs := LShapeItem.Stitchs^;
        for i := 0 to High(LStitchs) do
        begin
          // Bitmap.PenColor:= clBlack32;
          with LStitchs[i] do
          begin
            ColorAt := at and $FF;
            if ColorAt > High(FShapeList.colors) then
              ColorAt := at and $0F;

            if UseOrdinalColor then
              CurrentColor := Color32( defCol[ ColorAt ] )
            else
              CurrentColor := Color32( FShapeList.Colors[ ColorAt ] );

            if i = 0 then
            begin
              R.TopLeft := floatPoint(x * zRat.X, y * zRat.Y);
            end
            else
            begin
              R.BottomRight := floatPoint(x * zRat.X, y * zRat.Y);

              //JUMP STITCH + COLOR CHANGED.
              if CurrentColor = LastColor then
              FDrawLine(Bitmap, R, CurrentColor, sdlLine);

              R.TopLeft := R.BottomRight;

            end;
            LastColor := CurrentColor;
            {if i = 0 then
              pb.Buffer.MoveToF(x * zRat.X, y * zRat.Y)
            else
              pb.Buffer.LineToFS(x * zRat.X, y * zRat.Y);
          end;
        end;
        //R := FloatRect(0,0, FShapeList.HeaderEx.xhup * zRat.X, FShapeList.HeaderEx.yhup * zRat.Y);

        R := FloatRect(Bitmap.BoundsRect);

        FDrawLine(Bitmap, R, Color32(FShapeList.BgColor), sdlFinish); }
        //fnhrz(TEmbroideryItem( FShapeList[i]), Bitmap);
        {
        LPolyPolyGon := FShapeList[i].PolyPolygon^;
        if Length(LPolyPolyGon) <= 0 then
          Continue;
          
        SetLength(LPoints, Length(LPolyPolyGon));
        for j := 0 to Length(LPolyPolyGon)-1 do
        begin
          if length(LPolyPolyGon[j].Points) = 0 then
            continue;
          LPoints[j] := LPolyPolyGon[j].Points;
        end;

        ActiveIntegrator.DoDebugLog(Self,
          Format('Points[%d]: %d',[i, Length(LPolyPolyGon) ]) ) ;

        PolyPolygonFS(Bitmap, LPoints, clTrRed32); //FPolyPolygons[i,0].BackColor);
        PolyPolylineFS(Bitmap, LPoints, clTrBlack32);

        //if i = FSelectedIndex then
          //LXorPoints := LPoints;
        }
      //end;//for

      //FPainter.EndPaint(Bitmap);

      //if FSelectedIndex >= 0 then
        LDrawSelection();

    finally
      SetLength(LPoints,0);
      EndUpdate;
      Changed;
    end;
  end;
end;

procedure TfcDesign.WMEnterSizeMove(var Msg: TMessage);
begin
  if csDestroying in Self.ComponentState then Exit;
  {$IFDEF DEBUGLOG} ActiveIntegrator.DoDebugLog(Self, 'WMEnterSizeMove', 0); {$ENDIF}

  //code here
  inherited;
end;

procedure TfcDesign.WMExitSizeMove(var Msg: TMessage);
begin
  if csDestroying in Self.ComponentState then Exit;
  {$IFDEF DEBUGLOG} ActiveIntegrator.DoDebugLog(Self, 'WMExitSizeMove', 0); {$ENDIF}

  //code here
  TMainForm(Application.MainForm).RullersRedraw;
  inherited
end;

procedure TfcDesign.WMPosChanging(var Msg: TMessage);
begin
  if csDestroying in Self.ComponentState then Exit;
  {$IFDEF DEBUGLOG} ActiveIntegrator.DoDebugLog(Self, 'WMPosChanging', 0); {$ENDIF}

  //code here
  TMainForm(Application.MainForm).RullersRedraw;
  inherited;
end;

  
procedure TfcDesign.imgStitchsScroll(Sender: TObject);
begin
  TMainForm(Application.MainForm).RullersRedraw;
  //caption := format('%d, %d',[TImgView32Access(imgStitchs).HScroll.Range, TImgView32Access(imgStitchs).VScroll.Range]);
end;

procedure TfcDesign.timerLazyLoadTimer(Sender: TObject);
begin
  if not (csLoading in self.ComponentState) and self.Visible and not FStitchLoaded then
  begin
    timerLazyLoad.Enabled := False;
    FStitchLoaded := True;
////
    if FShapeList.FileName <> '' then
    begin
      self.LoadFromFile(FShapeList.FileName);
    end
    else
    begin

    end;

    imgStitchs.Show;
    lblLoading.Hide;

    if Application.MainForm.ActiveMDIChild = Self then
      FormActivate(self); // send signal to MDI MainForm
  end;

end;

procedure TfcDesign.SetDrawQuality(const Value: Integer);
begin
  if FDrawQuality <> Value then
  begin
    FDrawQuality := Value;
    //it is modified by my own (childform) render quality menu.
    case Value of
      //1 : FDrawLine := DrawWireFrame;
      2 : Painter  := TEmbroideryPainter.Create(imgStitchs);  //Solid
      3 : Painter  := TEmbroideryPhotoPainter.Create(imgStitchs);  //Photo
      {4 : Painter  := TEmbroideryOutDoorPhotoPainter;//Outdoor Photo
      5 : Painter  := TEmbroideryMountainPainter;
      6 : Painter  := TEmbroideryXRayPainter;        //
      7 : Painter  := TEmbroideryHotPressurePainter;
      }8 : Painter  := TEmbroideryDebugLinPainter.Create(imgStitchs);
      9 : Painter  := TEmbroideryDebugGrpPainter.Create(imgStitchs);
      10 : Painter  := TEmbroideryDebugRegionPainter.Create(imgStitchs);
      {11 : Painter  := TEmbroideryByJumpPainter ;
      12 : Painter  := TEmbroideryByWesternPainter ;
      }13 : Painter  := TEmbroideryDebugRgnsPainter.Create(imgStitchs);
      14 : Painter  := TEmbroideryDebugBrkPainter.Create(imgStitchs);
      15 : Painter  := TEmbroideryDebugCntBrkPainter.Create(imgStitchs);

    end;
    //pb.Repaint;
    self.DrawStitchs;
  end;
end;

procedure TfcDesign.SetUseOrdinalColor(const Value: boolean);
begin
  if FUseOrdinalColor <> Value then
  begin
    FUseOrdinalColor := Value;
    DrawStitchs;
  end;
end;

procedure TfcDesign.FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  if [ssShift, ssAlt] * Shift <> [] then //modifiered?
    imgStitchs.Scroll(16,0) //
  else
    imgStitchs.Scroll(0, 16) //end;
end;

procedure TfcDesign.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  if [ssShift, ssAlt] * Shift <> [] then //modifiered?
    imgStitchs.Scroll(-16, 0) //
  else
    imgStitchs.Scroll(0, -16) //end;
end;

procedure TfcDesign.imgStitchsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer;
  Layer: TCustomLayer);
begin
  {$IFDEF DEBUGLOG} ActiveIntegrator.DoDebugLog(Self, 'imgStitchsMouseDown', 0); {$ENDIF}

  //caption :=  inttostr(Ord(Button));
end;

(*function TfcDesign.AddShape(AddMode: TgmEditMode; Index : Integer = -1): PgmShapeInfo;
var
  Len, N : Integer;
  LPolygon : PArrayOfgmShapeInfo;
  LNewPoly2 : Boolean;
begin
  LNewPoly2 := (AddMode = emNew) or (Length(FPolyPolygons) = 0) or  (Index >= Length(FPolyPolygons) );
  if (Index = -1) or LNewPoly2 then  // the last?
  begin
    if LNewPoly2 then //Has no item, add!
    begin
      Len := Length(FPolyPolygons);
      SetLength(FPolyPolygons, Len+1);
    end;
    
    //LPolygon := @FPolyPolygons[ High(FPolyPolygons)];
    index := High(FPolyPolygons); // the last!
  end
  else
  begin
    //LPolygon := @FPolyPolygons[ Index ];
  end;


  LPolygon := @FPolyPolygons[ Index ];
  Len := Length(LPolygon^);
  SetLength(LPolygon^, Len + 1);
  Result := @LPolygon^[Len];

  //SELECT IT
  FSelectedIndex := index;
  {$IFDEF DEBUGLOG} ActiveIntegrator.DoDebugLog(Self,Format('AddShapeInfoSelection %d %d',[index, Len]) ); {$ENDIF}
  AddShapeInfoSelection(index, Len, FPolyPolygons, FSelections);
end;  *)

{function TfcDesign.GetPolyPolygons: PArrayOfArrayOfgmShapeInfo;
begin
  Result := @FPolyPolygons;
end;}

(*procedure TfcDesign.SetSelectedIndex(const Value: Integer);
begin
  {$IFDEF DEBUGLOG} ActiveIntegrator.DoDebugLog(Self, 'SetSelectedIndex', 0); {$ENDIF}

  if FSelectedIndex <> Value then
  begin
    FSelectedIndex := Value;
    imgStitchs.Invalidate;
  end;
end;*)

{function TfcDesign.GetSelections: PArrayOfArrayOfInteger;
begin
  //Result := nil;
  //if FSelections <> nil then
    Result := @FSelections;
end;}

procedure TfcDesign.FormDestroy(Sender: TObject);
begin
  {$IFDEF DEBUGLOG} ActiveIntegrator.DoDebugLog(Self, 'FormDestroy', 0); {$ENDIF}
//  ClearShapes(FPolyPolygons);
  //SetLength(FPolyPolygons,0);
//  FPolyPolygons := nil;
  //FSelections := nil;
//  SetLength(FSelections,0);
//  FSelections := nil;
end;

function TfcDesign.GetPolyPolygons: PArrayOfArrayOfgmShapeInfo;
begin

end;

function TfcDesign.GetSelections: PArrayOfArrayOfInteger;
begin

end;

procedure TfcDesign.SetPainter(const Value: TEmbroideryPainter);
begin
  if Assigned(FPainter) then
    FreeAndNil(FPainter);
  FPainter := Value;
end;

procedure TfcDesign.RefreshScreenEvent(Sender: TObject);
begin
  DrawStitchs();
end;

procedure TfcDesign.btnNewStarClick(Sender: TObject);
var
  x,y : Integer;
  LShape : TEmbroideryItem;
  LPolygon : PgmShapeInfo;
begin
  FShapeList.ClearSelections;
  FShapeList.Clear;
  LShape := TEmbroideryItem(FShapeList.Add);
  LPolygon := LShape.Add;

  LPolygon.Centroid := FloatPoint(
        imgStitchs.Bitmap.Width div 2-1,
        imgStitchs.Bitmap.Height div 2-1
  );
  //LPolygon.Delta := FloatPoint( LPolygon.Centroid.X /3 *2, LPolygon.Centroid.Y /3 * 2);
  LPolygon.Delta := FloatPoint( 162, 171);
  LPolygon.Kind := skStar;
  LPolygon.Star.VertexCount := 5;
  LPolygon.Star.Straight := True;

  BuildStarPoints(LPolygon^, [smAngled]);

  //TStarForm(FStitchForm).EndingPoint := Point(x + 162, y + 171);
  Self.DrawStitchs;
end;

procedure TfcDesign.btnDumpClick(Sender: TObject);
var i : Integer;
begin
  if FShapeList.Count < 1 then Exit;

  with TEmbroideryItem(FShapeList[0]) do
    for i := 0 to Length(Stitchs^) -1 do
    begin
      with Stitchs^[i] do
      begin
        Memo1.Lines.Add(Format('lin[%d] R:%d  L:%d  g:%d  x:%.0f   y:%.0f',[i, rgns, lin, grp, x, y]))
        //Memo1.Lines.Add(Format('lin[%d]  L:%d  g:%d  x:%.2f   y:%.fd',[i, lin, grp, x, y]))
      end;
    end;

end;

procedure TfcDesign.Verbose(const VerboseMsg: string);
begin
  Memo1.Lines.Add(VerboseMsg);
end;

end.
