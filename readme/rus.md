## RU
#### Сборка
1. Установить пакеты php4delphi, synedit и AlphaControls из папки проекта
2. Открыть файл проекта soulEngine.dpr в Delphi XE6+
3. Собрать проект, бинарники попадут в папку `C:\DevelStudio 3.0Beta\`.

Если при запуске exe будет выдаваться ошибка, скорее
всего компоненты были некорректно установлены, или же в папке `C:\DevelStudio 3.0Beta\`
отсутствует инсталляция <a href="https://github.com/KashaketCompany/DevelStudio-3.0-beta">DevelStudio</a>.

#### Дополнительные расширения
Расширения со всей сопутствующей информацией находятся в папке `ext/`

#### Лицензия и авторство
Переписали движок: Kashaket (Andrew Zenin, Artem Ukolov)
<br>Декомпилировали движок: Nyashik(Nyasik), Hunting Kashket(Andrew Zenin)
<br>Авторские права на php_wincall, php_TWinTaskBar, php_skins принадлежат Nyashik (Nyasik, http://github.com/Nyasik)

Требования к лицензии:
1) Указать лицензию на все сопутствующие компоненты - PHP4Delphi, tb2k, CEF
2) Указать лицензию на данный пакет (опционально)

Обновлённые пакеты компонентов:
1) PHP4Delphi обновление до php 5.6 - Anrew Zenin
2) TB2k исправление фатальной ошибки - Artem Ukolov
3) DCEF исправление загрузки и панелей - Andrew Zenin
4) Captioned Dock Tree накопительное обновление - Andrew Zenin
5) GIFImage адаптация под Delphi 2010+ - Andrew Zenin
6) EXEMod переписан Andrew Zenin
7) uNonVisual исправление прорисовки - Andrew Zenin, Artem Ukolov
8) CategoryButtons накопительное обновление - Andrew Zenin

#### Использование значений
(в sDef.inc)
1) ADD_SYN - добавлять SynEdit

   ADD_SYN_OPT - добавлять набор подсветок SynEdit
3) ADD_CHROMIUM - добавлять CEF
3) PHP560 - добавлять поддержку PHP 5.6 и выше
4) PHP_Unice - add partial unicode support
