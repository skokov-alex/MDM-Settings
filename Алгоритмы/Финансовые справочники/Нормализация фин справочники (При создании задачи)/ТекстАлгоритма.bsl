// >> 1БИТ, Скоков, 02.12.2020, Задача MDM-51  
//  
// Описание алгоритма:  
// Алгоритм изменения наименования заявки и наименования задачи.  
// Вызывается при создании задачи.  
//  
// Настройки алгоритма:  
// Наименование:		Финансовые справочники (При создании задачи)  
// Область применения:	При создании задач  
//  
// Параметры передаваемые в алгоритм:  
// ОбъектОбработки		Структура - объект обработки  
// Параметры			Структура параметров  
//		ЗаявкаОбъект	БизнесПроцессОбъект.нсиЗаявкаНаИзменение - объект бизнес-процесса.  
//		ЗадачаОбъект	ЗадачаОбъект.ЗадачаИсполнителя - объект задачи.  
//		ИзменятьДанные	Булево - признак изменения данных.  
//		ТочкаМаршрутаБизнесПроцесса - точка маршрута бизнес-процесса.  
//		Отказ			Булево - признак отказа.  
  
#Область Алгоритм_изменения_наименований_заявки_и_задачи  
  
ЗаявкаОбъект = Параметры.ЗаявкаОбъект;  
  
// Получим наименование заявки  
МассивНаименования = Новый Массив;  
  
Если ЗаявкаОбъект.ИзменяемыеОбъекты.Количество() > 0  
	И ЗаявкаОбъект.ИзменяемыеОбъекты[0].Изменение Тогда  
	МассивНаименования.Добавить("Изменить");  
Иначе  
	МассивНаименования.Добавить("Создать");  
КонецЕсли;  
  
НаименованиеВидаЗаявки = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(  
ЗаявкаОбъект.ВидЗаявки, "Наименование");  
  
МассивНаименования.Добавить(НаименованиеВидаЗаявки);  
МассивНаименования.Добавить(ОбъектОбработки.Наименование);  
  
ЗаявкаОбъект.Наименование = СтрСоединить(МассивНаименования, ". ");  
  
// Получим наименование задачи  
ЗадачаОбъект = Параметры.ЗадачаОбъект;  
ШагБП = ЗадачаОбъект.нсиШагБП;  
  
Если ЗадачаОбъект.нсиОтклонена Тогда  
	НаименованиеЗадачи = "Не согласовано: " + ЗаявкаОбъект.Наименование;  
ИначеЕсли ШагБП = Перечисления.нсиШагиБП.РаспределениеЗадач Тогда  
	НаименованиеЗадачи =  ЗаявкаОбъект.Наименование;  
ИначеЕсли ШагБП = Перечисления.нсиШагиБП.ПервичнаяОбработка Тогда  
	Если ЗадачаОбъект.РольИсполнителя = ПараметрыАлгоритма.Модератор Тогда  
		НаименованиеЗадачи = ЗаявкаОбъект.Наименование;  
	Иначе  
		НаименованиеЗадачи = "Первичная обработка: " + ЗаявкаОбъект.Наименование;  
	КонецЕсли;  
ИначеЕсли ШагБП = Перечисления.нсиШагиБП.Уточнение Тогда  
	НаименованиеЗадачи = "Уточнение информации: " + ЗаявкаОбъект.Наименование;  
ИначеЕсли ШагБП = Перечисления.нсиШагиБП.Утверждение Тогда  
	НаименованиеЗадачи = "Согласовано: " + ЗаявкаОбъект.Наименование;  
Иначе  
	НаименованиеЗадачи = "Согласование: " + ЗаявкаОбъект.Наименование;  
КонецЕсли;  
  
ЗадачаОбъект.Наименование = НаименованиеЗадачи;  
  
#КонецОбласти  
// << 1БИТ, Скоков, 02.12.2020, Задача MDM-51  
  
