{
  Component Collection
  Copyright (C) 1996-2004 by Berg
  All rights reserved.

  $id:NxCollectionReg.pas bn
}

unit NxCollectionReg;

interface

uses
  DesignIntf, DesignEditors, Classes, Types, Graphics, Dialogs,
  NxCollection, NxPageControl, NxToolBox, NxLinkMenu,
  VCLEditors, ImgList;

const
  stControlVersion = '1.7';
  stOutlookBarVersion = '1.2';

type
  TNxItemsProperty = class(TPropertyEditor)
  private
    function ShowForm(Owner: TPersistent): Boolean;
  public
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure Edit; override;
  end;

  TNxToolbarComponentEditor = class(TDefaultEditor)
  public
    function GetVerb (Index: Integer): string; override;
    function GetVerbCount: Integer; override;
    procedure EditProperty(const Prop: IProperty; var Continue: Boolean); override;
    procedure ExecuteVerb (Index: Integer); override;
  end;

  TNxActivePagePropertyEditor = class(TComponentProperty)
  public
    procedure GetValues(Proc: TGetStrProc); override;
  end;

  TNxNotebookComponentEditor = class(TDefaultEditor)
  public
    function GetVerb (Index: Integer): string; override;
    function GetVerbCount: Integer; override;
    procedure ExecuteVerb (Index: Integer); override;
  end;

  TNxPageControlComponentEditor = class(TNxNotebookComponentEditor)
  public
    function GetVerb (Index: Integer): string; override;
    function GetVerbCount: Integer; override;
    procedure ExecuteVerb (Index: Integer); override;
  end;

  TNxTabSheetComponentEditor = class(TDefaultEditor)
  public
    function GetVerb (Index: Integer): string; override;
    function GetVerbCount: Integer; override;
    procedure ExecuteVerb (Index: Integer); override;
  end;

  TNxToolBoxComponentEditor = class(TDefaultEditor)
  public
    function GetVerb (Index: Integer): string; override;
    function GetVerbCount: Integer; override;
    procedure EditProperty(const Prop: IProperty; var Continue: Boolean); override;
    procedure ExecuteVerb (Index: Integer); override;
  end;

  TNxOutlookBarComponentEditor = class(TDefaultEditor)
  public
    function GetVerb (Index: Integer): string; override;
    function GetVerbCount: Integer; override;
    procedure EditProperty(const Prop: IProperty; var Continue: Boolean); override;
    procedure ExecuteVerb (Index: Integer); override;
  end;

  TNxImageIndexPropertyEditor = class(TIntegerProperty,
    ICustomPropertyListDrawing)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
    function GetImageListAt(Index: Integer): TCustomImageList; virtual;

    // ICustomPropertyListDrawing
    procedure ListMeasureHeight(const Value: string; ACanvas: TCanvas;
      var AHeight: Integer);
    procedure ListMeasureWidth(const Value: string; ACanvas: TCanvas;
      var AWidth: Integer);
    procedure ListDrawValue(const Value: string; ACanvas: TCanvas;
      const ARect: TRect; ASelected: Boolean);
  end;

  TNxOtlookBarItemImageIndexPropertyEditor = class(TNxImageIndexPropertyEditor)
  public
    function GetImageListAt(Index: Integer): TCustomImageList; override;
  end;

  TNxLinkLabelImageIndexPropertyEditor = class(TNxImageIndexPropertyEditor)
  public
    function GetImageListAt(Index: Integer): TCustomImageList; override;
  end;

  TTabSheetNameProperty = class(TComponentNameProperty)
  public
    procedure SetValue(const Value: string); override;
  end;

  TNxLinkMenuComponentEditor = class(TDefaultEditor)
  public
    procedure EditProperty(const Prop: IProperty; var Continue: Boolean); override;
  end;

procedure Register;

implementation

uses SysUtils, Forms, Math, NxToolbarEditor;

