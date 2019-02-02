{
  NextGrid
  Copyright (C) 1996-2002 by Berg
  All rights reserved.

  $id:NxGridCommon.pas 12/25/2002 7:10:16 bn
}

unit NxGridCommon;

interface

uses
  Windows, Classes, Graphics;

const
  crColumnNoDragDrop = 3001;
  crHorzSplit = 3000;
  crVertSplit = 3003;
  crOutlookHorzSplit = 3002;
  crIndicatorSelect = 3006;
  exCellOut = 'Cell out of bounds';
  exColOut = 'Column out of bounds';
  exRowOut = 'Row out of bounds';
  sizDropButton = 16;
  sizDragArrowHeight = 9;
  sizDragArrowWidth = 9;
  sizFooterSplitter = 4;
  sizIndicator = 12;
  sizInputSplitter = 6;
  spAllowDragDistance = 3;
  spDragBoxToCursorSpace = 4;
  spThemedHeaderMargin = 11;
  spCellTextMargin = 2;

type
  TGridArea = (gaNone, gaBody, gaFooter, gaHeader, gaIndicator, gaInput);

implementation

end.



