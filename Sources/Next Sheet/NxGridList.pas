{
  NxSheet
  Copyright (C) 1996-2006 by Berg
  All rights reserved.

  $id:NxSheet.pas bn
}

unit NxGridList;

interface

uses
  Classes, Types, Graphics, Controls, ImgList, SysUtils, Messages;

const
  spHorzMargin = 8;
  spVertMargin = 7;

type
  TNxGridList = class(TCustomControl)
  private
    FImages: TImageList;
    function GetWidth: Integer;
    procedure SetImages(const Value: TImageList);
  protected
    function GetItemWidth: Integer; virtual;
    procedure Paint; override;
    procedure UpdateSize; virtual;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Images: TImageList read FImages write SetImages;
  end;

procedure Register;

implementation

uses
  NxThemesSupport;

procedure Register;
begin
  RegisterComponents('Next Shared', [TNxGridList]);
end;

{ TNxGridList }

constructor TNxGridList.Create(AOwner: TComponent);
begin
  inherited;
  FImages := nil;
end;

function TNxGridList.GetItemWidth: Integer;
begin
  if Assigned(FImages) then Result := Images.Width else Result := 36;
end;

function TNxGridList.GetWidth: Integer;
var
  W, C: Integer;
begin
  W := Width;
  Dec(W, 2); // borders
  C := W div (GetItemWidth + spHorzMargin);
  Result := C * (GetItemWidth + spHorzMargin);
  Inc(Result, 2);
end;

procedure TNxGridList.Paint;
begin
  inherited;
  if IsThemed then ThemeRect(Handle, Canvas.Handle, ClientRect, teListView, 1, 1);
  Canvas.TextOut(10,10, IntToStr(GetWidth));
end;

procedure TNxGridList.SetImages(const Value: TImageList);
begin
  FImages := Value;
  Invalidate;
end;

procedure TNxGridList.UpdateSize;
var
  NewWidth: Integer;
begin
  NewWidth := GetWidth;
  if NewWidth <> Width then Width := NewWidth;
end;

procedure TNxGridList.WMSize(var Message: TWMSize);
begin
  inherited;
  UpdateSize;
end;

end.
