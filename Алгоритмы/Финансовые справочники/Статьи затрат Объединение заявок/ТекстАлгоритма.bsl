// >> 1БИТ, Скоков, 09.12.2020, Задача MDM-46
//
// Описание алгоритма:
// 		Алгоритм выполняет заполнение массива параметров,
//		которые необходимых для объединения заявок.
//
// Настройки алгоритма:
// 		Наименование			Статьи затрат Объединение заявок
// 		Область применения		Объединение заявок
//
// Параметры передаваемые в алгоритм:
// 		Параметры.МассивВариантовПоиска	- массив настройки поиска заявок для объединения
// 		Параметры.ЗаявкаОбъект	- БизнесПроцессОбъект.нсиЗаявкаНаИзменение - объект бизнес-процесса
// 		ОбъектОбработки			- ДанныеФормыСтруктура структуру реквизитов создаваемого элемента справочника

#Область Алгоритм_объединения_заявок_по_статьям_затрат

КлючиПоиска = Новый Структура;
КлючиПоиска.Вставить("ЭтоГруппа", ОбъектОбработки.ЭтоГруппа);
КлючиПоиска.Вставить("Наименование", ОбъектОбработки.Наименование);

МетодыСравнения = Новый Структура;
МетодыСравнения.Вставить("ЭтоГруппа", "=");
МетодыСравнения.Вставить("Наименование", "=");

Если НЕ ОбъектОбработки.ЭтоГруппа Тогда
	КлючиПоиска.Вставить("ВидРасходовНУ", ОбъектОбработки.ВидРасходовНУ);
	МетодыСравнения.Вставить("ВидРасходовНУ", "=");
КонецЕсли;

ВариантПоиска = Новый Структура;
ВариантПоиска.Вставить("КлючиПоиска", КлючиПоиска);
ВариантПоиска.Вставить("МетодыСравнения", МетодыСравнения);

Параметры.МассивВариантовПоиска.Добавить(ВариантПоиска);

#КонецОбласти
// << 1БИТ, Скоков, 09.12.2020, Задача MDM-46