procedure Register;
begin
  RegisterComponents('Next Collection', [TNxAlertList, TNxAlertWindow, TNxGlyphButton, TNxFlipContainer, TNxFlipPanel,
    TNxGlyph, TNxHeaderPanel, TNxIconList, TNxImage, TNxLabel, TNxLinkLabel, TNxNotebook, TNxOutlookBar, TNxPageControl,
    TNxToolBox, TNxExpandPanel, TNxSplitter, TNxButton, TNxPanel, TNxLinkMenu, TNxGroupHeader, TNxInfoPanel, TNxHtmlLabel,
    TNxOptionButton, TNxPathControl, TNxHint, TNxToolbar, TNxGlyphPageControl]);

  RegisterComponentEditor(TNxCustomNotebook, TNxNotebookComponentEditor);
  RegisterComponentEditor(TNxPageControl, TNxPageControlComponentEditor);
  RegisterComponentEditor(TNxTabSheet, TNxTabSheetComponentEditor);
  RegisterComponentEditor(TNxToolBox, TNxToolBoxComponentEditor);
  RegisterComponentEditor(TNxOutlookBar, TNxOutlookBarComponentEditor);
  RegisterComponentEditor(TNxLinkMenu, TNxLinkMenuComponentEditor);
  RegisterComponentEditor(TNxToolbar, TNxToolbarComponentEditor);
  RegisterPropertyEditor(TypeInfo(TNxToolbarItems), TNxToolbar, 'Items', TNxItemsProperty);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TNxOutlookBarItem, 'ImageIndex', TNxOtlookBarItemImageIndexPropertyEditor);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TNxLinkLabel, 'ImageIndex', TNxLinkLabelImageIndexPropertyEditor);
  RegisterPropertyEditor(TypeInfo(TNxTabSheet), TNxCustomNotebook, 'ActivePage', TNxActivePagePropertyEditor);
  RegisterPropertyEditor(TypeInfo(TComponentName), TNxTabSheet, 'Name', TTabSheetNameProperty);

  { Registering Classes }
  RegisterNoIcon([TNxToolItem, TNxToolButton, TNxToolSeparator]);
  RegisterClasses([TNxToolItem, TNxToolButton, TNxToolSeparator]);
end;

{ TNxActivePagePropertyEditor }

procedure TNxActivePagePropertyEditor.GetValues(Proc: TGetStrProc);
var
  i: Integer;
begin
  with GetComponent(0) as TNxCustomNotebook do
    for i := 0 to PageCount - 1 do Proc(Pages[i].Name);
end;

{ TNxNotebookComponentEditor }

procedure TNxNotebookComponentEditor.ExecuteVerb(Index: Integer);
var
  Page: TNxTabSheet;
begin
  inherited;
  with GetComponent as TNxCustomNotebook do
    case Index of
      0:  begin
            Page := TNxTabSheet(Designer.CreateComponent(TNxTabSheet, GetComponent, 0, 0, 100, 100));
            AddPage(Page, True);
            ActivePage := Page;
          end;
      1:  if (PageCount > 0) and Assigned(ActivePage) then DeletePage(ActivePage);
      3:  ActivePageIndex := ActivePageIndex + 1;
      4:  ActivePageIndex := ActivePageIndex - 1;
      5:  if ActivePage <> nil then Designer.SelectComponent(ActivePage);
      7:  ShowMessage('Copyright (C) 1996-2011 Berg' + #13#10 +
                       'Version ' + stControlVersion + #13#10 +
                       'http://www.bergsoft.net/');
  end;
  Designer.Modified;
end;

function TNxNotebookComponentEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := '&New Page';
    1: Result := '&Delete Page';
    2: Result := '-';
    3: Result := 'N&ext Page';
    4: Result := '&Previous Page';
    5: Result := '&Select Active Page';
    6: Result := '-';
    7: Result := '&Version...';
  end;
end;

function TNxNotebookComponentEditor.GetVerbCount: Integer;
begin
  Result := 8;
end;

{ TNxPageControlComponentEditor }

procedure TNxPageControlComponentEditor.ExecuteVerb(Index: Integer);
begin
  inherited;
  with GetComponent as TNxPageControl do
    case Index of
      9:  if pgCloseButton in Options then Options := Options - [pgCloseButton]
            else Options := Options + [pgCloseButton]; 
      10: if pgScrollButtons in Options then Options := Options - [pgScrollButtons]
            else Options := Options + [pgScrollButtons];
      11: if pgTabsPopup in Options then Options := Options - [pgTabsPopup]
            else Options := Options + [pgTabsPopup];
  end;
end;

function TNxPageControlComponentEditor.GetVerb(Index: Integer): string;
const
  Status: array[Boolean] of string = ('Show', 'Hide');
begin
  Result := inherited GetVerb(Index);
  with GetComponent as TNxPageControl do
    case Index of
      8: Result := '-';
      9: Result := Status[pgCloseButton in Options] + ' &Close Button';
      10: Result := Status[pgScrollButtons in Options] + ' &Scroll Buttons';
      11: Result := Status[pgTabsPopup in Options] + ' &Tabs Popup Button';
    end;