//// >> 1БИТ, Нуртдинов, 20201212  
////Выбор исполнителя по базе подписчика и виду заявки, при уточнении информации  
//ЗаявкаСсылка = Параметры.ЗаявкаОбъект.ссылка;  
//если ЗаявкаСсылка.НадоУточнить тогда  
//	Исполнитель = "";  
//	РольПользователя = "";  
//	  
//	НаименованиеПользователя = "";  
//	если ЗаявкаСсылка.ВидЗаявки.наименование = "Нормализация данных для справочника Статьи затрат" тогда  
//		НаименованиеПользователя = "Ответственный за нормализацию по справочнику Статьи затрат";			  
//	иначеесли ЗаявкаСсылка.ВидЗаявки.наименование = "Нормализация данных для справочника Статьи движения денежных средств" тогда  
//		НаименованиеПользователя = "Ответственный за нормализацию по справочнику Статьи движения денежных средств";  
//	иначеесли ЗаявкаСсылка.ВидЗаявки.наименование = "Нормализация данных для справочника Прочие доходы и расходы" тогда  
//		НаименованиеПользователя = "Ответственный за нормализацию по справочнику Прочие доходы и расходы";  
//	конецесли;    		                                                                                 	  
//	если не НаименованиеПользователя = "" тогда	  
//	РольПользователя = справочники.РолиИсполнителей.НайтиПоНаименованию(НаименованиеПользователя,истина);  
//	если не РольПользователя = справочники.РолиИсполнителей.пустаяссылка() тогда  
//		Параметры.ЗадачаОбъект.Исполнитель = справочники.Пользователи.ПустаяСсылка();  
//		Параметры.ЗадачаОбъект.нсиСпособРаспределения = Перечисления.нсиСпособыРаспределенияЗадач.ПоРоли;  
//		Параметры.ЗадачаОбъект.РольИсполнителя = РольПользователя;  
//		Параметры.изменятьДанные = истина;  
//	иначе  
//		//ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не найден ответсвенный за уточнение информации в базе: " + пОбъект.Подписчик );      
//	Конецесли;	  
//	Конецесли;  
//конецесли;       
//// << 1БИТ, Нуртдинов, 20201212     
  //////////////////////////////////////////////   
/////////////ОТПРАВКА УВЕДОМЛЕНИЯ/////////////  
//////////////////////////////////////////////  
ТекЗадача = Параметры.ЗадачаОбъект;    
ТекЗаявка = Параметры.ЗаявкаОбъект;   
ТекТочкаБП = Параметры.ТочкаМаршрутаБизнесПроцесса;   
   
Автор = ТекЗадача.Автор;   
Исполнитель = ТекЗадача.Исполнитель;   
ПредыдущийИсполнитель = ТекЗаявка.ПредыдущийИсполнитель;   
НаименованиеЗадачи = ТекЗадача.Наименование;   
Если ПустаяСтрока(ТекЗадача.Номер) Тогда ТекЗадача.УстановитьНовыйНомер(); КонецЕсли;  
  
СтатусЗаявки = "Неопределено";   
Сообщаем = "Для данного шага не настроено оповещение, обратитесь к администратору";   
  
ОтправитьМодераторам = Ложь;  
Модераторы = Новый Массив;  
  
АвторИсполнитель = Новый Массив;  
АвторИсполнитель.Добавить(Автор);  
  
НомерЗаявки = ПрефиксацияОбъектовКлиентСервер.УдалитьЛидирующиеНулиИзНомераОбъекта(ТекЗаявка.Номер);      
НомерЗадачи = ПрефиксацияОбъектовКлиентСервер.УдалитьЛидирующиеНулиИзНомераОбъекта(ТекЗадача.Номер);  
  
ШаблонСообщения =   
"<HTML xmlns:o = ""urn:schemas-microsoft-com:office:office""><HEAD>  
|<META content=""text/html; charset=utf-8"" http-equiv=Content-Type><LINK rel=stylesheet type=text/css href=""v8help://service_book/service_style""><BASE href=""v8config://94665124-b22a-4db5-ae89-b64479ae1268/mdobject/idf77eafdc-c93d-42c8-a191-be0156e80e0e/038b5c85-fb1c-4082-9c4c-e69f8928bf3a"">  
|<META name=GENERATOR content=""MSHTML 9.00.8112.16443""></HEAD>  
|<BODY>  
|<p><font size=""3"" face=""Calibri"" color=""#1F497D"">Добрый день, _Кому_!</font></p>  
|<p>&nbsp;</p>  
|<p><font face=""Calibri"" size=""3"" color=""#1F497D"">%1</font></p>  
|<p>&nbsp;</p>  
|<p><font size=""3"" face=""Calibri"" color=""#1F497D"">  
|Номер заявки: <strong>%2</strong><br/>  
|Дата создания заявки: %3<br/>  
|Создана задача: %4 %5<br/>  
|Текущий статус заявки: <span style=""color:#ff0000""><strong>%6</strong></span><br/>  
|Текущий исполнитель: <strong>%7</strong></font></p>  
|<p>&nbsp;</p>  
|<p>&nbsp;</p>  
|<p><font size=""2"" face=""Calibri"" color=""#1F497D"">Письмо отправлено автоматической рассылкой информационной базы 1С:МДМ</font></p>  
|";  
//Параметры шаблона для СтрШаблон - 1:Сообщаем;2:НомерЗаявки;3:ДатаЗаявки;4:НомерЗадачи;5:НаименованиеЗадачи;6:СтатусЗаявки;7:Исполнитель  
  
  
ЗаписьЖурналаРегистрации("УВЕДОМЛЕНИЯ", ,,, "ШагБП: " + Строка(ТекЗадача.нсиШагБП) + " ;НомерЭтапаБП: " + Строка(ТекЗадача.нсиНомерЭтапаБП));  
  
