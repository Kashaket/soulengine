library php_squall;

{$I PHP.INC}

uses
  zendTypes,
  ZENDAPI,
  PHPAPI,
  Win_D_api,
  Squall;

{$R *.res}

function rinit (_type : integer; module_number : integer; TSRMLS_DC : pointer) : integer; cdecl;
begin
  Result := SUCCESS;
end;

function rshutdown (_type : integer; module_number : integer; TSRMLS_DC : pointer) : integer; cdecl;
begin
  SQUALL_Sample_UnloadAll();
  SQUALL_Free();
  Result := SUCCESS;
end;

procedure php_info_module(zend_module : Pzend_module_entry; TSRMLS_DC : pointer); cdecl;
begin
  php_info_print_table_start();
  php_info_print_table_row(2, PAnsiChar('php squall'), PAnsiChar('enabled'));
  php_info_print_table_end();
end;

function minit (_type : integer; module_number : integer; TSRMLS_DC : pointer) : integer; cdecl;
begin
  RESULT := SUCCESS;
end;

function mshutdown (_type : integer; module_number : integer; TSRMLS_DC : pointer) : integer; cdecl;
begin
  RESULT := SUCCESS;
end;

procedure _SQUALL_Init(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
    pr: psquall_parameters_t;
    param : pzval_array;
begin
  if ht > 13 then
  begin
    zend_wrong_param_count(TSRMLS_DC);
    Exit;
  end;

  if ht > 0 then
  begin
  if ( not (zend_get_parameters_ex(ht, param) = SUCCESS )) then
     begin
        zend_wrong_param_count(TSRMLS_DC);
        Exit;
     end;
  end;

   case ht of
    0: begin

    try
       ZVAL_LONG(return_value, SQUALL_Init(nil));
     except
        ZVAL_FALSE(return_value);
    end; end;
    1: begin
      pr.Window := PHandle( param[0]^.value.lval );
      try
       ZVAL_LONG(return_value, SQUALL_Init( pr ));
     except
        ZVAL_FALSE(return_value);
      end;
    end;
     2: begin
      pr.Window := PHandle( param[0]^.value.lval );
      pr.Device := param[1]^.value.lval;
      try
       ZVAL_LONG(return_value, SQUALL_Init( pr ));
     except
        ZVAL_FALSE(return_value);
      end;
    end;
    3: begin
      pr.Window := PHandle( param[0]^.value.lval );
      pr.Device := param[1]^.value.lval;
      pr.SampleRate := param[2]^.value.lval;
      try
       ZVAL_LONG(return_value, SQUALL_Init( pr ));
     except
        ZVAL_FALSE(return_value);
      end;
    end;
    4: begin
      pr.Window := PHandle( param[0]^.value.lval );
      pr.Device := param[1]^.value.lval;
      pr.SampleRate := param[2]^.value.lval;
      pr.BitPerSample := param[3]^.value.lval;
      try
       ZVAL_LONG(return_value, SQUALL_Init( pr ));
     except
        ZVAL_FALSE(return_value);
      end;
    end;
    5: begin
      pr.Window := PHandle( param[0]^.value.lval );
      pr.Device := param[1]^.value.lval;
      pr.SampleRate := param[2]^.value.lval;
      pr.BitPerSample := param[3]^.value.lval;
      pr.Channels := param[4]^.value.lval;
      try
       ZVAL_LONG(return_value, SQUALL_Init( pr ));
     except
        ZVAL_FALSE(return_value);
      end;
    end;
    6: begin
      pr.Window := PHandle( param[0]^.value.lval );
      pr.Device := param[1]^.value.lval;
      pr.SampleRate := param[2]^.value.lval;
      pr.BitPerSample := param[3]^.value.lval;
      pr.Channels := param[4]^.value.lval;
      pr.UseHW2D :=  param[5]^.value.lval;
      try
       ZVAL_LONG(return_value, SQUALL_Init( pr ));
     except
        ZVAL_FALSE(return_value);
      end;
    end;
     7: begin
      pr.Window := PHandle( param[0]^.value.lval );
      pr.Device := param[1]^.value.lval;
      pr.SampleRate := param[2]^.value.lval;
      pr.BitPerSample := param[3]^.value.lval;
      pr.Channels := param[4]^.value.lval;
      pr.UseHW2D :=  param[5]^.value.lval;
      pr.UseHW3D :=  param[6]^.value.lval;
      try
       ZVAL_LONG(return_value, SQUALL_Init( pr ));
     except
        ZVAL_FALSE(return_value);
      end;
    end;
     8: begin
      pr.Window := PHandle( param[0]^.value.lval );
      pr.Device := param[1]^.value.lval;
      pr.SampleRate := param[2]^.value.lval;
      pr.BitPerSample := param[3]^.value.lval;
      pr.Channels := param[4]^.value.lval;
      pr.UseHW2D :=  param[5]^.value.lval;
      pr.UseHW3D :=  param[6]^.value.lval;
      pr.UseAlg  :=  param[7]^.value.lval;
      try
       ZVAL_LONG(return_value, SQUALL_Init( pr ));
     except
        ZVAL_FALSE(return_value);
      end;
    end;
     9: begin
      pr.Window := PHandle( param[0]^.value.lval );
      pr.Device := param[1]^.value.lval;
      pr.SampleRate := param[2]^.value.lval;
      pr.BitPerSample := param[3]^.value.lval;
      pr.Channels := param[4]^.value.lval;
      pr.UseHW2D :=  param[5]^.value.lval;
      pr.UseHW3D :=  param[6]^.value.lval;
      pr.UseAlg  :=  param[7]^.value.lval;
      pr.BufferSize :=  param[8]^.value.lval;
      try
       ZVAL_LONG(return_value, SQUALL_Init( pr ));
     except
        ZVAL_FALSE(return_value);
      end;
    end;
     10: begin
      pr.Window := PHandle( param[0]^.value.lval );
      pr.Device := param[1]^.value.lval;
      pr.SampleRate := param[2]^.value.lval;
      pr.BitPerSample := param[3]^.value.lval;
      pr.Channels := param[4]^.value.lval;
      pr.UseHW2D :=  param[5]^.value.lval;
      pr.UseHW3D :=  param[6]^.value.lval;
      pr.UseAlg  :=  param[7]^.value.lval;
      pr.BufferSize :=  param[8]^.value.lval;
      pr.ListenerMode :=  param[9]^.value.lval;
      try
       ZVAL_LONG(return_value, SQUALL_Init( pr ));
     except
        ZVAL_FALSE(return_value);
      end;
    end;
     11: begin
      pr.Window := PHandle( param[0]^.value.lval );
      pr.Device := param[1]^.value.lval;
      pr.SampleRate := param[2]^.value.lval;
      pr.BitPerSample := param[3]^.value.lval;
      pr.Channels := param[4]^.value.lval;
      pr.UseHW2D :=  param[5]^.value.lval;
      pr.UseHW3D :=  param[6]^.value.lval;
      pr.UseAlg  :=  param[7]^.value.lval;
      pr.BufferSize :=  param[8]^.value.lval;
      pr.ListenerMode :=  param[9]^.value.lval;
      pr.DistanceFactor :=  param[10]^.value.dval;
      try
       ZVAL_LONG(return_value, SQUALL_Init( pr ));
     except
        ZVAL_FALSE(return_value);
      end;
    end;
     12: begin
      pr.Window := PHandle( param[0]^.value.lval );
      pr.Device := param[1]^.value.lval;
      pr.SampleRate := param[2]^.value.lval;
      pr.BitPerSample := param[3]^.value.lval;
      pr.Channels := param[4]^.value.lval;
      pr.UseHW2D :=  param[5]^.value.lval;
      pr.UseHW3D :=  param[6]^.value.lval;
      pr.UseAlg  :=  param[7]^.value.lval;
      pr.BufferSize :=  param[8]^.value.lval;
      pr.ListenerMode :=  param[9]^.value.lval;
      pr.DistanceFactor :=  param[10]^.value.dval;
      pr.RolloffFactor :=  param[11]^.value.dval;
      try
       ZVAL_LONG(return_value, SQUALL_Init( pr ));
     except
        ZVAL_FALSE(return_value);
      end;
    end;
     13: begin
      pr.Window := PHandle( param[0]^.value.lval );
      pr.Device := param[1]^.value.lval;
      pr.SampleRate := param[2]^.value.lval;
      pr.BitPerSample := param[3]^.value.lval;
      pr.Channels := param[4]^.value.lval;
      pr.UseHW2D :=  param[5]^.value.lval;
      pr.UseHW3D :=  param[6]^.value.lval;
      pr.UseAlg  :=  param[7]^.value.lval;
      pr.BufferSize :=  param[8]^.value.lval;
      pr.ListenerMode :=  param[9]^.value.lval;
      pr.DistanceFactor :=  param[10]^.value.dval;
      pr.RolloffFactor :=  param[11]^.value.dval;
      pr.DopplerFactor :=  param[12]^.value.dval;
      try
       ZVAL_LONG(return_value, SQUALL_Init( pr ));
     except
        ZVAL_FALSE(return_value);
      end;
    end;
   end;
   dispose_pzval_array(param);

end;

procedure _SQUALL_Free(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
begin

  if ht <> 0 then
    begin
      zend_wrong_param_count(TSRMLS_DC);
      Exit;
    end;

   try
     SQUALL_Free;
     ZVAL_TRUE(return_value);
   except
       ZVAL_FALSE(return_value);
   end;

end;

procedure _SQUALL_Sample_LoadFile(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      param : pzval_array;
begin

  if ht < 1 then
    begin
      zend_wrong_param_count(TSRMLS_DC);
      Exit;
    end;

  if ( not (zend_get_parameters_ex(ht, Param) = SUCCESS )) then
    begin
      zend_wrong_param_count(TSRMLS_DC);
      Exit;
   end;

   try
     ZVAL_LONG(return_value,
                SQUALL_Sample_LoadFile(PWideChar(param[0]^.value.str.val), 0, nil));
   except
        ZVAL_FALSE(return_value);
   end;

    dispose_pzval_array(param);
end;



procedure _SQUALL_Sample_Play(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      param : pzval_array;
      ID,LOOP,GROUP,START: Integer;
begin
  if ht <> 4 then
    begin
      zend_wrong_param_count(TSRMLS_DC);
      Exit;
    end;

  if ( not (zend_get_parameters_ex(ht, Param) = SUCCESS )) then
    begin
      zend_wrong_param_count(TSRMLS_DC);
      Exit;
   end;

   ID   := param[0]^.value.lval;
   LOOP := param[1]^.value.lval;
   GROUP:= param[2]^.value.lval;
   START:= param[3]^.value.lval;


   try
     ZVAL_LONG(return_value, SQUALL_Sample_Play(ID,LOOP,GROUP,START));
   except
       ZVAL_FALSE(return_value);
   end;

    dispose_pzval_array(param);
end;


procedure _SQUALL_Sample_Stop(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      param : pzval_array;
      ID: Integer;
begin
  if ht <> 1 then begin
      zend_wrong_param_count(TSRMLS_DC); Exit;
  end;

  if ( not (zend_get_parameters_ex(ht, Param) = SUCCESS )) then
    begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   ID   := param[0]^.value.lval;

   try
     ZVAL_LONG(return_value, SQUALL_Sample_Stop(ID));
   except
       ZVAL_FALSE(return_value);
   end;

    dispose_pzval_array(param);
end;

procedure _SQUALL_Sample_Pause(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
begin
  if ht <> 2 then begin
      zend_wrong_param_count(TSRMLS_DC); Exit;
  end;

  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then
    begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value, SQUALL_Sample_Pause(pr[0]^.value.lval,pr[1]^.value.lval));
   except
       ZVAL_FALSE(return_value);
   end;

    dispose_pzval_array(pr);
end;


procedure _SQUALL_Sample_SetDevice(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
begin
  if ht <> 1 then begin
      zend_wrong_param_count(TSRMLS_DC); Exit;
  end;

  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then
    begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value, SQUALL_SetDevice( ZendToVariant(pr[0]) ) );
   except
       ZVAL_FALSE(return_value);
   end;

    dispose_pzval_array(pr);
end;

procedure _SQUALL_Sample_GetDevice(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
begin
     ZVAL_LONG(return_value, SQUALL_GetDevice())
end;

procedure _SQUALL_Sample_Unload(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
begin
  if ht <> 1 then begin
      zend_wrong_param_count(TSRMLS_DC); Exit;
  end;

  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then
    begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_TRUE(return_value);
     SQUALL_Sample_Unload(pr[0]^.value.lval);
   except
       ZVAL_FALSE(return_value);
   end;

    dispose_pzval_array(pr);
end;

procedure _SQUALL_Sample_UnloadAll(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
begin
   try
     ZVAL_TRUE(return_value);
     SQUALL_Sample_UnloadAll();
   except
       ZVAL_FALSE(return_value);
   end;
end;





procedure _SQUALL_Sample_GetFileLength(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
begin
  if ht <> 1 then begin
      zend_wrong_param_count(TSRMLS_DC); Exit;
  end;

  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then
    begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
        SQUALL_Sample_GetFileLength(pr[0]^.value.lval)
     );
   except
       ZVAL_FALSE(return_value);
   end;

    dispose_pzval_array(pr);
end;




procedure _SQUALL_Sample_GetFileLengthMs(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
begin
  if ht <> 1 then begin
      zend_wrong_param_count(TSRMLS_DC); Exit;
  end;

  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then
    begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
        SQUALL_Sample_GetFileLengthMs(pr[0]^.value.lval)
     );
   except
       ZVAL_FALSE(return_value);
   end;

    dispose_pzval_array(pr);
end;



procedure _SQUALL_Sample_GetFileFrequency(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
begin
  if ht <> 1 then begin
      zend_wrong_param_count(TSRMLS_DC); Exit;
  end;

  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then
    begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
        SQUALL_Sample_GetFileFrequency(pr[0]^.value.lval)
     );
   except
       ZVAL_FALSE(return_value);
   end;

    dispose_pzval_array(pr);
end;



procedure _SQUALL_Sample_PlayEx(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
      ID,LOOP,GROUP,START,PRIORITY,VALUE,FREQ,PAN: Integer;
begin


  if ht <> 8 then begin
      zend_wrong_param_count(TSRMLS_DC); Exit;
  end;

  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then
    begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

    ID      := ZendToVariant(pr[0]);
    LOOP    := pr[1]^.value.lval;
    GROUP   := pr[2]^.value.lval;
    START   := pr[3]^.value.lval;
    PRIORITY:= pr[4]^.value.lval;
    VALUE   := pr[5]^.value.lval;
    FREQ    := pr[6]^.value.lval;
    PAN     := pr[7]^.value.lval;

   try
     ZVAL_LONG(return_value,
        SQUALL_Sample_PlayEx(ID,LOOP,GROUP,START,PRIORITY,VALUE,FREQ,PAN)
     );
   except
       ZVAL_FALSE(return_value);
   end;

    dispose_pzval_array(pr);
end;



procedure _SQUALL_Sample_SetDefault(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
      def: psquall_sample_default_t;
      AR: TArrayVariant;
      tmp : pppzval;
begin
  if ht <> 2 then begin
      zend_wrong_param_count(TSRMLS_DC); Exit;
  end;

  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then
    begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

    HashToArray(pr[1]^.value.ht, AR);


    new(def);
    new(tmp);

    zend_hash_find(pr[1]^.value.ht,'sample_group_id',15, tmp);
    def^.SampleGroupID := ZendToVariant(tmp);

    zend_hash_find(pr[1]^.value.ht,'priority',8, tmp);
    def^.Priority      := ZendToVariant(tmp);

    zend_hash_find(pr[1]^.value.ht,'frequency',9, tmp);
    def^.Frequency     := ZendToVariant(tmp);

    zend_hash_find(pr[1]^.value.ht,'volume',6, tmp);
    def^.Volume        := ZendToVariant(tmp);

    zend_hash_find(pr[1]^.value.ht,'pan',3, tmp);
    def^.Pan           := ZendToVariant(tmp);

    zend_hash_find(pr[1]^.value.ht,'min_dist',8, tmp);
    def^.MinDist       := ZendToVariant(tmp);

    zend_hash_find(pr[1]^.value.ht,'max_dist',8, tmp);
    def^.MaxDist       := ZendToVariant(tmp);

   try
     ZVAL_LONG(return_value,
        SQUALL_Sample_SetDefault(pr[0]^.value.lval, def)
     );
   except
       ZVAL_FALSE(return_value);
   end;

    FreeMem(def);
    dispose_pzval_array(pr);
end;


procedure _SQUALL_Sample_GetDefault(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
      def: squall_sample_default_t;
      AR: TArrayVariant;
      res: integer;
begin
  if ht <> 1 then begin
      zend_wrong_param_count(TSRMLS_DC); Exit;
  end;

  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then
    begin zend_wrong_param_count(TSRMLS_DC); Exit; end;


    res := SQUALL_Sample_GetDefault(pr[0]^.value.lval, def);

    if res < 0 then
        ZVAL_LONG(return_value, res)
    else begin

        SetLength(AR,7);

        AR[0] := def.SampleGroupID;
        AR[1] := def.Priority;
        AR[2] := def.Frequency;
        AR[3] := def.Volume;
        AR[4] := def.Pan;
        AR[5] := def.MinDist;
        AR[6] := def.MaxDist;

        ArrayToHash(
                ['sample_group_id','priority','frequency','volume','pan','min_dist','max_dist'],
                AR,
                return_value
        );

    end;

    dispose_pzval_array(pr);
end;


procedure _SQUALL_Sample_Play3D(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
      ID,LOOP,GROUP,START{,PRIORITY,VALUE,FREQ,PAN}: Integer;
      POS, VEL: TArrayVariant;
      POSITION, VELOCITY: TSoundVec;
begin
  if ht <> 6 then begin
      zend_wrong_param_count(TSRMLS_DC); Exit;
  end;

  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then
    begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

    ID   := pr[0]^.value.lval;
    LOOP := pr[1]^.value.lval;
    GROUP:= pr[2]^.value.lval;
    START:= pr[3]^.value.lval;
    HashToArray(pr[4]^.value.ht, POS);
    HashToArray(pr[5]^.value.ht, VEL);


    POSITION[0] := POS[0];
    POSITION[1] := POS[1];
    POSITION[2] := POS[2];

    VELOCITY[0] := VEL[0];
    VELOCITY[1] := VEL[1];
    VELOCITY[2] := VEL[2];

   try
     ZVAL_LONG(return_value,
        SQUALL_Sample_Play3D(ID, LOOP, GROUP, START, @POSITION, @VELOCITY)
     );
   except
       ZVAL_FALSE(return_value);
   end;

    dispose_pzval_array(pr);
end;

procedure _SQUALL_Sample_Play3DEx(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
      ID,LOOP,GROUP,START,PRIORITY,VALUE,FREQ: Integer;
      min,max: single;
      POS, VEL: TArrayVariant;
      POSITION, VELOCITY: TSoundVec;
begin
  if ht <> 11 then begin
      zend_wrong_param_count(TSRMLS_DC); Exit;
  end;

  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then
    begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

    ID   := pr[0]^.value.lval;
    LOOP := pr[1]^.value.lval;
    GROUP:= pr[2]^.value.lval;
    START:= pr[3]^.value.lval;
    HashToArray(pr[4]^.value.ht, POS);
    HashToArray(pr[5]^.value.ht, VEL);

    PRIORITY := ZendToVariant(pr[6]);
    VALUE:= ZendToVariant(pr[7]);
    FREQ := ZendToVariant(pr[8]);
    min  := ZendToVariant(pr[9]);
    max  := ZendToVariant(pr[10]);


    POSITION[0] := POS[0];
    POSITION[1] := POS[1];
    POSITION[2] := POS[2];

    VELOCITY[0] := VEL[0];
    VELOCITY[1] := VEL[1];
    VELOCITY[2] := VEL[2];

   try
     ZVAL_LONG(return_value,
        SQUALL_Sample_Play3DEx(ID, LOOP, GROUP, START, @POSITION, @VELOCITY,
        PRIORITY,VALUE,FREQ,min,max)
     );
   except
       ZVAL_FALSE(return_value);
   end;

    dispose_pzval_array(pr);
end;

procedure _SQUALL_Channel_Start(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
begin
  if ht <> 1 then begin
      zend_wrong_param_count(TSRMLS_DC); Exit;
  end;

  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then
    begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
        SQUALL_Channel_Start(pr[0]^.value.lval)
     );
   except
       ZVAL_FALSE(return_value);
   end;

    dispose_pzval_array(pr);
end;

procedure _SQUALL_Channel_Pause(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
begin
  if ht <> 2 then begin
      zend_wrong_param_count(TSRMLS_DC); Exit;
  end;

  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then
    begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
        SQUALL_Channel_Pause(pr[0]^.value.lval, pr[1]^.value.lval)
     );
   except
       ZVAL_FALSE(return_value);
   end;

    dispose_pzval_array(pr);
end;

procedure _SQUALL_Channel_Stop(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
begin
  if ht <> 1 then begin
      zend_wrong_param_count(TSRMLS_DC); Exit;
  end;

  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then
    begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
        SQUALL_Channel_Stop(pr[0]^.value.lval)
     );
   except
       ZVAL_FALSE(return_value);
   end;

    dispose_pzval_array(pr);
end;

procedure _SQUALL_Channel_Status(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
begin
  if ht <> 1 then begin
      zend_wrong_param_count(TSRMLS_DC); Exit;
  end;

  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then
    begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
        SQUALL_Channel_Status(pr[0]^.value.lval)
     );
   except
       ZVAL_FALSE(return_value);
   end;

    dispose_pzval_array(pr);
end;


procedure _SQUALL_Channel_SetVolume(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
      vol: Integer;
      channel: integer;
begin
  if ht <> 2 then begin
      zend_wrong_param_count(TSRMLS_DC); Exit;
  end;

  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then
    begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

    channel := pr[0]^.value.lval;
    vol := pr[1]^.value.lval;

   try
     ZVAL_LONG(return_value,SQUALL_Channel_SetVolume(channel, vol));
   except
       ZVAL_FALSE(return_value);
   end;

    dispose_pzval_array(pr);
end;


procedure _SQUALL_Channel_GetVolume(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
begin
  if ht <> 1 then begin
      zend_wrong_param_count(TSRMLS_DC); Exit;
  end;

  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then
    begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
        SQUALL_Channel_GetVolume(pr[0]^.value.lval)
     );
   except
       ZVAL_FALSE(return_value);
   end;

    dispose_pzval_array(pr);
end;


procedure _SQUALL_Channel_SetFrequency(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
begin
  if ht <> 2 then begin
      zend_wrong_param_count(TSRMLS_DC); Exit;
  end;

  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then
    begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
        SQUALL_Channel_SetFrequency(pr[0]^.value.lval, pr[1]^.value.lval)
     );
   except
       ZVAL_FALSE(return_value);
   end;

    dispose_pzval_array(pr);
end;


procedure _SQUALL_Channel_GetFrequency(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
begin
  if ht <> 1 then begin
      zend_wrong_param_count(TSRMLS_DC); Exit;
  end;

  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then
    begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
        SQUALL_Channel_GetFrequency(pr[0]^.value.lval)
     );
   except
       ZVAL_FALSE(return_value);
   end;

    dispose_pzval_array(pr);
end;


procedure _SQUALL_Channel_SetPlayPosition(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
begin
  if ht <> 2 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then
    begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
        SQUALL_Channel_SetPlayPosition(pr[0]^.value.lval, pr[1]^.value.lval)
     );
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;

procedure _SQUALL_Channel_GetPlayPosition(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
begin
  if ht <> 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
        SQUALL_Channel_GetPlayPosition(pr[0]^.value.lval)
     );
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;

procedure _SQUALL_Channel_SetPlayPositionMs(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
begin
  if ht <> 2 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then
    begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
        SQUALL_Channel_SetPlayPositionMs(pr[0]^.value.lval, pr[1]^.value.lval)
     );
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;


procedure _SQUALL_Channel_GetPlayPositionMs(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
begin
  if ht <> 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
        SQUALL_Channel_GetPlayPositionMs(pr[0]^.value.lval)
     );
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;


procedure _SQUALL_Channel_SetFragment(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
begin
  if ht <> 3 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then
    begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
        SQUALL_Channel_SetFragment(pr[0]^.value.lval, pr[1]^.value.lval, pr[2]^.value.lval)
     );
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;




procedure _SQUALL_Channel_GetFragment(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
      s,e,r: integer;
begin
  if ht <> 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try

     r := SQUALL_Channel_GetFragment(pr[0]^.value.lval, s, e);

     if (r >= 0) then
        ArrayToHash(['start','end'],[s,e], return_value)
     else
        ZVAL_LONG(return_value,r);

   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;




procedure _SQUALL_Channel_SetFragmentMs(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
begin
  if ht <> 3 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then
    begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
        SQUALL_Channel_SetFragmentMs(pr[0]^.value.lval, pr[1]^.value.lval, pr[2]^.value.lval)
     );
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;




procedure _SQUALL_Channel_GetFragmentMs(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
      s, e, r: integer;
begin
  if ht <> 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     r := SQUALL_Channel_GetFragmentMs(pr[0]^.value.lval, s, e);

     if (r >= 0) then
        ArrayToHash(['start','end'],[s,e], return_value)
     else
        ZVAL_LONG(return_value,r);

   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;





procedure _SQUALL_Channel_GetLength(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
begin
  if ht <> 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
        SQUALL_Channel_GetLength(pr[0]^.value.lval)
     );
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;

procedure _SQUALL_Channel_GetLengthMs(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
begin
  if ht <> 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
        SQUALL_Channel_GetLengthMs(pr[0]^.value.lval)
     );
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;




procedure _SQUALL_Channel_SetPriority(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
begin
  if ht <> 2 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then
    begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
        SQUALL_Channel_SetPriority(pr[0]^.value.lval, pr[1]^.value.lval)
     );
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;




procedure _SQUALL_Channel_GetPriority(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
begin
  if ht <> 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
        SQUALL_Channel_GetPriority(pr[0]^.value.lval)
     );
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;





procedure _SQUALL_Channel_SetLoop(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
begin
  if ht <> 2 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then
    begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
        SQUALL_Channel_SetLoop(pr[0]^.value.lval, pr[1]^.value.lval)
     );
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;




procedure _SQUALL_Channel_GetLoop(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
begin
  if ht <> 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
        SQUALL_Channel_GetLoop(pr[0]^.value.lval)
     );
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;





procedure _SQUALL_Channel_SetPan(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
begin
  if ht <> 2 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then
    begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
        SQUALL_Channel_SetPan(pr[0]^.value.lval, pr[1]^.value.lval)
     );
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;




procedure _SQUALL_Channel_GetPan(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
begin
  if ht <> 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
        SQUALL_Channel_GetPan(pr[0]^.value.lval)
     );
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;


procedure _SQUALL_SetHardwareAcceleration(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
begin
  if ht <> 2 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
        SQUALL_SetHardwareAcceleration(pr[0]^.value.lval, pr[1]^.value.lval)
     );
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;


procedure _SQUALL_GetHardwareAcceleration(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      buf1, buf2, res: integer;
begin
  if ht <> 0 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     res := SQUALL_GetHardwareAcceleration(buf1, buf2);
     if res >= 0 then
     begin
      ArrayToHash( [Variant(buf1), Variant(buf2)], return_value );
     end
     else
     begin
       ZVAL_LONG(return_value, res);
     end;
   except ZVAL_FALSE(return_value); end;
end;

procedure _SQUALL_SetSpeakerMode(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
begin
  if ht <> 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
        SQUALL.SQUALL_SetSpeakerMode(pr[0]^.value.lval)
     );
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;


procedure _SQUALL_GetSpeakerMode(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
begin
    if ht <> 0 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
        SQUALL.SQUALL_GetSpeakerMode()
     );
   except ZVAL_FALSE(return_value); end;
end;

procedure _SQUALL_Set3DAlgorithm(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
begin
  if ht <> 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
    if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
        SQUALL.SQUALL_Set3DAlgorithm(pr[0]^.value.lval)
     );
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;

procedure _SQUALL_Get3DAlgorithm(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
begin
  if ht <> 0 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
        SQUALL.SQUALL_Get3DAlgorithm()
     );
   except ZVAL_FALSE(return_value); end;
end;

procedure _SQUALL_SetBufferSize(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
begin
  if ht <> 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
    if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
        SQUALL.SQUALL_SetBufferSize(pr[0]^.value.lval)
     );
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;

procedure _SQUALL_GetBufferSize(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
begin
  if ht <> 0 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
        SQUALL.SQUALL_GetBufferSize()
     );
   except ZVAL_FALSE(return_value); end;
end;

procedure _SQUALL_GetNumDevice(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
begin
  if ht <> 0 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
        SQUALL.SQUALL_GetNumDevice()
     );
   except ZVAL_FALSE(return_value); end;
end;

procedure _SQUALL_GetDeviceName(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
      buffer: array[0..255] of AnsiChar;
      rivb: RawByteString;
      res: integer;
begin
  if ht <> 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
      if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
   begin
   res := SQUALL.SQUALL_GetDeviceName(pr[0]^.value.lval, buffer, Length(buffer)*(SizeOf(PAnsiChar)*2));
   if res >= 0 then
   begin
      SetString(rivb, buffer, Length(buffer)*(SizeOf(PAnsiChar)*2));
     ZVAL_STRING(return_value,
         PAnsiChar(rivb),
         true
     );
   end
   else
   begin
     ZVAL_LONG(return_value, res);
   end;
   end;
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;

procedure _SQUALL_GetDeviceCaps(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
      buf: squall_device_caps_t;
      buf2: array of Variant;
      res: integer;
begin
  if ht <> 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
    if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
   begin
    res := SQUALL.SQUALL_GetDeviceCaps(pr[0]^.value.lval, buf);
    if res >= 0  then
    begin
      setLength(buf2, 3);
      buf2[0] := Variant( buf.Flags );
      buf2[1] := Variant( buf.HardwareChannels );
      buf2[2] := Variant( buf.Hardware3DChannels );
      ArrayToHash( buf2, return_value );
    end
    else
    begin
      ZVAL_LONG(return_value, res);
    end;
   end;
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;

procedure _SQUALL_GetEAXVersion(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
begin
  if ht <> 0 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
      ZVAL_LONG(return_value, SQUALL.SQUALL_GetEAXVersion());
   except ZVAL_FALSE(return_value); end;
end;

procedure _SQUALL_GetChannelsInfo(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      buf: squall_channels_t;
      res: integer;
begin
  if ht <> 0 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
   begin
   res := SQUALL.SQUALL_GetChannelsInfo(buf);
   if res >= 0 then
   begin
      ArrayToHash(
        [Variant(buf.Play),
        Variant(buf.Pause),
        Variant(buf.Prepare),
        Variant(buf.Play3D),
        Variant(buf.Pause3D),
        Variant(buf.Prepare3D)],
        return_value);
   end
   else
   begin
      ZVAL_LONG(return_value, res);
   end;
   end;
   except ZVAL_FALSE(return_value); end;
end;

procedure _SQUALL_Listener_SetParameters(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
      position, front, top, velocity: single;
begin
  if ht <> 4 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
    if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     position :=  pr[0]^.value.dval;
     front    :=  pr[1]^.value.dval;
     top      :=  pr[2]^.value.dval;
     velocity :=  pr[3]^.value.dval;
     ZVAL_LONG(return_value,
        SQUALL.SQUALL_Listener_SetParameters (
        @position,
        @front,
        @top,
        @velocity
        )
     );
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;

procedure _SQUALL_Listener_GetParameters(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      position, front, top, velocity: single;
      res: integer;
begin
  if ht <> 0 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
    res := SQUALL.SQUALL_Listener_GetParameters(
        PSingle(position),
        PSingle(front),
        PSingle(top),
        PSingle(velocity));
    if res >= 0 then
    begin
      ArrayToHash(
      [
      Variant(position),
      Variant(front),
      Variant(top),
      Variant(velocity)],
      return_value);
    end
    else
    begin
     ZVAL_LONG(return_value, res);
    end;
   except ZVAL_FALSE(return_value); end;
end;

procedure _SQUALL_Listener_SetVelocity(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
      velocity: single;
begin
  if ht <> 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
    if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     velocity :=  pr[0]^.value.dval;
     ZVAL_LONG(return_value,
        SQUALL.SQUALL_Listener_SetVelocity (
        @velocity
        )
     );
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;

procedure _SQUALL_Listener_GetVelocity(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      velocity: single;
      res: integer;
begin
  if ht <> 0 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     res := SQUALL.SQUALL_Listener_GetVelocity (PSingle(velocity));
     if res >=0 then
     begin
         ZVAL_DOUBLE(return_value, velocity);
     end
     else
     begin
         ZVAL_LONG(return_value, res);
     end;
   except ZVAL_FALSE(return_value); end;
end;

procedure _SQUALL_Listener_SetPosition(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
      pos: single;
begin
  if ht <> 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
    if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     pos :=  pr[0]^.value.dval;
     ZVAL_LONG(return_value,
        SQUALL.SQUALL_Listener_SetPosition (
        @pos
        )
     );
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;

procedure _SQUALL_Listener_GetPosition(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pos : single;
      res: integer;
begin
  if ht <> 0 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
   try
     res := SQUALL.SQUALL_Listener_GetPosition (PSingle(pos));
     if res >=0 then
     begin
         ZVAL_DOUBLE(return_value, pos);
     end
     else
     begin
         ZVAL_LONG(return_value, res);
     end;
   except ZVAL_FALSE(return_value); end;
end;

procedure _SQUALL_Listener_SetDistanceFactor(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
      pos: single;
begin
  if ht <> 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
    if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     pos :=  pr[0]^.value.dval;
     ZVAL_LONG(return_value,
        SQUALL.SQUALL_Listener_SetDistanceFactor (
        pos
        )
     );
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;

procedure _SQUALL_Listener_GetDistanceFactor(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pos : single;
      res: integer;
begin
  if ht <> 0 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     res := SQUALL.SQUALL_Listener_GetDistanceFactor (pos);
     if res >=0 then
     begin
         ZVAL_DOUBLE(return_value, pos);
     end
     else
     begin
         ZVAL_LONG(return_value, res);
     end;
   except ZVAL_FALSE(return_value); end;
end;

procedure _SQUALL_Listener_SetFrolovFactor(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
      pos: single;
begin
  if ht <> 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
    if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     pos :=  pr[0]^.value.dval;
     ZVAL_LONG(return_value,
        SQUALL.SQUALL_Listener_SetRolloffFactor (
        pos
        )
     );
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;
                           //Rollof
procedure _SQUALL_Listener_GetFrolovFactor(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pos : single;
      res: integer;
begin
  if ht <> 0 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     res := SQUALL.SQUALL_Listener_GetRolloffFactor (pos);
     if res >=0 then
     begin
         ZVAL_DOUBLE(return_value, pos);
     end
     else
     begin
         ZVAL_LONG(return_value, res);
     end;
   except ZVAL_FALSE(return_value); end;
end;

procedure _SQUALL_Listener_SetDopplerFactor(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
      pos: single;
begin
  if ht <> 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
    if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     pos :=  pr[0]^.value.dval;
     ZVAL_LONG(return_value,
        SQUALL.SQUALL_Listener_SetDopplerFactor (
        pos
        )
     );
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;

procedure _SQUALL_Listener_GetDopplerFactor(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pos : single;
      res: integer;
begin
  if ht <> 0 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     res := SQUALL.SQUALL_Listener_GetDopplerFactor (pos);
     if res >=0 then
     begin
         ZVAL_DOUBLE(return_value, pos);
     end
     else
     begin
         ZVAL_LONG(return_value, res);
     end;
   except ZVAL_FALSE(return_value); end;
end;

procedure _SQUALL_Listener_Update(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
begin
  if ht <> 0 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
   try
     ZVAL_LONG(return_value,
        SQUALL.SQUALL_Listener_Update ()
     );
   except ZVAL_FALSE(return_value); end;
end;

procedure _SQUALL_Listener_EAX_SetPreset(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
begin
  if ht <> 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
    if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
      SQUALL.SQUALL_Listener_EAX_SetPreset (pr[0]^.value.lval)
      );
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;

                  //add class TEax for every props
procedure _SQUALL_Listener_EAX_SetProperties(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
      props: psquall_eax_listener_t;
      ar, ar2: TArrayVariant;
      ars, ars2: TSoundVec;
begin
//4 + 1, 14 + 1, 24 + 1
  if (ht <> 5) and (ht <> 15) and (ht <> 25) then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
    if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
    case pr[0]^.value.lval of
    1: begin
      if (ht <> 5) then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
      props.eax1.Environment    := Cardinal(pr[1]^.value.lval);
      props.eax1.Volume         := pr[2]^.value.dval;
      props.eax1.DecayTime_sec  := pr[3]^.value.dval;
      props.eax1.Damping        := pr[4]^.value.dval;
    end;
    2: begin
      if (ht <> 15) then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
      props.eax2.Room               := pr[1]^.value.lval;
      props.eax2.RoomHF             := pr[2]^.value.lval;
      props.eax2.RoomRolloffFactor  := pr[3]^.value.dval;
      props.eax2.DecayTime          := pr[4]^.value.dval;
      props.eax2.DecayHFRatio       := pr[5]^.value.dval;
      props.eax2.Reflections        := pr[6]^.value.lval;
      props.eax2.ReflectionsDelay   := pr[7]^.value.dval;
      props.eax2.Reverb             := pr[8]^.value.lval;
      props.eax2.ReverbDelay        := pr[9]^.value.dval;
      props.eax2.Environment        := Cardinal(pr[10]^.value.lval);
      props.eax2.EnvironmentSize    := pr[11]^.value.dval;
      props.eax2.EnvironmentDiffusion:=pr[12]^.value.dval;
      props.eax2.AirAbsorptionHF    := pr[13]^.value.dval;
      props.eax2.Flags              := Cardinal(pr[14]^.value.lval);
    end;
    3: begin
      if (ht <> 25) or (pr[12]^._type <> IS_ARRAY) or (pr[14]^._type <> IS_ARRAY) then
      begin
        zend_wrong_param_count(TSRMLS_DC);
        Exit;
      end;
       props.eax3.Environment         := Cardinal(pr[1]^.value.lval);
       props.eax3.EnvironmentSize     := pr[2]^.value.lval;
       props.eax3.EnvironmentDiffusion:= pr[3]^.value.dval;
       props.eax3.Room                := pr[4]^.value.lval;
       props.eax3.RoomHF              := pr[5]^.value.lval;
       props.eax3.RoomLF              := pr[6]^.value.lval;
       props.eax3.DecayTime           := pr[7]^.value.dval;
       props.eax3.DecayHFRatio        := pr[8]^.value.dval;
       props.eax3.DecayLFRatio        := pr[9]^.value.dval;
       props.eax3.Reflections         := pr[10]^.value.lval;
       props.eax3.ReflectionsDelay    := pr[11]^.value.dval;
       //дичайшие костыли
       HashToArray(pr[12]^.value.ht, ar);
       ars[0]  := ar[0];
       ars[1]  := ar[1];
       ars[2]  := ar[2];
       props.eax3.ReflectionsPan      := ars;
       props.eax3.Reverb              := pr[13]^.value.lval;
       //дичайшие костыли
       HashToArray(pr[14]^.value.ht, ar2);
       ars2[0]  := ar2[0];
       ars2[1]  := ar2[1];
       ars2[2]  := ar2[2];
       props.eax3.ReverbPan           := ars2;
       props.eax3.ReverbDelay         := pr[15]^.value.dval;
       props.eax3.EchoTime            := pr[16]^.value.dval;
       props.eax3.EchoDepth           := pr[17]^.value.dval;
       props.eax3.ModulationTime      := pr[18]^.value.dval;
       props.eax3.ModulationDepth     := pr[19]^.value.dval;
       props.eax3.AirAbsorptionHF     := pr[20]^.value.dval;
       props.eax3.HFReference         := pr[21]^.value.dval;
       props.eax3.LFReference         := pr[22]^.value.dval;
       props.eax3.RoomRolloffFactor   := pr[23]^.value.dval;
       props.eax3.Flags               := Cardinal(pr[24]^.value.lval);
    end;
    end;
     ZVAL_LONG(return_value,
      SQUALL.SQUALL_Listener_EAX_SetProperties (pr[0]^.value.lval, props)
      );
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;

                  //add class TEax for every props
procedure _SQUALL_Listener_EAX_GetProperties(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
      res: integer;
      props: squall_eax_listener_t;
      ar, ar2: TArrayVariant;
begin
  if (ht <> 1) then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
    if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
   res := SQUALL.SQUALL_Listener_EAX_GetProperties (pr[0]^.value.lval, props);
   if res >=0 then
   begin
    case pr[0]^.value.lval of
    1: begin
      ArrayToHash([
      Variant(props.eax1.Environment),
      Variant(props.eax1.Volume),
      Variant(props.eax1.DecayTime_sec),
      Variant(props.eax1.Damping)],
      return_value);
    end;
    2: begin
      ArrayToHash([
      Variant(props.eax2.Room),
      Variant(props.eax2.RoomHF),
      Variant(props.eax2.RoomRolloffFactor),
      Variant(props.eax2.DecayTime),
      Variant(props.eax2.DecayHFRatio),
      Variant(props.eax2.Reflections),
      Variant(props.eax2.ReflectionsDelay),
      Variant(props.eax2.Reverb),
      Variant(props.eax2.ReverbDelay),
      Variant(props.eax2.Environment),
      Variant(props.eax2.EnvironmentSize),
      Variant(props.eax2.EnvironmentDiffusion),
      Variant(props.eax2.AirAbsorptionHF),
      Variant(props.eax2.Flags)],
      return_value);
    end;
    3: begin
    ar := [props.eax3.ReflectionsPan[0],
        props.eax3.ReflectionsPan[1],
        props.eax3.ReflectionsPan[2]];
    ar2 := [props.eax3.ReverbPan[0],
        props.eax3.ReverbPan[1],
        props.eax3.ReverbPan[2]];
      ArrayToHash([
       Variant(props.eax3.Environment),
       Variant(props.eax3.EnvironmentSize),
       Variant(props.eax3.EnvironmentDiffusion),
       Variant(props.eax3.Room),
       Variant(props.eax3.RoomHF),
       Variant(props.eax3.RoomLF),
       Variant(props.eax3.DecayTime),
       Variant(props.eax3.DecayHFRatio),
       Variant(props.eax3.DecayLFRatio),
       Variant(props.eax3.Reflections),
       Variant(props.eax3.ReflectionsDelay),
       Variant(ar),
       Variant(props.eax3.Reverb),
       Variant(props.eax3.ReverbDelay),
        Variant(ar2),
       Variant(props.eax3.EchoTime),
       Variant(props.eax3.EchoDepth),
       Variant(props.eax3.ModulationTime),
       Variant(props.eax3.ModulationDepth),
       Variant(props.eax3.AirAbsorptionHF),
       Variant(props.eax3.HFReference),
       Variant(props.eax3.LFReference),
       Variant(props.eax3.RoomRolloffFactor),
       Variant(props.eax3.Flags)],
       return_value);
    end;
    end;
   end
   else
   begin
     ZVAL_LONG(return_value, res);
   end;
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;

procedure _SQUALL_Channel_Set3DPosition(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
      pos: single;
begin
  if ht <> 2 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
    if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     pos :=  pr[1]^.value.dval;
     ZVAL_LONG(return_value,
        SQUALL.SQUALL_Channel_Set3DPosition (pr[0]^.value.lval, PSingle(pos))
     );
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;

procedure _SQUALL_Channel_Get3DPosition(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
      pos : single;
      res: integer;
begin
  if ht <> 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
    if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     res := SQUALL.SQUALL_Channel_Set3DPosition (pr[0]^.value.lval, PSingle(pos));
     if res >=0 then
     begin
         ZVAL_DOUBLE(return_value, pos);
     end
     else
     begin
         ZVAL_LONG(return_value, res);
     end;
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;

procedure _SQUALL_Channel_SetVelocity(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
      pos: single;
begin
  if ht <> 2 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
    if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     pos :=  pr[1]^.value.dval;
     ZVAL_LONG(return_value,
        SQUALL.SQUALL_Channel_SetVelocity (
        pr[0]^.value.lval,
        PSingle(pos)
        )
     );
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;

procedure _SQUALL_Channel_GetVelocity(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
      pos : single;
      res: integer;
begin
  if ht <> 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     res := SQUALL.SQUALL_Channel_GetVelocity (pr[0]^.value.lval, PSingle(pos));
     if res >=0 then
     begin
         ZVAL_DOUBLE(return_value, pos);
     end
     else
     begin
         ZVAL_LONG(return_value, res);
     end;
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;

procedure _SQUALL_Channel_SetMinMaxDistance(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
begin
  if ht <> 3 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
     SQUALL.SQUALL_Channel_SetMinMaxDistance (
     pr[0]^.value.lval,
     pr[1]^.value.dval,
     pr[2]^.value.dval));
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;

procedure _SQUALL_Channel_GetMinMaxDistance(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
      pos, pos2: single;
      res: integer;
begin
  if ht <> 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
    if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     res := SQUALL.SQUALL_Channel_GetMinMaxDistance (
        pr[0]^.value.lval,
        pos,
        pos2
        );
     if res >= 0 then
     begin
        ArrayToHash([Variant(pos), Variant(pos2)], return_value);
     end
    else
    begin
      ZVAL_LONG(return_value, res);
    end;
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;

procedure _SQUALL_Channel_SetConeParameters(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
begin
  if ht <> 5 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
    if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
     SQUALL.SQUALL_Channel_SetConeParameters (
        pr[0]^.value.lval,
        pr[1]^.value.dval,
        pr[2]^.value.lval,
        pr[3]^.value.lval,
        pr[4]^.value.lval
        )
        );
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;

procedure _SQUALL_Channel_GetConeParameters(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
      poss : single;
      pos1, pos2, pos3, res: integer;
begin
  if ht <> 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
        res := SQUALL.SQUALL_Channel_GetConeParameters (
        pr[0]^.value.lval,
        poss,
        pos1,
        pos2,
        pos3
        );
     if res >= 0 then
     begin
        ArrayToHash([
        Variant(poss),
        Variant(pos1),
        Variant(pos2),
        Variant(pos3)],
        return_value);
     end
    else
    begin
      ZVAL_LONG(return_value, res);
    end;
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;

                 //add class TEax for every props
procedure _SQUALL_Channel_EAX_SetProperties(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
      props: psquall_eax_channel_t;
begin
//4 + 1 + 1, 14 + 1 + 1, 24 + 1 + 1
  if (ht <> 3) and (ht <> 14) and (ht <> 20) then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
    if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
    case pr[1]^.value.lval of
    1: begin
      if (ht <> 3) then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
        props.eax1.Mix  := pr[2]^.value.dval;
    end;
    2: begin
      if (ht <> 14) then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
      props.eax2.Direct             := pr[2]^.value.lval;
      props.eax2.DirectHF           := pr[3]^.value.lval;
      props.eax2.Room               := pr[4]^.value.lval;
      props.eax2.RoomRolloffFactor  := pr[5]^.value.dval;
      props.eax2.Obstruction        := pr[6]^.value.lval;
      props.eax2.ObstructionLFRatio := pr[7]^.value.dval;
      props.eax2.Occlusion          := pr[8]^.value.lval;
      props.eax2.OcclusionLFRatio   := pr[9]^.value.dval;
      props.eax2.OcclusionRoomRatio := pr[10]^.value.dval;
      props.eax2.OutsideVolumeHF    := pr[11]^.value.lval;
      props.eax2.AirAbsorptionFactor:= pr[12]^.value.dval;
      props.eax2.Flags              := Cardinal(pr[13]^.value.lval);
    end;
    3: begin
      if (ht <> 20) then
      begin
        zend_wrong_param_count(TSRMLS_DC);
        Exit;
      end;
       props.eax3.Direct              :=  pr[2]^.value.lval;
       props.eax3.DirectHF            :=  pr[3]^.value.lval;
       props.eax3.Room                :=  pr[4]^.value.lval;
       props.eax3.RoomHF              :=  pr[5]^.value.lval;
       props.eax3.Obstruction         :=  pr[6]^.value.lval;
       props.eax3.ObstructionLFRatio  :=  pr[7]^.value.dval;
       props.eax3.Occlusion           :=  pr[8]^.value.lval;
       props.eax3.OcclusionLFRatio    :=  pr[9]^.value.dval;
       props.eax3.OcclusionRoomRatio  :=  pr[10]^.value.dval;
       props.eax3.OcclusionDirectRatio:=  pr[11]^.value.dval;
       props.eax3.Exclusion           :=  pr[12]^.value.lval;
       props.eax3.ExclusionLFRatio    :=  pr[13]^.value.dval;
       props.eax3.OutsideVolumeHF     :=  pr[14]^.value.lval;
       props.eax3.DopplerFactor       :=  pr[15]^.value.dval;
       props.eax3.RolloffFactor       :=  pr[16]^.value.dval;
       props.eax3.RoomRolloffFactor   :=  pr[17]^.value.dval;
       props.eax3.AirAbsorptionFactor :=  pr[18]^.value.dval;
       props.eax3.Flags               := Cardinal(pr[19]^.value.lval);
    end;
    end;
     ZVAL_LONG(return_value,
      SQUALL.SQUALL_Channel_EAX_SetProperties (pr[0]^.value.lval, pr[1]^.value.lval, props)
      );
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;

                 //add class TEax for every props
procedure _SQUALL_Channel_EAX_GetProperties(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
      res: integer;
      props: squall_eax_channel_t;
begin
  if (ht <> 2) then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
    if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
   res := SQUALL.SQUALL_Channel_EAX_GetProperties (pr[0]^.value.lval, pr[1]^.value.lval, props);
   if res >=0 then
   begin
    case pr[0]^.value.lval of
    1: begin
      ZVAL_DOUBLE(return_value,
      props.eax1.Mix);
    end;
    2: begin
      ArrayToHash([
      Variant(props.eax2.Direct),
      Variant(props.eax2.DirectHF),
      Variant(props.eax2.Room),
      Variant(props.eax2.RoomRolloffFactor),
      Variant(props.eax2.Obstruction),
      Variant(props.eax2.ObstructionLFRatio),
      Variant(props.eax2.Occlusion),
      Variant(props.eax2.OcclusionLFRatio),
      Variant(props.eax2.OcclusionRoomRatio),
      Variant(props.eax2.OutsideVolumeHF),
      Variant(props.eax2.AirAbsorptionFactor),
      Variant(props.eax2.Flags)],
      return_value);
    end;
    3: begin
      ArrayToHash([
        Variant(props.eax3.Direct),
        Variant(props.eax3.DirectHF),
        Variant(props.eax3.Room),
        Variant(props.eax3.RoomHF),
        Variant(props.eax3.Obstruction),
        Variant(props.eax3.ObstructionLFRatio),
        Variant(props.eax3.Occlusion),
        Variant(props.eax3.OcclusionLFRatio),
        Variant(props.eax3.OcclusionRoomRatio),
        Variant(props.eax3.OcclusionDirectRatio),
        Variant(props.eax3.Exclusion),
        Variant(props.eax3.ExclusionLFRatio),
        Variant(props.eax3.OutsideVolumeHF),
        Variant(props.eax3.DopplerFactor),
        Variant(props.eax3.RolloffFactor),
        Variant(props.eax3.RoomRolloffFactor),
        Variant(props.eax3.AirAbsorptionFactor),
        Variant(props.eax3.Flags)
      ],
      return_value);
    end;
    end;
   end
   else
   begin
     ZVAL_LONG(return_value, res);
   end;
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;

procedure _SQUALL_Channel_ZOOMFX_SetProperties(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
      pos1, pos2, pos3, pos4: TSoundVec;
      ar1: TArrayVariant;
      props: psquall_zoomfx_channel_t;
begin
  if ht <> 6 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
  if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
    HashToArray(pr[1]^.value.ht, ar1);
    pos1[0] :=  ar1[0];
    pos1[1] :=  ar1[1];
    pos1[2] :=  ar1[2];
    props.Min   := pos1;
    HashToArray(pr[2]^.value.ht, ar1);
    pos2[0] :=  ar1[0];
    pos2[1] :=  ar1[1];
    pos2[2] :=  ar1[2];
    props.Max   := pos2;
    HashToArray(pr[3]^.value.ht, ar1);
    pos3[0] :=  ar1[0];
    pos3[1] :=  ar1[1];
    pos3[2] :=  ar1[2];
    props.Front := pos3;
    HashToArray(pr[4]^.value.ht, ar1);
    pos4[0] :=  ar1[0];
    pos4[1] :=  ar1[1];
    pos4[2] :=  ar1[2];
    props.Top   := pos4;
    props.MacroFX  := pr[5]^.value.lval;

     ZVAL_LONG(return_value,
     SQUALL.SQUALL_Channel_ZOOMFX_SetProperties (
     pr[0]^.value.lval,
     props));
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;

procedure _SQUALL_Channel_ZOOMFX_GetProperties(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
      res: integer;
      var1, var2, var3, var4: TArrayVariant;
      props: squall_zoomfx_channel_t;
begin
  if ht <> 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
    if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     res := SQUALL.SQUALL_Channel_ZOOMFX_GetProperties (
        pr[0]^.value.lval,
        props
        );
     if res >= 0 then
     begin
        var1 := [Variant(props.Min[0]),
                Variant(props.Min[1]),
                Variant(props.Min[2])];
        var2 := [Variant(props.Max[0]),
                Variant(props.Max[1]),
                Variant(props.Max[2])];
        var3 := [Variant(props.Front[0]),
                Variant(props.Front[1]),
                Variant(props.Front[2])];
        var4 := [Variant(props.Top[0]),
                Variant(props.Top[1]),
                Variant(props.Top[2])];
        ArrayToHash(
        [
        Variant( var1 ),
        Variant( var2 ),
        Variant( var3 ),
        Variant( var4 ),
        Variant( props.MacroFX )
        ],
        return_value);
     end
    else
    begin
      ZVAL_LONG(return_value, res);
    end;
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;

procedure _SQUALL_ChannelGroup_Pause(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
begin
  if ht <> 2 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
    if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
     ZVAL_LONG(return_value,
        SQUALL.SQUALL_ChannelGroup_Pause (pr[0]^.value.lval,
        pr[1]^.value.lval
        )
     );
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;

procedure _SQUALL_ChannelGroup_Stop(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
begin
  if ht <> 1 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
    if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
      ZVAL_LONG(return_value,
      SQUALL.SQUALL_ChannelGroup_Stop(pr[0]^.value.lval));
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;

procedure _SQUALL_ChannelGroup_SetVolume(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
begin
  if ht <> 2 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
    if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
      ZVAL_LONG(return_value,
      SQUALL.SQUALL_ChannelGroup_SetVolume(
      pr[0]^.value.lval,
      pr[1]^.value.lval
      ));
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;

procedure _SQUALL_ChannelGroup_SetFrequency(ht : integer; return_value : pzval; return_value_ptr : ppzval; this_ptr : pzval;
   return_value_used : integer; TSRMLS_DC : pointer); cdecl;
var
      pr : pzval_array;
begin
  if ht <> 2 then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;
    if ( not (zend_get_parameters_ex(ht, pr) = SUCCESS )) then begin zend_wrong_param_count(TSRMLS_DC); Exit; end;

   try
      ZVAL_LONG(return_value,
      SQUALL.SQUALL_ChannelGroup_SetFrequency (
      pr[0]^.value.lval,
      pr[1]^.value.lval
      ));
   except ZVAL_FALSE(return_value); end;
    dispose_pzval_array(pr);
end;

var
  moduleEntry : Tzend_module_entry;
  module_entry_table : array[0..85]  of zend_function_entry;


function get_module : Pzend_module_entry; cdecl;
begin
  if not PHPLoaded then
    LoadPHP;

  ModuleEntry.size := sizeOf(Tzend_module_entry);
  ModuleEntry.zend_api := ZEND_MODULE_API_NO;
  ModuleEntry.zend_debug := 0;
  ModuleEntry.zts := USING_ZTS;
  ModuleEntry.name :=  'squall';
  ModuleEntry.functions := nil;
  ModuleEntry.module_startup_func := @minit;
  ModuleEntry.module_shutdown_func := @mshutdown;
  ModuleEntry.request_startup_func := @rinit;
  ModuleEntry.request_shutdown_func := @rshutdown;
  ModuleEntry.info_func := @php_info_module;
  ModuleEntry.version := '2.1';

  ModuleEntry.module_started := 0;
  ModuleEntry._type := MODULE_PERSISTENT;
  ModuleEntry.handle := nil;
  ModuleEntry.module_number := 0;
  {$IFDEF PHP530}
  {$IFNDEF COMPILER_VC9}
  ModuleEntry.build_id := strdup(PAnsiChar(ZEND_MODULE_BUILD_ID));
  {$ELSE}
  ModuleEntry.build_id := DupStr(PAnsiChar(ZEND_MODULE_BUILD_ID));
  {$ENDIF}
  {$ENDIF}

  // подключаем функции...
  Module_entry_table[0].fname := 'SQUALL_Init';
  Module_entry_table[0].handler := @_SQUALL_Init;

  Module_entry_table[1].fname := 'SQUALL_Free';
  Module_entry_table[1].handler := @_SQUALL_Free;

  Module_entry_table[2].fname := 'SQUALL_Sample_LoadFile';
  Module_entry_table[2].handler := @_SQUALL_Sample_LoadFile;

  Module_entry_table[3].fname := 'SQUALL_Sample_Play';
  Module_entry_table[3].handler := @_SQUALL_Sample_Play;

  Module_entry_table[4].fname := 'SQUALL_Sample_Pause';
  Module_entry_table[4].handler := @_SQUALL_Sample_Pause;

  Module_entry_table[5].fname := 'SQUALL_Sample_Unload';
  Module_entry_table[5].handler := @_SQUALL_Sample_Unload;

  Module_entry_table[6].fname := 'SQUALL_Sample_UnloadAll';
  Module_entry_table[6].handler := @_SQUALL_Sample_UnloadAll;

  Module_entry_table[7].fname := 'SQUALL_Sample_GetFileLength';
  Module_entry_table[7].handler := @_SQUALL_Sample_GetFileLength;

  Module_entry_table[8].fname := 'SQUALL_Sample_GetFileLengthMs';
  Module_entry_table[8].handler := @_SQUALL_Sample_GetFileLengthMs;

  Module_entry_table[9].fname := 'SQUALL_Sample_GetFileFrequency';
  Module_entry_table[9].handler := @_SQUALL_Sample_GetFileFrequency;

  Module_entry_table[10].fname := 'SQUALL_Sample_PlayEx';
  Module_entry_table[10].handler := @_SQUALL_Sample_PlayEx;

  Module_entry_table[11].fname := 'SQUALL_Sample_Play3D';
  Module_entry_table[11].handler := @_SQUALL_Sample_Play3D;

  Module_entry_table[12].fname := 'SQUALL_Sample_GetDefault';
  Module_entry_table[12].handler := @_SQUALL_Sample_GetDefault;

  Module_entry_table[13].fname := 'SQUALL_Sample_SetDefault';
  Module_entry_table[13].handler := @_SQUALL_Sample_SetDefault;

  Module_entry_table[14].fname := 'SQUALL_Sample_GetDevice';
  Module_entry_table[14].handler := @_SQUALL_Sample_GetDevice;

  Module_entry_table[15].fname := 'SQUALL_Sample_SetDevice';
  Module_entry_table[15].handler := @_SQUALL_Sample_SetDevice;

  Module_entry_table[16].fname := 'SQUALL_Sample_Play3DEx';
  Module_entry_table[16].handler := @_SQUALL_Sample_Play3DEx;

  Module_entry_table[17].fname := 'SQUALL_Channel_Start';
  Module_entry_table[17].handler := @_SQUALL_Channel_Start;

  Module_entry_table[18].fname   := 'SQUALL_Channel_Pause';
  Module_entry_table[18].handler := @_SQUALL_Channel_Pause;

  Module_entry_table[19].fname   := 'SQUALL_Channel_Stop';
  Module_entry_table[19].handler := @_SQUALL_Channel_Stop;

  Module_entry_table[20].fname   := 'SQUALL_Channel_Status';
  Module_entry_table[20].handler := @_SQUALL_Channel_Status;

  Module_entry_table[21].fname   := 'SQUALL_Channel_SetVolume';
  Module_entry_table[21].handler := @_SQUALL_Channel_SetVolume;

  Module_entry_table[22].fname   := 'SQUALL_Channel_GetVolume';
  Module_entry_table[22].handler := @_SQUALL_Channel_GetVolume;

  Module_entry_table[23].fname   := 'SQUALL_Channel_SetFrequency';
  Module_entry_table[23].handler := @_SQUALL_Channel_SetFrequency;

  Module_entry_table[24].fname   := 'SQUALL_Channel_GetFrequency';
  Module_entry_table[24].handler := @_SQUALL_Channel_GetFrequency;

  Module_entry_table[25].fname   := 'SQUALL_Channel_SetPlayPosition';
  Module_entry_table[25].handler := @_SQUALL_Channel_SetPlayPosition;

  Module_entry_table[26].fname   := 'SQUALL_Channel_GetPlayPosition';
  Module_entry_table[26].handler := @_SQUALL_Channel_GetPlayPosition;

  Module_entry_table[27].fname   := 'SQUALL_Channel_SetPlayPositionMs';
  Module_entry_table[27].handler := @_SQUALL_Channel_SetPlayPositionMs;

  Module_entry_table[28].fname   := 'SQUALL_Channel_GetPlayPositionMs';
  Module_entry_table[28].handler := @_SQUALL_Channel_GetPlayPositionMs;

  Module_entry_table[29].fname   := 'SQUALL_Channel_SetFragment';
  Module_entry_table[29].handler := @_SQUALL_Channel_SetFragment;

  Module_entry_table[30].fname   := 'SQUALL_Channel_GetFragment';
  Module_entry_table[30].handler := @_SQUALL_Channel_GetFragment;

  Module_entry_table[31].fname   := 'SQUALL_Channel_GetFragmentMs';
  Module_entry_table[31].handler := @_SQUALL_Channel_GetFragmentMs;

  Module_entry_table[32].fname   := 'SQUALL_Channel_SetFragmentMs';
  Module_entry_table[32].handler := @_SQUALL_Channel_SetFragmentMs;

  Module_entry_table[33].fname   := 'SQUALL_Channel_GetLength';
  Module_entry_table[33].handler := @_SQUALL_Channel_GetLength;

  Module_entry_table[34].fname   := 'SQUALL_Channel_GetLengthMs';
  Module_entry_table[34].handler := @_SQUALL_Channel_GetLengthMs;

  Module_entry_table[35].fname   := 'SQUALL_Channel_SetPriority';
  Module_entry_table[35].handler := @_SQUALL_Channel_SetPriority;

  Module_entry_table[36].fname   := 'SQUALL_Channel_GetPriority';
  Module_entry_table[36].handler := @_SQUALL_Channel_GetPriority;

  Module_entry_table[37].fname   := 'SQUALL_Channel_SetLoop';
  Module_entry_table[37].handler := @_SQUALL_Channel_SetLoop;

  Module_entry_table[38].fname   := 'SQUALL_Channel_GetLoop';
  Module_entry_table[38].handler := @_SQUALL_Channel_GetLoop;

  Module_entry_table[39].fname   := 'SQUALL_Channel_SetPan';
  Module_entry_table[39].handler := @_SQUALL_Channel_SetPan;

  Module_entry_table[40].fname   := 'SQUALL_Channel_GetPan';
  Module_entry_table[40].handler := @_SQUALL_Channel_GetPan;

  Module_entry_table[41].fname   := 'SQUALL_SetHardwareAcceleration';
  Module_entry_table[41].handler := @_SQUALL_SetHardwareAcceleration;

  Module_entry_table[42].fname   := 'SQUALL_GetHardwareAcceleration';
  Module_entry_table[42].handler := @_SQUALL_GetHardwareAcceleration;

  Module_entry_table[43].fname   := 'SQUALL_SetSpeakerMode';
  Module_entry_table[43].handler := @_SQUALL_SetSpeakerMode;

  Module_entry_table[44].fname   := 'SQUALL_GetSpeakerMode';
  Module_entry_table[44].handler := @_SQUALL_GetSpeakerMode;

  Module_entry_table[45].fname   := 'SQUALL_Set3DAlgorithm';
  Module_entry_table[45].handler := @_SQUALL_Set3DAlgorithm;

  Module_entry_table[46].fname   := 'SQUALL_Get3DAlgorithm';
  Module_entry_table[46].handler := @_SQUALL_Get3DAlgorithm;

  Module_entry_table[47].fname   := 'SQUALL_SetBufferSize';
  Module_entry_table[47].handler := @_SQUALL_SetBufferSize;

  Module_entry_table[48].fname   := 'SQUALL_GetBufferSize';
  Module_entry_table[48].handler := @_SQUALL_GetBufferSize;

  Module_entry_table[49].fname   := 'SQUALL_GetDeviceCaps';
  Module_entry_table[49].handler := @_SQUALL_GetDeviceCaps;

  Module_entry_table[50].fname   := 'SQUALL_GetDeviceName';
  Module_entry_table[50].handler := @_SQUALL_GetDeviceName;

  Module_entry_table[51].fname   := 'SQUALL_GetEAXVersion';
  Module_entry_table[51].handler := @_SQUALL_GetEAXVersion;

  Module_entry_table[52].fname   := 'SQUALL_GetChannelsInfo';
  Module_entry_table[52].handler := @_SQUALL_GetChannelsInfo;

  Module_entry_table[53].fname   := 'SQUALL_Listener_SetParameters';
  Module_entry_table[53].handler := @_SQUALL_Listener_SetParameters;

  Module_entry_table[54].fname   := 'SQUALL_Listener_GetParameters';
  Module_entry_table[54].handler := @_SQUALL_Listener_GetParameters;

  Module_entry_table[55].fname   := 'SQUALL_Listener_SetVelocity';
  Module_entry_table[55].handler := @_SQUALL_Listener_SetVelocity;

  Module_entry_table[56].fname   := 'SQUALL_Listener_GetVelocity';
  Module_entry_table[56].handler := @_SQUALL_Listener_GetVelocity;

  Module_entry_table[57].fname   := 'SQUALL_Listener_SetPosition';
  Module_entry_table[57].handler := @_SQUALL_Listener_SetPosition;

  Module_entry_table[58].fname   := 'SQUALL_Listener_GetPosition';
  Module_entry_table[58].handler := @_SQUALL_Listener_GetPosition;

  Module_entry_table[59].fname   := 'SQUALL_Listener_SetDistanceFactor';
  Module_entry_table[59].handler := @_SQUALL_Listener_SetDistanceFactor;

  Module_entry_table[60].fname   := 'SQUALL_Listener_GetDistanceFactor';
  Module_entry_table[60].handler := @_SQUALL_Listener_GetDistanceFactor;

  Module_entry_table[61].fname   := 'SQUALL_Listener_SetRolloffFactor';
  Module_entry_table[61].handler := @_SQUALL_Listener_SetFrolovFactor;

  Module_entry_table[62].fname   := 'SQUALL_Listener_GetRolloffFactor';
  Module_entry_table[62].handler := @_SQUALL_Listener_GetFrolovFactor;

  Module_entry_table[63].fname   := 'SQUALL_Listener_SetDopplerFactor';
  Module_entry_table[63].handler := @_SQUALL_Listener_SetDopplerFactor;

  Module_entry_table[64].fname   := 'SQUALL_Listener_GetDopplerFactor';
  Module_entry_table[64].handler := @_SQUALL_Listener_GetDopplerFactor;

  Module_entry_table[65].fname   := 'SQUALL_Listener_Update';
  Module_entry_table[65].handler := @_SQUALL_Listener_Update;

  Module_entry_table[66].fname   := 'SQUALL_Listener_EAX_SetPreset';
  Module_entry_table[66].handler := @_SQUALL_Listener_EAX_SetPreset;

  Module_entry_table[67].fname   := 'SQUALL_Listener_EAX_SetProperties';
  Module_entry_table[67].handler := @_SQUALL_Listener_EAX_SetProperties;

  Module_entry_table[68].fname   := 'SQUALL_Listener_EAX_GetProperties';
  Module_entry_table[68].handler := @_SQUALL_Listener_EAX_GetProperties;

  Module_entry_table[69].fname   := 'SQUALL_Channel_Set3DPosition';
  Module_entry_table[69].handler := @_SQUALL_Channel_Set3DPosition;

  Module_entry_table[70].fname   := 'SQUALL_Channel_Get3DPosition';
  Module_entry_table[70].handler := @_SQUALL_Channel_Get3DPosition;

  Module_entry_table[71].fname   := 'SQUALL_Channel_SetVelocity';
  Module_entry_table[71].handler := @_SQUALL_Channel_SetVelocity;

  Module_entry_table[72].fname   := 'SQUALL_Channel_GetVelocity';
  Module_entry_table[72].handler := @_SQUALL_Channel_GetVelocity;

  Module_entry_table[73].fname   := 'SQUALL_Channel_SetMinMaxDistance';
  Module_entry_table[73].handler := @_SQUALL_Channel_SetMinMaxDistance;

  Module_entry_table[74].fname   := 'SQUALL_Channel_GetMinMaxDistance';
  Module_entry_table[74].handler := @_SQUALL_Channel_GetMinMaxDistance;

  Module_entry_table[75].fname   := 'SQUALL_Channel_SetConeParameters';
  Module_entry_table[75].handler := @_SQUALL_Channel_SetConeParameters;

  Module_entry_table[76].fname   := 'SQUALL_Channel_GetConeParameters';
  Module_entry_table[76].handler := @_SQUALL_Channel_GetConeParameters;

  Module_entry_table[77].fname   := 'SQUALL_Channel_EAX_SetProperties';
  Module_entry_table[77].handler := @_SQUALL_Channel_EAX_SetProperties;

  Module_entry_table[78].fname   := 'SQUALL_Channel_EAX_GetProperties';
  Module_entry_table[78].handler := @_SQUALL_Channel_EAX_GetProperties;

  Module_entry_table[79].fname   := 'SQUALL_Channel_ZOOMFX_SetProperties';
  Module_entry_table[79].handler := @_SQUALL_Channel_ZOOMFX_SetProperties;

  Module_entry_table[80].fname   := 'SQUALL_Channel_ZOOMFX_GetProperties';
  Module_entry_table[80].handler := @_SQUALL_Channel_ZOOMFX_GetProperties;

  Module_entry_table[81].fname   := 'SQUALL_ChannelGroup_Pause';
  Module_entry_table[81].handler := @_SQUALL_ChannelGroup_Pause;

  Module_entry_table[82].fname   := 'SQUALL_ChannelGroup_Stop';
  Module_entry_table[82].handler := @_SQUALL_ChannelGroup_Stop;

  Module_entry_table[83].fname   := 'SQUALL_ChannelGroup_SetVolume';
  Module_entry_table[83].handler := @_SQUALL_ChannelGroup_SetVolume;

  Module_entry_table[84].fname   := 'SQUALL_ChannelGroup_SetFrequency';
  Module_entry_table[84].handler := @_SQUALL_ChannelGroup_SetFrequency;

  Module_entry_table[85].fname   := 'SQUALL_GetNumDevice';
  Module_entry_table[85].handler := @_SQUALL_GetNumDevice;

  ModuleEntry.functions :=  @module_entry_table[0];
  ModuleEntry._type := MODULE_PERSISTENT;
  Result := @ModuleEntry;
end;



exports
  get_module;

end.