end;

function TNxPageControlComponentEditor.GetVerbCount: Integer;
begin
  Result := 12;
end;

{ TNxTabSheetComponentEditor }

procedure TNxTabSheetComponentEditor.ExecuteVerb(Index: Integer);
var
  Notebook: TNxCustomNotebook;
  Page: TNxTabSheet;
begin
  inherited;
  Notebook := (GetComponent as TNxTabSheet).PageControl;
  if Notebook = nil then Exit;
  with Notebook do
    case Index of
      0:  begin
            Page := TNxTabSheet(Designer.CreateComponent(TNxTabSheet, Notebook, 0, 0, 100, 100));
            AddPage(Page, True);
            ActivePage := Page;
          end;
      2:  ActivePageIndex := ActivePageIndex + 1;
      3:  ActivePageIndex := ActivePageIndex - 1;
    end;
  Designer.Modified;
end;

function TNxTabSheetComponentEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := '&New Page';
    1: Result := '-';
    2: Result := 'N&ext Page';
    3: Result := '&Previous Page';
  end;
end;

function TNxTabSheetComponentEditor.GetVerbCount: Integer;
begin
  Result := 4;
end;

{ TNxToolBoxComponentEditor }

procedure TNxToolBoxComponentEditor.EditProperty(const Prop: IProperty;
  var Continue: Boolean);
begin
  inherited;
  if (Prop.GetName = 'Categories') then
  begin
    Continue := False;
    Prop.Edit; { call TNxColumnsProperty.Edit }
  end;
end;

procedure TNxToolBoxComponentEditor.ExecuteVerb(Index: Integer);
begin
  inherited;
  with GetComponent as TNxToolBox do
    case Index of
      0: Edit;
    end;
end;

function TNxToolBoxComponentEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := '&Categories Editor...';
  end;
end;

function TNxToolBoxComponentEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

{ TNxOutlookBarComponentEditor }

procedure TNxOutlookBarComponentEditor.EditProperty(const Prop: IProperty;
  var Continue: Boolean);
begin
  inherited;
  if (Prop.GetName = 'Items') then
  begin
    Continue := False;
    Prop.Edit;
  end;
end;

procedure TNxOutlookBarComponentEditor.ExecuteVerb(Index: Integer);
begin
  inherited;
  case Index of
    0: Edit;
    2: ShowMessage('Copyright (C) 1996-2005 Berg' + #13#10 +
                    'Version ' + stOutlookBarVersion + #13#10 +
                    'http://www.bergsoft.net/');
  end;
end;

function TNxOutlookBarComponentEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := '&Items Editor...';
    1: Result := '-';
    2: Result := '&Version...';
  end;
end;

function TNxOutlookBarComponentEditor.GetVerbCount: Integer;
begin
  Result := 3;
end;

{ TNxImageIndexPropertyEditor }

function TNxImageIndexPropertyEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paMultiSelect, paValueList, paRevertable];
end;

function TNxImageIndexPropertyEditor.GetImageListAt(
  Index: Integer): TCustomImageList;
begin
  Result := nil;
end;

procedure TNxImageIndexPropertyEditor.GetValues(
  Proc: TGetStrProc);
var
  ImgList: TCustomImageList;
  I: Integer;
begin
  ImgList := GetImageListAt(0);
  if Assigned(ImgList) then
    for I := 0 to ImgList.Count-1 do
      Proc(IntToStr(I));
end;

procedure TNxImageIndexPropertyEditor.ListDrawValue(
  const Value: string; ACanvas: TCanvas; const ARect: TRect;
  ASelected: Boolean);
var
  ImgList: TCustomImageList;
  X: Integer;
begin
  ImgList := GetImageListAt(0);
  ACanvas.FillRect(ARect);
  X := ARect.Left + 2;
  if Assigned(ImgList) then
  begin
    ImgList.Draw(ACanvas, X, ARect.Top + 2, StrToInt(Value));
    Inc(X, ImgList.Width);
  end;
  ACanvas.TextOut(X + 3, ARect.Top + 1, Value);
end;

procedure TNxImageIndexPropertyEditor.ListMeasureHeight(
  const Value: string; ACanvas: TCanvas; var AHeight: Integer);
var
  ImgList: TCustomImageList;
