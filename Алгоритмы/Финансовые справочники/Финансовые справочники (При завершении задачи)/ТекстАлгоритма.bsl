// >> 1БИТ, Нуртдинов, 20210118 
//Отклоненные заявки на нормализацию отправляют в базу подписчик "Кс_неактуально = истина"
Если Параметры.результат = Перечисления.нсиРезультатыВыполненияЗадач.Отклонена тогда 
	Запрос = Новый Запрос; 
	Запрос.Текст =  
		"ВЫБРАТЬ 
		|	БИТ_ВидыЗаявокДляНормализации.ВидЗаявки КАК ВидЗаявки 
		|ИЗ 
		|	РегистрСведений.БИТ_ВидыЗаявокДляНормализации КАК БИТ_ВидыЗаявокДляНормализации 
		|ГДЕ 
		|	БИТ_ВидыЗаявокДляНормализации.ВидЗаявки = &ВидЗаявки"; 
	 
	Запрос.УстановитьПараметр("ВидЗаявки", Параметры.ЗаявкаОбъект.ВидЗаявки); 
	 
	РезультатЗапроса = Запрос.Выполнить(); 
	Если не РезультатЗапроса.Пустой() тогда 
		пМетаданныеЗаявка = нсиДанныеЗаявок.ПолучитьМетаданные(Параметры.ЗаявкаОбъект.ВидЗаявки); 
		пОбъект = нсиДанныеЗаявок.ПолучитьОбъект(пМетаданныеЗаявка, Параметры.ЗаявкаОбъект.ссылка);		 
		Если пОбъект.Свойство("Кс_неактуально") и пОбъект.Кс_неактуально тогда        
	 		БИТ_ФормированиеСообщений.СоздатьСообщениеНеАктуальноВБазуПодписчик(Параметры.ЗаявкаОбъект.ВидЗаявки.изменяемыеДанные[0].тип2, пОбъект.GUID, пОбъект.Подписчик); 
		конецесли; 
		 
	КонецЕсли; 
 
Конецесли; 
// << 1БИТ, Нуртдинов, 20210118

// >> 1БИТ, Скоков, 18.01.2021, Задача MDM-51
//
// Описание алгоритма:
// 		Алгоритм изменения наименования заявки и наименования задачи.
// 		Вызывается при завершении задачи.
//
// Настройки алгоритма:
// 		Наименование			Финансовые справочники (При завершения задачи)
// 		Область применения		Обработка завершения задач БП
//
// Параметры передаваемые в алгоритм:
// 		ОбъектОбработки			- Структура - объект обработки
//		Параметры.ЗаявкаОбъект	- БизнесПроцессОбъект.нсиЗаявкаНаИзменение - объект бизнес-процесса.
//		Параметры.ЗадачаОбъект	- ЗадачаОбъект.ЗадачаИсполнителя - объект задачи.
//		Параметры.ИзменятьДанные - Булево - признак изменения данных.
//		Параметры.Результат 	- ПеречислениеСсылка.нсиРезультатыВыполненияЗадач, Произвольный - ссылка на перечисление.
//		Параметры.Отказ 		- Булево - признак отказа.

Если НЕ Параметры.Отказ Тогда
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
	
	ШагБПОбработкаКонтрагенты = (НаименованиеВидаЗаявки = "Контрагенты" ИЛИ НаименованиеВидаЗаявки = "Контрагенты Группа")
		И ШагБП = Перечисления.нсиШагиБП.Обработка;
	
	РезультатВыполненияЗадачи = Неопределено;
	Параметры.Свойство("Результат", РезультатВыполненияЗадачи);
	
	Если ЗадачаОбъект.нсиОтклонена Тогда
		НаименованиеЗадачи = "Не согласовано: " + ЗаявкаОбъект.Наименование;
	ИначеЕсли РезультатВыполненияЗадачи = Перечисления.нсиРезультатыВыполненияЗадач.ЗапрошеноУточнение Тогда
		// В случае запроса уточнения, наименование задачи не изменяем
		НаименованиеЗадачи = ЗадачаОбъект.Наименование;
	ИначеЕсли ШагБП = Перечисления.нсиШагиБП.РаспределениеЗадач Тогда
		НаименованиеЗадачи = ЗаявкаОбъект.Наименование;
	ИначеЕсли ШагБП = Перечисления.нсиШагиБП.ПервичнаяОбработка ИЛИ ШагБПОбработкаКонтрагенты Тогда
		Если ЗадачаОбъект.РольИсполнителя = ПараметрыАлгоритма.Модератор Тогда
			НаименованиеЗадачи = ЗаявкаОбъект.Наименование;
		Иначе
			НаименованиеЗадачи = "Первичная обработка: " + ЗаявкаОбъект.Наименование;
		КонецЕсли;
	ИначеЕсли ШагБП = Перечисления.нсиШагиБП.Уточнение
		И РезультатВыполненияЗадачи = Перечисления.нсиРезультатыВыполненияЗадач.Выполнена Тогда
		Если СтрНачинаетсяС(ЗадачаОбъект.Наименование, "Уточнение информации:") Тогда
			НаименованиеЗадачи = "Информация уточнена: " + ЗаявкаОбъект.Наименование;
		КонецЕсли;
	ИначеЕсли ЗадачаОбъект.РезультатВыполнения = "автоматически" Тогда
		НаименованиеЗадачи = "Автосогласовано: " + ЗаявкаОбъект.Наименование;
	Иначе
		НаименованиеЗадачи = "Согласовано: " + ЗаявкаОбъект.Наименование;
	КонецЕсли;
	
	ЗадачаОбъект.Наименование = НаименованиеЗадачи;
