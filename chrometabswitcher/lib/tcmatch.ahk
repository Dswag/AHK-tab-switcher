; tcmatch.ahk: QuickSearch eXtended GUI for Total Commander 7.5+
  Version=2.2.7
; by Samuel Plentz

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - init the script
#SingleInstance force
#Persistent
#NoTrayIcon
#NoEnv
SetBatchLines,-1
SetKeyDelay,-1
DetectHiddenWindows,On
OnMessage(0x06 ,"WM_ACTIVATE")
OnMessage(0x200,"WM_MOUSEOVER")
isWinActive=0
QSvisible=0
QSDelay=0
wdx32_64=wdx
x32_64=
if(A_PtrSize==8){
	wdx32_64=wdx64
 x32_64=64
}


; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - use 16x16 and 32x32 program icon
if(A_IsCompiled){
 hModule:=DllCall("GetModuleHandle",Str,A_ScriptFullPath)
 Icon16:=DllCall("LoadImageW",UInt,hModule,UInt,              159,UInt,IMAGE_ICON:=0x1,Int,16,Int,16,UInt,LR_SHARED      :=0x8000)
 Icon32:=DllCall("LoadImageW",UInt,hModule,UInt,              159,UInt,IMAGE_ICON:=0x1,Int,32,Int,32,UInt,LR_SHARED      :=0x8000)
}else{
 Icon16:=DllCall("LoadImageW",UInt,      0, Str,"tcmatch.ahk.ico",UInt,IMAGE_ICON:=0x1,Int,16,Int,16,UInt,LR_LOADFROMFILE:=0x10)
 Icon32:=DllCall("LoadImageW",UInt,      0, Str,"tcmatch.ahk.ico",UInt,IMAGE_ICON:=0x1,Int,32,Int,32,UInt,LR_LOADFROMFILE:=0x10)
}
Gui 2:Default
Gui,+LastFound
SendMessage,WM_SETICON:=0x80,ICON_SMALL:=0x0,Icon16
SendMessage,WM_SETICON:=0x80,ICON_BIG  :=0x1,Icon32
Gui 3:Default
Gui,+LastFound
SendMessage,WM_SETICON:=0x80,ICON_SMALL:=0x0,Icon16
SendMessage,WM_SETICON:=0x80,ICON_BIG  :=0x1,Icon32

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - load language strings
; #Language
LanguageStrings2=
(
 0,English                                                    
 1,Simple search                                              
 2,RegEx search                                               
 3,Similarity search                                          
 4,Srch                                                       
 5,<Presets>                                                  
 6,General                                                    
 7,Change syntax                                              
 8,Presets                                                    
 9,Replacement rules                                          
10,Search options                                             
11,Match only at beginning of files/words                     
12,Case sensitive                                             
13,"Allow input, leading to empty results (TC restart needed)"
14,Filter files                                               
15,Filter folders                                             
16,Use PinYin (for Chinese users)                             
17,Additional user interface                                  
18,Activate                                                   
19,Show in one row                                            
20,Activation chars for search modes                          
21,Change                                                     
22,Char for simple search                                     
23,Char for simple search with match only at beginning        
24,Char for RegEx                                             
25,Char for similarity search                                 
26,Char for srch                                              
27,Other chars                                                
28,And separator char                                         
29,Or separator char                                          
30,Negate char                                                
31,Activation char for presets                                
32,Content plugin separator char                              
33,New char                                                   
34,Please enter a new char:                                   
35,Confirm                                                    
36,Char:                                                      
37,Preset string:                                             
38,Add                                                        
39,Preset list:                                               
40,Chars to replace:                                          
41,New text:                                                  
42,Replacement rules:                                         
43,Show help                                                  
44,Helpfile not found                                         
45,Helpfile was not found in this path:                       
46,Show presets                                               
47,Select language: (TC restart needed)                       
48,Content plugins                                            
49,Choose content plugin file:                                
50,Fields of the content plugin:                              
51,Choose group:                                              
52,update                                                     
53,Content plugin list:                                       
54,Extended Options                                           
55,Logfile: (slows down the search)                           
56,disabled                                                   
57,create only for errors                                     
58,log the values of content plugin                           
59,log all function calls                                     
60,Size of cache: (Number of Files)                           
61,Invert the result                                          
62,Quick Search eXtended - configuration                      
63,Use lead syllable search (for Korean users)                
)

LanguageStrings3=
(
 0,Deutsch (German)                                                      
 1,einfache Suche                                                        
 2,RegEx Suche                                                           
 3,Ähnlichkeitssuche                                                     
 4,Srch                                                                  
 5,<Favoriten>                                                           
 6,Allgemein                                                             
 7,Suchsyntax ändern                                                     
 8,Favoriten                                                             
 9,Ersetzungsregeln                                                      
10,Suchoptionen                                                          
11,Übereinstimmung nur am Datei-/Wortanfang                              
12,Groß-/Kleinschreibung beachten                                        
13,"Eingaben erlauben, die zu keinem Ergebnis führen (TC-Neustart nötig)"
14,Dateien filtern                                                       
15,Ordner filtern                                                        
16,PinYin verwenden (für chinesische Anwender)                           
17,ergänzende Benutzeroberfläche                                         
18,aktivieren                                                            
19,einzeilig anzeigen                                                    
20,Zeichen die Suchmodi aktivieren                                       
21,ändern                                                                
22,Zeichen für die einfache Suche                                        
23,Zeichen für die einfache Suche mit Übereinstimmung am Anfang          
24,Zeichen für die RegEx Suche                                           
25,Zeichen für die Ähnlichkeitssuche                                     
26,Zeichen für die Srch                                                  
27,sonstige Zeichen                                                      
28,Und Trennzeichen                                                      
29,Oder Trennzeichen                                                     
30,Negationszeichen                                                      
31,Favoriten Aktivierungszeichen                                         
32,Inhaltsplugins Trennzeichen                                           
33,neues Zeichen                                                         
34,Bitte ein neues Zeichen eingeben:                                     
35,übernehmen                                                            
36,Zeichen:                                                             
37,Favoritensuchstring:                                                 
38,hinzufügen                                                           
39,Favoritenliste:                                                      
40,zu ersetzende Zeichen:                                               
41,Ersetzungstext:                                                      
42,Ersetzungsliste:                                                     
43,Hilfe anzeigen                                                       
44,Hilfedatei nicht gefunden                                            
45,Die Hilfedatei wurde unter folgendem Pfad nicht gefunden:            
46,Favoriten anzeigen                                                   
47,Sprache auswählen: (TC-Neustart nötig)                               
48,Inhaltsplugins                                                       
49,Inhaltsplugin-Datei auswählen:                                       
50,Felder des Inhaltsplugins:                                           
51,Gruppe wählen:                                                       
52,ändern                                                               
53,Inhaltsplugin-Liste:                                                 
54,erweiterte Einstellungen                                             
55,Logdatei: (verlangsamt die Suche)                                    
56,deaktiviert                                                          
57,nur bei Fehlern erstellen                                            
58,Werte der Inhaltsplugins loggen                                      
59,alle Funktionsaufrufe loggen                                         
60,Größe des Cache: (Dateianzahl)                                       
61,invertiere das Ergebnis                                              
62,Quick Search eXtended - Einstellungen                                
63,führende Silbensuche verwenden (für koreanische Anwender)            
)

LanguageStrings4=
(
 0,Español (Spanish)                                                   
 1,Búsqueda simple                                                     
 2,Buscar RegExp                                                       
 3,Buscar similaridad                                                  
 4,Buscar                                                              
 5,<Predefinidos>                                                      
 6,General								                                                     
 7,Cambiar sintaxis                                                    
 8,Predefinidos                                                        
 9,Reglas de reemplazo                                                 
10,Opciones de búsqueda                                                
11,Sólo coincidentes al inicio de archivos/palabras                    
12,Sensible a mayúsculas y minúsculas                                  
13,"Permitir entrada, llevar a resultados vacíos (Debe reiniciar TC)"  
14,Filtrar archivos                                                    
15,Filtrar carpetas                                                    
16,Usar PinYin (para usuarios chinos)                                  
17,Opciones adicionales de interfaz de usuario                         
18,Activar                                                             
19,Mostrar en una fila                                                 
20,Caracteres de activación para modos de búsqueda                     
21,Cambiar                                                             
22,Caracter para búsqueda simple                                       
23,Caracter para búsqueda simple coincidencte sólo al inicio           
24,Caracter para buscar expresiones regulares                          
25,Caracter para buscar similaridades                                  
26,Caracter para buscar                                                
27,Otros caracteres                                                    
28,Caracter separador Y                                                
29,Caracter separador O                                                
30,Caracter de negación                                              
31,Caracter de activación para predefinidos                          
32,Caracter separador para plugin de contenido                       
33,Nuevo caracter                                                    
34,Por favor introduzca un nuevo caracter                            
35,Confirmar                                                         
36,Caracter:                                                         
37,Cadena predefinida:                                               
38,Añadir                                                            
39,Lista de predefinidos:                                            
40,Caracteres a reemplazar:                                          
41,Texto nuevo:                                                      
42,Reglas de reemplazo:                                              
43,Mostrar ayuda                                                     
44,Archivo de ayuda no encontrado                                         
45,No se encontró el archivo de ayuda en esta ruta:                       
46,Mostrar predefinidos                                                   
47,Seleccionar idioma: (Debe reiniciar TC)                                
48,Plugins de contenido                                                   
49,Escoja el archivo del plugin de contenido:                             
50,Campos plugin de contenido:                                            
51,Escoger grupo:                                                         
52,Actualizar                                                             
53,Lista de plugins de contenido:                                         
54,Opciones extendidas                                                    
55,Archivo de registro: (Búsqueda lenta)                                  
56,deshabilitado                                                          
57,sólo crear para errores                                                
58,valores de plugin de contenido                                         
59,todas las llamadas a funciones                                         
60,Tamaño de caché: (Nº de archivos)                                      
61,Invertir el resultado                                                  
62,Búsqueda rápida extendida - Configuración                              
63,Usar búsqueda de sílabas pistas (para usuarios coreanos)               
)

