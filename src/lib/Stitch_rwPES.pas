unit Stitch_rwPES;

(* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/LGPL 2.1/GPL 2.0
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Initial Developer of the Original Code are
 *
 * x2nie - Fathony Luthfillah  <x2nie@yahoo.com>
 * Ma Xiaoguang and Ma Xiaoming < gmbros@hotmail.com >
 *
 * Contributor(s):
 *
 * Lab to RGB color conversion is using RGBCIEUtils.pas under mbColorLib library
 * developed by Marko Binic' marko_binic [at] yahoo [dot] com
 * or mbinic [at] gmail [dot] com.
 * forums : http://mxs.bergsoft.net/forums
 *
 *
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 * ***** END LICENSE BLOCK ***** *)

interface
uses Classes,SysUtils, Graphics,
  gmFileFormatList, Stitch_items, 
  Thred_Constants, Thred_Types ;

type

  
  TStitchPESConverter = class(TgmConverter)
  private
    FStream: TStream;
    function ReadInt32:LongInt;
    function ReadInt16:SmallInt;
    function ReadByte:Byte;
    function getPesDefaultColors: TArrayOfTColor;
  public
    constructor Create; override;
    procedure LoadFromStream(Stream: TStream; ACollection: TCollection); override;
    //procedure LoadItemFromString(Item :TgmSwatchItem; S : string);
    procedure LoadItemFromStream(Stream: TStream; AItem: TCollectionItem); virtual;
    procedure SaveToStream(Stream: TStream; ACollection: TCollection); override;
    //procedure SaveItemToStream(Stream: TStream; AItem: TCollectionItem); virtual; abstract;
    class function WantThis(AStream: TStream): Boolean; override;
    //constructor Create; virtual;
  end;

implementation

uses
  Windows,
  GR32;
//  GR32, GR32_LowLevel;
{ TgmConverter }

constructor TStitchPESConverter.Create;
begin
  inherited;

end;


procedure TStitchPESConverter.LoadFromStream(Stream: TStream;
  ACollection: TCollection);
var
	led : Cardinal;
	len : Cardinal;	//length of strhed + length of stitch data
  inf,i,red : Integer;
  sthed : THED;
//  item  : SHRTPNT;
  hedx : TSTREX;
  LDesign : TStitchCollection;
  c : TColor;
  c16 : T16Colors;
  buf : array[0..17] of Char;
//#5617    #if PESACT                                                                       
//#5618                                                                           
//#5619        unsigned        ine;                                                           
//#5620        PESHED*            peshed;
  peshed : TPESHED;
  pecof  : Cardinal;                                                    
//#5621        TCHAR*            peschr;                                                       
//#5622        unsigned        pecof;
  pcolcnt   : Byte;
  pescols   : array Of TColor;
  colorList : array{[0..255]} of byte;

//#5623        unsigned char*    pcolcnt;

//#5624        DUBPNT            loc;
//#5625        PESTCH*            pabstch;
//#5626        unsigned        pabind;
//#5627        double            locof;

//#5628    #endif
  val1,val2,val3 : byte;
//  curBlock : TStitchBlock;
   prevX,prevY, maxX,minX,
                 maxY,
                 minY,
                 imageWidth,
                 imageHeight,



  deltaX,deltaY:integer;
                 translateStart :TPoint;
                 LColorNum : integer;
  colorIndex : byte;
  Lstchs : TArrayOfTSHRTPNT;

  function getIndexFromOrder(order: integer): Integer;
  begin
    Result := colorList[order];
  end;


begin
  FStream := Stream;
  LDesign := TStitchCollection(ACollection);
  LDesign.Clear;
  SetLength(Lstchs,0);
  prevX := 00665;
  prevY := 00376;
  maxX := 0;
  minX := 0;
  maxY := 0;
  minY := 0;
  LColorNum := 0;

//#5967    #if PESACT                                                                       
//#5968                        else{                                                   
//#5969
  Stream.Read(peshed, SizeOf(TPESHED));
  if peshed.led <> '#PES0001' then
    raise Exception.Create('Not a PES file');