Если ТекЗадача.нсиШагБП = Перечисления.нсиШагиБП.РаспределениеЗадач Тогда   
	  
ИначеЕсли ТекЗадача.нсиШагБП = Перечисления.нсиШагиБП.ПервичнаяОбработка Тогда   
	Если ТекЗадача.нсиНомерЭтапаБП = 1 Тогда   
		Запрос = Новый Запрос;  
		Запрос.УстановитьПараметр("БизнесПроцесс", ТекЗадача.БизнесПроцесс);   
		Запрос.УстановитьПараметр("нсиШагБП" , Перечисления.нсиШагиБП.Уточнение);  
		Запрос.Текст =   
		"ВЫБРАТЬ  
		|	1  
		|ИЗ  
		|	Задача.ЗадачаИсполнителя КАК ЗадачаИсполнителя  
		|ГДЕ  
		|	ЗадачаИсполнителя.БизнесПроцесс = &БизнесПроцесс  
		|	И ЗадачаИсполнителя.нсиШагБП = &нсиШагБП";  
		Выборка = Запрос.Выполнить().Выбрать();  
		Если Выборка.Следующий() Тогда  
			//Задача была на уточнении  
			Сообщаем = СтрШаблон("Сообщаем Вам, что Ваша заявка взята в обработку пользователем %1", Строка(Исполнитель));     
			СтатусЗаявки = "Не согласовано";     
			  
			ОтправитьМодераторам = Истина;   
			СообщаемМодераторам = СтрШаблон("Сообщаем Вам, что заявка от %1 взята в обработку пользователем %2", Строка(Автор), Строка(Исполнитель));   
			Модераторы.Добавить(Исполнитель);   
		Иначе  
			//Задача новая  
			Сообщаем = "Сообщаем Вам, что по вашему запросу зарегистрирована заявка";  
			СтатусЗаявки = "Не согласовано";   
			Исполнитель = ?(Исполнитель.Пустая(), ТекЗадача.РольИсполнителя, Исполнитель);  
			  
			ОтправитьМодераторам = Истина;  
			СообщаемМодераторам = СтрШаблон("Сообщаем Вам, что зарегистрирована заявка от %1", Строка(Автор));  
			Модераторы = нсиБизнесПроцессы.ПолучитьДопустимыхИсполнителей(ТекЗадача);  
		КонецЕсли;  
	КонецЕсли;   