LanguageStrings5=
(
 0,Magyar (Hungarian)                                                                
 1,Egyszerű keresés                                                                  
 2,RegEx keresés                                                                     
 3,Hasonlóság alapú keresés                                                          
 4,Krs                                                                               
 5,<Sablonok>                                                                        
 6,Általános                                                                         
 7,Szintaxis módosítása                                                              
 8,Sablonok                                                                          
 9,Helyettesítési szabályok                                                          
10,Keresési opciók                                                                   
11,Egyezőség csak a fájlok/szavak elején                                             
12,Kis- és nagybetű érzékenység                                                      
13,"Üres listát eredményező bemeneti adatok engedélyezése (TC újraindítás szükséges)"
14,Fájlok szűrése                                                                    
15,Mappák szűrése                                                                    
16,PinYin használata (kínai felhasználók számára)                                    
17,Kiegészítő felhasználói felület                                                   
18,Aktiválás                                                                         
19,Kijelzés egy sorban                                                               
20,A keresési módok aktiváló karakterei                                              
21,Módosítás                                                                         
22,Karakter egyszerű kereséshez                                                      
23,Karakter egyszerű kereséshez csak az elején történő egyezőséghez                  
24,Karakter RegEx kereséshez                                                         
25,Karakter hasonlóság alapú kereséshez                                              
26,Karakter kereséshez                                                               
27,További karakterek                                                                
28,ÉS elválasztó karakter                                                            
29,VAGY elválasztó karakter                                                          
30,Tagadó karakter                                                                   
31,Sablonok aktiváló karaktere                                                       
32,Tartalom beépülő elválasztó karakter                                              
33,Új karakter                                                                       
34,"Kérlek, írj be egy új karaktert:"                                                
35,Megerősítés                                                                       
36,Karakter:                                                                         
37,Sablon szöveg:                                                                    
38,Hozzáadás                                                                         
39,Sablonlista:                                                                      
40,Helyettesítendő karakterek:                                                       
41,Új szöveg:                                                                        
42,Helyettesítési szabályok:                                                         
43,Súgó megnyitása                                                                   
44,A súgófájl nem található                                                          
45,A súgófájl nem található a következő elérési úton:                                
46,Sablonok mutatása                                                                 
47,Válassz nyelvet: (TC újraindítás szükséges)                                       
48,Tartalom beépülők                                                                 
49,Válassz tartalom beépülő fájlt:                                                   
50,A tartalom beépülő mezői:                                                         
51,Válassz csoportot:                                                                
52,frissítés                                                                         
53,Tartalom beépülő lista:                                                           
54,További beállítások                                                               
55,Naplófájl: (lelassítja a keresést)                                                
56,kikapcsolva                                                                       
57,kizárólag hibákhoz készítsen                                                      
58,a tartalom beépülő értékeinek naplózása                                           
59,minden funkcióhívás naplózása                                                     
60,Gyorsítótár mérete: (Fájlok száma)                                                
61,Találatok invertálása                                                             
62,Quick Search eXtended - Konfiguráció                                              
63,Vezető szótag keresés használata (koreai felhasználók számára)                    
)

LanguageStrings6=
(
 0,Polski (Polish)                                                         
 1,proste wyszukiwanie                                                     
 2,RegEx szukanie                                                          
 3,Szukanie podobieństwa                                                   
 4,Szuk                                                                    
 5,<Ulubione>                                                              
 6,Ogólny                                                                  
 7,Zmień składnię                                                          
 8,Ulubione                                                                
 9,Zasady zamienne                                                         
10,Opcje szukania                                                          
11,Pasujące tylko na początku pliki / słowa                                
12,Wielkość liter                                                          
13,"Pozwól na wejście, co prowadzi do pustych wyników (TC ponowny restart)"
14,Filtrowanie plików                                                      
15,Filtrowanie folderów                                                    
16,Użyj PinYin (dla chińskich użytkowników)                                
17,Dodatkowy interfejs użytkownika                                         
18,Aktywować                                                               
19,Pokaż w jednym rzędzie                                                  
20,Znaki aktywowania dla trybów wyszukiwania                               
21,Zmiana                                                                  
22,Znak dla prostego wyszukiwania                                          
23,Znak proste wyszukiwanie z meczu tylko na początku                      
24,Znak dla RegEx                                                          
25,Znak dla szukanego podobieństwa                                         
26,Znak dla srch                                                           
27,Inny znak                                                               
28,Dodaj znak seperacji                                                    
29,lub znak separatora                                                     
30,Znak negacji                                                            
31,Aktywacja char dla ustawień                                             
32,Content plugin separator char                                           
33,Nowy Znak                                                               
34,Proszę enter dla nowego Znaku:                                          
35,Potwierdź                                                               
36,Znak:                                                                   
37,Ustawienie ciągu:                                                       
38,Dodaj                                                                   
39,Preset list:                                                            
40,Znaki do zmiany:                                                        
41,Nowy tekst:                                                             
42,Zasady zmiany:                                                          
43,Pokaż help                                                              
44,Plik pomocy niedostępny                                                 
45,HelpFile nie znaleziono w tej ścieżce:                                  
46,pokaż ustawienia                                                        
47,Wybór języka: (TC ponowny restart)                                      
48,Zawartość wtyczek                                                       
49,Wybierz plik treści wtyczki:                                            
50,Obszary zawartości wtyczki:                                             
51,Wybierz grupę:                                                          
52,aktualizować                                                            
53,Zawartość listy wtyczek:                                                
54,Extended Options                                                        
55,Logfile: (spowalnia wyszukiwanie)                                       
56,wyłączony                                                               
57,stworzyć tylko dla błędów                                               
58,log wartości zawartości wtyczki                                         
59,log wszystkie wywołania funkcji                                         
60,Rozmiar pamięci podręcznej: (Liczba plików)                             
61,Odwróć wynik                                                            
62,Szybkie szukanie eXtended - konfiguracja                                
63,Użyj prowadzić sylabę wyszukiwanie (dla Koreańczyków)                   
)

LanguageStrings7=
(
 0,Українська (Ukrainian)                                                 
 1,Простий пошук                                                          
 2,RegEx пошук                                                            
 3,Пошук схожості                                                         
 4,Пошук                                                                  
 5,<Пресети>                                                              
 6,Загальні                                                               
 7,Змінити синтаксис                                                      
 8,Пресеты                                                                
 9,Правила заміни                                                         
10,Опції пошуку                                                           
11,Збіг тільки з початку файлів/слів                                      
12,З урахуванням регістру                                                 
13,"Допускати введення з порожніми результатами (необходим перезапуск TC)"
14,Фільтрація файлів                                                      
15,Фільтрація каталогів                                                   
16,Використовувати PinYin (для китайозів)                                 
17,Розширений інтерфейс                                                   
18,Активувати                                                             
19,Показати в один ряд                                                    
20,Активація символів для режимів пошуку                                  
21,Змінити                                                                
22,Символи для простого пошуку                                            
23,Символи для простого пошуку зі збігом початку слів                     
24,Символи для пошуку RegEx                                               
25,Символи для пошуку схожості                                            
26,Символи для пошуку                                                     
27,Інші символи                                                           
28,Додати сепаратор                                                       
29,Або сепаратор                                                          
30,Заперечення символів                                                   
31,Активація символу для пресету                                          
32,Контентний плаґін сепаратор                                            
33,Новий символ                                                           
34,Введіть новий символ:                                                  
35,Підтвердження                                                          
36,Символ:                                                                
37,Рядок пресету:                                                         
38,Додати                                                                 
39,Список пресетів:                                                       
40,Символи для заміни:                                                    
41,Новий текст:                                                           
42,Правила заміни:                                                        
43,Показати довідку                                                       
44,Довідку не знайдено                                                    
45,Довідку не знайдено за цим шляхом:                                     
46,Показати пресети                                                       
47,Мова: (необхідний перезапуск TC)                                       
48,Контентні плаґіни                                                      
49,Оберіть файл контентного плаґіна:                                      
50,Поля контентного плаґіна:                                              
51,Вибір групи                                                            
52,оновити                                                                
53,Контентні плаґіни:                                                     
54,Розширені опції                                                        
55,Log-файл: (уповільнює пошук)                                           
56,не створювати                                                          
57,створювати тільки для помилок                                          
58,log значень плаґіна                                                    
59,log всіх функцій                                                       
60,Розмір кешу: (Кількість файлів)                                        
61,Інверсія результату                                                    
62,Quick Search eXtended - конфігурація                                   
63,Пошук по складах (для вузькоглазеньких корейців)                       
)