//#5970                            ReadFile(hFil,(BSEQPNT*)&bseq,sizeof(bseq),&red,0);                                               
//#5971                            peshed=(PESHED*)&bseq;                                               
//#5972                            peschr=(TCHAR*)&bseq;                                               
//#5973                            if(strncmp(peshed->led,"#PES00",6)){                                               
//#5974                                                                           
//#5975                                sprintf(msgbuf,"Not a PES file: %s\n",filnam);
//#5976                                shoMsg(msgbuf);                                           
//#5977                                return;                                           
//#5978                            }

  pecof := peshed.off[0] + (peshed.off[1] shl 8) + (peshed.off[2] shl 16);                                                   
//#5979                            pecof=tripl(peshed->off);                                               
//#5980                            pestch=(unsigned char*)&peschr[pecof+532];                                               
//#5981                            xpnt=0;

  //COLORS===
  Stream.Position :=pecof + 48;
  pcolcnt := ReadByte; // should +1 !
  //for i := 0 to FnumColors do
      //colorList[i] := ReadByte;
  SetLength(colorList,pcolcnt + 1);
  Stream.Read(colorList[0], pcolcnt + 1);
//#5982                            pcolcnt=(unsigned char*)&peschr[pecof+48];

  FStream.Position := pecof + 532;
//#5983                            pescols=&pcolcnt[1];

//#5984                            rmap[0]=rmap[1]=0;                                               
//#5985                            xpnt=0;                                               
//#5986                            for(ind=0;ind<(unsigned)(*pcolcnt+1);ind++){                                               
//#5987                                                                           
//#5988                                if(setRmp(pescols[ind])){                                           
//#5989                                                                           
//#5990                                    useCol[xpnt++]=pestrn[pescols[ind]&PESCMSK];                                       
//#5991                                    if(xpnt>=16)                                       
//#5992                                        break;                                   
//#5993                                }                                           
//#5994                            }                                               
//#5995                            tcol=0;                                               
//#5996                            pcolind=1;                                               
//#5997                            loc.x=loc.y=0;                                               
//#5998                            pabind=ind=ine=0;                                               
//#5999                            rstMap(FILDIR);                                               
//#6000                            ind=0;                                               
//#6001                            pabstch=(PESTCH*)&peschr[sizeof(PESHED)+4];                                               
//#6002                            ind=0;                                               
//#6003                            ine=1;                                               
//#6004                            stchs[0].x=stchs[0].y;                                               
//#6005                            while(ind<red-pecof-529){   
  while True do
  begin

//#6006                                                                           
//#6007                                if(pestch[ind]==0xff&&pestch[ind+1]==0)                                           
//#6008                                    break;
      val1 := ReadByte();
      val2 := ReadByte();
      if (val1 = 255) and( val2 = 0) then
      begin
          //end of stitches
          Break;

          //add the last block
          {curBlock = new stitchBlock();
          curBlock.stitches = new Point[tempStitches.Count];
          tempStitches.CopyTo(curBlock.stitches);
          curBlock.stitchesTotal = tempStitches.Count;
          colorNum++;
          colorIndex = colorList[colorNum];
          curBlock.colorIndex = colorIndex;
          curBlock.color = getColorFromIndex(colorIndex);
          blocks.Add(curBlock);}
      end

//#6009                                if(pestch[ind]==0xfe&&pestch[ind+1]==0xb0){
//#6010
//#6011                                    tcol=dupcol();
//#6012                                    ind+=2;
//#6013                                }
      else if (val1 = $FE{254}) and (val2 = $B0{176})  then
      begin
          //color switch, start a new block

          {curBlock = new stitchBlock();
          curBlock.stitches = new Point[tempStitches.Count];
          tempStitches.CopyTo(curBlock.stitches);
          curBlock.stitchesTotal = tempStitches.Count;
          colorNum++;
          colorIndex = colorList[colorNum];
          curBlock.colorIndex = colorIndex;
          curBlock.color = getColorFromIndex(colorIndex);
          blocks.Add(curBlock);

          tempStitches = new List<Point>();
          }
          Inc(LColorNum);
          colorIndex := getIndexFromOrder(LColorNum);
          //curBlock.colorIndex = colorIndex;
          //pb.Buffer.PenColor := Color32(getColorFromIndex(colorIndex));
          //read useless(?) byte
          ReadByte();
      end

