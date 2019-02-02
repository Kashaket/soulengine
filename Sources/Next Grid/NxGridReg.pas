{
  Next Grid
  Copyright (C) 1996-2002 by Berg
  All rights reserved.

  $id:Next Grid_reg.pas 12/25/2002 7:10:18 bn
}

{$I '..\NxSuite.inc'}

unit NxGridReg;

interface

uses
	DesignIntf, DesignEditors, VCLEditors, Classes, Forms,
  NxCustomGridControl, NxCustomGrid, NxGrid, NxColumns, NxDisplays,
  NxColumnClasses, NxColumnEditor, NxSlidesEditor, NxFieldChooser;

type
  TColumnFormClass = class of TColumnForm;

  TNxGridComponentEditor = class(TDefaultEditor)
  protected
    function ShowSlidesForm(Owner: TPersistent): Boolean;
  public
    function GetVerb (Index: Integer): string; override;
    function GetVerbCount: Integer; override;
    procedure Edit; override;
    procedure EditProperty(const Prop: IProperty; var Continue: Boolean); override;
    procedure EditSlides;
    procedure ExecuteVerb (Index: Integer); override;
  end;

  TNxColumnsProperty = class(TPropertyEditor)
  private
    function ShowForm(Owner: TPersistent): Boolean;
  protected
  	function GetColumnFormClass: TColumnFormClass; virtual;
  public
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure Edit; override;
  end;

  TNxFieldChooserComponentEditor = class(TDefaultEditor)
  public
    function GetVerb (Index: Integer): string; override;
    function GetVerbCount: Integer; override;
    procedure EditProperty(const Prop: IProperty; var Continue: Boolean); override;
    procedure ExecuteVerb (Index: Integer); override;
  end;

  {$IFNDEF D2005UP}
  TWideStringProperty = TStringProperty;
  {$ENDIF}
  
  TWideCaptionProperty = class(TWideStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
  end;

  TNxCaptionProperty = class(TWideCaptionProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

procedure Register;

implementation

uses
  Controls, Dialogs, SysUtils, NxVirtualColumn, NxVersions, NxCaptionDlg;

procedure Register;
begin
  RegisterComponents('Next Suite', [TNextGrid, TNxFieldChooser, TNxSlidesDesigner]);
  RegisterComponents('Next Editors', [TNxGridPicker]);

  RegisterComponentEditor (TNxCustomGrid, TNxGridComponentEditor);
  RegisterComponentEditor (TNxFieldChooser, TNxFieldChooserComponentEditor);
  RegisterPropertyEditor(TypeInfo(TNxColumns), TNxCustomGrid, 'Columns', TNxColumnsProperty);

  { Delphi 6/7: Disable this 2 lines to support unicode editing for this 2 properties }
  RegisterPropertyEditor(TypeInfo(WideString), TColumnHeader, 'Caption', TNxCaptionProperty);
  RegisterPropertyEditor(TypeInfo(WideString), TNxCustomGrid, 'Caption', TWideCaptionProperty);

  { Registering Column Classes }
  RegisterNoIcon([TNxButtonColumn, TNxCalcColumn, TNxGuidColumn, TNxGraphicColumn, TNxCheckBoxColumn,
    TNxDateColumn, TNxHtmlColumn, TNxImageColumn, TNxIncrementColumn, TNxComboBoxColumn, TNxMemoColumn,
    TNxNumberColumn, TNxProgressColumn, TNxRateColumn, TNxTextColumn, TNxTimeColumn, TNxTreeColumn,
    TNxVirtualColumn, TNxListColumn, TNxHyperlinkColumn, TNxColorColumn]);
  RegisterClasses([TNxButtonColumn, TNxCalcColumn, TNxGuidColumn, TNxGraphicColumn, TNxCheckBoxColumn,
    TNxDateColumn, TNxHtmlColumn, TNxImageColumn, TNxIncrementColumn, TNxComboBoxColumn, TNxMemoColumn,
    TNxNumberColumn, TNxProgressColumn, TNxRateColumn, TNxTextColumn, TNxTimeColumn, TNxTreeColumn,
    TNxVirtualColumn, TNxListColumn, TNxHyperlinkColumn, TNxColorColumn]);
end;

{ TNxGridComponentEditor }

function TNxGridComponentEditor.ShowSlidesForm(Owner: TPersistent): Boolean;
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
    if Form is TSlidesForm then
      if TSlidesForm(Form).ParentComponent = Owner then
      begin
        Form.Show;
        if Form.WindowState = wsMinimized then Form.WindowState := wsNormal;
        Result := True;
        Exit;
      end;
  end;
end;

procedure TNxGridComponentEditor.Edit;
begin
  inherited;

end;

procedure TNxGridComponentEditor.EditProperty(const Prop: IProperty; var Continue: Boolean);
begin
  inherited;
  if (Prop.GetName = 'Columns') then
  begin
    Continue := False;
    Prop.Edit; { call TNxColumnsProperty.Edit }
  end;
end;

procedure TNxGridComponentEditor.EditSlides;
var
  SlidesForm: TSlidesForm;
begin
  if not ShowSlidesForm(GetComponent) then { form is already shown }
  begin
    SlidesForm := TSlidesForm.Create(Application);
    try
      SlidesForm.ParentComponent := GetComponent as TNxCustomGrid;
      SlidesForm.SlidesDesigner.Associate := GetComponent as TNxCustomGrid;
      SlidesForm.Designer := Self.Designer;
      SlidesForm.WindowState := wsNormal;
      SlidesForm.Show;
    except
      SlidesForm.Free;
    end;
  end;
end;

procedure TNxGridComponentEditor.ExecuteVerb(Index: Integer);
begin
  inherited;
  with GetComponent as TNxCustomGrid do
  begin
    case Index of
      0: Edit;
      1: EditSlides;
      2: ShowMessage('Copyright (C) 1996-2011 Berg' + #13#10 +
                     'Version ' + strNextGridVer + #13#10 +
                     'http://www.bergsoft.net/');
      4: if goHeader in Options then Options := Options - [goHeader] else Options := Options + [goHeader];
      5: if goFooter in Options then Options := Options - [goFooter] else Options := Options + [goFooter];
      6: if goGrid in Options then Options := Options - [goGrid] else Options := Options + [goGrid];
      7: if goInput in Options then Options := Options - [goInput] else Options := Options + [goInput];
      8: if goIndicator in Options then Options := Options - [goIndicator] else Options := Options + [goIndicator];
      9: if goMultiselect in Options then Options := Options - [goMultiselect, goSelectFullRow] else Options := Options + [goMultiselect, goSelectFullRow];
    end;
    if Index > 3 then Designer.Modified;
  end;
end;

function TNxGridComponentEditor.GetVerb(Index: Integer): string;
const
  Status: array[Boolean] of string = ('Show', 'Hide');
  Multisel: array[Boolean] of string = ('Enable', 'Disable');
begin
  with GetComponent as TNxCustomGrid do
    case Index of
      0: Result := '&Columns Editor...';
      1: Result := '&Slides Editor...';
      2: Result := '&Version...';
      3: Result := '-';
      4: Result := Status[goHeader in Options] + ' &Header';
      5: Result := Status[goFooter in Options] + ' &Footer';
      6: Result := Status[goGrid in Options] + ' &Grid';
      7: Result := Status[goInput in Options] + ' Input &Line';
      8: Result := Status[goIndicator in Options] + ' &Indicator';
      9: Result := Multisel[(goSelectFullRow in Options) and (goMultiSelect in Options)] + ' &Multiselect';
    end;
end;

function TNxGridComponentEditor.GetVerbCount: Integer;
begin
  Result := 10;
end;

{ TNxColumnsProperty }

function TNxColumnsProperty.ShowForm(Owner: TPersistent): Boolean;
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
    if Form is TColumnForm then
      if TColumnForm(Form).ParentComponent = Owner then
      begin
        Form.Show;
        if Form.WindowState = wsMinimized then Form.WindowState := wsNormal;
        Result := True;
        Exit;
      end;
  end;
end;

function TNxColumnsProperty.GetColumnFormClass: TColumnFormClass;
begin
  Result := TColumnForm;
end;

function TNxColumnsProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes + [paDialog, paReadOnly];
end;

function TNxColumnsProperty.GetValue: string;
begin
  Result := '(' + TNextGrid(GetComponent(0)).Columns.ClassName +  ')';
end;

procedure TNxColumnsProperty.Edit;
var
  EditorForm: TColumnForm;
begin
  inherited;
  if not ShowForm(GetComponent(0)) then { form is already shown }
  begin
    EditorForm := GetColumnFormClass.Create(Application);
    try
      EditorForm.ParentComponent := GetComponent(0) as TNxCustomGrid;
      EditorForm.Designer := Self.Designer;
      EditorForm.WindowState := wsNormal;
      EditorForm.Show;
    except
      EditorForm.Free;
    end;
  end;
end;

{ TNxFieldChooserComponentEditor }

function TNxFieldChooserComponentEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := '&Categories Editor...';
  end;
end;

function TNxFieldChooserComponentEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

procedure TNxFieldChooserComponentEditor.EditProperty(
  const Prop: IProperty; var Continue: Boolean);
begin
  inherited;
  if (Prop.GetName = 'Categories') then
  begin
    Continue := False;
    Prop.Edit; { call TNxColumnsProperty.Edit }
  end;
end;

procedure TNxFieldChooserComponentEditor.ExecuteVerb(Index: Integer);
begin
  inherited;
  case Index of
    0: Edit;
  end;
end;

{ TNxCaptionProperty }

function WordCount(const S: string; const Delims: TSysCharSet): Integer;
var
  L, I: Cardinal;
begin
  Result := 0;
  I := 1;
  L := Length(S);
  while I <= L do
  begin
    while (I <= L) and (S[I] in Delims) do Inc(I);
    if I <= L then Inc(Result);
    while (I <= L) and not(S[I] in Delims) do Inc(I);
  end;
end;

function WordPosition(const N: Integer; const S: string;
  const WordDelims: TSysCharSet): Integer;
var
  Count, I: Integer;
begin
  Count := 0;
  I := 1;
  Result := 0;
  while (I <= Length(S)) and (Count <> N) do begin
    { skip over delimiters }
    while (I <= Length(S)) and (S[I] in WordDelims) do Inc(I);
    { if we're not beyond end of S, we're at the start of a word }
    if I <= Length(S) then Inc(Count);
    { if not finished, find the end of the current word }
    if Count <> N then
      while (I <= Length(S)) and not (S[I] in WordDelims) do Inc(I)
    else Result := I;
  end;
end;

function ExtractWord(N: Integer; const S: string;
  const WordDelims: TSysCharSet): string;
var
  I: Integer;
  Len: Integer;
begin
  Len := 0;
  I := WordPosition(N, S, WordDelims);
  if I <> 0 then
    { find the end of the current word }
    while (I <= Length(S)) and not(S[I] in WordDelims) do begin
      { add the I'th character to result }
      Inc(Len);
      SetLength(Result, Len);
      Result[Len] := S[I];
      Inc(I);
    end;
  SetLength(Result, Len);
end;

procedure TNxCaptionProperty.Edit;
var
  Temp: string;
  Component: TPersistent;
  I, N: Integer;
begin
  with TCaptionDlg.Create(Application) do
  try
    Component := GetComponent(0);
    if Component is TComponent then Caption := TComponent(Component).Name + '.' + GetName
    else Caption := GetName;

    Temp := GetStrValue;
    N := WordCount(Temp, [#13, #10]);
    for I := 1 to N do Memo.Lines.Add(ExtractWord(I, Temp, [#13, #10]));

    Memo.MaxLength := GetEditLimit;
    if ShowModal = mrOk then
    begin
      Temp := Memo.Text;
      while (Length(Temp) > 0) and (Temp[Length(Temp)] < ' ') do
        System.Delete(Temp, Length(Temp), 1);
      SetStrValue(Temp);
    end;
  finally
    Free;
  end;
end;

function TNxCaptionProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes + [paDialog];
end;

{ TWideCaptionProperty }

function TWideCaptionProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes + [paAutoUpdate];
end;

end.