LanguageStrings8=
(
 0,Pусский (Russian)                                                
 1,Простой поиск                                                    
 2,RegEx поиск                                                      
 3,Поиск подобного                                                  
 4,Поиск                                                            
 5,<Пресеты>                                                        
 6,Общие                                                            
 7,Изменить синтаксис                                               
 8,Пресеты                                                          
 9,Правила замены                                                   
10,Опции поиска                                                     
11,Совпадение только с начала файлов/слов                           
12,С учетом регистра                                                
13,"Допускать ввод с пустыми результатами (необходим перезапуск TC)"
14,Фильтрация файлов                                                
15,Фильтрация каталогов                                             
16,Использовать PinYin (для китайского языка)                       
17,Расширенный интерфейс                                            
18,Активировать                                                     
19,Показать в один ряд                                              
20,Активация символов для режимов поиска                            
21,Изменить                                                         
22,Символы для простого поиска                                      
23,Символы для простого поиска с совпадением начала слов            
24,Символы для поиска RegEx                                         
25,Символы для поиска подобия                                       
26,Символы для поиска                                               
27,Другие символы                                                   
28,Добавить сепаратор                                               
29,Или сепаратор                                                    
30,Отрицание символов                                               
31,Активация символа для пресета                                    
32,Контентный плагин сепаратор                                      
33,Новый символ                                                     
34,Введите новый символ:                                            
35,Подтверждение                                                    
36,Символ:                                                          
37,Строка пресета:                                                  
38,Добавить                                                         
39,Список пресетов:                                                 
40,Символы для замены:                                              
41,Новый текст:                                                     
42,Правила замены:                                                  
43,Показать справку                                                 
44,Справка не найдена                                               
45,Справка не найдена по этому пути:                                
46,Показать пресеты                                                 
47,Язык: (необходим перезапуск TC)                                  
48,Контентные плагины                                               
49,Выберите файл контентного плагина:                               
50,Поля контентного плагина:                                        
51,Выбор группы:                                                    
52,обновить                                                         
53,Контентные плагины:                                              
54,Расширенные опции                                                
55,Log-файл: (замедляет поиск)                                      
56,не создавать                                                     
57,создавать только для ошибок                                      
58,log значений контентного плагина                                 
59,log всех вызываемых функций                                      
60,Размер кэша: (Количество файлов)                                 
61,Инверсия результата                                              
62,Quick Search eXtended - конфигурация                             
63,Использовать поиск по слогам (для корейского языка)              
)

LanguageStrings9=
(
 0,한국어 (Korean)
 1,간편 검색
 2,정규식 검색
 3,유사 검색
 4,퀵실버 검색
 5,<프리셋>
 6,일반
 7,구문 변경
 8,프리셋
 9,바꾸기 규칙
10,검색 옵션
11,파일/단어의 시작 부분에서만 일치하기
12,대소문자 구별하기
13,"검색 결과가 없는 입력 허용하기 (TC 재시작 필요)"
14,찾은 파일만 표시하기
15,찾은 폴더만 표시하기
16,중국어 병음(PinYin) 사용하기
17,추가 사용자 인터페이스
18,활성화하기
19,한 줄로 표시하기
20,검색 모드 활성화 문자
21,바꾸기
22,간편 검색용 문자
23,간편 검색용 문자 (시작 부분에서만 일치)
24,정규식 검색용 문자
25,유사 검색용 문자
26,퀵실버 검색용 문자
27,다른 문자
28,And 분리자 문자
29,Or 분리자 문자
30,부정 문자
31,프리셋 활성화 문자
32,컨텐츠 플러그인 분리자 문자
33,새로운 문자
34,새 문자를 입력하세요:
35,확인
36,문자:
37,프리셋 문자열:
38,추가
39,프리셋 목록:
40,바꿀 문자:
41,새 텍스트:
42,바꾸기 규칙:
43,도움말
44,도움말 파일이 없습니다
45,다음 경로에 도움말 파일이 없습니다:
46,프리셋 보기
47,언어 선택: (TC 재시작 필요)
48,컨텐츠 플러그인
49,컨텐츠 플러그인 파일 선택:
50,컨텐츠 플러그인의 필드:
51,그룹 선택:
52,업데이트
53,컨텐츠 플러그인 목록:
54,추가 옵션
55,로그파일: (검색 속도가 느려짐)
56,사용하지 않음
57,오류 발생시만 만들기
58,컨텐츠 플러그인의 값 기록하기
59,모든 함수 호출 기록하기
60,캐쉬 크기: (파일 개수)
61,결과 반전하기
62,빠른 찾기 확장 - 설정
63,한글 초성 검색 사용하기
)

IniRead,INI_language,%A_ScriptDir%\tcmatch.ini,gui,language,1
; #Language
; autodetect languages
if(INI_language < "2"){
 if A_Language in 0412 ; 한국어 (Korean)
  INI_language=9
 else if A_Language in 0419 ; Pусский (Russian)
  INI_language=8
 else if A_Language in 0422 ; Українська (Ukrainian)
  INI_language=7
 else if A_Language in 0415 ; Polski (Polish)
  INI_language=6
 else if A_Language in 040e ; Magyar (Hungarian)
  INI_language=5
 else if A_Language in 040a,080a,0c0a,100a,140a,180a,1c0a,200a,240a,280a,2c0a,300a,340a,380a,3c0a,400a,440a,480a,4c0a,500a ; Español (Spanish)
  INI_language=4
 else if A_Language in 0407,0807,0c07,1007,1407 ; Deutsch (German)
  INI_language=3
 else INI_language=2 ; English
}      

LanguageStrings := LanguageStrings%INI_language%
loop,parse,LanguageStrings,`n,`r
{      
 i:=A_Index-1
 loop,parse,A_LoopField,CSV
 {     
  if(A_Index=="2"){
   tmp=%A_LoopField%
   L%i%:=tmp
  }     
 }      
}       

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - load the icons
loop,9  
{       
 VarSetCapacity(Icon_small,4,0)
 VarSetCapacity(Icon_big,4,0)
 DllCall("shell32.dll\ExtractIconExW","str","tcmatch" . x32_64 . ".dll","int",A_Index-1,"str",Icon_big,"str",Icon_small,"uint",1)
 DllCall("DestroyIcon","uint",NumGet(Icon_big))
 Icon_%A_Index%:=NumGet(Icon_small)
}        
         
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - create gui1
Gui 1:Default
IniRead,INI_one_line_gui,%A_ScriptDir%\tcmatch.ini,gui,one_line_gui,-1
if(INI_one_line_gui=="-1"){
 IniWrite,1,%A_ScriptDir%\tcmatch.ini,gui,one_line_gui
 INI_one_line_gui=1
}         
IniRead,INI_show_presets,%A_ScriptDir%\tcmatch.ini,gui,show_presets,-1
if(INI_show_presets=="-1"){
 IniWrite,0,%A_ScriptDir%\tcmatch.ini,gui,show_presets
 INI_show_presets=0
}         
          
Gui,+AlwaysOnTop -Border +ToolWindow
if(INI_one_line_gui=="0"){
 Gui,add,button      ,x0   y0  hwndhwnd_1 +64 h24 w24 vQSXVB1 gLMatchBeginning
 Gui,add,button      ,x26  y0  hwndhwnd_2 +64 h24 w24 vQSXVB2 gLCaseSensitive
 Gui,add,button      ,x0   y26 hwndhwnd_3 +64 h24 w24 vQSXVB3 gLInvert
 Gui,add,button      ,x26  y26 hwndhwnd_4 +64 h24 w24 vQSXVB4 gShowGui2
 Gui,add,dropdownlist,x52  y1  w130 altsubmit vVSearch gLSearch       ,%L1%||%L2%|%L3%|%L4%
 Gui,add,picture     ,x52  y30 w16 h16 vVFavicon Icon7                ,tcmatch%x32_64%.dll
 Gui,add,dropdownlist,x72  y27 w110 vVFavitems gLFavitems             ,
}else{     
 Gui,add,button      ,x0   y0  hwndhwnd_1 +64 h24 w24 vQSXVB1 gLMatchBeginning
 Gui,add,button      ,x26  y0  hwndhwnd_2 +64 h24 w24 vQSXVB2 gLCaseSensitive
 Gui,add,button      ,x52  y0  hwndhwnd_3 +64 h24 w24 vQSXVB3 gLInvert
 Gui,add,dropdownlist,x83  y1  w110 altsubmit vVSearch gLSearch       ,%L1%||%L2%|%L3%|%L4%
 Gui,add,picture     ,x200 y4  w16 h16 vVFavicon Icon7                ,tcmatch%x32_64%.dll
 Gui,add,dropdownlist,x220 y1  w110 vVFavitems gLFavitems             ,
 Gui,add,button      ,x337 y0  hwndhwnd_4 +64 h24 w24 vQSXVB4 gShowGui2
 if(INI_show_presets==0){
  GuiControl,move,QSXVB4   ,x200 y0
  GuiControl,move,VFavitems,x0 y100
  GuiControl,move,VFavicon ,x0 y100
  GuiControl,disable,VFavitems
  GuiControl,disable,VFavicon
 }           
}            
QSXVB1_Tooltip=%L11%
QSXVB2_Tooltip=%L12%
QSXVB3_Tooltip=%L61%
QSXVB4_Tooltip=%L62%
Gui,+Delimiter`n
Gui 2:+Delimiter`n