//#6014                                else{
//#6015
      else
      begin
          deltaX := 0;
          deltaY := 0;
//#6016                                    if(pestch[ind]&0x80){
//#6017
//#6018                                        locof=dubl(&pestch[ind]);
//#6019                                        ind++;
//#6020                                    }
          if (val1 and 128) = 128 //$80
          then begin
              //this is a jump stitch
              deltaX := ((val1 and 15) * 256) + val2;
              if ((deltaX and 2048) = 2048) //$0800
              then begin
                  deltaX := deltaX - 4096;
              end;
              //read next byte for Y value
              val2 := ReadByte();
          end

//#6021                                    else{
//#6022                                                                           
//#6023                                        if(pestch[ind]&0x40)                                   
//#6024                                            locof=pestch[ind]-128;                               
//#6025                                        else                                   
//#6026                                            locof=pestch[ind];                               
//#6027                                    }
          else
          begin
              //normal stitch
              deltaX := val1;
              if (deltaX > 63)
              then begin
                  deltaX := deltaX - 128;
              end;
          end;

          if ((val2 and 128) = 128) then//$80
          begin
              //this is a jump stitch
              val3 := ReadByte();
              deltaY := ((val2 and 15) * 256) + val3;
              if ((deltaY and 2048) = 2048) then
              begin
                  deltaY := deltaY - 4096;
              end;
          end
          else
          begin
              //normal stitch
              deltaY := val2;
              if (deltaY > 63) then
              begin
                  deltaY := deltaY - 128;
              end;
          end;                                                                   
          //tempStitches.Add(new Point(prevX + deltaX, prevY + deltaY));

          SetLength(Lstchs,Length(Lstchs)+1);
          with Lstchs[High(lstchs)] do
          begin
            x := (prevX + deltaX) * 0.6;
            y :=  (prevY + deltaY) * 0.6;
            at := colorIndex;
          end;

          //pb.Buffer.LineToXS(Fixed((prevX + deltaX)/3),Fixed(( prevY + deltaY)/3));
          prevX := prevX + deltaX;
          prevY := prevY + deltaY;


          if (prevX > maxX) then
          begin
              maxX := prevX;
          end
          else if (prevX < minX) then
          begin
              minX := prevX;
          end;

          if (prevY > maxY) then
          begin
              maxY := prevY;
          end
          else if (prevY < minY) then
          begin
              minY := prevY;
          end;

      end;
  end;

  LDesign.Stitchs := Lstchs;

//#6028                                    locof*=0.6;
//#6029                                    if(toglMap(FILDIR)){                                       
//#6030
//#6031                                        loc.y-=locof;                                   
//#6032                                        stchs[ine].x=loc.x;                                   
//#6033                                        stchs[ine].y=loc.y;                                   
//#6034                                        stchs[ine].at=tcol;                                   
//#6035                                        ine++;                                   
//#6036                                    }                                       
//#6037                                    else                                       
//#6038                                        loc.x+=locof;                                   
//#6039                                }                                           
//#6040                                ind++;                                           
//#6041                            }                                               
//#6042                            hed.stchs=ine;                                               
//#6043                            //ini.auxfil=AUXPES;                                               
//#6044                            hupfn();                                               
//#6045                        }                                                   
//#6046    #endif
  LDesign.BgColor := clWhite;
  FillChar(hedx, SizeOf(hedx), 0);
        hedx.xhup := LHUPX;
        hedx.yhup := LHUPY;

  LDesign.Colors := getPesDefaultColors;
  LDesign.HeaderEx := hedx;


