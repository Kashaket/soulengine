### SoulEngine

GUI Tool kit for PHP and DevelStudio.

#### Инструкции

Данная версия SoulEngine не совместима с DevelStudio (3.0.2),
Только с <a href="https://github.com/KashaketCompany/DevelStudio-3.0-beta">DevelStudio (3.0.4)</a> - <a href="https://github.com/KashaketCompany/DevelStudio-3.0-beta">DevelStudio Ke</a> (3.4).

Процент совместимости составляет 92 балла (движок совместим на 92%).

#### Сборка

1. Установить пакеты php4delphi, synedit и AlphaControls из папки проекта
2. Открыть файл проекта soulEngine.dpr в Delphi XE6+
3. Собрать проект, бинарники попадут в папку `C:\DevelStudio 3.0Beta\`.

Если при запуске exe будет выдаваться ошибка, скорее
всего компоненты были некорректно установлены, или же в папке `C:\DevelStudio 3.0Beta\`
отсутствует инсталляция DevelStudio 3.0.3.


#### Дополнительные расширения

В папке `ext/` находятся исходники расширений, которые
используются в DevelStudio. Чтобы их собрать, необходимо
прописать путь к исходникам php4delphi в настройках
среды или проекта.

#### Краткие требования лицензии
1. Указать авторство
2. Использовать на своё усмотрение, не продавая проекты, если они использует/ют движок в чистом виде
3. Указать лицензионный файл LICENSE

Варианты указания авторства:
1) Указать данный репозиторий в Github или пользователя <a href="https://github.com/NyaSik">Nyasik</a> или пользователя <a href="https://github.com/Kashaket">Kashaket</a>
2) Указать данный репозиторий в Github и состав членов команды <a href="https://github.com/KashaketCompany">Kashaket</a>
3) Указать данный репозиторий в Github и <a href="https://github.com/KashaketCompany/DevelStudio-3.0-beta">репозиторий</a> <a href="https://github.com/KashaketCompany/DevelStudio-3.0-beta">студии</a>
4) Упомянуть создателей элементов студии - Nyashik, 3rd party license(s), Kashaket, KurandX, Armen Productions, Dim-S.

### Использование значение (в sDef.inc)
1) ADD_SYN - добавлять SynEdit

   ADD_SYN_OPT - добавлять набор подсветок SynEdit
2) ADD_AC, ADD_SKINS - добавлять AlphaControls
3) ADD_CHROMIUM - добавлять CEF
4) PHP540 - добавлять поддержку PHP 5.4.0
5) ADD_RYM - добавлять стильные меню (Rays Menues)