GoSub LoadIni
DllCall("SendMessage","UInt",hwnd_4,"UInt",247,"UInt",1,"UInt",Icon_9)
             
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - start gui2 when called without parameters
GoSub CreateGui2
if 0>0        
{             
 parameter=%1%
}             
if(parameter!="gui"){                                                         ; "gui" is used as parameter when called by tcmatch(64).dll
 GoSub ShowGui2
}             
              
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - start automatic show/hide
;GoSub QSWindowCheck
SetTimer,QSWindowCheck,100
return         
               
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - load ini settings
LoadIni:       
 Gui 1:Default 
 FileGetTime,IniTimestamp,%A_ScriptDir%\tcmatch.ini
 if(IniTimestamp==IniLastTimestamp){
  return       
 }             
 IniLastTimestamp=%IniTimestamp%
                
 if(INI_case_sensitive==""){
  IniRead,INI_case_sensitive ,%A_ScriptDir%\tcmatch.ini,general,case_sensitive ,0
  IniRead,INI_match_beginning,%A_ScriptDir%\tcmatch.ini,general,match_beginning,0
  IniRead,INI_override_search,%A_ScriptDir%\tcmatch.ini,gui    ,override_search,1
  IniRead,INI_invert_result  ,%A_ScriptDir%\tcmatch.ini,gui    ,invert_result  ,0
 }else{         
  IniRead,INI_case_sensitive ,%A_ScriptDir%\tcmatch.ini,general,case_sensitive ,%INI_case_sensitive%
  IniRead,INI_match_beginning,%A_ScriptDir%\tcmatch.ini,general,match_beginning,%INI_match_beginning%
  IniRead,INI_override_search,%A_ScriptDir%\tcmatch.ini,gui    ,override_search,%INI_override_search%
  IniRead,INI_invert_result  ,%A_ScriptDir%\tcmatch.ini,gui    ,invert_result  ,%INI_invert_result%
 }               
                 
 GuiControl,choose,VSearch,%INI_override_search%
 GuiControl,,VFavitems,`n%L5%`n`n
 FileRead,IniFile,%A_ScriptDir%\tcmatch.ini
                 
 IniSection=0
 Loop,parse,IniFile,`n,`r
 {
  if(RegExMatch(A_LoopField,"^\s*\[presets]\s*$")){
   IniSection=1
  }else if(RegExMatch(A_LoopField,"^\s*\[.*]\s*$")){
   IniSection=0
  }
  pos:=InStr(A_LoopField,"=")
  if(IniSection && pos){
   StringMid,LoopField,A_LoopField,pos+1
   GuiControl,,VFavitems,%LoopField%
  }
 }

 Icon:=INI_match_beginning ? Icon_2 : Icon_1
 DllCall("SendMessage","UInt",hwnd_1,"UInt",247,"UInt",1,"UInt",Icon)
 Icon:=INI_case_sensitive  ? Icon_4 : Icon_3
 DllCall("SendMessage","UInt",hwnd_2,"UInt",247,"UInt",1,"UInt",Icon)
 Icon:=INI_invert_result   ? Icon_6 : Icon_5
 DllCall("SendMessage","UInt",hwnd_3,"UInt",247,"UInt",1,"UInt",Icon)
return

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - handle events gui1
LMatchBeginning:
 INI_match_beginning:=INI_match_beginning ? 0 : 1
 IniWrite,%INI_match_beginning%,%A_ScriptDir%\tcmatch.ini,general,match_beginning
 Icon:=INI_match_beginning ? Icon_2 : Icon_1
 DllCall("SendMessage","UInt",hwnd_1,"UInt",247,"UInt",1,"UInt",Icon)
 ActivateTC("^s{space}{backspace}")
return

LCaseSensitive:
 INI_case_sensitive:=INI_case_sensitive ? 0 : 1
 IniWrite,%INI_case_sensitive%,%A_ScriptDir%\tcmatch.ini,general,case_sensitive
 Icon:=INI_case_sensitive ? Icon_4 : Icon_3
 DllCall("SendMessage","UInt",hwnd_2,"UInt",247,"UInt",1,"UInt",Icon)
 ActivateTC("^s{space}{backspace}")
return

LInvert:
 INI_invert_result:=INI_invert_result ? 0 : 1
 IniWrite,%INI_invert_result%,%A_ScriptDir%\tcmatch.ini,gui,invert_result
 Icon:=INI_invert_result ? Icon_6 : Icon_5
 DllCall("SendMessage","UInt",hwnd_3,"UInt",247,"UInt",1,"UInt",Icon)
 ActivateTC("^s{space}{backspace}")
return

LSearch:
 Gui 1:Default
 GuiControlGet,INI_override_search,,VSearch
 IniWrite,%INI_override_search%,%A_ScriptDir%\tcmatch.ini,gui,override_search
 ActivateTC("^s{space}{backspace}")
return

LFavitems:
 Gui 1:Default
 GuiControlGet,Favitem,,VFavitems
 GuiControl,choose,VFavitems,1
 ActivateTC("^s+{home}" . Favitem)
return

ActivateTC(Keys)
{
 global QSDelay
 QSDelay=3
 WinActivate ahk_class TTOTAL_CMD
 WinWaitActive ahk_class TTOTAL_CMD,,2
 if(!ErrorLevel){
  send %Keys%
 }
}

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - automatic show/hide functions
WM_ACTIVATE(wParam,lParam,msg,hwnd)
{
 global isWinActive
 isWinActive=%wParam%
}

QSWindowCheck:
 if(QSvisible==1){ ; tooltips
  MouseGetPos,newmx,newmy
  if(Messagex!=newmx || Messagey!=newmy){
   newMessage=
   Tooltip
  }
  if(newmx!=oldmx || newmy!=oldmy){
   oldmx=%newmx%
   oldmy=%newmy%
   Tooltip   
   mz=0
  }else{
   if(mz=4 && newMessage!=""){
    newmx:=newmx+20
    Tooltip,%newMessage%,%newmx%,%newmy%
   }
   mz++
  }
 }
 if(QSvisible==0 && INI_override_search!=0 && WinActive("ahk_class TQUICKSEARCH")){
  gosub showQSX
 }else if(QSvisible==1 && !WinExist("ahk_class TQUICKSEARCH") && !isWinActive){
  if(QSDelay){
   QSDelay--
  }else{
   gosub hideQSX
  }
 }else if(QSvisible!=2 && !WinExist("ahk_class TTOTAL_CMD")){
  ExitApp  
 }
return

WM_MOUSEOVER()
{
 global
 MouseGetPos,Messagex,Messagey
 if A_GuiControl in QSXVB1,QSXVB2,QSXVB3,QSXVB4
 {
  MessageVar=%A_GuiControl%_Tooltip
  newMessage:=%MessageVar%
 }
}

showQSX:
 Gui 2:Default
 Gui,hide
 Gui 1:Default
 WinGetPos,posX,posY,posDX,posDY,ahk_class TQUICKSEARCH
 GoSub LoadIni
 posX:=posX+posDX+5
 if(INI_one_line_gui==0){
  posy:=posy-25
  gui,Show,X%posX% Y%posY% w183 h50 NoActivate
 }else{
  if(INI_show_presets==1){
   gui,Show,X%posX% Y%posY% w361 h24 NoActivate
  }else{
   gui,Show,X%posX% Y%posY% w224 h24 NoActivate
  }
 }
 QSvisible=1
 QSDelay=0
return

hideQSX:
 Gui 1:Default
 gui,hide
 Tooltip
 QSvisible=0
return

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - create gui2
CreateGui2:
 Gui 2:Default
 Gui,add,tab2    ,              w450 h430 +Theme -Background,%L6%`n`n%L7%`n%L8%`n%L9%`n%L48%
 
; - - - - - tab #1
 Gui,add,groupbox,x+10   y+10   w425 h165 section            ,%L10%
 Gui,add,checkbox,xp+10  yp+25            vC01 gL01          ,%L11%
 Gui,add,checkbox,                        vC02 gL02          ,%L12%
 Gui,add,checkbox,                        vC03 gL03          ,%L13%
 Gui,add,checkbox,                        vC04 gL04          ,%L14%
 Gui,add,checkbox,                        vC05 gL05          ,%L15%
 Gui,add,checkbox,                        vC06 gL06          ,%L16%
 Gui,add,checkbox,                        vC06b gL06b        ,%L63%
 Gui,add,groupbox,xs     ys+175 w425 h150 section            ,%L17%
 Gui,add,checkbox,xp+10  yp+25            vC07 gL07          ,%L18%
 Gui,add,checkbox,                        vC08 gL08          ,%L19%
 Gui,add,checkbox,                        vCa9 gLa9          ,%L46%
 Gui,add,text    ,       yp+30                               ,%L47%