end;

procedure TStitchPESConverter.LoadItemFromStream(Stream: TStream;
  AItem: TCollectionItem);
var d : integer;
  b : tSHRTPNT;

begin
  Stream.Read(b,SizeOf(tSHRTPNT));


end;
{
function TPesFile.ReadByte: Byte;
begin
end;

function TPesFile.ReadInt16: SmallInt;
begin
end;

function TPesFile.ReadInt32: LongInt;
begin
end;
}
function TStitchPESConverter.ReadByte: Byte;
begin
  FStream.Read(Result,1)
end;

function TStitchPESConverter.ReadInt16: SmallInt;
begin
  FStream.Read(Result,2)
end;

function TStitchPESConverter.ReadInt32: LongInt;
begin
  FStream.Read(Result,4)
end;

procedure TStitchPESConverter.SaveToStream(Stream: TStream;
  ACollection: TCollection);
begin
//#6629    #if PESACT                                                                       
//#6630                                                                           
//#6631            case AUXPES:                                                               
//#6632                                                                           
//#6633                pchr=(TCHAR*)&peshed;                                                           
//#6634                for(ind=0;ind<sizeof(PESHED);ind++)                                                           
//#6635                    pchr[ind]=0;                                                       
//#6636                strcpy(peshed.led,"#PES0001");                                                           
//#6637                strcpy(peshed.ce,"CEmbOne");                                                           
//#6638                strcpy(peshed.cs,"CSewSeg");                                                           
//#6639                pestch=(PESTCH*)&bseq;                                                           
//#6640                for(ind=0;ind<16;ind++){                                                           
//#6641                                                                           
//#6642                    mtchmin=0xffffffff;                                                       
//#6643                    for(ine=0;ine<sizeof(pestrn)>>2;ine++){                                                       
//#6644                                                                           
//#6645                        match=pesmtch(useCol[ind],ine);                                                   
//#6646                        if(match<mtchmin){                                                   
//#6647                                                                           
//#6648                            mtchind=ine;                                               
//#6649                            mtchmin=match;                                               
//#6650                        }                                                   
//#6651                    }                                                       
//#6652                    pescolrs[ind]=(unsigned char)mtchind;                                                       
//#6653                }                                                           
//#6654                tcol=stchs[0].at&COLMSK;                                                           
//#6655                pescol=peshed.scol=pescolrs[stchs[0].at&COLMSK];                                                           
//#6656                sizstch(&srct);                                                           
//#6657                sof.x=midl(srct.right,srct.left);                                                           
//#6658                sof.y=midl(srct.top,srct.bottom);                                                           
//#6659                peshed.xsiz=srct.right-srct.left;                                                           
//#6660                peshed.ysiz=srct.top-srct.bottom;                                                           
//#6661                opnt=0;                                                           
//#6662                pestchs=(PESTCH*)&bseq;                                                           
//#6663                ritpes(0);                                                           
//#6664                pestchs[opnt].x=(short)0x8003;                                                           
//#6665                pestchs[opnt++].y=0;                                                           
//#6666                ritpcol(pescolrs[tcol]);                                                           
//#6667                ritpes(0);                                                           
//#6668                pcolcnt=0;                                                           
//#6669                for(ind=1;ind<hed.stchs;ind++){                                                           
//#6670                                                                           
//#6671                    if(tcol==(stchs[ind].at&COLMSK))                                                       
//#6672                        ritpes(ind);                                                   
//#6673                    else{                                                       
//#6674                                                                           
//#6675                        ritpes(ind);                                                   
//#6676                        pestchs[opnt].x=(short)0x8001;                                                   
//#6677                        pestchs[opnt++].y=0;                                                   
//#6678                        ritpcol(pescolrs[tcol]);                                                   
//#6679                        tcol=stchs[ind].at&COLMSK;                                                   
//#6680                        ritpes(ind++);                                                   
//#6681                        ritpes(ind);                                                   
//#6682                        pestchs[opnt].x=(short)0x8003;                                                   
//#6683                        pestchs[opnt++].y=0;                                                   
//#6684                        ritpcol(pescolrs[tcol]);                                                   
//#6685                        ritpes(ind);                                                   
//#6686                        pcolcnt++;                                                   
//#6687                    }                                                       
//#6688                }                                                           
//#6689                pestchs[opnt].x=ine;                                                           
//#6690                pestchs[opnt++].y=0;                                                           
//#6691                pesof=(unsigned*)&peshed.off;                                                           
//#6692                *pesof=(opnt<<2)+sizeof(PESHED);                                                           
//#6693                *peshed.m1=0x20;                                                           
//#6694                gpnt0=0;                                                           
//#6695                gpnt1=hed.stchs-1;                                                           
//#6696                peshed.xsiz=10000;                                                           
//#6697                peshed.ysiz=10000;                                                           
//#6698                WriteFile(hPcs,(PESHED*)&peshed,sizeof(PESHED),&wrot,0);                                                           
//#6699                WriteFile(hPcs,(PESTCH*)&bseq,opnt<<2,&wrot,0);                                                           
//#6700                ind=pesnam();                                                           
//#6701                pchr=(TCHAR*)&bseq;                                                           
//#6702                while(ind<512)                                                           
//#6703                    pchr[ind++]=' ';                                                       
//#6704                pchr[19]=13;                                                           
//#6705                pchr[48]=(TCHAR)pcolcnt;                                                           
//#6706                pecdat();                                                           
//#6707                upnt=(unsigned*)&pchr[514];                                                           
//#6708                *upnt=opnt-512;                                                           
//#6709                pchr[517]=0x20;                                                           
//#6710                pchr[518]=-1;                                                           
//#6711                pchr[519]=-17;                                                           
//#6712                psiz=(short*)&pchr[520];                                                           
//#6713                *psiz=peshed.xsiz;                                                           
//#6714                psiz++;                                                           
//#6715                *psiz=peshed.ysiz;                                                           
//#6716                psiz++;                                                           
//#6717                *psiz=480;                                                           
//#6718                pesof=(unsigned*)psiz;                                                           
//#6719                *pesof=11534816;                                                           
//#6720    //            pchr[527]=(TCHAR)0x0;                                                           
//#6721    //            pchr[528]=(TCHAR)0x90;                                                           
//#6722    //            pchr[529]=(TCHAR)0x0;                                                           
//#6723    //            pchr[530]=(TCHAR)0x8f;                                                           
//#6724                pchr[527]=(TCHAR)0x00;                                                           
//#6725                pchr[528]=(TCHAR)0x80;    //hor    msb                                                   
//#6726                pchr[529]=(TCHAR)0x80; //hor lsb                                                           
//#6727                pchr[530]=(TCHAR)0x82; //vert msb                                                           
//#6728                pchr[531]=(TCHAR)0xff; //vert lsb                                                           
//#6729                WriteFile(hPcs,(TCHAR*)&bseq,opnt,&wrot,0);                                                           
//#6730                break;                                                           
//#6731    #endif
end;

