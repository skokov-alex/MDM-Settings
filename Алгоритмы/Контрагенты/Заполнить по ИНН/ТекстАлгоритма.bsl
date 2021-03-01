//БИТ.AKU.28.11.2020   
   
Объект = Параметры.Форма;      
Форма = Параметры.Форма;      
ПараметрыТекущегоАлгоритма = нсиАлгоритмыОбработкиДанныхЗаявокСервер.ПолучитьПараметрыАлгоритма(Параметры.Алгоритм);    
    
ТекИНН = Объект.ИНН;    
Пока СтрНайти(ТекИНН, " ") > 0 цикл    
	ТекИНН = СтрЗаменить(ТекИНН, " ", "");     
КонецЦикла;    
Объект.ИНН = ТекИНН;    
    
ОповещатьОбОшибке = Истина;    
    
ЭтоЮЛ = Ложь; ЭтоГО = Ложь; ЭтоИП = Ложь; ЭтоОП = Ложь; ЭтоФилиал = Ложь; ЭтоВозврат = Ложь;    
ВидКонтрагента = Строка(Параметры.Форма.Вид_контрагента);    
Если ВидКонтрагента = "Государственный орган" Тогда    
	ЭтоЮЛ = Истина;    
	ЭтоГО = Истина;    
ИначеЕсли ВидКонтрагента = "Юридическое лицо" Тогда    
	ЭтоЮЛ = Истина;    
ИначеЕсли ВидКонтрагента = "Индивидуальный предприниматель" Тогда    
	ЭтоИП = Истина;    
ИначеЕсли ВидКонтрагента = "Физическое лицо" Тогда    
	ПоказатьПредупреждение(, НСтр("ru='Реквизиты физических лиц заполняются вручную.'"));    
	ЭтоВозврат = Истина;    
ИначеЕсли ВидКонтрагента = "Обособленное подразделение"     
	ИЛИ ВидКонтрагента = "Филиал" Тогда    
	ЭтоЮЛ = Истина;    
	ЭтоОП = Истина;    
Иначе	    
	ПоказатьПредупреждение(, НСтр("ru='Вид контрагента не заполнен. Заполнение не возможно.'"));    
	ЭтоВозврат = Истина;    
КонецЕсли;    
    
Если НЕ ЭтоЮЛ И НЕ ЭтоИП Тогда       
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Заполнение реквизитов данного Вида контрагента из ЕГРЮЛ/ЕГРИП не поддерживается.",,,"Вид_контрагента");   //ЮрФизЛицо    
	ЭтоВозврат = Истина;    
//ИначеЕсли Параметры.Форма.Страна_регистрации <> ПредопределенноеЗначение("Справочник.СтраныМира.Россия") Тогда    
//	ПоказатьПредупреждение(, НСтр("ru='Автоматически заполняются только реквизиты российских контрагентов.'"));    
//	ЭтоВозврат = Истина;    
КонецЕсли;    
    