ИначеЕсли ТекЗадача.нсиШагБП = Перечисления.нсиШагиБП.Обработка Тогда   
	Если ТекЗадача.нсиНомерЭтапаБП = 1 Тогда   
		Запрос = Новый Запрос;  
		Запрос.УстановитьПараметр("БизнесПроцесс", ТекЗадача.БизнесПроцесс);   
		Запрос.УстановитьПараметр("нсиШагБП" , Перечисления.нсиШагиБП.ПервичнаяОбработка);  
		Запрос.УстановитьПараметр("нсиНомерЭтапаБП", 1);   
		Запрос.Текст =   
		"ВЫБРАТЬ  
		|	ЗадачаИсполнителя.Исполнитель.Представление КАК Исполнитель  
		|ИЗ  
		|	Задача.ЗадачаИсполнителя КАК ЗадачаИсполнителя  
		|ГДЕ  
		|	ЗадачаИсполнителя.БизнесПроцесс = &БизнесПроцесс  
		|	И ЗадачаИсполнителя.нсиШагБП = &нсиШагБП  
		|	И ЗадачаИсполнителя.нсиНомерЭтапаБП = &нсиНомерЭтапаБП";  
		Выборка = Запрос.Выполнить().Выбрать();  
		Если Выборка.Следующий() Тогда  
			ПредыдущийИсполнитель = Выборка.Исполнитель;  
		КонецЕсли;  
		Сообщаем = СтрШаблон("Сообщаем Вам, что Ваша заявка направлена на согласование пользователем %1", Строка(ПредыдущийИсполнитель));  
		СтатусЗаявки = "Согласование";   
		  
		ОтправитьМодераторам = Истина;  
		СообщаемМодераторам = СтрШаблон("Сообщаем, что Вам на согласование направлена заявка от %1", Строка(Автор));  
		Модераторы.Добавить(Исполнитель);  
	ИначеЕсли ТекЗадача.нсиНомерЭтапаБП = 2 Тогда   
		Запрос = Новый Запрос;  
		Запрос.УстановитьПараметр("БизнесПроцесс", ТекЗадача.БизнесПроцесс);   
		Запрос.УстановитьПараметр("нсиШагБП" , Перечисления.нсиШагиБП.Обработка);   
		Запрос.УстановитьПараметр("нсиНомерЭтапаБП", 1);   
		Запрос.Текст =   
		"ВЫБРАТЬ  
		|	ЗадачаИсполнителя.Исполнитель.Представление КАК Исполнитель  
		|ИЗ  
		|	Задача.ЗадачаИсполнителя КАК ЗадачаИсполнителя  
		|ГДЕ  
		|	ЗадачаИсполнителя.БизнесПроцесс = &БизнесПроцесс  
		|	И ЗадачаИсполнителя.нсиШагБП = &нсиШагБП  
		|	И ЗадачаИсполнителя.нсиНомерЭтапаБП = &нсиНомерЭтапаБП";  
		Выборка = Запрос.Выполнить().Выбрать();  
		Если Выборка.Следующий() Тогда  
			ПредыдущийИсполнитель = Выборка.Исполнитель;  
		КонецЕсли;      
		Сообщаем = СтрШаблон("Сообщаем Вам, что Ваша заявка согласована пользователем %1", Строка(ПредыдущийИсполнитель));   
		СтатусЗаявки = "Согласование";   
		  
		ОтправитьМодераторам = Истина;  
		СообщаемМодераторам = СтрШаблон("Сообщаем, что Вам на согласование направлена заявка от %1", Строка(Автор));  
		Модераторы.Добавить(Исполнитель);  
	ИначеЕсли ТекЗадача.нсиНомерЭтапаБП = 3 Тогда   
		Запрос = Новый Запрос;  
		Запрос.УстановитьПараметр("БизнесПроцесс", ТекЗадача.БизнесПроцесс);   
		Запрос.УстановитьПараметр("нсиШагБП" , Перечисления.нсиШагиБП.Обработка);   
		Запрос.УстановитьПараметр("нсиНомерЭтапаБП", 2);   
		Запрос.Текст =   
		"ВЫБРАТЬ  
		|	ЗадачаИсполнителя.Исполнитель.Представление КАК Исполнитель  
		|ИЗ  
		|	Задача.ЗадачаИсполнителя КАК ЗадачаИсполнителя  
		|ГДЕ  
		|	ЗадачаИсполнителя.БизнесПроцесс = &БизнесПроцесс  
		|	И ЗадачаИсполнителя.нсиШагБП = &нсиШагБП  
		|	И ЗадачаИсполнителя.нсиНомерЭтапаБП = &нсиНомерЭтапаБП";  
		Выборка = Запрос.Выполнить().Выбрать();  
		Если Выборка.Следующий() Тогда  
			ПредыдущийИсполнитель = Выборка.Исполнитель;  
		КонецЕсли;      
		Сообщаем = СтрШаблон("Сообщаем Вам, что Ваша заявка согласована пользователем %1", Строка(ПредыдущийИсполнитель));   
		СтатусЗаявки = "Согласование";   
		  
		ОтправитьМодераторам = Истина;  
		СообщаемМодераторам = СтрШаблон("Сообщаем, что Вам на согласование направлена заявка от %1", Строка(Автор));  
		Модераторы.Добавить(Исполнитель);  
	ИначеЕсли ТекЗадача.нсиНомерЭтапаБП = 4 Тогда   
		Запрос = Новый Запрос;  
		Запрос.УстановитьПараметр("БизнесПроцесс", ТекЗадача.БизнесПроцесс);   
		Запрос.УстановитьПараметр("нсиШагБП" , Перечисления.нсиШагиБП.Обработка);   
		Запрос.УстановитьПараметр("нсиНомерЭтапаБП", 3);   
		Запрос.Текст =   
		"ВЫБРАТЬ РАЗЛИЧНЫЕ 
		|	ЗадачаИсполнителя.Исполнитель.Представление КАК Исполнитель  
		|ИЗ  
		|	Задача.ЗадачаИсполнителя КАК ЗадачаИсполнителя  
		|ГДЕ  
		|	ЗадачаИсполнителя.БизнесПроцесс = &БизнесПроцесс  
		|	И ЗадачаИсполнителя.нсиШагБП = &нсиШагБП  
		|	И ЗадачаИсполнителя.нсиНомерЭтапаБП = &нсиНомерЭтапаБП";  
		Выборка = Запрос.Выполнить().Выбрать();   
		Если Выборка.Следующий() Тогда  
			ПредыдущийИсполнитель = Выборка.Исполнитель;  
		КонецЕсли;      
		Сообщаем = СтрШаблон("Сообщаем Вам, что Ваша заявка согласована пользователем %1", Строка(ПредыдущийИсполнитель));  
		СтатусЗаявки = "Согласование";   
		  
		ОтправитьМодераторам = Истина;  
		СообщаемМодераторам = СтрШаблон("Сообщаем, что Вам на согласование направлена заявка от %1", Строка(Автор));  
		Если Модераторы.Найти(Исполнитель) = Неопределено Тогда 
			Модераторы.Добавить(Исполнитель);  
		КонецЕсли; 
	КонецЕсли;   
	  
	//Если Предыдущая задача была Уточнение у пользователя  
	Запрос = Новый Запрос;  
	Запрос.УстановитьПараметр("БизнесПроцесс", ТекЗадача.БизнесПроцесс);   
	Запрос.УстановитьПараметр("нсиШагБП" , Перечисления.нсиШагиБП.Уточнение);  
	Запрос.Текст =   
	"ВЫБРАТЬ ПЕРВЫЕ 1  
	|	ЗадачаИсполнителя.нсиШагБП КАК нсиШагБП  
	|ИЗ  
	|	Задача.ЗадачаИсполнителя КАК ЗадачаИсполнителя  
	|ГДЕ  
	|	ЗадачаИсполнителя.БизнесПроцесс = &БизнесПроцесс  
	|УПОРЯДОЧИТЬ ПО ЗадачаИсполнителя.Номер УБЫВ";  
	Выборка = Запрос.Выполнить().Выбрать();  
	Выборка.Следующий();  
	Если Выборка.нсиШагБП = Перечисления.нсиШагиБП.Уточнение Тогда  
		Сообщаем = СтрШаблон("Сообщаем Вам, что Ваша заявка направлена на согласование пользователю %1", Строка(Исполнитель)); 
	КонецЕсли;  