КонецЕсли;
// << 1БИТ, Скоков, 18.01.2021, Задача MDM-51 
 
////////////////////////////////////////////// 
///////////ОТПРАВКА УВЕДОМЛЕНИЙ/////////////// 
////////////////////////////////////////////// 
ТекЗадача = Параметры.ЗадачаОбъект;   
ТекЗаявка = Параметры.ЗаявкаОбъект;  
ТекТочкаБП = ТекЗадача.ТочкаМаршрута;  
 
Автор = ТекЗадача.Автор;  
Исполнитель = ТекЗадача.Исполнитель;  
ПредыдущийИсполнитель = ТекЗаявка.ПредыдущийИсполнитель;  
НаименованиеЗадачи = ТекЗадача.Наименование;  
 
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
 
УстановитьПривилегированныйРежим(Истина);      
 
Если ТекЗадача.нсиРезультат = Перечисления.нсиРезультатыВыполненияЗадач.Отклонена Тогда  
	Сообщаем = СтрШаблон("Сообщаем Вам, что Ваша заявка отклонена %1 по причине %2", Строка(Исполнитель), ТекЗадача.РезультатВыполнения); 
	СтатусЗаявки = "Отклонено"; 
		 
	//Модератору не отправляем  
	ОтправитьМодераторам = Истина;  
	СообщаемМодераторам = СтрШаблон("Сообщаем Вам, что заявка %1 отклонена %2 по причине %3", Строка(Автор), Строка(Исполнитель), ТекЗадача.РезультатВыполнения); 
	 
	Запрос = Новый Запрос;   
	Запрос.УстановитьПараметр("БизнесПроцесс", ТекЗадача.БизнесПроцесс);    
	Запрос.УстановитьПараметр("Автор", Автор);  
	Запрос.УстановитьПараметр("Исполнитель", ТекЗадача.Исполнитель);  
	Запрос.Текст =    
	"ВЫБРАТЬ РАЗЛИЧНЫЕ  
	|	ЗадачаИсполнителя.Исполнитель КАК Исполнитель   
	|ИЗ   
	|	Задача.ЗадачаИсполнителя КАК ЗадачаИсполнителя   
	|ГДЕ   
	|	ЗадачаИсполнителя.БизнесПроцесс = &БизнесПроцесс  
	|	И ЗадачаИсполнителя.Выполнена  
	|	И НЕ ЗадачаИсполнителя.Исполнитель = ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)   
	|	И НЕ ЗадачаИсполнителя.Исполнитель = &Автор  
	|	И НЕ ЗадачаИсполнителя.Исполнитель = &Исполнитель";   
	Выборка = Запрос.Выполнить().Выбрать();   
	Пока Выборка.Следующий() Цикл   
		Модераторы.Добавить(Выборка.Исполнитель);   
	КонецЦикла;       
	Исполнитель = "-";  
ИначеЕсли ТекЗадача.нсиШагБП = Перечисления.нсиШагиБП.Утверждение Тогда  
	Если ТекЗадача.нсиНомерЭтапаБП = 1 Тогда  
		Сообщаем = СтрШаблон("Сообщаем Вам, что изменения по Вашей заявке внесены в справочник %1", Строка(ТекЗаявка.ВидЗаявки));  
		СтатусЗаявки = "Согласовано";  
		 
		ОтправитьМодераторам = Истина;  
		СообщаемМодераторам = СтрШаблон("Сообщаем Вам, что изменения по заявке %1 внесены в справочник %2", Строка(Автор), Строка(ТекЗаявка.ВидЗаявки));  
		 
		Запрос = Новый Запрос;   
		Запрос.УстановитьПараметр("БизнесПроцесс", ТекЗадача.БизнесПроцесс);    
		Запрос.УстановитьПараметр("Автор", Автор);  
		Запрос.Текст =    
		"ВЫБРАТЬ РАЗЛИЧНЫЕ  
		|	ЗадачаИсполнителя.Исполнитель КАК Исполнитель   
		|ИЗ   
		|	Задача.ЗадачаИсполнителя КАК ЗадачаИсполнителя   
		|ГДЕ   
		|	ЗадачаИсполнителя.БизнесПроцесс = &БизнесПроцесс  
		|	И ЗадачаИсполнителя.Выполнена  
		|	И НЕ ЗадачаИсполнителя.Исполнитель = ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)   
		|	И НЕ ЗадачаИсполнителя.Исполнитель = &Автор";   
		Выборка = Запрос.Выполнить().Выбрать();   
		Пока Выборка.Следующий() Цикл   
			Модераторы.Добавить(Выборка.Исполнитель);   
		КонецЦикла;       
	КонецЕсли;  
Иначе  
	//В остальных случаях ничего не отправляем  
	Перейти ~КонецАлгоритма;  
КонецЕсли;  
 
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
 
~КонецАлгоритма:   
 
УстановитьПривилегированныйРежим(Ложь);  