Если НЕ ЭтоВозврат Тогда       
	ТекстПроверкиИНН = "";       
	//БИТ.AKU.26.11.2020 Эта проверка будет внутри функции БИТ_АлгоритмыСервер.ДанныеКонтрагентаПоИНН    
	//Если РегламентированныеДанныеКлиентСервер.ИННСоответствуетТребованиям(Объект.ИНН, ЭтоЮЛ, ТекстПроверкиИНН) Тогда      
    
		ПараметрыФормирования = Новый Структура;    
		ПараметрыФормирования.Вставить("ИНН", Объект.ИНН);    
		ПараметрыФормирования.Вставить("ЭтоЮЛ", ЭтоЮЛ);    
		    
		АдресХранилища = БИТ_АлгоритмыСервер.ДанныеКонтрагентаПоИНН(ПараметрыФормирования, Новый УникальныйИдентификатор()); // нсиПолучениеДанныхПоИНН    
		Если АдресХранилища <> неопределено Тогда    
			РеквизитыКонтрагента = ПолучитьИзВременногоХранилища(АдресХранилища);    
			Если РеквизитыКонтрагента <> Неопределено Тогда      
				Если ЗначениеЗаполнено(РеквизитыКонтрагента.ОписаниеОшибки) Тогда      
					    
					Если ПустаяСтрока(РеквизитыКонтрагента.ОписаниеОшибки) Тогда      
						ТекстПредупреждения = НСтр("ru='При получении данных ЕГРЮЛ\ЕГРИП произошла неизвестная ошибка.'");      
					ИначеЕсли РеквизитыКонтрагента.ОписаниеОшибки = "НеУказаныПараметрыАутентификации" Тогда      
						ТекстПредупреждения = НСтр("ru='Не указаны параметры аутентификации сервиса получения данных по ИНН.'");      
					ИначеЕсли РеквизитыКонтрагента.ОписаниеОшибки = "НеУказанПароль" Тогда      
						ТекстПредупреждения = НСтр("ru='Не указан пароль для доступа к сервису получения данных по ИНН'");      
					ИначеЕсли СтрЧислоВхождений(ВРЕГ(РеквизитыКонтрагента.ОписаниеОшибки),"НЕ УДАЛОСЬ НАЙТИ ДАННЫЕ ДЛЯ ЗАПОЛНЕНИЯ РЕКВИЗИТОВ") > 0 Тогда      
						ТекстПредупреждения = НСтр("ru = 'Выполнен запрос к базе ЕГРЮЛ\ЕГРИП.'") + " " + РеквизитыКонтрагента.ОписаниеОшибки;      
					Иначе      
						ТекстПредупреждения = РеквизитыКонтрагента.ОписаниеОшибки;      
					КонецЕсли;      
					    
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстПредупреждения);       
					    
				Иначе      
					// Если ИНН корректный, но указан не тот вид контрагента    
					Если РеквизитыКонтрагента.ПроизошлаЗамена Тогда    
						Если ПараметрыФормирования.ЭтоЮЛ = Ложь Тогда    
							ЭтоЮЛ = Истина;    
							ЭтоИП = Ложь;    
							РеквизитыКонтрагента.Вставить("НовыйВидКонтрагента", ПараметрыТекущегоАлгоритма.ЮрЛицо);    
						Иначе	    
							ЭтоЮЛ = Ложь;    
							ЭтоИП = Истина;    
							РеквизитыКонтрагента.Вставить("НовыйВидКонтрагента", ПараметрыТекущегоАлгоритма.Предприниматель);    
						КонецЕсли;   
					Иначе	    
						РеквизитыКонтрагента.Вставить("НовыйВидКонтрагента", неопределено);    
					КонецЕсли;    
					// НАЧАЛО Подготовка данных для сравнения       
					ДанныеОбъекта = Новый Структура;      
					ДанныеОбъекта.Вставить("КПП"                    	, Объект.КПП);     
					ДанныеОбъекта.Вставить("Наименование"        	   , Объект.Наименование);     
					ДанныеОбъекта.Вставить("НаименованиеПолное"			, Объект.ПолноеНаименование);      
					ДанныеОбъекта.Вставить("Полное_наименование_ЕГРЮЛ"	, Объект.Полное_наименование_ЕГРЮЛ);      
					ДанныеОбъекта.Вставить("ЮридическийАдрес"       	, "");      
					//ДанныеОбъекта.Вставить("Телефон"                	, "");    
					ДанныеОбъекта.Вставить("ОГРН"                   	, Объект.ОГРН);    
					ДанныеОбъекта.Вставить("ДатаРегистрации"			, Объект.ДатаРегистрации);      
					Если ЭтоИП тогда    
						ДанныеОбъекта.Вставить("СвидетельствоСерияНомер", Объект.СвидетельствоСерияНомер);    
						ДанныеОбъекта.Вставить("СвидетельствоДатаВыдачи", Объект.СвидетельствоДатаВыдачи);    
					КонецЕсли;	    