ИначеЕсли ТекЗадача.нсиШагБП = Перечисления.нсиШагиБП.Утверждение Тогда   
	Если ТекЗадача.нсиНомерЭтапаБП = 1 Тогда   
		Сообщаем = "Сообщаем Вам, что Ваша заявка согласована рабочей группой";   
		СтатусЗаявки = "Согласовано";   
		Исполнитель = ?(Исполнитель.Пустая(), ТекЗадача.РольИсполнителя, Исполнитель);  
		  
		ОтправитьМодераторам = Истина;  
		СообщаемМодераторам = СтрШаблон("Сообщаем Вам, что заявка от %1 согласована рабочей группой", Строка(Автор));  
		Модераторы = нсиБизнесПроцессы.ПолучитьДопустимыхИсполнителей(ТекЗадача);  
		  
		//Уведомляем рецензентов, кроме последнего  
		Запрос = Новый Запрос;  
		Запрос.УстановитьПараметр("БизнесПроцесс", ТекЗадача.БизнесПроцесс);   
		Запрос.УстановитьПараметр("нсиШагБП" , Перечисления.нсиШагиБП.Обработка);   
		Запрос.УстановитьПараметр("Автор" , Автор);   
		Запрос.Текст =   
		"ВЫБРАТЬ РАЗЛИЧНЫЕ 
		|	ЗадачаИсполнителя.Исполнитель КАК Исполнитель  
		|ИЗ  
		|	Задача.ЗадачаИсполнителя КАК ЗадачаИсполнителя  
		|ГДЕ  
		|	ЗадачаИсполнителя.БизнесПроцесс = &БизнесПроцесс  
		|	И ЗадачаИсполнителя.нсиШагБП = &нсиШагБП  
		|	И НЕ ЗадачаИсполнителя.нсиНомерЭтапаБП = 4  
		|	И НЕ ЗадачаИсполнителя.Исполнитель = &Автор";  
		Выборка = Запрос.Выполнить().Выбрать();   
		Пока Выборка.Следующий() Цикл  
			Модераторы.Добавить(Выборка.Исполнитель);  
		КонецЦикла;  
	КонецЕсли;   
