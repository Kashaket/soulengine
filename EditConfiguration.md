1) Конфигурация построения - Release
2) Установлены компоненты: TSynEdit for 101B (Delphi 10.1 Berlin update 2)
3) Разрядность построения:
	SoulEngine - x32bit
	Synedit - x32bit (SourcePackage), x64bit (Designtime Package, Design Editor)
	PHP4Delphi - x32bit
	
4) Исправления
Ваша папка Delphi\Embarcadero\Studio\(версия Component Kit, у меня - 18.0)\source\rtl\sys\System.pas
Исправлена строчка:
TTypeKind = (tkUnknown, tkInteger, tkChar, tkEnumeration, tkFloat, tkString,
    tkSet, tkClass, tkMethod, tkSString, tkLString, tkAString,
    tkWString, tkVariant, tkArray, tkRecord, tkInterface,
    tkObject, tkWChar, tkBool, tkInt64, tkQWord,
    tkDynArray, tkInterfaceRaw, tkProcVar, tkUString, tkUChar);
TTypeKind = {tkUnknown, tkInteger, tkChar, tkEnumeration, tkFloat,
    tkString, tkSet, tkClass, tkMethod, tkWChar, tkLString, tkWString,
    tkVariant, tkArray, tkRecord, tkInterface, tkInt64, tkDynArray, tkUString,
    tkClassRef, tkPointer, tkProcedure}