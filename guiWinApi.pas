unit guiWinApi;
{$I PHP.inc}
interface
uses   Winapi.Windows,
  {$IFDEF PHP7} hzend_types, {$ENDIF}
  zendTypes,
  ZENDAPI,
  phpTypes,
  PHPAPI,
  php4delphi;
procedure InitializeGuiWinAPI(PHPEngine: TPHPEngine);
implementation

procedure gui_ReleaseCapture(ht: integer; return_value: pzval;
  return_value_ptr: pzval; this_ptr: pzval; return_value_used: integer;
  TSRMLS_DC: pointer); cdecl;
begin
  if ht <> 0 then
  begin
    zend_wrong_param_count(TSRMLS_DC);
    Exit;
  end;
  ZVAL_BOOL(return_value, ReleaseCapture);
end;

procedure gui_SetCapture(ht: integer; return_value: pzval;
  return_value_ptr: pzval; this_ptr: pzval; return_value_used: integer;
  TSRMLS_DC: pointer); cdecl;
var
  p: pzval_array;
begin
  if ht < 1 then
  begin
    zend_wrong_param_count(TSRMLS_DC);
    Exit;
  end;
  zend_get_parameters_ex(ht, p);

  ZVAL_LONG(return_value, SetCapture( HWND(Z_LVAL(p[0]^)) ));
end;

procedure gui_GetCapture(ht: integer; return_value: pzval;
  return_value_ptr: pzval; this_ptr: pzval; return_value_used: integer;
  TSRMLS_DC: pointer); cdecl;
var
  p: pzval_array;
begin
  if ht <> 0 then
  begin
    zend_wrong_param_count(TSRMLS_DC);
    Exit;
  end;
  ZVAL_LONG(return_value, GetCapture());
end;

procedure InitializeGuiWinAPI(PHPEngine: TPHPEngine);
begin
  PHPEngine.AddFunction('ReleaseCapture', @gui_ReleaseCapture);
  PHPEngine.AddFunction('SetCapture', @gui_SetCapture);
  PHPEngine.AddFunction('GetCapture', @gui_GetCapture);
end;


end.