ИначеЕсли ТекЗадача.нсиШагБП = Перечисления.нсиШагиБП.Уточнение Тогда   
	Сообщаем = "Сообщаем Вам, что Ваша заявка отправлена на уточнение";   
	СтатусЗаявки = "На уточнении";  
	//АвторИсполнитель.Добавить(Исполнитель);  
	// >> 1БИТ, Нуртдинов, 20201217  
	Если ТекЗаявка.НадоУточнить тогда  
		//ОбщегоНазначенияКлиентСервер.СообщитьПользователю("НадоУточнить");    
		Если значениеЗаполнено(Исполнитель) тогда  
			Если Не Автор = Исполнитель Тогда  
				АвторИсполнитель.Добавить(Исполнитель);	  
			КонецЕсли;  
		Иначе  
			пМетаданныеЗаявка = нсиДанныеЗаявок.ПолучитьМетаданные(ТекЗаявка.ВидЗаявки);  
			пОбъект = нсиДанныеЗаявок.ПолучитьОбъект(пМетаданныеЗаявка,ТекЗаявка.ссылка);				     
			Если пОбъект.Свойство("Подписчик") тогда  
				//ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Подписчик");      
				Если ТекЗаявка.ВидЗаявки.наименование = "Нормализация данных для справочника Статьи затрат" Тогда  
					НаименованиеПользователя = "Ответственный за нормализацию по справочнику Статьи затрат";			  
				ИначеЕсли ТекЗаявка.ВидЗаявки.наименование = "Нормализация данных для справочника Статьи движения денежных средств" Тогда   
					НаименованиеПользователя = "Ответственный за нормализацию по справочнику Статьи движения денежных средств";  
				ИначеЕсли ТекЗаявка.ВидЗаявки.наименование = "Нормализация данных для справочника Прочие доходы и расходы" Тогда   
					НаименованиеПользователя = "Ответственный за нормализацию по справочнику Прочие доходы и расходы";  
				КонецЕсли;      
				РольИсполнителя = справочники.РолиИсполнителей.НайтиПоНаименованию(НаименованиеПользователя, Истина);  
				Запрос = Новый Запрос;  
				Запрос.Текст =   
				"ВЫБРАТЬ РАЗЛИЧНЫЕ  
				|	БИТ_ПодписчикиПользователиИнформационнойБазы.Пользователь КАК Пользователь  
				|ИЗ  
				|	РегистрСведений.ИсполнителиЗадач КАК ИсполнителиЗадач  
				|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.БИТ_Подписчики.ПользователиИнформационнойБазы КАК БИТ_ПодписчикиПользователиИнформационнойБазы  
				|		ПО ИсполнителиЗадач.Исполнитель = БИТ_ПодписчикиПользователиИнформационнойБазы.Пользователь  
				|ГДЕ  
				|	БИТ_ПодписчикиПользователиИнформационнойБазы.Ссылка = &Ссылка  
				|	И ИсполнителиЗадач.РольИсполнителя = &РольИсполнителя  
				|	И НЕ БИТ_ПодписчикиПользователиИнформационнойБазы.Пользователь = &Автор";  
				  
				Запрос.УстановитьПараметр("Ссылка", пОбъект.Подписчик);	  
				Запрос.УстановитьПараметр("РольИсполнителя", РольИсполнителя);  
				Запрос.УстановитьПараметр("Автор", Автор);  
				  
				РезультатЗапроса = Запрос.Выполнить();  
				//ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Запрос.Выполнить()");   
				  
				ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();  
				  
				Пока ВыборкаДетальныеЗаписи.Следующий() Цикл  
					Исполнитель = ВыборкаДетальныеЗаписи.Пользователь;  
					АвторИсполнитель.Добавить(Исполнитель);  
					//ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Исполнитель);      
				КонецЦикла;			  
			КонецЕсли;   
		КонецЕсли;  
	КонецЕсли;   
	// << 1БИТ, Нуртдинов, 20201217  