function TStitchPESConverter.getPesDefaultColors(): TArrayOfTColor;
    function ColorFromIndex(index : Integer): TColor;
    begin
    case index of
      1:
                    result := RGB(14, 31, 124);
                    
                 2:
                    result := RGB(10, 85, 163);
                    
                 3:
                    result := RGB(48, 135, 119);
                    
                 4:
                    result := RGB(75, 107, 175);
                    
                 5:
                    result := RGB(237, 23, 31);
                    
                 6:
                    result := RGB(209, 92, 0);
                    
                 7:
                    result := RGB(145, 54, 151);
                    
                 8:
                    result := RGB(228, 154, 203);
                    
                 9:
                    result := RGB(145, 95, 172);
                    
                 10:
                    result := RGB(157, 214, 125);
                    
                 11:
                    result := RGB(232, 169, 0);
                    
                 12:
                    result := RGB(254, 186, 53);
                    
                 13:
                    result := RGB(255, 255, 0);
                    
                 14:
                    result := RGB(112, 188, 31);
                    
                 15:
                    result := RGB(186, 152, 0);
                    
                 16:
                    result := RGB(168, 168, 168);
                    
                 17:
                    result := RGB(123, 111, 0);
                    
                 18:
                    result := RGB(255, 255, 179);
                    
                 19:
                    result := RGB(79, 85, 86);
                    
                 20:
                    result := RGB(0, 0, 0);
                    
                 21:
                    result := RGB(11, 61, 145);
                    
                 22:
                    result := RGB(119, 1, 118);
                    
                 23:
                    result := RGB(41, 49, 51);
                    
                 24:
                    result := RGB(42, 19, 1);
                    
                 25:
                    result := RGB(246, 74, 138);
                    
                 26:
                    result := RGB(178, 118, 36);
                    
                 27:
                    result := RGB(252, 187, 196);
                    
                 28:
                    result := RGB(254, 55, 15);
                    
                 29:
                    result := RGB(240, 240, 240);
                    
                 30:
                    result := RGB(106, 28, 138);
                    
                 31:
                    result := RGB(168, 221, 196);
                    
                 32:
                    result := RGB(37, 132, 187);
                    
                 33:
                    result := RGB(254, 179, 67);
                    
                 34:
                    result := RGB(255, 240, 141);
                    
                 35:
                    result := RGB(208, 166, 96);
                    
                 36:
                    result := RGB(209, 84, 0);
                    
                 37:
                    result := RGB(102, 186, 73);
                    
                 38:
                    result := RGB(19, 74, 70);
                    
                 39:
                    result := RGB(135, 135, 135);
                    
                 40:
                    result := RGB(216, 202, 198);
                    
                 41:
                    result := RGB(67, 86, 7);
                    
                 42:
                    result := RGB(254, 227, 197);
                    
                 43:
                    result := RGB(249, 147, 188);
                    
                 44:
                    result := RGB(0, 56, 34);
                    
                 45:
                    result := RGB(178, 175, 212);
                    
                 46:
                    result := RGB(104, 106, 176);
                    
                 47:
                    result := RGB(239, 227, 185);
                    
                 48:
                    result := RGB(247, 56, 102);
                    
                 49:
                    result := RGB(181, 76, 100);
                    
                 50:
                    result := RGB(19, 43, 26);
                    
                 51:
                    result := RGB(199, 1, 85);
                    
                 52:
                    result := RGB(254, 158, 50);
                    
                 53:
                    result := RGB(168, 222, 235);
                    
                 54:
                    result := RGB(0, 103, 26);
                    
                 55:
                    result := RGB(78, 41, 144);
                    
                 56:
                    result := RGB(47, 126, 32);
                    
                 57:
                    result := RGB(253, 217, 222);
                    
                 58:
                    result := RGB(255, 217, 17);
                    
                 59:
                    result := RGB(9, 91, 166);
                    
                 60:
                    result := RGB(240, 249, 112);
                    
                 61:
                    result := RGB(227, 243, 91);
                    
                 62:
                    result := RGB(255, 200, 100);
                    
                 63:
                    result := RGB(255, 200, 150);
                    
                 64:
                    result := RGB(255, 200, 200);
                   else
                      result := clWhite;
      end;
    end;
var i : Integer;
begin
  SetLength(Result, 65);
  for i := 0 to 65 do
  begin
    Result[i] := ColorFromIndex(i);

  end;


end;


class function TStitchPESConverter.WantThis(AStream: TStream): Boolean;
var
  peshed : TPESHED;
  red : Integer;
begin
  aStream.Read(peshed, SizeOf(TPESHED));
  Result := peshed.led = '#PES0001' ;

end;

initialization
  TStitchCollection.RegisterConverterReader('PES','Brother',0, TStitchPESConverter);
end.