begin
  ImgList := GetImageListAt(0);
  AHeight := ACanvas.TextHeight(Value) + 2;
  if Assigned(ImgList) and (ImgList.Height + 4 > AHeight) then
    AHeight := ImgList.Height + 4;
end;

procedure TNxImageIndexPropertyEditor.ListMeasureWidth(
  const Value: string; ACanvas: TCanvas; var AWidth: Integer);
var
  ImgList: TCustomImageList;
begin
  ImgList := GetImageListAt(0);
  AWidth := ACanvas.TextWidth(Value) + 4;
  if Assigned(ImgList) then
    Inc(AWidth, ImgList.Width);
end;

{ TNxOtlookBarItemImageIndexPropertyEditor }

function TNxOtlookBarItemImageIndexPropertyEditor.GetImageListAt(
  Index: Integer): TCustomImageList;
var
  C: TPersistent;
  Item: TNxOutlookBarItem;
  Bar: TNxOutlookBar;
begin
  Result := nil;
  { ? I'm guessing that the Index parameter is a component index (one that
    would be passed to the GetComponent function). }
  C := GetComponent(Index);
  if C is TNxOutlookBarItem then
  begin
    Item := TNxOutlookBarItem(C);
    Bar := TNxOutlookBar(Item.Items.Owner);
    Result := Bar.SmallImages;
  end;
end;

{ TNxLinkLabelImageIndexPropertyEditor }

function TNxLinkLabelImageIndexPropertyEditor.GetImageListAt(
  Index: Integer): TCustomImageList;
var
  C: TPersistent;
begin
  Result := nil;
  { ? I'm guessing that the Index parameter is a component index (one that
    would be passed to the GetComponent function). }
  C := GetComponent(Index);
  if C is TNxLinkLabel then Result := TNxLinkLabel(C).Images;
end;

{ TTabSheetNameProperty }

procedure TTabSheetNameProperty.SetValue(const Value: string);
var
  PageControl: TNxCustomNotebook;
begin
  inherited;
  PageControl := TNxTabSheet(GetComponent(0)).PageControl;
  if PageControl is TNxNotebook then PageControl.Invalidate;
end;

{ TNxLinkMenuComponentEditor }

procedure TNxLinkMenuComponentEditor.EditProperty(const Prop: IProperty;
  var Continue: Boolean);
begin
  inherited;
  if (Prop.GetName = 'Sections') then
  begin
    Continue := False;
    Prop.Edit;
  end;
end;

{ TNxItemsProperty }

procedure TNxItemsProperty.Edit;
var
  EditorForm: TToolbarEditor;
begin
  inherited;
  if not ShowForm(GetComponent(0)) then { form is already shown }
  begin
    EditorForm := TToolbarEditor.Create(Application);
    try
      EditorForm.ParentComponent := GetComponent(0) as TNxToolbar;
      EditorForm.Designer := Self.Designer;
      EditorForm.WindowState := wsNormal;
      EditorForm.Show;
    except
      EditorForm.Free;
    end;
  end;
end;

function TNxItemsProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes + [paDialog, paReadOnly];
end;

function TNxItemsProperty.GetValue: string;
begin
  Result := '(' + TNxToolbar(GetComponent(0)).Items.ClassName +  ')';
end;

function TNxItemsProperty.ShowForm(Owner: TPersistent): Boolean;
var
  i: Integer;
  Form: TCustomForm;
begin
  { try to locate form with
    same owner to show it again }
  Result := False;
  for i := 0 to Screen.FormCount - 1 do
  begin
    Form := Screen.Forms[i];
    if Form is TToolbarEditor then
      if TToolbarEditor(Form).ParentComponent = Owner then
      begin
        Form.Show;
        if Form.WindowState = wsMinimized then Form.WindowState := wsNormal;
        Result := True;
        Exit;
      end;
  end;
end;

{ TNxToolbarComponentEditor }

procedure TNxToolbarComponentEditor.EditProperty(const Prop: IProperty;
  var Continue: Boolean);
begin
  inherited;
  if (Prop.GetName = 'Items') then
  begin
    Continue := False;
    Prop.Edit; { call TNxColumnsProperty.Edit }
  end;
end;

procedure TNxToolbarComponentEditor.ExecuteVerb(Index: Integer);
begin
  with GetComponent as TNxToolbar do
    case Index of
      0: Edit;
    end;
end;

function TNxToolbarComponentEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := '&Items Editor';
  end;
end;

function TNxToolbarComponentEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

end.
