### SoulEngine

GUI Tool kit for PHP and DevelStudio.

## EN
### Information
This version of SoulEngine is partially compatible with DevelStudio 3.0.2Beta and fully compatible with <a href="https://github.com/KashaketCompany/DevelStudio-3.0-beta">DevelStudio (3.0.4)</a> - <a href="https://github.com/KashaketCompany/DevelStudio-3.0-beta">DevelStudio Ke</a> (3.4)
<br>P.s Sorry for bicycles and so unclean code, but, if you look at the code i started from, you'll want to beat up Dim-S, whose code is worse than my.

#### Compiling

1. Install php4delphi, synedit and CEF4Delphi Packages from the project's dir
2. Open project file (SoulEngine.dpr or SoulEngine.dproj either)
3. Compile project, the output binaries will be in the `C:\DevelStudio 3.0Beta\`.

If you see error when running binaries, rather components 
installed uncorrectly or DevelStudio 3.0.4 
installation doesn't exist in 
final(end-point) build directory `C:\DevelStudio 3.0Beta\`


#### Additional extensions

Extensions with all included info located at the `ext/` directory.
Copyright on php_wincall, php_TWinTaskBar, php_skins points to Nyashik (Nyasik, http://github.com/Nyasik)

#### Credits and copyright
Rewrited by: Kashaket (Andrew Zenin, Artem Ukolov)
<br>Decompiled by: Nyashik, Hunting Kashket (Andrew Zenin)
1) Add license for base packages: PHP4Delphi, tb2k, CEF

2) Add license for the engine code (optional)

### Using conditionals
(in sDef.inc)
1) ADD_SYN - add Synedit to the build

   ADD_SYN_OPT - add additional SynEdit Highlighters Set
2) ADD_CHROMIUM - add CEF (Chromium Embedded Framework 69)
3) PHP560 - add PHP 5.6 up support
4) ADD_RYM - add styled menus (Rays Menues)

## RU
#### Информация

Данная версия SoulEngine частично совместима с DevelStudio (3.0.2),
Полная совместимость только с <a href="https://github.com/KashaketCompany/DevelStudio-3.0-beta">DevelStudio (3.0.4)</a> - <a href="https://github.com/KashaketCompany/DevelStudio-3.0-beta">DevelStudio Ke</a> (3.4).

Процент совместимости составляет 92 балла (движок совместим на 92%).

#### Сборка

1. Установить пакеты php4delphi, synedit и AlphaControls из папки проекта
2. Открыть файл проекта soulEngine.dpr в Delphi XE6+
3. Собрать проект, бинарники попадут в папку `C:\DevelStudio 3.0Beta\`.

Если при запуске exe будет выдаваться ошибка, скорее
всего компоненты были некорректно установлены, или же в папке `C:\DevelStudio 3.0Beta\`
отсутствует инсталляция DevelStudio 3.0.3.


#### Дополнительные расширения

Расширения со всей сопутствующей информацией находятся в папке `ext/`
Авторские права на php_wincall, php_TWinTaskBar, php_skins принадлежат Nyashik (Nyasik, http://github.com/Nyasik)

#### Краткие требования лицензии
Переписали движок: Kashaket (Andrew Zenin, Artem Ukolov)
<br>Декомпилировали движок: Nyashik(Nyasik), Hunting Kashket(Andrew Zenin)

1) Указать лицензию на все сопутствующие компоненты - PHP4Delphi, tb2k, CEF

2) Указать лицензию на данный пакет (опционально)

### Использование значение (в sDef.inc)
1) ADD_SYN - добавлять SynEdit

   ADD_SYN_OPT - добавлять набор подсветок SynEdit
3) ADD_CHROMIUM - добавлять CEF
3) PHP560 - добавлять поддержку PHP 5.6 и выше
4) ADD_RYM - добавлять стильные меню (Rays Menues)
