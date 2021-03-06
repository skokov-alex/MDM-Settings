// >> 1БИТ, Скоков, 02.12.2020, Задача MDM-51
//
// Описание алгоритма:
// 		Данный алгоритм является вспомогательным. Его необходимо добавить во все
//		алгоритмы при изменении наименования, на закладку "Подчиненные алгоритмы".
// 		Вызывается при изменении реквизита Наименование в форме заявки на изменение.
//
// Настройки алгоритма:
// 		Наименование:		Изменить наименование заявки
// 		Область применения:	Произвольный алгоритм
//		После добавления данного алгоритма на закладку "Подчиненные алгоритмы",
//		В колонке "Объект обработки" необходимо указать значение Параметры.Форма
//
// Параметры передаваемые в алгоритм:
//		ОбъектОбработки		- ФормаКлиентскогоПриложения - форма.

#Область Алгоритм_изменения_наименования_заявки

ЗаявкаОбъект = ОбъектОбработки.Объект;
МассивНаименования = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(
		ЗаявкаОбъект.Наименование, ". ");

КоличествоЧастейНаименования = 3;

Если МассивНаименования.Количество() = КоличествоЧастейНаименования Тогда
	МассивНаименования[2] = ОбъектОбработки.Наименование;
	НовоеНаименование = СтрСоединить(МассивНаименования, ". ");
	ЗаявкаОбъект.Наименование = НовоеНаименование;
КонецЕсли;

#КонецОбласти
// << 1БИТ, Скоков, 02.12.2020, Задача MDM-51