; language selection
; #Language
 Gui,add,dropdownlist,          w150      vCaa gLaa altsubmit,English`nDeutsch (German)`nEspañol (Spanish)`nMagyar (Hungarian)`nPolski (Polish)`nУкраїнська (Ukrainian)`nPусский (Russian)`n한국어 (Korean)
                                                         
; - - - - - tab #2                                       
 Gui,tab,2                                               
 Gui,add,groupbox,x+10   y+10   w425 h180 section            ,%L20%
 Gui,add,Edit    ,xp+10  yp+25  w20  h21  vC09 Disabled      ,
 Gui,add,button  ,xp+25  yp-1        h23  gL09               ,%L21%
 Gui,add,text    ,xp+65  yp+5                                ,%L22%
 Gui,add,Edit    ,xp-90  yp+25  w20  h21  vC10 Disabled      ,
 Gui,add,button  ,xp+25  yp-1        h23  gL10               ,%L21%
 Gui,add,text    ,xp+65  yp+5                                ,%L23%
 Gui,add,Edit    ,xp-90  yp+25  w20  h21  vC11 Disabled      ,
 Gui,add,button  ,xp+25  yp-1        h23  gL11               ,%L21%
 Gui,add,text    ,xp+65  yp+5                                ,%L24%
 Gui,add,Edit    ,xp-90  yp+25  w20  h21  vC12 Disabled      ,
 Gui,add,button  ,xp+25  yp-1        h23  gL12               ,%L21%
 Gui,add,text    ,xp+65  yp+5                                ,%L25%
 Gui,add,Edit    ,xp-90  yp+25  w20  h21  vC13 Disabled      ,
 Gui,add,button  ,xp+25  yp-1        h23  gL13               ,%L21%
 Gui,add,text    ,xp+65  yp+5                                ,%L26%
 Gui,add,groupbox,xs     ys+190 w425 h180 section            ,%L27%
 Gui,add,Edit    ,xp+10  yp+25  w20  h21  vC14 Disabled      ,
 Gui,add,button  ,xp+25  yp-1        h23  gL14               ,%L21%
 Gui,add,text    ,xp+65  yp+5                                ,%L28%
 Gui,add,Edit    ,xp-90  yp+25  w20  h21  vC15 Disabled      ,
 Gui,add,button  ,xp+25  yp-1        h23  gL15               ,%L21%
 Gui,add,text    ,xp+65  yp+5                                ,%L29%
 Gui,add,Edit    ,xp-90  yp+25  w20  h21  vC16 Disabled      ,
 Gui,add,button  ,xp+25  yp-1        h23  gL16               ,%L21%
 Gui,add,text    ,xp+65  yp+5                                ,%L30%
 Gui,add,Edit    ,xp-90  yp+25  w20  h21  vC17 Disabled      ,
 Gui,add,button  ,xp+25  yp-1        h23  gL17               ,%L21%
 Gui,add,text    ,xp+65  yp+5                                ,%L31%
 Gui,add,Edit    ,xp-90  yp+25  w20  h21  vC18 Disabled      ,
 Gui,add,button  ,xp+25  yp-1        h23  gL18               ,%L21%
 Gui,add,text    ,xp+65  yp+5                                ,%L32%

; - - - - - tab #3
 Gui,tab,3
 Gui,add,text    ,x+10   y+15                                ,%L36%
 Gui,add,text    ,xp+50  yp                                  ,%L37%
 Gui,add,Edit    ,xp-50  yp+18  w20  h21  vC19 limit1        ,
 Gui,add,Edit    ,xp+50  yp     w290 h21  vC20               ,
 Gui,add,Button  ,xp+300 yp-1             gAddListEntry1     ,%L38%
 Gui,add,text    ,xp-350 yp+35                               ,%L39%
 Gui,add,ListBox ,              w425 h300 vC21 gListEntryChanged1 sort t25,

; - - - - - tab #4
 Gui,tab,4
 Gui,add,text    ,x+10   y+15                                ,%L40%
 Gui,add,text    ,xp+250 yp                                  ,%L41%
 Gui,add,Edit    ,xp-250 yp+18  w240 h21  vC22               ,
 Gui,add,Edit    ,xp+250 yp     w90  h21  vC23               ,
 Gui,add,Button  ,xp+100 yp-1             gAddListEntry2     ,%L38%
 Gui,add,text    ,xp-350 yp+35                               ,%L42%
 Gui,add,ListBox ,              w425 h300 vC24 gListEntryChanged2 sort t128 t160 t192,
 
; - - - - - tab #5
 Gui,tab,5
 Gui,add,text    ,x+10   y+15             section            ,%L49%
 Gui,add,text    ,xp+280 yp                                  ,%L50%
 Gui,add,Edit    ,xp-280 yp+18  w245 h21  vC25 Disabled      ,
 Gui,add,Button  ,xp+248 yp-1                  gL25          ,...
 Gui,add,listbox ,xp+32  yp+1   w145 h100 vC26 Multi         ,
 Gui,add,text    ,xp-280 yp+55                               ,%L51%
 Gui,add,Edit    ,              w40            Limit2 Number ,
 Gui,add,UpDown  ,                        vC27 Range1-99     ,1
 Gui,add,Button  ,xp+155 yp-1             gUpdateListEntry3  ,%L52%
 Gui,add,Button  ,xp+60  yp               gAddListEntry3     ,%L38%
 Gui,add,text    ,xp-215 yp+35                               ,%L53%
 Gui,add,ListBox ,              w425 h130 vC28 gListEntryChanged3 sort t60 t195,
 Gui,add,groupbox,xs     ys+280 w425 h85  section            ,%L54%
 Gui,add,text    ,xp+10  yp+25                               ,%L55%
 Gui,add,dropdownlist,   yp+20  w200      vC29 gL29 altsubmit,%L56%`n`n%L57%`n%L58%`n%L59%
 Gui,add,text    ,xp+205 yp-20                               ,%L60%
 Gui,add,edit    ,              w70       vC30 gL30 Number   ,
 
 Gui,tab
 Gui,add,button,xm gShowHelp                                 ,%L43%
 Gui,add,button,xp+425 hwndhwnd_5 +64 h24 w24 gCloseGui2
 DllCall("SendMessage","UInt",hwnd_5,"UInt",247,"UInt",1,"UInt",Icon_8)
 
 Gui 3:Default
 Gui,+owner2 -MinimizeBox -MaximizeBox
 Gui,add,Text  ,                                             ,%L34%
 Gui,add,Edit  ,xp+30 yp+25 w20 h21 vC99 limit1              ,
 Gui,add,Button,xp+30 yp-1          gHideGui3                ,%L35%
return

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - show gui2
ShowGui2:
 GoSub hideQSX
 QSvisible=2
 Gui 2:Default
 GoSub LoadIni2
 Gui,show,,QuickSearch eXtended %Version% © Samuel Plentz
 if(!V07){
  GuiControl 2:+Disabled,C08
  GuiControl 2:+Disabled,Ca9
 }
 if(!V08){
  GuiControl 2:+Disabled,Ca9
 }
return

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - loadini gui2
LoadIni2:
 Gui 2:Default
 
; - - - - - tab #1
 IniRead,V01,%A_ScriptDir%\tcmatch.ini,general,match_beginning         ,0
 IniRead,V02,%A_ScriptDir%\tcmatch.ini,general,case_sensitive          ,0
 IniRead,V03,%A_ScriptDir%\tcmatch.ini,general,allow_empty_result      ,1
 IniRead,W04,%A_ScriptDir%\tcmatch.ini,general,filter_files_and_folders,3
 V04:=(W04==1) ? 0 : 1
 V05:=(W04==2) ? 0 : 1
 Chinese=0
 if(SubStr(A_Language,3)=="04"){
  Chinese=1
 }
 Korean=0
 if(SubStr(A_Language,3)=="12"){
  Korean=1
 }
 IniRead,V06,%A_ScriptDir%\tcmatch.ini,general,use_pinyin              ,%Chinese%
 IniRead,V06b,%A_ScriptDir%\tcmatch.ini,general,use_korean             ,%Korean%
 IniRead,V07,%A_ScriptDir%\tcmatch.ini,gui    ,override_search         ,1
 IniRead,V08,%A_ScriptDir%\tcmatch.ini,gui    ,one_line_gui            ,0
 IniRead,Va9,%A_ScriptDir%\tcmatch.ini,gui    ,show_presets            ,1
 
 V07:=(V07!=0) ? 1 : 0
 
 GuiControl,,C01,%V01%
 GuiControl,,C02,%V02%
 GuiControl,,C03,%V03%
 GuiControl,,C04,%V04%
 GuiControl,,C05,%V05%
 GuiControl,,C06,%V06%
 GuiControl,,C06b,%V06b%
 GuiControl,,C07,%V07%
 GuiControl,,C08,%V08%
 GuiControl,,Ca9,%Va9%
 INI_language_2 := INI_language - 1
 GuiControl,Choose,Caa,%INI_language_2%

; - - - - - tab #2
 IniRead,V09,%A_ScriptDir%\tcmatch.ini,general,simple_search_activate_char                ,%A_Space%
 IniRead,V10,%A_ScriptDir%\tcmatch.ini,general,simple_search_match_beginning_activate_char,^
 IniRead,V11,%A_ScriptDir%\tcmatch.ini,general,regex_search_activate_char                 ,?
 IniRead,V12,%A_ScriptDir%\tcmatch.ini,general,leven_search_activate_char                 ,<
 IniRead,V13,%A_ScriptDir%\tcmatch.ini,general,srch_activate_char                         ,*
 IniRead,V14,%A_ScriptDir%\tcmatch.ini,general,and_separator_char                         ,
 IniRead,V15,%A_ScriptDir%\tcmatch.ini,general,or_separator_char                          ,|
 IniRead,V16,%A_ScriptDir%\tcmatch.ini,general,negate_char                                ,!
 IniRead,V17,%A_ScriptDir%\tcmatch.ini,general,preset_activate_char                       ,>
 IniRead,V18,%A_ScriptDir%\tcmatch.ini,general,wdx_separator_char                         ,/
 V09:=ConvertChar(V09,1)
 V10:=ConvertChar(V10,1)
 V11:=ConvertChar(V11,1)
 V12:=ConvertChar(V12,1)
 V13:=ConvertChar(V13,1)
 V14:=ConvertChar(V14,1)
 V15:=ConvertChar(V15,1)
 V16:=ConvertChar(V16,1)
 V17:=ConvertChar(V17,1)
 V18:=ConvertChar(V18,1)
 GuiControl,,C09,%V09%
 GuiControl,,C10,%V10%
 GuiControl,,C11,%V11%
 GuiControl,,C12,%V12%
 GuiControl,,C13,%V13%
 GuiControl,,C14,%V14%
 GuiControl,,C15,%V15%
 GuiControl,,C16,%V16%
 GuiControl,,C17,%V17%
 GuiControl,,C18,%V18%

; - - - - - tab #3
 GuiControl,,C21,`n
 PresetList=
 FileRead,IniFile,%A_ScriptDir%\tcmatch.ini
 IniSection=0
 Loop,parse,IniFile,`n,`r
 {
  if(RegExMatch(A_LoopField,"^\s*\[presets]\s*$")){
   IniSection=1
  }else if(RegExMatch(A_LoopField,"^\s*\[.*]\s*$")){
   IniSection=0
  }
  pos:=InStr(A_LoopField,"=")
  if(IniSection && pos){
   StringReplace,LoopField,A_LoopField,=,%A_Tab%
   PresetList=%PresetList%`n%LoopField%
  }
 }
 GuiControl,,C21,%PresetList%
 GuiControl,Choose,C21,1
 gosub ListEntryChanged1
 
; - - - - - tab #4
 GuiControl,,C24,`n
 ReplaceList=
 ReplaceCount=0
 Loop
 {
  IniRead,Entry,%A_ScriptDir%\tcmatch.ini,replace,chars%A_Index%,
  if(Entry=="ERROR"){
   break
  }
  StringReplace,Entry,Entry,|,%A_Tab%
  ReplaceList=%ReplaceList%`n%Entry%
  ReplaceCount=%A_Index%
 }
 GuiControl,,C24,%ReplaceList%
 GuiControl,Choose,C24,1
 gosub ListEntryChanged2
  
; - - - - - tab #5
 IniRead,V29,%A_ScriptDir%\tcmatch.ini,wdx,debug_output,1
 IniRead,V30,%A_ScriptDir%\tcmatch.ini,wdx,wdx_cache   ,1000
 V29++
 GuiControl,Choose,C29,%V29%
 GuiControl,,C30,%V30%
 GuiControl,,C28,`n
 wdxListA=
 wdxListB=
 Loop 100
 {
  wdxListC%A_Index%:=1
 }
 IniRead,VGroups,%A_ScriptDir%\tcmatch.ini,%wdx32_64%,wdx_groups,%A_Space%
 StringSplit,VGroups,VGroups,|
 Loop %VGroups0%
 {
  VGroup:=VGroups%A_Index%
  Index=%A_Index%
  StringSplit,VGroup,VGroup,`,
  Loop %VGroup0%
  {
   Item:=VGroup%A_Index%
   wdxListC%Item%:=Index
  }
 }
 Loop
 {
  IniRead,Entry,%A_ScriptDir%\tcmatch.ini,%wdx32_64%,wdx_text_plugin%A_Index%,
  if(Entry=="ERROR"){
   break
  }
  Group:=wdxListC%A_Index%
  wdxListB=%wdxListB%`n%Entry%
  StringSplit,Entry_,Entry,@
  SplitPath,Entry_2,Filename
  StringReplace,Entry_1,Entry_1,|,`,%A_Space%,1
  wdxListA=%wdxListA%`n%Filename%%A_Tab%%Entry_1%%A_Tab%%Group%
 }
 GuiControl,,C28,%wdxListA%
 GuiControl,Choose,C28,1
 gosub ListEntryChanged3

 Hotkey,IfWinActive,QuickSearch eXtended %Version% © Samuel Plentz
 Hotkey,~Delete,DeleteListEntry
return

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - handle events gui2
ShowHelp:
; #Language
 if(INI_language==5 && FileExist(A_ScriptDir . "\tcmatch_hu.pdf")){
  run,%A_ScriptDir%\tcmatch_hu.pdf
 }else if(INI_language==3 && FileExist(A_ScriptDir . "\tcmatch_de.pdf")){
  run,%A_ScriptDir%\tcmatch_de.pdf
 }else if(INI_language==9 && FileExist(A_ScriptDir . "\tcmatch_ko.pdf")){
  run,%A_ScriptDir%\tcmatch_ko.pdf
 }else if(FileExist(A_ScriptDir . "\tcmatch.pdf")){
  run,%A_ScriptDir%\tcmatch.pdf
 }else{
  msgbox,8240,%L44%,%L45%`n%A_ScriptDir%\tcmatch.pdf
 }
return

; - - - - - tab #1
L01:
 V01:=(V01!=0) ? 0 : 1
 IniWrite,%V01%,%A_ScriptDir%\tcmatch.ini,general,match_beginning
return

L02:
 V02:=(V02!=0) ? 0 : 1
 IniWrite,%V02%,%A_ScriptDir%\tcmatch.ini,general,case_sensitive
return

L03:
 V03:=(V03!=0) ? 0 : 1
 IniWrite,%V03%,%A_ScriptDir%\tcmatch.ini,general,allow_empty_result
return

L04:
 V04:=(V04!=0) ? 0 : 1
 if(V04==0){
  GuiControl 2:,C05,1
  V05=1
 }
 W04:=2*V05+V04
 IniWrite,%W04%,%A_ScriptDir%\tcmatch.ini,general,filter_files_and_folders
return

L05:
 V05:=(V05!=0) ? 0 : 1
 if(V05==0){
  GuiControl 2:,C04,1
  V04=1
 }
 W04:=2*V05+V04
 IniWrite,%W04%,%A_ScriptDir%\tcmatch.ini,general,filter_files_and_folders
return

L06:
 V06:=(V06!=0) ? 0 : 1
 IniWrite,%V06%,%A_ScriptDir%\tcmatch.ini,general,use_pinyin
return

L06b:
 V06b:=(V06b!=0) ? 0 : 1
 IniWrite,%V06b%,%A_ScriptDir%\tcmatch.ini,general,use_korean
return

L07:
 V07:=(V07!=0) ? 0 : 1
 IniWrite,%V07%,%A_ScriptDir%\tcmatch.ini,gui,override_search
 INI_override_search=%V07%
 if(!V07){
  GuiControl 2:+Disabled,C08
  GuiControl 2:+Disabled,Ca9
 }else{
  GuiControl 2:-Disabled,C08
  if(V08){
   GuiControl 2:-Disabled,Ca9
  }
 }
return

L08:
 V08:=(V08!=0) ? 0 : 1
 IniWrite,%V08%,%A_ScriptDir%\tcmatch.ini,gui,one_line_gui
 INI_one_line_gui=%V08%
 if(!V08){
  GuiControl 2:+Disabled,Ca9
 }else{
  GuiControl 2:-Disabled,Ca9
 }
 GoSub LMoveWindow
return

La9:
 Va9:=(Va9!=0) ? 0 : 1
 IniWrite,%Va9%,%A_ScriptDir%\tcmatch.ini,gui,show_presets
 INI_show_presets=%Va9%
 GoSub LMoveWindow
return

LMoveWindow:
 Gui 1:Default
 if(INI_one_line_gui=="0"){
  GuiControl,enable,VFavitems
  GuiControl,enable,VFavicon
  GuiControl,move,QSXVB3   ,x0  y26
  GuiControl,move,QSXVB4   ,x26 y26
  GuiControl,move,VSearch  ,x52 y1 w130
  GuiControl,move,VFavicon ,x52 y30
  GuiControl,move,VFavitems,x72 y27
 }else{
  if(INI_show_presets!=0){
   GuiControl,enable,VFavitems
   GuiControl,enable,VFavicon
   GuiControl,move,QSXVB4   ,x337 y0
   GuiControl,move,VFavicon ,x200 y4
   GuiControl,move,VFavitems,x220 y1
  }else{
   GuiControl,move,QSXVB4   ,x200 y0
   GuiControl,move,VFavitems,x0 y100
   GuiControl,move,VFavicon ,x0 y100
   GuiControl,disable,VFavitems
   GuiControl,disable,VFavicon
  }
  GuiControl,move,QSXVB3 ,x52 y0
  GuiControl,move,VSearch,x83 y1 w110
 }
return

Laa:
 GuiControlGet,INI_language,,Caa
 INI_language++
 IniWrite,%INI_language%,%A_ScriptDir%\tcmatch.ini,gui,language
return

; - - - - - tab #2
L09:
 CurItem=9
 Gosub ShowGui3
return

L10:
 CurItem=10
 Gosub ShowGui3
return

L11:
 CurItem=11
 Gosub ShowGui3
return

L12:
 CurItem=12
 Gosub ShowGui3
return

L13:
 CurItem=13
 Gosub ShowGui3
return

L14:
 CurItem=14
 Gosub ShowGui3
return

L15:
 CurItem=15
 Gosub ShowGui3
return

L16:
 CurItem=16
 Gosub ShowGui3
return

L17:
 CurItem=17
 Gosub ShowGui3
return

L18:
 CurItem=18
 Gosub ShowGui3
return

ShowGui3:
 Gui 2:+Disabled
 Gui 3:Default
 GuiControl,,C99,
 GuiControl,Focus,C99
 Gui 3:show,,%L33%
return

HideGui3:
 Gui 3:Default
 GuiControlGet,NewChar,,C99
 ConvertedChar:=ConvertChar(NewChar,1)
 Char4File    :=ConvertChar(NewChar,2)
 if(CurItem=="9"){
  GuiControl 2:,C09,%ConvertedChar%
  IniWrite,%Char4File%,%A_ScriptDir%\tcmatch.ini,general,simple_search_activate_char
 }else if(CurItem=="10"){
  GuiControl 2:,C10,%ConvertedChar%
  IniWrite,%Char4File%,%A_ScriptDir%\tcmatch.ini,general,simple_search_match_beginning_activate_char
 }else if(CurItem=="11"){
  GuiControl 2:,C11,%ConvertedChar%
  IniWrite,%Char4File%,%A_ScriptDir%\tcmatch.ini,general,regex_search_activate_char
 }else if(CurItem=="12"){
  GuiControl 2:,C12,%ConvertedChar%
  IniWrite,%Char4File%,%A_ScriptDir%\tcmatch.ini,general,leven_search_activate_char
 }else if(CurItem=="13"){
  GuiControl 2:,C13,%ConvertedChar%
  IniWrite,%Char4File%,%A_ScriptDir%\tcmatch.ini,general,srch_activate_char
 }else if(CurItem=="14" && ConvertedChar!=""){
  GuiControl 2:,C14,%ConvertedChar%
  IniWrite,%Char4File%,%A_ScriptDir%\tcmatch.ini,general,and_separator_char
 }else if(CurItem=="15" && ConvertedChar!=""){
  GuiControl 2:,C15,%ConvertedChar%
  IniWrite,%Char4File%,%A_ScriptDir%\tcmatch.ini,general,or_separator_char
 }else if(CurItem=="16" && ConvertedChar!=""){
  GuiControl 2:,C16,%ConvertedChar%
  IniWrite,%Char4File%,%A_ScriptDir%\tcmatch.ini,general,negate_char
 }else if(CurItem=="17" && ConvertedChar!=""){
  GuiControl 2:,C17,%ConvertedChar%
  IniWrite,%Char4File%,%A_ScriptDir%\tcmatch.ini,general,preset_activate_char
 }else if(CurItem=="18" && ConvertedChar!=""){
  GuiControl 2:,C18,%ConvertedChar%
  IniWrite,%Char4File%,%A_ScriptDir%\tcmatch.ini,general,wdx_separator_char
 }
3guiClose:
3guiEscape:
 Gui 2:-Disabled
 Gui 3:hide
return

ConvertChar(Char,Mode)
{
 if(Mode==1){
  if(Char=="ERROR" or Char==" "){
   return """ """
  }else if(Char==""){
   return ""
  }else{
   return " " . Char
  }
 }else if(Mode==2){
  if(Char==" "){
   return """ """
  }else{
   return Char
  }
 }
}

; - - - - - tab #3
AddListEntry1:
 GuiControlGet,Key,  2:,C19
 GuiControlGet,Value,2:,C20
 if(StrLen(Key)!=1 || StrLen(Value)<1){
  return
 }
 newPresetList=
 Loop,parse,PresetList,`n
 {
  if(A_LoopField!="" && InStr(A_LoopField,Key . A_Tab)!=1){
   newPresetList=%newPresetList%`n%A_LoopField%
  }
 }
 PresetList=%newPresetList%`n%Key%%A_Tab%%Value%
 IniWrite,%Value%,%A_ScriptDir%\tcmatch.ini,presets,%Key%
 GuiControl 2:,C21,%PresetList%
 GuiControl,2:ChooseString,C21,%Key%%A_Tab%%Value%
 gosub ListEntryChanged1
return

ListEntryChanged1:
 GuiControlGet,Value,2:,C21
 StringLeft,Key,Value,1
 StringTrimLeft,Value,Value,2
 GuiControl 2:,C19,%Key%
 GuiControl 2:,C20,%Value%
return

; - - - - - tab #4
AddListEntry2:
 GuiControlGet,Key,  2:,C22
 GuiControlGet,Value,2:,C23
 if(StrLen(Key)<1 || StrLen(Value)<1){
  return
 }
 ReplaceList=%ReplaceList%`n%Key%%A_Tab%%Value%
 ReplaceCount++
 IniWrite,%Key%|%Value%,%A_ScriptDir%\tcmatch.ini,replace,chars%ReplaceCount%
 GuiControl 2:,C24,%ReplaceList%
 GuiControl,2:ChooseString,C24,%Key%%A_Tab%%Value%
 gosub ListEntryChanged2
return

ListEntryChanged2:
 GuiControlGet,Value,2:,C24
 Position:=InStr(Value,A_Tab)
 StringLeft,Key,Value,Position-1
 StringTrimLeft,Value,Value,Position
 GuiControl 2:,C22,%Key%
 GuiControl 2:,C23,%Value%
return

; - - - - - tab #5
UpdateListEntry3:
 GuiControlGet,Filepath,2:,C25
 GuiControlGet,Fields,2:,C26
 GuiControlGet,Value,2:,C28
 if(Filepath=="" || Fields=="" || Value==""){
  return
 }
 StringSplit,wdxListA,wdxListA,`n
 StringSplit,wdxListB,wdxListB,`n
 wdxListA=
 wdxListB=
 Found=0
 Loop %wdxListA0%
 {
  IndexM1:=A_Index-1
  ValueA:=wdxListA%A_Index%
  ValueB:=wdxListB%A_Index%
  if(ValueA==Value && Found==0){
   Found=1
  }else if(ValueA!=""){
   IndexM2:=IndexM1-Found
   wdxListA=%wdxListA%`n%ValueA%
   wdxListB=%wdxListB%`n%ValueB%
   IniWrite,%ValueB%,%A_ScriptDir%\tcmatch.ini,%wdx32_64%,wdx_text_plugin%IndexM2%
  }
  if(Found==1){
   wdxListC%IndexM1%:=wdxListC%A_Index%
  }
 }
 IniDelete,%A_ScriptDir%\tcmatch.ini,%wdx32_64%,wdx_text_plugin%IndexM1%
 gosub AddListEntry3
return

AddListEntry3:
 GuiControlGet,Filepath,2:,C25
 GuiControlGet,Fields,2:,C26
 GuiControlGet,Group,2:,C27
 if(Filepath=="" || Fields==""){
  return
 }
 StringSplit,wdxListA,wdxListA,`n
 wdxListA0p1 := wdxListA0
 if(wdxListA0p1==0){
  wdxListA0p1++
 }
 SplitPath,Filepath,Filename
 wdxListC%wdxListA0p1%:=Group
 StringReplace,Fields,Fields,`n,|,1
 wdxListB=%wdxListB%`n%Fields%@%Filepath%
 IniWrite,%Fields%@%Filepath%,%A_ScriptDir%\tcmatch.ini,%wdx32_64%,wdx_text_plugin%wdxListA0p1%
 StringReplace,Fields,Fields,|,`,%A_Space%,1
 wdxListA=%wdxListA%`n%Filename%%A_Tab%%Fields%%A_Tab%%Group%
 wdxListC=
 Loop,100
 {
  B_Index=%A_Index%
  wdxListCpart=
  Loop,%wdxListA0p1%
  {
   ValueC:=wdxListC%A_Index%
   if(B_Index==ValueC){
    if(wdxListCpart=""){
     wdxListCpart=%A_Index%
    }else{
     wdxListCpart=%wdxListCpart%,%A_Index%
    }
   }
  }
  wdxListC=%wdxListC%%wdxListCpart%|
 }
 while(SubStr(wdxListC,StrLen(wdxListC))=="|"){
  StringTrimRight,wdxListC,wdxListC,1
 }
 IniWrite,%wdxListC%,%A_ScriptDir%\tcmatch.ini,%wdx32_64%,wdx_groups
 GuiControl,2:,C28,`n
 GuiControl,2:,C28,%wdxListA%
 GuiControl,2:Choose,C28,1
 gosub ListEntryChanged3
return

StrPutVar(Str,@){
 return StrPut(Str,@,"cp1252")
}

wdxLoadFields:
 Critical,On
 GuiControlGet,wdxFilename,2:,C25
 StringRight,wdxext,wdxFilename,4
	StringRight,wdxext64,wdxFilename,6
 wdxListD=
 if(FileExist(wdxFilename) && (wdxext=="." . wdx32_64 || wdxext64=="." . wdx32_64)){
  wdxFile:=DllCall("LoadLibrary","str",wdxFilename)
  if(errorlevel!=0){
   msgbox,Error in LoadLibrary:`n%wdxFilename%`nErrorlevel: %errorlevel%`nLast Error: %A_LastError%
  }else{
   setVersion:=DllCall("GetProcAddress",uint,wdxFile,astr,"ContentSetDefaultParams")
   if(errorlevel!=0){
    msgbox,Error in GetProcAddress_ContentSetDefaultParams:`n%wdxFilename%`nErrorlevel: %errorlevel%`nLast Error: %A_LastError%
   }
   getFields:=DllCall("GetProcAddress",uint,wdxFile,astr,"ContentGetSupportedField")
   if(errorlevel!=0){
    msgbox,Error in GetProcAddress_ContentGetSupportedField:`n%wdxFilename%`nErrorlevel: %errorlevel%`nLast Error: %A_LastError%
   }
   unloadPlugin:=DllCall("GetProcAddress",uint,wdxFile,astr,"ContentPluginUnloading")
   if(errorlevel!=0){
    msgbox,Error in GetProcAddress_ContentPluginUnloading:`n%wdxFilename%`nErrorlevel: %errorlevel%`nLast Error: %A_LastError%
   }
   if(setVersion!=0){
    VersionFileName := A_ScriptDir . "\contplug.ini"
    Size:=12+StrLen(VersionFileName)+1
    VarSetCapacity(VersionStruct,Size,0)
    NumPut(Size,VersionStruct,0,"Int")
    NumPut(2   ,VersionStruct,4,"UInt")
    NumPut(0   ,VersionStruct,8,"UInt")
    StrPutVar(VersionFileName,&VersionStruct+12)
    DllCall(setVersion,"uint",&VersionStruct)
    if(errorlevel!=0){
     msgbox,Error in ContentSetDefaultParams:`n%wdxFilename%`nErrorlevel: %errorlevel%`nLast Error: %A_LastError%
    }
   }
   Loop
   {
    IndexM1:=A_Index-1
    Size=1024
    FieldNameA=
    UnitsA=
    VarSetCapacity(FieldNameA,Size+1)
    VarSetCapacity(UnitsA,Size+1)
    VarSetCapacity(FieldName,(Size+1)*2)
    result:=DllCall(getFields,"int",IndexM1,"UInt",&FieldNameA,"UInt",&UnitsA,"int",Size)
    FieldName:=StrGet(&FieldNameA,"cp1252")
    if(errorlevel!=0){
     msgbox,Error in ContentGetSupportedField:`n%wdxFilename%`nErrorlevel: %errorlevel%`nLast Error: %A_LastError%
     break
    }
    if(result==0){
     break
    }
    wdxListD=%wdxListD%`n%FieldName%
   }
   if(unloadPlugin!=0){
    DllCall(unloadPlugin)
    if(errorlevel!=0){
     msgbox,Error in ContentPluginUnloading:`n%wdxFilename%`nErrorlevel: %errorlevel%`nLast Error: %A_LastError%
    }
   }
   DllCall("FreeLibrary","UInt",wdxFile)
   if(errorlevel!=0){
    msgbox,Error in FreeLibrary:`n%wdxFilename%`nErrorlevel: %errorlevel%`nLast Error: %A_LastError%
   }
  }
 }
 GuiControl 2:,C26,`n
 if(wdxListD==""){
  GuiControl 2:,C25,
 }else{
  GuiControl 2:,C26,%wdxListD%
 }
 Critical,Off
return

ListEntryChanged3:
 GuiControlGet,Value,2:,C28
 StringSplit,wdxListA,wdxListA,`n
 StringSplit,wdxListB,wdxListB,`n
 Loop %wdxListA0%
 {
  IndexM1:=A_Index-1
  ValueA:=wdxListA%A_Index%
  ValueB:=wdxListB%A_Index%
  ValueC:=wdxListC%IndexM1%
  if(ValueA==Value){
   StringSplit,ValueB,ValueB,@
   GuiControl 2:,C25,%ValueB2%
   GuiControl 2:,C27,%ValueC%`naaa
   GoSub wdxLoadFields
   Loop,parse,ValueB1,|
   {
    GuiControl 2:Choose,C26,%A_LoopField%
   }
   return
  }
 }
return

DeleteListEntry:
 ControlGetFocus,focusedControl
 if(focusedControl=="ListBox1"){
  GuiControlGet,Value,2:,C21
  if(Value!=""){
   StringLeft,Key,Value,1
   IniDelete,%A_ScriptDir%\tcmatch.ini,presets,%Key%
   StringReplace,PresetList,PresetList,`n%Value%,,All
   GuiControl 2:,C21,`n
   GuiControl 2:,C21,%PresetList%
   GuiControl,2:Choose,C21,1
   gosub ListEntryChanged1
  }
 }else if(focusedControl=="ListBox2"){
  GuiControlGet,Value,2:,C24
  if(Value!=""){
   StringReplace,ReplaceList,ReplaceList,`n%Value%
   IniDelete,%A_ScriptDir%\tcmatch.ini,replace,chars%ReplaceCount%
   ReplaceCount--
   Loop,parse,ReplaceList,`n
   {
    if(A_LoopField!=""){
     StringReplace,Value,A_LoopField,%A_Tab%,|
     Index:=A_Index-1
     IniWrite,%Value%,%A_ScriptDir%\tcmatch.ini,replace,chars%Index%
    }
   }
   GuiControl 2:,C24,`n
   GuiControl 2:,C24,%ReplaceList%
   GuiControl,2:Choose,C24,1
   gosub ListEntryChanged2
  }
 }else if(focusedControl=="ListBox4"){
  GuiControlGet,Value,2:,C28
  if(Value!=""){
   StringSplit,wdxListA,wdxListA,`n
   StringSplit,wdxListB,wdxListB,`n
   wdxListA=
   wdxListB=
   Found=0
   Loop %wdxListA0%
   {
    IndexM1:=A_Index-1
    ValueA:=wdxListA%A_Index%
    ValueB:=wdxListB%A_Index%
    if(ValueA==Value && Found==0){
     Found=1
    }else if(ValueA!=""){
     IndexM2:=IndexM1-Found
     wdxListA=%wdxListA%`n%ValueA%
     wdxListB=%wdxListB%`n%ValueB%
     IniWrite,%ValueB%,%A_ScriptDir%\tcmatch.ini,%wdx32_64%,wdx_text_plugin%IndexM2%
    }
    if(Found==1){
     wdxListC%IndexM1%:=wdxListC%A_Index%
    }
   }
   IniDelete,%A_ScriptDir%\tcmatch.ini,%wdx32_64%,wdx_text_plugin%IndexM1%
   IndexM1--
   wdxListC=
   Loop,100
   {
    B_Index=%A_Index%
    wdxListCpart=
    Loop,%IndexM1%
    {
     ValueC:=wdxListC%A_Index%
     if(B_Index==ValueC){
      if(wdxListCpart=""){
       wdxListCpart=%A_Index%
      }else{
       wdxListCpart=%wdxListCpart%,%A_Index%
      }
     }
    }
    wdxListC=%wdxListC%%wdxListCpart%|
   }
   while(SubStr(wdxListC,StrLen(wdxListC))=="|"){
    StringTrimRight,wdxListC,wdxListC,1
   }
   IniWrite,%wdxListC%,%A_ScriptDir%\tcmatch.ini,%wdx32_64%,wdx_groups
   GuiControl,2:,C28,`n
   GuiControl,2:,C28,%wdxListA%
   GuiControl,2:Choose,C28,1
   gosub ListEntryChanged3
  }
 }
return

L25:
 GuiControlGet,oldwdxfile,2:,C25
 Gui 2:+OwnDialogs
 FileSelectFile,wdxfile,3,%oldwdxfile%,%L49%,%L48% (*.%wdx32_64%)
 StringRight,wdxext,wdxfile,4
	StringRight,wdxext64,wdxfile,6
	if(FileExist(wdxfile) && (wdxext=="." . wdx32_64 || wdxext64=="." . wdx32_64)){
  GuiControl 2:,C25,%wdxfile%
  GoSub wdxLoadFields
  GuiControl 2:Choose,C26,1
 }
return

L29:
 GuiControlGet,V29,2:,C29
 V29--
 IniWrite,%V29%,%A_ScriptDir%\tcmatch.ini,wdx,debug_output
return

L30:
 GuiControlGet,V30,2:,C30
 IniWrite,%V30%,%A_ScriptDir%\tcmatch.ini,wdx,wdx_cache
return

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - close gui2
CloseGui2:
 Gui 2:Default
 Gui,hide
 QSvisible=0
 ActivateTC("^s{space}{backspace}")
 if(INI_override_search==0){
  ExitApp  
 }
return

2guiClose:
2guiEscape:
 Gui 2:Default
 Gui,hide
 QSvisible=0
 if(INI_override_search==0){
  ExitApp  
 }
return

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - exit script
; #x::
;  ExitApp
; return
; 
; #IfWinActive ahk_class TfPSPad.UnicodeClass
; F5::
;  ExitApp
; return
; #IfWinActive
