ВидЗаявкиТЧ = Параметры.Объект.пМетаданные.ТабличныеЧасти.КонтактнаяИнформация.ВидЗаявки;   
СтрокаОбогащения = Параметры.ЗаявкаОбъект.НастройкиОбновленияДанных.НайтиСтроки(новый Структура("ВидЗаявки", ВидЗаявкиТЧ));   
Если СтрокаОбогащения.Количество() = 0 Тогда    
	СтрокаОбогащения = Параметры.ЗаявкаОбъект.НастройкиОбновленияДанных.Добавить();   
	СтрокаОбогащения.ВидЗаявки = ВидЗаявкиТЧ;   
Иначе   
	СтрокаОбогащения = СтрокаОбогащения[0];   
КонецЕсли;   
СтрокаОбогащения.Обогащать = Истина;   
 
//БИТ.AKU.01.12.2020 -> 
Параметры.Объект.Заполнено_по_ЕГРЮЛ_ЕГРИП = Ложь;   
//Параметры.ИзменятьДанные = Истина;   
//Параметры.ОбновлятьОтображение = Истина; 
////<- 