//БИТ.AKU.26.01.2021 ->					    
//					// Данные телефона.      
//					Отбор = Новый Структура("Вид", ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.ТелефонКонтрагента"));      
//					ДанныеКонтактнойИнформации = Объект.КонтактнаяИнформацияОписаниеДополнительныхРеквизитов.НайтиСтроки(Отбор);      
//					Если ДанныеКонтактнойИнформации.ВГраница() > -1 Тогда      
//						ДанныеОбъекта.Телефон = ДанныеКонтактнойИнформации[0].Представление;      
//					КонецЕсли;      
//<-   
					// Данные юридического адреса.      
					Отбор = Новый Структура("Вид", ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.ЮрАдресКонтрагента"));      
					ДанныеКонтактнойИнформации = Объект.КонтактнаяИнформацияОписаниеДополнительныхРеквизитов.НайтиСтроки(Отбор);      
					Для Каждого Строка Из ДанныеКонтактнойИнформации Цикл      
						Если ЗначениеЗаполнено(Строка.ИмяРеквизита) Тогда       
							ДанныеОбъекта.ЮридическийАдрес = Строка.Представление;      
						КонецЕсли;      
					КонецЦикла;      
					//ДанныеОбъекта.Вставить("ОрганизационноПравоваяФорма", ?(ЗначениеЗаполнено(Объект.ОрганизационноПравоваяФорма), Объект.ОрганизационноПравоваяФорма, Неопределено));      
					// КОНЕЦ Подготовка данных для сравнения    
					    
					    
					// НАЧАЛО Сравнение данных     
					РезультатСравнения = Новый Структура("ЕстьИзменения, ЕстьИзмененияВЗаполненныхРеквизитах, СопоставлениеРеквизитов", Ложь, Ложь,Новый Массив);      
					    
					Если РеквизитыКонтрагента.Свойство("ДатаРегистрации") Тогда       
						Если НЕ РеквизитыКонтрагента.ДатаРегистрации = ДанныеОбъекта.ДатаРегистрации Тогда      
							РезультатСравнения.ЕстьИзменения = Истина;      
							Если ЗначениеЗаполнено(ДанныеОбъекта.ДатаРегистрации) Тогда      
								РезультатСравнения.ЕстьИзмененияВЗаполненныхРеквизитах = Истина;      
							КонецЕсли;      
						КонецЕсли;      
						    
						РезультатСравнения.СопоставлениеРеквизитов.Добавить(      
							новый Структура(      
								"Реквизит,Синоним,Значение,НовоеЗначение",      
								"ДатаРегистрации", "Дата регистрации", ДанныеОбъекта.ДатаРегистрации, РеквизитыКонтрагента.ДатаРегистрации)      
						);      
					КонецЕсли;      
					    
					СвидетельствоОРегистрации = Неопределено;    
					Если ЭтоИП И РеквизитыКонтрагента.Свойство("СвидетельствоОРегистрации", СвидетельствоОРегистрации) Тогда    
						Если СвидетельствоОРегистрации = Неопределено Тогда    
						    НовоеСвидетельство = "";    
						Иначе    
							НовоеСвидетельство = ""    
							//--> Изменил Стрючков, Datareon, 03.06.2020      
								+ СвидетельствоОРегистрации.Серия + " " + СвидетельствоОРегистрации.Номер    
							//<-- Изменил Стрючков, Datareon, 03.06.2020      
								+ ?(ЗначениеЗаполнено(СвидетельствоОРегистрации.Дата), " от " + Формат(СвидетельствоОРегистрации.Дата, "ДФ=dd.MM.yyyy"), "");    
						КонецЕсли;    
						СтароеСвидетельство = ""     
							+ ДанныеОбъекта.СвидетельствоСерияНомер     
							+ ?(ЗначениеЗаполнено(ДанныеОбъекта.СвидетельствоДатаВыдачи), " от " + Формат(ДанныеОбъекта.СвидетельствоДатаВыдачи, "ДФ=dd.MM.yyyy"), "");     
						    
						Если НЕ НовоеСвидетельство = СтароеСвидетельство Тогда      
							РезультатСравнения.ЕстьИзменения = Истина;      
							Если ЗначениеЗаполнено(ДанныеОбъекта.ОГРН) Тогда      
								РезультатСравнения.ЕстьИзмененияВЗаполненныхРеквизитах = Истина;      
							КонецЕсли;      
						КонецЕсли;      
						    
						РезультатСравнения.СопоставлениеРеквизитов.Добавить(      
							новый Структура(      
								"Реквизит,Синоним,Значение,НовоеЗначение",      
								"СвидетельствоОРегистрации", "Свидетельство о регистрации", СтароеСвидетельство, НовоеСвидетельство      
							)      
						);      
					КонецЕсли;      
					    
					Если РеквизитыКонтрагента.Свойство("РегистрационныйНомер") Тогда       
						Если НЕ РеквизитыКонтрагента.РегистрационныйНомер = ДанныеОбъекта.ОГРН Тогда      
							РезультатСравнения.ЕстьИзменения = Истина;      
							Если ЗначениеЗаполнено(ДанныеОбъекта.ОГРН) Тогда      
								РезультатСравнения.ЕстьИзмененияВЗаполненныхРеквизитах = Истина;      
							КонецЕсли;      
						КонецЕсли;      
						    
						Если ЭтоИП тогда    
							Синоним = "ОГРНИП";    
						Иначе     
							Синоним = "ОГРН";    
						КонецЕсли;	    
						    
						РезультатСравнения.СопоставлениеРеквизитов.Добавить(      
							новый Структура(      
								"Реквизит,Синоним,Значение,НовоеЗначение",      
								"ОГРН", Синоним, ДанныеОбъекта.ОГРН, РеквизитыКонтрагента.РегистрационныйНомер      
							)      
						);      
					КонецЕсли;      
					    
					Если РеквизитыКонтрагента.Свойство("КПП") Тогда       
						Если НЕ РеквизитыКонтрагента.КПП = ДанныеОбъекта.КПП Тогда      
							РезультатСравнения.ЕстьИзменения = Истина;      
							Если ЗначениеЗаполнено(ДанныеОбъекта.КПП) Тогда      
								РезультатСравнения.ЕстьИзмененияВЗаполненныхРеквизитах = Истина;      
							КонецЕсли;      
						КонецЕсли;      
						    
						РезультатСравнения.СопоставлениеРеквизитов.Добавить(      
							новый Структура(      
								"Реквизит,Синоним,Значение,НовоеЗначение",      
								"КПП", "КПП", ДанныеОбъекта.КПП, РеквизитыКонтрагента.КПП      
							)      
						);      
					КонецЕсли;      
					    
					Если РеквизитыКонтрагента.Свойство("ОрганизационноПравоваяФорма") Тогда       
						Если НЕ РеквизитыКонтрагента.ОрганизационноПравоваяФорма = ДанныеОбъекта.ОрганизационноПравоваяФорма Тогда      
							РезультатСравнения.ЕстьИзменения = Истина;      
							Если ЗначениеЗаполнено(ДанныеОбъекта.ОрганизационноПравоваяФорма) Тогда      
								РезультатСравнения.ЕстьИзмененияВЗаполненныхРеквизитах = Истина;      
							КонецЕсли;      
						КонецЕсли;      
						    
						РезультатСравнения.СопоставлениеРеквизитов.Добавить(      
							новый Структура(      
								"Реквизит,Синоним,Значение,НовоеЗначение",      
								"ОрганизационноПравоваяФорма","Организационно-правовая форма",ДанныеОбъекта.ОрганизационноПравоваяФорма,РеквизитыКонтрагента.ОрганизационноПравоваяФорма      
							)      
						);      
					КонецЕсли;      
					    
					Если РеквизитыКонтрагента.Свойство("Наименование")    
						И РеквизитыКонтрагента.Свойство("НаименованиеСокращенное") Тогда        
						Если ЭтоОП Тогда    
							Если ЗначениеЗаполнено(Объект.Головной_контрагент) Тогда    
								Наименование = нсиОбщегоНазначения.ПолучитьЗначениеРеквизита(Объект.Головной_контрагент, "Наименование") +   
								" ОСП " + РеквизитыКонтрагента.НаименованиеСокращенное;   
							Иначе	   
								Наименование = "ОСП " + РеквизитыКонтрагента.НаименованиеСокращенное;   
							КонецЕсли;    
						ИначеЕсли ЭтоФилиал Тогда    
							Если ЗначениеЗаполнено(Объект.Головной_контрагент) Тогда    
								Наименование = нсиОбщегоНазначения.ПолучитьЗначениеРеквизита(Объект.Головной_контрагент, "Наименование") +   
								" Филиал " + РеквизитыКонтрагента.НаименованиеСокращенное;       
							Иначе	   
								Наименование = "Филиал " + РеквизитыКонтрагента.НаименованиеСокращенное;       
							КонецЕсли;    
						ИначеЕсли ЭтоИП Тогда    
							Наименование = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(    
							НСтр("ru='%1 %2 %3'"),     
							РеквизитыКонтрагента.Фамилия,    
							РеквизитыКонтрагента.Имя,    
							РеквизитыКонтрагента.Отчество);    
						Иначе     
							Наименование = РеквизитыКонтрагента.НаименованиеСокращенное;    
							Поз = СтрНайти(Наименование, """");    
							Если Поз > 0 И Поз <= 10 Тогда    
								Наименование = СокрП(Сред(Наименование, Поз)) + " " + СокрП(Лев(Наименование, Поз-1));    
								Наименование = СтрЗаменить(Наименование, """", "");    
							КонецЕсли;    
							Наименование = СокрЛП(Наименование);    
						КонецЕсли;    
						   
						Если НЕ Наименование = ДанныеОбъекта.Наименование Тогда      
							РезультатСравнения.ЕстьИзменения = Истина;      
							Если ЗначениеЗаполнено(ДанныеОбъекта.Наименование) Тогда      
								РезультатСравнения.ЕстьИзмененияВЗаполненныхРеквизитах = Истина;      
							КонецЕсли;      
						КонецЕсли;      
						    
						РезультатСравнения.СопоставлениеРеквизитов.Добавить(      
						новый Структура(      
						"Реквизит,Синоним,Значение,НовоеЗначение",      
						"Наименование","Наименование",ДанныеОбъекта.Наименование,Наименование    
						)      
						);    
											      
					КонецЕсли;      
				    
					Если РеквизитыКонтрагента.Свойство("НаименованиеСокращенное")    
						И НЕ (ЭтоОП ИЛИ ЭтоФилиал) Тогда        
						Если НЕ РеквизитыКонтрагента.НаименованиеСокращенное = ДанныеОбъекта.НаименованиеПолное Тогда      
							РезультатСравнения.ЕстьИзменения = Истина;      
							Если ЗначениеЗаполнено(ДанныеОбъекта.НаименованиеПолное) Тогда      
								РезультатСравнения.ЕстьИзмененияВЗаполненныхРеквизитах = Истина;      
							КонецЕсли;      
						КонецЕсли;      
						    
						РезультатСравнения.СопоставлениеРеквизитов.Добавить(      
						новый Структура(      
						"Реквизит,Синоним,Значение,НовоеЗначение",      
						"НаименованиеПолное","Полное наименование",ДанныеОбъекта.НаименованиеПолное,РеквизитыКонтрагента.НаименованиеСокращенное      
						)      
						);    
						      
					КонецЕсли;      
					    
					Если РеквизитыКонтрагента.Свойство("НаименованиеПолное")    
						И ЭтоЮЛ И НЕ ЭтоОП Тогда        
						Если НЕ РеквизитыКонтрагента.НаименованиеПолное = ДанныеОбъекта.Полное_наименование_ЕГРЮЛ Тогда      
							РезультатСравнения.ЕстьИзменения = Истина;      
							Если ЗначениеЗаполнено(ДанныеОбъекта.Полное_наименование_ЕГРЮЛ) Тогда      
								РезультатСравнения.ЕстьИзмененияВЗаполненныхРеквизитах = Истина;      
							КонецЕсли;      
						КонецЕсли;      
						    
						РезультатСравнения.СопоставлениеРеквизитов.Добавить(      
						новый Структура(      
						"Реквизит,Синоним,Значение,НовоеЗначение",      
						"Полное_наименование_ЕГРЮЛ","Полное наименование ЕГРЮЛ",ДанныеОбъекта.Полное_наименование_ЕГРЮЛ,РеквизитыКонтрагента.НаименованиеПолное    
						)      
						);      
					КонецЕсли;      
		    
//БИТ.AKU.26.01.2021 ->					    
//					Если РеквизитыКонтрагента.Свойство("Телефон")       
//						И НЕ РеквизитыКонтрагента.Телефон = Неопределено Тогда      
//						    
//						Если РеквизитыКонтрагента.Телефон.Представление <> ДанныеОбъекта.Телефон Тогда      
//							    
//							РезультатСравнения.ЕстьИзменения = Истина;      
//							Если ЗначениеЗаполнено(ДанныеОбъекта.Телефон) Тогда      
//								РезультатСравнения.ЕстьИзмененияВЗаполненныхРеквизитах = Истина;      
//							КонецЕсли;      
//						КонецЕсли;      
//						    
//						РезультатСравнения.СопоставлениеРеквизитов.Добавить(      
//							новый Структура(      
//								"Реквизит,Синоним,Значение,НовоеЗначение",      
//								"Телефон","Телефон",ДанныеОбъекта.Телефон,РеквизитыКонтрагента.Телефон.Представление      
//							)      
//						);      
//						    
//					КонецЕсли;      
//<-   
					    
					Если РеквизитыКонтрагента.Свойство("ЮридическийАдрес")      
						И НЕ РеквизитыКонтрагента.ЮридическийАдрес = Неопределено Тогда      
						    
						Если РеквизитыКонтрагента.ЮридическийАдрес.Представление <> ДанныеОбъекта.ЮридическийАдрес Тогда      
							    
							РезультатСравнения.ЕстьИзменения = Истина;      
							Если ЗначениеЗаполнено(ДанныеОбъекта.ЮридическийАдрес) Тогда      
								РезультатСравнения.ЕстьИзмененияВЗаполненныхРеквизитах = Истина;      
							КонецЕсли;      
							    
						КонецЕсли;      
						    
						РезультатСравнения.СопоставлениеРеквизитов.Добавить(      
						новый Структура(      
						"Реквизит,Синоним,Значение,НовоеЗначение",      
						"ЮридическийАдрес","Юридический адрес",ДанныеОбъекта.ЮридическийАдрес,РеквизитыКонтрагента.ЮридическийАдрес.Представление)    
						);      
					    
					КонецЕсли;      
					// КОНЕЦ Сравнение данных     
					    
					Если РезультатСравнения.ЕстьИзменения Тогда      
						ПараметрыОповещения = новый Структура(      
							"Форма,Алгоритм,Заявка,РеквизитыКонтрагента",      
								Параметры.Форма,      
								Параметры.Алгоритм,      
								?(ТипЗнч(Параметры.Форма.Объект.Ссылка)=Тип("ЗадачаСсылка.ЗадачаИсполнителя"),Параметры.Форма.Задание,Параметры.Форма.Объект),      
								РеквизитыКонтрагента      
						);      
						    
						ОписаниеОповещения = новый ОписаниеОповещения(      
							"ОбработкаОповещения",      
							нсиАлгоритмыОбработкиДанныхЗаявокКлиентСервер,ПараметрыОповещения      
						);      
						    
						ПараметрыФормы = Новый Структура("СопоставлениеРеквизитов,РазрешитьОбновлять",РезультатСравнения.СопоставлениеРеквизитов,Истина);      
						    
						ОткрытьФорму(      
							"ОбщаяФорма.нсиФормаПодтвержденияИзмененияДанныхКонтрагентаПоЕГРЮЛ",      
							ПараметрыФормы,      
							Параметры.Форма,,,,      
							ОписаниеОповещения,      
							РежимОткрытияОкнаФормы.БлокироватьОкноВладельца      
						);      
					Иначе       
						ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Данные соответсвуют ЕГРЮЛ\ЕГРИП. Изменения не требуется.");	      
					КонецЕсли;      
				КонецЕсли;      
			КонецЕсли;      
		КонецЕсли;    
	//КонецЕсли;    
КонецЕсли;    