КонецЕсли;   
  
//ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекЗадача.нсиШагБП);  
  
УстановитьПривилегированныйРежим(Истина);      
  
ПараметрыПисьма = Новый Структура;      
Если ТипЗнч(ТекЗадача.БизнесПроцесс) = Тип("БизнесПроцессСсылка.нсиЗаявкаНаИзменение") Тогда       
	ПараметрыПисьма.Вставить("Тема", СтрШаблон("1С:НСИ Заявка №%1 на обработку. Статус: %2", НомерЗаявки, СтатусЗаявки));  
ИначеЕсли ТипЗнч(ТекЗадача.БизнесПроцесс)<>Тип("БизнесПроцессСсылка.Задание") Тогда       
	ПараметрыПисьма.Вставить("Тема", СтрШаблон("1С:НСИ Справочник ""%1"": Заявка №%2 на обработку. Статус: %3", ТекЗадача.Бизнеспроцесс.ИмяСправочника, НомерЗаявки, СтатусЗаявки));  
Иначе      
	ПараметрыПисьма.Вставить("Тема", "1С:НСИ Задание на изменение вспомогательного справочника");      
КонецЕсли;      
  
ТелоПисьма = СтрШаблон(ШаблонСообщения, Сообщаем, НомерЗаявки, ТекЗаявка.Дата, НомерЗадачи, ТекЗадача.Наименование, СтатусЗаявки, Строка(Исполнитель));  
  
ПараметрыПисьма.Вставить("ТипТекста", Перечисления.ТипыТекстовЭлектронныхПисем.HTML);  
ПараметрыПисьма.Вставить("Тело", ТелоПисьма);      
  
ПараметрыУведомления = Новый Структура;  
ПараметрыУведомления.Вставить("ПараметрыПисьма", ПараметрыПисьма);   
ПараметрыУведомления.Вставить("Получатели", АвторИсполнитель);  
  
ВыполнитьАлгоритм(ПараметрыАлгоритма.Параметр1, ОбъектОбработки, ПараметрыУведомления);   
  
Если ОтправитьМодераторам Тогда  
	ПараметрыПисьма = Новый Структура;      
	Если ТипЗнч(ТекЗадача.БизнесПроцесс) = Тип("БизнесПроцессСсылка.нсиЗаявкаНаИзменение") Тогда       
		ПараметрыПисьма.Вставить("Тема", СтрШаблон("1С:НСИ Заявка №%1 на обработку. Статус: %2", НомерЗаявки, СтатусЗаявки));  
	ИначеЕсли ТипЗнч(ТекЗадача.БизнесПроцесс)<>Тип("БизнесПроцессСсылка.Задание") Тогда       
		ПараметрыПисьма.Вставить("Тема", СтрШаблон("1С:НСИ Справочник ""%1"": Заявка №%2 на обработку. Статус: %3", ТекЗадача.Бизнеспроцесс.ИмяСправочника, НомерЗаявки, СтатусЗаявки));  
	Иначе      
		ПараметрыПисьма.Вставить("Тема", "1С:НСИ Задание на изменение вспомогательного справочника");      
	КонецЕсли;      
	  
	ТелоПисьма = СтрШаблон(ШаблонСообщения, СообщаемМодераторам, НомерЗаявки, ТекЗаявка.Дата, НомерЗадачи, ТекЗадача.Наименование, СтатусЗаявки, Строка(Исполнитель));  
	  
	ПараметрыПисьма.Вставить("ТипТекста", Перечисления.ТипыТекстовЭлектронныхПисем.HTML);  
	ПараметрыПисьма.Вставить("Тело", ТелоПисьма);      
	  
	ПараметрыУведомления = Новый Структура;  
	ПараметрыУведомления.Вставить("ПараметрыПисьма", ПараметрыПисьма);   
	ПараметрыУведомления.Вставить("Получатели", Модераторы);  
	  
	ВыполнитьАлгоритм(ПараметрыАлгоритма.Параметр1, ОбъектОбработки, ПараметрыУведомления);    
КонецЕсли;  
  
УстановитьПривилегированныйРежим(Ложь);   

